Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E451B2F7
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379535AbiEDXBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380426AbiEDXAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 19:00:00 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0570954F87
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id v8-20020a170902b7c800b0015e927ee201so1368188plz.12
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+CNWUluVgfE7BKVDZQOZnHYJi4lcccfQxqQd/SjNgbE=;
        b=oZupDN2DKwB5oVgymTvsHW5Hf1NhUapq7YbEKSPLCfMyWiKxFju9RjbCx4aiYKf/4T
         BFxw9vcPPGu+DCqX4nOHfdXgl4T0v1m9GzMo0hO3eflzXK/1gJxUhvsgYVA65Rrf9x1f
         wJb4+WzanxTzRUL/s2q3uv/Ux3s16RG3475MF+kJp8TGGgZjyDUMFJJzvn2oo/6Owa+u
         +P82jgbcHu2iI5DlntlhvpQBUSlKDkUGSszkF0YeQIvRx2qbSohxYW1oDDnowck64Zin
         WNPsTiGFMaxxgSzlAZkWga79TAFCUKFp5dY0WSqffKcPwNG+/jcBTPPOGgeb02oK4r6d
         ZkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+CNWUluVgfE7BKVDZQOZnHYJi4lcccfQxqQd/SjNgbE=;
        b=ls/9loTMO7WXP5X0XYUgHKzzwTgjz34WQjP3X3si9Q3/CV0Gwr2gDdTIgfaoSQRRnt
         O01vmVSu/Zn2frOWcLML2Gt/ImYggULkKKP8BNCK44jUn+Rsq6OLMF+mZ7SKa+/2jJ1i
         GwXf2n6r0pL1G2IH6HAq4bv7oFZ4tSGaYcWtKxBpdMxOf9N/RP5Y04cGdxHIoNTrNuj4
         FMUwNmru25auw0/ZpUBSDpJhqDKODTV/tjQeKKW9LYpkNvm8IFSvTBkn8kRdLgIcW6bh
         bt9oI83NS3Y6jbXaqAU2praODBb5tntPoQvhdxaDoQTXR2clQACtIRUI29HEEU5nF+dU
         O2RQ==
X-Gm-Message-State: AOAM53023jl3BE0UQ6AfYY0RQKqbBJvUvtj0nvZnV3ysAuelyL/rQLTI
        GPNdqdRIMD86JFCt8ziOmA1pINJPSGk=
X-Google-Smtp-Source: ABdhPJyJvttlOkABk04uej8Mc89kBy2o6rz1jLup7YqfoTJcxS0m2k22OZQRN+HbqY/nWqK2C9gcEIn60Nk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:d155:0:b0:50d:3c4e:37ec with SMTP id
 t21-20020a62d155000000b0050d3c4e37ecmr22808296pfl.60.1651704769699; Wed, 04
 May 2022 15:52:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:49:01 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-116-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 115/128] KVM: selftests: Convert get-reg-list away from its "VCPU_ID"
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

Track the vCPU's 'struct kvm_vcpu' object in get-reg-list instead of
hardcoding '0' everywhere.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 8283a62e16e4..dae6d5704519 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -406,6 +406,7 @@ static void run_test(struct vcpu_config *c)
 	struct kvm_vcpu_init init = { .target = -1, };
 	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct reg_sublist *s;
 
@@ -413,10 +414,10 @@ static void run_test(struct vcpu_config *c)
 
 	vm = vm_create_barebones();
 	prepare_vcpu_init(c, &init);
-	aarch64_vcpu_add(vm, 0, &init, NULL);
-	finalize_vcpu(vm, 0, c);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, NULL);
+	finalize_vcpu(vm, vcpu->id, c);
 
-	reg_list = vcpu_get_reg_list(vm, 0);
+	reg_list = vcpu_get_reg_list(vm, vcpu->id);
 
 	if (fixup_core_regs)
 		core_reg_fixup();
@@ -452,7 +453,7 @@ static void run_test(struct vcpu_config *c)
 		bool reject_reg = false;
 		int ret;
 
-		ret = __vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &reg);
+		ret = __vcpu_ioctl(vm, vcpu->id, KVM_GET_ONE_REG, &reg);
 		if (ret) {
 			printf("%s: Failed to get ", config_name(c));
 			print_reg(c, reg.id);
@@ -464,7 +465,7 @@ static void run_test(struct vcpu_config *c)
 		for_each_sublist(c, s) {
 			if (s->rejects_set && find_reg(s->rejects_set, s->rejects_set_n, reg.id)) {
 				reject_reg = true;
-				ret = __vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+				ret = __vcpu_ioctl(vm, vcpu->id, KVM_SET_ONE_REG, &reg);
 				if (ret != -1 || errno != EPERM) {
 					printf("%s: Failed to reject (ret=%d, errno=%d) ", config_name(c), ret, errno);
 					print_reg(c, reg.id);
@@ -476,7 +477,7 @@ static void run_test(struct vcpu_config *c)
 		}
 
 		if (!reject_reg) {
-			ret = __vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+			ret = __vcpu_ioctl(vm, vcpu->id, KVM_SET_ONE_REG, &reg);
 			if (ret) {
 				printf("%s: Failed to set ", config_name(c));
 				print_reg(c, reg.id);
-- 
2.36.0.464.gb9c8b46e94-goog

