Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB0260FF86
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 19:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiJ0RpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 13:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiJ0Ro6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 13:44:58 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4789724099
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 10:44:56 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id io19so2288210plb.8
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 10:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q5c4/+RxPj63577Cu1nifyDq83AUirvqoeSZewd7dIg=;
        b=S4cOj3RJR3KlfSSTVpWantzeoh1YFXAN4WpGbDxghDi4XuxFuN5Esc5cYHQIlN34qT
         CzL7/bbQp18QzSLOK7OHVHdjdHdDF6aHPxX6wahjuNh4Fz8yh8XYEkmb6udcHthyJPVn
         1ZNqJrKYE7s0irC3dUkr1gSsBBVvMvRU7tixYF1iOQ/uUdVpdkn4czh6TorZE1cdQ0Gb
         vWAheqJhK1LCA6uYqc+EZ89IyncuoBUZWJ8kN8nDMnYOtiShaY4fp0EvRdzB2o8sUiWd
         gyN7VdqESv2E9rtfRWuRKHCQ89x8xENTU1w4ASJWUwDA9cfEUaeZANZGKnltm8bBigAU
         uR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5c4/+RxPj63577Cu1nifyDq83AUirvqoeSZewd7dIg=;
        b=aZsfW7/FpNkzLtpz56dYBjraUL75GChfauhSY7n+iNs6wVwMsgadMr25zIvaeyVG30
         pqIUDk1FMVgPRTMWED6IGIOCqvlka5NGCesfAJLMep4pEtSh4Sr5m84fhbHymzdPUbvT
         hgMZDqKbSgvXP1t98vO4qCP5yporQpFwms6SONrKuh8TGMYs2ZnoPzXV3LfZ0Sg4fFgK
         kCsIcDKLFmS4DpstHWuVkdxX2yuqycc7iPRX5CpgW/qts3tQAiC0afe341YetbkqbIn+
         WrXd/yyeMWBAisG/fPH9KlXTqcTv+IUOcRExvx4E0JxyWPhPB9pUdriRnHA5isP6/84X
         wE4Q==
X-Gm-Message-State: ACrzQf0mXSk7D+vDACOY92OdEXW9CSBJ7ER6A71FMjf1HZk2JDVjo+TR
        GL0NPhWLiVnwzC6z4nsJ9yYRpQ==
X-Google-Smtp-Source: AMsMyM7G6q7BzXM3ZQI4nRtOz8jjvF+NAsGCL1JUEV6PD+ITzkr1az8n26v3M5B4mb3+kD4l+1Zmaw==
X-Received: by 2002:a17:903:120d:b0:178:a6ca:b974 with SMTP id l13-20020a170903120d00b00178a6cab974mr49920600plh.8.1666892695634;
        Thu, 27 Oct 2022 10:44:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s15-20020a170902b18f00b00185002f0c6csm1456085plr.134.2022.10.27.10.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 10:44:55 -0700 (PDT)
Date:   Thu, 27 Oct 2022 17:44:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
        bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1rDkz6q8+ZgYFWW@google.com>
References: <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com>
 <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
 <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org>
 <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d0lhdo9.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022, Marc Zyngier wrote:
> On Tue, 25 Oct 2022 18:47:12 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > Call us incompetent, but I have zero confidence that KVM will never
> > unintentionally add a path that invokes mark_page_dirty_in_slot()
> > without a running vCPU.
> 
> Well, maybe it is time that KVM acknowledges there is a purpose to
> dirtying memory outside of a vcpu context, and that if a write happens
> in a vcpu context, this vcpu must be explicitly passed down rather
> than obtained from kvm_get_running_vcpu(). Yes, this requires some
> heavy surgery.

Heh, preaching to the choir on this one.

  On Mon, Dec 02, 2019 at 12:10:36PM -0800, Sean Christopherson wrote:
  > IMO, adding kvm_get_running_vcpu() is a hack that is just asking for future
  > abuse and the vcpu/vm/as_id interactions in mark_page_dirty_in_ring() look
  > extremely fragile.

I'm all in favor of not using kvm_get_running_vcpu() in this path.

That said, it's somewhat of an orthogonal issue, as I would still want a sanity
check in mark_page_dirty_in_slot() that a vCPU is provided when there is no
dirty bitmap.

> > By completely dropping the rule that KVM must have an active vCPU on
> > architectures that support ring+bitmap, those types of bugs will go
> > silently unnoticed, and will manifest as guest data corruption after
> > live migration.
> 
> The elephant in the room is still userspace writing to its view of the
> guest memory for device emulation. Do they get it right? I doubt it.

I don't see what that has to do with KVM though.  There are many things userspace
needs to get right, that doesn't mean that KVM shouldn't strive to provide
safeguards for the functionality that KVM provides.

> > And ideally such bugs would detected without relying on userspace to
> > enabling dirty logging, e.g. the Hyper-V bug lurked for quite some
> > time and was only found when mark_page_dirty_in_slot() started
> > WARNing.
> > 
> > I'm ok if arm64 wants to let userspace shoot itself in the foot with
> > the ITS, but I'm not ok dropping the protections in the common
> > mark_page_dirty_in_slot().
> > 
> > One somewhat gross idea would be to let architectures override the
> > "there must be a running vCPU" rule, e.g. arm64 could toggle a flag
> > in kvm->arch in its kvm_write_guest_lock() to note that an expected
> > write without a vCPU is in-progress:
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 8c5c69ba47a7..d1da8914f749 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3297,7 +3297,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> >         struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> >  
> >  #ifdef CONFIG_HAVE_KVM_DIRTY_RING
> > -       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> > +       if (!kvm_arch_allow_write_without_running_vcpu(kvm) && WARN_ON_ONCE(!vcpu))
> > +               return;
> > +
> > +       if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
> >                 return;
> >  #endif
> >  
> > @@ -3305,10 +3308,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> >                 unsigned long rel_gfn = gfn - memslot->base_gfn;
> >                 u32 slot = (memslot->as_id << 16) | memslot->id;
> >  
> > -               if (kvm->dirty_ring_size)
> > +               if (kvm->dirty_ring_size && vcpu)
> >                         kvm_dirty_ring_push(&vcpu->dirty_ring,
> >                                             slot, rel_gfn);
> > -               else
> > +               else if (memslot->dirty_bitmap)
> >                         set_bit_le(rel_gfn, memslot->dirty_bitmap);
> >         }
> >  }
> 
> I think this is equally wrong. Writes occur from both CPUs and devices
> *concurrently*, and I don't see why KVM should keep ignoring this
> pretty obvious fact.
>
> Yes, your patch papers over the problem, and it can probably work if
> the kvm->arch flag only gets set in the ITS saving code, which is
> already exclusive of vcpus running.
> 
> But in the long run, with dirty bits being collected from the IOMMU
> page tables or directly from devices, we will need a way to reconcile
> the dirty tracking. The above doesn't quite cut it, unfortunately.

Oooh, are you referring to IOMMU page tables and devices _in the guest_?  E.g. if
KVM itself were to emulate a vIOMMU, then KVM would be responsible for updating
dirty bits in the vIOMMU page tables.

Not that it really matters, but do we actually expect KVM to ever emulate a vIOMMU?
On x86 at least, in-kernel acceleration of vIOMMU emulation seems more like VFIO
territory.

Regardless, I don't think the above idea makes it any more difficult to support
in-KVM emulation of non-CPU stuff, which IIUC is the ITS case.  I 100% agree that
the above is a hack, but that's largely due to the use of kvm_get_running_vcpu().

A slightly different alternative would be have a completely separate API for writing
guest memory without an associated vCPU.  I.e. start building up proper device emulation
support.  Then the vCPU-based APIs could yell if a vCPU isn't provided (or there
is no running vCPU in the current mess).  And the deviced-based API could be
provided if and only if the architecture actually supports emulating writes from
devices, i.e. x86 would not opt-in and so would even have access to the API.
