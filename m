Return-Path: <kvm+bounces-69511-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8OfxNakAe2nKAQIAu9opvQ
	(envelope-from <kvm+bounces-69511-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:39:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C460AC477
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D700B301F160
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 982963793BA;
	Thu, 29 Jan 2026 06:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xHGUFHRB"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010032.outbound.protection.outlook.com [52.101.46.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970E8371059;
	Thu, 29 Jan 2026 06:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769668772; cv=fail; b=G/7XOUPCeETMspd6xacsOKMrCyPSWD1VVRschpB4jUjz+utL5YJJztfgMcRecIPM1OI7mJzgfJUnr/XPo1z0oXxKsSbfG3KjsiQkRk3Pswbv1OV9IZHu0m9bNMgplwRwbqik7HxNHq5PSVRHJy201dkecFllQZmvEyrDt2v1z/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769668772; c=relaxed/simple;
	bh=9uZdKg9RoB70fjG6xoKqdC+adYyGgTUCTyXgI1EdwJ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SNOJTsvrp5DZ1Oz5RyHup+t1Rwj596ZaAVNb1WSdMZ3OiD5t+Bzk7+rfMJmNyNmp1VVPsQy6ozt33+FP26hocxjcrq8LhA+MNVpWGg58IaMIMktxnmWIeMNnmvK9EjSFdZQbgvAtxvIOhJrF0kWmh7AUYUq0T8CCmJlub7lZTIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xHGUFHRB; arc=fail smtp.client-ip=52.101.46.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ATCnBb9pHq0oPrpLpV0A5+NAr0KYN70cEjaaLMnEefAItUmbggdMYJR3unojbopCV3D/dZhtrJRVKxwmLFZBpqdgY8KwdgWgbgwztoQygM/JppxUc66a87OVU7rFm3njIpqPQK9ps7QIg+Bk/y6ECFDBqqlecTnJukivXHS3Oeo1l9uN1/kR26j+FZWJcfj8ItgEyMCJepLinUzJ64s9IoIuwep+01qK/lA7pWWPc72hEq9StJOiuy9eAtb8TWMr0wDCjw30NVIbpeJ6dzdIJm0vqdtEhcMRSrXigK3Ew+XgsvcPbpv8LLCxYqtRWZDLil1B/uE9E+Xe29RfB3kCHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQ71td7i0raJZi8jVwoUHLNbNz68xc/XoatlrpeFngU=;
 b=JGsaIaOKwg7CtXlDT4Tg0x/QrPRyycoFdJrr16MShSVcFeqxyRQ9K0BrC4/PiPyypToBpQGj4Q499XD54Vr2rofNAIezLUk9w4YlipsyEf/ckuWVu1iNmhY8+loDBqkSH3imEs3hMsmb6sN4yz0N2CORsnKHGTUHBTPHEgy8d4BsYJOuBBctzPahJCAHr2F/NUkmslE295nQ72TFMyWtGTeCgUDEmQiPALVJH7kJ0F1QFjq1f6rJVecLoVgR/KabynPxsEIs69d8LombHsmohYAG2goEZTHiqSVbvE8cr35eFz41QXyH5QEr6/w/NeRh1Hwkl02TqZgIE3KrDJuIrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQ71td7i0raJZi8jVwoUHLNbNz68xc/XoatlrpeFngU=;
 b=xHGUFHRBiopa5TiFbrPOILu+5FVWP0muBhaK+7NlfsEjvZgPYJ7RxtzRHSMVb2kW8djNO0pOoSeNbkLZQ5Jhw9c2UcpjIWmx8XqEOiw3fCtVxcMSpsrAOnywUF+VSplv9DjG82VHGrlBvduUu9zEGUwwPp4en/iCXA5+Wx0cTm8=
Received: from BL6PEPF00016415.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:d) by DM4PR12MB7549.namprd12.prod.outlook.com
 (2603:10b6:8:10f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 06:39:27 +0000
Received: from BN2PEPF00004FBB.namprd04.prod.outlook.com
 (2a01:111:f403:c803::7) by BL6PEPF00016415.outlook.office365.com
 (2603:1036:903:4::a) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Thu,
 29 Jan 2026 06:39:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBB.mail.protection.outlook.com (10.167.243.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 06:39:27 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 00:39:23 -0600
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>
Subject: [PATCH 5/7] KVM: SVM: Support FRED nested exception injection
Date: Thu, 29 Jan 2026 06:36:51 +0000
Message-ID: <20260129063653.3553076-6-shivansh.dhiman@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBB:EE_|DM4PR12MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: 48bf01c2-ed49-4d8c-bb00-08de5f012649
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FbQTYwYJhJAVjG6I80ri4GSU4ihYgdzhZtl6BIKNRQ/Lz3PbqM0/goL4RYU/?=
 =?us-ascii?Q?0lwiRMDUAgJbi+79Re4QfFZbeOAX02DBNqwhn3pV8TPtQJax2r0BKTzRq9TM?=
 =?us-ascii?Q?uKveJP9gDyUnjnUu2V7zJAvvEgD9qAU2k725ZAKzuYHwN/Lg/YTpE6/wxaZd?=
 =?us-ascii?Q?9PXmZYWDP5RmoHelLMm1DNXseUphB5AbWyTzVBtQxaP1nBY1y6h23ZVqTvIs?=
 =?us-ascii?Q?qhym/IEls+futcNrlhXEI9Yz7sOBp+PgMkhvkTUMqOFqeW95b2Avher14dt+?=
 =?us-ascii?Q?n9bNIOp3LNKtGLSLxJ09j/ucvlm0du06GxWQxz9YV41fVnZRduSRDAxH4nMs?=
 =?us-ascii?Q?y+3NwBMl+voWSdMTPkZ9/XLYaoZKUQVoTfhCA/ntWT91mn6rn2Bmc/VUFswo?=
 =?us-ascii?Q?E0QOSi+bO9X+iGLy2Dxa97j8JI5SQq9+DpE+Wse3TCg0h6YLIIfZ/t+lPmUP?=
 =?us-ascii?Q?p0c3LboHFamemZqL7oUlGePsz/BVxv+BZUpQW6MmEFTZIWUiJXkYHTmnSm3c?=
 =?us-ascii?Q?e9uScy9IkVAO8CPQ42CEqNlXDjvlPgOXsa1In96/KJug0E56YHUQy3nPiJfz?=
 =?us-ascii?Q?Vs2ry/GO9VOirVuuelwU5Y+y9kMIKeQESXAwF3RGD2ssnOWA1rIyBWhJZoi5?=
 =?us-ascii?Q?11UfhFYVkFg1ByeGwDaFQ4gs8fOy9y+aCdH9G7/waA9ZlsifFU36EHTqRP5h?=
 =?us-ascii?Q?fIJ7u/kndb1X47AQB3+Tu0+8Z01YByLF4ASwGnLaeJqVWPXPwdeVpNuPXkwV?=
 =?us-ascii?Q?mU0G0PPB/mMF3SFjBgRZFnFCxjTnLVf4x7Bhml/4XCYBCz3RZFHv8PgxHemG?=
 =?us-ascii?Q?GIPGYO46CDm4viSjsGZSLMAv/K970qIswYqxxxz1sWW3kR+W9EOlEc2aObAD?=
 =?us-ascii?Q?yZrrEm4PWoKjTo2a9pFTCiMYMDY/X4KOJkDjbuDHxRkFYYcPMgfWVGOkCg21?=
 =?us-ascii?Q?hE1sII3lizxUJOytuiIJL4sM0zqG3t2F0iVDJfJgzKIBKAcX/JPzJZ4XNyJ4?=
 =?us-ascii?Q?516PILHUL5qJyWOxNivIgx5A5OFXcdM5WwrUU4BvDIFLbZOcZKbLGhG1Lq0u?=
 =?us-ascii?Q?az447vz44JevdDg5OkAsimFunD/+A6WZd4mcO4vxZngkjE9fyRVCKOUc+I92?=
 =?us-ascii?Q?Be/4S7fDZwXLeBPuye9oCsEWG5n1yS6Jr3QcdyCpyr23K+t444jxcUVRtoKN?=
 =?us-ascii?Q?afjVn1mtJOjtCyaL6uoxZstExtyVPOCGNWAsNCmAbOfUSFUjtRHNAalsEWTC?=
 =?us-ascii?Q?Ps73fT+28K4KIRC1MbA6v0YXsuuFitTQRzza7MMex1GqdrnpJ8lWTKDN0ihL?=
 =?us-ascii?Q?le34zkk+CPTmBKl4gasLJOKY0XBIATj8uN+rJ4eVnRl/2foCBK48wvvKOau9?=
 =?us-ascii?Q?Qo545z5o9GDeRL8jB5epsQJmeMl2zJdKtjLktkTAxp5j1kDu2OdeysXadXAu?=
 =?us-ascii?Q?MHGnizKcX3tbKBD2izUgTxdqKzLoy+xvHcatEbqBKKtVapIuvfZ9dDg9nlSG?=
 =?us-ascii?Q?Nvs6JgNkJ9XZ2dqCtq7KxSSyuGC193eXUVHpWDDtfBskSLBBwlkFKn3yTRW2?=
 =?us-ascii?Q?U+MbpMoGIyjpIpHCLwEsuner2dtPOh5yYn+ecpy9oDxwDKyt5uZklVxfBmRG?=
 =?us-ascii?Q?rZ3AtPvJVN/9dxRQtGdX+BgLiJa7Ori73iV7YERbjyGBV5QqZWsPimW0Z2R/?=
 =?us-ascii?Q?L/bGQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 06:39:27.4303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48bf01c2-ed49-4d8c-bb00-08de5f012649
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7549
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69511-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 3C460AC477
X-Rspamd-Action: no action

From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>

Set the SVM nested exception bit in EVENT_INJECTION_CTL when
injecting a nested exception using FRED event delivery to
ensure:
  1) A nested exception is injected on a correct stack level.
  2) The nested bit defined in FRED stack frame is set.

The event stack level used by FRED event delivery depends on whether
the event was a nested exception encountered during delivery of an
earlier event, because a nested exception is "regarded" as happening
on ring 0.  E.g., when #PF is configured to use stack level 1 in
IA32_FRED_STKLVLS MSR:
  - nested #PF will be delivered on the stack pointed by FRED_RSP1
    MSR when encountered in ring 3 and ring 0.
  - normal #PF will be delivered on the stack pointed by FRED_RSP0
    MSR when encountered in ring 3.

The SVM nested-exception support ensures a correct event stack level is
chosen when a VM entry injects a nested exception.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h | 1 +
 arch/x86/kvm/svm/svm.c     | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index c2f3e03e1f4b..f4a9781c1d6c 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -657,6 +657,7 @@ static inline void __unused_size_checks(void)
 
 #define SVM_EVTINJ_VALID (1 << 31)
 #define SVM_EVTINJ_VALID_ERR (1 << 11)
+#define SVM_EVTINJ_NESTED_EXCEPTION    (1 << 13)
 
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
 #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 693b46d715b4..374589784206 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -363,6 +363,7 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool nested = is_fred_enabled(vcpu) && ex->nested;
 
 	kvm_deliver_exception_payload(vcpu, ex);
 
@@ -373,6 +374,7 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.event_inj = ex->vector
 		| SVM_EVTINJ_VALID
 		| (ex->has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
+		| (nested ? SVM_EVTINJ_NESTED_EXCEPTION : 0)
 		| SVM_EVTINJ_TYPE_EXEPT;
 
 	if (is_fred_enabled(vcpu))
@@ -4137,7 +4139,8 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu, bool reinject_on_vmex
 
 		kvm_requeue_exception(vcpu, vector,
 				      exitintinfo & SVM_EXITINTINFO_VALID_ERR,
-				      error_code, false, event_data);
+				      error_code, exitintinfo & SVM_EVTINJ_NESTED_EXCEPTION,
+				      event_data);
 		break;
 	}
 	case SVM_EXITINTINFO_TYPE_INTR:
-- 
2.43.0


