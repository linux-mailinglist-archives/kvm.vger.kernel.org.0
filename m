Return-Path: <kvm+bounces-69513-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cASgE/MAe2nKAQIAu9opvQ
	(envelope-from <kvm+bounces-69513-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:40:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E1271AC496
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F3E43026AAF
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBF02E6CC0;
	Thu, 29 Jan 2026 06:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iEquznED"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010021.outbound.protection.outlook.com [52.101.56.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9921E1DE9;
	Thu, 29 Jan 2026 06:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769668818; cv=fail; b=cGwtlTOrDUU3bCI9j4Y4BFRqX3d5rL1prgEfX1tTn6n+6nEsdPugP9w8w0AbVaOCCQnncXrg85PccFqOmwfp+zxYh6PPk23Qe7kgnmsWcKDWQXmFno/7NU+Xukyq7Q0PI8jolnvq+ETyUS5+yaafqSUGadv5RPLzxYo7ecLfbG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769668818; c=relaxed/simple;
	bh=JWtE8rVAJ/yhAn7gfw7edbQ9i5Q8Qscb+YELX8m2Uhg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I24dT+2GM0TXQrH48vWSLkRPFIf96PlUJKB9yextriOhNaONJ1ctMfDdF70zZfGy5i/+6PYLxNk3K/G+dV0U2dkqx8OqOBlewmwJO97Go7kM8QwKYktzRjzecFEN/TWcXotaTuzfbudjliD6oRZ99gPbfAgel7h2Zb8vml+unWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iEquznED; arc=fail smtp.client-ip=52.101.56.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N4npbx3kwxLJbWQpGw6ebcQvFAG0vxPgVG+4JBwmgNY4MRwUlYaiuyBBQCpA4jUl2pwZzCC5Yf3NvGDrsiXoVRZTDB8UKetxBL7Byscm8W+eE0wHC5ra7GY3DVbE3QHP4RvxYGfFRYOiLU6eMN5f87Z/rtHKldwXeYa/EyM/axLfwgbT3wa5X+fi2vp4+EM1hg82ioJKtsiNugDbrXbtOKkdbURyu/NZ0XdYwLieXaSyS3cgA8fgtf7VDHVJLHYN+vAox/hhXPTM/ZvN+0elQEgxlHoxJyLf8vRbmr3rECQ2TNEmYBn3c/HpY+Ch7JKW/ttZQqMjbAZzhi6Dq5oZeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXF3UnGMl1T2MmJmgdTGPvw+lvfgzC3NNGw70tpa3tc=;
 b=KHx+82AMm89avWsWWcEku48OUdSViW4DjrbjT5uhBxSJmWtOZbimjl/IRDZYddO3JgdmMrxwUApIBSDTZPe+jCdcShITP56IP+ku9n+khuw938msRuNomzEU4eyUNzdpmIg3sMjiQMMu0xOlHULCtFwoyYghx3Hd0I9KVGswgAuVTpsp3tEEboQkNN7DnxBTia90QmC7gdtwt9aOuANBpXRYZkDpsDHW7h2k1lPJeC4oDJ19uc70AnsZKZvhMOosyERCJU//A3j9st0Rmzg+r/plmhoFgXQcOYwex97XhzJMq76azi+VwHNrP6XubgQausw3KxgvBCUITSJ/GkZqsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXF3UnGMl1T2MmJmgdTGPvw+lvfgzC3NNGw70tpa3tc=;
 b=iEquznEDOfOX10H6gAU48eOp0uxSqtCKGj/cLrZLop26TVIwz6MbcHPocgsieWazM/Plu33+6ohClfoK81CAquAwfvTcBd0ZFzJKl0Bk0cFgT1tgcSja4N+JKJpK169Hem8rXAnLVDhHMFuOS2QJXSt8ijekITPl1ymzqSX5mtY=
Received: from BN9PR03CA0862.namprd03.prod.outlook.com (2603:10b6:408:13d::27)
 by IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 06:40:12 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:13d:cafe::e6) by BN9PR03CA0862.outlook.office365.com
 (2603:10b6:408:13d::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Thu,
 29 Jan 2026 06:40:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 06:40:12 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 00:40:07 -0600
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>
Subject: [PATCH 7/7] KVM: SVM: Enable save/restore of FRED MSRs
Date: Thu, 29 Jan 2026 06:36:53 +0000
Message-ID: <20260129063653.3553076-8-shivansh.dhiman@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|IA1PR12MB6460:EE_
X-MS-Office365-Filtering-Correlation-Id: e8b363a0-202c-48a5-7baf-08de5f01411d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3dfOyibLHPB6zdNpUjUq4DazAM3xRRKsBRFi7vLpajtOMRPN6q4N1MvBr+UN?=
 =?us-ascii?Q?Pha1fuA7gq+9EPfk/xvnjeNWpYNYjSWz3XX8ErEbxGnxFJ3zlQIUpEmVSYHp?=
 =?us-ascii?Q?1oN1H4RQAYP5XJsAaWlpDvBmLU+BrsOxoBplTYfN9Ib1P6NTKkIu7SIo0hLX?=
 =?us-ascii?Q?oKWDhHqywAPjr6N//kwNNmGnucEGOGvQJ8SwL6iUK3yKlyqiTD7RYcOfVPHd?=
 =?us-ascii?Q?YlWTqFYJaRPXUtlZitmQPPoUZYpeTV/Ml7YRYfte0ykvQzv5DQFOIeiQOnX5?=
 =?us-ascii?Q?me/U8XUfdSpmecXvDeyEsGkTlR34K7w3gBy9AwTc9IYKs4j1vHJlABE59Pvr?=
 =?us-ascii?Q?sx5fVKA+a+cFAQRTb8r7gYIaTDxjrkro5G3aoXgwsUYw+J5feRhX4iZ+Cx6/?=
 =?us-ascii?Q?uLCPfkxa9kFIaxJIpz8WANMkMzXfrCbIwuS/P0KYtBHjrJn5kjg9q4mPLsU0?=
 =?us-ascii?Q?25hPL+qVhoBpD3BWxBV8bZlA/7YWjwzBBrF7JuDpTtLu3Jw2Zmmiw6mZ8QEN?=
 =?us-ascii?Q?KTdD/qf+tt2JWY9Q8DSkkg8ja4Hep2zG956FFRec5mL68qgdBGMIZsANi4rQ?=
 =?us-ascii?Q?V44bbeK3+AeYnWlsFFUjMM2EeaLE8/99HM1GYiv5FvycVsNwNpOZLIJzbO6A?=
 =?us-ascii?Q?tMxZAoHT107t+GRFRdhjzIRAhCBKW34dZnq4uIsLB/97tp0ViBUFbLljhRix?=
 =?us-ascii?Q?TD45o8z5j4geDcA53JSKXnpjG2FOiXlDFxfHGs5+C8SV6083TLOmMQ8SIvxS?=
 =?us-ascii?Q?TeE9568JVkUuYmN7Dc2Z+ft0cYCn8NplmAaVq9uiFY/4yu1JGI37HpCADuZf?=
 =?us-ascii?Q?xcPq3hDkD9E8kfbCoAKM876MinC5RmqzXJGfLLRvGD5ud41M5CjCn5ARPzuj?=
 =?us-ascii?Q?9VsidMDAsNVJggijW+pvMcWO7uV5Xgj70QpRpIF8iwTIo9ZFHqWWgn3houLr?=
 =?us-ascii?Q?TxZn3Z/WqlPnWxIARCW6I1apB3JTVlmm/cIGY8I8+CjIcz/UgcHG8pdDSbeA?=
 =?us-ascii?Q?bV2oTHLp92bJXKs3cl5Mn5iocUqSSgoJRUY8TYjGmOJIjPqa0QLCN+TwAEuR?=
 =?us-ascii?Q?CISZsw18yuAsgqN0XQGE8js5OTSdm6Ft5nj7hdT8/76WtG2vkInRRGM+/l1W?=
 =?us-ascii?Q?jvKGfIJJTxNwTmYrSZ91xSjKZDL04x54epSBJA8kvY9gLEuBJwPI49EHWe8f?=
 =?us-ascii?Q?7ohTxgVuxl2LGyuL1pEuCeOrGmUO+CGcKgrYDj2CkBLNsYqpew/zcJyBCcKj?=
 =?us-ascii?Q?fR2l6Xm3x9MXiYs3bK48ircosy/u6eAeZ/p3uqH0XwDjFPaEnpCrrtCWSurs?=
 =?us-ascii?Q?9MxFwOhvoJp/jOiAg0N3s1y6eTbJHx48be+jUB9qDqSnjCV1xCydBbzGuEcj?=
 =?us-ascii?Q?ImEjIxoooP8HCOGyKXAg2sBLUfBcXirVPMpgIkMC0CWCILRPvNiWClujlkE6?=
 =?us-ascii?Q?FrJm/y/rb/i7uByf2GjjQyUQi52Uyln2QEtmhC5gHdKfSKxlywQUM9vOjopV?=
 =?us-ascii?Q?mc/QumjPTi79Uy7G92NuCTwn0zTWja5Rk23iJMg9FJkrtkc+v/OmgMmPnCk0?=
 =?us-ascii?Q?QsI7zyAxFjxvQYTGxIUqx8uLznXV5VqjiYHRYDbYeXLMThTMyW70jBgUHnI5?=
 =?us-ascii?Q?puikghaLwAirfP7tbHL61FWxGAQcb7TiwYxn3mTw1Wlj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 06:40:12.4174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b363a0-202c-48a5-7baf-08de5f01411d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6460
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69513-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E1271AC496
X-Rspamd-Action: no action

Set the FRED_VIRT_ENABLE bit (bit 4) in the VIRT_EXT field of VMCB to enable
FRED Virtualization for the guest. This enables automatic save/restore of
FRED MSRs. Also toggle this bit when setting CPUIDs, to support booting of
secure guests.

Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 arch/x86/kvm/svm/svm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 954df4eae90e..24579c149937 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1144,6 +1144,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 	save->fred_ssp3 = 0;
 	save->fred_config = 0;
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+		svm->vmcb->control.virt_ext |= FRED_VIRT_ENABLE_MASK;
+
 	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
@@ -4529,6 +4532,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (guest_cpuid_is_intel_compatible(vcpu))
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+		svm->vmcb->control.virt_ext |= FRED_VIRT_ENABLE_MASK;
+
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
 }
-- 
2.43.0


