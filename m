Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06159793783
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 10:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbjIFIzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 04:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjIFIzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 04:55:46 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F981CE;
        Wed,  6 Sep 2023 01:55:42 -0700 (PDT)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4Rgbn44zsRz4wy7;
        Wed,  6 Sep 2023 18:55:36 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Rgbn05WHvz4wy3;
        Wed,  6 Sep 2023 18:55:32 +1000 (AEST)
Message-ID: <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org>
Date:   Wed, 6 Sep 2023 10:55:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker
 object
Content-Language: en-US
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com,
        'Avihai Horon' <avihaih@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
 <20220908183448.195262-8-yishaih@nvidia.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20220908183448.195262-8-yishaih@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 9/8/22 20:34, Yishai Hadas wrote:
> Add support for creating and destroying page tracker object.
> 
> This object is used to control/report the device dirty pages.
> 
> As part of creating the tracker need to consider the device capabilities
> for max ranges and adapt/combine ranges accordingly.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>   drivers/vfio/pci/mlx5/cmd.c | 147 ++++++++++++++++++++++++++++++++++++
>   drivers/vfio/pci/mlx5/cmd.h |   1 +
>   2 files changed, 148 insertions(+)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 0a362796d567..f1cad96af6ab 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -410,6 +410,148 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>   	return err;
>   }
>   
> +static void combine_ranges(struct rb_root_cached *root, u32 cur_nodes,
> +			   u32 req_nodes)
> +{
> +	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
> +	unsigned long min_gap;
> +	unsigned long curr_gap;
> +
> +	/* Special shortcut when a single range is required */
> +	if (req_nodes == 1) {
> +		unsigned long last;
> +
> +		curr = comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
> +		while (curr) {
> +			last = curr->last;
> +			prev = curr;
> +			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
> +			if (prev != comb_start)
> +				interval_tree_remove(prev, root);
> +		}
> +		comb_start->last = last;
> +		return;
> +	}
> +
> +	/* Combine ranges which have the smallest gap */
> +	while (cur_nodes > req_nodes) {
> +		prev = NULL;
> +		min_gap = ULONG_MAX;
> +		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
> +		while (curr) {
> +			if (prev) {
> +				curr_gap = curr->start - prev->last;
> +				if (curr_gap < min_gap) {
> +					min_gap = curr_gap;
> +					comb_start = prev;
> +					comb_end = curr;
> +				}
> +			}
> +			prev = curr;
> +			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
> +		}
> +		comb_start->last = comb_end->last;
> +		interval_tree_remove(comb_end, root);
> +		cur_nodes--;
> +	}
> +}
> +
> +static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
> +				 struct mlx5vf_pci_core_device *mvdev,
> +				 struct rb_root_cached *ranges, u32 nnodes)
> +{
> +	int max_num_range =
> +		MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_max_num_range);
> +	struct mlx5_vhca_page_tracker *tracker = &mvdev->tracker;
> +	int record_size = MLX5_ST_SZ_BYTES(page_track_range);
> +	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
> +	struct interval_tree_node *node = NULL;
> +	u64 total_ranges_len = 0;
> +	u32 num_ranges = nnodes;
> +	u8 log_addr_space_size;
> +	void *range_list_ptr;
> +	void *obj_context;
> +	void *cmd_hdr;
> +	int inlen;
> +	void *in;
> +	int err;
> +	int i;
> +
> +	if (num_ranges > max_num_range) {
> +		combine_ranges(ranges, nnodes, max_num_range);
> +		num_ranges = max_num_range;
> +	}
> +
> +	inlen = MLX5_ST_SZ_BYTES(create_page_track_obj_in) +
> +				 record_size * num_ranges;
> +	in = kzalloc(inlen, GFP_KERNEL);
> +	if (!in)
> +		return -ENOMEM;
> +
> +	cmd_hdr = MLX5_ADDR_OF(create_page_track_obj_in, in,
> +			       general_obj_in_cmd_hdr);
> +	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode,
> +		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
> +	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type,
> +		 MLX5_OBJ_TYPE_PAGE_TRACK);
> +	obj_context = MLX5_ADDR_OF(create_page_track_obj_in, in, obj_context);
> +	MLX5_SET(page_track, obj_context, vhca_id, mvdev->vhca_id);
> +	MLX5_SET(page_track, obj_context, track_type, 1);
> +	MLX5_SET(page_track, obj_context, log_page_size,
> +		 ilog2(tracker->host_qp->tracked_page_size));
> +	MLX5_SET(page_track, obj_context, log_msg_size,
> +		 ilog2(tracker->host_qp->max_msg_size));
> +	MLX5_SET(page_track, obj_context, reporting_qpn, tracker->fw_qp->qpn);
> +	MLX5_SET(page_track, obj_context, num_ranges, num_ranges);
> +
> +	range_list_ptr = MLX5_ADDR_OF(page_track, obj_context, track_range);
> +	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
> +	for (i = 0; i < num_ranges; i++) {
> +		void *addr_range_i_base = range_list_ptr + record_size * i;
> +		unsigned long length = node->last - node->start;
> +
> +		MLX5_SET64(page_track_range, addr_range_i_base, start_address,
> +			   node->start);
> +		MLX5_SET64(page_track_range, addr_range_i_base, length, length);
> +		total_ranges_len += length;
> +		node = interval_tree_iter_next(node, 0, ULONG_MAX);
> +	}
> +
> +	WARN_ON(node);
> +	log_addr_space_size = ilog2(total_ranges_len);
> +	if (log_addr_space_size <
> +	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
> +	    log_addr_space_size >
> +	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_addr_space))) {
> +		err = -EOPNOTSUPP;
> +		goto out;
> +	}


We are seeing an issue with dirty page tracking when doing migration
of an OVMF VM guest. The vfio-pci variant driver for the MLX5 VF
device complains when dirty page tracking is initialized from QEMU :

   qemu-kvm: 0000:b1:00.2: Failed to start DMA logging, err -95 (Operation not supported)

The 64-bit computed range is  :

   vfio_device_dirty_tracking_start nr_ranges 2 32:[0x0 - 0x807fffff], 64:[0x100000000 - 0x3838000fffff]

which seems to be too large for the HW. AFAICT, the MLX5 HW has a 42
bits address space limitation for dirty tracking (min is 12). Is it a
FW tunable or a strict limitation ?

We should probably introduce more ranges to overcome the issue.

Thanks,

C.


> +	MLX5_SET(page_track, obj_context, log_addr_space_size,
> +		 log_addr_space_size);
> +	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
> +	if (err)
> +		goto out;
> +
> +	tracker->id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
> +out:
> +	kfree(in);
> +	return err;
> +}
> +
> +static int mlx5vf_cmd_destroy_tracker(struct mlx5_core_dev *mdev,
> +				      u32 tracker_id)
> +{
> +	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
> +	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
> +
> +	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
> +	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_PAGE_TRACK);
> +	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, tracker_id);
> +
> +	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
> +}
> +
>   static int alloc_cq_frag_buf(struct mlx5_core_dev *mdev,
>   			     struct mlx5_vhca_cq_buf *buf, int nent,
>   			     int cqe_size)
> @@ -833,6 +975,7 @@ _mlx5vf_free_page_tracker_resources(struct mlx5vf_pci_core_device *mvdev)
>   
>   	WARN_ON(mvdev->mdev_detach);
>   
> +	mlx5vf_cmd_destroy_tracker(mdev, tracker->id);
>   	mlx5vf_destroy_qp(mdev, tracker->fw_qp);
>   	mlx5vf_free_qp_recv_resources(mdev, tracker->host_qp);
>   	mlx5vf_destroy_qp(mdev, tracker->host_qp);
> @@ -941,6 +1084,10 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
>   
>   	tracker->host_qp = host_qp;
>   	tracker->fw_qp = fw_qp;
> +	err = mlx5vf_create_tracker(mdev, mvdev, ranges, nnodes);
> +	if (err)
> +		goto err_activate;
> +
>   	*page_size = host_qp->tracked_page_size;
>   	mvdev->log_active = true;
>   	mlx5vf_state_mutex_unlock(mvdev);
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index e71ec017bf04..658925ba5459 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -80,6 +80,7 @@ struct mlx5_vhca_qp {
>   };
>   
>   struct mlx5_vhca_page_tracker {
> +	u32 id;
>   	u32 pdn;
>   	struct mlx5_uars_page *uar;
>   	struct mlx5_vhca_cq cq;

