Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C0E6AF7ED
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 22:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjCGVsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 16:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjCGVsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 16:48:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CFA59411
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 13:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678225645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Tz2V7SZ3XeeN9Zt6Fi1B70yrfoR6WDiikhpxo6iLcw=;
        b=bh1TY7E3bkdfQuv4EeiUlm76a5rJxa9576LN+XeJHVYS4o109vT6/NVmfBVhhcTz/42z2i
        HKv0mtUJ24XlfwmalQWUeVUOzVN+8IO/rYeq361WAulYgMF8AFqTlYmhXJCjh4PI2ozSAg
        McinExHz7CTgjsDI+ptZe37NPjXJQYI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-iWeMwCjIONieAiwyaL6Tng-1; Tue, 07 Mar 2023 16:47:24 -0500
X-MC-Unique: iWeMwCjIONieAiwyaL6Tng-1
Received: by mail-io1-f71.google.com with SMTP id 207-20020a6b14d8000000b0074ca9a558feso7623389iou.5
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 13:47:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678225643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Tz2V7SZ3XeeN9Zt6Fi1B70yrfoR6WDiikhpxo6iLcw=;
        b=Roa6Br78BtviUnwZEF00rrmOtS2QEnyjrTyFZ41wuIhezfz+L1AI0LjUgqtHvqun01
         WiSuyb1VAKzw6g9vYJBb7MtJjMSY1ZPWtvy9QV+5cOkl5T7Q+ysx1r4NqtfuYlhn9puU
         5kdA96wX9hCj80DpCvArSXGNCD/MS3VR13LDAj9l/KjdS7wf5y/Duf3ANZ15zku3mdz5
         eEc8e/pbD5BhIvruO2Ow1U9ZS+9lFDBeqgZAKFW8//mgvZSz6M27BBeKV2wxucl3l6Q/
         WgZMLwzwv6jyhicqV7ZH6PhmBfciu8NWsQ4TIH8ttML/XZJq8UeoCnXR45rU7medOBxZ
         1KLQ==
X-Gm-Message-State: AO0yUKUzIbamCmZgW9XTkOUXgvldtsLCU6b26x72IX52An7DVpYhoa5b
        6aKT+3swg2uCu+BervN45NMgT/ZMV8OU/OFGq4ext/sPcYyE74rmOUFCcDH/L1eUs7Yhh4rVFbF
        CVUrmCBmy5MnKPV3W0kOQ
X-Received: by 2002:a05:6602:358c:b0:74d:6e1b:1b97 with SMTP id bi12-20020a056602358c00b0074d6e1b1b97mr12549554iob.4.1678225643233;
        Tue, 07 Mar 2023 13:47:23 -0800 (PST)
X-Google-Smtp-Source: AK7set/Afx5tVMxTZsYui74DaNbT8jdEsT/xZin8VxDAtreWYmKTXbxIQbVcES0BSHZirrMUyzKmIA==
X-Received: by 2002:a05:6602:358c:b0:74d:6e1b:1b97 with SMTP id bi12-20020a056602358c00b0074d6e1b1b97mr12549544iob.4.1678225642975;
        Tue, 07 Mar 2023 13:47:22 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z3-20020a056638000300b003c508c54647sm4569491jao.29.2023.03.07.13.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:47:22 -0800 (PST)
Date:   Tue, 7 Mar 2023 14:47:20 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Seunggyun Lee <sglee97@dankook.ac.kr>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci/vfio_pci_core.c: add IORESOURCE_EXCLUSIVE flag
Message-ID: <20230307144720.620d2fed.alex.williamson@redhat.com>
In-Reply-To: <20230307034018.36980-1-sglee97@dankook.ac.kr>
References: <20230307034018.36980-1-sglee97@dankook.ac.kr>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Mar 2023 12:40:18 +0900
Seunggyun Lee <sglee97@dankook.ac.kr> wrote:

> While using a pci device (GPU) through the vfio-pci passthrough in QEMU
> VM, host can mmap the PCI device which used by the guest through sysfs.
> 
> In this case, when the guest used the PCI device, the host could also
> access the data stored in the PCI device memory.
> 
> Regarding this, there is a routine to check IORESOURCE_EXCLUSIVE through
> iomem_is_exclusive() in pci_mmap_resource() of pci-sysfs.c, but vfio-pci
> driver doesn't seem to set that flag.
> 
> Wouldn't it be better to use pci_request_selected_regions_exclusive() to
> set the IORESOURCE_EXCLUSIVE flag rather than
> pci_request_selected_regions() that was used previously?
> 
> Signed-off-by: Seunggyun Lee <sglee97@dankook.ac.kr>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 26a541cc64d1..9731ac35b3ad 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1779,7 +1779,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	 * we need to request the region and the barmap tracks that.
>  	 */
>  	if (!vdev->barmap[index]) {
> -		ret = pci_request_selected_regions(pdev,
> +		ret = pci_request_selected_regions_exclusive(pdev,
>  						   1 << index, "vfio-pci");
>  		if (ret)
>  			return ret;

I don't understand why this request is so pervasive lately, there are
other means to lockdown sysfs access to a device, why are they not
sufficient (ex. LOCKDOWN_PCI_ACCESS).

If this is work towards confidential computing support with VFIO, I'm
afraid that sysfs access to the device is only one potential vector,
QEMU itself is in control of whether a VM directly maps device
resources.

Also, IORESOURCE_EXCLUSIVE is described as preventing userspace mapping
of the resource, so it's a bit ironic that a driver providing userspace
mappings of device resources would mark the resource in such a way.
Thanks,

Alex

