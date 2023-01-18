Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94DD67237A
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjARQgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjARQgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:36:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A746312F29
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674059646;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dzZjYf/Zgp8mUSnEq60pUAfB2U4N4I6FmDwK70OZvNg=;
        b=ap6cOoKi/uW7FX3g/ZVm6uZRDUEf7kTmd5tDnuqhW3frTPt777PKefCCAf9yolSEXr4kyS
        9glKd4PUMcrLxnnHJeKIZ+TGie/MuHGrTSo2C02KwZGatCV9fmg4fpRz8Zt2Vv8kw0vFVP
        YIKFq4KG1qgqsWszKBWmRshPZYoLe+Q=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-1xXGy66MPHmGOxdptgYdoA-1; Wed, 18 Jan 2023 11:34:02 -0500
X-MC-Unique: 1xXGy66MPHmGOxdptgYdoA-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-4ea88f2f57aso98937097b3.20
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:34:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dzZjYf/Zgp8mUSnEq60pUAfB2U4N4I6FmDwK70OZvNg=;
        b=HyZnuqR2vwW/soy1+igXM7xwJsCPrZPpCeheyi20O/F4g/tQGFpTPQNnnl0TwsczmL
         hS49suyjW6In9nU7TZYevElz+nHgXiRuoIYaAB6hL+DjcDD7Tx7gTQHq9AqbdtkYya1h
         no61DLy1cLfylxwcBPV3c/L5v4uAhbJKzG2+VVosldpkrDU9GzQ9tu6sjcLzMpeZvjTm
         hsMQ5sYTN72XF9Uz/wPQpFPst9mMXeh0zclW0HvEWL3sxAJkKUXKtLeuuIoo9W0ZnpAT
         h7mWA4vS1S7bkg2CvsxBArZ3amLAlRha1PRyDkD+nrx7D5m5hIoDUImq97cc89FzG2ty
         GMNw==
X-Gm-Message-State: AFqh2konuYc99IZHqDM3jgbXHySYkgOE0jTgZiZQeMjnErDs8HZA50/n
        1hC2N8eVsX8vMZkmRDxcPvQcuYtNk8PmVJw7n1rj5aE8TFFoFKrqSKX/lRBea18cCdtAo0XNpoY
        EPl0AfrzBgxOb
X-Received: by 2002:a05:7500:1c4b:b0:eb:74c:50f6 with SMTP id dz11-20020a0575001c4b00b000eb074c50f6mr518225gab.44.1674059639668;
        Wed, 18 Jan 2023 08:33:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvtKqTfiuAzmzK0mxedl9ZRmPxu/KvP9zPV8xWWTmzrejRSDzcYGnVIAXDQQPCEpBb3aVsXbw==
X-Received: by 2002:a05:7500:1c4b:b0:eb:74c:50f6 with SMTP id dz11-20020a0575001c4b00b000eb074c50f6mr518199gab.44.1674059639194;
        Wed, 18 Jan 2023 08:33:59 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id u8-20020a05620a430800b006b615cd8c13sm22755908qko.106.2023.01.18.08.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 08:33:58 -0800 (PST)
Message-ID: <ee3a5edb-6542-77e2-48e1-6fa5fbbf1c98@redhat.com>
Date:   Wed, 18 Jan 2023 17:33:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 04/13] kvm/vfio: Rename kvm_vfio_group to prepare for
 accepting vfio device fd
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-5-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117134942.101112-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/17/23 14:49, Yi Liu wrote:
> Meanwhile, rename related helpers. No functional change is intended.
>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  virt/kvm/vfio.c | 115 ++++++++++++++++++++++++------------------------
>  1 file changed, 58 insertions(+), 57 deletions(-)
>
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 868930c7a59b..0f54b9d308d7 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -21,7 +21,7 @@
>  #include <asm/kvm_ppc.h>
>  #endif
>  
> -struct kvm_vfio_group {
> +struct kvm_vfio_file {
>  	struct list_head node;
>  	struct file *file;
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> @@ -30,7 +30,7 @@ struct kvm_vfio_group {
>  };
>  
>  struct kvm_vfio {
> -	struct list_head group_list;
> +	struct list_head file_list;
>  	struct mutex lock;
>  	bool noncoherent;
>  };
> @@ -98,34 +98,35 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>  }
>  
>  static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
> -					     struct kvm_vfio_group *kvg)
> +					     struct kvm_vfio_file *kvf)
>  {
> -	if (WARN_ON_ONCE(!kvg->iommu_group))
> +	if (WARN_ON_ONCE(!kvf->iommu_group))
>  		return;
>  
> -	kvm_spapr_tce_release_iommu_group(kvm, kvg->iommu_group);
> -	iommu_group_put(kvg->iommu_group);
> -	kvg->iommu_group = NULL;
> +	kvm_spapr_tce_release_iommu_group(kvm, kvf->iommu_group);
> +	iommu_group_put(kvf->iommu_group);
> +	kvf->iommu_group = NULL;
>  }
>  #endif
>  
>  /*
> - * Groups can use the same or different IOMMU domains.  If the same then
> - * adding a new group may change the coherency of groups we've previously
> - * been told about.  We don't want to care about any of that so we retest
> - * each group and bail as soon as we find one that's noncoherent.  This
> - * means we only ever [un]register_noncoherent_dma once for the whole device.
> + * Groups/devices can use the same or different IOMMU domains.  If the same
> + * then adding a new group/device may change the coherency of groups/devices
> + * we've previously been told about.  We don't want to care about any of
> + * that so we retest each group/device and bail as soon as we find one that's
> + * noncoherent.  This means we only ever [un]register_noncoherent_dma once
> + * for the whole device.
>   */
>  static void kvm_vfio_update_coherency(struct kvm_device *dev)
>  {
>  	struct kvm_vfio *kv = dev->private;
>  	bool noncoherent = false;
> -	struct kvm_vfio_group *kvg;
> +	struct kvm_vfio_file *kvf;
>  
>  	mutex_lock(&kv->lock);
>  
> -	list_for_each_entry(kvg, &kv->group_list, node) {
> -		if (!kvm_vfio_file_enforced_coherent(kvg->file)) {
> +	list_for_each_entry(kvf, &kv->file_list, node) {
> +		if (!kvm_vfio_file_enforced_coherent(kvf->file)) {
>  			noncoherent = true;
>  			break;
>  		}
> @@ -143,10 +144,10 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
>  	mutex_unlock(&kv->lock);
>  }
>  
> -static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
> +static int kvm_vfio_file_add(struct kvm_device *dev, unsigned int fd)
>  {
>  	struct kvm_vfio *kv = dev->private;
> -	struct kvm_vfio_group *kvg;
> +	struct kvm_vfio_file *kvf;
>  	struct file *filp;
>  	int ret;
>  
> @@ -162,27 +163,27 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  
>  	mutex_lock(&kv->lock);
>  
> -	list_for_each_entry(kvg, &kv->group_list, node) {
> -		if (kvg->file == filp) {
> +	list_for_each_entry(kvf, &kv->file_list, node) {
> +		if (kvf->file == filp) {
>  			ret = -EEXIST;
>  			goto err_unlock;
>  		}
>  	}
>  
> -	kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
> -	if (!kvg) {
> +	kvf = kzalloc(sizeof(*kvf), GFP_KERNEL_ACCOUNT);
> +	if (!kvf) {
>  		ret = -ENOMEM;
>  		goto err_unlock;
>  	}
>  
> -	kvg->file = filp;
> -	list_add_tail(&kvg->node, &kv->group_list);
> +	kvf->file = filp;
> +	list_add_tail(&kvf->node, &kv->file_list);
>  
>  	kvm_arch_start_assignment(dev->kvm);
>  
>  	mutex_unlock(&kv->lock);
>  
> -	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
> +	kvm_vfio_file_set_kvm(kvf->file, dev->kvm);
>  	kvm_vfio_update_coherency(dev);
>  
>  	return 0;
> @@ -193,10 +194,10 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  	return ret;
>  }
>  
> -static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
> +static int kvm_vfio_file_del(struct kvm_device *dev, unsigned int fd)
>  {
>  	struct kvm_vfio *kv = dev->private;
> -	struct kvm_vfio_group *kvg;
> +	struct kvm_vfio_file *kvf;
>  	struct fd f;
>  	int ret;
>  
> @@ -208,18 +209,18 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
>  
>  	mutex_lock(&kv->lock);
>  
> -	list_for_each_entry(kvg, &kv->group_list, node) {
> -		if (kvg->file != f.file)
> +	list_for_each_entry(kvf, &kv->file_list, node) {
> +		if (kvf->file != f.file)
>  			continue;
>  
> -		list_del(&kvg->node);
> +		list_del(&kvf->node);
>  		kvm_arch_end_assignment(dev->kvm);
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> -		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
> +		kvm_spapr_tce_release_vfio_group(dev->kvm, kvf);
>  #endif
> -		kvm_vfio_file_set_kvm(kvg->file, NULL);
> -		fput(kvg->file);
> -		kfree(kvg);
> +		kvm_vfio_file_set_kvm(kvf->file, NULL);
> +		fput(kvf->file);
> +		kfree(kvf);
>  		ret = 0;
>  		break;
>  	}
> @@ -234,12 +235,12 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
>  }
>  
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> -static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
> -					void __user *arg)
> +static int kvm_vfio_file_set_spapr_tce(struct kvm_device *dev,
> +				       void __user *arg)
>  {
>  	struct kvm_vfio_spapr_tce param;
>  	struct kvm_vfio *kv = dev->private;
> -	struct kvm_vfio_group *kvg;
> +	struct kvm_vfio_file *kvf;
>  	struct fd f;
>  	int ret;
>  
> @@ -254,20 +255,20 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
>  
>  	mutex_lock(&kv->lock);
>  
> -	list_for_each_entry(kvg, &kv->group_list, node) {
> -		if (kvg->file != f.file)
> +	list_for_each_entry(kvf, &kv->file_list, node) {
> +		if (kvf->file != f.file)
>  			continue;
>  
> -		if (!kvg->iommu_group) {
> -			kvg->iommu_group = kvm_vfio_file_iommu_group(kvg->file);
> -			if (WARN_ON_ONCE(!kvg->iommu_group)) {
> +		if (!kvf->iommu_group) {
> +			kvf->iommu_group = kvm_vfio_file_iommu_group(kvf->file);
> +			if (WARN_ON_ONCE(!kvf->iommu_group)) {
>  				ret = -EIO;
>  				goto err_fdput;
>  			}
>  		}
>  
>  		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
> -						       kvg->iommu_group);
> +						       kvf->iommu_group);
>  		break;
>  	}
>  
> @@ -278,8 +279,8 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
>  }
>  #endif
>  
> -static int kvm_vfio_set_group(struct kvm_device *dev, long attr,
> -			      void __user *arg)
> +static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
> +			     void __user *arg)
>  {
>  	int32_t __user *argp = arg;
>  	int32_t fd;
> @@ -288,16 +289,16 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr,
>  	case KVM_DEV_VFIO_GROUP_ADD:
>  		if (get_user(fd, argp))
>  			return -EFAULT;
> -		return kvm_vfio_group_add(dev, fd);
> +		return kvm_vfio_file_add(dev, fd);
>  
>  	case KVM_DEV_VFIO_GROUP_DEL:
>  		if (get_user(fd, argp))
>  			return -EFAULT;
> -		return kvm_vfio_group_del(dev, fd);
> +		return kvm_vfio_file_del(dev, fd);
>  
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
>  	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
> -		return kvm_vfio_group_set_spapr_tce(dev, arg);
> +		return kvm_vfio_file_set_spapr_tce(dev, arg);
>  #endif
>  	}
>  
> @@ -309,8 +310,8 @@ static int kvm_vfio_set_attr(struct kvm_device *dev,
>  {
>  	switch (attr->group) {
>  	case KVM_DEV_VFIO_GROUP:
> -		return kvm_vfio_set_group(dev, attr->attr,
> -					  u64_to_user_ptr(attr->addr));
> +		return kvm_vfio_set_file(dev, attr->attr,
> +					 u64_to_user_ptr(attr->addr));
>  	}
>  
>  	return -ENXIO;
> @@ -339,16 +340,16 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
>  static void kvm_vfio_destroy(struct kvm_device *dev)
>  {
>  	struct kvm_vfio *kv = dev->private;
> -	struct kvm_vfio_group *kvg, *tmp;
> +	struct kvm_vfio_file *kvf, *tmp;
>  
> -	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
> +	list_for_each_entry_safe(kvf, tmp, &kv->file_list, node) {
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> -		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
> +		kvm_spapr_tce_release_vfio_group(dev->kvm, kvf);
>  #endif
> -		kvm_vfio_file_set_kvm(kvg->file, NULL);
> -		fput(kvg->file);
> -		list_del(&kvg->node);
> -		kfree(kvg);
> +		kvm_vfio_file_set_kvm(kvf->file, NULL);
> +		fput(kvf->file);
> +		list_del(&kvf->node);
> +		kfree(kvf);
>  		kvm_arch_end_assignment(dev->kvm);
>  	}
>  
> @@ -382,7 +383,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
>  	if (!kv)
>  		return -ENOMEM;
>  
> -	INIT_LIST_HEAD(&kv->group_list);
> +	INIT_LIST_HEAD(&kv->file_list);
>  	mutex_init(&kv->lock);
>  
>  	dev->private = kv;
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

