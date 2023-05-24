Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FDB710182
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 01:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbjEXXI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 19:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbjEXXI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 19:08:28 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207A299
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 16:08:27 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1ae64580e9fso31625ad.1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 16:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684969706; x=1687561706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uIGf3DX/t1yVaRSBiF6g+nRghGOxxs2qgmm7TStiZI=;
        b=pQrJjkly+JWvSS6WqrgX7WVhttD3oD0FFoWQv+S/8U7sVToiGsLNnF9FRRorNzzKQt
         ga5G21bM9rOSj8ju6vs+UgU77HkWgoc6XFOkBJOQ8p/fbBWygnsmRgahJnflVUOsvq94
         8ZQUR+3mEOD1JMflV0LxgIf3LKCu00Q+zfD/h2GUtIDbXGetUU+iXHvsNed+aX7G9CqM
         0GrQdXHigVrfBoab2kGUkcu0L1j2ypPndAIkdTl7MZgSHfwLUL8LFRQpvfVi2UEBnQYm
         nb1tRVb9MgmpKc6JVlPSX/sc2ResWe5XgSWqtnNj5Ti5rmUa/tncoMssQsKBEcVGR/25
         af+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684969706; x=1687561706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7uIGf3DX/t1yVaRSBiF6g+nRghGOxxs2qgmm7TStiZI=;
        b=f11Axn38TTPCEbLr+l4vn/exuWSKhXjTqDsS8Cf3FT257c9LUmZgWzDIdQnSJYc4C3
         6AYTwFm8GVrMhvvacOrejTWOvCYiVVv6cN9pBxh479x1A3cUoEeHlt7vxkxkmQeFc38z
         wGtxCnMy5+zob7hPVSJHEydSos7++Ymh6eicN9sfIEvknVGoRImyqF1HygEcUHa39gHk
         F+MJWGCkYiT1Htmc+fnU618t59YT8fsXLV7fUPTgZANMns8Y50v9Ovy2U0znclLox6Tq
         w6KCRXUxMyHUPaqPJj2jgCaJ+9u2E+VjH0ahrN3xjUso7BEq/oPEY/NjgtjOrj1wk+mE
         ZO/w==
X-Gm-Message-State: AC+VfDz8+wXwvumjTm3wBP/PJpQYfnSPYpK6tQHLV4OT+//BEBcVYHzr
        AhSMmDxHC5pL028peaqSY2veMTnjbN+MKE32fEHpLA==
X-Google-Smtp-Source: ACHHUZ63+Idbw/qt4T1qFTdyJfOJ0ruqx7xMAaVHR2RRTjlcbT6hGthEciYIg12Lx4T0cEZdAzOgYIooXEwjRHzh860=
X-Received: by 2002:a17:902:e5c3:b0:1a6:6a2d:18f0 with SMTP id
 u3-20020a170902e5c300b001a66a2d18f0mr23477plf.9.1684969706417; Wed, 24 May
 2023 16:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230323072714.82289-1-likexu@tencent.com> <20230323072714.82289-5-likexu@tencent.com>
In-Reply-To: <20230323072714.82289-5-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 24 May 2023 16:08:15 -0700
Message-ID: <CALMp9eT1e0OB0sRkGu_EhuAa_B5wQUQ9KajEQvN3gg231Pqzaw@mail.gmail.com>
Subject: Re: [PATCH 4/7] KVM: selftests: Test consistency of CPUID with num of
 Fixed counters
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Thu, Mar 23, 2023 at 12:28=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> =
wrote:
>
> From: Jinrong Liang <cloudliang@tencent.com>
>
> Add test to check if non-existent counters can be accessed in guest after
> determining the number of Intel generic performance counters by CPUID.
> Per SDM, fixed-function performance counter 'i' is supported if ECX[i] ||
> (EDX[4:0] > i). KVM doesn't emulate more counters than it can support.
>
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/=
testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> index 50902187d2c9..c934144be287 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> @@ -74,6 +74,22 @@ static uint8_t kvm_gp_ctrs_num(void)
>         return (kvm_entry->eax & GP_CTR_NUM_MASK) >> GP_CTR_NUM_OFS_BIT;
>  }
>
> +static uint8_t kvm_fixed_ctrs_num(void)
> +{
> +       const struct kvm_cpuid_entry2 *kvm_entry;
> +
> +       kvm_entry =3D get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
> +       return kvm_entry->edx & FIXED_CTR_NUM_MASK;
> +}
> +
> +static uint32_t kvm_fixed_ctrs_bitmask(void)
> +{
> +       const struct kvm_cpuid_entry2 *kvm_entry;
> +
> +       kvm_entry =3D get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
> +       return kvm_entry->ecx;
> +}
> +
>  static struct kvm_vcpu *new_vcpu(void *guest_code)
>  {
>         struct kvm_vm *vm;
> @@ -230,6 +246,39 @@ static void test_oob_gp_counter_setup(struct kvm_vcp=
u *vcpu, uint8_t eax_gp_num,
>         vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handle=
r);
>  }
>
> +static uint64_t test_oob_fixed_counter_setup(struct kvm_vcpu *vcpu,
> +                                            uint8_t edx_fix_num,
> +                                            uint32_t fixed_bitmask)
> +{
> +       struct kvm_cpuid_entry2 *entry;
> +       uint32_t ctr_msr =3D MSR_CORE_PERF_FIXED_CTR0;
> +       uint8_t idx =3D edx_fix_num;
> +       bool is_supported =3D true;
> +       uint64_t ret =3D 0xffffULL;
> +
> +       entry =3D vcpu_get_cpuid_entry(vcpu, 0xa);
> +       entry->ecx =3D fixed_bitmask;
> +       entry->edx =3D (entry->edx & ~FIXED_CTR_NUM_MASK) | edx_fix_num;
> +       vcpu_set_cpuid(vcpu);
> +
> +       /* Per Intel SDM, FixCtr[i]_is_supported :=3D ECX[i] || (EDX[4:0]=
 > i). */
> +       is_supported =3D (entry->ecx & BIT_ULL(idx) ||
> +                       ((entry->edx & FIXED_CTR_NUM_MASK) > idx));
> +
> +       /* KVM doesn't emulate more fixed counters than it can support. *=
/
> +       if (idx >=3D kvm_fixed_ctrs_num())
> +               is_supported =3D false;
> +
> +       if (!is_supported) {
> +               vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_g=
p_handler);
> +               ret =3D GP_VECTOR;
> +       }
> +
> +       vcpu_args_set(vcpu, 4, ctr_msr, ret, idx, 1);
> +
> +       return ret;
> +}
> +
>  static void intel_check_arch_event_is_unavl(uint8_t idx)
>  {
>         const char *msg =3D "Unavailable arch event is counting.";

This test seems bogus to me. The event may not be available because it
is inaccurate. That doesn't imply that the count will always be zero.

> @@ -267,10 +316,23 @@ static void test_oob_gp_counter(uint8_t eax_gp_num,=
 uint64_t perf_cap)
>         free_vcpu(vcpu);
>  }
>
> +static void intel_test_oob_fixed_ctr(uint8_t edx_fix_num, uint32_t fixed=
_bitmask)
> +{
> +       const char *msg =3D "At least one unsupported Fixed counter is vi=
sible.";

This test seems bogus to me. Unsupported does not imply invisible.

> +       struct kvm_vcpu *vcpu;
> +       uint64_t ret;
> +
> +       vcpu =3D new_vcpu(guest_wr_and_rd_msrs);
> +       ret =3D test_oob_fixed_counter_setup(vcpu, edx_fix_num, fixed_bit=
mask);
> +       run_vcpu(vcpu, msg, first_uc_arg_equals, (void *)ret);
> +       free_vcpu(vcpu);
> +}
> +
>  static void intel_test_counters_num(void)
>  {
>         uint8_t kvm_gp_num =3D kvm_gp_ctrs_num();
>         unsigned int i;
> +       uint32_t ecx;
>
>         TEST_REQUIRE(kvm_gp_num > 2);
>
> @@ -289,6 +351,12 @@ static void intel_test_counters_num(void)
>                 /* KVM doesn't emulate more counters than it can support.=
 */
>                 test_oob_gp_counter(kvm_gp_num + 1, perf_caps[i]);
>         }
> +
> +       for (ecx =3D 0; ecx <=3D kvm_fixed_ctrs_bitmask() + 1; ecx++) {
> +               intel_test_oob_fixed_ctr(0, ecx);
> +               intel_test_oob_fixed_ctr(kvm_fixed_ctrs_num(), ecx);
> +               intel_test_oob_fixed_ctr(kvm_fixed_ctrs_num() + 1, ecx);
> +       }
>  }
>
>  static void intel_test_arch_events(void)
> --
> 2.40.0
>
