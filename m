Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0874954BB49
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357858AbiFNUJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357820AbiFNUIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:41 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1562E4EF7C
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x1-20020a170902ec8100b0016634ff72a4so5340556plg.15
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7dK1gA3gQqs3fKdWhyCzD6xfEZc5UbOlaOb38QzqS2U=;
        b=EfidSeuIFghasfraZ/h9MY6yqwTwna2AYjeiLNaoG1XPpeGj8hqD/XONv0aLw+T4rk
         XipfpeJLj7y8ros9hl/NR4Wzo2ZSolo+APyf30zS+di7ZDk8pMKT31y9yay7d/aXd/aZ
         UGYyql+gZtqm5yttsA8J3L22Ab9c28Llr/DUAzQGK6YzaB9GaepTwZIODnUUnuqjBrog
         K9RcMSBzA75u++KgAZajQ0G1AG34vuohCykGQDijr8+xxdQ4vQdUgAfvVYsry/Bf5y5r
         LZsW75VLszGu7ubjZjo/F+zsC/AZKMaZThpT2BPIls3EOuBsYulJFkBhy2MuD3i02yOI
         59PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7dK1gA3gQqs3fKdWhyCzD6xfEZc5UbOlaOb38QzqS2U=;
        b=dqjN2Ei3SLavW/t93UtDPjwP8hEwvh0y02o2/DdBAVIucVkUwumFfsIUh5uBSxsH34
         aLM5hGYN9qcAm4PqI/Q1jARkHLU4vhzs087lfhwn1S2AknYbyQY6nUuAEkYykqyxqGgK
         R8R6Wbe/oTSySqqiJLu8I6+rVLbNDYMYuj3vYpTFDbO8gx2Zry8L3Zhf7zrGYKbN/u5s
         C/3d5WjG7gVRoLjeoVp59RdKuhCoUPEdK/O/sLNz0LJfVVbOW5Z8nDK+AmH8sFXFKV6s
         4cGvomGuuKbxI5cqOFH/F12wOUoTbiFJt85V/CCvW/fmlD+UyO7LEvT//fJkTQzEHqBD
         727g==
X-Gm-Message-State: AOAM533sv6uyqm/FkyXm4mAmFz0reLEYxY4n67lmUhkilWIHU5D1dX3k
        S3kWFitDdGfTDb6Be6uAcBddlmA3QuU=
X-Google-Smtp-Source: ABdhPJwxNNqOpI9VOAwwy5MYZeAACQttRNAKCs5bimbP/mDlaSZ/xbLFtZQWnairbklsaQB1SVD2pgo4eBU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a65:6c08:0:b0:3f2:6a6a:98d with SMTP id
 y8-20020a656c08000000b003f26a6a098dmr5888282pgu.30.1655237284555; Tue, 14 Jun
 2022 13:08:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:54 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-30-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 29/42] KVM: selftests: Use vcpu_clear_cpuid_feature() to
 clear x2APIC
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add X86_FEATURE_X2APIC and use vcpu_clear_cpuid_feature() to clear x2APIC
support in the xAPIC state test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h |  1 +
 tools/testing/selftests/kvm/x86_64/xapic_state_test.c  | 10 +---------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0633196e7b79..98d05e153fa3 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -81,6 +81,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_SMX			KVM_X86_CPU_FEATURE(0x1, 0, ECX, 6)
 #define	X86_FEATURE_PDCM		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 15)
 #define	X86_FEATURE_PCID		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 17)
+#define X86_FEATURE_X2APIC		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 21)
 #define	X86_FEATURE_MOVBE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 22)
 #define	X86_FEATURE_TSC_DEADLINE_TIMER	KVM_X86_CPU_FEATURE(0x1, 0, ECX, 24)
 #define	X86_FEATURE_XSAVE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 26)
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index 7728730c2dda..1bc091f3b58b 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -122,9 +122,7 @@ int main(int argc, char *argv[])
 		.vcpu = NULL,
 		.is_x2apic = true,
 	};
-	struct kvm_cpuid2 *cpuid;
 	struct kvm_vm *vm;
-	int i;
 
 	vm = vm_create_with_one_vcpu(&x.vcpu, x2apic_guest_code);
 	test_icr(&x);
@@ -138,13 +136,7 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&x.vcpu, xapic_guest_code);
 	x.is_x2apic = false;
 
-	cpuid = x.vcpu->cpuid;
-	for (i = 0; i < cpuid->nent; i++) {
-		if (cpuid->entries[i].function == 1)
-			break;
-	}
-	cpuid->entries[i].ecx &= ~BIT(21);
-	vcpu_set_cpuid(x.vcpu);
+	vcpu_clear_cpuid_feature(x.vcpu, X86_FEATURE_X2APIC);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 	test_icr(&x);
-- 
2.36.1.476.g0c4daa206d-goog

