Return-Path: <kvm+bounces-13124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2CE892777
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98A4F1C21327
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF46613E6D3;
	Fri, 29 Mar 2024 23:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0qaiMEu3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7893A13DBB3;
	Fri, 29 Mar 2024 23:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753398; cv=fail; b=HFuT+KiiVQI+Uuq+VlznNW/DuqEPEGdVllPpUv17O8ePjG+WbrcEpMCo6qNhMUd8BqLav2NVptOiY/nxIFoHjcDsRqvjvPhBLQShi9fHpvjLUPY3wvijuj4sqYN1ZBQ2yWqaXL9vC08nLaUCVIAjTJXi6v0eeXf3TaOehg0IYf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753398; c=relaxed/simple;
	bh=ADKCuQ5ZPgcMUSBkIs3y/3J0nN07ibiIkpAjcxmMd9k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zt+t+EbaeVaNcu/qmoayx6Y1SCFsErGu4f6sFreT4/PBxdyt6UYNsmZyuFKEw+9plmB3zaES5zt7eohvx8DPVnjMo0Dxep+n5IAmAXtfplSqlHeyGXWYjSBE+Fmyo1rsfjq81pmCrSfE95U7XYjkrNtl4/Ikg1IAaThdwo6KBzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0qaiMEu3; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ad/NYbmdBkY5J3ovtCg2lgYBkwmWXGapNT6gLIfx47F38R6sLdvQ+OwyCEN7TGJOo11LNY1+2RoN24BqXXErFTKSdUAOBf6ViEtI/sp+c9D9ZbNccJEHBvssoTrlm01adFBVWB7wiLiaIdTM5k5Cq1ENaDisxohOCA757aYnZrW9f+eMCbsksV8r0EZf+RQ+/PMyWLmJqzS8fDGg6e1OA92fveLe2YPqHxuCElB2NdhzrFSLMnEIfnC/gv86B0S77VuZJSGQV+nhMMVKIrHpKNQrKhGTQHIEkmDGzzr/gKBAWUfLUQdtmUHshvBTXqiwqslsC0rxIt87Pj+eKbP+Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VvmmF8DWUNh/hIchD9go/drdRtrw4d4tU0BqDNiQuvs=;
 b=Kz/bVd4b2iwTHvBSc8p77Ogb7ZOhyYmb8GtLurWpdBI1Hh+2xzrDBz2ervY1ZEYi0y4Id8vBLp6KuE/8tUIKf153QqcBPt5i7rwykTs+YKrY5Vmh18rijsQKifno53VbGxNUzMEAlIr+cDKW6NhZOqQJ2Mbn9/kVHdaMUDmOYtFtuIy7jy1oRQQaZCCKL0SuZ17iCpfspvb5VNn0IWrT5IqyTJIlnlg4IF1a1hdqcJ2DO69FUW7xeAEhKR7LSbLWK/2TCAghxVEqoEe286aQfCaEpIcl30F0kAMxA/cS2y4PDwW2uqCLp4ebgiqomVk/JC1EkGm1DxFgZ9pAmK4q1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvmmF8DWUNh/hIchD9go/drdRtrw4d4tU0BqDNiQuvs=;
 b=0qaiMEu3a2xCIbByvz6b7XPeqlnhpALKFapsKh9b+47gc1Gbw8LLkKirYQKunZX+bJ17MC0cImJCKVaKNb5f3aHzFTsePWYxqwEyBBtK7RFruSJ7JDlA7Ig/+nmlEHMIxemW4VE0ZWBfkVBBFZKbGFS4+XgHDD8N8BiccQ6Xbz8=
Received: from SJ0PR03CA0024.namprd03.prod.outlook.com (2603:10b6:a03:33a::29)
 by IA1PR12MB8493.namprd12.prod.outlook.com (2603:10b6:208:447::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:03:13 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::70) by SJ0PR03CA0024.outlook.office365.com
 (2603:10b6:a03:33a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:03:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:03:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:03:12 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 20/29] KVM: SEV: Add support for GHCB-based termination requests
Date: Fri, 29 Mar 2024 17:58:26 -0500
Message-ID: <20240329225835.400662-21-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|IA1PR12MB8493:EE_
X-MS-Office365-Filtering-Correlation-Id: 6480f0c9-db72-4f68-283f-08dc50446929
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4xNaBWQcZ3bIgw+WuiB0tPsj3M5ahRIiRsRfiLY4T5qkgl1AixP6rmkzIdpZST/4jN0hjto5zAc5KXbIT6KacSBmjKKL+MBBbxtr2MJSCvUxS+xVI3vV/DQGCUfGHznXR+EnN38dhiKcAhlMaa0ocbk1w08IC5xf67rewBVQ1NkNZ6ZKQ5feBTUU2uzaa+qRJaicoeJjQeCqPJiKGKHKZLGN33eoq6JMXYyZS0Qhc6VXy028sjkjJSaWA8UaTOzXFANuMMhUtrPe9hm8oLPeiR/3svkX+YJrvp3QZ2ZKVD12v1DWPDXgiKU8yqWmZuWSA+xioJTER3y61jnKaQJ+4FrLFwkw4Nb85NpXKLjmMFQy4CkHkJ2sP82tQTirBrMqdFoKOwG9IHI4FYE9gH9waqc+3Q2nsU5TM43f/GoDWrQUJuP5jKzBwPqRs+ll4YPeETw+ZWnxiJWWolArSpP/XSG5pRJVrsCAAR4jf28M/pe8Txme/s7c+NMozsNPZzNGNxHL4vlVS+BiwCXLSjK5n5m6HrvJp1p5YouSoi+B8EKMbvRaL6WrQtdtrvmQ10fc9IGsxf6F/MDu/HllBMUWR5rn3sTGNjIV7ejxxNsTJb+PkcZShe6FZHg1fBoSoBWuV/Zr89XISGb4ri/q05z/v/tVfL8MDyvaodW29RekXa8Axpt3TWQhse71SdHiJa7FGxYXcPUl7FIz4maHPeHYTaOCJf4LH/gXj0d7cxKuIyE6/ec7AHZRKQlx+bVjlu+E
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:03:13.0821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6480f0c9-db72-4f68-283f-08dc50446929
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8493

GHCB version 2 adds support for a GHCB-based termination request that
a guest can issue when it reaches an error state and wishes to inform
the hypervisor that it should be terminated. Implement support for that
similarly to GHCB MSR-based termination requests that are already
available to SEV-ES guests via earlier versions of the GHCB protocol.

See 'Termination Request' in the 'Invoking VMGEXIT' section of the GHCB
specification for more details.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7dfbf12b454b..9ea13c2de668 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3214,6 +3214,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3889,6 +3890,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_TERM_REQUEST:
+		pr_info("SEV-ES guest requested termination: reason %#llx info %#llx\n",
+			control->exit_info_1, control->exit_info_2);
+		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->run->system_event.ndata = 1;
+		vcpu->run->system_event.data[0] = control->ghcb_gpa;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


