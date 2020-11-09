Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD412AC88D
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732460AbgKIW3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:29:34 -0500
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:4832
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732388AbgKIW3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:29:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYhqz9HRMCKVABMtkHCzd/xSvAr5KdzcCoZsgJf4Wxy2vQ5l376LDP47uof7v9FFWi5lRgos62T+oYkGRozebg6EUff0OHgIX835ztF/HY71Ew/AQ6xXeVesVMyWtNQud6ALIF++wHBBCBQG4kf/MwdHc2lBAPD5fVSZ7ekgvjzfDmqc5SryMkSAK90gefS8CFT/Gi3JtCyP08qo0A1D3EhiN6fi5vQxU2ghhfaJv75NQCMoyKdw617ZqQNmFxzY/J+4bAmin41DjJFHm+xBY3cdMDT9ae6sqyDXt4+u84lxWFl90cxPmWvJ/hAEP3Ok88SFfUOeHaAsz8Mf4jPD1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaKzEKVYszNGeUwnPIJCYKDleIBl9k+Y+DpHfZX6hxM=;
 b=fxFYOYh6Qn6HVS3v6WWCmwWfPi4fqGQR7zBldLQEHtc6exLjrDjQAKXdrBlHVZPQGB9HyobvWFjZnvYWHi9565RZa3iZN0BhhDdXvuGK476ms2StQzD7TbH8WXBfGoValrdL50aoZjLCxmbnKEbl5Vod9SZ0r68UaC/iLPNx7SlUeqIbnw0lHdIGIcBtKvxvWQXrX56VIglZrhVrOm1SWlhdyxdlU8J1o0VAOJ7jvvLNXa25kxXBX84mWR3j5sjJsTRdquMltfuWawwMJ3ysu2hcjL22FU8gui1/FUgfQLN8qMb2xwh2n7xL9IHWtEwMr+YVVPxuBNVjxU48JxqORw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaKzEKVYszNGeUwnPIJCYKDleIBl9k+Y+DpHfZX6hxM=;
 b=FJe5IhGuU/8Y6ZqoSA8przV16AQvubNKK5eeCZ9/Rxpec73saKkuhzK9ckkse2Jf/lWBcFzgbP8wVNVbu0M0nbEaEixkViuYv8sqh/AK+hXSoc9K1hrIzEN2pshLqJLdUKm9xZlGE8HqemuoY1ie5PKdCKaxUF+TeNMP2eF5NoM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:29:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:29:29 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 25/34] KVM: SVM: Do not report support for SMM for an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:51 -0600
Message-Id: <728ca6f239633abb5ddf1479f8e15826a712395b.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR10CA0014.namprd10.prod.outlook.com (2603:10b6:4:2::24)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR10CA0014.namprd10.prod.outlook.com (2603:10b6:4:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:29:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 784eb44b-7630-4a5c-53dc-08d884feec37
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40582DBA838B54321556FD1CECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XtHbGm1pcuxQlitlxVjLNTEhVkxlrXYRkaoVvRl5NRPtQEROas1nrbxTxAitGtRnpTO5PzMzQnZa5aJ5a/VmgNF+2rMqau2UbucMxbHO3lWiHdYKiUOTd4aKISq7tmSXRGLzEKU7mOEpJHG3z71D5YzM5DrMJrbTBAW1lAXBl3GEPdEYUDR4LMYMoyIJbjTl0x2rQD9oD6P39dZJbAtFaFjalv3d6YkZ0zgPaSyaMpXcV6c2daSMYUo+PzxiEjnlslre5Xg3KTYybX16wrV7HdZqTHd3i4DPVJxLFhLUd3moGE4cvyWkIM+8SthwZqSiWrftbqHyuek68T3F9GBtYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: S2B0YIN74pRLrEVv3mycvVWG8nxzAvDpXZYS5HPhRrN8tVjmSyPFib+3Dc3Wb/QeChVtY6Za2BQJ9MKUceR2e8LlYN91k2DrYBlfeec9g6aO8WjC1QlbF414qN8tpX0ySTasy2TzKoXaFIreWlLpzWuA0Bj9r5/tKyR5HTHORUroXo4NuD+09cKCQEqs0Gep2xLviWNK9Cn/8JrVap/9D06ZW8dssYCb8CuS+JHeFMRn6yii+S6W2KMc6vA5Lw/5Q0ahNxbL/+1JRUwkqAPzraT4yAMeQ8DamiGmfgL4Q5FYizO5KRXJZvJm5JiBvVWvX0SIOnlinxbVSfpJ3+FyzJXOTcTiq10OteWUyZIapDFP2Y+KKwqvjJGTWReQEF1BrCsK0p+mC+d44Nhc2KRsHhShIkIFtjslj/5Nhr7okF3kIOO7XI3acePosUZ50+6rymPattFV8X9bo5RQAVb8g0q9lweTSteRVFHhDUch0wRIXGMplsglpcTOPm3K8egMap8xWFatgfkcLNM34xKZpuawuvPSoG7KLPQO9oE9sJ//TNgZmerpuvmSET4XvdP8/ITEPkQPDpZ3Pr5iTqBc+VwCMGz49Uh+jDgHZdIDXvbhurXfKZOmhi4zfNBo5PjqaBIEzY1I+Gj6LIcf6DidaA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 784eb44b-7630-4a5c-53dc-08d884feec37
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:29:29.5122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKOdyDPq5UYfiAcfYhpYeZwxFpKwYN/gDRFQDxa0jK4SvPxMytO2pgJ0G7nPgBtwcj+CPlHXqfyuYJnxOIpa8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

SEV-ES guests do not currently support SMM. Update the has_emulated_msr()
kvm_x86_ops function to take a struct kvm parameter so that the capability
can be reported at a VM level.

Since this op is also called during KVM initialization and before a struct
kvm instance is available, comments will be added to each implementation
of has_emulated_msr() to indicate the kvm parameter can be null.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          | 11 ++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  6 +++++-
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bd7169de7bcb..51343c7e69fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1091,7 +1091,7 @@ struct kvm_x86_ops {
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
-	bool (*has_emulated_msr)(u32 index);
+	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	unsigned int vm_size;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fb529d5cb36d..b8167a889d8d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3922,12 +3922,21 @@ static bool svm_cpu_has_accelerated_tpr(void)
 	return false;
 }
 
-static bool svm_has_emulated_msr(u32 index)
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
+	case MSR_IA32_SMBASE:
+		/* SEV-ES guests do not support SMM, so report false */
+		if (kvm && sev_es_guest(kvm))
+			return false;
+		break;
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..006d91dca695 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6399,7 +6399,11 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		handle_exception_nmi_irqoff(vmx);
 }
 
-static bool vmx_has_emulated_msr(u32 index)
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 647d9e47195a..aecd931f46be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3777,7 +3777,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * fringe case that is not enabled except via specific settings
 		 * of the module parameters.
 		 */
-		r = kvm_x86_ops.has_emulated_msr(MSR_IA32_SMBASE);
+		r = kvm_x86_ops.has_emulated_msr(kvm, MSR_IA32_SMBASE);
 		break;
 	case KVM_CAP_VAPIC:
 		r = !kvm_x86_ops.cpu_has_accelerated_tpr();
@@ -5789,7 +5789,7 @@ static void kvm_init_msr_list(void)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
-		if (!kvm_x86_ops.has_emulated_msr(emulated_msrs_all[i]))
+		if (!kvm_x86_ops.has_emulated_msr(NULL, emulated_msrs_all[i]))
 			continue;
 
 		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
-- 
2.28.0

