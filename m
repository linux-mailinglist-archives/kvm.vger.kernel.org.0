Return-Path: <kvm+bounces-41555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 620D4A6A720
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:28:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE86A16F2BC
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12ABA222578;
	Thu, 20 Mar 2025 13:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wfQlKKq5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E40221549;
	Thu, 20 Mar 2025 13:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477255; cv=fail; b=qBTgAn7f+uyaGMRTt6HOoSd2xTlXfzod3c38TwXOs6KLf/aZrEsvj/zYOxEBu6yeFNhG+G2doFPR8mfSL8J6u/aEnKGzBkrRVCwvRDmfy2fOtn/sykYmXBq9uLhf+oeyilDByTN6jy4GX7ixIxi2jKiXZIBMd7X/Njty1p00HU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477255; c=relaxed/simple;
	bh=GLkrgwiP/TdjNAXR5YA0FRzW2yLxn9jRXRKKzXyomE4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9ij19xFcFy5ZGje8yG6osknMW3lMWiZGDnpJwdOM3mQ4MXLq/4yKjidVE82zfcqP86IAyyQs+YegUS4Z49+nEUOB6oGg+UqE9ESwCVtqlBW1J75d74UmbFVaxDZpSUkbz5NTpbW5NELF4lk02ndfL1tDdOYNmngO47BUrS+JBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wfQlKKq5; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UjYiER+WQDKXzUMZJm6m50AH4L4jrbyyeACOOJdjVpF1noeN/Saoc2wAlgXB8jofh/2Nxw2MGoh35e9ZHVmd/q88UlI0lQwWw6+sUSLjwn01tO+wtYDWdnto68Ddfc+5xL5nCJb7ROWHc1Wl571auy77MdH+UH5qmBlfWbLXMXbBf2ibR4Jl6XaFzuXlKgWf4d5snkv+HzGfBzNvTx/AoRDoNA5RXLLdRIALdJY0AIfdOHIWe4Sooa70fKlAd5yLWaaxuFpxjXnRj8GWxPBteVsmI8xyZNRYgdTM8Qk+iVLIEM6hzCQ1gZR0f2N7qn/ojsKwIcce9bpRqUjj3fRdig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpjcUe5NBYSLvKKrzgFlnlZ2dyLo6Yoi3l0iEmCBpXY=;
 b=UNz5zOI49wZFEK1MNLhQpv089ija/uqFxvS37+DJSPQT/c1ey7iJCCDuJkt7y8vLmRtHt04WauJ9/OHEEyBP/0KuWeH/2Ma/DqwdELrvs1WKYIYp0AEe5Mth4t8b+BNR4GcN4tv6t7Au17znrLegPXhYW6Kdsx9edjTFMpLMlnUyNUO+h0fosZPh2CoMgywbNwiEXRm6MFr5mINazmgJ1OVj5oz+NfOlF/3ra2/Mi9i3Ff6j5Y4xVQb4FoEJwvvTxvCaAwAVyAOCHe+QF5g18kLWS9BOfM4E/IusQt963VBp17qhlNdR3EeID5Jpv1dEH74zrvK+WvGSSSeAaJiAew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpjcUe5NBYSLvKKrzgFlnlZ2dyLo6Yoi3l0iEmCBpXY=;
 b=wfQlKKq5QAqK3wkiGf7CP+J+o1XUzM1xIzNty4EQ2JWlA1YT4YNQ2T9rMj8Dw8m33F/txlFxv0zQUawhiC1l46P5ax3HWlzNGzWAaR9cw/eN5VZe0SrWuUY0Y6OCDJihkG+0HhlfSV51Kx7uprGtvDtYmMBxkRCtFlBm2VMNSDE=
Received: from MN0P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::16)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 13:27:30 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:52e:cafe::39) by MN0P220CA0018.outlook.office365.com
 (2603:10b6:208:52e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Thu,
 20 Mar 2025 13:27:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 13:27:30 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 20 Mar
 2025 08:27:29 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH 3/5] KVM: SVM: Add the type of VM for which the VMCB/VMSA is being dumped
Date: Thu, 20 Mar 2025 08:26:51 -0500
Message-ID: <7a183a8beedf4ee26c42001160e073a884fe466e.1742477213.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1742477213.git.thomas.lendacky@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 38bb2f88-92da-40f3-05d8-08dd67b2f720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4NIdBI0n2MJ0pEh4WTItlOocZGacxKaT6UxKOItufcZXYQKJdnksoxiGgcuv?=
 =?us-ascii?Q?Ehd2j/60bqW9CUBdpsre+uWqMG5nu/mwz0kT69pQuod+FUXOnTdbrEyuAzK7?=
 =?us-ascii?Q?VAqVD0H4Dde7NCYZ0SRaL3QDt62KavcMYtVKYyfxeGigRC2IpefN95m5Akce?=
 =?us-ascii?Q?MgXK6y6nW/U1yUyTAN/pFwFnBjvHMJu8OeA1E46TZ+rU6f/tsfnOD8bKrTlZ?=
 =?us-ascii?Q?80/jbXqa88Hf2Mze3lNQ0TWJ1qVS1lxe1ktW0dH8zIZ0AR0X1/RAHtoKR4M1?=
 =?us-ascii?Q?FRyhZ48rP2jRAvOJayn16DDSGHaLdh/tQvwvk0LY7uH0KQp99KdRKWPKPiPM?=
 =?us-ascii?Q?cdSqLFxe00iRYQbi0vXwqlkmF9Kvmf0j9TxPnkh9bjjS1FfrXagLURsENHj2?=
 =?us-ascii?Q?rxZYJNXxLIXF6ILm20N6QIH/oT/iKL+mQYXAz91QW6q2E42qpCKMdA1adGo1?=
 =?us-ascii?Q?gnkk5Uwe+P8KbGBVQobvuS72lKBbUG/7ElJ8cWmmcU9OAeEfrBb4KWxIu3bf?=
 =?us-ascii?Q?NMmyBmRF3u4H/nCnUFX0G8+c2aZJMGBOXR/tFKsTPOzux3s8Mv9CDBg1/Nd5?=
 =?us-ascii?Q?E4zqc8sF208abLIh+aNG5W8/YuWvZengr0hm5OwpkxX8ajg3nN9VH/9aYVEK?=
 =?us-ascii?Q?ctny6IPthoSC9n0A7LTH80FP+3IVd05Cj2daVyPsXf3iii4rmijgwzgw/mK2?=
 =?us-ascii?Q?oNQrFyY127+NdYVQJ0R0tZMPd7m9biCz2EGr6uxplFFrUWTOzBOLq1y+EN/u?=
 =?us-ascii?Q?NhUStgILXxqTInxCfB8pQzb9lLJ/YwLeUBf3z8n5ia62JpfSiI/Fiu/iTA/f?=
 =?us-ascii?Q?w0DqR5I26zAXmsZKYzbFqFKTwQodqSbj+UnonGW4hY78B0W+PVdbXtfSgefm?=
 =?us-ascii?Q?6xUO3iqWQp6sXP+EtLhOKyK4fxdr9DNkQcHFbGxXdBJznvpnQWLrw9TH3xRt?=
 =?us-ascii?Q?WcofClSZd/tqJW94Lq82aQDpqBwcS+HrwBOAY+zgDuWrVcohrZQwkZkYBLsF?=
 =?us-ascii?Q?B9oyXJ6Dpz0EozyGMSIiUHOWxpzfBopLccf/PqinULtTEkaGfLBnBlVH3m0F?=
 =?us-ascii?Q?FrBORCfnA1gZMbj6VNC6C5dgdiWLLLvQ9z0++S+fqXJ/Zk/ZGfxwqBKigPqk?=
 =?us-ascii?Q?I0DGKPRFPBkj0VyoPNL/RNgXiuDOSpgBHsKDlhfQYIei20dHelwNxWc/Fpjq?=
 =?us-ascii?Q?X5NJmsogR4KlRR55m+OxBYS/SeeZO8HwEMm1V2QAk7DOMGIMSyEcry4Hpvwa?=
 =?us-ascii?Q?kBbXYnY4rxoJvYX7l3JBOZfLWu1I8nUWsPMWgeJDoCdX5RBi4m4kQUIeSZQ3?=
 =?us-ascii?Q?w4sqoI/rkZKpU4g3ERmD+F+qYg6iAamztjQayIXt5SBweyxI9l9Zd6RVpgvv?=
 =?us-ascii?Q?L6+E2AN2sxG+SRKH3axcknH3U4rmakOLWlUE5KqY+3mv0A8tOsoecuLV70Wj?=
 =?us-ascii?Q?akS4xO8Q129syUb3Jc43DhoQr7T/CrLlVVQ8cJYRMhiMOli2NjJymQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 13:27:30.3920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bb2f88-92da-40f3-05d8-08dd67b2f720
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719

Add the type of VM (SVM, SEV, SEV-ES, or SEV-SNP) being dumped to the
dump_vmcb() function.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5ed6009bcf69..73b5ab58d2b8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3378,14 +3378,19 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct vmcb_save_area *save = &svm->vmcb->save;
 	struct vmcb_save_area *save01 = &svm->vmcb01.ptr->save;
+	char *vm_type;
 
 	if (!dump_invalid_vmcb) {
 		pr_warn_ratelimited("set kvm_amd.dump_invalid_vmcb=1 to dump internal KVM state.\n");
 		return;
 	}
 
-	pr_err("VMCB %p, last attempted VMRUN on CPU %d\n",
-	       svm->current_vmcb->ptr, vcpu->arch.last_vmentry_cpu);
+	vm_type = sev_snp_guest(vcpu->kvm) ? "SEV-SNP" :
+		  sev_es_guest(vcpu->kvm) ? "SEV-ES" :
+		  sev_guest(vcpu->kvm) ? "SEV" : "SVM";
+
+	pr_err("%s VMCB %p, last attempted VMRUN on CPU %d\n",
+	       vm_type, svm->current_vmcb->ptr, vcpu->arch.last_vmentry_cpu);
 	pr_err("VMCB Control Area:\n");
 	pr_err("%-20s%04x\n", "cr_read:", control->intercepts[INTERCEPT_CR] & 0xffff);
 	pr_err("%-20s%04x\n", "cr_write:", control->intercepts[INTERCEPT_CR] >> 16);
-- 
2.46.2


