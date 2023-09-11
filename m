Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B0479B358
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbjIKUtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbjIKLox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:44:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AF8CDD;
        Mon, 11 Sep 2023 04:44:49 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 98e67ed59e1d1-26f3975ddd4so3375886a91.1;
        Mon, 11 Sep 2023 04:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432689; x=1695037489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XS4l8NjypD0OWjSmUSnK/9QZ38cmUYdqmRK9Wl6+lME=;
        b=g4mI7GMqGPcjyt9bL2hFhwZ5I0FxVmC9Z//XgV1dwjW/DqufL3KaH049HPxrSh2U/a
         RMiwUeQRyrEio9CoUTwcRnPZthh2SbXFzkI/5lD6LXCFpas2q/DZRkp/kOHvnlwLL53N
         F+LA0/KRXN6wVWGdfX7wn3zE0BZ6wF89Pqji2hATBlv9Sdhm4NI0stak9ZwkpGykl96r
         2QN0l4lvrWyTMpo2rosn4xqcomh1PhISUCPPgAhOBSuUCngGPmFkgbLIfX2MImIcUXZB
         puOvR1XiX7bPbK9YNkHToXQajWj/DR4jL8Q2vVMWKj/lXkLWV40yHJ2FAsaLVjezglz/
         65RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432689; x=1695037489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XS4l8NjypD0OWjSmUSnK/9QZ38cmUYdqmRK9Wl6+lME=;
        b=xUeRof2/o2TUvqFyBZMyYWwtP9pcYhYdXcVNpucJ7TJDIs+g8iE2I4Q6YgyXcepO04
         LM3RcdZeiCX916iobWVZyb57/ir6ZqYYDFufeMFp6isAZGvHbi/DmVLJJL9EEOlxzRil
         QyO/kgUy+0m7rcrTXOYk9qeSV9WQd3iqHxT93/zwA76tWjkMXoTXx7RXr/rLOFhriBNC
         La2ncPptAHHgugo0nmb4EL9a/fsq18rP/ZwAWYlRcADKFj+Xbltmf8yH+WzyA+iqA6ju
         j/J/Vbf0CFZKNhb+qBFdVyHiAtFiyygqKAlNfKlXdStd9BC0kuijPCwlziLaNWlmgauM
         WHPQ==
X-Gm-Message-State: AOJu0YyXbkvhFB4b5LxXCMy7VBfRVoNtsTltDPYOq1ZF+MsjaTc2jL7l
        tmrzkPTbgOEjz2dQMOHv/Vo8yCb/Oa6IRb2H
X-Google-Smtp-Source: AGHT+IEm5WNIXk0lYZ5DBRk4aFK9xALQuUJIbtn8h0hpFzKcdBtiBcy63vgdALyHL4Iun1GKjH9LGg==
X-Received: by 2002:a17:90a:289:b0:262:fc8a:ed1 with SMTP id w9-20020a17090a028900b00262fc8a0ed1mr8879745pja.44.1694432689300;
        Mon, 11 Sep 2023 04:44:49 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:48 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/9] KVM: selftests: Test consistency of CPUID with num of fixed counters
Date:   Mon, 11 Sep 2023 19:43:45 +0800
Message-Id: <20230911114347.85882-8-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911114347.85882-1-cloudliang@tencent.com>
References: <20230911114347.85882-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

Add test to check if non-existent counters can be accessed in guest after
determining the number of Intel generic performance counters by CPUID.
Per SDM, fixed-function performance counter 'i' is supported if ECX[i] ||
(EDX[4:0] > i). KVM doesn't emulate more counters than it can support.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index e636323e202c..df76f0f2bfd0 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -251,8 +251,32 @@ static void test_oob_gp_counter(uint8_t eax_gp_num, uint64_t perf_cap)
 	kvm_vm_free(vm);
 }
 
+static void guest_rd_wr_fixed_counter(void)
+{
+	uint8_t nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+
+	__guest_wrmsr_rdmsr(MSR_CORE_PERF_FIXED_CTR0, nr_fixed_counters, true);
+}
+
+static void test_oob_fixed_ctr(uint8_t edx_fixed_num)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_rd_wr_fixed_counter);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK, 0);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_FIXED_COUNTERS,
+				edx_fixed_num);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
 static void test_intel_counters_num(void)
 {
+	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	unsigned int i;
 
@@ -271,6 +295,10 @@ static void test_intel_counters_num(void)
 		/* KVM doesn't emulate more counters than it can support. */
 		test_oob_gp_counter(nr_gp_counters + 1, perf_caps[i]);
 	}
+
+	test_oob_fixed_ctr(0);
+	test_oob_fixed_ctr(nr_fixed_counters);
+	test_oob_fixed_ctr(nr_fixed_counters + 1);
 }
 
 int main(int argc, char *argv[])
-- 
2.39.3

