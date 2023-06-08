Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C2572891B
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 21:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbjFHT6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 15:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbjFHT6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 15:58:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192692D52
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 12:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686254271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WMHgXod6t2XuUVHTvFXUlFVgxq33IY3ATlf+HZ0QqSE=;
        b=jLzDa6xXaFcZeMEvfFvjsmfR5rTTZ0oSEz+yNxxWUBucH+Fu4kEfqTTXYhbnHb9Mn2GzX1
        zoRc5K9s7fS4CQudutEv4/8BLFXYfTXqGs0cZT7x+KJe6/z5sN2Nz2xnhvaxTvlD5622p4
        xqj7edFageelHCApqxXw4PKStKOkF14=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-9VG4PYNSMTqxFJvy6ynhcw-1; Thu, 08 Jun 2023 15:57:50 -0400
X-MC-Unique: 9VG4PYNSMTqxFJvy6ynhcw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3f9aa2026ffso12656791cf.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 12:57:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686254269; x=1688846269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WMHgXod6t2XuUVHTvFXUlFVgxq33IY3ATlf+HZ0QqSE=;
        b=W43Y0TxDfFLQDFU4uo+ZGc09JRIPfBOTubFpOZiq2pDHEoXBVgdYkcwhK/8tfkGcMx
         Bfw6nFyOe5vZimimZ+bjrF40TCNz08m2jNHyydJB1rRX9qgzb/85TV4cqlADZcs/x9Jm
         rwwNJUsLcGwp/rcKJP6986hUGmVAAuGQwKb2/Zu76+MshVFSH9OrPzAgWZny/kflq+Pg
         +ZIhrlcXTOuJHer55J6QtZDzW3W/GP0fCRiGQSIgO7lsGiszQX+PjeCzyghdSq6ph+xY
         PF3g7kvUFZJvaovoEvxWJVgqrPxexNK5mQVpMjmbPvQBdMW9c60g/S2yP+8UVpe4cl0d
         MgiA==
X-Gm-Message-State: AC+VfDzdaIk8BBEnHsLXhXL8PnYsvIGK1nY6Uyr5A0wtF8pld/3WdsHb
        QbEmJgr/4QsuBoRBwc8MrKQdVH1Fr2hmlNUpOOJKu6AF6HowWanZnZIfMMoAGF5pzAdt2AiV287
        lDlSeZTx8IJRcTqapZlMH
X-Received: by 2002:a05:622a:453:b0:3f6:aa61:4e6b with SMTP id o19-20020a05622a045300b003f6aa614e6bmr8676553qtx.32.1686254269167;
        Thu, 08 Jun 2023 12:57:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ54yhRBvR+uLQpcg0Qc9MFHM6RbzbKfSZGO79GuXKaG8BBS+QZPEkGrK92vN2+WgmpIJRLW7A==
X-Received: by 2002:a05:622a:453:b0:3f6:aa61:4e6b with SMTP id o19-20020a05622a045300b003f6aa614e6bmr8676538qtx.32.1686254268913;
        Thu, 08 Jun 2023 12:57:48 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:9e2:9000:9283:b79f:cbb3:327a? ([2a01:e0a:9e2:9000:9283:b79f:cbb3:327a])
        by smtp.gmail.com with ESMTPSA id b8-20020ac844c8000000b003f6b0f4126fsm611953qto.8.2023.06.08.12.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 12:57:48 -0700 (PDT)
Message-ID: <f7aa5df2-d3a3-80fc-60bd-6bf62c182c51@redhat.com>
Date:   Thu, 8 Jun 2023 21:57:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] vfio/pci-core: Add capability for AtomicOp copleter
 support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     robin@streamhpc.com
References: <20230519214748.402003-1-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <20230519214748.402003-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/23 23:47, Alex Williamson wrote:
> Test and enable PCIe AtomicOp completer support of various widths and
> report via device-info capability to userspace.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   drivers/vfio/pci/vfio_pci_core.c | 38 ++++++++++++++++++++++++++++++++
>   include/uapi/linux/vfio.h        | 14 ++++++++++++
>   2 files changed, 52 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index a5ab416cf476..a21ab726c9d4 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -882,6 +882,37 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
>   }
>   EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
>   
> +static int vfio_pci_info_atomic_cap(struct vfio_pci_core_device *vdev,
> +				    struct vfio_info_cap *caps)
> +{
> +	struct vfio_device_info_cap_pci_atomic_comp cap = {
> +		.header.id = VFIO_DEVICE_INFO_CAP_PCI_ATOMIC_COMP,
> +		.header.version = 1
> +	};
> +	struct pci_dev *pdev = pci_physfn(vdev->pdev);
> +	u32 devcap2;
> +
> +	pcie_capability_read_dword(pdev, PCI_EXP_DEVCAP2, &devcap2);
> +
> +	if ((devcap2 & PCI_EXP_DEVCAP2_ATOMIC_COMP32) &&
> +	    !pci_enable_atomic_ops_to_root(pdev, PCI_EXP_DEVCAP2_ATOMIC_COMP32))
> +		cap.flags |= VFIO_PCI_ATOMIC_COMP32;
> +
> +	if ((devcap2 & PCI_EXP_DEVCAP2_ATOMIC_COMP64) &&
> +	    !pci_enable_atomic_ops_to_root(pdev, PCI_EXP_DEVCAP2_ATOMIC_COMP64))
> +		cap.flags |= VFIO_PCI_ATOMIC_COMP64;
> +
> +	if ((devcap2 & PCI_EXP_DEVCAP2_ATOMIC_COMP128) &&
> +	    !pci_enable_atomic_ops_to_root(pdev,
> +					   PCI_EXP_DEVCAP2_ATOMIC_COMP128))
> +		cap.flags |= VFIO_PCI_ATOMIC_COMP128;
> +
> +	if (!cap.flags)
> +		return -ENODEV;
> +
> +	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
> +}
> +
>   static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
>   				   struct vfio_device_info __user *arg)
>   {
> @@ -920,6 +951,13 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
>   		return ret;
>   	}
>   
> +	ret = vfio_pci_info_atomic_cap(vdev, &caps);
> +	if (ret && ret != -ENODEV) {
> +		pci_warn(vdev->pdev,
> +			 "Failed to setup AtomicOps info capability\n");
> +		return ret;
> +	}
> +
>   	if (caps.size) {
>   		info.flags |= VFIO_DEVICE_FLAGS_CAPS;
>   		if (info.argsz < sizeof(info) + caps.size) {
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 0552e8dcf0cb..07988d62b33c 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -240,6 +240,20 @@ struct vfio_device_info {
>   #define VFIO_DEVICE_INFO_CAP_ZPCI_UTIL		3
>   #define VFIO_DEVICE_INFO_CAP_ZPCI_PFIP		4
>   
> +/*
> + * The following VFIO_DEVICE_INFO capability reports support for PCIe AtomicOp
> + * completion to the root bus with supported widths provided via flags.
> + */
> +#define VFIO_DEVICE_INFO_CAP_PCI_ATOMIC_COMP	5
> +struct vfio_device_info_cap_pci_atomic_comp {
> +	struct vfio_info_cap_header header;
> +	__u32 flags;
> +#define VFIO_PCI_ATOMIC_COMP32	(1 << 0)
> +#define VFIO_PCI_ATOMIC_COMP64	(1 << 1)
> +#define VFIO_PCI_ATOMIC_COMP128	(1 << 2)
> +	__u32 reserved;
> +};
> +
>   /**
>    * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
>    *				       struct vfio_region_info)

