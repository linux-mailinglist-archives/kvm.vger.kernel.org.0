Return-Path: <kvm+bounces-18757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3B88FB17C
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 13:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A603B22C1D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 11:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BE6145A07;
	Tue,  4 Jun 2024 11:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PL3k+5Jz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98D4145A06
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 11:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502143; cv=none; b=juVgaj8pBOpc5io+4AJ44hFsJeCSaFUjJHOYBqNAU35dayHu7JLQJlEsbOh5ZEW8eD0Oh2n6Kj1tKy1I75ObSdDTUvxstFh5JKMUAaYt9A006c7o2IinDA+3CvCkI/qK2mgAmxJZV8+z7UzkT0kiop5SvdEjgtsfw8n/CheL35I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502143; c=relaxed/simple;
	bh=F1drlEwszPU9F0tuO69yMHTYmBReoRJFrrPImhmczTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=memAVVjx4pzBlYAkjc1OmlJk4/NSK+W1eVbtF6ceDyZ1h+3njheCTT7NnfqZ3TnswQ2RjTcYdNjahaxwUBcj+itDd7meg46RuATMXxDfImshZ61FJxzypns88oO+OuuEc1RGZ3i/n1M40M7sowQCGXc2HBZiByq8/HAx7SNmIwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PL3k+5Jz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717502140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UPK651wHYrkYBCXh8jpOOzyZoFpupY8aSft7y4xq4W8=;
	b=PL3k+5Jz+yA8jTivcoIPBdarf40RJFXD9Y1q4LayQVf/9y6rNqddZ8Jp3nG7nwvD+F3q7g
	urbRBJoXsRGk6l6uLVAXlUfns3ZnFlpKWxwmpltWPWN89BDVhiBlpwY3fUFoJWRtZceUOv
	t4PvYnGbUcv5B6dCEvlCXeeBnbDEQ3U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-oDXWrP3CPN-kB9dWnrWvMQ-1; Tue, 04 Jun 2024 07:55:39 -0400
X-MC-Unique: oDXWrP3CPN-kB9dWnrWvMQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35dca4922a4so2975450f8f.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 04:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717502138; x=1718106938;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UPK651wHYrkYBCXh8jpOOzyZoFpupY8aSft7y4xq4W8=;
        b=sM6bByQiWGpzEomlBmmTRjNsXj4oiMpqUNRjkrbRTeMYHDcycTa/+dQDX9yeqaCKSK
         QIMwJ6UXre3R144rXLCvHrwFW7b1om+7KCFtdiuWFVPXgVkssSmH/7gvidb3f/mT3BKj
         Aa8x5EUOK+ZpDBFWdXdtt0WAKrKP3rh3/Wq2ePsts8qw+oyRkw81KdtMoStI8XpntKdl
         OzItRu4gWcetfEQAbCLLpfGNvnG6Ii7ydyzhX/hR7YK1CPtKil16iX+r211uM7IYraHs
         MdhkbV3wHzIn9CXMxC1lNp0Ff5TxDpe/S3TsQxaGTu3g7h2619G2PP9rtXQYmtj4fTf7
         rDow==
X-Forwarded-Encrypted: i=1; AJvYcCWZNX1YhYdthvk0T/FEmiOL5/ijCAjVRB4g1tnxHOMmsqNXjQjeRSvgcP4dK2kfAjx8VJBi036q+YAMScr28gltzuAi
X-Gm-Message-State: AOJu0YxicQDhORs1qd83Bmw8yifqP39oUPp1jca0rdNGcQ6Vufex5vfr
	b8jZA5ACY87CYSVHs232ZxCJMpXJdFR38NF6IjnH117pwQfcO5JfaTbXmz73R+12W8qgcH4E3dE
	r9fFI0mnh7UJwV+4UMy0ZuHW608Qm0PyWi/275fsCdtlSz5ZXEw==
X-Received: by 2002:a5d:400e:0:b0:351:b130:45c2 with SMTP id ffacd0b85a97d-35e7c54b270mr2388399f8f.14.1717502138504;
        Tue, 04 Jun 2024 04:55:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5YmUTkrAQDfHoDcyYwJ45C3sk3mPdapxdGOCihWWjx8N1UxmvRgBSSSw0kLMmoTen9a9x3Q==
X-Received: by 2002:a5d:400e:0:b0:351:b130:45c2 with SMTP id ffacd0b85a97d-35e7c54b270mr2388383f8f.14.1717502138120;
        Tue, 04 Jun 2024 04:55:38 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-171.retail.telecomitalia.it. [82.53.134.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35e0f97ba3csm10968582f8f.73.2024.06.04.04.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 04:55:37 -0700 (PDT)
Date: Tue, 4 Jun 2024 13:55:33 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Srujana Challa <schalla@marvell.com>, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, mst@redhat.com, vattunuru@marvell.com, sthotton@marvell.com, 
	ndabilpuram@marvell.com, jerinj@marvell.com
Subject: Re: [PATCH] vdpa: Add support for no-IOMMU mode
Message-ID: <s5tkqdls55n535tvrlalsej44hvrzqgcdqkspyxrvnl4muard6@nyvdw7xptoze>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <CACGkMEsxPfck-Ww6CHSod5wP5xLOpS3t2B8qhTL0=PoE3koCGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEsxPfck-Ww6CHSod5wP5xLOpS3t2B8qhTL0=PoE3koCGQ@mail.gmail.com>

On Fri, May 31, 2024 at 10:26:31AM GMT, Jason Wang wrote:
>On Thu, May 30, 2024 at 6:18 PM Srujana Challa <schalla@marvell.com> wrote:
>>
>> This commit introduces support for an UNSAFE, no-IOMMU mode in the
>> vhost-vdpa driver. When enabled, this mode provides no device isolation,
>> no DMA translation, no host kernel protection, and cannot be used for
>> device assignment to virtual machines. It requires RAWIO permissions
>> and will taint the kernel.
>> This mode requires enabling the "enable_vhost_vdpa_unsafe_noiommu_mode"
>> option on the vhost-vdpa driver. This mode would be useful to get
>> better performance on specifice low end machines and can be leveraged
>> by embedded platforms where applications run in controlled environment.
>
>I wonder if it's better to do it per driver:
>
>1) we have device that use its own IOMMU, one example is the mlx5 vDPA device
>2) we have software devices which doesn't require IOMMU at all (but
>still with protection)

It worries me even if the module parameter is the best thing.
What about a sysfs entry?

Thanks,
Stefano

>
>Thanks
>
>>
>> Signed-off-by: Srujana Challa <schalla@marvell.com>
>> ---
>>  drivers/vhost/vdpa.c | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index bc4a51e4638b..d071c30125aa 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -36,6 +36,11 @@ enum {
>>
>>  #define VHOST_VDPA_IOTLB_BUCKETS 16
>>
>> +bool vhost_vdpa_noiommu;
>> +module_param_named(enable_vhost_vdpa_unsafe_noiommu_mode,
>> +                  vhost_vdpa_noiommu, bool, 0644);
>> +MODULE_PARM_DESC(enable_vhost_vdpa_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
>> +
>>  struct vhost_vdpa_as {
>>         struct hlist_node hash_link;
>>         struct vhost_iotlb iotlb;
>> @@ -60,6 +65,7 @@ struct vhost_vdpa {
>>         struct vdpa_iova_range range;
>>         u32 batch_asid;
>>         bool suspended;
>> +       bool noiommu_en;
>>  };
>>
>>  static DEFINE_IDA(vhost_vdpa_ida);
>> @@ -887,6 +893,10 @@ static void vhost_vdpa_general_unmap(struct vhost_vdpa *v,
>>  {
>>         struct vdpa_device *vdpa = v->vdpa;
>>         const struct vdpa_config_ops *ops = vdpa->config;
>> +
>> +       if (v->noiommu_en)
>> +               return;
>> +
>>         if (ops->dma_map) {
>>                 ops->dma_unmap(vdpa, asid, map->start, map->size);
>>         } else if (ops->set_map == NULL) {
>> @@ -980,6 +990,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>>         if (r)
>>                 return r;
>>
>> +       if (v->noiommu_en)
>> +               goto skip_map;
>> +
>>         if (ops->dma_map) {
>>                 r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
>>         } else if (ops->set_map) {
>> @@ -995,6 +1008,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>>                 return r;
>>         }
>>
>> +skip_map:
>>         if (!vdpa->use_va)
>>                 atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
>>
>> @@ -1298,6 +1312,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>>         struct vdpa_device *vdpa = v->vdpa;
>>         const struct vdpa_config_ops *ops = vdpa->config;
>>         struct device *dma_dev = vdpa_get_dma_dev(vdpa);
>> +       struct iommu_domain *domain;
>>         const struct bus_type *bus;
>>         int ret;
>>
>> @@ -1305,6 +1320,14 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>>         if (ops->set_map || ops->dma_map)
>>                 return 0;
>>
>> +       domain = iommu_get_domain_for_dev(dma_dev);
>> +       if ((!domain || domain->type == IOMMU_DOMAIN_IDENTITY) &&
>> +           vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO)) {
>> +               add_taint(TAINT_USER, LOCKDEP_STILL_OK);
>> +               dev_warn(&v->dev, "Adding kernel taint for noiommu on device\n");
>> +               v->noiommu_en = true;
>> +               return 0;
>> +       }
>>         bus = dma_dev->bus;
>>         if (!bus)
>>                 return -EFAULT;
>> --
>> 2.25.1
>>
>
>


