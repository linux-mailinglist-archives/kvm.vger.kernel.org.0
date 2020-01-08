Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5364134A8D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 19:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgAHSky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 13:40:54 -0500
Received: from mail-dm6nam10on2054.outbound.protection.outlook.com ([40.107.93.54]:54738
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbgAHSky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 13:40:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFQjH/NJXbiBDtqIDY3dyYbglN+fBe9xnunSh3oc7xGU6t0ScGgSL3ynK7X8FDb8DECsW/YZ/lDjftG+ax6pClXgAJ2mVyQrP7Rrux8Ty9IRi9jZAKw0dudljIltB4gkG7w4INFzme2OZ1XWBevlRDpUY18ax3p9oIj//JNAWs4f9lhztEsCjtuRMixWChs1IwTDLSzNkeeQer/iago6rxT/bWScWR8CW8rSsA+8o1hhN57jD8IkCdSrltq0UOGJLNJJZXwTWh6ULr5+hZ7OBXhqIX9B7MbiJp4KrUCnJUv+1BV43WeG4BY2gKbMC3syFHaEFPGQKQZhD1TwVkqoRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGzsz3IV8YFq3xOEnx52bEb4Qddzsj9SnhSRU95OvUo=;
 b=XWIwLyGxwDG3/K+6qtLVvhd0Tz+wIT7pOsZaMqfazA1nVB2QjKV4M5N8YKffw/ZJy/7Ge3MDAGEx+lFJJPbqMU1Q51kqI0RyJbaJ/1iAvVnlgqqHK7XorLg5SZxNlUYMR8Z8FiC4QiHZsuKXWMFcmWu7WS8ij7Da5x9Fk+fCGR3vYiXiGkdJ6+3RXdgljMsgogqXk5xsIGByUVYfaJgccTY4H8Br7OpFU1ccxpKSCQgRnlZrlpvXjumZwDmf8PMMgphPJhR+QodVrGaxoXFJ7qV81VPNkMj2Fsz3LUpW48aNzHfSFrUikceMz+ychtRb99QjlmxH/3umBk9C5K3hog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGzsz3IV8YFq3xOEnx52bEb4Qddzsj9SnhSRU95OvUo=;
 b=PhrqTw3CJSetQ2nKHCVusGY5D1G6k8fblQvZCf6HHs3wqpt222CLO7dmGm1Uv9hUkQdmewyKu3x9lS0L2WY2dbP/WKkPIZlbtA4x7En6JzWMY719EhKpCRwhrqgdPaziZC5MXqk+o598ojbG/rhIr+jlgTrB12gD/LhcN5JYmcU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3179.namprd12.prod.outlook.com (20.179.104.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Wed, 8 Jan 2020 18:40:38 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 18:40:38 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3] KVM: SVM: Override default MMIO mask if memory encryption is enabled
Date:   Wed,  8 Jan 2020 12:40:16 -0600
Message-Id: <6d2b7e37ca4dca92fadd1f3df93803fd17aa70ad.1578508816.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0092.namprd12.prod.outlook.com
 (2603:10b6:802:21::27) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0092.namprd12.prod.outlook.com (2603:10b6:802:21::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Wed, 8 Jan 2020 18:40:37 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35b363c4-64e0-44ec-2a73-08d7946a4185
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:|DM6PR12MB3179:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3179E83617B1A3AA86DADA8AEC3E0@DM6PR12MB3179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(199004)(189003)(6486002)(2616005)(2906002)(4326008)(86362001)(316002)(956004)(5660300002)(54906003)(36756003)(6666004)(7696005)(52116002)(478600001)(16526019)(8676002)(81166006)(186003)(8936002)(81156014)(26005)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3179;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4v6qukUTdFbQxX7khjK4rC9MTiSxWAzT+u91eJdPpbDwAkwASM2ZWx1PSeU8qSUWKl43IRdyv9buLFlGFUMfIBKE0XyxLffDBpaj9mfVg1bOvZdndAW97OQEAR8wpvdA0853BRC18APGWDz1bbqQKh9+0swGqp4oCuOE5qCYK0o5099RUzkcVlISP1stke59KOslG1kB4Uagv4XsPvaKD+Xtp4Vec/z15mSJsKT0T1XjnZjpczjaPKLKyVKCS7x7U4hWtFeXu03gES4hZ5V4c7dyFtM8GaAaS+CoVbS0PxQcHpSbsWCtr3xx0vOdAJxAAXdW3L5Ab15Z7bMkgkHq+/xiqpJ5M8Wib313soQlQD5TIWy8rzJ8jwbVjYaxfepUBbbBp/ARv5rDzc7JPhui1zszlTzDKgR1du8WgCBAhS1r9kkZCWLUIwnd3Z7famq/
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b363c4-64e0-44ec-2a73-08d7946a4185
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 18:40:38.5033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYRlq0oa/GRlNFskQXHkANVJbvZTTVg0a1DPsKfxY/9hXriJV6dJCETHEM2KiQLyQNDZHcXEbaTBaNvzP6fa+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
faults when a guest performs MMIO. The AMD memory encryption support uses
a CPUID function to define the encryption bit position. Given this, it is
possible that these bits can conflict.

Use svm_hardware_setup() to override the MMIO mask if memory encryption
support is enabled. Various checks are performed to ensure that the mask
is properly defined and rsvd_bits() is used to generate the new mask (as
was done prior to the change that necessitated this patch).

Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

---

Changes in v3:
- Add additional checks to ensure there are no conflicts between the
  encryption bit position and physical address setting.
- Use rsvd_bits() generated mask (as was previously used) instead of
  setting a single bit.

Changes in v2:
- Use of svm_hardware_setup() to override MMIO mask rather than adding an
  override callback routine.
---
 arch/x86/kvm/svm.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 122d4ce3b1ab..9d6bd3fc12c8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1307,6 +1307,55 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * The default MMIO mask is a single bit (excluding the present bit),
+ * which could conflict with the memory encryption bit. Check for
+ * memory encryption support and override the default MMIO masks if
+ * it is enabled.
+ */
+static __init void svm_adjust_mmio_mask(void)
+{
+	unsigned int enc_bit, mask_bit;
+	u64 msr, mask;
+
+	/* If there is no memory encryption support, use existing mask */
+	if (cpuid_eax(0x80000000) < 0x8000001f)
+		return;
+
+	/* If memory encryption is not enabled, use existing mask */
+	rdmsrl(MSR_K8_SYSCFG, msr);
+	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
+		return;
+
+	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
+	mask_bit = boot_cpu_data.x86_phys_bits;
+
+	/* Increment the mask bit if it is the same as the encryption bit */
+	if (enc_bit == mask_bit)
+		mask_bit++;
+
+	if (mask_bit > 51) {
+		/*
+		 * The mask bit is above 51, so use bit 51 without the present
+		 * bit.
+		 */
+		mask = BIT_ULL(51);
+	} else {
+		/*
+		 * Some bits above the physical addressing limit will always
+		 * be reserved, so use the rsvd_bits() function to generate
+		 * the mask. This mask, along with the present bit, will be
+		 * used to generate a page fault with PFER.RSV = 1.
+		 */
+		mask = rsvd_bits(mask_bit, 51);
+		mask |= BIT_ULL(0);
+	}
+
+	kvm_mmu_set_mmio_spte_mask(mask, mask,
+				   PT_WRITABLE_MASK |
+				   PT_USER_MASK);
+}
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
@@ -1361,6 +1410,8 @@ static __init int svm_hardware_setup(void)
 		}
 	}
 
+	svm_adjust_mmio_mask();
+
 	for_each_possible_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
-- 
2.17.1

