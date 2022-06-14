Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400A154BB30
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356937AbiFNUHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352048AbiFNUHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:35 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96C3C2F
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2dc7bdd666fso34276987b3.7
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=kVwV6JYFJ6utxVeswV5UZJLPrp6uZhhdEbw3jp8RhEE=;
        b=WI/GojvuQE25iMByhGawtFgC8pDFtglByVBkcrSCmBzHfBVX+b9wbBRUbJMiZ24cpn
         ict/0+XoxFi4p6RzUhvABJQHpIDoeOGvungKIIDC3E8TUJQihcTHQ4b982kAS5ID4WTo
         OlMVSzBbgZl9UfkHgGavgVsEwPs02h9fU5J6Lac2SL5N2YCiX10U1j1ktDFwT/T5dnIY
         UdQ3UJF1EWMg68JGoF5JtLPbVWOOq0eAPsYrirzA+ViZAReYmzMeRx9Pc1LMn3kxmxv/
         44wsd5zQp3i01Ncrz+g1qChrthvY2A1TgkFisK9VNa1L3yD3t/U9clbsWH61dGkFMtGb
         drAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=kVwV6JYFJ6utxVeswV5UZJLPrp6uZhhdEbw3jp8RhEE=;
        b=lcarIC8kOpx1XeqqIs184VaIxO5nLyk/BdymMbiOU0xIi9xbxKH0iebiaMCP0UVK13
         qGPR6utGEYAjcCFjemfy2sInF+n1kzJ0tZU0I0zKJw8TSSpIIwYslRCiE6a3JsmQdQan
         jVDgNK55+HYPZ+GWQfMz8krLg7qptNpjS/yEIJJc9aGNuLoDxvWTzd/P8Jk02ew8/4RC
         6dV/FVsBQ+9vFnipySKicIFsOzQazfBwrC+yhyglJyKhAWUxvXgI6GOE4f42aLMFwfYu
         LJoAIZsJ9fHVabaGG8Z/5q0LwUpxEk0t1ckel3uPiuc63Bim6KPBUxqPDl9fw2gQbfpK
         hmZg==
X-Gm-Message-State: AJIora+JeY8M3w5trNGOdM+f5Kx2LRhCY7Pe87s+vDSLO1XHjEinxC7p
        hDxbKu50PWKb3eCDkgmXIJHqPaJe5Gc=
X-Google-Smtp-Source: AGRyM1tChiJEQJlnuBJBQoShmjkNfYkRf+ieBtVl8lBlIfxB/XmyQmKWhT+UtRF6beTnzZgrsKWhdYNrXrg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a0d:eb08:0:b0:30c:2f46:f7aa with SMTP id
 u8-20020a0deb08000000b0030c2f46f7aamr7552327ywe.299.1655237247728; Tue, 14
 Jun 2022 13:07:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:33 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 08/42] KVM: selftests: Drop redundant vcpu_set_cpuid() from
 PMU selftest
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop a redundant vcpu_set_cpuid() from the PMU test.  The vCPU's CPUID is
set to KVM's supported CPUID by vm_create_with_one_vcpu(), which was also
true back when the helper was named vm_create_default().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 667d48e8c1e0..dc3869d5aff0 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -53,7 +53,6 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid2 *cpuid;
 	struct kvm_cpuid_entry2 *entry_a_0;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -66,7 +65,6 @@ int main(int argc, char *argv[])
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	cpuid = kvm_get_supported_cpuid();
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
@@ -77,7 +75,6 @@ int main(int argc, char *argv[])
 	__TEST_REQUIRE(eax.split.version_id, "PMU is not supported by the vCPU");
 
 	/* testcase 1, set capabilities when we have PDCM bit */
-	vcpu_set_cpuid(vcpu, cpuid);
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
 
 	/* check capabilities can be retrieved with KVM_GET_MSR */
-- 
2.36.1.476.g0c4daa206d-goog

