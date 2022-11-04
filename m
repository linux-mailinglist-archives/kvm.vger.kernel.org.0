Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B35461A1FD
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 21:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiKDUPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 16:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKDUPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 16:15:10 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359D930F77
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:15:08 -0700 (PDT)
Date:   Fri, 4 Nov 2022 20:12:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667592767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e1MPhNwvfG4enmJTG4TrEJFHNNzuRv9rFUtE3O6Q7fQ=;
        b=UdfYU32+A3e2WuPMtlWhM79eOtsaVNdMBblK1AnJ7zGMgHIWpWD0/BOJkU4Th/r6giXD0d
        6W72w9Dze+eqzJHt5FAtlqYfeISDy1r5dzSyrFKVWDDxWxst1wH0Vhs98qaQmZ2zes2cAw
        GaDjgSMTUdryq6i49X0zgHyo7fZjTU4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2VyMwAlg7U9pXzV@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
 <Y2RPhwIUsGLQ2cz/@google.com>
 <d5b86a73-e030-7ce3-e5f3-301f4f505323@redhat.com>
 <Y2RlfkyQMCtD6Rbh@google.com>
 <d7e45de0-bff6-7d8c-4bf4-1a09e8acb726@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7e45de0-bff6-7d8c-4bf4-1a09e8acb726@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022 at 02:57:15PM +0800, Gavin Shan wrote:
> On 11/4/22 9:06 AM, Oliver Upton wrote:

[...]

> > Just to make sure we're on the same page, there's two issues:
> > 
> >   (1) If DIRTY_LOG_RING is enabled before memslot creation and
> >       RING_WITH_BITMAP is enabled after memslots have been created w/
> >       dirty logging enabled, memslot->dirty_bitmap == NULL and the
> >       kernel will fault when attempting to save the ITS tables.
> > 
> >   (2) Not your code, but a similar issue. If DIRTY_LOG_RING[_ACQ_REL] is
> >       enabled after memslots have been created w/ dirty logging enabled,
> >       memslot->dirty_bitmap != NULL and that memory is wasted until the
> >       memslot is freed.
> > 
> > I don't expect you to fix #2, though I've mentioned it because using the
> > same approach to #1 and #2 would be nice.
> > 
> 
> Yes, I got your points. Case (2) is still possible to happen with QEMU
> excluded. However, QEMU is always enabling DIRTY_LOG_RING[_ACQ_REL] before
> any memory slot is created. I agree that we need to ensure there are no
> memory slots when DIRTY_LOG_RING[_ACQ_REL] is enabled.
> 
> For case (1), we can ensure RING_WTIH_BITMAP is enabled before any memory
> slot is added, as below. QEMU needs a new helper (as above) to enable it
> on board's level.
> 
> Lets fix both with a new helper in PATCH[v8 4/9] like below?

I agree that we should address (1) like this, but in (2) requiring that
no memslots were created before enabling the existing capabilities would
be a change in ABI. If we can get away with that, great, but otherwise
we may need to delete the bitmaps associated with all memslots when the
cap is enabled.

>   static inline bool kvm_vm_has_memslot_pages(struct kvm *kvm)
>   {
>       bool has_memslot_pages;
> 
>       mutex_lock(&kvm->slots_lock);
> 
>       has_memslot_pages = !!kvm->nr_memslot_pages;
> 
>       mutex_unlock(&kvm->slots_lock);
> 
>       return has_memslot_pages;
>   }

Do we need to build another helper for this? kvm_memslots_empty() will
tell you whether or not a memslot has been created by checking the gfn
tree.

On top of that, the memslot check and setting
kvm->dirty_ring_with_bitmap must happen behind the slots_lock. Otherwise
you could still wind up creating memslots w/o bitmaps.


Something like:


diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 91cf51a25394..420cc101a16e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4588,6 +4588,32 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 			return -EINVAL;
 
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
+
+	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
+		struct kvm_memslots *slots;
+		int r = -EINVAL;
+
+		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
+		    !kvm->dirty_ring_size)
+			return r;
+
+		mutex_lock(&kvm->slots_lock);
+
+		slots = kvm_memslots(kvm);
+
+		/*
+		 * Avoid a race between memslot creation and enabling the ring +
+		 * bitmap capability to guarantee that no memslots have been
+		 * created without a bitmap.
+		 */
+		if (kvm_memslots_empty(slots)) {
+			kvm->dirty_ring_with_bitmap = cap->args[0];
+			r = 0;
+		}
+
+		mutex_unlock(&kvm->slots_lock);
+		return r;
+	}
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}

--
Thanks,
Oliver
