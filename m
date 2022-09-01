Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B0F5A9D81
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbiIAQuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbiIAQuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:50:40 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096645E56B
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 09:50:37 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-11f34610d4aso22173384fac.9
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 09:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TmAVIGCxkXwVO7ChCEmtXTeEcWuZVHFSmie/Vk4DZ0o=;
        b=omPCDQTtFdF1Pp9rmOPhl+BpfMCCG8gc4fqP7jMSkdATi+5x9Iaf5ivx4PiI+Uz8On
         FzpKKebiTzQEYifsrMmTptA/jSgGOo5udB90Gc4/cqEhObV92ziHF+iNY6ZLFtvdD6P6
         kYwS2lGssQs7F2SU7bZYIA8aABx/D+75oFaYz4HDXJTGz0CqPVMduf+nc/c0FcQkmlul
         6yMGheXZOCy8YzNRjJiFZfRikc5k01zQOxNPsZcIifAOhqLC02KgKUKvvdElzRZ3KHOI
         ffoTXB92JQrqrxph3S+tf5I/IqnXPraVcGjsTT27mEOhn9cz8t+z9QR+FvdA6ePj3H52
         LR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TmAVIGCxkXwVO7ChCEmtXTeEcWuZVHFSmie/Vk4DZ0o=;
        b=FbCjuHOpTLrWMTM2eDfn480uuCLxoXP1/VkzCmmk84iX4MkjLyoIzmv9t5rwk3J+TD
         +JfD747WApitLJXFu+SploDXbSh5MylbjqpMMsgjthD7OlJ2CdBgMvLUjyxuIU22ALAz
         R7IAZG4OdU9EFdjFPJnXXQWYVwbF2BP9hnET8+1CW6cr5WWS/Ru5g9/JjFK/GDKGTURg
         6HrPIRTYYANSnVcw5mSItRNPFa5yt5fs0NqiKj9rHDYzMVoIXvLed8hre4rs2RE2lAF2
         NzfmzD3GrQDk2UMgY85RrfEhSSh1dXIgr87pFuTnqK/3k2QyQZ9igVE5rGaWNke1qmW+
         ydMg==
X-Gm-Message-State: ACgBeo123Bp25GKzXKCIL+r9Mb3p4XiOk07ENtrHPOC38IH1pmbM7O+V
        hcD/NQCe1sDOANHlBEAVvkNoTpvpbZgSPTQ/LJ3tkw==
X-Google-Smtp-Source: AA6agR51wUW2Y3wpErwfy495QJV9+d/YUYuAjevPe91xmTBTaUBdhwV99NFOSBeKXlOBnVhS+N/qlmUJhxYKB8X6K9M=
X-Received: by 2002:a05:6808:656:b0:343:2783:7e62 with SMTP id
 z22-20020a056808065600b0034327837e62mr6728oih.297.1662051036136; Thu, 01 Sep
 2022 09:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com> <20220826231227.4096391-9-dmatlack@google.com>
 <20220830235708.GB2711697@ls.amr.corp.intel.com>
In-Reply-To: <20220830235708.GB2711697@ls.amr.corp.intel.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 1 Sep 2022 09:50:10 -0700
Message-ID: <CALzav=fg8xonNUkbFcep6kcVcBGtsp2RRW0_NKUL8DhdbQbRPA@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] KVM: x86/mmu: Split out TDP MMU page fault handling
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 4:57 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
>
> On Fri, Aug 26, 2022 at 04:12:25PM -0700,
> David Matlack <dmatlack@google.com> wrote:
>
> > Split out the page fault handling for the TDP MMU to a separate
> > function.  This creates some duplicate code, but makes the TDP MMU fault
> > handler simpler to read by eliminating branches and will enable future
> > cleanups by allowing the TDP MMU and non-TDP MMU fault paths to diverge.
> >
> > Only compile in the TDP MMU fault handler for 64-bit builds since
> > kvm_tdp_mmu_map() does not exist in 32-bit builds.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 62 ++++++++++++++++++++++++++++++++----------
> >  1 file changed, 48 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a185599f4d1d..8f124a23ab4c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4242,7 +4242,6 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> >
> >  static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  {
> > -     bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
> >       int r;
> >
> >       if (page_fault_handle_page_track(vcpu, fault))
> > @@ -4261,11 +4260,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >               return r;
> >
> >       r = RET_PF_RETRY;
> > -
> > -     if (is_tdp_mmu_fault)
> > -             read_lock(&vcpu->kvm->mmu_lock);
> > -     else
> > -             write_lock(&vcpu->kvm->mmu_lock);
> > +     write_lock(&vcpu->kvm->mmu_lock);
> >
> >       if (is_page_fault_stale(vcpu, fault))
> >               goto out_unlock;
> > @@ -4274,16 +4269,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >       if (r)
> >               goto out_unlock;
> >
> > -     if (is_tdp_mmu_fault)
> > -             r = kvm_tdp_mmu_map(vcpu, fault);
> > -     else
> > -             r = __direct_map(vcpu, fault);
> > +     r = __direct_map(vcpu, fault);
> >
> >  out_unlock:
> > -     if (is_tdp_mmu_fault)
> > -             read_unlock(&vcpu->kvm->mmu_lock);
> > -     else
> > -             write_unlock(&vcpu->kvm->mmu_lock);
> > +     write_unlock(&vcpu->kvm->mmu_lock);
> >       kvm_release_pfn_clean(fault->pfn);
> >       return r;
> >  }
> > @@ -4331,6 +4320,46 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
> >
> > +#ifdef CONFIG_X86_64
> > +int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
> > +                        struct kvm_page_fault *fault)
>
> nitpick: static

Will do.

>
> > +{
> > +     int r;
> > +
> > +     if (page_fault_handle_page_track(vcpu, fault))
> > +             return RET_PF_EMULATE;
> > +
> > +     r = fast_page_fault(vcpu, fault);
> > +     if (r != RET_PF_INVALID)
> > +             return r;
> > +
> > +     r = mmu_topup_memory_caches(vcpu, false);
> > +     if (r)
> > +             return r;
> > +
> > +     r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
> > +     if (r != RET_PF_CONTINUE)
> > +             return r;
> > +
> > +     r = RET_PF_RETRY;
> > +     read_lock(&vcpu->kvm->mmu_lock);
> > +
> > +     if (is_page_fault_stale(vcpu, fault))
> > +             goto out_unlock;
> > +
> > +     r = make_mmu_pages_available(vcpu);
> > +     if (r)
> > +             goto out_unlock;
> > +
> > +     r = kvm_tdp_mmu_map(vcpu, fault);
> > +
> > +out_unlock:
> > +     read_unlock(&vcpu->kvm->mmu_lock);
> > +     kvm_release_pfn_clean(fault->pfn);
> > +     return r;
> > +}
> > +#endif
> > +
> >  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  {
> >       /*
> > @@ -4355,6 +4384,11 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >               }
> >       }
> >
> > +#ifdef CONFIG_X86_64
> > +     if (tdp_mmu_enabled)
> > +             return kvm_tdp_mmu_page_fault(vcpu, fault);
> > +#endif
> > +
> >       return direct_page_fault(vcpu, fault);
> >  }
>
> Now we mostly duplicated page_fault method.  We can go one step further.
> kvm->arch.mmu.page_fault can be set for each case.  Maybe we can do it later
> if necessary.

Hm, interesting idea. We would have to refactor the MTRR max_level
code in kvm_tdp_page_fault() into a helper function, but otherwise
that idea would work. I will give it a try in the next version.

> --
> Isaku Yamahata <isaku.yamahata@gmail.com>
