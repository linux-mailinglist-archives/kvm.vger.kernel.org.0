Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0D85258CB
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 01:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359651AbiELX5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 19:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350405AbiELX5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 19:57:37 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4435A554AE
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:57:36 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id w123so8351624oiw.5
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7qvuAI/LbHot+Z3zgvkne2FOb1LdGua9+c4HxvF2hBM=;
        b=eFd/xCYa6a0vzCzsVHnwJRF3FcWjsKpaBwxGVr+x8Kljpbk1guwoVq/BIW1TmRrCTS
         olJB7RCMwpzv8ljkm8YSQgiP/n9IIyVjyXUqfIJKB1MoZns6czGr/qBXwEt73KzEqZAJ
         KD/QrHtZiEM8I/AS2WZAMjPXv2Dcz5MNOJMEe/CiJWMrdE1z0a4a7NBs1uB22beLr/I/
         R5AylckCoPqjFPhax1zG3QtKqJkq8dj8xwYX0yf1e2fEmRLH63JG8f+PtAO7h30OEaxj
         s6Li+r6vbJaqiPaJCOukutWCXWpU7q4b2zBp10r7kxFCneFhFHvMdnoaj0GqyXU3J3ol
         igrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7qvuAI/LbHot+Z3zgvkne2FOb1LdGua9+c4HxvF2hBM=;
        b=gpECg61DvevZRwPwFHPKC7w4Evzx8stfRwYqd156zGK5sMKxcUzhefTy30d7ncsDeT
         RPI/eNFwQycG4m3bCBk+1JcGLfSQTXdhFy4YDUteKv6B0AfYeLKBoKuhjIWHHKpFk8mo
         NKWTFJWgJeh/zAcWe8umfFcqAh8eBcnZDxy40QIX0NO5ZsuQOsglz6DGt+pdt9LQakjy
         9ivUlfM97ZTBrdsU03v/E/NpSu12olONe/zjguRFfQdZCHp/ApV2gJVRnIl8AusT2izY
         WjHsG4g8BvUkjWTGPQF28k+ltFc1moNxoW1vuxgBCWD5/NtNzG66m/X2rw5UwH865+ci
         9jEg==
X-Gm-Message-State: AOAM531fQn+M+fCSV5Bu1kwkmIuAyfaStVNLSFWjvqJr6Jqvoe9ZDUqS
        FFhGb7SsLu3v5idzYnRwWjt+CYxolALUE1IpKg8mQQ==
X-Google-Smtp-Source: ABdhPJwx3bfbhZoV/hTg74ZJlzP3iMqS5eo2UO8VN2XkVLechBYYqd+yQx3tj+myeofa5RDIl9HFskNnjHJm3tnrPHw=
X-Received: by 2002:a05:6808:c2:b0:325:eb71:7266 with SMTP id
 t2-20020a05680800c200b00325eb717266mr6676460oic.269.1652399855370; Thu, 12
 May 2022 16:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220512184514.15742-1-jon@nutanix.com> <Yn1fjAqFoszWz500@google.com>
 <Yn1hdHgMVuni/GEx@google.com> <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
 <Yn1o9ZfsQutXXdQS@google.com> <CALMp9eRQv6owjfyf+UO=96Q1dkeSrJWy0i4O-=RPSaQwz0bjTQ@mail.gmail.com>
 <C39CD5E4-3705-4D1A-A67D-43CBB7D1950B@nutanix.com>
In-Reply-To: <C39CD5E4-3705-4D1A-A67D-43CBB7D1950B@nutanix.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 May 2022 16:57:24 -0700
Message-ID: <CALMp9eRXmWvrQ1i0V3G738ndZOZ4YezQ=BqXe-BF2b4GNo1m3Q@mail.gmail.com>
Subject: Re: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
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

On Thu, May 12, 2022 at 1:34 PM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On May 12, 2022, at 4:27 PM, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Thu, May 12, 2022 at 1:07 PM Sean Christopherson <seanjc@google.com>=
 wrote:
> >>
> >> On Thu, May 12, 2022, Jon Kohler wrote:
> >>>
> >>>
> >>>> On May 12, 2022, at 3:35 PM, Sean Christopherson <seanjc@google.com>=
 wrote:
> >>>>
> >>>> On Thu, May 12, 2022, Sean Christopherson wrote:
> >>>>> On Thu, May 12, 2022, Jon Kohler wrote:
> >>>>>> Remove IBPB that is done on KVM vCPU load, as the guest-to-guest
> >>>>>> attack surface is already covered by switch_mm_irqs_off() ->
> >>>>>> cond_mitigation().
> >>>>>>
> >>>>>> The original commit 15d45071523d ("KVM/x86: Add IBPB support") was=
 simply
> >>>>>> wrong in its guest-to-guest design intention. There are three scen=
arios
> >>>>>> at play here:
> >>>>>
> >>>>> Jim pointed offline that there's a case we didn't consider.  When s=
witching between
> >>>>> vCPUs in the same VM, an IBPB may be warranted as the tasks in the =
VM may be in
> >>>>> different security domains.  E.g. the guest will not get a notifica=
tion that vCPU0 is
> >>>>> being swapped out for vCPU1 on a single pCPU.
> >>>>>
> >>>>> So, sadly, after all that, I think the IBPB needs to stay.  But the=
 documentation
> >>>>> most definitely needs to be updated.
> >>>>>
> >>>>> A per-VM capability to skip the IBPB may be warranted, e.g. for con=
tainer-like
> >>>>> use cases where a single VM is running a single workload.
> >>>>
> >>>> Ah, actually, the IBPB can be skipped if the vCPUs have different mm=
_structs,
> >>>> because then the IBPB is fully redundant with respect to any IBPB pe=
rformed by
> >>>> switch_mm_irqs_off().  Hrm, though it might need a KVM or per-VM kno=
b, e.g. just
> >>>> because the VMM doesn't want IBPB doesn't mean the guest doesn't wan=
t IBPB.
> >>>>
> >>>> That would also sidestep the largely theoretical question of whether=
 vCPUs from
> >>>> different VMs but the same address space are in the same security do=
main.  It doesn't
> >>>> matter, because even if they are in the same domain, KVM still needs=
 to do IBPB.
> >>>
> >>> So should we go back to the earlier approach where we have it be only
> >>> IBPB on always_ibpb? Or what?
> >>>
> >>> At minimum, we need to fix the unilateral-ness of all of this :) sinc=
e we=E2=80=99re
> >>> IBPB=E2=80=99ing even when the user did not explicitly tell us to.
> >>
> >> I think we need separate controls for the guest.  E.g. if the userspac=
e VMM is
> >> sufficiently hardened then it can run without "do IBPB" flag, but that=
 doesn't
> >> mean that the entire guest it's running is sufficiently hardened.
> >>
> >>> That said, since I just re-read the documentation today, it does spec=
ifically
> >>> suggest that if the guest wants to protect *itself* it should turn on=
 IBPB or
> >>> STIBP (or other mitigations galore), so I think we end up having to t=
hink
> >>> about what our =E2=80=9Ccontract=E2=80=9D is with users who host thei=
r workloads on
> >>> KVM - are they expecting us to protect them in any/all cases?
> >>>
> >>> Said another way, the internal guest areas of concern aren=E2=80=99t =
something
> >>> the kernel would always be able to A) identify far in advance and B)
> >>> always solve on the users behalf. There is an argument to be made
> >>> that the guest needs to deal with its own house, yea?
> >>
> >> The issue is that the guest won't get a notification if vCPU0 is repla=
ced with
> >> vCPU1 on the same physical CPU, thus the guest doesn't get an opportun=
ity to emit
> >> IBPB.  Since the host doesn't know whether or not the guest wants )IBP=
B, unless the
> >> owner of the host is also the owner of the guest workload, the safe ap=
proach is to
> >> assume the guest is vulnerable.
> >
> > Exactly. And if the guest has used taskset as its mitigation strategy,
> > how is the host to know?
>
> Yea thats fair enough. I posed a solution on Sean=E2=80=99s response just=
 as this email
> came in, would love to know your thoughts (keying off MSR bitmap).
>

I don't believe this works. The IBPBs in cond_mitigation (static in
arch/x86/mm/tlb.c) won't be triggered if the guest has given its
sensitive tasks exclusive use of their cores. And, if performance is a
concern, that is exactly what someone would do.
