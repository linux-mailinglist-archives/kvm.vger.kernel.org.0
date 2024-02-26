Return-Path: <kvm+bounces-10000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BDCF868328
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FE141C23086
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A78133288;
	Mon, 26 Feb 2024 21:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jp10aC3O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542F6132C2A;
	Mon, 26 Feb 2024 21:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983198; cv=fail; b=f46ASMwzNLpUfCkOsnWnVmYg6IkeEJ3E78i6yhHCAzCG2kAhcPMdiKZAM7BjryvIHp8KrpHVS6Q+tJl/OgfDkbKMyN4OL6Eey4jXvlnw9tAB8kgL6a4upw3f+v3AweiFFZPlPlfRfKsWkLtJ7rmYOEFxKFczFZu0vuzGxGSzO4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983198; c=relaxed/simple;
	bh=oGI4z1E+dcaInNs25HvjRZ14QNhk4dNjV+0SupNKLg8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X19bmV7pUs/YTLHyg1u+0zsQeGzLWq9oC1n+WwGEJzJe+vhFjv9YZdDWmqSukZorURIDLAU7Rogq87LqIN9+i3e5VjgchB/ovsPGx5DUfsj9Jy84MsZaNXDaAQMmlt6TpFjifJxiNm8hvffhvXHBV+dn5zOeDZjMWPp9d6UZ3Tg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jp10aC3O; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgOT3l7qU8vIxID7R+iSf56QmUPwczDVvH1q/wSZFPW24jgRmuZuyVboXJ6HPM5D6/t+zcb6nt38AdSJe0hp528IXCZJ2LP56SGbnE3wSS91fcuFB0qY4bNaj0ae/x05FyPkqpaQiu3bQjtBjTdZ+eTP8yRpRKRz4Bdn/XOQbFgBzp2jZq+hi1ZkPtyGlyky0p6boxRRNqUvOcJfInm9ZfwaEi02DS4SAoClt5bcD+EaMIgC5JeFEDB/EFZavO36LcQRj+gw4/yDaZAYr8kWtT1vts08TdbKlXE5xM1yGXFh+QxDZUErVoDZ+LQ41sjNbjtIsJwMiaRjoWqhyY+HSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9umBMiWClOer5d/riBrXbCzpKrxM/rqB1EX6hZ8JvO8=;
 b=AbANk3x7y7O8RADL9kjFCANi0CSjqgmQNGydsvkhY0uhPdz6CpUIeKdMymV2Zlu82S939uEKLJTr3phWATbOloqurV3hkf6Ezwo+3JbVNqB8kF6wUC1yPehzTH2gNfxzv4ccVyUJL/NxuiuBD7Qi7fgCyp4xjWj71EFx9iUOSSRzc8oabowgcuri640Dp3OfgDRVGZpmDOM5SpLlzp6foX/1MCjmC5hiNub65jVoziGul7AkBBA7Oi3nlqqkXO5uw8XKJ7msedidUD8ARLQinwuzINtToxIBNozbWfA7JJKCqAV9MH0UIp0OVB0j3zRoGx6QMjjfcxRxRK8IoqofOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9umBMiWClOer5d/riBrXbCzpKrxM/rqB1EX6hZ8JvO8=;
 b=jp10aC3O9dwP9QruT9cdxi+v31UI3aeusD60mAlyLl9q3IXYG3s1AZXjpQpZsNkbXn0YDvQO1nN78i4kIFV1ta0zREIVio2aAlS120cW540HQ8UXmKf0tBWsRSjaZPGSZq7LwdkmveDOusAIh4++8fEkYnubp1rwtpPvDkctXug=
Received: from CH5PR04CA0018.namprd04.prod.outlook.com (2603:10b6:610:1f4::29)
 by SA0PR12MB7075.namprd12.prod.outlook.com (2603:10b6:806:2d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 21:33:14 +0000
Received: from CH3PEPF0000000E.namprd04.prod.outlook.com
 (2603:10b6:610:1f4:cafe::15) by CH5PR04CA0018.outlook.office365.com
 (2603:10b6:610:1f4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000E.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:13 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:13 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 2/9] KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
Date: Mon, 26 Feb 2024 21:32:37 +0000
Message-ID: <20240226213244.18441-3-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240226213244.18441-1-john.allen@amd.com>
References: <20240226213244.18441-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000E:EE_|SA0PR12MB7075:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a972bfe-2d28-42c2-a29a-08dc371289c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Lcer7778P7qA6n1qIFMHd3r/MLfLIK5F7bpBPqqAdNm8jg7NZRSWA/zRKBAzFbjr9cp/Upeo1tCQY8/t03Fh4gTN0ti+QPB96FDfsSdO3cXHkNUrH9Y4iWGEw1eCuZb12kC52oxHVkbo8YxfHnQE4FohYoG+cAKSsfxbh4Rt5pzreyN4XXRWsTVGy/bRYH0CenYtdG+TmlMZkdfAiK2133SUkAKToT7HgFIOzDAfP7bE55DJpje2aekkCCugFEs6s8f8k5qmrDUGT2PwgrW1q/BsKgGiT+hp5B8y+k5I705XCeglRi2VEVbIuHWNXXAVxopNgAgKKCEP/wZ9dDQHsbSziA0Y/46yLVgZ2wJA7oVNIrk8+Brz2xUNXYfH+HDRJ9NOWFatDpwyq5FzkHLekGziAMVnVu6tD9TotPs6B6vqGsrYiEF0avxUSo6nFtRjX01eBDsoaYO/BYGS7PFhDKmmz+SG5qw7zWQjNGs57dwUcR7qg5i/kLsjxusVZ5rGNLM9BdDDcs4UgWSNlA+af+rpsDux5qFEbZYPcTP8QnvIuiibLcGjk/XKPeaSWOEGARVWnQF/q6IqG6lh6MDN4CNG2TuGXuCzB3y1+qlYHL9F/sVDs8IlnvQgTcQ6uIZ7WQ5qXIwvbAzphR44m8Z4ldyVGfaZBQJ86DjSPi2a8g4pKOdR5GbvqeYGGbkVhNXNlAsFJfEuBIfjmvBQQQW2DD3GpHYcscoqBn0Ed+tBzNpoTrIB8rLWa2xfUo/ApshE
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:13.8937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a972bfe-2d28-42c2-a29a-08dc371289c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7075

Set up interception of shadow stack MSRs. In the event that shadow stack
is unsupported on the host or the MSRs are otherwise inaccessible, the
interception code will return an error. In certain circumstances such as
host initiated MSR reads or writes, the interception code will get or
set the requested MSR value.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..70f6fb1a166b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2864,6 +2864,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_is_intel(vcpu))
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = svm->vmcb->save.s_cet;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = svm->vmcb->save.isst_addr;
+		break;
+	case MSR_KVM_SSP:
+		msr_info->data = svm->vmcb->save.ssp;
+		break;
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -3090,6 +3099,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
+	case MSR_IA32_S_CET:
+		svm->vmcb->save.s_cet = data;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		svm->vmcb->save.isst_addr = data;
+		break;
+	case MSR_KVM_SSP:
+		svm->vmcb->save.ssp = data;
+		break;
 	case MSR_TSC_AUX:
 		/*
 		 * TSC_AUX is always virtualized for SEV-ES guests when the
-- 
2.40.1


