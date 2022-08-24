Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA7259FF63
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 18:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbiHXQWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 12:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238489AbiHXQV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 12:21:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046F89A9D2
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 09:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661358115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wANo/GHMzT757gDMJMmO8LCL5UwXYQqWDiktVytCe74=;
        b=Kzsrnw1+6zStgXAsbc3aZVeaJSM381+AJb8kJT5TXV3MTJJ2rx2nDG09SCzyDrXFCUCo4x
        t3R4wy519d0hD8ee+cthDPImBCzKwz1h98v6fap6zYqCImc5Va+ixP+QgvkCh8YuFXIV4B
        S5AFhppxyR+IIO8pjctoxGcefmkVPZE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-622-qLpIl7rcMwm5x2l-S9ahag-1; Wed, 24 Aug 2022 12:21:53 -0400
X-MC-Unique: qLpIl7rcMwm5x2l-S9ahag-1
Received: by mail-qv1-f71.google.com with SMTP id l10-20020ad44bca000000b0049664e99a57so9933248qvw.17
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 09:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=wANo/GHMzT757gDMJMmO8LCL5UwXYQqWDiktVytCe74=;
        b=oKKZdqqrtslMRGxfhZPDiHXQIeYNNyfASmm3gpimoYDlzDGddanZn4BC6BCqHgowA7
         hTU29DS1IBqir1+pCRoVwpl82bTt5KKhJh1V2M0egbTojntJfdnXpanUHFOkOIpLQhuF
         1OPkKCOXYHq6eHu3vfSKfOS1gWy+49FmE9F6rWYuvIUV7QksxHRUyqRjMd5eudTKlRjm
         oLGf+0j8yopELtJsE9/SjEsOxJWxbFdpLutDONj7edSYDMco5bTAaOaM4c/VuurmprrS
         y8LHka0qdTSs7mbbL5dp4LoXaje3ktoxJKPxTEX78HsGy05SUINGBnvIsbNYfoWWvTpT
         WCeA==
X-Gm-Message-State: ACgBeo248fcrbqW2vTQ2NGCdkzlJyagjpX6i9cBgny/RdihFNpniEhjZ
        d+1McIh5OGsmKGzts7fokxMXHHa4LGuY5oIiM2PmRDYgZvlxN6fojTT1D5lik/0UrxLJZDbRKqa
        3DhDGmf8F9LBt
X-Received: by 2002:a05:6214:d86:b0:496:e991:c4a9 with SMTP id e6-20020a0562140d8600b00496e991c4a9mr12630961qve.129.1661358113266;
        Wed, 24 Aug 2022 09:21:53 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6Qvk99CLgme2nXiMZvw3XJHeABpevFZgbSFRX695IhCdFipklBVIAy26zO9TEdi8UNpCj9Zg==
X-Received: by 2002:a05:6214:d86:b0:496:e991:c4a9 with SMTP id e6-20020a0562140d8600b00496e991c4a9mr12630908qve.129.1661358112949;
        Wed, 24 Aug 2022 09:21:52 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id j4-20020a05620a0a4400b006b905e003a4sm15116119qka.135.2022.08.24.09.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:21:52 -0700 (PDT)
Date:   Wed, 24 Aug 2022 12:21:50 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        corbet@lwn.net, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        seanjc@google.com, dmatlack@google.com, bgardon@google.com,
        ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory
 tracking
Message-ID: <YwZQHqS5DZBloYPZ@xz-m1.local>
References: <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org>
 <171d0159-4698-354b-8b2f-49d920d03b1b@redhat.com>
 <YwTc++Lz6lh3aR4F@xz-m1.local>
 <87bksawz0w.wl-maz@kernel.org>
 <YwVEoM1pj2MPCELp@xz-m1.local>
 <878rnewpaw.wl-maz@kernel.org>
 <YwVgaGp3HOGzC8k2@xz-m1.local>
 <87y1vdr98o.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87y1vdr98o.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 03:45:11PM +0100, Marc Zyngier wrote:
> On Wed, 24 Aug 2022 00:19:04 +0100,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Tue, Aug 23, 2022 at 11:47:03PM +0100, Marc Zyngier wrote:
> > > On Tue, 23 Aug 2022 22:20:32 +0100,
> > > Peter Xu <peterx@redhat.com> wrote:
> > > > 
> > > > On Tue, Aug 23, 2022 at 08:17:03PM +0100, Marc Zyngier wrote:
> > > > > I don't think we really need this check on the hot path. All we need
> > > > > is to make the request sticky until userspace gets their act together
> > > > > and consumes elements in the ring. Something like:
> > > > > 
> > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > index 986cee6fbc7f..e8ed5e1af159 100644
> > > > > --- a/arch/arm64/kvm/arm.c
> > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > @@ -747,6 +747,14 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> > > > >  
> > > > >  		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> > > > >  			return kvm_vcpu_suspend(vcpu);
> > > > > +
> > > > > +		if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
> > > > > +		    kvm_dirty_ring_soft_full(vcpu)) {
> > > > > +			kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> > > > > +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
> > > > > +			trace_kvm_dirty_ring_exit(vcpu);
> > > > > +			return 0;
> > > > > +		}
> > > > >  	}
> > > > >  
> > > > >  	return 1;
> > > > 
> > > > Right, this seems working.  We can also use kvm_test_request() here.
> > > > 
> > > > > 
> > > > > 
> > > > > However, I'm a bit concerned by the reset side of things. It iterates
> > > > > over the vcpus and expects the view of each ring to be consistent,
> > > > > even if userspace is hacking at it from another CPU. For example, I
> > > > > can't see what guarantees that the kernel observes the writes from
> > > > > userspace in the order they are being performed (the documentation
> > > > > provides no requirements other than "it must collect the dirty GFNs in
> > > > > sequence", which doesn't mean much from an ordering perspective).
> > > > > 
> > > > > I can see that working on a strongly ordered architecture, but on
> > > > > something as relaxed as ARM, the CPUs may^Wwill aggressively reorder
> > > > > stuff that isn't explicitly ordered. I have the feeling that a CAS
> > > > > operation on both sides would be enough, but someone who actually
> > > > > understands how this works should have a look...
> > > > 
> > > > I definitely don't think I 100% understand all the ordering things since
> > > > they're complicated.. but my understanding is that the reset procedure
> > > > didn't need memory barrier (unlike pushing, where we have explicit wmb),
> > > > because we assumed the userapp is not hostile so logically it should only
> > > > modify the flags which is a 32bit field, assuming atomicity guaranteed.
> > > 
> > > Atomicity doesn't guarantee ordering, unfortunately.
> > 
> > Right, sorry to be misleading.  The "atomicity" part I was trying to say
> > the kernel will always see consistent update on the fields.
> >
> > The ordering should also be guaranteed, because things must happen with
> > below sequence:
> > 
> >   (1) kernel publish dirty GFN data (slot, offset)
> >   (2) kernel publish dirty GFN flag (set to DIRTY)
> >   (3) user sees DIRTY, collects (slots, offset)
> >   (4) user sets it to RESET
> >   (5) kernel reads RESET
> 
> Maybe. Maybe not. The reset could well be sitting in the CPU write
> buffer for as long as it wants and not be seen by the kernel if the
> read occurs on another CPU. And that's the crucial bit: single-CPU is
> fine, but cross CPU isn't. Unfortunately, the userspace API is per-CPU
> on collection, and global on reset (this seems like a bad decision,
> but it is too late to fix this).

Regarding the last statement, that's something I had question too and
discussed with Paolo, even though at that time it's not a outcome of
discussing memory ordering issues.

IIUC the initial design was trying to avoid tlb flush flood when vcpu
number is large (each RESET per ring even for one page will need all vcpus
to flush, so O(N^2) flushing needed).  With global RESET it's O(N).  So
it's kind of a trade-off, and indeed until now I'm not sure which one is
better.  E.g., with per-ring reset, we can have locality too in userspace,
e.g. the vcpu thread might be able to recycle without holding global locks.

Regarding safety I hope I covered that below in previous reply.

> 
> > 
> > So the ordering of single-entry is guaranteed in that when (5) happens it
> > must be after stablized (1+2).
> > 
> > > Take the
> > > following example: CPU0 is changing a bunch of flags for GFNs A, B, C,
> > > D that exist in the ring in that order, and CPU1 performs an ioctl to
> > > reset the page state.
> > > 
> > > CPU0:
> > >     write_flag(A, KVM_DIRTY_GFN_F_RESET)
> > >     write_flag(B, KVM_DIRTY_GFN_F_RESET)
> > >     write_flag(C, KVM_DIRTY_GFN_F_RESET)
> > >     write_flag(D, KVM_DIRTY_GFN_F_RESET)
> > >     [...]
> > > 
> > > CPU1:
> > >    ioctl(KVM_RESET_DIRTY_RINGS)
> > > 
> > > Since CPU0 writes do not have any ordering, CPU1 can observe the
> > > writes in a sequence that have nothing to do with program order, and
> > > could for example observe that GFN A and D have been reset, but not B
> > > and C. This in turn breaks the logic in the reset code (B, C, and D
> > > don't get reset), despite userspace having followed the spec to the
> > > letter. If each was a store-release (which is the case on x86), it
> > > wouldn't be a problem, but nothing calls it in the documentation.
> > > 
> > > Maybe that's not a big deal if it is expected that each CPU will issue
> > > a KVM_RESET_DIRTY_RINGS itself, ensuring that it observe its own
> > > writes. But expecting this to work across CPUs without any barrier is
> > > wishful thinking.
> > 
> > I see what you meant...
> > 
> > Firstly I'm actually curious whether that'll really happen if the gfns are
> > collected in something like a for loop:
> > 
> >   for(i = 0; i < N; i++)
> >     collect_dirty_gfn(ring, i);
> > 
> > Because since all the gfps to be read will depend on variable "i", IIUC no
> > reordering should happen, but I'm not really sure, so more of a pure
> > question.
> 
> 'i' has no influence on the write ordering. Each write targets a
> different address, there is no inter-write dependencies (this concept
> doesn't exist other than for writes to the same address), so they can
> be reordered at will.
> 
> If you want a proof of this, head to http://diy.inria.fr/www/ and run
> the MP.litmus test (which conveniently gives you a reduction of this
> problem) on both the x86 and AArch64 models. You will see that the
> reordering isn't allowed on x86, but definitely allowed on arm64.
> 
> > Besides, the other thing to mention is that I think it is fine the RESET
> > ioctl didn't recycle all the gfns got set to reset state.  Taking above
> > example of GFNs A-D, if when reaching the RESET ioctl only A & D's flags
> > are updated, the ioctl will recycle gfn A but stop at gfn B assuming B-D
> > are not reset.  But IMHO it's okay because it means we reset partial of the
> > gfns not all of them, and it's safe to do so.  It means the next ring full
> > event can come earlier because we recycled less, but that's functionally
> > safe to me.
> 
> It may be safe, but it isn't what the userspace API promises.

The document says:

  After processing one or more entries in the ring buffer, userspace calls
  the VM ioctl KVM_RESET_DIRTY_RINGS to notify the kernel about it, so that
  the kernel will reprotect those collected GFNs.  Therefore, the ioctl
  must be called *before* reading the content of the dirty pages.

I'd say it's not an explicit promise, but I think I agree with you that at
least it's unclear on the behavior.

Since we have a global recycle mechanism, most likely the app (e.g. current
qemu impl) will use the same thread to collect/reset dirty GFNs, and
trigger the RESET ioctl().  In that case it's safe, IIUC, because no
cross-core ops.

QEMU even guarantees this by checking it (kvm_dirty_ring_reap_locked):

    if (total) {
        ret = kvm_vm_ioctl(s, KVM_RESET_DIRTY_RINGS);
        assert(ret == total);
    }

I think the assert() should never trigger as mentioned above.  But ideally
maybe it should just be a loop until cleared gfns match total.

> In other words, without further straightening of the API, this doesn't
> work as expected on relaxed memory architectures. So before this gets
> enabled on arm64, this whole ordering issue must be addressed.

How about adding some more documentation for KVM_RESET_DIRTY_RINGS on the
possibility of recycling partial of the pages, especially when collection
and the ioctl() aren't done from the same thread?

Any suggestions will be greatly welcomed.

Thanks,

-- 
Peter Xu

