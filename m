Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A7B553715
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353173AbiFUP7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353589AbiFUP65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:58:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC9C3B96
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655827136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EmEzVaoMAZSsUe/5lbRI/mv6YdcXtXL+W5zafkz/96I=;
        b=EUWCaHhGUFayKpcAZozc2hGYou1h64RljKkrTqboS6xG1hcWgAYUlLxjGKKcR4v2bPXv++
        YWXTbKrs3lagazOK04kJQ43g+Tg/UMs3TsRaTMt448+BM7vSCsAbC4KCNFXNfKEeX4+WVp
        58jy0NtL7X09AyevY+6+8XefomuIF7Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-mg2ovC4pPmuAadO-8QTN3g-1; Tue, 21 Jun 2022 11:58:51 -0400
X-MC-Unique: mg2ovC4pPmuAadO-8QTN3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AE933815D28;
        Tue, 21 Jun 2022 15:58:51 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 199812026D64;
        Tue, 21 Jun 2022 15:58:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] KVM: selftests: Switch to KVM_CAP_HYPERV_ENLIGHTENED_VMCS2
Date:   Tue, 21 Jun 2022 17:58:26 +0200
Message-Id: <20220621155830.60115-8-vkuznets@redhat.com>
In-Reply-To: <20220621155830.60115-1-vkuznets@redhat.com>
References: <20220621155830.60115-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_HYPERV_ENLIGHTENED_VMCS was obsoleted by
KVM_CAP_HYPERV_ENLIGHTENED_VMCS2, use it in selftests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h       | 8 ++++++++
 tools/testing/selftests/kvm/include/x86_64/evmcs.h        | 1 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c              | 5 +++--
 tools/testing/selftests/kvm/x86_64/evmcs_test.c           | 2 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c         | 2 +-
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c      | 2 +-
 6 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index cdaea2383543..3b5d25d6baae 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -348,6 +348,14 @@ static inline void vcpu_enable_cap(struct kvm_vcpu *vcpu, uint32_t cap,
 	vcpu_ioctl(vcpu, KVM_ENABLE_CAP, &enable_cap);
 }
 
+static inline void vcpu_enable_cap2(struct kvm_vcpu *vcpu, uint32_t cap,
+				   uint64_t arg0, uint64_t arg1)
+{
+	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0, arg1 } };
+
+	vcpu_ioctl(vcpu, KVM_ENABLE_CAP, &enable_cap);
+}
+
 static inline void vcpu_guest_debug_set(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *debug)
 {
diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index 3c9260f8e116..b6d6c73f68dc 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -17,6 +17,7 @@
 #define u64 uint64_t
 
 #define EVMCS_VERSION 1
+#define EVMCS_REVISION 1
 
 extern bool enable_evmcs;
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 381432741df4..1a0b9334f8d4 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -42,12 +42,13 @@ struct eptPageTablePointer {
 	uint64_t address:40;
 	uint64_t reserved_63_52:12;
 };
+
 int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 {
 	uint16_t evmcs_ver;
 
-	vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
-			(unsigned long)&evmcs_ver);
+	vcpu_enable_cap2(vcpu, KVM_CAP_HYPERV_ENLIGHTENED_VMCS2,
+			 EVMCS_REVISION, (unsigned long)&evmcs_ver);
 
 	/* KVM should return supported EVMCS version range */
 	TEST_ASSERT(((evmcs_ver >> 8) >= (evmcs_ver & 0xff)) &&
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 8dda527cc080..a546d1cad146 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -210,7 +210,7 @@ int main(int argc, char *argv[])
 
 	TEST_REQUIRE(nested_vmx_supported());
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS2));
 
 	vcpu_set_hv_cpuid(vcpu);
 	vcpu_enable_evmcs(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index cbd4a7d36189..f19859f1956e 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -149,7 +149,7 @@ int main(int argc, char *argv[])
 	free(hv_cpuid_entries);
 
 	if (!nested_vmx_supported() ||
-	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
+	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS2)) {
 		print_skip("Enlightened VMCS is unsupported");
 		goto do_sys;
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index b564b86dfc1d..b624a08a5574 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -265,7 +265,7 @@ int main(int argc, char *argv[])
 	struct kvm_nested_state state;
 	struct kvm_vcpu *vcpu;
 
-	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
+	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS2);
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 
-- 
2.35.3

