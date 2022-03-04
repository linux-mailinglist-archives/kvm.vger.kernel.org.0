Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBDA4CD276
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiCDKfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiCDKfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:35:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79929EA764
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646390090;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KRt/1YOotxk5NR8Y7CjRRb4zuwpYyvXvnhun3VZ9oQ=;
        b=NXw5s0G4HZ0icWdZUBaHApCf+AHsLFw70Qe18jgQNoHGkrIz/gNzsaiFMXzZ5hzL6cYUo2
        1ICyn553kd4kAB+XvJLyOz4slvGslqlWIrrlXAuMQspBf9EJcGgQuZDbD/XdNutwVX752Q
        ubSJQBx2+JCKU7r9wktlVVe/P3ZnqsI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-TzxOjqf8OcKFYLYod2p1ww-1; Fri, 04 Mar 2022 05:34:49 -0500
X-MC-Unique: TzxOjqf8OcKFYLYod2p1ww-1
Received: by mail-wm1-f71.google.com with SMTP id 10-20020a1c020a000000b0037fae68fcc2so4005472wmc.8
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 02:34:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=3KRt/1YOotxk5NR8Y7CjRRb4zuwpYyvXvnhun3VZ9oQ=;
        b=P6YSEPGMh75E1Mj835Z9xtC42NYKiFmlFuqAkLjiXoZ+VaODjfxOA9e7or1DDPMEUj
         nhoXjV17oe+iNLYlx5rAiICpal3hiUfStTwtEYE7k+lC07NKEtlTDDfyAw1rEgHdgakd
         mZqCWuv1NomYAgisO1kkGZBHI7mcsIuWKrnmJ9Owjepd0AEGFSr3odwHpVg9WKkGZ4z+
         55hTBL0ufqK6PlqXxDjXaRqUid3dT7c21HdXj+71h7xhM/cKcvweQbyCqs0l+7E+slk4
         xy4ACiKItKZ3GlOvo49WRhse9D/NwMJtkTRfgDFssrcU6TatIAZc+J33Qu7Vc1SaH/8W
         b8lg==
X-Gm-Message-State: AOAM5338D9mU6pbxsdyn3ZT4KiJfIgYcuz6Ck7qobz+OqwiWAF3fvItT
        EXMZ8JnYyxla3CqbtiwiT5jIDym74IZ501GytgHEl4T7OevIrf5bTDU7va2Lkdk/vGInR2s/Q5/
        nZWqHLZWS6PTz
X-Received: by 2002:a05:6000:1684:b0:1f0:63de:79c5 with SMTP id y4-20020a056000168400b001f063de79c5mr3564548wrd.654.1646390088291;
        Fri, 04 Mar 2022 02:34:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyzr5ioiS3zM4eOLG7A9xe9Umq/3U0LLXJSRBegVTD5U8Z4Z6y+udEJZk83cj7xzuy7hkaIA==
X-Received: by 2002:a05:6000:1684:b0:1f0:63de:79c5 with SMTP id y4-20020a056000168400b001f063de79c5mr3564500wrd.654.1646390087887;
        Fri, 04 Mar 2022 02:34:47 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l12-20020a5d6d8c000000b001efd2c071dbsm4454462wrs.20.2022.03.04.02.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 02:34:47 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v7 01/11] iommu: Add DMA ownership management interfaces
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220228005056.599595-1-baolu.lu@linux.intel.com>
 <20220228005056.599595-2-baolu.lu@linux.intel.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <c75b6e04-bc1b-b9f6-1a44-bf1567a8c19d@redhat.com>
Date:   Fri, 4 Mar 2022 11:34:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220228005056.599595-2-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Lu,

On 2/28/22 1:50 AM, Lu Baolu wrote:
> Multiple devices may be placed in the same IOMMU group because they
> cannot be isolated from each other. These devices must either be
> entirely under kernel control or userspace control, never a mixture.
>
> This adds dma ownership management in iommu core and exposes several
> interfaces for the device drivers and the device userspace assignment
> framework (i.e. VFIO), so that any conflict between user and kernel
> controlled dma could be detected at the beginning.
>
> The device driver oriented interfaces are,
>
> 	int iommu_device_use_default_domain(struct device *dev);
> 	void iommu_device_unuse_default_domain(struct device *dev);
>
> By calling iommu_device_use_default_domain(), the device driver tells
> the iommu layer that the device dma is handled through the kernel DMA
> APIs. The iommu layer will manage the IOVA and use the default domain
> for DMA address translation.
>
> The device user-space assignment framework oriented interfaces are,
>
> 	int iommu_group_claim_dma_owner(struct iommu_group *group,
> 					void *owner);
> 	void iommu_group_release_dma_owner(struct iommu_group *group);
> 	bool iommu_group_dma_owner_claimed(struct iommu_group *group);
>
> The device userspace assignment must be disallowed if the DMA owner
> claiming interface returns failure.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h |  31 +++++++++
>  drivers/iommu/iommu.c | 153 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 181 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 9208eca4b0d1..77972ef978b5 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -675,6 +675,13 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
>  void iommu_sva_unbind_device(struct iommu_sva *handle);
>  u32 iommu_sva_get_pasid(struct iommu_sva *handle);
>  
> +int iommu_device_use_default_domain(struct device *dev);
> +void iommu_device_unuse_default_domain(struct device *dev);
> +
> +int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner);
> +void iommu_group_release_dma_owner(struct iommu_group *group);
> +bool iommu_group_dma_owner_claimed(struct iommu_group *group);
> +
>  #else /* CONFIG_IOMMU_API */
>  
>  struct iommu_ops {};
> @@ -1031,6 +1038,30 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
>  {
>  	return NULL;
>  }
> +
> +static inline int iommu_device_use_default_domain(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static inline void iommu_device_unuse_default_domain(struct device *dev)
> +{
> +}
> +
> +static inline int
> +iommu_group_claim_dma_owner(struct iommu_group *group, void *owner)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline void iommu_group_release_dma_owner(struct iommu_group *group)
> +{
> +}
> +
> +static inline bool iommu_group_dma_owner_claimed(struct iommu_group *group)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_IOMMU_API */
>  
>  /**
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index f2c45b85b9fc..eba8e8ccf19d 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -48,6 +48,8 @@ struct iommu_group {
>  	struct iommu_domain *default_domain;
>  	struct iommu_domain *domain;
>  	struct list_head entry;
> +	unsigned int owner_cnt;
> +	void *owner;
>  };
>  
>  struct group_device {
> @@ -294,7 +296,11 @@ int iommu_probe_device(struct device *dev)
>  	mutex_lock(&group->mutex);
>  	iommu_alloc_default_domain(group, dev);
>  
> -	if (group->default_domain) {
> +	/*
> +	 * If device joined an existing group which has been claimed, don't
> +	 * attach the default domain.
> +	 */
> +	if (group->default_domain && !group->owner) {
>  		ret = __iommu_attach_device(group->default_domain, dev);
>  		if (ret) {
>  			mutex_unlock(&group->mutex);
> @@ -2109,7 +2115,7 @@ static int __iommu_attach_group(struct iommu_domain *domain,
>  {
>  	int ret;
>  
> -	if (group->default_domain && group->domain != group->default_domain)
> +	if (group->domain && group->domain != group->default_domain)
>  		return -EBUSY;
>  
>  	ret = __iommu_group_for_each_dev(group, domain,
> @@ -2146,7 +2152,11 @@ static void __iommu_detach_group(struct iommu_domain *domain,
>  {
>  	int ret;
>  
> -	if (!group->default_domain) {
> +	/*
> +	 * If the group has been claimed already, do not re-attach the default
> +	 * domain.
> +	 */
> +	if (!group->default_domain || group->owner) {
>  		__iommu_group_for_each_dev(group, domain,
>  					   iommu_group_do_detach_device);
>  		group->domain = NULL;
> @@ -3095,3 +3105,140 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
>  
>  	return ret;
>  }
> +
> +/**
> + * iommu_device_use_default_domain() - Device driver wants to handle device
> + *                                     DMA through the kernel DMA API.
> + * @dev: The device.
> + *
> + * The device driver about to bind @dev wants to do DMA through the kernel
> + * DMA API. Return 0 if it is allowed, otherwise an error.
> + */
> +int iommu_device_use_default_domain(struct device *dev)
> +{
> +	struct iommu_group *group = iommu_group_get(dev);
> +	int ret = 0;
> +
> +	if (!group)
> +		return 0;
I hit a WARN_ON() when unbinding an e1000e driver just after boot:

sudo modprobe -v vfio-pci
echo vfio-pci | sudo tee -a
/sys/bus/pci/devices/0004:01:00.0/driver_override
vfio-pci
echo 0004:01:00.0 | sudo tee -a  /sys/bus/pci/drivers/e1000e/unbind


[  390.042811] ------------[ cut here ]------------
[  390.046468] WARNING: CPU: 42 PID: 5589 at drivers/iommu/iommu.c:3123
iommu_device_unuse_default_domain+0x68/0x100
[  390.056710] Modules linked in: vfio_pci vfio_pci_core vfio_virqfd
vfio_iommu_type1 vfio xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT
nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink bridge stp llc rfkill
sunrpc vfat fat mlx5_ib ib_uverbs ib_core acpi_ipmi ipmi_ssif
ipmi_devintf ipmi_msghandler cppc_cpufreq drm xfs libcrc32c mlx5_core sg
mlxfw crct10dif_ce tls ghash_ce sha2_ce sha256_arm64 sha1_ce sbsa_gwdt
e1000e psample sdhci_acpi ahci_platform sdhci libahci_platform qcom_emac
mmc_core hdma hdma_mgmt dm_mirror dm_region_hash dm_log dm_mod fuse
[  390.110618] CPU: 42 PID: 5589 Comm: tee Kdump: loaded Not tainted
5.17.0-rc4-lu-v7-official+ #24
[  390.119384] Hardware name: WIWYNN QDF2400 Reference Evaluation
Platform CV90-LA115-P120/QDF2400 Customer Reference Board, BIOS 0ACJA570
11/05/2018
[  390.132492] pstate: a0400005 (NzCv daif +PAN -UAO -TCO -DIT -SSBS
BTYPE=--)
[  390.139436] pc : iommu_device_unuse_default_domain+0x68/0x100
[  390.145165] lr : iommu_device_unuse_default_domain+0x38/0x100
[  390.150894] sp : ffff80000fbb3bc0
[  390.154193] x29: ffff80000fbb3bc0 x28: ffff03c0cf6b2400 x27:
0000000000000000
[  390.161311] x26: 0000000000000000 x25: 0000000000000000 x24:
ffff03c0c7cc5720
[  390.168429] x23: ffff03c0c2b9d150 x22: ffffb4e61df223f8 x21:
ffffb4e61df223f8
[  390.175547] x20: ffff03c7c03c3758 x19: ffff03c7c03c3700 x18:
0000000000000000
[  390.182665] x17: 0000000000000000 x16: 0000000000000000 x15:
0000000000000000
[  390.189783] x14: 0000000000000000 x13: 0000000000000030 x12:
ffff03c0d519cd80
[  390.196901] x11: 7f7f7f7f7f7f7f7f x10: 0000000000000dc0 x9 :
ffffb4e620b54f8c
[  390.204019] x8 : ffff03c0cf6b3220 x7 : ffff4ef132bba000 x6 :
00000000000000ff
[  390.211137] x5 : ffff03c0c2b9f108 x4 : ffff03c0d51f6438 x3 :
0000000000000000
[  390.218255] x2 : ffff03c0cf6b2400 x1 : 0000000000000000 x0 :
0000000000000000
[  390.225374] Call trace:
[  390.227804]  iommu_device_unuse_default_domain+0x68/0x100
[  390.233187]  pci_dma_cleanup+0x38/0x44
[  390.236919]  __device_release_driver+0x1a8/0x260
[  390.241519]  device_driver_detach+0x50/0xd0
[  390.245686]  unbind_store+0xf8/0x120
[  390.249245]  drv_attr_store+0x30/0x44
[  390.252891]  sysfs_kf_write+0x50/0x60
[  390.256537]  kernfs_fop_write_iter+0x134/0x1cc
[  390.260964]  new_sync_write+0xf0/0x18c
[  390.264696]  vfs_write+0x230/0x2d0
[  390.268082]  ksys_write+0x74/0x100
[  390.271467]  __arm64_sys_write+0x28/0x3c
[  390.275373]  invoke_syscall.constprop.0+0x58/0xf0
[  390.280061]  el0_svc_common.constprop.0+0x160/0x164
[  390.284922]  do_el0_svc+0x34/0xcc
[  390.288221]  el0_svc+0x30/0x140
[  390.291346]  el0t_64_sync_handler+0xa4/0x130
[  390.295599]  el0t_64_sync+0x1a0/0x1a4
[  390.299245] ---[ end trace 0000000000000000 ]---


I put some traces in the code and I can see that iommu_device_use_default_domain() effectively is called on 0004:01:00.0 e1000e device on pci_dma_configure() but at that time the iommu group is NULL:
[   10.569427] e1000e 0004:01:00.0: ------ ENTRY pci_dma_configure driver_managed_area=0
[   10.569431] e1000e 0004:01:00.0: **** iommu_device_use_default_domain ENTRY
[   10.569433] e1000e 0004:01:00.0: **** iommu_device_use_default_domain no group
[   10.569435] e1000e 0004:01:00.0: pci_dma_configure iommu_device_use_default_domain returned 0
[   10.569492] e1000e 0004:01:00.0: Adding to iommu group 3

^^^the group is added after the 
iommu_device_use_default_domain() call
So the group->owner_cnt is not incremented as expected.

Thanks

Eric

> +
> +	mutex_lock(&group->mutex);
> +	if (group->owner_cnt) {
> +		if (group->domain != group->default_domain ||
> +		    group->owner) {
> +			ret = -EBUSY;
> +			goto unlock_out;
> +		}
> +	}
> +
> +	group->owner_cnt++;
> +
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +	iommu_group_put(group);
> +
> +	return ret;
> +}
> +
> +/**
> + * iommu_device_unuse_default_domain() - Device driver stops handling device
> + *                                       DMA through the kernel DMA API.
> + * @dev: The device.
> + *
> + * The device driver doesn't want to do DMA through kernel DMA API anymore.
> + * It must be called after iommu_device_use_default_domain().
> + */
> +void iommu_device_unuse_default_domain(struct device *dev)
> +{
> +	struct iommu_group *group = iommu_group_get(dev);
> +
> +	if (!group)
> +		return;
> +
> +	mutex_lock(&group->mutex);
> +	if (!WARN_ON(!group->owner_cnt))
> +		group->owner_cnt--;
> +
> +	mutex_unlock(&group->mutex);
> +	iommu_group_put(group);
> +}
> +
> +/**
> + * iommu_group_claim_dma_owner() - Set DMA ownership of a group
> + * @group: The group.
> + * @owner: Caller specified pointer. Used for exclusive ownership.
> + *
> + * This is to support backward compatibility for vfio which manages
> + * the dma ownership in iommu_group level. New invocations on this
> + * interface should be prohibited.
> + */
> +int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&group->mutex);
> +	if (group->owner_cnt) {
> +		ret = -EPERM;
> +		goto unlock_out;
> +	} else {
> +		if (group->domain && group->domain != group->default_domain) {
> +			ret = -EBUSY;
> +			goto unlock_out;
> +		}
> +
> +		group->owner = owner;
> +		if (group->domain)
> +			__iommu_detach_group(group->domain, group);
> +	}
> +
> +	group->owner_cnt++;
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_claim_dma_owner);
> +
> +/**
> + * iommu_group_release_dma_owner() - Release DMA ownership of a group
> + * @group: The group.
> + *
> + * Release the DMA ownership claimed by iommu_group_claim_dma_owner().
> + */
> +void iommu_group_release_dma_owner(struct iommu_group *group)
> +{
> +	mutex_lock(&group->mutex);
> +	if (WARN_ON(!group->owner_cnt || !group->owner))
> +		goto unlock_out;
> +
> +	group->owner_cnt = 0;
> +	/*
> +	 * The UNMANAGED domain should be detached before all USER
> +	 * owners have been released.
> +	 */
> +	if (!WARN_ON(group->domain) && group->default_domain)
> +		__iommu_attach_group(group->default_domain, group);
> +	group->owner = NULL;
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_release_dma_owner);
> +
> +/**
> + * iommu_group_dma_owner_claimed() - Query group dma ownership status
> + * @group: The group.
> + *
> + * This provides status query on a given group. It is racy and only for
> + * non-binding status reporting.
> + */
> +bool iommu_group_dma_owner_claimed(struct iommu_group *group)
> +{
> +	unsigned int user;
> +
> +	mutex_lock(&group->mutex);
> +	user = group->owner_cnt;
> +	mutex_unlock(&group->mutex);
> +
> +	return user;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);

