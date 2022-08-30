Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFDF5A6677
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 16:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiH3OmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 10:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiH3OmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 10:42:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD10DB95A0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 07:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661870541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+te87sYtTGczNabgaJy1Pj2NfLsGoso4jkdFkum7FlU=;
        b=b2/XSxWPaY3A0uZ0jqYq/654nxllL8+IPfWSjjRUkhh0kd9fpGJnD+Ysg7Qa3NlunJbFhY
        QDwi+iF5qO2XuOa4YVnMJMut8fsI3PMhG1vQp/wb7olTLQhB4n/GkKOL6khzVRgZq3yw3E
        3A23S9+0I3SosTABacwwk6lhfhniQtE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-uXIY6pn3OPSZZGxBCPHDzA-1; Tue, 30 Aug 2022 10:42:20 -0400
X-MC-Unique: uXIY6pn3OPSZZGxBCPHDzA-1
Received: by mail-qt1-f198.google.com with SMTP id z6-20020ac875c6000000b0034454b14c91so8947422qtq.15
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 07:42:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+te87sYtTGczNabgaJy1Pj2NfLsGoso4jkdFkum7FlU=;
        b=KFTVZDLFq5U2U4xhLXFPEkT9BXyWu1XQz86nsLFnCS+CzWL1I60lEh23BKVCPP6fP1
         F2VkOQmLCn7gb8J2AQQ5UhlHKh1GFYGm23SZSYGy7YjOxIHPzdbUiTO6gorQ51jIqQPN
         96AiTRyvYQfhWC3jcZHROwZwuJ0anRm/RTmPJvYJn4jh9VGzN24/+pTiBNcZquMWwHKn
         Bpb8AbAVad8QOBwjvYZACuMQR3+RRc+fpVSPF5QT/QrTEVkquMHbTtT8T+d5LRQbNjjo
         Jd/v4CU9SnEBcxCyO0j5X79/DCc9/sWl7yqaOG8/MHBgVW0ttWvdpO7XsNqWFJhQj05E
         RTBw==
X-Gm-Message-State: ACgBeo2Fd3tS9Nr7EwIfvcSAZkOAIfjKmh+D9iLQvgPsq0yfuG5qLcWp
        RSoI9pCAYcHYVeBa4DPJaZg5QW7A5JcDVdTE7sPxmuhB5YxgEH8G/ymbkW8SoQrKPyzURZD9RJc
        zICMHMvwUjHPD
X-Received: by 2002:a05:622a:1a0d:b0:343:6284:cbc8 with SMTP id f13-20020a05622a1a0d00b003436284cbc8mr15163346qtb.341.1661870540139;
        Tue, 30 Aug 2022 07:42:20 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6D8op/R0BZbn270yGLNeyiqE7221aPAIVz7ZsIkOvVsCOIjnQ86kAB8hellaaWH315TLq1vg==
X-Received: by 2002:a05:622a:1a0d:b0:343:6284:cbc8 with SMTP id f13-20020a05622a1a0d00b003436284cbc8mr15163320qtb.341.1661870539902;
        Tue, 30 Aug 2022 07:42:19 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b00339b8a5639csm7064707qts.95.2022.08.30.07.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 07:42:19 -0700 (PDT)
Date:   Tue, 30 Aug 2022 10:42:16 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org, corbet@lwn.net,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org,
        shuah@kernel.org, seanjc@google.com, drjones@redhat.com,
        dmatlack@google.com, bgardon@google.com, ricarkol@google.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory
 tracking
Message-ID: <Yw4hyEAyivKT35vQ@xz-m1.local>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com>
 <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org>
 <YwTn2r6FLCx9mAU7@google.com>
 <87a67uwve8.wl-maz@kernel.org>
 <99364855-b4e9-8a69-e1ca-ed09d103e4c8@redhat.com>
 <874jxzvxak.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <874jxzvxak.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022 at 04:28:51PM +0100, Marc Zyngier wrote:
> On Fri, 26 Aug 2022 11:58:08 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > On 8/23/22 22:35, Marc Zyngier wrote:
> > >> Heh, yeah I need to get that out the door. I'll also note that Gavin's
> > >> changes are still relevant without that series, as we do write unprotect
> > >> in parallel at PTE granularity after commit f783ef1c0e82 ("KVM: arm64:
> > >> Add fast path to handle permission relaxation during dirty logging").
> > > 
> > > Ah, true. Now if only someone could explain how the whole
> > > producer-consumer thing works without a trace of a barrier, that'd be
> > > great...
> > 
> > Do you mean this?
> >
> > void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
> 
> Of course not. I mean this:
> 
> static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
> {
> 	unsigned long i;
> 	struct kvm_vcpu *vcpu;
> 	int cleared = 0;
> 
> 	if (!kvm->dirty_ring_size)
> 		return -EINVAL;
> 
> 	mutex_lock(&kvm->slots_lock);
> 
> 	kvm_for_each_vcpu(i, vcpu, kvm)
> 		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
> [...]
> }
> 
> and this
> 
> int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> {
> 	u32 cur_slot, next_slot;
> 	u64 cur_offset, next_offset;
> 	unsigned long mask;
> 	int count = 0;
> 	struct kvm_dirty_gfn *entry;
> 	bool first_round = true;
> 
> 	/* This is only needed to make compilers happy */
> 	cur_slot = cur_offset = mask = 0;
> 
> 	while (true) {
> 		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> 
> 		if (!kvm_dirty_gfn_harvested(entry))
> 			break;
> [...]
> 
> }
> 
> which provides no ordering whatsoever when a ring is updated from one
> CPU and reset from another.

Marc,

I thought we won't hit this as long as we properly take care of other
orderings of (a) gfn push, and (b) gfn collect, but after a second thought
I think it's indeed logically possible that with a reversed ordering here
we can be reading some garbage gfn before (a) happens butt also read the
valid flag after (b).

It seems we must have all the barriers correctly applied always.  If that's
correct, do you perhaps mean something like this to just add the last piece
of barrier?

===8<===
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index f4c2a6eb1666..ea620bfb012d 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -84,7 +84,7 @@ static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
 
 static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
 {
-       return gfn->flags & KVM_DIRTY_GFN_F_RESET;
+       return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
 }
 
 int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
===8<===

Thanks,

-- 
Peter Xu

