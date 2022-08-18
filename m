Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4886598D90
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 22:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345490AbiHRUN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 16:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345916AbiHRUNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 16:13:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368F1B8A4D
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 13:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660853463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qF9mwdX42Z4XttzFYrU1Z9fWJ/vdaMjVOtdzop5CgMc=;
        b=DaOIYBw50dLHT/dC+TYGoSIEwqcOM6S3JO4XyDi0EYH87YOnapJ0gXMA4wS96Q7MhvIlQb
        sh8Oa/SvczE7pwiCumdkjrrFLan2zeVpsCADNS7/2jEBR7ZdNiDrTRDOGjRVvqHktL/jzL
        eag1CqHxLQqCXtF3jdDviV8u9fl9Ko4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-507-4TY-LmnrPrGyfRfJVkrkqQ-1; Thu, 18 Aug 2022 16:04:59 -0400
X-MC-Unique: 4TY-LmnrPrGyfRfJVkrkqQ-1
Received: by mail-qk1-f199.google.com with SMTP id bl27-20020a05620a1a9b00b0069994eeb30cso2254419qkb.11
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 13:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=qF9mwdX42Z4XttzFYrU1Z9fWJ/vdaMjVOtdzop5CgMc=;
        b=eQyBzOLzgW9N35HBVisNdekKqpUYJk+/o0Ua++nsQPmuCiKSns3Ep9q7tAzP7IfiB4
         YP4FDvTh5JcTOTmQA4LyvftxuC9RSUoiS0gCB4gsuriwGE/IXKfjZDZYVT+KMJ0r2E4b
         yqaGlgfb7i3+0RE/Rvy+MAWKFkVcKPbiCZZc5MYFoKL9mqyDedb6FqKnXViKiwbC2vYx
         GNnQOaMSfvM+M1w3vmCEEJg3mbkc1oSlRMLe980JapR3TWLKDA1FtBMP+7457Ye+b7wa
         kLcygsnooH8mm8FxPbGxw9anfdrfQVmAMnLSfDG75BAk5AMAI4dEwyaEEioXYH9qWVK9
         /0kQ==
X-Gm-Message-State: ACgBeo13Wfswq9TK4BLvESeTH59Ixw8bmuvv70YX9cLrG8DbF4epfcgc
        rsct6OiTwbhXfqhogApOZz2drmBrL0qtTjTn8IltauXxKH0s8dK9UMZeDoA7jzGl9sUkAYgH4fD
        WzYho/MiXvHrI
X-Received: by 2002:a05:6214:d6c:b0:476:94f5:aa7b with SMTP id 12-20020a0562140d6c00b0047694f5aa7bmr3895816qvs.92.1660853098552;
        Thu, 18 Aug 2022 13:04:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6O9zlcJ/KMtTjIyEYwAveSzfMEIkT91qHws4tgXti0bKMuujrPu5MosTDghM+a6G4Jrn/kBw==
X-Received: by 2002:a05:6214:d6c:b0:476:94f5:aa7b with SMTP id 12-20020a0562140d6c00b0047694f5aa7bmr3895774qvs.92.1660853098131;
        Thu, 18 Aug 2022 13:04:58 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id bm30-20020a05620a199e00b006bb11f9a859sm2185725qkb.122.2022.08.18.13.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:04:57 -0700 (PDT)
Date:   Thu, 18 Aug 2022 16:04:56 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Leonardo Bras Soares Passos <lsoaresp@redhat.com>
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay
 kvm_vm_ioctl to the commit phase
Message-ID: <Yv6baJoNikyuZ38R@xz-m1.local>
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220816101250.1715523-3-eesposit@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 06:12:50AM -0400, Emanuele Giuseppe Esposito wrote:
> +static void kvm_memory_region_node_add(KVMMemoryListener *kml,
> +                                       struct kvm_userspace_memory_region *mem)
> +{
> +    MemoryRegionNode *node;
> +
> +    node = g_malloc(sizeof(MemoryRegionNode));
> +    *node = (MemoryRegionNode) {
> +        .mem = mem,
> +    };

Nit: direct assignment of struct looks okay, but maybe pointer assignment
is clearer (with g_malloc0?  Or iirc we're suggested to always use g_new0):

  node = g_new0(MemoryRegionNode, 1);
  node->mem = mem;

[...]

> +/* for KVM_SET_USER_MEMORY_REGION_LIST */
> +struct kvm_userspace_memory_region_list {
> +	__u32 nent;
> +	__u32 flags;
> +	struct kvm_userspace_memory_region entries[0];
> +};
> +
>  /*
>   * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
>   * other bits are reserved for kvm internal use which are defined in
> @@ -1426,6 +1433,8 @@ struct kvm_vfio_spapr_tce {
>  					struct kvm_userspace_memory_region)
>  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
>  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> +#define KVM_SET_USER_MEMORY_REGION_LIST _IOW(KVMIO, 0x49, \
> +					struct kvm_userspace_memory_region_list)

I think this is probably good enough, but just to provide the other small
(but may not be important) piece of puzzle here.  I wanted to think through
to understand better but I never did..

For a quick look, please read the comment in kvm_set_phys_mem().

                /*
                 * NOTE: We should be aware of the fact that here we're only
                 * doing a best effort to sync dirty bits.  No matter whether
                 * we're using dirty log or dirty ring, we ignored two facts:
                 *
                 * (1) dirty bits can reside in hardware buffers (PML)
                 *
                 * (2) after we collected dirty bits here, pages can be dirtied
                 * again before we do the final KVM_SET_USER_MEMORY_REGION to
                 * remove the slot.
                 *
                 * Not easy.  Let's cross the fingers until it's fixed.
                 */

One example is if we have 16G mem, we enable dirty tracking and we punch a
hole of 1G at offset 1G, it'll change from this:

                     (a)
  |----------------- 16G -------------------|

To this:

     (b)    (c)              (d)
  |--1G--|XXXXXX|------------14G------------|

Here (c) will be a 1G hole.

With current code, the hole punching will del region (a) and add back
region (b) and (d).  After the new _LIST ioctl it'll be atomic and nicer.

Here the question is if we're with dirty tracking it means for each region
we have a dirty bitmap.  Currently we do the best effort of doing below
sequence:

  (1) fetching dirty bmap of (a)
  (2) delete region (a)
  (3) add region (b) (d)

Here (a)'s dirty bmap is mostly kept as best effort, but still we'll lose
dirty pages written between step (1) and (2) (and actually if the write
comes within (2) and (3) I think it'll crash qemu, and iiuc that's what
we're going to fix..).

So ideally the atomic op can be:

  "atomically fetch dirty bmap for removed regions, remove regions, and add
   new regions"

Rather than only:

  "atomically remove regions, and add new regions"

as what the new _LIST ioctl do.

But... maybe that's not a real problem, at least I didn't know any report
showing issue with current code yet caused by losing of dirty bits during
step (1) and (2).  Neither do I know how to trigger an issue with it.

I'm just trying to still provide this information so that you should be
aware of this problem too, at the meantime when proposing the new ioctl
change for qemu we should also keep in mind that we won't easily lose the
dirty bmap of (a) here, which I think this patch does the right thing.

Thanks!

--
Peter Xu

