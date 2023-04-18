Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42736E6F75
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 00:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjDRWjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 18:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjDRWje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 18:39:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0329011
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 15:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681857527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nt4NAlgjVn3bwVtb59HBkHnV8fhtHInS8+cCLwzW3Oo=;
        b=eplRB4EYd/BRVjPcXlKnIAmoU8v/IJ+6xjqeul0/TKtSP1b0uErY34i3/0cPcUYw/dvhll
        JOFBL4SyTn+1omPMUqHD1hgc60+fPXUTEU1u4VqLuYiP2EiZVkMjZ+fOPTsfCPrvUg6jgi
        8rv7LeW1lA3uQ2eG1IxkSrUuucgqfpM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-ZED_Lv90PdqVkm9MeyzG1A-1; Tue, 18 Apr 2023 18:38:45 -0400
X-MC-Unique: ZED_Lv90PdqVkm9MeyzG1A-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-760718e6816so254948639f.2
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 15:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681857525; x=1684449525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nt4NAlgjVn3bwVtb59HBkHnV8fhtHInS8+cCLwzW3Oo=;
        b=FBU0m6eHbkYzgtm702615GQtctdNpevedwuidnjUTMtzd4rKJu+/YXtTS5FBdwlPwQ
         19SxAi0SWpZCN/dHwl0TAnI42yQgZjIQLTaTq7CHA3tfIXqc4rA3CZkG5JOmSNiWfAZg
         6XRZdvKzCySl/sM4VnbqduA+0H7dv6mwSYReBaASakqVe+refBKUYWJgxnps4bdU4Hq4
         T3I21rdh2x66SmwCMZ8ciZdezb8rKrDoYjICecitxQALQnhelGEXHM/8Tb6U4Kv36UEJ
         ss5ychc5djf+083ieksOMNp08FFFDvT3u/T9QCLJhfru+shJx6mUaAVvI5sz6ZsQcbD8
         tIGA==
X-Gm-Message-State: AAQBX9fwhz9k4CvVqmOz6YuRnuHeyypty482WzNIUpaWwzzYfwejFrmg
        K8K5FqXJiSCNjNqa6DiQQ+pkbZUQvLzJC8+4B0WZb0W5s9h6ofEVJuQG5J6a7ZI0neqj7c5KxXs
        jzrgc+xMj8fdl
X-Received: by 2002:a5d:80d6:0:b0:760:e9b6:e6da with SMTP id h22-20020a5d80d6000000b00760e9b6e6damr3037655ior.1.1681857524999;
        Tue, 18 Apr 2023 15:38:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350YI7seWtoBWPqYjT1RzndFBvuqrDODhMJ9id2vYXvKT4+TRs/PoewlgjvRH85jDeChhXC2tOQ==
X-Received: by 2002:a5d:80d6:0:b0:760:e9b6:e6da with SMTP id h22-20020a5d80d6000000b00760e9b6e6damr3037642ior.1.1681857524746;
        Tue, 18 Apr 2023 15:38:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x6-20020a5d9906000000b007079249a9d1sm4275565iol.34.2023.04.18.15.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 15:38:44 -0700 (PDT)
Date:   Tue, 18 Apr 2023 16:38:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 10/10] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for
 MSI-X
Message-ID: <20230418163843.7b4c0366.alex.williamson@redhat.com>
In-Reply-To: <6c057618833a180da2147bffadb98e07cb73e045.1681837892.git.reinette.chatre@intel.com>
References: <cover.1681837892.git.reinette.chatre@intel.com>
        <6c057618833a180da2147bffadb98e07cb73e045.1681837892.git.reinette.chatre@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Apr 2023 10:29:21 -0700
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Dynamic MSI-X is supported. Clear VFIO_IRQ_INFO_NORESIZE
> to provide guidance to user space.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since V2:
> - Use new vdev->has_dyn_msix property instead of calling
>   pci_msix_can_alloc_dyn() directly. (Alex)
> 
> Changes since RFC V1:
> - Only advertise VFIO_IRQ_INFO_NORESIZE for MSI-X devices that
>   can actually support dynamic allocation. (Alex)
> 
>  drivers/vfio/pci/vfio_pci_core.c | 4 +++-
>  include/uapi/linux/vfio.h        | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index a3635a8e54c8..4050ad3388c2 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1114,7 +1114,9 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>  	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
>  		info.flags |=
>  			(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
> -	else
> +	else if ((info.index != VFIO_PCI_MSIX_IRQ_INDEX) ||
> +		 (info.index == VFIO_PCI_MSIX_IRQ_INDEX &&
> +		  !vdev->has_dyn_msix))

Isn't this the same as:

	(info.index != VFIO_PCI_MSIX_IRQ_INDEX || !vdev->has_dyn_msix)

Thanks,
Alex

>  		info.flags |= VFIO_IRQ_INFO_NORESIZE;
>  
>  	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 0552e8dcf0cb..1a36134cae5c 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -511,6 +511,9 @@ struct vfio_region_info_cap_nvlink2_lnkspd {
>   * then add and unmask vectors, it's up to userspace to make the decision
>   * whether to allocate the maximum supported number of vectors or tear
>   * down setup and incrementally increase the vectors as each is enabled.
> + * Absence of the NORESIZE flag indicates that vectors can be enabled
> + * and disabled dynamically without impacting other vectors within the
> + * index.
>   */
>  struct vfio_irq_info {
>  	__u32	argsz;

