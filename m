Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A6F525637
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 22:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358277AbiELUG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 16:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358276AbiELUGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 16:06:53 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D1065425
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 13:06:50 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id z5-20020a9d62c5000000b00606041d11f1so3492252otk.2
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 13:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zQaYoCe85C4OWs0lOZEThzi3C5V4+Gn0nWrkUoVxviA=;
        b=SZogx2/smQbOu1ljZOuPd1be4aSXBhM2T0qGSEzJH+p3lVSle6GL68sLBALkTUnEQg
         T9fliaMhIdImcbaGR8BkughVY0chn+k+f3YuQSvMMo88ni23k2AloWvCLQBEEb8hs5H+
         /HyRBvVbLWZLWHyM679x0swWskgKVxOAaFeCwnG+khnruWbeQiASf5mkATYeZ+bnoXTd
         Oepk+aWBC+K/KYrcT54hgqPcgP8Jqp6A+a21SEmOw+rKBTIS8NaFWgqQ5pHe5EI17JmD
         1xqLNu/iuY4rCLHouiBMtcF7EQqO2Qtf0apq7w1j9ZJZqZMcF3HFWbzXSSD4j8mIJ/Kw
         j9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zQaYoCe85C4OWs0lOZEThzi3C5V4+Gn0nWrkUoVxviA=;
        b=O5cVeQgCUXkr0PAaIpkvcZ5qytjeKzAHzBxY9iPig8p8f4sijycWd+hMiSMUdz9fE6
         SySli4YKUlfPFeUSLWIn7hF6RPizd9SNB1tyjn9pQ84dukrC6kMVRMqgszFB+Dvmbd8U
         0Co10FIL2ZT96ALlyizGGvprtDzoWKmXostyADIP5PSeS7m1RzgiJLKJWbI7//DvygTd
         t55v1o0tzSb98jnihADrhGBjxBb+EUorXaB7TpX0XCD5gEyoMHlChQmVDGDRzKqWr6xB
         jaspN0e11cN/MOE1IoCJ1c5oN116aBcZZRSNfCE4dBza1p4qTf/4gOF+a6aZ2HXMj5Hk
         FDlA==
X-Gm-Message-State: AOAM532LpfDhA/IOOaYMkk8/QQbxbmRikNU5UFIdKQuJcL1mPbLpeGI6
        dH2kacmf8QDzOkz/SPO8satA5noF/RJy4pai88AS9A==
X-Google-Smtp-Source: ABdhPJwhHLd3+fq+h/GEibas+/Fm3MuJ74kLY7OWh8d2BlOhKbyESRCxHoOBt0FvJPmf8JtKarC8CH3oCc/jq2zfnA4=
X-Received: by 2002:a05:6830:280e:b0:606:ae45:6110 with SMTP id
 w14-20020a056830280e00b00606ae456110mr664767otu.14.1652386009945; Thu, 12 May
 2022 13:06:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220512184514.15742-1-jon@nutanix.com> <Yn1fjAqFoszWz500@google.com>
 <Yn1hdHgMVuni/GEx@google.com> <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
In-Reply-To: <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 May 2022 13:06:39 -0700
Message-ID: <CALMp9eQbP5DdX+SA0subeHmVxZgfQ7LEZ-Cxs3AFVHUpa6nhfg@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 12:51 PM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On May 12, 2022, at 3:35 PM, Sean Christopherson <seanjc@google.com> wr=
ote:
> >
> > On Thu, May 12, 2022, Sean Christopherson wrote:
> >> On Thu, May 12, 2022, Jon Kohler wrote:
> >>> Remove IBPB that is done on KVM vCPU load, as the guest-to-guest
> >>> attack surface is already covered by switch_mm_irqs_off() ->
> >>> cond_mitigation().
> >>>
> >>> The original commit 15d45071523d ("KVM/x86: Add IBPB support") was si=
mply
> >>> wrong in its guest-to-guest design intention. There are three scenari=
os
> >>> at play here:
> >>
> >> Jim pointed offline that there's a case we didn't consider.  When swit=
ching between
> >> vCPUs in the same VM, an IBPB may be warranted as the tasks in the VM =
may be in
> >> different security domains.  E.g. the guest will not get a notificatio=
n that vCPU0 is
> >> being swapped out for vCPU1 on a single pCPU.
> >>
> >> So, sadly, after all that, I think the IBPB needs to stay.  But the do=
cumentation
> >> most definitely needs to be updated.
> >>
> >> A per-VM capability to skip the IBPB may be warranted, e.g. for contai=
ner-like
> >> use cases where a single VM is running a single workload.
> >
> > Ah, actually, the IBPB can be skipped if the vCPUs have different mm_st=
ructs,
> > because then the IBPB is fully redundant with respect to any IBPB perfo=
rmed by
> > switch_mm_irqs_off().  Hrm, though it might need a KVM or per-VM knob, =
e.g. just
> > because the VMM doesn't want IBPB doesn't mean the guest doesn't want I=
BPB.
> >
> > That would also sidestep the largely theoretical question of whether vC=
PUs from
> > different VMs but the same address space are in the same security domai=
n.  It doesn't
> > matter, because even if they are in the same domain, KVM still needs to=
 do IBPB.
>
> So should we go back to the earlier approach where we have it be only
> IBPB on always_ibpb? Or what?
>
> At minimum, we need to fix the unilateral-ness of all of this :) since we=
=E2=80=99re
> IBPB=E2=80=99ing even when the user did not explicitly tell us to.
>
> That said, since I just re-read the documentation today, it does specific=
ally
> suggest that if the guest wants to protect *itself* it should turn on IBP=
B or
> STIBP (or other mitigations galore), so I think we end up having to think
> about what our =E2=80=9Ccontract=E2=80=9D is with users who host their wo=
rkloads on
> KVM - are they expecting us to protect them in any/all cases?
>
> Said another way, the internal guest areas of concern aren=E2=80=99t some=
thing
> the kernel would always be able to A) identify far in advance and B)
> always solve on the users behalf. There is an argument to be made
> that the guest needs to deal with its own house, yea?

To the extent that the guest has control over its own house, yes.

Say the guest obviates the need for internal IBPB by statically
partitioning virtual cores into different security domains. If the
hypervisor breaks core isolation on the physical platform, it is
responsible for providing the necessary mitigations.
