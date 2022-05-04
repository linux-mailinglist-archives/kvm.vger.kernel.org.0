Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C892851B298
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbiEDXBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380383AbiEDW76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F4556C33
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:18 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c202-20020a621cd3000000b0050dd228152aso822728pfc.11
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=F+kK/XPWXcKK2ny6diLAkFYmqndC2dDl4o6tQn0cWkc=;
        b=BWCmEOfrEeiIqLn0P4PWgbGYuu7qE1llTLedCapeUbf8Qrvh9Nmt2tKrqlBiGQ0gO5
         MUIPAvEbTKyLzrtBddgAEoknXooe1QDEbJFOEfYMlkFA2rF9V7KLzfg+nJr9OrkmT3t0
         px76pV3l5HemfSDAQZntU+eJND2iScwTQ+XC5cWhjtotDHrG1WKz5j1LbcOC5p5ZsMQP
         kMS6OG0aBsFr7g2lAADMBfw9KjVuQFaQEvM8b5Elemzd8BqMxTtfKdEeyCgs8tpLIB9g
         bAjwaBeuOpayQzfPL29PWe7BeASgEy+4rjs9Tx1813FrN2MmE8e/eiS6icobBpy3CqMh
         85FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=F+kK/XPWXcKK2ny6diLAkFYmqndC2dDl4o6tQn0cWkc=;
        b=65+xDFyAGhNci7OlFJaVoc0pWpKj65wZHYNDMevh7vIcCR01VnMEBjHWwYc0lfC4Ye
         8K3yB6ExC+bXDl+P5/n131sKJpH3ASppbuJHu39EDJ9X7krYQraMpm/T8PvO07uOOp5w
         nHLSoQicjJ2wpeoX+ok6Dmt+IAXS9KMjrWWq4Q5q/jRcH0xV3PY+jn9Ak7bA+xDds55l
         xuXuMg0/AXLB8Nm+JGkSoZ/kA8Q3zOdiSHMOI9f1dyLyayt9WeZ9fQ+mM0Jqr4YQ73mh
         rsHaDpQ8RllHcaztXPikHXqDCVjCLXxNzkfLwvOo9W40ycBzsy61FwjbOFf3+J8hcADz
         Szdw==
X-Gm-Message-State: AOAM533H4JsSPojjJR4vNd9DlMqQ3TaQEXEMhJzhPvYhX1hMKtpfu9Bd
        S6umLDfXl6dS0DYIXcUk3MZafVpD7T8=
X-Google-Smtp-Source: ABdhPJyUhuTwwz7UIV57bC3ZMTsptmctbegVNnYinR+99suZaX48lZRMBPr6CQkG4EY6TbpBD28DxRnoY6I=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1991:b0:50e:697:53f9 with SMTP id
 d17-20020a056a00199100b0050e069753f9mr11918083pfl.22.1651704767934; Wed, 04
 May 2022 15:52:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:49:00 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-115-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 114/128] KVM: selftests: Convert kvm_binary_stats_test away
 from vCPU IDs
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

Track vCPUs by their 'struct kvm_vcpu' object in kvm_binary_stats_test,
not by their ID.  The per-vCPU helpers will soon take a vCPU instead of a
VM+vcpu_id pair.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 407e9ea8e6f3..dfc3cf531ced 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -172,9 +172,9 @@ static void vm_stats_test(struct kvm_vm *vm)
 	TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
 }
 
-static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
+static void vcpu_stats_test(struct kvm_vcpu *vcpu)
 {
-	int stats_fd = vcpu_get_stats_fd(vm, vcpu_id);
+	int stats_fd = vcpu_get_stats_fd(vcpu->vm, vcpu->id);
 
 	stats_test(stats_fd);
 	close(stats_fd);
@@ -195,6 +195,7 @@ static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
 int main(int argc, char *argv[])
 {
 	int i, j;
+	struct kvm_vcpu **vcpus;
 	struct kvm_vm **vms;
 	int max_vm = DEFAULT_NUM_VM;
 	int max_vcpu = DEFAULT_NUM_VCPU;
@@ -220,17 +221,21 @@ int main(int argc, char *argv[])
 	/* Create VMs and VCPUs */
 	vms = malloc(sizeof(vms[0]) * max_vm);
 	TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
+
+	vcpus = malloc(sizeof(struct kvm_vcpu *) * max_vm * max_vcpu);
+	TEST_ASSERT(vcpus, "Allocate memory for storing vCPU pointers");
+
 	for (i = 0; i < max_vm; ++i) {
 		vms[i] = vm_create_barebones();
 		for (j = 0; j < max_vcpu; ++j)
-			__vm_vcpu_add(vms[i], j);
+			vcpus[j * max_vcpu + i] = __vm_vcpu_add(vms[i], j);
 	}
 
 	/* Check stats read for every VM and VCPU */
 	for (i = 0; i < max_vm; ++i) {
 		vm_stats_test(vms[i]);
 		for (j = 0; j < max_vcpu; ++j)
-			vcpu_stats_test(vms[i], j);
+			vcpu_stats_test(vcpus[j * max_vcpu + i]);
 	}
 
 	for (i = 0; i < max_vm; ++i)
-- 
2.36.0.464.gb9c8b46e94-goog

