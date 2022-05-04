Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063F751B2B9
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379769AbiEDW7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379677AbiEDW6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:58:09 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CE653E14
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 23-20020a630117000000b003c5ea4365a1so1345765pgb.6
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JuSB6I15ZhVqlzJm9dB6xmEsKq4c3QIfjVdXnbIX1uc=;
        b=f+sE+6mGX/smmSPNXPjARqw/YAoc+kPcExZzb7PZZ4ZLPERBNyRyt4chK9qVK0Mq2G
         R27dsT7UAp9Amh4eZyMdMptcUg+PzehAOVisNmgAoWTFINhBSwisJQF305pONj0zqLez
         c07e2v63pE3qtdgT7uxg5QJnhQF1gZV2D/9Oq20pS2bvZm3w8LZ7SOXbGTn4REB3tQAQ
         K2n8pn7yjiuc7Ghf10qYjVvj4F3/LMlGDZCaAiaQMyiw6R8YoA9xwmhkOL58Q/18SmTt
         kgTbD/mEbe5oTDMaa5IXb0oo8SZ+cDfERJsQAI0n88w1xxtEyA9tpbcCev9d4ZHha5wH
         2hxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JuSB6I15ZhVqlzJm9dB6xmEsKq4c3QIfjVdXnbIX1uc=;
        b=r+MR/5JDd2yr3Hw1TA6YrMy4zn/xze4TSeOKjNw+OumFv/A370ReuM9mSmqd828E1S
         cBAgy7h21ljKwPiM8/UG34rMmW2Nw8cTQEaMcXIjehNrZKib4wcQA2qXjxyErxtBngld
         3H7J0PiqzB1/V5daCOxXdBePGdhjbWBxkIq8sBf6M+28HtL5bIKZ5UNkDfZWY0mFJ7xd
         Y3ljPdapNuAZHDpO2ZQsn62yRwlygtK4SQePLzUeEKauSc3yKixzre9SLbUk3beuiGV6
         VygnDAna04XEiNZEo0tLIg8YzcthPoYhOnYb4W/oMI7RTA1VEwdaz0D+r7nMNanOWH0N
         wEiQ==
X-Gm-Message-State: AOAM532SCAiYX1ig5d2TKUbSqfAEa/rhA2Dy3oyk96HWc+5OMpxcqfJR
        68do5gpZ9n2jSPjEd88Wj3iUYI3u7Ws=
X-Google-Smtp-Source: ABdhPJxruw3LauMi/kdqcd0a1xbkf42wJZ3sPtgbnfUtrwW4m7ceco7H0S2yw+oYuIIOwZ56ISyiBqA0Dus=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP id
 t16-20020a17090ae51000b001d9ee239fa1mr140465pjy.0.1651704720721; Wed, 04 May
 2022 15:52:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:33 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-88-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 087/128] KVM: selftests: Convert debug-exceptions away from VCPU_ID
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert debug-exceptions to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c    | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 63b2178210c4..b69db0942169 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -3,8 +3,6 @@
 #include <kvm_util.h>
 #include <processor.h>
 
-#define VCPU_ID 0
-
 #define MDSCR_KDE	(1 << 13)
 #define MDSCR_MDE	(1 << 15)
 #define MDSCR_SS	(1 << 0)
@@ -240,27 +238,28 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
-static int debug_version(struct kvm_vm *vm)
+static int debug_version(struct kvm_vcpu *vcpu)
 {
 	uint64_t id_aa64dfr0;
 
-	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
+	get_reg(vcpu->vm, vcpu->id, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return id_aa64dfr0 & 0xf;
 }
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 
-	if (debug_version(vm) < 6) {
+	if (debug_version(vcpu) < 6) {
 		print_skip("Armv8 debug architecture not supported.");
 		kvm_vm_free(vm);
 		exit(KSFT_SKIP);
@@ -278,9 +277,9 @@ int main(int argc, char *argv[])
 				ESR_EC_SVC64, guest_svc_handler);
 
 	for (stage = 0; stage < 11; stage++) {
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_SYNC:
 			TEST_ASSERT(uc.args[1] == stage,
 				"Stage %d: Unexpected sync ucall, got %lx",
-- 
2.36.0.464.gb9c8b46e94-goog

