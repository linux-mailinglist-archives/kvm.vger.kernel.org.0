Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4B2673489
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 10:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjASJgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 04:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjASJgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 04:36:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1415DC10
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 01:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674120925;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6saBc3Hskh5cFDwTIgFllNpxb8IMwKF2qr10jKqpF0=;
        b=C2ePncZ/8Bxba/Y4JwNXsIQwLYukXnT+29b3ha5yFrl3ZwVnOpXUy07grd3WP1Q6bsXoi4
        r7pYN1tOfPTANLwPZuInXrKKWM5ltCAT3Z1XwV1cT+mnL1S4dsXosUJCoT5hYJuHcIZTXr
        1myOR4y2dl+GoDJlFeISACJADod566M=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-248-U2bwyiRBMii-X3xajDhuyw-1; Thu, 19 Jan 2023 04:35:24 -0500
X-MC-Unique: U2bwyiRBMii-X3xajDhuyw-1
Received: by mail-qv1-f70.google.com with SMTP id e5-20020a056214110500b0053547681552so716087qvs.8
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 01:35:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v6saBc3Hskh5cFDwTIgFllNpxb8IMwKF2qr10jKqpF0=;
        b=XsycHBmaoiiDK6S4KtGOhPX8qvBGguxbHLLyi++bwmBTLzf6/bAdW8NF8es0AluACK
         b1D0y7794GgByvqx7wtdiWalrt40jQg8WjFv1yNHhHdZxgs6sLLjhx3bBwJVl4FClYJb
         GV6/+BcseTd1kSGBDmNuyvZ+OjPGY2IIOWKhnHJ6HKp+3XeGKla4+kVk2B3tQVHmaLTE
         QJSWKbyNbWsM4fdPHzb7zzTrRfSLKUU5/JMJPsu0g1DGk5YbXbNafKkF9MzrFGYcP3u2
         uBJxn99Ji8EyKeU72hBGfIcPU/Xi/PgjCnXAmtyIyvqvf/gtkevXN7ofNBVBjWjcRYkO
         Y35Q==
X-Gm-Message-State: AFqh2krH3WloY2lqIQ0FZh/efVH4gi6RcSCR2V7XC7U4F6EnhIA0BUNI
        TGHrewpj36mtbD5Sx06OBb4t1GWdTd9d/1hs2qZ1OlcZOoK3sYAD7Qx6t9GPGy/Hw9JS1+tuuBC
        tabteYsIcRsvC
X-Received: by 2002:a05:6214:5293:b0:532:2d0e:7e3b with SMTP id kj19-20020a056214529300b005322d0e7e3bmr18616639qvb.37.1674120923564;
        Thu, 19 Jan 2023 01:35:23 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtexV7sAiBk7EZnEjJeSm8KfCic4A6/AyyBTJtlE+WGwQaxyk9aWFDXaqmDmwsil/eOqmH69g==
X-Received: by 2002:a05:6214:5293:b0:532:2d0e:7e3b with SMTP id kj19-20020a056214529300b005322d0e7e3bmr18616612qvb.37.1674120923282;
        Thu, 19 Jan 2023 01:35:23 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bm16-20020a05620a199000b006e16dcf99c8sm23914974qkb.71.2023.01.19.01.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 01:35:22 -0800 (PST)
Message-ID: <a9d03e80-dff5-aa6e-c118-b1299fabbe5d@redhat.com>
Date:   Thu, 19 Jan 2023 10:35:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 06/13] kvm/vfio: Accept vfio device file from userspace
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-7-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117134942.101112-7-yi.l.liu@intel.com>
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

Hi Yi,

On 1/17/23 14:49, Yi Liu wrote:
> This defines KVM_DEV_VFIO_FILE* and make alias with KVM_DEV_VFIO_GROUP*.
> Old userspace uses KVM_DEV_VFIO_GROUP* works as well.
>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 32 ++++++++++++-------------
>  include/uapi/linux/kvm.h                | 23 +++++++++++++-----
>  virt/kvm/vfio.c                         | 18 +++++++-------
>  3 files changed, 42 insertions(+), 31 deletions(-)
>
> diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
> index 2d20dc561069..ac4300ded398 100644
> --- a/Documentation/virt/kvm/devices/vfio.rst
> +++ b/Documentation/virt/kvm/devices/vfio.rst
> @@ -9,23 +9,23 @@ Device types supported:
>    - KVM_DEV_TYPE_VFIO
>  
>  Only one VFIO instance may be created per VM.  The created device
> -tracks VFIO groups in use by the VM and features of those groups
> -important to the correctness and acceleration of the VM.  As groups
> -are enabled and disabled for use by the VM, KVM should be updated
> -about their presence.  When registered with KVM, a reference to the
> -VFIO-group is held by KVM.
> -
> -Groups:
> -  KVM_DEV_VFIO_GROUP
> -
> -KVM_DEV_VFIO_GROUP attributes:
> -  KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
> -	kvm_device_attr.addr points to an int32_t file descriptor
> +tracks VFIO files (group or device) in use by the VM and features
> +of those groups/devices important to the correctness and acceleration
> +of the VM.  As groups/device are enabled and disabled for use by the
> +VM, KVM should be updated about their presence.  When registered with
> +KVM, a reference to the VFIO file is held by KVM.
> +
> +VFIO Files:
> +  KVM_DEV_VFIO_FILE
> +
> +KVM_DEV_VFIO_FILE attributes:
> +  KVM_DEV_VFIO_FILE_ADD: Add a VFIO file (group/device) to VFIO-KVM device
> +	tracking kvm_device_attr.addr points to an int32_t file descriptor
> +	for the VFIO file.
> +  KVM_DEV_VFIO_FILE_DEL: Remove a VFIO file (group/device) from VFIO-KVM device
> +	tracking kvm_device_attr.addr points to an int32_t file descriptor
>  	for the VFIO group.
> -  KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM device tracking
> -	kvm_device_attr.addr points to an int32_t file descriptor
> -	for the VFIO group.
> -  KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: attaches a guest visible TCE table
> +  KVM_DEV_VFIO_FILE_SET_SPAPR_TCE: attaches a guest visible TCE table
>  	allocated by sPAPR KVM.
>  	kvm_device_attr.addr points to a struct::
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 55155e262646..ad36e144a41d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1396,15 +1396,26 @@ struct kvm_create_device {
>  
>  struct kvm_device_attr {
>  	__u32	flags;		/* no flags currently defined */
> -	__u32	group;		/* device-defined */
> -	__u64	attr;		/* group-defined */
> +	union {
> +		__u32	group;
> +		__u32	file;
> +	}; /* device-defined */
> +	__u64	attr;		/* VFIO-file-defined or group-defined */
I think there is a confusion here between the 'VFIO group' terminology
and the 'kvm device group' terminology. Commands for kvm devices are
gathered in groups and within groups you have sub-commands called
attributes.

See Documentation/virt/kvm/devices/arm-vgic-v3.rst for instance. So to
me this shall be left unchanged.
>  	__u64	addr;		/* userspace address of attr data */
>  };
>  
> -#define  KVM_DEV_VFIO_GROUP			1
> -#define   KVM_DEV_VFIO_GROUP_ADD			1
> -#define   KVM_DEV_VFIO_GROUP_DEL			2
> -#define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE		3
> +#define  KVM_DEV_VFIO_FILE	1
> +
> +#define   KVM_DEV_VFIO_FILE_ADD			1
> +#define   KVM_DEV_VFIO_FILE_DEL			2
> +#define   KVM_DEV_VFIO_FILE_SET_SPAPR_TCE	3
> +
> +/* Group aliases are for compile time uapi compatibility */
> +#define  KVM_DEV_VFIO_GROUP	KVM_DEV_VFIO_FILE
> +
> +#define   KVM_DEV_VFIO_GROUP_ADD	KVM_DEV_VFIO_FILE_ADD
> +#define   KVM_DEV_VFIO_GROUP_DEL	KVM_DEV_VFIO_FILE_DEL
> +#define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE	KVM_DEV_VFIO_FILE_SET_SPAPR_TCE
>  
>  enum kvm_device_type {
>  	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 525efe37ab6d..e73ca60af3ae 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -286,18 +286,18 @@ static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
>  	int32_t fd;
>  
>  	switch (attr) {
> -	case KVM_DEV_VFIO_GROUP_ADD:
> +	case KVM_DEV_VFIO_FILE_ADD:
>  		if (get_user(fd, argp))
>  			return -EFAULT;
>  		return kvm_vfio_file_add(dev, fd);
>  
> -	case KVM_DEV_VFIO_GROUP_DEL:
> +	case KVM_DEV_VFIO_FILE_DEL:
>  		if (get_user(fd, argp))
>  			return -EFAULT;
>  		return kvm_vfio_file_del(dev, fd);
>  
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> -	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
> +	case KVM_DEV_VFIO_FILE_SET_SPAPR_TCE:
>  		return kvm_vfio_file_set_spapr_tce(dev, arg);
>  #endif
>  	}
> @@ -309,7 +309,7 @@ static int kvm_vfio_set_attr(struct kvm_device *dev,
>  			     struct kvm_device_attr *attr)
>  {
>  	switch (attr->group) {
> -	case KVM_DEV_VFIO_GROUP:
> +	case KVM_DEV_VFIO_FILE:
>  		return kvm_vfio_set_file(dev, attr->attr,
>  					 u64_to_user_ptr(attr->addr));
>  	}
> @@ -320,13 +320,13 @@ static int kvm_vfio_set_attr(struct kvm_device *dev,
>  static int kvm_vfio_has_attr(struct kvm_device *dev,
>  			     struct kvm_device_attr *attr)
>  {
> -	switch (attr->group) {
> -	case KVM_DEV_VFIO_GROUP:
> +	switch (attr->file) {
> +	case KVM_DEV_VFIO_FILE:
>  		switch (attr->attr) {
> -		case KVM_DEV_VFIO_GROUP_ADD:
> -		case KVM_DEV_VFIO_GROUP_DEL:
> +		case KVM_DEV_VFIO_FILE_ADD:
> +		case KVM_DEV_VFIO_FILE_DEL:
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> -		case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
> +		case KVM_DEV_VFIO_FILE_SET_SPAPR_TCE:
>  #endif
>  			return 0;
>  		}
Thanks

Eric

