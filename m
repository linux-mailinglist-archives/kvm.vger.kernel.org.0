Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00C1718962
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 20:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjEaSag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 14:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEaSae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 14:30:34 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385A39D
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 11:30:23 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-33b398f2ab8so21225ab.0
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 11:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685557822; x=1688149822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oxpshYnAXSG9FfvU/D+cJhwkZUUdHfoRxjeCwRDDwqI=;
        b=H0U1KRvw1ivJh9iV3NKovxsHWtctrloknZl9b/bgbREjhP5JKLdWWoE9F2m1w12eWV
         lJM7hulTG7RF6CspWPUSBCyc3Wp/HgbLL/bpuGBW4btrtoWYAaAtl5yHaz6u7pKFmx3T
         f0WxXS97gRn6oxaYRIii4AohDKTz92PLZnVjIRoOjoPGw/OpGYulhDuHAQXo4pMXO7/d
         eM55YPHmQf6T13HeZTRuh/0dYcYXlucS52tFDs+3NGxZcZMm3qTHOxak90bx6jVX4/iS
         hbpZOUzaYL8IAQx1LR+rZndUOJF+8ZfaVDSCxJ36BaeWdRKSXCRuiDvaVprPikTeTPOG
         PpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685557822; x=1688149822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oxpshYnAXSG9FfvU/D+cJhwkZUUdHfoRxjeCwRDDwqI=;
        b=kT6T51Zr5ENBNAzA80yh5KYr4ErXfah9t3MKNiVrz8G7CH78mT/DDgwSw4dG/qYBRW
         e4DKRXQ1Ra30umCK9Tyb2/Xs7JKwWIMq6rDhBFbmcS9ZdSS9KRoII8GDcEQNf0jrfI0P
         aSkn9dt5ZJ14EoArw7xUZaePM3LdUpep1/Zq9v2eK5fv5obTeVPsZoXxtPwFgvzZLTgK
         KK5UVPhrt1Iz4iQQSZ1qcwjSVHwMi2iPN+oanWhW34j2zRAZ2cEMwtYXoQF42yZsxJAW
         jj5RqnRQkD1Y+GazwpX06yN+8gstWwt6rfrR1mng2akXnW+5CFI3vApVZItZUJPGcuS1
         xAEA==
X-Gm-Message-State: AC+VfDw1mO96k9ihhGRxvqtP0ctcQ3tgZ3ITTbn6RcKARx/PYXJkbdgh
        bEg/WgQGaHUMeBQ1abaeCjgAIl+FIhiXlN6o0k8VNA==
X-Google-Smtp-Source: ACHHUZ4FEP59s+IpNFhVx1lLRIPbgdF0FN+vQtjw2eARBXqaX6Rpf3i0EI2lzIqMGkdP7ENjBx7yF07SKFj0G6zOcKc=
X-Received: by 2002:a05:6e02:20e4:b0:330:af65:de3d with SMTP id
 q4-20020a056e0220e400b00330af65de3dmr4012ilv.11.1685557822429; Wed, 31 May
 2023 11:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230531144128.73814-1-jon@nutanix.com> <9d37ab07-97c6-5245-6939-9c1090b4b3a9@redhat.com>
 <ECE9A3B4-2CF3-452A-838A-99BE075D5E68@nutanix.com> <3cb96907-0d58-ba60-ed0e-6c17c69bd0f8@redhat.com>
 <CALMp9eQNNCwUbPQGBfHzWnTAEJeRO-fjQAFxb9101SChe9F5rg@mail.gmail.com> <623EC08D-A755-4520-B9BF-42B0E72570C1@nutanix.com>
In-Reply-To: <623EC08D-A755-4520-B9BF-42B0E72570C1@nutanix.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 31 May 2023 11:30:11 -0700
Message-ID: <CALMp9eQ17+XRpxJjMnmvPnKOC1VP1P=mU-KykoOzYZsgtGN8sQ@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
To:     Jon Kohler <jon@nutanix.com>
Cc:     Waiman Long <longman@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 11:17=E2=80=AFAM Jon Kohler <jon@nutanix.com> wrote=
:
>
>
>
> > On May 31, 2023, at 2:08 PM, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Wed, May 31, 2023 at 10:22=E2=80=AFAM Waiman Long <longman@redhat.co=
m> wrote:
> >>
> >> On 5/31/23 13:13, Jon Kohler wrote:
> >>>
> >>>> On May 31, 2023, at 1:02 PM, Waiman Long <longman@redhat.com> wrote:
> >>>>
> >>>> On 5/31/23 10:41, Jon Kohler wrote:
> >>>>> Avoid expensive rdmsr on every VM Exit for MSR_IA32_SPEC_CTRL on
> >>>>> eIBRS enabled systems iff the guest only sets IA32_SPEC_CTRL[0] (IB=
RS)
> >>>>> and not [1] (STIBP) or [2] (SSBD) by not disabling interception in
> >>>>> the MSR bitmap. Note: this logic is only for eIBRS, as Intel's guid=
ance
> >>>>> has long been that eIBRS only needs to be set once, so most guests =
with
> >>>>> eIBRS awareness should behave nicely. We would not want to accident=
ally
> >>>>> regress misbehaving guests on pre-eIBRS systems, who might be spamm=
ing
> >>>>> IBRS MSR without the hypervisor being able to see it today.
> >>>>>
> >>>>> eIBRS enabled guests using just IBRS will only write SPEC_CTRL MSR
> >>>>> once or twice per vCPU on boot, so it is far better to take those
> >>>>> VM exits on boot than having to read and save this msr on every
> >>>>> single VM exit forever. This outcome was suggested on Andrea's comm=
it
> >>>>> 2f46993d83ff ("x86: change default to spec_store_bypass_disable=3Dp=
rctl spectre_v2_user=3Dprctl")
> >>>>> however, since interception is still unilaterally disabled, the rdm=
sr
> >>>>> tax is still there even after that commit.
> >>>>>
> >>>>> This is a significant win for eIBRS enabled systems as this rdmsr
> >>>>> accounts for roughly ~50% of time for vmx_vcpu_run() as observed
> >>>>> by perf top disassembly, and is in the critical path for all
> >>>>> VM-Exits, including fastpath exits.
> >>>>>
> >>>>> Opportunistically update comments for both MSR_IA32_SPEC_CTRL and
> >>>>> MSR_IA32_PRED_CMD to make it clear how L1 vs L2 handling works.
> >>>>>
> >>>>> Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disa=
ble=3Dprctl spectre_v2_user=3Dprctl")
> >>>>> Signed-off-by: Jon Kohler <jon@nutanix.com>
> >>>>> Cc: Sean Christopherson <seanjc@google.com>
> >>>>> Cc: Andrea Arcangeli <aarcange@redhat.com>
> >>>>> Cc: Kees Cook <keescook@chromium.org>
> >>>>> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> >>>>> Cc: Waiman Long <longman@redhat.com>
> >>>>> ---
> >>>>> v1
> >>>>>  - https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kern=
el.org_all_20220512174427.3608-2D1-2Djon-40nutanix.com_&d=3DDwICaQ&c=3Ds883=
GpUCOChKOHiocYtGcg&r=3DNGPRGGo37mQiSXgHKm5rCQ&m=3DPT1QjB8Lk_a3baDOwHBfedQG6=
7HsVDmOdmcWHlr5PrT8WyuS9e6PfHF5JxLxD0zw&s=3DjNnloZQgh0KG-n36uwVC0dJTmokvqsQ=
dYQCWYI8hVvM&e=3D v1 -> v2:
> >>>>>  - https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kern=
el.org_all_20220520195303.58692-2D1-2Djon-40nutanix.com_&d=3DDwICaQ&c=3Ds88=
3GpUCOChKOHiocYtGcg&r=3DNGPRGGo37mQiSXgHKm5rCQ&m=3DPT1QjB8Lk_a3baDOwHBfedQG=
67HsVDmOdmcWHlr5PrT8WyuS9e6PfHF5JxLxD0zw&s=3DRwi5NoHwaezlmzzLiGGCuI6QHuGQZ1=
BVK2hs6-SZvzU&e=3D   - Addressed comments on approach from Sean.
> >>>>> v2 -> v3:
> >>>>>  - https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kern=
el.org_kvm_20220520204115.67580-2D1-2Djon-40nutanix.com_&d=3DDwICaQ&c=3Ds88=
3GpUCOChKOHiocYtGcg&r=3DNGPRGGo37mQiSXgHKm5rCQ&m=3DPT1QjB8Lk_a3baDOwHBfedQG=
67HsVDmOdmcWHlr5PrT8WyuS9e6PfHF5JxLxD0zw&s=3DR2Ykxdv-DyeVGLWd8_pLpu43zEsnWz=
pyvvBPEZ9lz-Y&e=3D   - Addressed comments on approach from Sean.
> >>>>> v3 -> v4:
> >>>>>  - Fixed inline code comments from Sean.
> >>>>>
> >>>>>  arch/x86/kvm/vmx/vmx.c | 35 ++++++++++++++++++++++++-----------
> >>>>>  1 file changed, 24 insertions(+), 11 deletions(-)
> >>>>>
> >>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >>>>> index 44fb619803b8..5e643ac897bc 100644
> >>>>> --- a/arch/x86/kvm/vmx/vmx.c
> >>>>> +++ b/arch/x86/kvm/vmx/vmx.c
> >>>>> @@ -2260,20 +2260,33 @@ static int vmx_set_msr(struct kvm_vcpu *vcp=
u, struct msr_data *msr_info)
> >>>>>                    return 1;
> >>>>>
> >>>>>            vmx->spec_ctrl =3D data;
> >>>>> -           if (!data)
> >>>>> +
> >>>>> +           /*
> >>>>> +            * Disable interception on the first non-zero write, ex=
cept if
> >>>>> +            * eIBRS is advertised to the guest and the guest is en=
abling
> >>>>> +            * _only_ IBRS.  On eIBRS systems, kernels typically se=
t IBRS
> >>>>> +            * once at boot and never touch it post-boot.  All othe=
r bits,
> >>>>> +            * and IBRS on non-eIBRS systems, are often set on a pe=
r-task
> >>>>> +            * basis, i.e. change frequently, so the benefit of avo=
iding
> >>>>> +            * VM-exits during guest context switches outweighs the=
 cost of
> >>>>> +            * RDMSR on every VM-Exit to save the guest's value.
> >>>>> +            */
> >>>>> +           if (!data ||
> >>>>> +               (data =3D=3D SPEC_CTRL_IBRS &&
> >>>>> +                (vcpu->arch.arch_capabilities & ARCH_CAP_IBRS_ALL)=
))
> >>>>>                    break;
> >>>>>
> >>>>>            /*
> >>>>> -            * For non-nested:
> >>>>> -            * When it's written (to non-zero) for the first time, =
pass
> >>>>> -            * it through.
> >>>>> -            *
> >>>>> -            * For nested:
> >>>>> -            * The handling of the MSR bitmap for L2 guests is done=
 in
> >>>>> -            * nested_vmx_prepare_msr_bitmap. We should not touch t=
he
> >>>>> -            * vmcs02.msr_bitmap here since it gets completely over=
written
> >>>>> -            * in the merging. We update the vmcs01 here for L1 as =
well
> >>>>> -            * since it will end up touching the MSR anyway now.
> >>>>> +            * Update vmcs01.msr_bitmap even if L2 is active, i.e. =
disable
> >>>>> +            * interception for the vCPU on the first write regardl=
ess of
> >>>>> +            * whether the WRMSR came from L1 or L2.  vmcs02's bitm=
ap is a
> >>>>> +            * combination of vmcs01 and vmcs12 bitmaps, and will b=
e
> >>>>> +            * recomputed by nested_vmx_prepare_msr_bitmap() on the=
 next
> >>>>> +            * nested VM-Enter.  Note, this does mean that future W=
RMSRs
> >>>>> +            * from L2 will be intercepted until the next nested VM=
-Exit if
> >>>>> +            * L2 was the first to write, but L1 exposing the MSR t=
o L2
> >>>>> +            * without first writing it is unlikely and not worth t=
he
> >>>>> +            * extra bit of complexity.
> >>>>>             */
> >>>>>            vmx_disable_intercept_for_msr(vcpu,
> >>>>>                                          MSR_IA32_SPEC_CTRL,
> >>>> I have 2 comments.
> >>>>
> >>>> 1) Besides the IBRS, STIBP & SSBD bits, the SPEC_CTRL MSR may have t=
he RRSBA_DIS_S bit set in the future. I am not aware of any current Intel p=
rocessors having this capability yet, but a future Intel processor may have=
 this and the above patch will have to be modified accordingly. It looks li=
ke that the RRSBA_DIS_S bit will be set once.
> >>> Agreed. Once that becomes pubic with future processors, this code can=
 be fixed up in a fairly trivial manner. I don=E2=80=99t have any access to=
 said future processors, so I=E2=80=99d like to keep it as-is today rather =
than project it out too far. Is that ok?
> >> That is certainly OK. I am just raising a question here.
> >
> > How difficult would it be to do a back of the envelope cost/benefit
> > analysis, rather than relying on heuristics based on today's typical
> > guest behavior?
> >
> > Say that it's a minimum of 1000 cycles to intercept this WRMSR. The
> > tradeoff is the cost of a RDMSR on every VM-exit. How long does a
> > RDMSR take these days? On the order of 50 cycles? So, if the guest
> > consistently writes IA32_SPEC_CTRL more often than once every 20
> > VM-exits, it's better not to intercept it.
> >
> > Most of the bookkeeping could be handled in the WRMSR(IA32_SPEC_CTRL)
> > intercept. The only overhead we'd incur on every VM-exit would be the
> > cost of incrementing a VM-exit counter.
> >
> > It's a bit more complicated, but it directly addresses the issue, and
> > it's more future-proof.
>
> Yea, I thought about it. One one hand, simplicity is king and on the othe=
r
> hand, not having to think about this again is nice too.
>
> The challenge in my mind is that on setups where this truly is static, we=
=E2=80=99d
> be taking some incremental amount of memory to keep the counter around,
> just to have the same outcome each time. Doesn=E2=80=99t feel right (to m=
e) unless that is
> also used for =E2=80=9Cother=E2=80=9D stuff as some sort of general purpo=
se/common counter.

If you're feeling mean, there's plenty of wasted space where you could
put the counter. For instance, we still allocate an entire page for
every VMCS, don't we?

> RE Cost: I can=E2=80=99t put my finger on it, but I swear that RDMSR for =
*this*
> specific MSR is more expensive than any other RDMSR I=E2=80=99ve come acr=
oss
> for run-of-the-mill random MSRs. I flipped thru the SDM and the mitigatio=
ns
> documentation, and it only ever mentions that there is a notable cost to
> do WRMSR IA32_SPEC_CTRL, but nothing about the RDMSR side.
>
> If anyone happens to know from an Intel-internals perspective, I=E2=80=99=
d be quite
> interested to know why it just =E2=80=9Cfeels=E2=80=9D so darn costly. i.=
e. is the proc also doing
> special things under the covers, similar to what the processor does on
> writes to this one?

What do you mean by "feels"? Have you measured it?
