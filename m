Return-Path: <kvm+bounces-2784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4497FDE08
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 18:12:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 182E01C20D6E
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 17:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAEF46B99;
	Wed, 29 Nov 2023 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTJrz2/B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3EB3B2BB;
	Wed, 29 Nov 2023 17:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FE7C433C9;
	Wed, 29 Nov 2023 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701277949;
	bh=cvu+1+jIJZ1kJKi0LvpvP5t3dupRwijJyikjtLVPy2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TTJrz2/BtIJSe8hRoEUBtL308u/wXHime/r5OkYzx++/eRMGIerSmBtYd6+fik4rJ
	 YYFVMmhLWoIYGpF4uzQYVT8e+zqf3qqoDYbnWT8kWS5ZgdES8EEa//bFIJYC5N6IOG
	 v6pSWYMQWRR5qQyx2GGRa8zK9O0xwYrZhsZbJNWz/l/40wkzWK0EfrUiGGGUMacm2u
	 G++eb0AoIvZ+OTh2ah4JXNmTLAaqND/djnVFeSKNA5Otq6MfynF1aGT8BDQORkEO2T
	 cn7RcJnUDaJNLEHveS5BfGw+sCuB5I146NwneUzLfUNGt8V38sMiF+2FlJM6DsN+3A
	 Tl6sGUGLIwiVA==
Date: Wed, 29 Nov 2023 17:12:22 +0000
From: Simon Horman <horms@kernel.org>
To: Yahui Cao <yahui.cao@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, kvm@vger.kernel.org,
	netdev@vger.kernel.org, lingyu.liu@intel.com, kevin.tian@intel.com,
	madhu.chittim@intel.com, sridhar.samudrala@intel.com,
	alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, brett.creeley@amd.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com
Subject: Re: [PATCH iwl-next v4 05/12] ice: Log virtual channel messages in PF
Message-ID: <20231129171222.GF43811@kernel.org>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-6-yahui.cao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121025111.257597-6-yahui.cao@intel.com>

On Tue, Nov 21, 2023 at 02:51:04AM +0000, Yahui Cao wrote:
> From: Lingyu Liu <lingyu.liu@intel.com>
> 
> Save the virtual channel messages sent by VF on the source side during
> runtime. The logged virtchnl messages will be transferred and loaded
> into the device on the destination side during the device resume stage.
> 
> For the feature which can not be migrated yet, it must be disabled or
> blocked to prevent from being abused by VF. Otherwise, it may introduce
> functional and security issue. Mask unsupported VF capability flags in
> the VF-PF negotiaion stage.
> 
> Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>

Hi Lingyu Liu and Yahui Cao,

some minor feedback from my side.

...

> diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c

...

> +/**
> + * ice_migration_log_vf_msg - Log request message from VF
> + * @vf: pointer to the VF structure
> + * @event: pointer to the AQ event
> + *
> + * Log VF message for later device state loading during live migration
> + *
> + * Return 0 for success, negative for error
> + */
> +int ice_migration_log_vf_msg(struct ice_vf *vf,
> +			     struct ice_rq_event_info *event)
> +{
> +	struct ice_migration_virtchnl_msg_listnode *msg_listnode;
> +	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
> +	struct device *dev = ice_pf_to_dev(vf->pf);
> +	u16 msglen = event->msg_len;
> +	u8 *msg = event->msg_buf;
> +
> +	if (!ice_migration_is_loggable_msg(v_opcode))
> +		return 0;
> +
> +	if (vf->virtchnl_msg_num >= VIRTCHNL_MSG_MAX) {
> +		dev_warn(dev, "VF %d has maximum number virtual channel commands\n",
> +			 vf->vf_id);
> +		return -ENOMEM;
> +	}
> +
> +	msg_listnode = (struct ice_migration_virtchnl_msg_listnode *)
> +			kzalloc(struct_size(msg_listnode,
> +					    msg_slot.msg_buffer,
> +					    msglen),
> +				GFP_KERNEL);

nit: there is no need to cast the void * pointer returned by kzalloc().

Flagged by Coccinelle.

> +	if (!msg_listnode) {
> +		dev_err(dev, "VF %d failed to allocate memory for msg listnode\n",
> +			vf->vf_id);
> +		return -ENOMEM;
> +	}
> +	dev_dbg(dev, "VF %d save virtual channel command, op code: %d, len: %d\n",
> +		vf->vf_id, v_opcode, msglen);
> +	msg_listnode->msg_slot.opcode = v_opcode;
> +	msg_listnode->msg_slot.msg_len = msglen;
> +	memcpy(msg_listnode->msg_slot.msg_buffer, msg, msglen);
> +	list_add_tail(&msg_listnode->node, &vf->virtchnl_msg_list);
> +	vf->virtchnl_msg_num++;
> +	vf->virtchnl_msg_size += struct_size(&msg_listnode->msg_slot,
> +					     msg_buffer,
> +					     msglen);
> +	return 0;
> +}
> +
> +/**
> + * ice_migration_unlog_vf_msg - revert logged message
> + * @vf: pointer to the VF structure
> + * @v_opcode: virtchnl message operation code
> + *
> + * Remove the last virtual channel message logged before.
> + */
> +void ice_migration_unlog_vf_msg(struct ice_vf *vf, u32 v_opcode)
> +{
> +	struct ice_migration_virtchnl_msg_listnode *msg_listnode;
> +
> +	if (!ice_migration_is_loggable_msg(v_opcode))
> +		return;
> +
> +	if (WARN_ON_ONCE(list_empty(&vf->virtchnl_msg_list)))
> +		return;
> +
> +	msg_listnode =
> +		list_last_entry(&vf->virtchnl_msg_list,
> +				struct ice_migration_virtchnl_msg_listnode,
> +				node);
> +	if (WARN_ON_ONCE(msg_listnode->msg_slot.opcode != v_opcode))
> +		return;
> +
> +	list_del(&msg_listnode->node);
> +	kfree(msg_listnode);

msg_listnode is freed on the line above,
but dereferenced in the usage of struct_size() below.

As flagged by Smatch and Coccinelle.

> +	vf->virtchnl_msg_num--;
> +	vf->virtchnl_msg_size -= struct_size(&msg_listnode->msg_slot,
> +					     msg_buffer,
> +					     msg_listnode->msg_slot.msg_len);
> +}

...

