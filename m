Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE215BECF2
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 20:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiITSot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 14:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiITSor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 14:44:47 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB42D13E10
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:44:44 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id z9so2672042qvn.9
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=IQ9PPDyjj+lezNSSGrpRlCchgA2fjl3IyszjxDAAz7w=;
        b=VgNVATk8TWzGJTvL5fgSB/Swnr0d1NFPmPI8WXt2gnAJAOWBy+K3vG1rVCoTckL+om
         LXmIcep6A2xb3HMjMDn98kelZqn7VTBJRe6RkICex6c7a1I3aTqu8IQ52I+aciQ1/gZG
         1ctbR39n94hyRXIrL5JF5E/nBYmtLTf7eoYjTL30W0xw44GsiUTmLiy6v3kWMIfklcMf
         nXGFcpryar+moC3LRbu2MCPnfzvW/GIrr0vxfW8T9ZOB8xZ703riH/Yrx0x7Uej0d1gO
         wdAsCxhKdJlxI9w89qGnnVbGWL1Se/xFTLsOPpvAoWs6pC8noYvDNM3oRoVZiDdDPh9W
         ZDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=IQ9PPDyjj+lezNSSGrpRlCchgA2fjl3IyszjxDAAz7w=;
        b=kwjU5Xn8mIw9b98TGElaKxVbF7cxYHx6/KGjDB7PMO4OJ5dfn4/7Whbk7X6gYv6ivY
         utNAvglxJa4ED7/KcMOkAwIHkw5lspUSA/uVN3fRk/7Unq/QvMdtSgQQH3ZJySuexCO1
         Dl85Bp6cbVAYIn1tJFMqqgj2sebs4dxkPqUfS7U4X8CqEn40VOps7/qsNZqGXsWG1lI5
         ZJmHpc1nFdbGFxZfq4PFVXi1rNZu252Bwtu3iLgbOzQWbetr3wFfhlHhAHLNjkrTSPH8
         3+WNS/TXbwdumpYb34UMcTVqA4Fz+V2SeeZAtnnv+dnUqLnIUC5GGQZiGpcx6878TauF
         Xawg==
X-Gm-Message-State: ACrzQf3D9BQ0TCs/r+8GP9n1AXOcijKTZ2fMevWCcoXzsoRfOu60sK93
        +1qLIxVuGErKODLYBpMuoiosZYXMJr9dRQDxfMwtrA==
X-Google-Smtp-Source: AMsMyM7INOTVcrsBL/Rr8F7QcG9VG1/9xRJcIcx3kbOSfwGxtW2k8P0tIsg8+KG+3mV74+I1rk4ZKlmu0BreUUIZB50=
X-Received: by 2002:a05:6214:c2a:b0:4ad:67d:c25a with SMTP id
 a10-20020a0562140c2a00b004ad067dc25amr20574500qvd.125.1663699483375; Tue, 20
 Sep 2022 11:44:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <c0ee12e44f2d218a0857a5e05628d05462b32bf9.1661331396.git.houwenlong.hwl@antgroup.com>
 <f6fd8ccff13f9f48cbca06f0a5278654198d0d06.camel@linux.intel.com> <YyoHNMz3CH4SnJwJ@google.com>
In-Reply-To: <YyoHNMz3CH4SnJwJ@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 20 Sep 2022 11:44:17 -0700
Message-ID: <CALzav=f=y7-2uOnXUi---hvCTa2otDBPsY1VoUtDWnS7+0QX=w@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing
 in validate_direct_spte()
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Hou Wenlong <houwenlong.hwl@antgroup.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Sep 20, 2022 at 11:32 AM David Matlack <dmatlack@google.com> wrote:
>
> On Sun, Sep 18, 2022 at 09:11:00PM +0800, Robert Hoo wrote:
> > On Wed, 2022-08-24 at 17:29 +0800, Hou Wenlong wrote:
> > > The spte pointing to the children SP is dropped, so the
> > > whole gfn range covered by the children SP should be flushed.
> > > Although, Hyper-V may treat a 1-page flush the same if the
> > > address points to a huge page, it still would be better
> > > to use the correct size of huge page. Also introduce
> > > a helper function to do range-based flushing when a direct
> > > SP is dropped, which would help prevent future buggy use
> > > of kvm_flush_remote_tlbs_with_address() in such case.
> > >
> > > Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new
> > > one to flush a specified range.")
> > > Suggested-by: David Matlack <dmatlack@google.com>
> > > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index e418ef3ecfcb..a3578abd8bbc 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -260,6 +260,14 @@ void kvm_flush_remote_tlbs_with_address(struct
> > > kvm *kvm,
> > >     kvm_flush_remote_tlbs_with_range(kvm, &range);
> > >  }
> > >
> > > +/* Flush all memory mapped by the given direct SP. */
> > > +static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct
> > > kvm_mmu_page *sp)
> > > +{
> > > +   WARN_ON_ONCE(!sp->role.direct);
> >
> > What if !sp->role.direct? Below flushing sp->gfn isn't expected? but
> > still to do it. Is this operation harmless?
>
> Flushing TLBs is always harmless because KVM cannot ever assume an entry is
> in the TLB. However, *not* (properly) flushing TLBs can be harmful. If KVM ever
> calls kvm_flush_remote_tlbs_direct_sp() with an indirect SP, that is a bug in
> KVM. The TLB flush here won't be harmful, as I explained, but KVM will miss a
> TLB flush.
>
> That being said, I don't think any changes here are necessary.
> kvm_flush_remote_tlbs_direct_sp() only has one caller, validate_direct_spte(),
> which only operates on direct SPs. The name of the function also makes it
> obvious this should only be called with a direct SP. And if we ever mess this
> up in the future, we'll see the WARN_ON().

That being said, we might as well replace the WARN_ON_ONCE() with
KVM_BUG_ON(). That will still do a WARN_ON_ONCE() but has the added
benefit of terminating the VM.
