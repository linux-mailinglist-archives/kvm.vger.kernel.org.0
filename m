Return-Path: <kvm+bounces-70152-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8CHYFVr5gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70152-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B403CE2CBB
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D98E7306451C
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524C1385514;
	Wed,  4 Feb 2026 07:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kUTOrEEP"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012003.outbound.protection.outlook.com [52.101.48.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EB735D5F6
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191143; cv=fail; b=q7PYez3B5tbuv018SRTDUK4Cr24ncApcIQjZGDpIcxnmVKohunpDmx5fbEGFTtScOPAzEYPfbD57lB2Rn0H05wZXueVX3w1zy6GumA5gnup4/KJeyvIIiIez0aXotFODi+/gndqN9DDcTa+ShubDQIR63SCut1RfQFB+D9vZbBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191143; c=relaxed/simple;
	bh=cjxyadLTbIirtURcKnaWsZx5LP5+zohEVrKHCDyyy8Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lWh/obUHN6xLer1pLM7XDNhe2WtTvUz2Y0AZGi7SofXctszgKWArRVNTcFywTHpgQJxf0wYImhZ6/vk7SiZEPHFJIHBcyCbwGqRWMd3yl+FB+Y6K6n5QtNUFjbTiQcXexI/2qUjbmHu8ard368hORFtnAfa6G5QkTIvD3/DFA40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kUTOrEEP; arc=fail smtp.client-ip=52.101.48.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Km6T+1Ws6/beHGjjcM8EYubkxne9mCHz0pIfhJdmN1npya1LdlrKyG6Y4naX6hW8IYL1j0jZWIY8wObed6P92zsxeh/VYABWJ90YVQd7vj9aN8R2Up6inOvT4KzFvWt/sClEymie79QtdbDkghmqWhTmkPo2bUSd/4HcEnKEMS+DMkoLeQkevOdX69FSNKtcYbMXb0rEN+mBzTZhLU0QIguF/O5upp9f3C8G7pzwI1kPd/DgxR3A1DMjG8i+0mY862QuXUrK3c/c3PCwTjAg3Qm5YOcgdSz//Dhw6/x0dZMIsqaQePjqLKnzhVnlLqjiJ09euPmyEGq6OMelpEFfyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m47O2X738LxnPfPwY8umWqXvwZPrIsYFsFg8I5yFic0=;
 b=mutwoA5+3BiYDt1z61nmFHev9ATTDXq2aDqMZgpUb1M7yJ7Pwul76WlKrFxwM18d5E1a/qvRlu7IW9DTk8XRskqnlJD8VgcFsdmm80UUMdpyBjI3V+SJ7UGjtHPH078atP2lWmO17ViqydMiIkKEdctHyKvvSM7SR7veOI3iY10jk93s8bHBxE2dmIL7tugiCVrYQryzBCvwxQDH8UjGEngOZJ7X966etf7HYCGXHYKaLgMyZbfWgy5fL9j0HqfRxaUFKkDtzN+DMnYylKKEnW2G14d6TstySQU1LObEkKrIh8Cr3nxAtmZnx7tFuNA6sFFuf3bVllNll9wclSar9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m47O2X738LxnPfPwY8umWqXvwZPrIsYFsFg8I5yFic0=;
 b=kUTOrEEPbKQS8ZxAO8otq+G3xfIjazm1HRRMbl6tROXz13Ex9g7jFeiQVBa2nwkMOzonVIhIluaCBkmz/azWjLit2yyVx9vzto0nCvfl04fQpYELXZv+roAw+pMCkU+GnsUmE7x9+itQcqKIK8TEgvCjvqfzJRSm3LTV1zW4Ygw=
Received: from SA1PR02CA0022.namprd02.prod.outlook.com (2603:10b6:806:2cf::29)
 by DS7PR12MB6144.namprd12.prod.outlook.com (2603:10b6:8:98::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.12; Wed, 4 Feb 2026 07:45:37 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:2cf:cafe::bf) by SA1PR02CA0022.outlook.office365.com
 (2603:10b6:806:2cf::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.16 via Frontend Transport; Wed,
 4 Feb 2026 07:45:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:37 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:33 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 7/9] KVM: x86: Emulate Extended LVT registers for AMD guests
Date: Wed, 4 Feb 2026 07:44:50 +0000
Message-ID: <20260204074452.55453-8-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260204074452.55453-1-manali.shukla@amd.com>
References: <20260204074452.55453-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|DS7PR12MB6144:EE_
X-MS-Office365-Filtering-Correlation-Id: ce8cfcc8-91e1-46dd-7a1e-08de63c162db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c3uBDejVokPm3wx+qmv6FIOIJA+h6f64oe5OQNpQ/zWtzo5DzYIIk0uCV8DN?=
 =?us-ascii?Q?vrOxWCjEtZQElvpKTHIQqQm4K6j2BIWTyRrQAA9lVO4KGQ55buGnamWpcVmM?=
 =?us-ascii?Q?8XSDfZqdLTHisie4Ps4Dlx2UkWkuYn0BmWorks438ngSJ/NNPLKIj6rHTtQs?=
 =?us-ascii?Q?minjwlL8xaal2YFnKK+tFZ1gMIzmFASDc9HtQQaew4liGHU1nLLwSfxOvful?=
 =?us-ascii?Q?XpXer2ORBlf8NIjc1T3vj0mOlMGW2TYBKU8UpiZ1lWkId19FQXnb+qtXIZU7?=
 =?us-ascii?Q?PFG9H2YWypsSx1syOHdpYa9qY95IaKb/5NJ/D+JCjobo5N4VhKIAc+4TWe+8?=
 =?us-ascii?Q?+9Y+bbYdCnQCWgJ5KIaO8d0zlt4BtFX9SGQZ81MuOVoj7Vzx3l137AApt4zR?=
 =?us-ascii?Q?1rJdFLMnLXLkBXx+oZmzwG1a4MEB7YJhhnqJuEy+QpnvqxJa9p4nqdQgzh5B?=
 =?us-ascii?Q?vNeq6M6yZVBN9zutfbh9esvBw5WP/bIJgPmcMOB4cB9a2ZAj8LY4GcZUNHfD?=
 =?us-ascii?Q?IlVB9qVcUBHBvpSal7BMKbYv8fVzhOeOAIHXpyXn+lXpLfUylTNeq+Wp0mfB?=
 =?us-ascii?Q?OaGLGUb6hnJAv1FAEUTAyDbAoUp0ZD+1Jg1Imq5x84GQJ4rQjD5d10pyOsAs?=
 =?us-ascii?Q?buqCtjNAUQ+eZ6VZ2WLAGj5GzhE6SJ1h+04Pjki2yqocfDOPJIxQRxlByM8Y?=
 =?us-ascii?Q?7bXnGADDo582lNpEB7FcQs5s96UEIzre5Lm+8PEAx89d3dK4TTEjZn9eFSze?=
 =?us-ascii?Q?J61I/pVNN3UCM7EvKhe9E97JO/xz+fTU4P6LK1i7hmfweN1QOEYBk4w4s4eG?=
 =?us-ascii?Q?HvJgdg/fEMd1u1J29Ob1mruXNk4PgWZOShSfy8lsiKhMOmYqdAPCYh07Xo8T?=
 =?us-ascii?Q?IIjFEZfSKhaI9hreWbGqpF5INixnGrIFjFEpHRZdiKYwxc4Nnc+orIjeQovk?=
 =?us-ascii?Q?IXz4m6voC4Fx+Z4/8YNBbBo0sHhLomICcUJ4L+cKgvKGN7OelKdct978X7GO?=
 =?us-ascii?Q?aX3fgXwEM+3s5HgSaqBmivSOoSqE9Vbs6tyAGuQVk5M+ExxtBJBSjFT8D+6Z?=
 =?us-ascii?Q?UZPk9cdMBe0Nr3ALFcpHWiLOucME2ydenLbXMllBL3lA7v4VZChFOmKMIMCe?=
 =?us-ascii?Q?gEZY/EqOEs7s9L9TCTzpxxNB/ofJmPewt2HfKRoaUReS0xbROxlvuPN/LX0+?=
 =?us-ascii?Q?fKGZUu1DRYOovAshySQWJX7C1x5zNeUp2xK4CEMXjBdatUcs5LDad9ocvL42?=
 =?us-ascii?Q?2gVCIg5ghFWBnknjHXzPCrdBM/LCqXllz1ZY8WbWeGjQ32ybOEfVPyp8u4pP?=
 =?us-ascii?Q?OAjW1Ti7L58nipMstTrr5RQF/SXWfxJdwsDr3pCC9nSIwnBAO8mEfYZmp2TG?=
 =?us-ascii?Q?ah9o9ni9S/j2iuJiyHISLpN+QPAfdO5fu/YgWZ6gKSmXELpdLEYmcpIHAM8f?=
 =?us-ascii?Q?E+qrAAkhc2O84R542vRs7TaeQ3a8BWrMEbFFgiVs+ZEu3/4peClsjdxSgI0S?=
 =?us-ascii?Q?VuKc81tMwgunQWwJvb4fTGbUEj+Q4qKuttMEd/QNYWtJOQ4m2r19k1gUGr49?=
 =?us-ascii?Q?DdSu5lVoin/7EEyRjNs0vGVJdY0KOhxOUp4sPIJr8EBZhdWoSWMI+GMsjg0i?=
 =?us-ascii?Q?OJtLDjZFIdN1Q+OIulHpTHdKLOBseKKOLMME22DWcJH7V+JdcHE38wkz5h9R?=
 =?us-ascii?Q?pdTSJg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	algVxMSQMXUy3DMWtTK3SVAJAUbLp2Cd/lGq+DFVHoh2d3EWf8Vla1GDCLbp+/vtRR+Y9Pmt1/WlkyEYgc6XKHLFQ4J4CcUZpKx55xiFjWpS4UbOt53wsuspLtg7wajbXvEcwjOwhrfid3AcqXd3q0x5I7qWOwm+uU+neEjNtOsfFJ/J6dq9hH86zvOp6/qJaBL37Whk7L4Yate9q9+RAgEu4lkwOS76+g8wtlTwsEcQB5dL5RrnqHe7WlactjwxA0oWwHeKskjPeV8+/TICnyIgJvXQp8UxNz3DSTOj/I1y8EtiejRKmuGfpcfM0FYp48udX4xbul3HCZR0kEl5Ks0VIfPf6teXUU/EuuWqQ9fjLG7MPV8pyu2LLfsOZfysYVJpWeRKsFUHGmWDAIISoW241LH53E2tCEJgrLGnQjn4HFsaVZWzwIaDxEEsaje8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:37.0847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8cfcc8-91e1-46dd-7a1e-08de63c162db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6144
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
	TAGGED_FROM(0.00)[bounces-70152-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: B403CE2CBB
X-Rspamd-Action: no action

From: Santosh Shukla <santosh.shukla@amd.com>

Emulate reads and writes to AMD Extended APIC registers: APIC_EFEAT
(0x400), APIC_ECTRL (0x410), and APIC_EILVTn (0x500-0x530).  Without
emulation, Instruction Based Sampling (IBS) driver fails to initialize
when it tries to access APIC_EILVT(0).

Extend the LAPIC register read and write paths to allow accesses beyond
the standard 0x3f0 offset when the guest has X86_FEATURE_EXTAPIC.  The
valid range is determined by kvm->arch.nr_extlvt, which userspace
configures via KVM_CAP_LAPIC2.

Initialize extended APIC registers in both kvm_vcpu_after_set_cpuid()
and kvm_lapic_reset().  The initial kvm_lapic_reset() occurs before
userspace configures CPUID via KVM_SET_CPUID2, so extended LVT registers
can't be initialized until X86_FEATURE_EXTAPIC is set.  Handle the
initial setup in kvm_vcpu_after_set_cpuid() and subsequent resets in
kvm_lapic_reset().

Initialize APIC_EFEAT to report the number of extended LVTs (read-only).
Initialize APIC_ECTRL to zero (read-write).  Initialize APIC_EILVTn
entries to masked (bit 16 set), matching hardware reset behavior.

Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
https://bugzilla.kernel.org/attachment.cgi?id=306250 for more details
on Extended LVT.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Co-developed-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/apicdef.h | 18 ++++++++++++++
 arch/x86/kvm/cpuid.c           | 10 +++++++-
 arch/x86/kvm/lapic.c           | 43 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h           |  8 +++++++
 4 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index be39a543fbe5..5c5e9db1e27d 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -148,6 +148,24 @@
 #define		APIC_EILVT_MSG_EXT	0x7
 #define		APIC_EILVT_MASKED	(1 << 16)
 
+/*
+ * Initialize extended APIC registers to the default value when guest
+ * is started and EXTAPIC feature is enabled on the guest.
+ *
+ * APIC_EFEAT is a read only Extended APIC feature register, whose bits
+ * 0, 1, and 2 represent features that are not currently emulated by KVM.
+ * Therefore, these bits must be cleared during initialization. As a result, the
+ * default value used for APIC_EFEAT in KVM is set based on number of extended
+ * LVT registers supported by the guest.
+ *
+ * APIC_ECTRL is a read-write Extended APIC control register, whose
+ * default value is 0x0.
+ */
+
+#define		APIC_EFEAT_MASK		0x00FF0000
+#define		APIC_EFEAT_DEFAULT(n)	((n << 16) & APIC_EFEAT_MASK)
+#define		APIC_ECTRL_DEFAULT	0x0
+
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR		0x800
 #define APIC_X2APIC_ID_MSR	0x802
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index baa1cf473d45..4574149d137b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -435,6 +435,14 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
+	/*
+	 * Initialize extended APIC registers after CPUID is set.  The initial
+	 * reset occurs before userspace configures CPUID, so extended LVT
+	 * registers (which require X86_FEATURE_EXTAPIC) can't be initialized
+	 * until after KVM_SET_CPUID2.
+	 */
+	kvm_apic_init_extlvt_regs(vcpu);
+
 	vcpu->arch.guest_supported_xcr0 = cpuid_get_supported_xcr0(vcpu);
 	vcpu->arch.guest_supported_xss = cpuid_get_supported_xss(vcpu);
 
@@ -1076,7 +1084,7 @@ void kvm_set_cpu_caps(void)
 		F(LAHF_LM),
 		F(CMP_LEGACY),
 		VENDOR_F(SVM),
-		/* ExtApicSpace */
+		F(EXTAPIC),
 		F(CR8_LEGACY),
 		F(ABM),
 		F(SSE4A),
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4ed6abb414e4..a04c808289c3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1687,6 +1687,7 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 	test_bit(APIC_REG_TO_BIT(reg), (unsigned long *)(mask))
 
 #define APIC_LAST_REG_OFFSET		0x3f0
+#define APIC_EXT_LAST_REG_OFFSET(n)	APIC_EILVTn((n))
 
 void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 mask[2])
 {
@@ -1722,6 +1723,12 @@ void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 mask[2])
 		APIC_REG_MASK(APIC_DFR, mask);
 		APIC_REG_MASK(APIC_ICR2, mask);
 	}
+
+	if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
+		APIC_REG_MASK(APIC_EFEAT, mask);
+		APIC_REG_MASK(APIC_ECTRL, mask);
+		APIC_REGS_MASK(APIC_EILVTn(0), apic->vcpu->kvm->arch.nr_extlvt, mask);
+	}
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lapic_readable_reg_mask);
 
@@ -1739,6 +1746,13 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	 */
 	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
 
+	if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
+		u8 nr_extlvt = apic->vcpu->kvm->arch.nr_extlvt;
+
+		if (nr_extlvt > 0)
+			last_reg = APIC_EXT_LAST_REG_OFFSET(nr_extlvt - 1);
+	}
+
 	if (alignment + len > 4)
 		return 1;
 
@@ -2500,7 +2514,15 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		else
 			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
 		break;
+
 	default:
+		if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
+			if (reg == APIC_ECTRL ||
+			    kvm_is_extlvt_offset(reg, apic->vcpu->kvm->arch.nr_extlvt)) {
+				kvm_lapic_set_reg(apic, reg, val);
+				break;
+			}
+		}
 		ret = 1;
 		break;
 	}
@@ -2866,6 +2888,26 @@ void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu)
 	kvm_vcpu_srcu_read_lock(vcpu);
 }
 
+/*
+ * Initialize extended APIC registers to the default value when guest is
+ * started. The extended APIC registers should only be initialized when the
+ * EXTAPIC feature is enabled on the guest.
+ */
+void kvm_apic_init_extlvt_regs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	int i, max_extlvt;
+
+	max_extlvt = vcpu->kvm->arch.nr_extlvt;
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_EXTAPIC)) {
+		kvm_lapic_set_reg(apic, APIC_EFEAT, APIC_EFEAT_DEFAULT(max_extlvt));
+		kvm_lapic_set_reg(apic, APIC_ECTRL, APIC_ECTRL_DEFAULT);
+		for (i = 0; i < max_extlvt; i++)
+			kvm_lapic_set_reg(apic, APIC_EILVTn(i), APIC_EILVT_MASKED);
+	}
+}
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -2927,6 +2969,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
+	kvm_apic_init_extlvt_regs(vcpu);
 	kvm_apic_update_apicv(vcpu);
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index c6ac40c76f62..6716828b65e5 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -98,6 +98,7 @@ void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector);
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
+void kvm_apic_init_extlvt_regs(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
@@ -266,4 +267,11 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }
 
+static inline bool kvm_is_extlvt_offset(u32 offset, u8 nr_extlvt)
+{
+	if ((offset < APIC_EILVTn(0)) || (offset & 0xf))
+		return false;
+	return ((offset - APIC_EILVTn(0)) >> 4) < nr_extlvt;
+}
+
 #endif
-- 
2.43.0


