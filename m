Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937A012522C
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 20:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfLRTqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 14:46:08 -0500
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:1696
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbfLRTqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 14:46:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbJtVF1C4OXtdMwfaVl2uqE9aMCW/XR7YS4gW3aRdEFqYr7qMGLnB9HLzeAeicpCHSCKf4SWJtjSdFuWoXzQ9bMXpbLWRlvQY4C92rvbFYp6zY57r4csmjvGFOQWGSjoE81Typr2qoI9jEUhz9o4YaZPVGuaILyDhrE8p8aIf9N38MwHBpIsUlzlRwkDd5xDr0dS1Y0DhfQBbVCt89J4MavFbUUwcNbElCHvp9ud8FwdMhQG3rsltWRYZbFtlsysKeAN8blQMYCd4pJXygx/qSMid+jTmeyW7pCHu8IOgqTbCAlU2Ro29ZLvZdgDyFFW8yyZIedmzeceS5bvmJROkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYWCpeUyyOK1booI6/Nbb8ENUnfh4Mf4FAOsEZa8rEc=;
 b=GHn4x7KjE2Z+/KYBGTy5U2txdXTGm/kfVw1h3DmwJ6AJHQYZaFsUygaS4SinJZMcIfbidTRsYmaJGcp89wvmYDp83xSWkqwamN7OgfJBYKk6zZsIZxWZxqrGoIwRk+NmPSUxoxsNaxF3iZqK+YojEIRPYR8GOpMXJH5MCb03nZKYq9t9a+gCugOjlLc9YXLEoURziv8Y5VZatUeIreRlwrthUpjvpBCAtYO2/Qows70Nd8tftAeyhOMySoJodx4hDqiXe260CQDA/vdg3sHoFeOqMfUTbIBaY9EURh1lQMzNZlucZ3G651oVSErEQF+cgJyL5J6+3miPUJ56gO5LxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYWCpeUyyOK1booI6/Nbb8ENUnfh4Mf4FAOsEZa8rEc=;
 b=lmgUTdU5uiIKtzG53Rt0381dPt/V8EZbD42jerKYQajhJRVNbkOi+pYYxJGFz1XiYx+m14r92aj8etxK2MKfG9NY0a3MbRfzi/5lqIOj4qA4zw8b0247xYi7CA/DUtCQcHd6YRbJbyfG9d9LR8R7iyFwBWAGYxIDkgabiy9g2gY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB2876.namprd12.prod.outlook.com (20.179.71.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 19:46:02 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 19:46:02 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 2/2] KVM: SVM: Implement reserved bit callback to set MMIO SPTE mask
Date:   Wed, 18 Dec 2019 13:45:47 -0600
Message-Id: <519cd0f0f2ff7fa0e097967546506c07e2e56dda.1576698347.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1576698347.git.thomas.lendacky@amd.com>
References: <cover.1576698347.git.thomas.lendacky@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0007.namprd21.prod.outlook.com
 (2603:10b6:5:174::17) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 620533ef-a3a2-4acb-e519-08d783f2e996
X-MS-TrafficTypeDiagnostic: DM6PR12MB2876:|DM6PR12MB2876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2876B8483234A5B7A97DC90CEC530@DM6PR12MB2876.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0255DF69B9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(189003)(199004)(478600001)(5660300002)(81156014)(66946007)(81166006)(6486002)(6512007)(186003)(52116002)(54906003)(36756003)(86362001)(6666004)(4326008)(8676002)(66476007)(8936002)(66556008)(2616005)(6506007)(2906002)(26005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2876;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: acAWswFqSm27kKf7rWEvmMYlm31I1PwhOm1Ud6WCdyLS4gEnSyEavQ8dJSCvHfuyR1z6bd41WUSkh9rbIdVlFFU5Ht+2eafnwCOS6Su3zPKtZmjofQbh/nZylTWfhOMxKhAFj9FmPgKJmlzyiKgYf6Yt+AL+QjcYKzUqV/UW8iOXSxxwT7V6dXJmxRObPeHcBzKhhCvV3l3VsL0QISF8VDVk8VK/YO+lgcIKMK21MskeZvAzZ7fg72MG73bpecnU5b2iYRqKEkkSm1vlltIf5S2XSFMmcEa72Sss9986/y6neQMpKN2tmVB+NLOhaozugKVsf7p/h6X+5BOKFTrPCi9Ai70EAqrvl26C4pCLcWjxsu+6yZXsJCH78dWqXZccgXajkJp5xft/RanPpskZ8uV8Uv1SD8pRVdmIPDFHN9NndQ6Nq9SC8ZVOBI9BOSa8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 620533ef-a3a2-4acb-e519-08d783f2e996
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2019 19:46:02.2707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +jN0Y2hrl2R8JdffeKJJSLC5gkwR+c0E3l7OObjpS/eDJR321rGdt+mIRyxdPEHYkFFEHNiMZP3IpYqVDN4/sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2876
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register a reserved bit(s) mask callback that will check if memory
encryption is supported/enabled:
  If enabled, then the physical address width is reduced and the first
  bit after the last valid reduced physical address bit will always be
  reserved.

  If disabled, then the physical address width is not reduced, so bit 51
  can be used, unless the physical address width is 52. In this case,
  return zero for the mask.

Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 122d4ce3b1ab..a769aab45841 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7242,6 +7242,46 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
 }
 
+static u64 svm_get_reserved_mask(void)
+{
+	u64 mask, msr;
+
+	/* The default mask, used when memory encryption is not enabled */
+	mask = 1ull << 51;
+
+	/* No support for memory encryption, use the default */
+	if (cpuid_eax(0x80000000) < 0x8000001f)
+		return mask;
+
+	/*
+	 * Check for memory encryption support. If memory encryption support
+	 * is enabled:
+	 *   The physical addressing width is reduced. The first bit above the
+	 *   new physical addressing limit will always be reserved.
+	 */
+	rdmsrl(MSR_K8_SYSCFG, msr);
+	if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT) {
+		/*
+		 * x86_phys_bits has been adjusted as part of the memory
+		 * encryption support.
+		 */
+		mask = 1ull << boot_cpu_data.x86_phys_bits;
+
+		return mask;
+	}
+
+	/*
+	 * If memory encryption support is disabled:
+	 *   The physical addressing width is not reduced, so the default mask
+	 *   will always be reserved unless the physical addressing width is 52,
+	 *   in which case there are no reserved bits, so return an empty mask.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_data.x86_phys_bits == 52)
+		mask = 0;
+
+	return mask;
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7379,6 +7419,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.get_reserved_mask = svm_get_reserved_mask,
 };
 
 static int __init svm_init(void)
-- 
2.17.1

