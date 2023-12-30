Return-Path: <kvm+bounces-5404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B415820809
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:37:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6BE3283B51
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E78014F9D;
	Sat, 30 Dec 2023 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZelDUwPD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2074.outbound.protection.outlook.com [40.107.102.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11AB14A92;
	Sat, 30 Dec 2023 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHsySAU6EZzKqL2WLihl9giGtBSmYVZ1xqKJ/COgBcZjRn3IEd78mLzk7K79HHvxVkls3TzlUXKBfacqXc9GzYmBO8jHXIZJFYOl1o4ymdswpI5QXEsyG7Ev9GpGY3AL+6RSOFfJhmFPB58PjoqIuYih/uXeaKheJa9l03URDwMJg+yvh9EU9w2CtFCuQ+FY01cKAbwt1I5YBe1gLgSheTjxqsRlo3ny/Kjx0bhyxTz6BCGe/BGiorrYX/l72MmZ5o/pOxSBmbPvdMR45tGxMfbjZg+oVsJ8mVrnkvsi73BfQrWa2wZiIuU3hFfZm//pBd7UoCBX6FXWHHSgN2+yyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=suPeQu3ZqbFX6Q/W+f2tBEOWSna7wKJedszjB7wQMIM=;
 b=HwxhfFnJx3bDeGjhRRP8WKXb9AN9NHqp1dRa0K1g2QpeV1wg2D4PbjdpkrqsZw83zxanUYsq5hM1w1ltODsI6br06vGrAqvneigm2mbXRPqq7JYliU4lC5FWp6TMminr/kzZ1FTAi2MujPTQa2/oKcfhugBkEZ5OH8mqjGxXQesmZsN1NB4a3QyyuAcjeGsQ/j0rm4bT7tSsx6GH19aN9boFmZYvIDCtRqSkA/YcIqOlapx08yV6NtQlk2dswp/RzMr0IIzyzXzEwpQljxptyaB3mo8NBrvLuM/AE9nZsLvTPDB3hmeGOYBjxVr4uuETwOQpZ/2t6JE0Ey/magV+Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suPeQu3ZqbFX6Q/W+f2tBEOWSna7wKJedszjB7wQMIM=;
 b=ZelDUwPDRL53ZCNroikc6fGfTpII6hXRvhSZ9wryiN69kQ7KYs/r4P8rfA3UiPm+Jsfsc1UCb0V3kM5GrHxnNemYIFtBP124ILS1du2HoIFlGzCky9dY0PAu+gwqsvWjkxCeHQvWM0xuAdrLU7Jx6iz1mm2yZ4VwwholEiA1fXg=
Received: from CY8PR19CA0009.namprd19.prod.outlook.com (2603:10b6:930:44::14)
 by PH7PR12MB7114.namprd12.prod.outlook.com (2603:10b6:510:1ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 17:36:09 +0000
Received: from CY4PEPF0000FCC1.namprd03.prod.outlook.com
 (2603:10b6:930:44:cafe::14) by CY8PR19CA0009.outlook.office365.com
 (2603:10b6:930:44::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23 via Frontend
 Transport; Sat, 30 Dec 2023 17:36:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC1.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:36:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:36:09 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 07/35] KVM: x86: Add KVM_X86_SNP_VM vm_type
Date: Sat, 30 Dec 2023 11:23:23 -0600
Message-ID: <20231230172351.574091-8-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC1:EE_|PH7PR12MB7114:EE_
X-MS-Office365-Filtering-Correlation-Id: be5358a0-ffd0-4a2c-3c39-08dc095dcf5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5q2d07QMAIpNskcHBIB+N1EFO1/pfqjPgE5QxvMTYi9vkQb2GIvV+nL8gegomJLGkxkeJGCkZnwg8D7dBDmKb+gVtqlX6vhMJr3ctnXk8wMQ6g++NzkpPwd8rfriu8NIWmUfMiWWFCi0MUTCQd064TaHjBh3ToOObzskMSY9A8DzdaeM0tbW2EmO6lSgqxjBno1j3/ZR9eRRZyIdzpiWB2p3t8xGlftaPkM5gwBioja1a2bHfg2LvnWwUc9Y+4QjJgOiwfV6SF2MH4t4a19etTMXrIsLRfcj6/W5RjVUOxrc4Po6bWR4wlIgo4UeJb3m8PujgNwTaJGH5N7jKwf/TuRTgQFimohFxIKMfjSftb0EoK7YkUV7v9OnoAQS5axGoPC3jyoBPZWdcaN7ve/LGUxHcB46rGk8Y812s5bt00IvQQnKFpfzwVOWmb8tJdd00btgmtzv/xR+Ot5umo9uHht78tExPJOjoTLaigL9ozH0o3U8xGLG0m9fG86Al4iMNaGbtJlBySNvFQmY1PPokL/JubdZNK3+IUyTeYr/V2y3GL3Qgt+V3/+ppxxfHimKB4yAKCKGlz+Yo8yjx3LPowK2d5tlKH1qo9RfSjl2ucQdWnUYCLvjgNMlCLJdBIT16S4y+280VZfEnFnVSBsQrRy+ugcMo94PmmXDipcqY6BuyA0a9EFMfazhIhiq5ZHvZNms9W8RR/dgpWyioXl2IO2WHiQuWvK6TSvwfbXvC3SahxhkE/hLcnnPlLVEpqKv1/c02dEdrSj51l/Z+VO9ew==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(39860400002)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(82310400011)(186009)(40470700004)(36840700001)(46966006)(47076005)(83380400001)(2616005)(26005)(1076003)(336012)(426003)(16526019)(82740400003)(356005)(81166007)(36860700001)(41300700001)(8676002)(8936002)(316002)(54906003)(4326008)(7416002)(5660300002)(7406005)(2906002)(44832011)(6916009)(6666004)(478600001)(70206006)(70586007)(86362001)(36756003)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:36:09.4407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be5358a0-ffd0-4a2c-3c39-08dc095dcf5f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7114

In some cases, such as detecting whether a page fault should be handled
as a private fault or not, KVM will need to handle things differently
versus the existing KVM_X86_PROTECTED_VM type.

Add a new KVM_X86_SNP_VM to allow for this, along with a helper to query
the vm_type.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/x86.c              | 20 +++++++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 63596fe45013..e38cab5dccae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2141,6 +2141,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 #define kvm_arch_has_private_mem(kvm) false
 #endif
 
+bool kvm_is_vm_type(struct kvm *kvm, unsigned long type);
+
 static inline u16 kvm_read_ldt(void)
 {
 	u16 ldt;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a448d0964fc0..57e4ba484aa2 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -564,5 +564,6 @@ struct kvm_pmu_event_filter {
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
+#define KVM_X86_SNP_VM		3
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aaf71e5c1d18..87b78d63e81d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4579,9 +4579,21 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 
 static bool kvm_is_vm_type_supported(unsigned long type)
 {
-	return type == KVM_X86_DEFAULT_VM ||
-	       (type == KVM_X86_SW_PROTECTED_VM &&
-		IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled);
+	if (type == KVM_X86_DEFAULT_VM)
+		return true;
+	else if (type == KVM_X86_SW_PROTECTED_VM &&
+		 IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled)
+		return true;
+	else if (type == KVM_X86_SNP_VM &&
+		 IS_ENABLED(CONFIG_KVM_AMD_SEV) && tdp_enabled)
+		return true;
+
+	return false;
+}
+
+bool kvm_is_vm_type(struct kvm *kvm, unsigned long type)
+{
+	return kvm->arch.vm_type == type;
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
@@ -4784,6 +4796,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = BIT(KVM_X86_DEFAULT_VM);
 		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
 			r |= BIT(KVM_X86_SW_PROTECTED_VM);
+		if (kvm_is_vm_type_supported(KVM_X86_SNP_VM))
+			r |= BIT(KVM_X86_SNP_VM);
 		break;
 	default:
 		break;
-- 
2.25.1


