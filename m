Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77166F5C4B
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 19:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjECRBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 13:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjECRBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 13:01:33 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDD410E6
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 10:01:31 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-32f4e0f42a7so318315ab.1
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 10:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683133291; x=1685725291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RokHpL7gEp+8bwACyg0TzjSMRwicpwkJBeyqxLUEb4o=;
        b=C9ZElJzmsw61SsIyXABDNWMxysHFG08kMIvwUFvHd2crTxZ2R14V7yBi++c3+DjDyD
         btXJZnhpip28GxNDW+/G8quk340mCEW336XufwWmrvsRs6BVzbU0kbqqhlpRUCyF6Egd
         l18ATr06FuRmLdWiS/RLueXT5U4Fn2h1V9LHNKdHG/YAhdqnPqBzLXhYv0kcra3RvAgi
         f4MsIuR8xUWwUdhrSpCOwhU1JjVpP36OQw6KZxQhCrPzq0uFHQa48L4w0pytChUsPAJn
         5/ralPci7bWZPkOR2O+EwHllsI3btnNzJ55kXCCPNDg9XCAJNLcaUC0y0zPtEvDhv6Ga
         FjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683133291; x=1685725291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RokHpL7gEp+8bwACyg0TzjSMRwicpwkJBeyqxLUEb4o=;
        b=LpHvIeG0iyefWrPfd/Gn/lGsumSkrQEO2uaYU45EdhaOKszLhLoCew4BOOkjq91PGM
         KXwX1mi2Bj+XIZNBiIYKTlPgxRP0O9rvPhvbBGV447tffHzxsFadxEyZy53gT/9NiInN
         PtG59ET7GpSWF5DGy3/BiyaniFR4v55KZGFbGR8YxGCxVj5uRsNCExJSBOUaq8n8CI/I
         lj0hyUPor27WzCZgqLIMVjzmkQPmVopgpbHVIr0TapkIIIK3KsWZamqZKpyu56eTqHaH
         iLY7CuAzfibVZAtI1MclGuGsoBTtT2JRXvq6m7z8CDwZUe7C7MXf1BpGNLXleNRjJwNu
         WFHw==
X-Gm-Message-State: AC+VfDyaGW0C73HQdOCk4N39KRjlAZOO3bcjtjNN1q4hYTfEEcgb9OZ+
        UfmFSMkbJQmaBqTUNMjhSk25Zjb8uGB+ikH/JvZXVw==
X-Google-Smtp-Source: ACHHUZ6C18aijFG98Dx4qPcWT5i4cZpKAKxoDk+NuIteU03P3f/4RpgCadZMImG5Wu2d6cz7bBpFNmv2I6v8J60C1PY=
X-Received: by 2002:a05:6e02:1cad:b0:325:d0d8:2ddb with SMTP id
 x13-20020a056e021cad00b00325d0d82ddbmr289785ill.15.1683133290706; Wed, 03 May
 2023 10:01:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230503041631.3368796-1-mizhang@google.com> <ZFKLB1C+v6HKcy0o@google.com>
In-Reply-To: <ZFKLB1C+v6HKcy0o@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 3 May 2023 10:01:19 -0700
Message-ID: <CALMp9eTHsS2PwVu38QtOa7JkUvBuR7Znz5wjsNuWBfyjT1O8ow@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, May 3, 2023 at 9:25=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, May 03, 2023, Mingwei Zhang wrote:
> > Add MSR_IA32_TSX_CTRL into msrs_to_save[] to explicitly tell userspace =
to
> > save/restore the register value during migration. Missing this may caus=
e
> > userspace that relies on KVM ioctl(KVM_GET_MSR_INDEX_LIST) fail to port=
 the
> > value to the target VM.
> >
> > Fixes: b07a5c53d42a ("KVM: vmx: use MSR_IA32_TSX_CTRL to hard-disable T=
SX on guest that lack it")
> > Reported-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 237c483b1230..2236cfee4b7a 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1431,7 +1431,7 @@ static const u32 msrs_to_save_base[] =3D {
> >  #endif
> >       MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
> >       MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
> > -     MSR_IA32_SPEC_CTRL,
> > +     MSR_IA32_SPEC_CTRL, MSR_IA32_TSX_CTRL,
> >       MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATCH,
> >       MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
> >       MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
> > --
>
> Hmm, KVM shouldn't report the MSR if it can't be written by the guest.  O=
ver-

I think you mean to say that KVM shouldn't report the MSR if it can't
be written by *any* guest. KVM_GET_MSR_INDEX_LIST is a device ioctl,
so it isn't capable of filtering out MSRs that can't be written by
*the* guest, for some occurrence of "the."

> reporting won't cause functional issues, and the odds of the MSR existing=
 but not
> being reported in ARCH_CAPILIBITES are basically zilch, but IMO it's wort=
h adding
> the check if only to document when the MSRs is fully supported.
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e7f78fe79b32..d8608c6753ff 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7152,6 +7152,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>                 if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
>                         return;
>                 break;
> +       case MSR_IA32_TSX_CTRL:
> +               if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR=
))
> +                       return;
> +               break;
>         default:
>                 break;
>         }
