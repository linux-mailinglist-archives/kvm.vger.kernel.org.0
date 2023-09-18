Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A0C7A48AA
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 13:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241708AbjIRLnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 07:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbjIRLnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 07:43:03 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BAEFD;
        Mon, 18 Sep 2023 04:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=F2tt1vng5GeCrD0vCTbIE4sW0FPuoGj/KLthbnkHO/8=; b=ZDN0LQkR52OCZ+dcXyY461a9r+
        7l1WiuKByZk0SU3yaOe1HlaKKcjw4lCY3mH/Nc2Ap4bfDVsT+bLVNvqsEFkv0G5gGLaz1ej+GeXJ7
        zv9NTLNyfY3fd0YgA/dPANIaEkjaPeLswMcFmmScxoY17etAkI8dGJNYrO8Be03Dh23k=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiCeV-0007d9-Ek; Mon, 18 Sep 2023 11:42:55 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiCKY-0005f3-J9; Mon, 18 Sep 2023 11:22:18 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v2 10/12] KVM: selftests / xen: map shared_info using HVA rather than GFN
Date:   Mon, 18 Sep 2023 11:21:46 +0000
Message-Id: <20230918112148.28855-11-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230918112148.28855-1-paul@xen.org>
References: <20230918112148.28855-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

Using the HVA of the shared_info page is more efficient, so if the
capability (KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA) is present use that method
to do the mapping.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>

v2:
 - New in this version.
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 50 ++++++++++++++++---
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 49d0c91ee078..fa829d6e0848 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -395,6 +395,7 @@ static int cmp_timespec(struct timespec *a, struct timespec *b)
 		return 0;
 }
 
+static struct shared_info *shinfo;
 static struct vcpu_info *vinfo;
 static struct kvm_vcpu *vcpu;
 
@@ -406,7 +407,7 @@ static void handle_alrm(int sig)
 	TEST_FAIL("IRQ delivery timed out");
 }
 
-static void *juggle_shinfo_state(void *arg)
+static void *juggle_shinfo_state_gfn(void *arg)
 {
 	struct kvm_vm *vm = (struct kvm_vm *)arg;
 
@@ -429,6 +430,29 @@ static void *juggle_shinfo_state(void *arg)
 	return NULL;
 }
 
+static void *juggle_shinfo_state_hva(void *arg)
+{
+	struct kvm_vm *vm = (struct kvm_vm *)arg;
+
+	struct kvm_xen_hvm_attr cache_activate = {
+		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA,
+		.u.shared_info.hva = (unsigned long)shinfo
+	};
+
+	struct kvm_xen_hvm_attr cache_deactivate = {
+		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA,
+		.u.shared_info.hva = 0
+	};
+
+	for (;;) {
+		__vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &cache_activate);
+		__vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &cache_deactivate);
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
 int main(int argc, char *argv[])
 {
 	struct timespec min_ts, max_ts, vm_ts;
@@ -449,6 +473,7 @@ int main(int argc, char *argv[])
 	bool do_eventfd_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL);
 	bool do_evtchn_tests = do_eventfd_tests && !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND);
 	bool has_vcpu_id = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND);
+	bool has_shinfo_hva = !!(xen_caps & KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA);
 
 	clock_gettime(CLOCK_REALTIME, &min_ts);
 
@@ -459,7 +484,7 @@ int main(int argc, char *argv[])
 				    SHINFO_REGION_GPA, SHINFO_REGION_SLOT, 3, 0);
 	virt_map(vm, SHINFO_REGION_GVA, SHINFO_REGION_GPA, 3);
 
-	struct shared_info *shinfo = addr_gpa2hva(vm, SHINFO_VADDR);
+	shinfo = addr_gpa2hva(vm, SHINFO_VADDR);
 
 	int zero_fd = open("/dev/zero", O_RDONLY);
 	TEST_ASSERT(zero_fd != -1, "Failed to open /dev/zero");
@@ -495,10 +520,16 @@ int main(int argc, char *argv[])
 			    "Failed to read back RUNSTATE_UPDATE_FLAG attr");
 	}
 
-	struct kvm_xen_hvm_attr ha = {
-		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
-		.u.shared_info.gfn = SHINFO_ADDR / PAGE_SIZE,
-	};
+	struct kvm_xen_hvm_attr ha = {};
+
+	if (has_shinfo_hva) {
+		ha.type = KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA;
+		ha.u.shared_info.hva = (unsigned long)shinfo;
+	} else {
+		ha.type = KVM_XEN_ATTR_TYPE_SHARED_INFO;
+		ha.u.shared_info.gfn = SHINFO_ADDR / PAGE_SIZE;
+	}
+
 	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &ha);
 
 	/*
@@ -902,7 +933,12 @@ int main(int argc, char *argv[])
 				if (verbose)
 					printf("Testing shinfo lock corruption (KVM_XEN_HVM_EVTCHN_SEND)\n");
 
-				ret = pthread_create(&thread, NULL, &juggle_shinfo_state, (void *)vm);
+				if (has_shinfo_hva)
+					ret = pthread_create(&thread, NULL,
+							     &juggle_shinfo_state_hva, (void *)vm);
+				else
+					ret = pthread_create(&thread, NULL,
+							     &juggle_shinfo_state_gfn, (void *)vm);
 				TEST_ASSERT(ret == 0, "pthread_create() failed: %s", strerror(ret));
 
 				struct kvm_irq_routing_xen_evtchn uxe = {
-- 
2.39.2

