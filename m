Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7DF190690
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 08:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgCXHpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 03:45:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51620 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbgCXHpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 03:45:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id c187so2096499wme.1;
        Tue, 24 Mar 2020 00:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E4laWHPFyqBGUJvtxwe1Z3Lus6v9LWPN8EYUI93Rtls=;
        b=nFZASXcc4nB9pmEFKaBvek+Sq0SW3tv6Wj0W7n/XOB/B5YSO9c+sZoE+xGcmDzBje2
         4K7EhILSluLpuSQJMwQUB51akbPlheh9Je2Spf42qULN8NE+9+nxB9bJMDToS6/nl8N4
         7D0GKq8osTZujE8SKlDMDct4IIAO6chO9DZXWbcJD71cC1wI183M4fxAv/ZhInG/KLS2
         MunnpqXeEM3TqOYonSwxMGyYSI/ojD2R3CBXV6+Ozu3TyphvhwYH8G+vDmCIzIgIdY8i
         euq5ac00stByd//KwXHxAH4nT+1+c8GVfBPsIiJvYgnEPw4IALdyHUkGiLcXXdNKB3Jz
         9Oxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E4laWHPFyqBGUJvtxwe1Z3Lus6v9LWPN8EYUI93Rtls=;
        b=UyjeC4RqIb7NtnIVKKbC3fF26c3HMa15U1iZAjQyASmFANU3DnXsxQLQSJLVUsrL9s
         ICWuYT3JErGwNmGoecFQnnczGSPVFU6ajzedzK8zmLueTI/iNGNBbneQu6jWVF70H+ou
         c+pqnkDWxjM5e3M4awkUhCcCZF/qflvgzoF2/ERvnxYQcocaZAWJN7E9wt3Zq17DGT2V
         BYMfe6IsXk1hpcoM+lk6iteuyDmjsxYlkRrPHpogFbk2mjqRULXOikKMvAvA75BY+EER
         oScBasmyS2IKLVOCI4uhXe4zZ+XgYfQSSeXpI360MdvBrSXE45IPJWF+7siyvmFybZ2C
         1sqQ==
X-Gm-Message-State: ANhLgQ1KTBCG21FFEWNsUZXbnV6yXNAmKNT6JE0Xx509La7c+zE5RNVd
        +7+z6hceTDWBMFXvnWSyMPSEt76plVM=
X-Google-Smtp-Source: ADFU+vtpNGYv/4s7yUPo07m4ysTE2tFOwDv7Lx1NTwyDE7zqmYAgfgiEp3lYnHEHZ50c0cYCH1s2wA==
X-Received: by 2002:a05:600c:24c:: with SMTP id 12mr1867336wmj.186.1585035952218;
        Tue, 24 Mar 2020 00:45:52 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id r15sm22066122wra.19.2020.03.24.00.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 00:45:51 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com
Subject: [PATCH v10 7/7] KVM: selftests: update hyperv_cpuid with SynDBG tests
Date:   Tue, 24 Mar 2020 09:43:41 +0200
Message-Id: <20200324074341.1770081-8-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324074341.1770081-1-arilou@gmail.com>
References: <20200324074341.1770081-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets () redhat ! com>

Test all four combinations with eVMCS and SynDBG capabilities,
check that we get the right number of entries and that
0x40000000.EAX always returns the correct max leaf.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 139 ++++++++++++------
 1 file changed, 96 insertions(+), 43 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 443a2b54645b..e63b0e1c253d 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -26,18 +26,18 @@ static void guest_code(void)
 {
 }
 
-static int smt_possible(void)
+static bool smt_possible(void)
 {
 	char buf[16];
 	FILE *f;
-	bool res = 1;
+	bool res = true;
 
 	f = fopen("/sys/devices/system/cpu/smt/control", "r");
 	if (f) {
 		if (fread(buf, sizeof(*buf), sizeof(buf), f) > 0) {
 			if (!strncmp(buf, "forceoff", 8) ||
 			    !strncmp(buf, "notsupported", 12))
-				res = 0;
+				res = false;
 		}
 		fclose(f);
 	}
@@ -45,30 +45,48 @@ static int smt_possible(void)
 	return res;
 }
 
+void vcpu_enable_syndbg(struct kvm_vm *vm, int vcpu_id)
+{
+	struct kvm_enable_cap enable_syndbg_cap = {
+		.cap = KVM_CAP_HYPERV_SYNDBG,
+	};
+
+	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, &enable_syndbg_cap);
+}
+
 static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
-			  int evmcs_enabled)
+			  bool evmcs_enabled, bool syndbg_enabled)
 {
 	int i;
+	int nent = 6;
+	u32 test_val;
+
+	if (evmcs_enabled)
+		nent += 1; /* 0x4000000A */
 
-	if (!evmcs_enabled)
-		TEST_ASSERT(hv_cpuid_entries->nent == 6,
-			    "KVM_GET_SUPPORTED_HV_CPUID should return 6 entries"
-			    " when Enlightened VMCS is disabled (returned %d)",
-			    hv_cpuid_entries->nent);
-	else
-		TEST_ASSERT(hv_cpuid_entries->nent == 7,
-			    "KVM_GET_SUPPORTED_HV_CPUID should return 7 entries"
-			    " when Enlightened VMCS is enabled (returned %d)",
-			    hv_cpuid_entries->nent);
+	if (syndbg_enabled)
+		nent += 3; /* 0x40000080 - 0x40000082 */
+
+	TEST_ASSERT(hv_cpuid_entries->nent == nent,
+		    "KVM_GET_SUPPORTED_HV_CPUID should return %d entries"
+		    " with evmcs=%d syndbg=%d (returned %d)",
+		    nent, evmcs_enabled, syndbg_enabled,
+		    hv_cpuid_entries->nent);
 
 	for (i = 0; i < hv_cpuid_entries->nent; i++) {
 		struct kvm_cpuid_entry2 *entry = &hv_cpuid_entries->entries[i];
 
 		TEST_ASSERT((entry->function >= 0x40000000) &&
-			    (entry->function <= 0x4000000A),
+			    (entry->function <= 0x40000082),
 			    "function %lx is our of supported range",
 			    entry->function);
 
+		TEST_ASSERT(evmcs_enabled || (entry->function != 0x4000000A),
+			    "0x4000000A leaf should not be reported");
+
+		TEST_ASSERT(syndbg_enabled || (entry->function <= 0x4000000A),
+			    "SYNDBG leaves should not be reported");
+
 		TEST_ASSERT(entry->index == 0,
 			    ".index field should be zero");
 
@@ -78,12 +96,27 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 		TEST_ASSERT(!entry->padding[0] && !entry->padding[1] &&
 			    !entry->padding[2], "padding should be zero");
 
-		if (entry->function == 0x40000004) {
-			int nononarchcs = !!(entry->eax & (1UL << 18));
-
-			TEST_ASSERT(nononarchcs == !smt_possible(),
+		switch (entry->function) {
+		case 0x40000000:
+			test_val = 0x40000005;
+			if (evmcs_enabled)
+				test_val = 0x4000000A;
+			if (syndbg_enabled)
+				test_val = 0x40000082;
+
+			TEST_ASSERT(entry->eax == test_val,
+				    "Wrong max leaf report in 0x40000000.EAX: %x"
+				    " (evmcs=%d syndbg=%d)",
+				    entry->eax, evmcs_enabled, syndbg_enabled
+				);
+			break;
+		case 0x40000004:
+			test_val = entry->eax & (1UL << 18);
+
+			TEST_ASSERT(!!test_val == !smt_possible(),
 				    "NoNonArchitecturalCoreSharing bit"
 				    " doesn't reflect SMT setting");
+			break;
 		}
 
 		/*
@@ -133,8 +166,9 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm)
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	int rv;
+	int rv, stage;
 	struct kvm_cpuid2 *hv_cpuid_entries;
+	bool evmcs_enabled, syndbg_enabled;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
@@ -151,32 +185,51 @@ int main(int argc, char *argv[])
 
 	test_hv_cpuid_e2big(vm);
 
-	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
-	if (!hv_cpuid_entries)
-		return 1;
-
-	test_hv_cpuid(hv_cpuid_entries, 0);
+	kvm_vm_free(vm);
 
-	free(hv_cpuid_entries);
+	for (stage = 0; stage < 5; stage++) {
+		evmcs_enabled = false;
+		syndbg_enabled = false;
+
+		vm = vm_create_default(VCPU_ID, 0, guest_code);
+		switch (stage) {
+		case 0:
+			test_hv_cpuid_e2big(vm);
+			continue;
+		case 1:
+			break;
+		case 2:
+			if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
+				print_skip("Enlightened VMCS is unsupported");
+				continue;
+			}
+			vcpu_enable_evmcs(vm, VCPU_ID);
+			evmcs_enabled = true;
+			break;
+		case 3:
+			if (!kvm_check_cap(KVM_CAP_HYPERV_SYNDBG)) {
+				print_skip("Synthetic debugger is unsupported");
+				continue;
+			}
+			vcpu_enable_syndbg(vm, VCPU_ID);
+			syndbg_enabled = true;
+			break;
+		case 4:
+			if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS) ||
+			    !kvm_check_cap(KVM_CAP_HYPERV_SYNDBG))
+				continue;
+			vcpu_enable_evmcs(vm, VCPU_ID);
+			vcpu_enable_syndbg(vm, VCPU_ID);
+			evmcs_enabled = true;
+			syndbg_enabled = true;
+			break;
+		}
 
-	if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
-		fprintf(stderr,
-			"Enlightened VMCS is unsupported, skip related test\n");
-		goto vm_free;
+		hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
+		test_hv_cpuid(hv_cpuid_entries, evmcs_enabled, syndbg_enabled);
+		free(hv_cpuid_entries);
+		kvm_vm_free(vm);
 	}
 
-	vcpu_enable_evmcs(vm, VCPU_ID);
-
-	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
-	if (!hv_cpuid_entries)
-		return 1;
-
-	test_hv_cpuid(hv_cpuid_entries, 1);
-
-	free(hv_cpuid_entries);
-
-vm_free:
-	kvm_vm_free(vm);
-
 	return 0;
 }
-- 
2.24.1

