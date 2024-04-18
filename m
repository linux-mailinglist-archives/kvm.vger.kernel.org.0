Return-Path: <kvm+bounces-15147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 301278AA33C
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:48:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B40241F2382C
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDCE4199EB3;
	Thu, 18 Apr 2024 19:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wLiPkh8c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE25A181B8E;
	Thu, 18 Apr 2024 19:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469521; cv=fail; b=Ro13MladNOHalEYqFDDb2FCow372GxEULoioOd6iOvNrD73pgZH8UTXpDEoXMmKbAJLQBGSlNhi15FHAhnIXMK1nc5yoeeexCWWWY28W+FHIuHTTxrZNFhXE+ZWQ3KcPRj38FzPK/KSCOuJeT5IUlYUZo4Bz349JR0CKmuAtYxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469521; c=relaxed/simple;
	bh=2SfvozIH33u4cXAMBhSOdNQkYC97O43EfE1QKnPd72U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OVPWoGRPF7SzJ3ShB5v58/cVvQ1E5ujfneI3RAHjVfPY08aMfu6I1JF6wG+7ZvbIW2KneUZodPag0WaPK3conDDZ2A+YHOMs5OJguqZdERW18MKgcDKfku1Owckb+66z6KrwnuNr4ec7dw+Chiq+FQWX3XhnA6qmeheu/frMidc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wLiPkh8c; arc=fail smtp.client-ip=40.107.92.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mG9auSHwDrYrhO2jpUKjNOHDr/N6eyheXTa+4VfPTqO3TMFND6SMCjVe6EaAFFX3IcSfqZ84o10uHTbLIuDTfDGL2JszbDaFbiNMCKVDO3iDpO3UE3XwZfqyQ1skJkAwJro+VfnNb4dZyKF990obTLpR1VasI1yUE+dr/BuyIwMPYfRwrZOb1Gscq1zbCKGxvvqHvn/F9RxirVd5iYcj1r27s06dbqNPPDM5qAXM9sa3FcPNBXXAkPiapJleXU117E6X7U3BFcwHZWHsCc/mNvJQrKHQ52Ou0jorSAoP0Dz6KGrZ13utWTHBVtm0XI3jlwVHb4KHPLGubaK9JSXKZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bx+UiV/8mdVOtuDMjYEt0x2o+sh50xZzYMq3LpQNu/k=;
 b=h0l3uR1En71OA9ip/IyvGSpBEne8AfO+YApp9WbkqQAiq5GP+2F3spfDl/+mf5AvCAS5cku3EZ02RTnGjE9cxEnyWuqJbUHUGTx75lQztcMtzXIHW8zG0hq632c+PdCxhKCT88l/V59vqbprWIbZzlwls4WjhJnQlNUp8hrJwdmPxgxsPN2zEvL3gUFThkUek+FDVcpNLEW2TI0vwAVaxbWnveMREmz5q5W/CiLeRqgd5ziI1nNPUPrUZYSxUAoQRanR6Rjp3RZDHBJwUrviWZDEepIguD2XR+Gq89MS1ohDkp8hVhWe3uB4aX6aEzIfD10wjtVLJMY2Id5HMzI39w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+UiV/8mdVOtuDMjYEt0x2o+sh50xZzYMq3LpQNu/k=;
 b=wLiPkh8cItOydS7Gq3V4h+R2HAHob+fDLsXP+QsjJJXVxe4cx+6HFQ7WtKoHZ7By4xduhYfNasdHOu+c6ys0w0/ZjIQJefZZWK87KYpvMfcc86GpeeDVoGIjliCwwsHV4YSYUU055ZFTyG++cNbkAe28+9WS5IXos4kQTjbaGlI=
Received: from SJ0PR05CA0176.namprd05.prod.outlook.com (2603:10b6:a03:339::31)
 by PH7PR12MB7377.namprd12.prod.outlook.com (2603:10b6:510:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 19:45:16 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::12) by SJ0PR05CA0176.outlook.office365.com
 (2603:10b6:a03:339::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.12 via Frontend
 Transport; Thu, 18 Apr 2024 19:45:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:45:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:45:15 -0500
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
Subject: [PATCH v13 17/26] KVM: SEV: Add support for GHCB-based termination requests
Date: Thu, 18 Apr 2024 14:41:24 -0500
Message-ID: <20240418194133.1452059-18-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|PH7PR12MB7377:EE_
X-MS-Office365-Filtering-Correlation-Id: 244273cd-9da7-4496-a46d-08dc5fe01278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rFuUwldkLH25m03dkf6YY/11rMjS7H7hJru+uOCHHIUZUntJ6ul2L+ATuc/lmpH7cA8m46mogtxk87a4r1uSDozr2DPXIxIq68oacyFNzl/NRcwcIACdT5aH040jX+wrvPbBsqbm05aY5x6ndHf4OdD8pXpmbPv0djxqw2APx5gwdZUt28hpF8ogcX6SurDBFUAhAkcFsNtgngBMP6Cf2A3eg0Tj8TRxDGtJySZJwGzJ6hDealNp2YrWkcHe5iv0JG1XQwHCczttHV0YEnLhlwVbDApVS2WOyzDM7bzm+GOUz3A64Ts+dy4n4/kG1SJEeTouvKacrCMjPzHJH2rW+24iF++/Vyx4nAacz30fBKBrbBtsduA7aGduROkWaaLLAkYqHtNIy1dQhfyJNH7Lt+guV+PEEWHHwBDjAO1ekBCLr4IuEWgA1kZFSHFZDXOcFfdaC+Eza/HwXudvTtdBgZhVzQf542+wJ9MEXz4s/r+GsSaBUuVfadOoZm+vHI9nSdyRE5bM4LeKGe6qylJaZuMFgE5yWEcGq/chNKzsmV8YInQI2UGNCIrIKSyYQLWhfFQK3dJAqYdM2Uk4sxEpfEjUoiD9tMIgzImlRi69G9piwHPWBx9pAYeglRRwHxZBBtFBakyA5nbdfWULAhYZq3i1t7prlOjh28kRoAxbq9utPB6sn8soodQtRpBYbisSIBwr4eS/+oyCE9/yvozjjPvU8jadJnTpBmiGo8d611kSYxkjI5T2T1qpNmZvhnLO
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:45:16.5727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 244273cd-9da7-4496-a46d-08dc5fe01278
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7377

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
index 2de3006fec65..2e0e825b6436 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3272,6 +3272,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3967,6 +3968,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
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


