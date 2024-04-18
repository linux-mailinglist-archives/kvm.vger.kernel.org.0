Return-Path: <kvm+bounces-15164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FCF8AA383
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AEDF1F22539
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB228194C9E;
	Thu, 18 Apr 2024 19:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hDogTjb0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE3181B83;
	Thu, 18 Apr 2024 19:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469884; cv=fail; b=eYLxnuEjnMR+PH5MV+JA97LD5C5RY/NM4YlMmxVu0d6fywf/u5/AdPwkDrBLDhwcCC5JOIOW7M3MQZoaqktab52b7qfIWvS3mh0cr6oYTVDWmkEUnt57CpE7mLYNIKUYHXC859sVMnpNqYpKULDVnd2EkgBto0+LtysqQJYDOsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469884; c=relaxed/simple;
	bh=pMKa5IcwzEoMzog/AhhX6W71dGNHZd5Om3r4C1Llpj4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rc99pjt4uT+7b57V/JjR59Fmi+d4n/N2C8semoiG9MN71BnGrwFVwBQn57m0ZKTv53wfmmErVQdrueImO6EieTa43Vl0EEaM00SeOYUuO9L+NcaU9XeY1Uqi5euL2LoWUWmkMSUOWdYplappkQaKa5Az3+WsB3GdSnISthAlik8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hDogTjb0; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMRTPctqWgVWvSivLiqkJKycroy+E8Z0/5F4prDNQ5Bc56oLApdTCE0qoP6hhGbrdA9lAs2bkUpNUi34EEQ5asZ8Z2H1Y7CGYt+w0qurFZmXa+xl54rxS5cGQLB8U/ZDGDduqd6JCpuZ/Gg1AaZK8sx0Ca/70bWwneRvFFZqGzL2Jned7ktjhT8kbrdDpdF5aznqocSHLFcMPaEux80zyYWVgBnNc5HvCztzCqv5Frd+5AeY62LdxCrv+N1FGuqZNmLz0Oyfkyfb/V9KCy8DRIZmocFGkrmnp0eQGHumyHG1OLiqbdiMwd1SJfqXWcvL08qHX/8xFeC6fbMIx2p1Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgJgGQzmEQFn3qDjiul4utVDj7Am85Us4DHS4OSv5bE=;
 b=B3dnVOG/UNjiqgWzkJvkU6k9biN7AqFOl7/eTRPUk6XkIAChcgMD2Y0a7q0B3PQnsVc3gpjcpaLb9ZIic3I/YYWsfe3qz2kOFuZHxuKV4ibkWljX+Qi3v/u3uDwdkT/dwaRyThiP0x+1PENDvhA6+/pXa2yB9gcq8RQbtWUSBvapk0WwoNZHNbX5uLb1IIkcJHBqo7yGTbIteLJC3cSLBOCrKGztVayms9uJN2i98hsW3Luahw1GgRpre5cKhyMXjQfdYupIWi3Xw2nRPJhcCAj5KxFQN04Y+6rYKn200NCfKTaBCSds9NsttECNjTfQ5uYe/RwDgKy6IZaDabLWcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgJgGQzmEQFn3qDjiul4utVDj7Am85Us4DHS4OSv5bE=;
 b=hDogTjb0ne+THYWLgia0Z0VZWrfoIPit4JmAppWiVKdADQmPQZ5j6FVrkhGkVIRLpx7ESAkk1mouP5P+iLk5lNjQMV7iht7lIcLvbaWvH8UmG72igRjPLnBhVCPEP0sZeoUtoO/i/MfMdDpuohUQsB0JIGYXZB72HQTlxz9cFqk=
Received: from DS0PR17CA0019.namprd17.prod.outlook.com (2603:10b6:8:191::8) by
 CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.42; Thu, 18 Apr 2024 19:51:19 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:8:191:cafe::9d) by DS0PR17CA0019.outlook.office365.com
 (2603:10b6:8:191::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.33 via Frontend
 Transport; Thu, 18 Apr 2024 19:51:14 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:51:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:51:09 -0500
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
Subject: [PATCH v13 07/26] KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
Date: Thu, 18 Apr 2024 14:41:14 -0500
Message-ID: <20240418194133.1452059-8-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|CY5PR12MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a99669-ed62-42ac-23e6-08dc5fe0e6e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4YNuoQaOceV26QYVqgjC1m+cXuqXQmc1V3yqqi2w/W0XpmlnRXIjE97Y/44StPx/BwmWVrk9ZuVe5juyGnhCz4hi8EQq1tA/MpzI1mBganR8l943hScPPl3wrxMr/Ruhe994xveIktg+LiLl+f6hK0gsxqIx4qN9ilmtAv+oBaha4OzfF4l7tiE0rtkpZYkgtqZBt38BKWQOLtcFhQL+PwJid6/Zb7xeewnm5aj/xZJiBok8nyJgP6IX1TOUro7I+fv6DYag4kBqcgnwYyloe7Ix2FB3FzRt7wJVUU2Te4neRb4EJANLj+UaKzy36304q40sTkGxd48ohx9Q1fwHwJAMOY1COK3e5pHJW3cS0HBeKa7YuR4LweLJPnKGwkF7EOuq4XQvVKUqHxs9evX3s3nJqk3OTwGTrBRlfhQC7jyC6WlQ6lh4GBVZTWj+XIQPkLuEnqEYoXyYDgUM3BJsVhyZ+Pd8IYB100089nwUtiLOCCQslznkRXqCpBUDY3rFZX/9lT9yG76LfpjachvVbzpQmA1n5+hNaW2p0wYhVvV/BZ4Q65SyDMQZzf9/w2KRTucvlBzrQCDyd1eALphiTnUWWrVlyMFZZkXGi0etnrCYtkcO9IM9P/jHux+KAUGsqaLznt2j7b3LoBevWw7SRzwmCAR4g22gR4TBIHsf4qdl82xXFw9u+jGecIOuji/OzBNd/WKaCea+sqKBlLQ9sgwVREOL0VojoWvUCx2kUcSaNE8z68XgtQ/oFBDOnbWi
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:51:13.0025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a99669-ed62-42ac-23e6-08dc5fe0e6e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6323

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
index 6e31cb408dd8..1d2264e93afe 100644
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
@@ -2701,6 +2703,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2961,6 +2964,12 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -3085,6 +3094,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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


