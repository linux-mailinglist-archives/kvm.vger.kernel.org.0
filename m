Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526A151B24F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379186AbiEDWxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379180AbiEDWxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:34 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3571D53A6A
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s18-20020a17090aa11200b001d92f7609e8so1086606pjp.3
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vdoiFFuprO/80jj0608+r4h582qSuKW9UvQgFdb6/os=;
        b=CsjkGavuxd04ZWo1ZEmta5wWdm/pj0mLLRl/UDLyTU8O2QEyi7tRbWFVMhnVAIl7xt
         ACIEoFAD9zecvgfI1lsVBV9Pf76xixzdc10q3pyrU0kBQC4iecgB2bi0lHZIUCcJnooN
         bxBCOqKk8OTY+24J5+YDPUJHWPtZ1rmJgtYF2WFZtH39X22WWPGh2CD5fLy1cwFkbtzv
         4/p5j8bk9zf0mS5sNdVsqaZTOWHPZ5e/Tbt3vwV4jATm8OKPGfIM9kGeb+F9GHIgjvHY
         zj1Km97NnqEf7sDgzs6N3/Fv0eotD911jTPSMagRghorE61tYRvSFp2J5ZnyXUOwa0X0
         7iXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vdoiFFuprO/80jj0608+r4h582qSuKW9UvQgFdb6/os=;
        b=bSYTPT2ilgeGfdMUoMUy9/nebYajMtlD4KppjH0vHiYlT3lWfIuSj9wgZbpirNZWJg
         Ovgw8fbb1yaWLEYdaJbXJNjqo69qKaQSTIoawhv+0h/TbT7VPe7oh0hDdgKmLF6L/LfV
         KbV78L54NjswbeIY+4OVa0G9cmflbMn9GO0Fqajfuh9/HFHYzt5gAi13RXqOqBkEHTix
         TnPS0NGM8M0DVlfTZuTeBr+lOWhhfPa9TTpHfbNXt2ZkNrQyoCDC6xZZuTw5hMSWh9ve
         EUyC9qjLHmFGr4O3AfX/C0FwgPT/93Qz4HAnijrzwd5aM9UBlc4YmKO6yzFvHmHMN2pu
         JF4Q==
X-Gm-Message-State: AOAM531qk4lkQoabGlL/fyw0IeqTTKnOIkYfiEb1EdSRyyVik8Hn6rPS
        w3I8TQjoTYBNCxXvKufu7mWPC7tssL4=
X-Google-Smtp-Source: ABdhPJww3I/HXN1k7DeKtvuR/EW+eiolzBbKVPYlhD1lhf7pINVhGjlhwBU6eBTna6N2UOeJ40sJ6tdmwiQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:813:b0:50d:f198:287b with SMTP id
 m19-20020a056a00081300b0050df198287bmr14969107pfk.68.1651704585477; Wed, 04
 May 2022 15:49:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:14 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 008/128] KVM: selftests: Split vcpu_set_nested_state() into
 two helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Split vcpu_nested_state_set() into a wrapper that asserts, and an inner
helper that does not.  Passing a bool is all kinds of awful as it's
unintuitive for readers and requires returning an 'int' from a function
that for most users can never return anything other than "success".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  6 ++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 20 +++++++++----------
 .../kvm/x86_64/vmx_set_nested_state_test.c    |  4 ++--
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f6984b0c3816..314d971c1f06 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -261,8 +261,10 @@ void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
 #ifdef __x86_64__
 void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
 			   struct kvm_nested_state *state);
-int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_nested_state *state, bool ignore_error);
+int __vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			    struct kvm_nested_state *state);
+void vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			   struct kvm_nested_state *state);
 #endif
 void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index bab4ab297fcc..7b339f98070b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1826,22 +1826,22 @@ void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
 		ret, errno);
 }
 
-int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_nested_state *state, bool ignore_error)
+int __vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			    struct kvm_nested_state *state)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
-	ret = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, state);
-	if (!ignore_error) {
-		TEST_ASSERT(ret == 0,
-			"KVM_SET_NESTED_STATE failed, ret: %i errno: %i",
-			ret, errno);
-	}
+	return ioctl(vcpu->fd, KVM_SET_NESTED_STATE, state);
+}
 
-	return ret;
+void vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+			   struct kvm_nested_state *state)
+{
+	int ret = __vcpu_nested_state_set(vm, vcpuid, state);
+
+	TEST_ASSERT(!ret, "KVM_SET_NESTED_STATE failed, ret: %i errno: %i", ret, errno);
 }
 #endif
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 5827b9bae468..af3b60eb35ec 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -29,7 +29,7 @@ bool have_evmcs;
 
 void test_nested_state(struct kvm_vm *vm, struct kvm_nested_state *state)
 {
-	vcpu_nested_state_set(vm, VCPU_ID, state, false);
+	vcpu_nested_state_set(vm, VCPU_ID, state);
 }
 
 void test_nested_state_expect_errno(struct kvm_vm *vm,
@@ -38,7 +38,7 @@ void test_nested_state_expect_errno(struct kvm_vm *vm,
 {
 	int rv;
 
-	rv = vcpu_nested_state_set(vm, VCPU_ID, state, true);
+	rv = __vcpu_nested_state_set(vm, VCPU_ID, state);
 	TEST_ASSERT(rv == -1 && errno == expected_errno,
 		"Expected %s (%d) from vcpu_nested_state_set but got rv: %i errno: %s (%d)",
 		strerror(expected_errno), expected_errno, rv, strerror(errno),
-- 
2.36.0.464.gb9c8b46e94-goog

