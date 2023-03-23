Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03D26C728B
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 22:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCWVrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjCWVrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 17:47:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29B0EB70
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:46:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i11-20020a256d0b000000b0086349255277so40514ybc.8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679608019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CTMwrqpUTqfKJNKABQxyuPRZFm+OY3BpBYx/0ZFfQGM=;
        b=HwhF0mUYrDAEY8QC1KfVPD/q+4T8bEkCrwgmBLGE0TQ9FWHEsvSfRvnLG5ggtkwasW
         5DdlW/+COEpgxOTFVsdjZB9GHau8mr4+c0ef1rx+xnoQN6MSc2wYGcKS7aVKhJKmlhGh
         IGOt03+5x/daXgchCvC4ZDC6C+g13lGgOKgWvs5OSXVBs0Rbvxeiy+P/b6mS85+gKZAU
         EbOrbx5n9UtG6QQcPKNMt1gT7hKVsVWI9bIM9OjJMu18OPCyjcnjDo+j7yjz6+fDiQ2F
         jixh7VqiPB4Yw+2OpYTq1sGyYCxG1T+rW9fzk8rq4vogqpRMqKs7Vme3Dxz5RWXam1iK
         M4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679608019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CTMwrqpUTqfKJNKABQxyuPRZFm+OY3BpBYx/0ZFfQGM=;
        b=zmNcXb9IsyBGoxhh0fY70VMyrY3L2+Ut4DyLsxlXT+J7ISBdj1huId9JaDiTrWbWPd
         ANNTIJEPF+IXiOOMXfmpq7C3jYlp0oR/pckQT7t3fDU949UihtcXwQIRPw3KglDxxVSz
         zw4ckP8Imx8GSSSXxYxqsNtVYGAIE5/6XauMCgCSb6n2xvtJvugxI1zdvv6VLUbvvXv9
         rD0IkQyL5Y01dSVvCBkzzV+hL8Nxi9x1CM3WbvSu9r9VNkmTrKKZaH69TzvmbuhtMoKR
         aFt5UkxrDWrqeb/G65//Z6YMq9r0CK0hrg+s3uYp4GBRxgbDRwcrAOy1yARJ8o4eFYqX
         3h4g==
X-Gm-Message-State: AAQBX9f1nOnkKSMpqtzhp2ZCzcit9DCM589Qm/YpPCJnw1wOOvlKWWgR
        1TicZitfOcI4BMbIP/tYhbOcyzaEduo=
X-Google-Smtp-Source: AKy350amloXgE+vRSf6+MUJjsuifmaA2jspMzXGcjPZV5wStmbvEG+3xaowsAtkXE3DFN0uFbPtCaW+Hgbw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b3c6:0:b0:541:7f69:aa9b with SMTP id
 r189-20020a81b3c6000000b005417f69aa9bmr27359ywh.4.1679608018892; Thu, 23 Mar
 2023 14:46:58 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:46:57 -0700
In-Reply-To: <20230224223607.1580880-9-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com> <20230224223607.1580880-9-aaronlewis@google.com>
Message-ID: <ZBzI0eTlpJR9A1Xp@google.com>
Subject: Re: [PATCH v3 8/8] KVM: selftests: Add XCR0 Test
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        mizhang@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023, Aaron Lewis wrote:
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index ebe83cfe521c..380daa82b023 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -667,6 +667,15 @@ static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
>  	       !this_cpu_has(feature.anti_feature);
>  }
>  
> +static __always_inline uint64_t this_cpu_supported_xcr0(void)
> +{
> +	uint32_t a, b, c, d;
> +
> +	cpuid(0xd, &a, &b, &c, &d);
> +
> +	return a | ((uint64_t)d << 32);

This can be done via X86_PROPERTY.  It's not that much prettier, but it at least
avoids open coding things.

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index fa49d51753e5..2bb0ec8dddf3 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -228,8 +228,11 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_PMU_NR_GP_COUNTERS                KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 8, 15)
 #define X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 24, 31)
 
+#define X86_PROPERTY_SUPPORTED_XCR0_LO         KVM_X86_CPU_PROPERTY(0xd,  0, EAX,  0, 31)
 #define X86_PROPERTY_XSTATE_MAX_SIZE_XCR0      KVM_X86_CPU_PROPERTY(0xd,  0, EBX,  0, 31)
 #define X86_PROPERTY_XSTATE_MAX_SIZE           KVM_X86_CPU_PROPERTY(0xd,  0, ECX,  0, 31)
+#define X86_PROPERTY_SUPPORTED_XCR0_HI         KVM_X86_CPU_PROPERTY(0xd,  0, EDX,  0, 31)
+
 #define X86_PROPERTY_XSTATE_TILE_SIZE          KVM_X86_CPU_PROPERTY(0xd, 18, EAX,  0, 31)
 #define X86_PROPERTY_XSTATE_TILE_OFFSET                KVM_X86_CPU_PROPERTY(0xd, 18, EBX,  0, 31)
 #define X86_PROPERTY_AMX_TOTAL_TILE_BYTES      KVM_X86_CPU_PROPERTY(0x1d, 1, EAX,  0, 15)
@@ -669,11 +672,11 @@ static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
 
 static __always_inline uint64_t this_cpu_supported_xcr0(void)
 {
-       uint32_t a, b, c, d;
+       if (!this_cpu_has_p(X86_PROPERTY_SUPPORTED_XCR0_LO))
+               return 0;
 
-       cpuid(0xd, &a, &b, &c, &d);
-
-       return a | ((uint64_t)d << 32);
+       return this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_LO) |
+              ((uint64_t)this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_HI) << 32);
 }
 
 typedef u32            __attribute__((vector_size(16))) sse128_t;

> +/* Architectural check. */

If you're going to bother with a comment, might as well actually explain the
architectural rule.

/*
 * Assert that architectural dependency rules are satisfied, e.g. that AVX is
 * supported if and only if SSE is supported.
 */

> +#define ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0, xfeatures, dependencies)	  \
> +do {										  \
> +	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (dependencies)); \
> +										  \
> +	GUEST_ASSERT_3((__supported & (xfeatures)) != (xfeatures) ||		  \
> +		       __supported == ((xfeatures) | (dependencies)),		  \
> +		       __supported, (xfeatures), (dependencies));		  \
> +} while (0)
> +

> +/*
> + * KVM's own software-defined rules.  While not architectural it really
> + * ought to be true.

This should call out what KVM's "rule" is.  But it's not really a rule, it's more
of a contract with userspace.

/*
 * Assert that KVM reports a sane, usable as-is XCR0.  Architecturally, a CPU
 * isn't strictly required to _support_ all XFeatures related to a feature, but
 * at the same time XSETBV will #GP if bundled XFeatures aren't enabled and
 * disabled coherently.  E.g. a CPU can technically enumerate supported for
 * XTILE_CFG but not XTILE_DATA, but attempt to enable XTILE_CFG without also
 * enabling XTILE_DATA will #GP.
 */

> +	/* Tell stdout not to buffer its content */
> +	setbuf(stdout, NULL);

This copy pasta is no longer necessary, see kvm_selftest_init().
