Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CC453D463
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350015AbiFDBV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350016AbiFDBVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:21:40 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3117C59969
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c11-20020a17090a4d0b00b001e4e081d525so5582758pjg.7
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3sb/I+ky1JUZTKaqAwigyM/L21YMBjQUFYwkaqETcv4=;
        b=m6nIko5GCN3MOxn/8rcQefG9rFEuGTTHfAsk4eI3uveGvlXGDq1hay6ZxQBAbKs7IY
         00hMab/FhZgS/YwhoLpoeuFZQ72xuwew7oLn+CW4USqq4RBNqvn+NaYfUrUK8wn2vLq4
         j+oWljM3i/T8gZQyijdTvsB2g/woL8QVyiEzPjKil5pn93meNbvXLxWhkcWaUf5QFcDu
         ydqz4lHjgSI2Q6i8KvdooE8lwGqdO+BKvFn5gzv7iuvakdXOsxkt54t2/qCQxclTeQHC
         FlgOqR2WQiN0+BhNfTV6H2nzPhfZM88AT4rL+C2NjTFRIFOZYyO61LMMuAUtlNcF0dpN
         sMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3sb/I+ky1JUZTKaqAwigyM/L21YMBjQUFYwkaqETcv4=;
        b=HbSnAe+JJQbP2+Nr6QD6vS99nRhhWAlQQKRMuOS5KIM47LL4r7AhA5w6XCuHeZrpTS
         lRTql0wdDqfGHJwMuzGz2Zr+S9WBaKnm3YSyU0S1sq6A9m2MhhVFNhlELpM0rHvxXMWC
         QuYRRNutESqnuiewgwpO/M6Qwi+2a1ZRJsgRZkiQIRH3iF+nkfWPc3cO7sXge3oadgYq
         YBfn6lv7hxs0Rs+0WEk/noJPbejSh61mdrL9zZPMX4pKwnwXP+600SecsEWJTdp79tcf
         Tq9edlxUjPWV3/SE9XI5wLjghfhsHGyNRAcLL3CBWcaQ7HYSs8gkFnkvjYR8lIbi0/yn
         ucHw==
X-Gm-Message-State: AOAM533Y2FtNkzFJPF85Sgc3OCVqZjmYsK5bzyZAuyiBb45HkDn2Kuzk
        4A/bf4i1a5rW0cuBYELIkQkU6S2Ey2M=
X-Google-Smtp-Source: ABdhPJwggjyOrjjIEMfnYF+4t5wXwGHaL4T2Qx0MyDWttr2/bgfgifikToGLp0dn0s8C1TcZHCw6lynqfBY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:319b:b0:51b:c5ec:62ba with SMTP id
 bj27-20020a056a00319b00b0051bc5ec62bamr11397413pfb.1.1654305680195; Fri, 03
 Jun 2022 18:21:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:27 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 11/42] KVM: selftests: Use kvm_cpu_has() in AMX test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Use kvm_cpu_has() in the AMX test instead of open coding equivalent
functionality using kvm_get_supported_cpuid_entry() and
kvm_get_supported_cpuid_index().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h    |  3 +++
 tools/testing/selftests/kvm/x86_64/amx_test.c   | 17 ++++++-----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 7992c665be1f..9a7ce6b047f1 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -107,9 +107,12 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_RDPID		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 22)
 #define	X86_FEATURE_SHSTK		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 7)
 #define	X86_FEATURE_IBT			KVM_X86_CPU_FEATURE(0x7, 0, EDX, 20)
+#define	X86_FEATURE_AMX_TILE		KVM_X86_CPU_FEATURE(0x7, 0, EDX, 24)
 #define	X86_FEATURE_SPEC_CTRL		KVM_X86_CPU_FEATURE(0x7, 0, EDX, 26)
 #define	X86_FEATURE_ARCH_CAPABILITIES	KVM_X86_CPU_FEATURE(0x7, 0, EDX, 29)
 #define	X86_FEATURE_PKS			KVM_X86_CPU_FEATURE(0x7, 0, ECX, 31)
+#define	X86_FEATURE_XTILECFG		KVM_X86_CPU_FEATURE(0xD, 0, EAX, 17)
+#define	X86_FEATURE_XTILEDATA		KVM_X86_CPU_FEATURE(0xD, 0, EAX, 18)
 #define	X86_FEATURE_XSAVES		KVM_X86_CPU_FEATURE(0xD, 1, EAX, 3)
 
 /*
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index dcad838953d0..bcf535646321 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -312,13 +312,12 @@ void guest_nm_handler(struct ex_regs *regs)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid_entry2 *entry;
 	struct kvm_regs regs1, regs2;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct kvm_x86_state *state;
-	int xsave_restore_size = 0;
+	int xsave_restore_size;
 	vm_vaddr_t amx_cfg, tiledata, xsavedata;
 	struct ucall uc;
 	u32 amx_offset;
@@ -329,17 +328,13 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	entry = kvm_get_supported_cpuid_entry(1);
-	TEST_REQUIRE(entry->ecx & CPUID_XSAVE);
-
-	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xd);
-
-	entry = kvm_get_supported_cpuid_index(0xd, 0);
-	TEST_REQUIRE(entry->eax & XFEATURE_MASK_XTILECFG);
-	TEST_REQUIRE(entry->eax & XFEATURE_MASK_XTILEDATA);
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_AMX_TILE));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILECFG));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILEDATA));
 
 	/* Get xsave/restore max size */
-	xsave_restore_size = entry->ecx;
+	xsave_restore_size = kvm_get_supported_cpuid_index(0xd, 0)->ecx;
 
 	run = vcpu->run;
 	vcpu_regs_get(vcpu, &regs1);
-- 
2.36.1.255.ge46751e96f-goog

