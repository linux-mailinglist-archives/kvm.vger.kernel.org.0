Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1896168D5
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiKBQ3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiKBQ3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:29:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928305585
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667406200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5byMHFaExyjDBXydjU2vjfyJkptyvIyynTJvAWyAxJc=;
        b=DdYoU46mosBTy9xZVhbLcrXfMTN3YbXAdo4hWgnkjqAGRB/tgQJLKGv3Z7xKTqE59D20sy
        oLpRhZ2RIXPIJHAwBF6ZWfm9Tcqkpm84wpKBN8J0SmEUIPZ5qgF8iqVEWFVygaQgjDlxbu
        2qtvpjMoEg5fR2U+dKZsrX6557ZlnfY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-258-nM23SX3oN96fuYa6jXAB9w-1; Wed, 02 Nov 2022 12:23:19 -0400
X-MC-Unique: nM23SX3oN96fuYa6jXAB9w-1
Received: by mail-qk1-f197.google.com with SMTP id j13-20020a05620a288d00b006be7b2a758fso15453284qkp.1
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5byMHFaExyjDBXydjU2vjfyJkptyvIyynTJvAWyAxJc=;
        b=dmnOdszhwe/Lp56B7RiP7EMd4D2VwNigFJKdETmRW5Kv3FEdci1ISFxKS8N1w5m9Cf
         I8ZPU3tQ5oMylQyAGNVtVDzST5sIqcNUR2MIeKQtqy5Sdad3zVMYzZzROxwczWuLrDJ0
         LI652KQ5QNEuTrlP+dcISgMI9sJmrv3atlwpPlW73rPhKxT9FdeTp5q+UGnQ6ViQAIVH
         z3t8oIpDIvOqd+zhCRQtegT7kBmj4m7Q+tp0xV/NucWCRmsLYptCU7W8zFNbjGVvXgnK
         5VZKmNsKSfE2Xb2TcEhYwuRiJetgaJ2dKV1nSvTt5amORmbcbm7WKS6C+szA6Q8WAeJk
         R04w==
X-Gm-Message-State: ACrzQf0ITbly8u/Tc+hFv7Drsyy1x8RlIz/JUJdQJ1eonVsOH95oHEMz
        H2ZBWa9AQ2znznNFG22LqHzz6ufido+HNndT2duhwO8Z8i6Deya0gHb+N+wWXEuJUr6/WPGXLP0
        NNM6wmGeZuqc7
X-Received: by 2002:a05:622a:ca:b0:3a5:24d2:9295 with SMTP id p10-20020a05622a00ca00b003a524d29295mr14748789qtw.300.1667406199200;
        Wed, 02 Nov 2022 09:23:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6EpjURP1I5j6n6rF3l05q9tySy58y2y7M9A2JRR097icY3iLQyUWI+2g5g7C6S/Ehg5hZGpQ==
X-Received: by 2002:a05:622a:ca:b0:3a5:24d2:9295 with SMTP id p10-20020a05622a00ca00b003a524d29295mr14748754qtw.300.1667406198900;
        Wed, 02 Nov 2022 09:23:18 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id s16-20020a05620a255000b006ee7923c187sm8903281qko.42.2022.11.02.09.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:23:18 -0700 (PDT)
Date:   Wed, 2 Nov 2022 12:23:16 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, catalin.marinas@arm.com, dmatlack@google.com,
        will@kernel.org, pbonzini@redhat.com, oliver.upton@linux.dev,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2KZdDAQN4889W9V@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <867d0de4b0.wl-maz@kernel.org>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 03:58:43PM +0000, Marc Zyngier wrote:
> On Wed, 02 Nov 2022 14:29:26 +0000,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Tue, Nov 01, 2022 at 07:39:25PM +0000, Sean Christopherson wrote:
> > > > @@ -142,13 +144,17 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > > >  
> > > >  	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > > >  
> > > > +	if (!kvm_dirty_ring_soft_full(ring))
> > > > +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> > > > +
> > > 
> > > Marc, Peter, and/or Paolo, can you confirm that clearing the
> > > request here won't cause ordering problems?  Logically, this makes
> > > perfect sense (to me, since I suggested it), but I'm mildly
> > > concerned I'm overlooking an edge case where KVM could end up with
> > > a soft-full ring but no pending request.
> > 
> > I don't see an ordering issue here, as long as kvm_clear_request() is using
> > atomic version of bit clear, afaict that's genuine RMW and should always
> > imply a full memory barrier (on any arch?) between the soft full check and
> > the bit clear.  At least for x86 the lock prefix was applied.
> 
> No, clear_bit() is not a full barrier. It only atomic, and thus
> completely unordered (see Documentation/atomic_bitops.txt). If you
> want a full barrier, you need to use test_and_clear_bit().

Right, I mixed it up again. :(  It's genuine RMW indeed (unlike _set/_read)
but I forgot it needs to have a retval to have the memory barriers.

Quotting atomic_t.rst:

---8<---
ORDERING  (go read memory-barriers.txt first)
--------

The rule of thumb:

 - non-RMW operations are unordered;

 - RMW operations that have no return value are unordered;

 - RMW operations that have a return value are fully ordered;

 - RMW operations that are conditional are unordered on FAILURE,
   otherwise the above rules apply.
---8<---

Bit clear unordered.

> 
> > 
> > However I don't see anything stops a simple "race" to trigger like below:
> > 
> >           recycle thread                   vcpu thread
> >           --------------                   -----------
> >       if (!dirty_ring_soft_full)                                   <--- not full
> >                                         dirty_ring_push();
> >                                         if (dirty_ring_soft_full)  <--- full due to the push
> >                                             set_request(SOFT_FULL);
> >           clear_request(SOFT_FULL);                                <--- can wrongly clear the request?
> >
> 
> Hmmm, well spotted. That's another ugly effect of the recycle thread
> playing with someone else's toys.
> 
> > But I don't think that's a huge matter, as it'll just let the vcpu to have
> > one more chance to do another round of KVM_RUN.  Normally I think it means
> > there can be one more dirty GFN (perhaps there're cases that it can push >1
> > gfns for one KVM_RUN cycle?  I never figured out the details here, but
> > still..) pushed to the ring so closer to the hard limit, but we have had a
> > buffer zone of KVM_DIRTY_RING_RSVD_ENTRIES (64) entries.  So I assume
> > that's still fine, but maybe worth a short comment here?
> > 
> > I never know what's the maximum possible GFNs being dirtied for a KVM_RUN
> > cycle.  It would be good if there's an answer to that from anyone.
> 
> This is dangerous, and I'd rather not go there.
> 
> It is starting to look like we need the recycle thread to get out of
> the way. And to be honest:
> 
> +	if (!kvm_dirty_ring_soft_full(ring))
> +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> 
> seems rather superfluous. Only clearing the flag in the vcpu entry
> path feels much saner, and I can't see anything that would break.
> 
> Thoughts?

Sounds good here.

Might be slightly off-topic: I didn't quickly spot how do we guarantee two
threads doing KVM_RUN ioctl on the same vcpu fd concurrently.  I know
that's insane and could have corrupted things, but I just want to make sure
e.g. even a malicious guest app won't be able to trigger host warnings.

-- 
Peter Xu

