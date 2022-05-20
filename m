Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9BB52EB66
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348872AbiETMBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 08:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348990AbiETMBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 08:01:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F8755FD4
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 05:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653048069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T1/te+4Y4ho6udDKU3FETTF4lh1tRvJCKy5k3ZgQWfQ=;
        b=gkwAIZQNU6UGt1Y/Pw+6l4pk9psDUkdylZrkkgMYcc5ysgSV/gNRJIeLsmIuHAexWtlAYC
        2Ybpg3T7LUZJOl149qmD/UoG+Q49h5QrR0cPCriE+srrIrSwmTYggPtPsqcOV8notSSGr7
        shc9PJbR2RdNF4khKRoPdWoJXYi1zE0=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-jJYeWG-rPnix4tuKx9YZXQ-1; Fri, 20 May 2022 08:01:07 -0400
X-MC-Unique: jJYeWG-rPnix4tuKx9YZXQ-1
Received: by mail-pl1-f197.google.com with SMTP id x23-20020a170902b41700b0015ea144789fso4043213plr.13
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 05:01:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T1/te+4Y4ho6udDKU3FETTF4lh1tRvJCKy5k3ZgQWfQ=;
        b=toGWzIRp8FKFSuXAhwumz4QJKg4NDhdZflvkR0iDkppmrvhHDTEajpV78h3NXSaLBe
         /zSSDcG+CUOFPI4nrsYReXpskWv4viXGqfEWtF8Uoa3sVKWM96lWkcpFwBjMcyghRp5b
         bBguK8/Dp7H6v1vpoyASwKigbm3bOqUi4kjk2uMCVj3my8rB4U+3Tf+i/OzItzcs+tmp
         vg+wcukYkfFRQO2DWrHa8KOB72MQhk9g1rED81fi9/wQeUflMXyXE21SXNg2E73QfcAt
         BXBZTlVkGGJYBaeYfB1kSYRiRwveAuW6I78KCUDQdl5lDsuwGo0UzY2RGSohylJiAfpj
         L4Og==
X-Gm-Message-State: AOAM530B2bOxXY9Z7BQWZltoQdvjDM55xfMCzIQcJjt725/aYWBrSsds
        b/XjIqqEUF3HNYi/2K3ezgbtL5h6VzOpOp4eNqS9LGldR4jlFCu4pL15H2oqtYAI26Uj34S9CQq
        5kMpth25HbN6pb/iQcwcBOtCk3/3S
X-Received: by 2002:a05:6a00:174a:b0:4fd:ac35:6731 with SMTP id j10-20020a056a00174a00b004fdac356731mr9599118pfc.71.1653048066246;
        Fri, 20 May 2022 05:01:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyw8odYerMJXPa7j+8qH+HKggUd27IfpqiiBb6TBD0oWyj+epTj2Yq+QIkthft/bauWj3S2LYpOoYBUKf2zvHM=
X-Received: by 2002:a05:6a00:174a:b0:4fd:ac35:6731 with SMTP id
 j10-20020a056a00174a00b004fdac356731mr9599093pfc.71.1653048065938; Fri, 20
 May 2022 05:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220518170118.66263-1-likexu@tencent.com>
In-Reply-To: <20220518170118.66263-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 20 May 2022 14:00:54 +0200
Message-ID: <CABgObfaNZqE+z5WA8VRPco9c_Swa15qyom7ieHGFRWzw39kU=g@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86/pmu: Move the vmx_icl_pebs_cpu[] definition
 out of the header file
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued all three, thanks.

Paolo

On Wed, May 18, 2022 at 7:01 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> Defining a static const array in a header file would introduce redundant
> definitions to the point of confusing semantics, and such a use case woul=
d
> only bring complaints from the compiler:
>
> arch/x86/kvm/pmu.h:20:32: warning: =E2=80=98vmx_icl_pebs_cpu=E2=80=99 def=
ined but not used [-Wunused-const-variable=3D]
>    20 | static const struct x86_cpu_id vmx_icl_pebs_cpu[] =3D {
>       |                                ^~~~~~~~~~~~~~~~
>
> Fixes: a095df2c5f48 ("KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake=
 guest PDIR counter")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.c | 7 +++++++
>  arch/x86/kvm/pmu.h | 8 --------
>  2 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index b5d0c36b869b..a2eaae85d97b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -16,6 +16,7 @@
>  #include <linux/bsearch.h>
>  #include <linux/sort.h>
>  #include <asm/perf_event.h>
> +#include <asm/cpu_device_id.h>
>  #include "x86.h"
>  #include "cpuid.h"
>  #include "lapic.h"
> @@ -27,6 +28,12 @@
>  struct x86_pmu_capability __read_mostly kvm_pmu_cap;
>  EXPORT_SYMBOL_GPL(kvm_pmu_cap);
>
> +static const struct x86_cpu_id vmx_icl_pebs_cpu[] =3D {
> +       X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
> +       X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
> +       {}
> +};
> +
>  /* NOTE:
>   * - Each perf counter is defined as "struct kvm_pmc";
>   * - There are two types of perf counters: general purpose (gp) and fixe=
d.
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index dbf4c83519a4..ecf2962510e4 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -4,8 +4,6 @@
>
>  #include <linux/nospec.h>
>
> -#include <asm/cpu_device_id.h>
> -
>  #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
>  #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu=
))
>  #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
> @@ -17,12 +15,6 @@
>  #define VMWARE_BACKDOOR_PMC_REAL_TIME          0x10001
>  #define VMWARE_BACKDOOR_PMC_APPARENT_TIME      0x10002
>
> -static const struct x86_cpu_id vmx_icl_pebs_cpu[] =3D {
> -       X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
> -       X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
> -       {}
> -};
> -
>  struct kvm_event_hw_type_mapping {
>         u8 eventsel;
>         u8 unit_mask;
> --
> 2.36.1
>

