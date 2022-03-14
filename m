Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74524D8FDE
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 23:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343517AbiCNWv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 18:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245751AbiCNWvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 18:51:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B692C2409A
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 15:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647298237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dr8vjVeMC0DL0KsvggB3fHeVAbBUF+c93QlSTnv4NdI=;
        b=U7Wn+0ikSuIU5tjeAQL8EQIug7bI0u2IV4P+O52kphoJCPM2jxKLjVeUpEJBAi3ObrWhv0
        GEV9RA3Nzw5c6ec0wEK18MUUWY6ZzZ3awWf4b88QhBo7UijhByFo/pxT667eCIfyjf6IEP
        wnVN8+nNzJ7ZE2RXkPEYOsBdEdUtXtI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324--4kSVn1oP0KcMuJoWNpO2w-1; Mon, 14 Mar 2022 18:50:36 -0400
X-MC-Unique: -4kSVn1oP0KcMuJoWNpO2w-1
Received: by mail-io1-f69.google.com with SMTP id e27-20020a056602045b00b00645bd576184so13276917iov.3
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 15:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dr8vjVeMC0DL0KsvggB3fHeVAbBUF+c93QlSTnv4NdI=;
        b=WPq8l+BS3mJ4hYllJUYUYqewLzu2V7hRrjjBd3aoVHz9XvvU5sl5l7bRepY/MSITMo
         OLynADihyccj1m1NIbw8ayrJ7RCGfwB/cYwa2eDEGxGzCjdvBAzbwL1tWeWN89/Mmf2N
         yFbIQvocS/X0lJFX0L6ULd58etGT6Wqx9YsLP0LCu9VFr5Dee0cD21qdvsut8ik9poaw
         iKApk3uazmcvgMyusadiuHbSQSBY94yjbZKz1lafCk6aaV8DS+Nq93dO9gCVkiJlskaX
         I4NNmLDCS8HphTu9koyfgjTZbuR8LCDVRyJswdbxPTw6snQx+UJlO2cJt5nXSDi0mIo3
         sdQg==
X-Gm-Message-State: AOAM533B9fdPILsanL+mV1Nahk35xf+fQxcfnaSfhjTgoyzOdB75W3Zc
        daAOUzXZ6flCOfMjCVDZD5sxQgumI2t4qr9rdAElP/yss8XzpZz3nmOXvcUEbRresgH8KgyFJ+m
        8oiWPzi0h2G1z
X-Received: by 2002:a6b:620e:0:b0:611:4b19:6ca8 with SMTP id f14-20020a6b620e000000b006114b196ca8mr20995640iog.49.1647298236055;
        Mon, 14 Mar 2022 15:50:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxg8HJ/3lVgtLPe6Yd5ht2l45iOmV2X8AafJZFuKi1YIsK1jkfd5ZA3a4unIG0CxlWIAReolA==
X-Received: by 2002:a6b:620e:0:b0:611:4b19:6ca8 with SMTP id f14-20020a6b620e000000b006114b196ca8mr20995618iog.49.1647298235835;
        Mon, 14 Mar 2022 15:50:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g8-20020a056602248800b006409fb2cbccsm9036619ioe.32.2022.03.14.15.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 15:50:35 -0700 (PDT)
Date:   Mon, 14 Mar 2022 16:50:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Message-ID: <20220314165033.6d2291a5.alex.williamson@redhat.com>
In-Reply-To: <20220314194451.58266-16-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
        <20220314194451.58266-16-mjrosato@linux.ibm.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Mar 2022 15:44:34 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> s390x will introduce a new IOMMU domain type where the mappings are
> managed by KVM rather than in response to userspace mapping ioctls.  Allow
> for specifying this type on the VFIO_SET_IOMMU ioctl and triggering the
> appropriate iommu interface for overriding the default domain.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 12 +++++++++++-
>  include/uapi/linux/vfio.h       |  6 ++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 9394aa9444c1..0bec97077d61 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -77,6 +77,7 @@ struct vfio_iommu {
>  	bool			nesting;
>  	bool			dirty_page_tracking;
>  	bool			container_open;
> +	bool			kvm;
>  	struct list_head	emulated_iommu_groups;
>  };
>  
> @@ -2203,7 +2204,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		goto out_free_group;
>  
>  	ret = -EIO;
> -	domain->domain = iommu_domain_alloc(bus);
> +
> +	if (iommu->kvm)
> +		domain->domain = iommu_domain_alloc_type(bus, IOMMU_DOMAIN_KVM);
> +	else
> +		domain->domain = iommu_domain_alloc(bus);
> +
>  	if (!domain->domain)
>  		goto out_free_domain;
>  
> @@ -2552,6 +2558,9 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	case VFIO_TYPE1v2_IOMMU:
>  		iommu->v2 = true;
>  		break;
> +	case VFIO_KVM_IOMMU:
> +		iommu->kvm = true;
> +		break;
>  	default:
>  		kfree(iommu);
>  		return ERR_PTR(-EINVAL);
> @@ -2637,6 +2646,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  	case VFIO_TYPE1_NESTING_IOMMU:
>  	case VFIO_UNMAP_ALL:
>  	case VFIO_UPDATE_VADDR:
> +	case VFIO_KVM_IOMMU:
>  		return 1;
>  	case VFIO_DMA_CC_IOMMU:
>  		if (!iommu)
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..666edb6957ac 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -52,6 +52,12 @@
>  /* Supports the vaddr flag for DMA map and unmap */
>  #define VFIO_UPDATE_VADDR		10
>  
> +/*
> + * The KVM_IOMMU type implies that the hypervisor will control the mappings
> + * rather than userspace
> + */
> +#define VFIO_KVM_IOMMU			11

Then why is this hosted in the type1 code that exposes a wide variety
of userspace interfaces?  Thanks,

Alex

