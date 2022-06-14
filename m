Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32E954BB68
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357226AbiFNUIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356266AbiFNUHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:41 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8421056C
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:33 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 37-20020a630a25000000b003fdcbe1ffc8so5459130pgk.11
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=h/OjiDb6ZU4P5Rs5vu7aiUIGzMiM/JPLT2d72W0LmOU=;
        b=V/PVBaSR2bLGOHRJbPWigQqdEEPXG7MEjVfNM/QRCqTtB7/z8VLHqdL1HAY4cIKh60
         nQw1kz9GcPK9lyYvtOgx4NSRZ0WQ/nY1eML4nb3GpY6LyyNbs25KuVJNwF8EEZmJUvX/
         UwoNvUIT5gaC22a4bjCA3q6ite18+bSIiZn+SX3kGMPzxlgT0wKGNO1Ltri6OL689KQG
         IuloNc3NWtPYLD4sRv8VTVQtCb3JCLOndw9IRZMZdpGjqs2QhR+sbassZmk6ZohOrAod
         9SMfepYTN7O6dwEpqfO3w37+vydn+++QS7q3zbUqVtoUiN5fJPXn46d+5KErcQImCBcW
         oxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=h/OjiDb6ZU4P5Rs5vu7aiUIGzMiM/JPLT2d72W0LmOU=;
        b=7aQJ/TLHkJWGXsw8DXMYBZ12XweOxMJD/kQLAJZQA3gRl79JdsB3JurWF/OmUETJH2
         FvXC8z21cMGyRkaar0Lb1IlzeZr89HeG8J+cJpKPDq1i1F7vQpDjDcZCyzOy1jDwIfHZ
         YcWhRM4m4YlLq9Ch6TsUmoBLG7wYUeDtX2GH/Trum/OVeVLtnmBxo65l+UvkX1zkhWTY
         EEgc297KE/FM/Aq2S4XW42KqADdaH1QdlCl5cYkGO7HE58BK6QpSTXS9sBCODFRrhF9s
         je+WcY2rxxEPAAy7dZn66QehHScLn/kvcRDGYaxzGVrJh7rny6xA9g5J3uCkjzZD6NiO
         4T8A==
X-Gm-Message-State: AJIora++7a9vSyEGth6xPa0BL5aoEGBhNpiE5fulLyPmA+vWFR5LMfyX
        OMJ6Xs75V9/YXEoTIBDXDPbKI/Cfrsg=
X-Google-Smtp-Source: AGRyM1sbl6DAPvZxgxT8mIXgVOSQ2LO6MFqbJax4sOk95lVr2Hlq+qrnHEPEhZB92ZdPwkAmkT8eCtHGi/s=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr192553pje.0.1655237252726; Tue, 14 Jun
 2022 13:07:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:36 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 11/42] KVM: selftests: Use kvm_cpu_has() in AMX test
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
index 2100eb08916a..b5d2e6c69c1a 100644
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
2.36.1.476.g0c4daa206d-goog

