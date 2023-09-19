Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DC67A660A
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 16:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbjISOA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 10:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjISOAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 10:00:24 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369ABF2;
        Tue, 19 Sep 2023 07:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=CigriqAWm5+Zqbh0ySs+Qdr8JUD6ix8xCQrHh/XGvCI=; b=bOVNv4mFHid3BSmO2/+7CBatxk
        1FuDk8s3Wxm/apyvBhW7LypFj4ZWV96u2hp5LUem9n3mU+imZQ0MICzIfaU6DzTWyZawJqMCK0K0y
        4I0Ne3qyykDuHHr9TVrkgmAJLCshAvqg7sGzBpFrK7A9+jhrEJiakZRenzxgBQmtsRsM=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qibGy-0004Z0-IA; Tue, 19 Sep 2023 14:00:16 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiazR-0005jy-Mh; Tue, 19 Sep 2023 13:42:09 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v4 10/13] KVM: selftests / xen: set KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID
Date:   Tue, 19 Sep 2023 13:41:46 +0000
Message-Id: <20230919134149.6091-11-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230919134149.6091-1-paul@xen.org>
References: <20230919134149.6091-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

If the capability (KVM_XEN_HVM_CONFIG_EVTCHN_SEND) is present then set
the guest's vCPU id to match the chosen vcpu_info offset.

Also make some cosmetic fixes to the code for clarity.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>

v3:
 - Remame VCPU_ID to XEN_VCPU_ID.
 - Set vcpu_id before the shared_info page is set.

v2:
 - New in this version.
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 05898ad9f4d9..b0c3a00ea6a6 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -38,6 +38,8 @@
 #define VCPU_INFO_VADDR	(SHINFO_REGION_GVA + 0x40)
 #define RUNSTATE_VADDR	(SHINFO_REGION_GVA + PAGE_SIZE + PAGE_SIZE - 15)
 
+#define XEN_VCPU_ID	1 /* Must correspond to offset of VCPU_INFO_[V]ADDR */
+
 #define EVTCHN_VECTOR	0x10
 
 #define EVTCHN_TEST1 15
@@ -410,7 +412,7 @@ static void *juggle_shinfo_state(void *arg)
 
 	struct kvm_xen_hvm_attr cache_activate = {
 		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
-		.u.shared_info.gfn = SHINFO_REGION_GPA / PAGE_SIZE
+		.u.shared_info.gfn = SHINFO_ADDR / PAGE_SIZE
 	};
 
 	struct kvm_xen_hvm_attr cache_deactivate = {
@@ -446,6 +448,7 @@ int main(int argc, char *argv[])
 	bool do_runstate_flag = !!(xen_caps & KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG);
 	bool do_eventfd_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL);
 	bool do_evtchn_tests = do_eventfd_tests && !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND);
+	bool has_vcpu_id = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND);
 
 	clock_gettime(CLOCK_REALTIME, &min_ts);
 
@@ -492,9 +495,17 @@ int main(int argc, char *argv[])
 			    "Failed to read back RUNSTATE_UPDATE_FLAG attr");
 	}
 
+	if (has_vcpu_id) {
+		struct kvm_xen_vcpu_attr vid = {
+			.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID,
+			.u.vcpu_id = XEN_VCPU_ID,
+		};
+		vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &vid);
+	}
+
 	struct kvm_xen_hvm_attr ha = {
 		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
-		.u.shared_info.gfn = SHINFO_REGION_GPA / PAGE_SIZE,
+		.u.shared_info.gfn = SHINFO_ADDR / PAGE_SIZE,
 	};
 	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &ha);
 
@@ -983,8 +994,8 @@ int main(int argc, char *argv[])
 	struct pvclock_wall_clock *wc;
 	struct pvclock_vcpu_time_info *ti, *ti2;
 
-	wc = addr_gpa2hva(vm, SHINFO_REGION_GPA + 0xc00);
-	ti = addr_gpa2hva(vm, SHINFO_REGION_GPA + 0x40 + 0x20);
+	wc = addr_gpa2hva(vm, SHINFO_ADDR + 0xc00);
+	ti = addr_gpa2hva(vm, VCPU_INFO_ADDR + 0x20);
 	ti2 = addr_gpa2hva(vm, PVTIME_ADDR);
 
 	if (verbose) {
-- 
2.39.2

