Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7777830A79C
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhBAM1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:27:43 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11652 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhBAM11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 07:27:27 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DTnGG4rnkz162kv;
        Mon,  1 Feb 2021 20:25:26 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 1 Feb 2021 20:26:41 +0800
Subject: Re: [PATCH v13 03/15] iommu/arm-smmu-v3: Maintain a SID->device
 structure
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <will@kernel.org>, <joro@8bytes.org>, <maz@kernel.org>,
        <robin.murphy@arm.com>, <alex.williamson@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-4-eric.auger@redhat.com>
CC:     <jean-philippe@linaro.org>, <jacob.jun.pan@linux.intel.com>,
        <nicoleotsuka@gmail.com>, <vivek.gautam@arm.com>,
        <yi.l.liu@intel.com>, <zhangfei.gao@linaro.org>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <a5cc1635-b69b-50a6-404a-5bf667296669@huawei.com>
Date:   Mon, 1 Feb 2021 20:26:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20201118112151.25412-4-eric.auger@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/11/18 19:21, Eric Auger wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> When handling faults from the event or PRI queue, we need to find the
> struct device associated to a SID. Add a rb_tree to keep track of SIDs.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
[...]

>  }
>  
> +static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
> +				  struct arm_smmu_master *master)
> +{
> +	int i;
> +	int ret = 0;
> +	struct arm_smmu_stream *new_stream, *cur_stream;
> +	struct rb_node **new_node, *parent_node = NULL;
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
> +
> +	master->streams = kcalloc(fwspec->num_ids,
> +				  sizeof(struct arm_smmu_stream), GFP_KERNEL);
> +	if (!master->streams)
> +		return -ENOMEM;
> +	master->num_streams = fwspec->num_ids;
This is not roll-backed when fail.

> +
> +	mutex_lock(&smmu->streams_mutex);
> +	for (i = 0; i < fwspec->num_ids && !ret; i++) {
Check ret at here, makes it hard to decide the start index of rollback.

If we fail at here, then start index is (i-2).
If we fail in the loop, then start index is (i-1).

> +		u32 sid = fwspec->ids[i];
> +
> +		new_stream = &master->streams[i];
> +		new_stream->id = sid;
> +		new_stream->master = master;
> +
> +		/*
> +		 * Check the SIDs are in range of the SMMU and our stream table
> +		 */
> +		if (!arm_smmu_sid_in_range(smmu, sid)) {
> +			ret = -ERANGE;
> +			break;
> +		}
> +
> +		/* Ensure l2 strtab is initialised */
> +		if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
> +			ret = arm_smmu_init_l2_strtab(smmu, sid);
> +			if (ret)
> +				break;
> +		}
> +
> +		/* Insert into SID tree */
> +		new_node = &(smmu->streams.rb_node);
> +		while (*new_node) {
> +			cur_stream = rb_entry(*new_node, struct arm_smmu_stream,
> +					      node);
> +			parent_node = *new_node;
> +			if (cur_stream->id > new_stream->id) {
> +				new_node = &((*new_node)->rb_left);
> +			} else if (cur_stream->id < new_stream->id) {
> +				new_node = &((*new_node)->rb_right);
> +			} else {
> +				dev_warn(master->dev,
> +					 "stream %u already in tree\n",
> +					 cur_stream->id);
> +				ret = -EINVAL;
> +				break;
> +			}
> +		}
> +
> +		if (!ret) {
> +			rb_link_node(&new_stream->node, parent_node, new_node);
> +			rb_insert_color(&new_stream->node, &smmu->streams);
> +		}
> +	}
> +
> +	if (ret) {
> +		for (; i > 0; i--)
should be (i >= 0)?
And the start index seems not correct.

> +			rb_erase(&master->streams[i].node, &smmu->streams);
> +		kfree(master->streams);
> +	}
> +	mutex_unlock(&smmu->streams_mutex);
> +
> +	return ret;
> +}
> +
> +static void arm_smmu_remove_master(struct arm_smmu_master *master)
> +{
> +	int i;
> +	struct arm_smmu_device *smmu = master->smmu;
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
> +
> +	if (!smmu || !master->streams)
> +		return;
> +
> +	mutex_lock(&smmu->streams_mutex);
> +	for (i = 0; i < fwspec->num_ids; i++)
> +		rb_erase(&master->streams[i].node, &smmu->streams);
> +	mutex_unlock(&smmu->streams_mutex);
> +
> +	kfree(master->streams);
> +}
> +
>  static struct iommu_ops arm_smmu_ops;
>  
>  static struct iommu_device *arm_smmu_probe_device(struct device *dev)
>  {
> -	int i, ret;
> +	int ret;
>  	struct arm_smmu_device *smmu;
>  	struct arm_smmu_master *master;
>  	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> @@ -2331,27 +2447,12 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
>  
>  	master->dev = dev;
>  	master->smmu = smmu;
> -	master->sids = fwspec->ids;
> -	master->num_sids = fwspec->num_ids;
>  	INIT_LIST_HEAD(&master->bonds);
>  	dev_iommu_priv_set(dev, master);
>  
> -	/* Check the SIDs are in range of the SMMU and our stream table */
> -	for (i = 0; i < master->num_sids; i++) {
> -		u32 sid = master->sids[i];
> -
> -		if (!arm_smmu_sid_in_range(smmu, sid)) {
> -			ret = -ERANGE;
> -			goto err_free_master;
> -		}
> -
> -		/* Ensure l2 strtab is initialised */
> -		if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
> -			ret = arm_smmu_init_l2_strtab(smmu, sid);
> -			if (ret)
> -				goto err_free_master;
> -		}
> -	}
> +	ret = arm_smmu_insert_master(smmu, master);
> +	if (ret)
> +		goto err_free_master;
>  
>  	master->ssid_bits = min(smmu->ssid_bits, fwspec->num_pasid_bits);
>  
> @@ -2389,6 +2490,7 @@ static void arm_smmu_release_device(struct device *dev)
>  	WARN_ON(arm_smmu_master_sva_enabled(master));
>  	arm_smmu_detach_dev(master);
>  	arm_smmu_disable_pasid(master);
> +	arm_smmu_remove_master(master);
>  	kfree(master);

Thanks,
Keqian
