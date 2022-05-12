Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6787252565B
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 22:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358361AbiELU1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 16:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345771AbiELU1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 16:27:37 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81A25131F
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 13:27:35 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id m25so7830758oih.2
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 13:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sGoOKvntmctjnTFpu4Xea6mgPsfoHZFHEqN6iO1ZtLc=;
        b=JMDSojiExZcn87ffWKkeqGVQmX/krfAFVjMPpYkk7+FfjLTnA88RVyvcURfoPkpBRe
         A6RclZi5OpkvLf8wo5kX68mOlDJYyTgsxNTGb4bPJpUy1kvmmuvdJxXr2ktjN5vBIlUP
         uZ0IWS/Z3K7N4HafatfJ9/2In2VUmbgt5j6THdq/VvUfUiaHq+OC6rsufuhjRhuu1yDQ
         UTj9uhobz63kSEvJEfF4yt/1wNDHO5bsknkSBs+QnRy9HGH2VaP9wUT7G6/6dzrqgvs2
         DVuEKtSm0b+AuwVnHfmb8RXk1KEUBVkUIgF/LzZ4oTIB+QMbDU++6dylbTPaG/2Qg5y5
         KARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sGoOKvntmctjnTFpu4Xea6mgPsfoHZFHEqN6iO1ZtLc=;
        b=sAJLpf759GPWtPhcFFe55Z3azr/D1N/cOg+U7vX6ryap254l+1zP1SOyenrFTYax1S
         EgkbdlDaXMvqIzL0TLBbbLMyPLPaedST9BR8D57nbpKCvJ69IzXUCohOci/sYRtFwE8s
         18dyH978OmaQinRfmbvIsSwIFEcG1Gm3C70J2G8f8Uts9fUIIK7Brh89Fepr+lnn9Juj
         CzY69kEjsMnKT7bLcnXVRZ/LJC38BnBQeQCHtn+qMYc5aYxZoEV6KKnLmcZbncaFBCm2
         wgSWH2px3Cfv+PxKldDg4cMlkMwmOWiuc6+WkTH4HvV414R9mDxc3cgERSsGOHklVWbT
         gtgA==
X-Gm-Message-State: AOAM531aQvfV4Fr3ejcN+Ecz8rkGD7ausKdFdP+zHHCYsDVLvHdvUX5D
        m39mzs3k1RH677hxucFZj2j/F7pvEEtUo7tV7Md/9A==
X-Google-Smtp-Source: ABdhPJzaXe0zNI37ouf0sN/+AvQlv6XXL4SayhKj2e7OKECO2cALUCPTzlEMUrAL2lWS+pZ8WPHClq2RqQwkm65lbxw=
X-Received: by 2002:a05:6808:c2:b0:325:eb71:7266 with SMTP id
 t2-20020a05680800c200b00325eb717266mr6342516oic.269.1652387254885; Thu, 12
 May 2022 13:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220512184514.15742-1-jon@nutanix.com> <Yn1fjAqFoszWz500@google.com>
 <Yn1hdHgMVuni/GEx@google.com> <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
 <Yn1o9ZfsQutXXdQS@google.com>
In-Reply-To: <Yn1o9ZfsQutXXdQS@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 May 2022 13:27:23 -0700
Message-ID: <CALMp9eRQv6owjfyf+UO=96Q1dkeSrJWy0i4O-=RPSaQwz0bjTQ@mail.gmail.com>
Subject: Re: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jon Kohler <jon@nutanix.com>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Waiman Long <longman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, May 12, 2022 at 1:07 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> On Thu, May 12, 2022, Jon Kohler wrote:
> >
> >
> > > On May 12, 2022, at 3:35 PM, Sean Christopherson <seanjc@google.com> =
wrote:
> > >
> > > On Thu, May 12, 2022, Sean Christopherson wrote:
> > >> On Thu, May 12, 2022, Jon Kohler wrote:
> > >>> Remove IBPB that is done on KVM vCPU load, as the guest-to-guest
> > >>> attack surface is already covered by switch_mm_irqs_off() ->
> > >>> cond_mitigation().
> > >>>
> > >>> The original commit 15d45071523d ("KVM/x86: Add IBPB support") was =
simply
> > >>> wrong in its guest-to-guest design intention. There are three scena=
rios
> > >>> at play here:
> > >>
> > >> Jim pointed offline that there's a case we didn't consider.  When sw=
itching between
> > >> vCPUs in the same VM, an IBPB may be warranted as the tasks in the V=
M may be in
> > >> different security domains.  E.g. the guest will not get a notificat=
ion that vCPU0 is
> > >> being swapped out for vCPU1 on a single pCPU.
> > >>
> > >> So, sadly, after all that, I think the IBPB needs to stay.  But the =
documentation
> > >> most definitely needs to be updated.
> > >>
> > >> A per-VM capability to skip the IBPB may be warranted, e.g. for cont=
ainer-like
> > >> use cases where a single VM is running a single workload.
> > >
> > > Ah, actually, the IBPB can be skipped if the vCPUs have different mm_=
structs,
> > > because then the IBPB is fully redundant with respect to any IBPB per=
formed by
> > > switch_mm_irqs_off().  Hrm, though it might need a KVM or per-VM knob=
, e.g. just
> > > because the VMM doesn't want IBPB doesn't mean the guest doesn't want=
 IBPB.
> > >
> > > That would also sidestep the largely theoretical question of whether =
vCPUs from
> > > different VMs but the same address space are in the same security dom=
ain.  It doesn't
> > > matter, because even if they are in the same domain, KVM still needs =
to do IBPB.
> >
> > So should we go back to the earlier approach where we have it be only
> > IBPB on always_ibpb? Or what?
> >
> > At minimum, we need to fix the unilateral-ness of all of this :) since =
we=E2=80=99re
> > IBPB=E2=80=99ing even when the user did not explicitly tell us to.
>
> I think we need separate controls for the guest.  E.g. if the userspace V=
MM is
> sufficiently hardened then it can run without "do IBPB" flag, but that do=
esn't
> mean that the entire guest it's running is sufficiently hardened.
>
> > That said, since I just re-read the documentation today, it does specif=
ically
> > suggest that if the guest wants to protect *itself* it should turn on I=
BPB or
> > STIBP (or other mitigations galore), so I think we end up having to thi=
nk
> > about what our =E2=80=9Ccontract=E2=80=9D is with users who host their =
workloads on
> > KVM - are they expecting us to protect them in any/all cases?
> >
> > Said another way, the internal guest areas of concern aren=E2=80=99t so=
mething
> > the kernel would always be able to A) identify far in advance and B)
> > always solve on the users behalf. There is an argument to be made
> > that the guest needs to deal with its own house, yea?
>
> The issue is that the guest won't get a notification if vCPU0 is replaced=
 with
> vCPU1 on the same physical CPU, thus the guest doesn't get an opportunity=
 to emit
> IBPB.  Since the host doesn't know whether or not the guest wants IBPB, u=
nless the
> owner of the host is also the owner of the guest workload, the safe appro=
ach is to
> assume the guest is vulnerable.

Exactly. And if the guest has used taskset as its mitigation strategy,
how is the host to know?
