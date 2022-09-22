Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021FE5E6E81
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 23:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiIVVin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 17:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiIVVil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 17:38:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8B610251A
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663882719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5JPX9T3GffPiHLyk9fM4X6AeVbPQqd4lfCm5aE7/aWU=;
        b=PzTD1CsgeBqiRU2GjWGTDZ85VD98loVDW0rBbEhQz9d/Vw34F4m9jOUY5fwbKhXlLpurUa
        2W1lBkCP9DrFb/RNO18q8qnkP05xfjefsmKkSUyaQcYLBoiJEkns8F6hABpip6SvARyDwp
        ynkxkxHxLR0jYyo0GHXXKUoXlEtG0dk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-kGCVXnEOMgieA0igRBNrqg-1; Thu, 22 Sep 2022 17:38:38 -0400
X-MC-Unique: kGCVXnEOMgieA0igRBNrqg-1
Received: by mail-qt1-f200.google.com with SMTP id u9-20020a05622a14c900b0035cc7e8cbaeso7346290qtx.19
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=5JPX9T3GffPiHLyk9fM4X6AeVbPQqd4lfCm5aE7/aWU=;
        b=XTLMY9QxrnTfr6Qg+Zs8yxPHsNk+w+7YNq4d1XmrVSDGgQsuC62GpfLn7S9gXla38x
         lzrdgbnvFpREaPTl1cd+QtZJBFAhpeXoe/9bv91XJ4/1PnK4kdK+TOSibzQWp3E+4nuN
         RaZmaSvkdyINR5KT9IKpoUu5WVRLtCDpNheGanuFJgSQdUd/MpMAhl/vAxa4aftdqFAR
         FqKR51zTzLAsy39UWp5vccMQ/yuAXnmoQWuOsBdnzDwT+2NB0TS9UVZtb3C4Qo/+KDbp
         44MDweTWMKr8KOhmhr1Vnf/eGgPSd5iFx1ylMA4WCLJPgsrtbUpXw56zMBX9Az7hBbDd
         wnhQ==
X-Gm-Message-State: ACrzQf0FGmrw8kGwwuAEKEf2ogFNPCBgXDmi3TErUonaDf1/rfRw1//5
        5d3DI+NF7Xa/BrmWivSnQJHI90Av6Ckq2TGeXYt7aWEOzRJ+avtvZrvZzx+S9e1dR9gV9am3Gey
        IZcLDTR0sZY79
X-Received: by 2002:a05:620a:4310:b0:6ac:f9df:178d with SMTP id u16-20020a05620a431000b006acf9df178dmr3774151qko.773.1663882716051;
        Thu, 22 Sep 2022 14:38:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4qBEL/j/DDcPndb3DepYOWe7ejxJsC+h3kQ6awmPMWBQWkJ+uc6sTX86CekI2Kuv9RnfMq2g==
X-Received: by 2002:a05:620a:4310:b0:6ac:f9df:178d with SMTP id u16-20020a05620a431000b006acf9df178dmr3774128qko.773.1663882715822;
        Thu, 22 Sep 2022 14:38:35 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id cp4-20020a05622a420400b0035cdd7a42d0sm3969804qtb.22.2022.09.22.14.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 14:38:35 -0700 (PDT)
Date:   Thu, 22 Sep 2022 17:38:33 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        gshan@redhat.com, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 1/6] KVM: Use acquire/release semantics when accessing
 dirty ring GFN state
Message-ID: <YyzV2Q/PZHPFMD6y@xz-m1.local>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220922170133.2617189-2-maz@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc,

On Thu, Sep 22, 2022 at 06:01:28PM +0100, Marc Zyngier wrote:
> The current implementation of the dirty ring has an implicit requirement
> that stores to the dirty ring from userspace must be:
> 
> - be ordered with one another
> 
> - visible from another CPU executing a ring reset
> 
> While these implicit requirements work well for x86 (and any other
> TSO-like architecture), they do not work for more relaxed architectures
> such as arm64 where stores to different addresses can be freely
> reordered, and loads from these addresses not observing writes from
> another CPU unless the required barriers (or acquire/release semantics)
> are used.
> 
> In order to start fixing this, upgrade the ring reset accesses:
> 
> - the kvm_dirty_gfn_harvested() helper now uses acquire semantics
>   so it is ordered after all previous writes, including that from
>   userspace
> 
> - the kvm_dirty_gfn_set_invalid() helper now uses release semantics
>   so that the next_slot and next_offset reads don't drift past
>   the entry invalidation
> 
> This is only a partial fix as the userspace side also need upgrading.

Paolo has one fix 4802bf910e ("KVM: dirty ring: add missing memory
barrier", 2022-09-01) which has already landed.

I think the other one to reset it was lost too.  I just posted a patch.

https://lore.kernel.org/qemu-devel/20220922213522.68861-1-peterx@redhat.com/
(link still not yet available so far, but should be)

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/dirty_ring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index f4c2a6eb1666..784bed80221d 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -79,12 +79,12 @@ static inline void kvm_dirty_gfn_set_invalid(struct kvm_dirty_gfn *gfn)
>  
>  static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
>  {
> -	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
> +	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_DIRTY);

IIUC you meant kvm_dirty_gfn_set_invalid as the comment says?

kvm_dirty_gfn_set_dirtied() has been guarded by smp_wmb() and AFAICT that's
already safe.  Otherwise looks good to me.

Thanks,

>  }
>  
>  static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>  {
> -	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
> +	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
>  }
>  
>  int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> -- 
> 2.34.1
> 

-- 
Peter Xu

