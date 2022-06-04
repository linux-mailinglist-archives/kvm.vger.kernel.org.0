Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A6E53D455
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350308AbiFDBYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350314AbiFDBXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:23:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7E630542
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id il9-20020a17090b164900b001e31dd8be25so8058246pjb.3
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=A+L4jwrNVFSobkDaNlEHqZZXKqAiVfG+Yz1ECFVoH7Q=;
        b=HClLGhYby2O6RWKIEcvB51oC+LESLcXBFm+QPDW4faSXz8u/ADPEgTOFSi1b/DDmYF
         ZHu4sFU1Hf5EuYnyukOn5QYVosm5hyXnuiohksPACKw5KpIcUdx6yh/9/bSE5oN+5rlK
         lKwkweL4a9GsPCllj8CzJjdXi+7lAIKD1jDrywxjlhXKp/t20JG5kBWawSpncwPve41f
         CJj9oPnATjpYJj3GkCWYuL08925Jqeah0+/SD4TYylpKF5XEejPasZ/UTZe3K2OkI5up
         BOT7cf1NmXwh/dX/OLCLZ/i+HIw05jmvq5J03GVmEVupmvqO0mx3wDLscfTeYCZhkmIY
         Pa8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=A+L4jwrNVFSobkDaNlEHqZZXKqAiVfG+Yz1ECFVoH7Q=;
        b=evUm9HbcfevTYFT8V3Ibpm839xFNGnhlWdwkxJ4nApa7qpx/SzgnU1qC0S0Q3vfJyK
         1KA/atveTs73lbraCg5w47JnyogmnTrNMSjn50KfCPjFiIUFSi5I9N46ENTSKAq3Xsv/
         3kGPJMJ++EzCkUOi6MqHBlZeOIE6v3Ox87edozryBFvGZ1bG2icGbfeNiFctO8DTlJNv
         1jtOsNI3Zp27b+47yFNu7dolhTnGXNqLUTJZPipa/u7NpE5BFUL+2+tZBpfvO9Xp2+YB
         XPwpAYd4F4j+d0eQcLbh4kOMxKEe6bVotSQzDlX6yYijPJB3AWNSWTh6OrmwBBqm6n/N
         rmJw==
X-Gm-Message-State: AOAM531o9n54+tyC8lD7GJc3kNRhhkOFalru7brRuhb1lkRQFDDzojdQ
        GZOeh289Kz7WJa68drU8AtO4veh4VdQ=
X-Google-Smtp-Source: ABdhPJzEtoqkkyDnh1nYx3K/1boz5Ym37vwjBt8KpMw9Fqj5RUpFpkiIeVTrXaMlyUkmaUk9JYjOCaYYpKA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:23ce:b0:50d:823f:981 with SMTP id
 g14-20020a056a0023ce00b0050d823f0981mr12822497pfc.10.1654305731282; Fri, 03
 Jun 2022 18:22:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:56 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-41-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 40/42] KVM: selftests: Clean up requirements for XFD-aware
 XSAVE features
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Provide informative error messages for the various checks related to
requesting access to XSAVE features that are buried behind XSAVE Feature
Disabling (XFD).

Opportunistically rename the helper to have "require" in the name so that
it's somewhat obvious that the helper may skip the test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 5 ++++-
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 8 +++++---
 tools/testing/selftests/kvm/x86_64/amx_test.c          | 2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e97b7c4ce367..3fd3d58148c2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -758,7 +758,10 @@ void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
 
-void vm_xsave_req_perm(int bit);
+void __vm_xsave_require_permission(int bit, const char *name);
+
+#define vm_xsave_require_permission(perm)	\
+	__vm_xsave_require_permission(perm, #perm)
 
 enum x86_page_size {
 	X86_PAGE_SIZE_4K = 0,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 86e610967e79..6e8c8781996c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -579,7 +579,7 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	vcpu_sregs_set(vcpu, &sregs);
 }
 
-void vm_xsave_req_perm(int bit)
+void __vm_xsave_require_permission(int bit, const char *name)
 {
 	int kvm_fd;
 	u64 bitmask;
@@ -597,10 +597,12 @@ void vm_xsave_req_perm(int bit)
 	close(kvm_fd);
 
 	if (rc == -1 && (errno == ENXIO || errno == EINVAL))
-		exit(KSFT_SKIP);
+		__TEST_REQUIRE(0, "KVM_X86_XCOMP_GUEST_SUPP not supported");
+
 	TEST_ASSERT(rc == 0, "KVM_GET_DEVICE_ATTR(0, KVM_X86_XCOMP_GUEST_SUPP) error: %ld", rc);
 
-	TEST_REQUIRE(bitmask & (1ULL << bit));
+	__TEST_REQUIRE(bitmask & (1ULL << bit),
+		       "Required XSAVE feature '%s' not supported", name);
 
 	TEST_REQUIRE(!syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit));
 
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 411a33cd4296..5d749eae8c45 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -307,7 +307,7 @@ int main(int argc, char *argv[])
 	u32 amx_offset;
 	int stage, ret;
 
-	vm_xsave_req_perm(XSTATE_XTILE_DATA_BIT);
+	vm_xsave_require_permission(XSTATE_XTILE_DATA_BIT);
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-- 
2.36.1.255.ge46751e96f-goog

