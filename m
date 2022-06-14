Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA4D54BB6B
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357829AbiFNUK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357815AbiFNUKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:10:37 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835444B42F
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s17-20020a170902ea1100b00168b7cad0efso5337289plg.14
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+JUUrANpcy0WjjSaiXZvhzOGdtbSexwErj2l4cNYJS4=;
        b=Vb6Fxn9aW/ul2PuLhdqDpBabNbGgeHaHowJIejicivMlRiTuveW2wSWYlyj8pjeGcD
         Mc86DtuoPa63NN5X2eCCV9xegjdN+JE3VK9F2XensCypsWWMEFpKCFMFULfsG2kR++3D
         kW3z8ZlsCnWm4SXmgEm2sMh5O/qYrG9GysgrHHgSP2uu7aofa2NvtGkcChgZujvq4aXK
         kcZlFttFF88PaiFHDmyL0ihlkgq3+yyC3UweBLXypfk07710ZQIE+vf+X7QfHaxLcF+4
         p4iRdkRkFD/wWdDDi91ZmSZsWyVT8IIR3RaGoP8gqpic9ZmExjPt4R1tMPkT6kse8qN/
         EoDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+JUUrANpcy0WjjSaiXZvhzOGdtbSexwErj2l4cNYJS4=;
        b=Qpk0zJHPEb003U4TmMLp+W7WuvzzxhViVTAfn2JPxydlhpulte1z/uBXp/DoyF6Xqx
         ZseNpPqwb6qJI3BIY1ZZd08uEGSjPOKqOOtf2CYbBefXcgQUgxQJbl4U5cqvT+q7oV0H
         TyPKs5OsGr+y4DCCtHD/3xR6Y0B8mk/IE5o5OrU1Lq4IzpCZGKkRQ4KUdOhn511NGUnf
         zUFT4EMzMBm2XK8bK0SK0+y7g2v42kQ6u7CymclgqJtZiFKG0H4ZpQYxsyOGlNng22K/
         NI9nFWnj6iK7iLVs+nxmD9b6nOQi9xxwjxhW8x5J2Kfq3Xf4ZNymG670QECJV950yt63
         2nmg==
X-Gm-Message-State: AOAM533buR5xCbd/VY2mAnwSgpoE/2VYHTAmf328x5VYd0Zh4i9S9ohf
        zcoDM/9yHUT5ENwEqmEIZqMpi+IwgNs=
X-Google-Smtp-Source: ABdhPJwnUdjdJO83HH4EqAXo+UyDJs0dAsj30iouzGW8CMW3p9szyM5Gb6CDc09QkFopB/4B4KXP2M0us9I=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:9f84:0:b0:51b:b64d:fc69 with SMTP id
 z4-20020aa79f84000000b0051bb64dfc69mr6412254pfr.7.1655237303978; Tue, 14 Jun
 2022 13:08:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:07:05 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-41-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 40/42] KVM: selftests: Clean up requirements for XFD-aware
 XSAVE features
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
index b51227ccfb96..19c023f767fc 100644
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
 
 enum pg_level {
 	PG_LEVEL_NONE,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index ee346a280482..d606ee2d970a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -578,7 +578,7 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	vcpu_sregs_set(vcpu, &sregs);
 }
 
-void vm_xsave_req_perm(int bit)
+void __vm_xsave_require_permission(int bit, const char *name)
 {
 	int kvm_fd;
 	u64 bitmask;
@@ -596,10 +596,12 @@ void vm_xsave_req_perm(int bit)
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
2.36.1.476.g0c4daa206d-goog

