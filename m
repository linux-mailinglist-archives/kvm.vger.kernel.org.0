Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B66718909
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 20:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjEaSIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 14:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjEaSIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 14:08:32 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404AD126
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 11:08:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b025aaeddbso14265ad.1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685556509; x=1688148509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSkNdiMP7jY6tlUh6I5KPB+Z+BpvSyNnxaiAhEVXtE0=;
        b=EpHT/8ZRve1Wq26t+TAKx7SJQNT+fVySv2OMKjZYQ2b+in9M3Hk7qwSrnDtgSaSAdA
         BTw0q6kgnioUg/lB6FVO3YhgBjF+Z79W8RhGrcwzlDC8iQOw3SMWDxXNwvgqYDLD9P1B
         CBr+ezEAZy09kHGYPWtTSyMGlxosRk18+QdCs3QnlQ7X9CifFrugJEQIhYDiH1ZwvsTe
         SATBHTtIkDlFDDjxhjOnFIrn9OCTTpKlVMDP1Sa3qo1PISxR2g1ly4R1vZIFthzRQ95/
         m4QEEl1mjkFjqsHHO+ieTqeF0XF2RzwhuieNLRQrsSIgoC+jGzcnTq272IfcrkINunLy
         v8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685556509; x=1688148509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vSkNdiMP7jY6tlUh6I5KPB+Z+BpvSyNnxaiAhEVXtE0=;
        b=LDkESYkkqypI8kDkTgOTuYOBx1c7xXrnIhnFJ+0nzps3v9dlBA1suc6/puyAaLCZw5
         JCk94yLsSo13aerTp40eszGBIwKBhqRrZ3l95Vd+ob1VgTZC2azvfJg4tvFOCNuDhI0h
         Y+1p1LY+9feRd+QSf3AlbTgg36hO4JMWHt9vrdnYkMBeIl6FzDA5i89Zhp2fJEhRn2+V
         UmMjE+1E4qNBjBcTAA15+2uyQcn0p7swpq3J2ny8TtlAxR3UgzIfTaGfr+GIQjdbqtAd
         uMSWSZkCvT3c9OC03gUmkmRsZvaiXsmzNjAeXH4Xs4/gvJQ8BoBadn/ZiKR9N4A+8I8z
         l6Eg==
X-Gm-Message-State: AC+VfDxh5bK5+45HATYMIP3qFrLLdKd+vIuRbmQ1KXUONHb2sPtKn8Ck
        MBYQfIunGTYSzVimOKV6aFfbGGaUTRDHIU2DDZrTqg==
X-Google-Smtp-Source: ACHHUZ7+ljlYTpJXZCGgniPPfn+sq9vKSoC+Zj1HFZ7z4X280RcuLWI/5I+55qaJAIGHvh1q6W46K/ONzLBoMm22kjk=
X-Received: by 2002:a17:902:d141:b0:1b0:26c0:757d with SMTP id
 t1-20020a170902d14100b001b026c0757dmr8147plt.22.1685556509329; Wed, 31 May
 2023 11:08:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230531144128.73814-1-jon@nutanix.com> <9d37ab07-97c6-5245-6939-9c1090b4b3a9@redhat.com>
 <ECE9A3B4-2CF3-452A-838A-99BE075D5E68@nutanix.com> <3cb96907-0d58-ba60-ed0e-6c17c69bd0f8@redhat.com>
In-Reply-To: <3cb96907-0d58-ba60-ed0e-6c17c69bd0f8@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 31 May 2023 11:08:17 -0700
Message-ID: <CALMp9eQNNCwUbPQGBfHzWnTAEJeRO-fjQAFxb9101SChe9F5rg@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
To:     Waiman Long <longman@redhat.com>
Cc:     Jon Kohler <jon@nutanix.com>,
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
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 10:22=E2=80=AFAM Waiman Long <longman@redhat.com> w=
rote:
>
> On 5/31/23 13:13, Jon Kohler wrote:
> >
> >> On May 31, 2023, at 1:02 PM, Waiman Long <longman@redhat.com> wrote:
> >>
> >> On 5/31/23 10:41, Jon Kohler wrote:
> >>> Avoid expensive rdmsr on every VM Exit for MSR_IA32_SPEC_CTRL on
> >>> eIBRS enabled systems iff the guest only sets IA32_SPEC_CTRL[0] (IBRS=
)
> >>> and not [1] (STIBP) or [2] (SSBD) by not disabling interception in
> >>> the MSR bitmap. Note: this logic is only for eIBRS, as Intel's guidan=
ce
> >>> has long been that eIBRS only needs to be set once, so most guests wi=
th
> >>> eIBRS awareness should behave nicely. We would not want to accidental=
ly
> >>> regress misbehaving guests on pre-eIBRS systems, who might be spammin=
g
> >>> IBRS MSR without the hypervisor being able to see it today.
> >>>
> >>> eIBRS enabled guests using just IBRS will only write SPEC_CTRL MSR
> >>> once or twice per vCPU on boot, so it is far better to take those
> >>> VM exits on boot than having to read and save this msr on every
> >>> single VM exit forever. This outcome was suggested on Andrea's commit
> >>> 2f46993d83ff ("x86: change default to spec_store_bypass_disable=3Dprc=
tl spectre_v2_user=3Dprctl")
> >>> however, since interception is still unilaterally disabled, the rdmsr
> >>> tax is still there even after that commit.
> >>>
> >>> This is a significant win for eIBRS enabled systems as this rdmsr
> >>> accounts for roughly ~50% of time for vmx_vcpu_run() as observed
> >>> by perf top disassembly, and is in the critical path for all
> >>> VM-Exits, including fastpath exits.
> >>>
> >>> Opportunistically update comments for both MSR_IA32_SPEC_CTRL and
> >>> MSR_IA32_PRED_CMD to make it clear how L1 vs L2 handling works.
> >>>
> >>> Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disabl=
e=3Dprctl spectre_v2_user=3Dprctl")
> >>> Signed-off-by: Jon Kohler <jon@nutanix.com>
> >>> Cc: Sean Christopherson <seanjc@google.com>
> >>> Cc: Andrea Arcangeli <aarcange@redhat.com>
> >>> Cc: Kees Cook <keescook@chromium.org>
> >>> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> >>> Cc: Waiman Long <longman@redhat.com>
> >>> ---
> >>> v1
> >>>   - https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kerne=
l.org_all_20220512174427.3608-2D1-2Djon-40nutanix.com_&d=3DDwICaQ&c=3Ds883G=
pUCOChKOHiocYtGcg&r=3DNGPRGGo37mQiSXgHKm5rCQ&m=3DPT1QjB8Lk_a3baDOwHBfedQG67=
HsVDmOdmcWHlr5PrT8WyuS9e6PfHF5JxLxD0zw&s=3DjNnloZQgh0KG-n36uwVC0dJTmokvqsQd=
YQCWYI8hVvM&e=3D v1 -> v2:
> >>>   - https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kerne=
l.org_all_20220520195303.58692-2D1-2Djon-40nutanix.com_&d=3DDwICaQ&c=3Ds883=
GpUCOChKOHiocYtGcg&r=3DNGPRGGo37mQiSXgHKm5rCQ&m=3DPT1QjB8Lk_a3baDOwHBfedQG6=
7HsVDmOdmcWHlr5PrT8WyuS9e6PfHF5JxLxD0zw&s=3DRwi5NoHwaezlmzzLiGGCuI6QHuGQZ1B=
VK2hs6-SZvzU&e=3D   - Addressed comments on approach from Sean.
> >>> v2 -> v3:
> >>>   - https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kerne=
l.org_kvm_20220520204115.67580-2D1-2Djon-40nutanix.com_&d=3DDwICaQ&c=3Ds883=
GpUCOChKOHiocYtGcg&r=3DNGPRGGo37mQiSXgHKm5rCQ&m=3DPT1QjB8Lk_a3baDOwHBfedQG6=
7HsVDmOdmcWHlr5PrT8WyuS9e6PfHF5JxLxD0zw&s=3DR2Ykxdv-DyeVGLWd8_pLpu43zEsnWzp=
yvvBPEZ9lz-Y&e=3D   - Addressed comments on approach from Sean.
> >>> v3 -> v4:
> >>>   - Fixed inline code comments from Sean.
> >>>
> >>>   arch/x86/kvm/vmx/vmx.c | 35 ++++++++++++++++++++++++-----------
> >>>   1 file changed, 24 insertions(+), 11 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >>> index 44fb619803b8..5e643ac897bc 100644
> >>> --- a/arch/x86/kvm/vmx/vmx.c
> >>> +++ b/arch/x86/kvm/vmx/vmx.c
> >>> @@ -2260,20 +2260,33 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu,=
 struct msr_data *msr_info)
> >>>                     return 1;
> >>>
> >>>             vmx->spec_ctrl =3D data;
> >>> -           if (!data)
> >>> +
> >>> +           /*
> >>> +            * Disable interception on the first non-zero write, exce=
pt if
> >>> +            * eIBRS is advertised to the guest and the guest is enab=
ling
> >>> +            * _only_ IBRS.  On eIBRS systems, kernels typically set =
IBRS
> >>> +            * once at boot and never touch it post-boot.  All other =
bits,
> >>> +            * and IBRS on non-eIBRS systems, are often set on a per-=
task
> >>> +            * basis, i.e. change frequently, so the benefit of avoid=
ing
> >>> +            * VM-exits during guest context switches outweighs the c=
ost of
> >>> +            * RDMSR on every VM-Exit to save the guest's value.
> >>> +            */
> >>> +           if (!data ||
> >>> +               (data =3D=3D SPEC_CTRL_IBRS &&
> >>> +                (vcpu->arch.arch_capabilities & ARCH_CAP_IBRS_ALL)))
> >>>                     break;
> >>>
> >>>             /*
> >>> -            * For non-nested:
> >>> -            * When it's written (to non-zero) for the first time, pa=
ss
> >>> -            * it through.
> >>> -            *
> >>> -            * For nested:
> >>> -            * The handling of the MSR bitmap for L2 guests is done i=
n
> >>> -            * nested_vmx_prepare_msr_bitmap. We should not touch the
> >>> -            * vmcs02.msr_bitmap here since it gets completely overwr=
itten
> >>> -            * in the merging. We update the vmcs01 here for L1 as we=
ll
> >>> -            * since it will end up touching the MSR anyway now.
> >>> +            * Update vmcs01.msr_bitmap even if L2 is active, i.e. di=
sable
> >>> +            * interception for the vCPU on the first write regardles=
s of
> >>> +            * whether the WRMSR came from L1 or L2.  vmcs02's bitmap=
 is a
> >>> +            * combination of vmcs01 and vmcs12 bitmaps, and will be
> >>> +            * recomputed by nested_vmx_prepare_msr_bitmap() on the n=
ext
> >>> +            * nested VM-Enter.  Note, this does mean that future WRM=
SRs
> >>> +            * from L2 will be intercepted until the next nested VM-E=
xit if
> >>> +            * L2 was the first to write, but L1 exposing the MSR to =
L2
> >>> +            * without first writing it is unlikely and not worth the
> >>> +            * extra bit of complexity.
> >>>              */
> >>>             vmx_disable_intercept_for_msr(vcpu,
> >>>                                           MSR_IA32_SPEC_CTRL,
> >> I have 2 comments.
> >>
> >> 1) Besides the IBRS, STIBP & SSBD bits, the SPEC_CTRL MSR may have the=
 RRSBA_DIS_S bit set in the future. I am not aware of any current Intel pro=
cessors having this capability yet, but a future Intel processor may have t=
his and the above patch will have to be modified accordingly. It looks like=
 that the RRSBA_DIS_S bit will be set once.
> > Agreed. Once that becomes pubic with future processors, this code can b=
e fixed up in a fairly trivial manner. I don=E2=80=99t have any access to s=
aid future processors, so I=E2=80=99d like to keep it as-is today rather th=
an project it out too far. Is that ok?
> That is certainly OK. I am just raising a question here.

How difficult would it be to do a back of the envelope cost/benefit
analysis, rather than relying on heuristics based on today's typical
guest behavior?

Say that it's a minimum of 1000 cycles to intercept this WRMSR. The
tradeoff is the cost of a RDMSR on every VM-exit. How long does a
RDMSR take these days? On the order of 50 cycles? So, if the guest
consistently writes IA32_SPEC_CTRL more often than once every 20
VM-exits, it's better not to intercept it.

Most of the bookkeeping could be handled in the WRMSR(IA32_SPEC_CTRL)
intercept. The only overhead we'd incur on every VM-exit would be the
cost of incrementing a VM-exit counter.

It's a bit more complicated, but it directly addresses the issue, and
it's more future-proof.
