Return-Path: <kvm+bounces-13141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCFFD8927BC
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ECE8281E0B
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4D013D627;
	Fri, 29 Mar 2024 23:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NL8k2ZOj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFB113D248;
	Fri, 29 Mar 2024 23:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753753; cv=fail; b=kR13X/WMVNzPClFF2E7tkBuctYgqkIkEGowlcxk9RTDxWbcJgQMttFueBbGt8TOLErTSgQDwsKCiUBD+Avkze0lp+vf9e5IBTvmaonHFCRNU3yRIzx/beiQWscO/1opt/sbsw7w2ImvERq4+OI04ov7Y0mYJKyAE8RjzPPcztL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753753; c=relaxed/simple;
	bh=aLomTrf9SIDzLw2oNU94EpYWwTJyeQCX+3O0wOuvZrw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bx5Pfr6ifQtre0jbNL7J7tzooYFXiHtHEYdR1A/ZOC9wcpAO0FfcMHcRUo4OcVfcctoPVyxSfC9dr365lTg438Dh2Yjl0BMrDJ+UugSP/LXYA6uf+nwW7MAJ9x0H6M5QOeh2mPqmQaO8l1/tMoTkHHknk23T+kx9v32XYC5CwA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NL8k2ZOj; arc=fail smtp.client-ip=40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nbwxo/Sfivyq+9sO+Uznd9brSOnWNxXcV/DSzxeV3OCOxzLguphA5mwUjBAt2UrCmoORo1BqNrDMnuYfh/MF1YixNeTiqS4uLKx+xeDuYf7lWzutLEp5+iXTVJ3PerO0wgktFP4rPpyPwRq4gvlNZHNcwz/Qiuna5sB6SWGz30Munst0AcJQu2DRXSuGQdzJ5CSoF3CE8TOjA7fdjFqH+SOSdFBlw/jFQy1KSaRtmZNg2Vvccku9pEzqwEy2hqiRsRUBXtDpVjIGR8gAqdN7h1g+1brJ+nSJIlvMB78FEZJF6Db37MZTNzHKrzFdoUhlKfCMGIEP3EGjVx70d4fYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JyBIto+oyeq2xLryrMPgxZB/uFVwetpVAZkLQukBgP4=;
 b=UHd+vtr6Xq17u2zj0F+54568WxjxUu7bhRq5mCiVqAsx6/8foTga+tjl6FB37Rk/gCadl8Hyu3HP6KOe5fSfj5Y+Fg39dRBHjAz+LkDwE/p7b9QgXpJOKeTbOwmgaP7p/JpmTwY1Nqoiz8gkuc38f/vi8oJOVG+10WRQIaySFA775ht8Qo/2pgPMBfyZJY213GN4vdR/iR5qCsjJdOun2gO1Zg+xAcSIliyIGrzVMp8zwNQm8m5/DpER15R9pLXzvIXFcDLLxdpW5T229/GQy6Io+7wtv/LRR8ybIPK8gX47e9g6ZPahsIgMHaTNBamhxCWajKIL9jB5YDunqwETdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JyBIto+oyeq2xLryrMPgxZB/uFVwetpVAZkLQukBgP4=;
 b=NL8k2ZOjyllNv+BOhVsE+g+IY9SqGG/lRFiTHc46v7vYp9YB1ZOFvfFW11KaMWRZiaDNeCtZP14EUp1sh69rwCeBGAG4rBmL3K9cyXTXacg+KZVRTaGkGnXJhEbk7k13iM3BRcde4JuhCfSqIQ/S4H99TNgMKSadIOFKe8MQhRA=
Received: from DS7PR05CA0081.namprd05.prod.outlook.com (2603:10b6:8:57::6) by
 SJ2PR12MB8978.namprd12.prod.outlook.com (2603:10b6:a03:545::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.40; Fri, 29 Mar 2024 23:09:09 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:8:57:cafe::63) by DS7PR05CA0081.outlook.office365.com
 (2603:10b6:8:57::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.17 via Frontend
 Transport; Fri, 29 Mar 2024 23:09:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:09:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:09:08 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 08/29] KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
Date: Fri, 29 Mar 2024 17:58:14 -0500
Message-ID: <20240329225835.400662-9-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|SJ2PR12MB8978:EE_
X-MS-Office365-Filtering-Correlation-Id: 64d39520-d208-4b29-8abb-08dc50453d6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lPJJMbGne+4Z7fo2ps/HjPCqG7bRgNidjM1ZY+1yitblxsXSb7RLE90onCSoEFFNkqjOFmuL0DAFztxDlmYQO7LS43j1B48JN4+zzmFjlGxNq9LMfh9nLkkAhsjxBnumc9RHFUScsxJ5flbRuNHvptWFgmjWLGHblCsrQ5ws44oFgH6W/IjvWf5A4ndelWHVsCITNwvX6X8Kd3hN/rGI1lOgyybomh2O9voSPI/RHL7EHdPkGa+pQvh8yN/Vg/lvCiZi+GuOn4IX+kP+Jge4s+pD2YyTc4hLE7og5UCEKhTo2P8jlLMSjitfIudLg0RlJEifdIO8fNepV/TyXcZfkARMjpO+iE33F39IQ0gjqMWKoeYD2ZmylzVo9OwFOVy2yGlcld/c7tNynBIYOZ/L97PWpgNBdt+Fm6bF1FN2xz7RatfW8/n6BHecKsgV/jPiO8RK2SbHSWdk16YwT3fsy1IOF2f0Z7ZYZAhd1nWvTqvuM5dlljvuPNLjqQQOdJerpwVL4SiBnzvUcGkcuFrKYQRMbuZk6qM2GnzZuhNhX5Mu7pHHf2Tkt4fAdxTaV54HvFmZHbqDdahOzL1aeCLTwZR0oIVO2P7q6ApKbDWAWnN4h6xD51MxqDqfYDv7Zn2PhatmT4TadKNLuLizp8WwHtrjagUpkCF8R3PvGtCuquyvZ2/qwwem+SQDEAlUGOjsE57NiBsL3HIgAz+SF8/ah1bngLS3OL1m+xagVdtqbBkC+XsgalTf2abReXgYnKlh
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(7416005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:09:09.2475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d39520-d208-4b29-8abb-08dc50453d6c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8978

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 01261f7054ad..5a8246dd532f 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,6 +101,8 @@ enum psc_op {
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
+#define GHCB_MSR_HV_FT_POS		12
+#define GHCB_MSR_HV_FT_MASK		GENMASK_ULL(51, 0)
 #define GHCB_MSR_HV_FT_RESP_VAL(v)			\
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7f5faa0d4d4f..1e65f5634ad3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -33,9 +33,11 @@
 #include "cpuid.h"
 #include "trace.h"
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+
 /* enable/disable SEV support */
 static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -2692,6 +2694,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2952,6 +2955,12 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ:
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3076,6 +3085,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES:
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


