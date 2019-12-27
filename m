Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F261412B5BF
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2019 16:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfL0P6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Dec 2019 10:58:20 -0500
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:6230
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726379AbfL0P6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Dec 2019 10:58:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOCj0L+MJkcE6PT0yMnecRNUUnNGXcndEidqrbDtA9C/AIH3kNzHj+9HpPHHVqwjOFQP8oNV/lPu2oMWIDy2aFtWbyDlRFkyvOGnxqrB6Au2GfGRkmNMFz5z4bB1YxZtf1/21mmRwqWq8kenKjwboVH5qgQX+LnS7ZqVpEIMrhlohCjxr42tRtu9f7JUTWNrAcnkv8fOMoORva26MlnYiBUlSeC+ZvGm8wfF1/uE2+zNQTgUMsdunGaUMNX08RWbJzCSjZ8k2f9NlfiOHTpHEcWn5KZ5VaALJW/wAa8RB90mKndDCTOX/XGDjmv9qKEmMcvK1y4v8uJzf0zpUKqfaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wk8uak0Vil/mw6zN+A+wF6b0s7FpuAD4lfooSEVwZXg=;
 b=MwmytmLcYaSzAfXDDO27F8LQPRvCgQQ2w+1u4flDIT4j/HSZdTwn9jV+e0pAu1VdVm8RXpyMBqAPvka1/v24TeZqIIOgzx1A2sjCwd7DPCAcF/KDX9C1IIWw/ExBdAAeIEnIqcah96ZZLiPzrlhiy6TKFXZ+eXRk8jYS6x2EuSaCe9ZOOYWdrSV5AF/3H14bA2lEEmeUrp3/qHuox66qz9EsVh5oIski755HS/jYxOdbZRzWr1TawAOexXua+JfVGH5j+pLxZAp0+Z67Pm6ulpYDQk9LsTDbDTO6UYCDKNUu3WYUEzHd+2gbfJC5BuQ0dZ42Fia1hywIF5CFyo1T9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wk8uak0Vil/mw6zN+A+wF6b0s7FpuAD4lfooSEVwZXg=;
 b=aeeKxbr8eDCJ2oOcCAhLHcMzG6WlQ8W9JlG0v0kWASeZrE1VnBbXshxUwUSJ8PtIra/GQfnNXY0DcJJvGhLxVsb666R1ypTx6tQPW1skcIhWzmB/IeKyNG9JsK2tjr1TouUtWi3CdmXSN/OXS8r12gI9eXLTvbpLqQ5qDWYLTQs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3737.namprd12.prod.outlook.com (10.255.173.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Fri, 27 Dec 2019 15:58:16 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 15:58:16 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v2] KVM: SVM: Override default MMIO mask if memory encryption is enabled
Date:   Fri, 27 Dec 2019 09:58:00 -0600
Message-Id: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0087.namprd12.prod.outlook.com
 (2603:10b6:802:21::22) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0087.namprd12.prod.outlook.com (2603:10b6:802:21::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Fri, 27 Dec 2019 15:58:15 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad600a2b-c3fa-4b0a-029d-08d78ae595a6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3737:|DM6PR12MB3737:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3737AA48068328244F4DCD3CEC2A0@DM6PR12MB3737.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0264FEA5C3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(189003)(199004)(81166006)(6666004)(8676002)(86362001)(478600001)(16526019)(4326008)(66946007)(52116002)(81156014)(6486002)(186003)(8936002)(7696005)(66476007)(26005)(66556008)(36756003)(956004)(2616005)(54906003)(5660300002)(2906002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3737;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6l4wxQYBe0gYgd8OKZsJbgxNi+smx6xdqW9h3bJzP2AmZEr/g+2jEIMWEZh2y9mrYcix4P7aK4BxuAoLmzeaQxQfl1XqVvgDbMNwExVwM7qHLaZJb3ie71fpqoNlX4Rsu+zSJqejNlWJ9dNeBlhPHiseN25HozJ5xMYJ2HA0DDn1ggk6odrkvWty6qWG6T9Mg2xZTsaImSrGhBFTaKyWWCgSJfdAlk6eRYzWp7geGs5o7GGx2wWFNcZSByWePwsB/qxiG3QjcpOOOzfatDjP8gbc4ULH2RMuo+lRCTa+OMJaCbFsUcYuymGroc7DStoI3VkVf5V8Tifr07Jh929irEGwKTOtonJlmr5jnLRAl3Q4eHy0nC0vJHRp/tzxFkiIHejbGOKSHZXX8JZ5zySVriB323Fdjb2jkAvE6hBF19Tmn2WWQIZh4Z+wHiPvRULf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad600a2b-c3fa-4b0a-029d-08d78ae595a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2019 15:58:16.0702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rE9L9PCzYfP9EGfAK67ALR2LuJF/hgjhU+Z9ycgqe1eFC2gDPtGpyx4LQn6YcTCD3G8yMUH9j/wxqmiGnoGsrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3737
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
faults when a guest performs MMIO. The AMD memory encryption support uses
a CPUID function to define the encryption bit position. Given this, it is
possible that these bits can conflict.

Use svm_hardware_setup() to override the MMIO mask if memory encryption
support is enabled. When memory encryption support is enabled the physical
address width is reduced and the first bit after the last valid reduced
physical address bit will always be reserved. Use this bit as the MMIO
mask.

Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 122d4ce3b1ab..2cb834b5982a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1361,6 +1361,32 @@ static __init int svm_hardware_setup(void)
 		}
 	}
 
+	/*
+	 * The default MMIO mask is a single bit (excluding the present bit),
+	 * which could conflict with the memory encryption bit. Check for
+	 * memory encryption support and override the default MMIO masks if
+	 * it is enabled.
+	 */
+	if (cpuid_eax(0x80000000) >= 0x8000001f) {
+		u64 msr, mask;
+
+		rdmsrl(MSR_K8_SYSCFG, msr);
+		if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT)  {
+			/*
+			 * The physical addressing width is reduced. The first
+			 * bit above the new physical addressing limit will
+			 * always be reserved. Use this bit and the present bit
+			 * to generate a page fault with PFER.RSV = 1.
+			 */
+			mask = BIT_ULL(boot_cpu_data.x86_phys_bits);
+			mask |= BIT_ULL(0);
+
+			kvm_mmu_set_mmio_spte_mask(mask, mask,
+						   PT_WRITABLE_MASK |
+						   PT_USER_MASK);
+		}
+	}
+
 	for_each_possible_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
-- 
2.17.1

