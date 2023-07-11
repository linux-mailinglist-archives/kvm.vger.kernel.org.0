Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE4674FBA5
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 01:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjGKXCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 19:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbjGKXBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 19:01:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07C41982
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ca48836fec5so70004276.3
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689116505; x=1691708505;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GyUg5dlzIa8McwdzPE+wxpmpG2aTO24P2TiMipK75HY=;
        b=Y2C7A9LJxKi26AKZCOedeQsoU3MSTc2nCv9iMnVsDgIcycFwF2iW/mzm4WJG9duMfW
         E6cxW6CLJjgVxajIFrFH1vILGdm2llWGYIwxULVvyPOHOSPSf45rTDmJlnDVcJW2DpSV
         yFj3uOhDqKIzO5tGc1CYv5gEHb47dgZeH2zz/FzRNqmF/yGQv6AT83/BxCF+asTB7gCi
         lGmI4ZTZRIWM1VXqLMA1+zHzXj5Rj7+cVH9NOZqZqCjtP2TsuqP/6PzCFvhNvuKWFY+N
         rwxN6Cl/NT3yjxO74GFQR/LkqBACrzmAydFPX2wn1C1SNALxw4OYgP0PMjKBYvu23ErB
         KtcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689116505; x=1691708505;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GyUg5dlzIa8McwdzPE+wxpmpG2aTO24P2TiMipK75HY=;
        b=iQyyK4ZVitLk3IwghAct27PKMWl+wY82FDZE2dnGTUfZj/h9uxppKMAQBbcACQm2pu
         0rPrpEVUs5xNylbRTtqPJ5jzZQCHjoMvuH++YYT67U1iV6MjU1UbbAwz4IGqZM3k6YnV
         4j11RUkz1/0RitLaPrMe1xqyV8OTERa5ifAJLT+PRkrOwZtRqvbu5MaJWho7/AImu6b2
         NAsni/iEYM9R/cJDyAgZKeWKFydcfhmroXCqrLSq/kj2pPsN4WnT7pdtQtzha0ZKRPFq
         KJ7ESjQoVetd5rifroxLBawF9mC0Lp29rLJG5rfksZ6g7QvBNw+O6QADic0zln5kCWuY
         k0Lw==
X-Gm-Message-State: ABy/qLbrhUxRAo/qQGYV6B0hxooF409M/09DOmLKdkMB8CP5ysdrqnBI
        zPlA/fpfV/rmfMY0Q5hRvwI+YQ8HCYo=
X-Google-Smtp-Source: APBJJlFUFLR8L4iRRHt9rKjYaaqegk++QZhf19a4JUv2eiG3mJ24F0+9Bee8MHPbDKZ6dEhXoMkWSkYNdZ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:508:b0:c4b:6ed6:6147 with SMTP id
 x8-20020a056902050800b00c4b6ed66147mr155293ybs.9.1689116505063; Tue, 11 Jul
 2023 16:01:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Jul 2023 16:01:29 -0700
In-Reply-To: <20230711230131.648752-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230711230131.648752-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711230131.648752-6-seanjc@google.com>
Subject: [PATCH 5/7] KVM: selftests: Verify userspace can create "redundant"
 binary stats files
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Zhang <zheng.zhang@email.ucr.edu>,
        Kees Cook <keescook@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that KVM doesn't artificially limit KVM_GET_STATS_FD to a single
file per VM/vCPU.  There's no known use case for getting multiple stats
fds, but it should work, and more importantly creating multiple files will
make it easier to test that KVM correct manages VM refcounts for stats
files.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/kvm_binary_stats_test.c     | 25 +++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 874fa5092551..653f10d8fb7c 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -185,6 +185,7 @@ static void stats_test(int stats_fd)
 
 int main(int argc, char *argv[])
 {
+	int vm_stats_fds, *vcpu_stats_fds;
 	int i, j;
 	struct kvm_vcpu **vcpus;
 	struct kvm_vm **vms;
@@ -217,18 +218,37 @@ int main(int argc, char *argv[])
 	vcpus = malloc(sizeof(struct kvm_vcpu *) * max_vm * max_vcpu);
 	TEST_ASSERT(vcpus, "Allocate memory for storing vCPU pointers");
 
+	/*
+	 * Not per-VM as the array is populated, used, and invalidated within a
+	 * single for-loop iteration.
+	 */
+	vcpu_stats_fds = calloc(max_vm, sizeof(*vcpu_stats_fds));
+	TEST_ASSERT(vcpu_stats_fds, "Allocate memory for VM stats fds");
+
 	for (i = 0; i < max_vm; ++i) {
 		vms[i] = vm_create_barebones();
 		for (j = 0; j < max_vcpu; ++j)
 			vcpus[i * max_vcpu + j] = __vm_vcpu_add(vms[i], j);
 	}
 
-	/* Check stats read for every VM and VCPU */
+	/*
+	 * Check stats read for every VM and vCPU, with a variety of testcases.
+	 * Note, stats_test() closes the passed in stats fd.
+	 */
 	for (i = 0; i < max_vm; ++i) {
+		vm_stats_fds = vm_get_stats_fd(vms[i]);
+
+		/* Verify userspace can instantiate multiple stats files. */
 		stats_test(vm_get_stats_fd(vms[i]));
 
-		for (j = 0; j < max_vcpu; ++j)
+		for (j = 0; j < max_vcpu; ++j) {
+			vcpu_stats_fds[j] = vcpu_get_stats_fd(vcpus[i * max_vcpu + j]);
 			stats_test(vcpu_get_stats_fd(vcpus[i * max_vcpu + j]));
+		}
+
+		stats_test(vm_stats_fds);
+		for (j = 0; j < max_vcpu; ++j)
+			stats_test(vcpu_stats_fds[j]);
 
 		ksft_test_result_pass("vm%i\n", i);
 	}
@@ -237,6 +257,7 @@ int main(int argc, char *argv[])
 		kvm_vm_free(vms[i]);
 	free(vms);
 	free(vcpus);
+	free(vcpu_stats_fds);
 
 	ksft_finished();	/* Print results and exit() accordingly */
 }
-- 
2.41.0.255.g8b1d071c50-goog

