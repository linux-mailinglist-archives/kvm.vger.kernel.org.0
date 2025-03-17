Return-Path: <kvm+bounces-41283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74281A65A9C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:25:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFFEA3AEABD
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE481A23B5;
	Mon, 17 Mar 2025 17:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M3Y7p70/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC1D17D355;
	Mon, 17 Mar 2025 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742232036; cv=fail; b=B/nUaOFsQkhvqL8nvlE76UiS0bVKio5eRu/gZRW9myk0EZ4UdbZ7ZWheLIBJ419dLJjsBfHPcdsJddGwgrcGeOHY2tYyOORs60+xkDAFH4vQPYrx7A7KuvLjB1CNpPFEedMAzvvTS1bJj7qroRX1U1PmpLKS2AHKxKd+zBG17q8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742232036; c=relaxed/simple;
	bh=MrA797OUZjv3C2t3Pw+NjfHck/zXJeZS2SpVR/MgZLY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=vBveB/JuGsIJCp2AhVZ0Pc82xpPxoV/c++JSGum3FknHD2bZ3ow3/kZ+e7sf8PuuD0K4KBL1h2QxtXOqr6ToDo6XwAruYKWzM6hz/mGakOjZ1ipnuRa83VqgDCZX47BnAAbXfu8uoGx8hY8BtDG+qS5fcW4pmXKSGc+M1KnCQ7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M3Y7p70/; arc=fail smtp.client-ip=40.107.243.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nVG1OoUsr2ExdsgBZeG36p7xl2V1RHycr4zu8HrSyzzyCYwYbOVfo9sQORttWCRyLmvh0mn7xlnhGNjdcZuzWuvqzlGWTRSyZMLvzZgZnVqttnFcO0irj8jALIoknkN75u1kyeIb5t574DY2urIT4busRvx96BKJfzsmv4oIfP5SwOxOJXz3neIGcwm7Cdd+QYLZr5qhx8fzv9qc6b1kQlzJtag/vnKAvSdsbqjnl3leN+1iT6d0zlesDnDMQ5VFAduMH2Dq9xaERvii0+8AghFoL/VzWeWnr8qTq0zxhb9bEfqw5D+SSNhuoqUwIvNAGZ4GVHciM+kmujulZr7lag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WoYq0dumOOiuZ2TiiQ7RQyEl9gLE5ha6rA9qG9gFlg=;
 b=EiWoKwsrX+o9zC3+8/6aeuygHUqJ2mpA+HsY4MKNc5DUhrpjOu8Suc8Lc8r47Yauavy+bI5fW+w+nMwTOX0li5ubk9yzZucLEmI7fsFlMy++BErjVVwmIue02d/kMvZXJ3igG00EGUczOVZ0of8EnxnOTqb6lO191Cxbe+eRrm2v9DQi9f4NbzR2WeNxBtUm7NcCnuaY01aoeF0vYr4ooILG0nQj5haAB3VxEmpy4aW71bjZK7zQOaqAnfO1J+WKsGRbUyc4p4S0IyyPE299uyBVt0qnf8FCE78LbPBuvoz14nE1up3/GhrRc4QeNORYV50Rtrs1W2jILRsaAPSaqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WoYq0dumOOiuZ2TiiQ7RQyEl9gLE5ha6rA9qG9gFlg=;
 b=M3Y7p70/rL9wioqWv78jkz7sjqKuHBX2p5+FCDpYuZ37RHtHRolsGNsoaF9fXZOXN3m2pme64ssvT4H9RspnQ8hzqPwp+h0YQPg1AI36nuVtfN4C2bEtZjM8xV+6QTvfjp8Pp8A9WUdgvtkitttOCpLp4SOIqQIPyCo9CCvZiPs=
Received: from BYAPR03CA0027.namprd03.prod.outlook.com (2603:10b6:a02:a8::40)
 by CH2PR12MB4037.namprd12.prod.outlook.com (2603:10b6:610:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 17:20:29 +0000
Received: from CO1PEPF000066EC.namprd05.prod.outlook.com
 (2603:10b6:a02:a8:cafe::42) by BYAPR03CA0027.outlook.office365.com
 (2603:10b6:a02:a8::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Mon,
 17 Mar 2025 17:20:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000066EC.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 17 Mar 2025 17:20:29 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Mar
 2025 12:20:27 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
Date: Mon, 17 Mar 2025 12:20:14 -0500
Message-ID: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EC:EE_|CH2PR12MB4037:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a9a8670-8dc3-4b90-ca54-08dd65780421
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TasFgzvcK84cOTNlk9y6ee/aCSbmZ/5eFJVT2gosDknYcw/GPRJw4rfFEQq2?=
 =?us-ascii?Q?pGrusFzZKscRWDrhejrBpy2M2GGWxHHwv11ln1fsIzIIhMrY/yIzSAB4LhNM?=
 =?us-ascii?Q?MrgB2FhVf/lVS8dUqdgZE4DDbX50rHHOxGkpq5q3Lsc+PDqWWhihkk884ScG?=
 =?us-ascii?Q?ElBOfS76rxPg/RtbfWvIlWlDb38cmx1KydrLddA5FveAyctF5SR9Cscev5oT?=
 =?us-ascii?Q?8khSAKgGdyaeEZZnGGU2U+1gvSsWr29tTkuuhJla5Q0p3CcmKvLZBKSyuzgL?=
 =?us-ascii?Q?EgcEGgDsm0taqHCWPAwggKb1YIBMSU30Wp9X+Nzn0x+yODf/m1btI4mSY6mU?=
 =?us-ascii?Q?HKUe3qYSnSxyWdUJIz04BGWk8hoqPat4BsyoVr4IGcit2vfHMRe8UcY18IAF?=
 =?us-ascii?Q?fnZdQ27uHKN4bSwdCB4uhLkh8DxbVlxH0ASWR96FCYMxP9j4tV9CCoNnA5a8?=
 =?us-ascii?Q?KDBmp4e+HgtAM6OvSYEjvlxiwgJriQ0WY4hp6LdLwst0CLJijLTdWeu7J5xL?=
 =?us-ascii?Q?8vAK7xSk4ImwOkJ6uc7PxEJA2DAJD/QUCOR81SW8k6hUAfu/iSjXZYkIy0ax?=
 =?us-ascii?Q?rfZNnztkW7kahjZIGmyMLM00obAXwiLgf2uzlRfwibdfaFIkCvx+E6hqWF3C?=
 =?us-ascii?Q?nRweIm9icWUIg/+NmqvFfvl+bxIAi0gCzxJfYUhf8kl7y9CS0VFYbZVQZFnf?=
 =?us-ascii?Q?PiUYXYiFtvf+zpodEB0LD60qxNIeD2FQ7t5I5Y9RCkMG0YZpmSL26XpvTpQN?=
 =?us-ascii?Q?Lhulev42hTbMyIs2EJ/ZvDWXW0VYrh1JlE/tfaQRAGylUkJQ1j8cxXj0mtjs?=
 =?us-ascii?Q?wwxdwO1GxcxkB7tLZeYcwDDPVq3v86TnDx91/cPEPnNzMhRS43E82JqKKqFA?=
 =?us-ascii?Q?IarqSKlPeqItC1APW07aZZ09lWxtEpE7wF0BXMGnPXHgSwBfpQVsFw//9xH8?=
 =?us-ascii?Q?T1z+7sbHfEPw3s+mli/OoYvWjHvPeHOHN5Vz1yo0uVle9Y9MXZf6q0PCgDgR?=
 =?us-ascii?Q?ULOd0VXitSGQSpOKvPRrbQTxv9VgbssfAYIBPVR36Qh+nAVVv1+HkIbFitKt?=
 =?us-ascii?Q?0BeKawiVCbHdUlgmmk+iRq003DiIJG3u0GpdJJP+hNvfR5Icrk9fXv+gckAn?=
 =?us-ascii?Q?++TMELzOAIs02W57QZO5CfJfM7QrozNlGe8OSy7ViXSYVBL6b7ZnUwboli/y?=
 =?us-ascii?Q?tpApcEyOfeUSRafZVZvdRsqHjVcmehJiqSrcA5g8BgkyPDHJYWEljV0l3vuc?=
 =?us-ascii?Q?L38VeG29/ziFlTWW3Ntuyl6ZVlOuLxgXAjQYD+WyfnDKQQayyCSpabQQNT4h?=
 =?us-ascii?Q?3ek8kkcSmv1PfEG5zYj65KNJQcTaHBqiL238mbGu+V0qRCO6tdZz+UwEhNfP?=
 =?us-ascii?Q?8QY15pzWcoKTMywJwmSQRJUczv1a8Ke9Z8muyiwq52uTgc3xG5SQBdBfDc05?=
 =?us-ascii?Q?pL5TWZqWsUQ9R2cO4FSHQkxlqeX23q5LJco494iUGoRuWL07QeK7Gw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 17:20:29.4876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9a8670-8dc3-4b90-ca54-08dd65780421
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4037

An AP destroy request for a target vCPU is typically followed by an
RMPADJUST to remove the VMSA attribute from the page currently being
used as the VMSA for the target vCPU. This can result in a vCPU that
is about to VMRUN to exit with #VMEXIT_INVALID.

This usually does not happen as APs are typically sitting in HLT when
being destroyed and therefore the vCPU thread is not running at the time.
However, if HLT is allowed inside the VM, then the vCPU could be about to
VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
guest to crash. An RMPADJUST against an in-use (already running) VMSA
results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
attribute cannot be changed until the VMRUN for target vCPU exits. The
Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
HLT inside the guest.

Use kvm_test_request() to ensure that the target vCPU sees the AP destroy
request before returning to the initiating vCPU.

Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0d898d6b697f..a040f29bb07b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4071,6 +4071,16 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	if (kick) {
 		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
 		kvm_vcpu_kick(target_vcpu);
+
+		if (request == SVM_VMGEXIT_AP_DESTROY) {
+			/*
+			 * A destroy is likely to be followed by an RMPADJUST
+			 * that will remove the VMSA flag, so be sure the vCPU
+			 * got the request in case it is on the way to a VMRUN.
+			 */
+			while (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu))
+				cond_resched();
+		}
 	}
 
 	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);

base-commit: f8d892c137f7448d7b49f5e3ad7aa7b5a48a64ed
-- 
2.46.2


