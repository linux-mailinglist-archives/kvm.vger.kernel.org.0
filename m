Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9ED5892B0
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 21:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbiHCT1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 15:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiHCT1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 15:27:05 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BB656BBD
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 12:27:04 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p35-20020a631e63000000b0041992866de0so7183788pgm.19
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 12:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=nm7CFbOdnKtZDNkgkKBzXQSPp+dIl3jdjLzC+jO16zk=;
        b=UJ2itWk2ezkIYRhnzAmzoIQO8u9ey77vKkdIhOd9vs8Zeh71OH2Ir0xFAgTl5ekOdQ
         zg4kSUzcMulV8zPGAmflfEkY8hdvqVxKfwgo3tN6kvzJ7cctBjo+NdAb+qPg81Z31eH1
         2k8GX3GntwsZ70h5FT00xRMSJlk7Ms902eCR6sQsk14inYSRrJn4PoHnxsJ6cCx+xWx6
         A8tH6ERH0TGgjMT6bjFklvTFBR5/PHNbdqm1O3lq8/lEI/G+5r7PEnb2vhv19udY9ok7
         V9hse3EWlAzb3IF2d7b2PyMdFA8w2Bj/vQj3EZzWcyi0aZAb+hIdq1wBC6EoFxSHijIr
         b9Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=nm7CFbOdnKtZDNkgkKBzXQSPp+dIl3jdjLzC+jO16zk=;
        b=Sx3K5WEmNHV+MIlC/VcaR1mpSKWddl+Edx92QAZq2fzhzvhtlMiJxUh2LauDKmMUVe
         D8zKAr5MoLjqUhZHkUyqVXN0RxqqXAb0S3cCOH2CbARbIjmzGaxBPW6aCRNPmoz8fsLl
         qeZy0fh/Gz4Vwn9XceIih7GHkbnlvgBruYlaFBbVI5n4ATqbEtmNXRGzgcUrmXVSEwNg
         AmBGW5CJU0SNJcp5ngvAa8Wnx5jSim9fItz60c2MVTnSaRB2u2jl5y300GHk/6hAAFlc
         c3jy8lKdNu2UvzHk//rOUOec1vO2viI+SpHPN3ntwNUO63HsVy4umpPtGkmjM9LvtvNC
         yB3w==
X-Gm-Message-State: AJIora9X8Ph9B7tdl3q4jmBnMbEe2fb236RUfOR24no+Hv++ndGXqGuq
        vyYWgtWU9i3RWkoe7HVpvbnMPHCYzNc=
X-Google-Smtp-Source: AGRyM1smK3BViI7TxhEbyAjRfforzWrdjCXIGbu9LuouDuELMs/W7f0KHUYaF4H+R7SWS+UD94l95eGoDe8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:e258:0:b0:41a:d92b:64f9 with SMTP id
 y24-20020a63e258000000b0041ad92b64f9mr21846257pgj.148.1659554824574; Wed, 03
 Aug 2022 12:27:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Aug 2022 19:26:52 +0000
In-Reply-To: <20220803192658.860033-1-seanjc@google.com>
Message-Id: <20220803192658.860033-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220803192658.860033-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2 1/7] KVM: x86: Refresh PMU after writes to MSR_IA32_PERF_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refresh the PMU if userspace modifies MSR_IA32_PERF_CAPABILITIES.  KVM
consumes the vCPU's PERF_CAPABILITIES when enumerating PEBS support, but
relies on CPUID updates to refresh the PMU.  I.e. KVM will do the wrong
thing if userspace stuffs PERF_CAPABILITIES _after_ setting guest CPUID.

Note, KVM may do the "wrong" thing if userspace changes PERF_CAPABILITIES
after running the vCPU, i.e. after KVM_RUN.  Similar to disallowing CPUID
changes after KVM_RUN, KVM should also disallow changing feature MSRs
after KVM_RUN to prevent unexpected behavior.  That problem will be
addressed separately at it affects MSRs other than PERF_CAPABILITES.

Opportunistically fix a curly-brace indentation.

Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33560bfa0cac..dc19298e7150 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3546,9 +3546,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 
 		vcpu->arch.perf_capabilities = data;
-
+		kvm_pmu_refresh(vcpu);
 		return 0;
-		}
+	}
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
 	case MSR_K7_HWCR:
-- 
2.37.1.559.g78731f0fdb-goog

