Return-Path: <kvm+bounces-52572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44509B06DA5
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:09:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C8863B087F
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 06:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E039283121;
	Wed, 16 Jul 2025 06:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SJsNsqTM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A78817A2EB
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 06:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752646144; cv=fail; b=H1oJWzQ4tBiWxX2CZp9Oc/+c/toIix+HOvN10s5yibzWbvbVm9oxAQHEgK5Dc0r3orxVb/EIQ8H019kXBETHKXxDPdPTgTx7BmBYqiMyfpf3hcNkYQaZwpOcX1lffs/yoffLYs4GhpwbSJx9+TeMImQ8xDLeKdIsg3q2ZIVm7ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752646144; c=relaxed/simple;
	bh=T4gawTqYjvga+fldmo3QibiNPCWwOAxmuce0Ump18go=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mbhCS5hmoWjbT4bvmHiM3ETFQ2Dnj7JaZAf76Wlbe9nBfNMilJ+KKI3UfAgz8biOKBiFmKXJkPEdQeuSqGo5DlMqv1B8efCM5is/2jJWpynmZJw7bijwkAzTGXYUb2TOTlttED8jUwa0+Chu0hJRc7/bqrvWpSUB40jwJoVowXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SJsNsqTM; arc=fail smtp.client-ip=40.107.94.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkagVC6RqHyt+kSNEDX1B0rvLCvyLtamjFUUm+lyTsbIwtXqEH0ak8qSBVHVrcMDmd1vyRxTjzbBIgu0BNav0DwP6OhlzCEinIPrXvNASK3GrpiK8Qm1iaDqFbR255YI7GVKkGgrDcxJlhsawcjMx2FpNjdZmgC7gg6ym7+xho9sWlGv6uHE2OX920CucxyRFlK6qPGnLOWTmcmfVhlkLFvy2+c3czHTMNqd1CX1kO5Kg6gqHttG7667qxaKnYgPKbsnYyi/7Ef0R+a2OBlQlOiid80FOv/1fSg1fzfYwlaarsxZL1TaoCi9PpD33TE7HYhvEZaoD+MNWckX18ybcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2ZoLqVJ8KI1cVDRH1j35Z8wGvXgrbmI2xkHe39R/1g=;
 b=cNpgrcjTpsLtO4znxnCafpkjagGb0kbbHK2og36OkLuJsDsLsJxYRPdGInT6Etd+u5aEYh7ddju+SBrk5nL+tXeowLDlK4Fkek9U+LZsL1Ipz8Hhtq6BQZbnEH1hj9Gul0azSGM12+Wsbw72zIVqKYt85W9oCUKkuHvAzNMpMLKD1uhUkf2I++0XpFBj6UBkQIx3EqRb9FU/UrHlQ4w5iNIDBzY1SkbZUujMsH4rMzudJy7+f3Ynm93hTaIn8RlFaVo7ctseFdGF/KmTKmnMy88j1OgmETU1N3KlGZlJcqBthaD1svvleWkCb28/VYfbZUJkax+sVWwV4YPELMhHyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2ZoLqVJ8KI1cVDRH1j35Z8wGvXgrbmI2xkHe39R/1g=;
 b=SJsNsqTM/s+q/03St1n1DLL+AC8JEb9sXb5+Iuo8RZZZjPdhaHUS0SZ/e3DiNph0zNyefFFG+LHL++OVhZU3R4diYdR36wQtfgyK3K5jjgjAuUyR5M0Txb4sOcPN5zHXCPVn67gberOZj6sT90njyRBOsT9hsScj6byCHvm5lBU=
Received: from MW4P222CA0008.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::13)
 by MW4PR12MB6825.namprd12.prod.outlook.com (2603:10b6:303:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 06:08:59 +0000
Received: from SJ1PEPF000026C4.namprd04.prod.outlook.com
 (2603:10b6:303:114:cafe::89) by MW4P222CA0008.outlook.office365.com
 (2603:10b6:303:114::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.20 via Frontend Transport; Wed,
 16 Jul 2025 06:08:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000026C4.mail.protection.outlook.com (10.167.244.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 06:08:58 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 16 Jul
 2025 01:08:55 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
Subject: [PATCH v9 0/2] Enable Secure TSC for SEV-SNP
Date: Wed, 16 Jul 2025 11:38:34 +0530
Message-ID: <20250716060836.2231613-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C4:EE_|MW4PR12MB6825:EE_
X-MS-Office365-Filtering-Correlation-Id: 75b4119c-4398-4fa4-ccf3-08ddc42f4110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k8Ep6frKQaIr01k6TkXThG9cZkva2g4PcKDjfcQq4NLCgRP7Qubwxsi98j7X?=
 =?us-ascii?Q?KOIHpMq/pUPJkgc4ZZ9cciqYCo43o+5VnMGQNaQZ7pDNwWl45KvH/XPkv9z+?=
 =?us-ascii?Q?+ZRmk/IoLzOp7AveGStiwCjfMwuIOjrtRro8vdFk6vjy87FbnQKhJenPwvxG?=
 =?us-ascii?Q?3Cy0QNJD/ze+4/djOmOZJhcv9TIyuQn5Ni2/t3zTu68goGYMN76G1Z4ucN/K?=
 =?us-ascii?Q?lNDJD2YMTALnp387L+Hx1Q3UBVoG17lD5BvTCrC7hiFlGCBZpE9MGg8IeLEs?=
 =?us-ascii?Q?I5k+7/G532aXmdElSFtUSeLN0d0FDhsdI53nPEwvPT2++IhoI0knqNcPT4Rs?=
 =?us-ascii?Q?k6oWkpThuag0a8Nzmtpyz0BwozHonK7XBer8jigVjNM3JLXf8vF2m516AS7N?=
 =?us-ascii?Q?BLtuQcIZ8aLf2YSJIjN7c3j+pXtUiGmrxv1yDiArOapSTOuYUgxQ/6mv08rK?=
 =?us-ascii?Q?LiTiruPwYbMvmx9i2BuuFL/sefdGPSByvrHsKXKSqugGA9dR+Zmn7GrkshPw?=
 =?us-ascii?Q?I7UWR7fVWFXW2ez3BNk9oGoByrLKW8SzUk0e8x4mr7HO+SJLfPwQSrYyOjuv?=
 =?us-ascii?Q?8/uBmQRGp/c8PWe/BznI3DFj6StIwYZRP8zrlYL3Yki91q2DAxL/uevplkRf?=
 =?us-ascii?Q?UmDG1Qe4kFBHEQFCsvrQW3g0xJzOqnc/ISxHBhkPYkJxOxOWxeWtNoeuQCwm?=
 =?us-ascii?Q?Fmrp//j336cp4G9H/KSvQbRuHHsIVC96pGiJE5SWTBwxYBE06IzQeL/awr3M?=
 =?us-ascii?Q?Il2ng7CNGh/I92lB3ZeAkMsSYolcSgZAOgFJSUPSUJRn72jVZ4KXto26sbbq?=
 =?us-ascii?Q?yFbJftkR+/5RVOM3dBw+u13DwOCqhUUy4zGD3qMnCJ7kKCoYQ12v39Ccy7El?=
 =?us-ascii?Q?7WEEyXI7JrG74wUliffup24pC+u09qA745bEHp0hJ2KIfsE7wv2kikuVRnHh?=
 =?us-ascii?Q?kT2tCkueAiKzhzOBJwRCjyodZh6q8gEAgpAxTkpSqj3N1JvR7HzYk141Vy87?=
 =?us-ascii?Q?Opuy4k0tykGYZjNm5f3hqcEgvDsWIuXMQC/ymu2nT6jqd5gS47tbls/LYD7A?=
 =?us-ascii?Q?JJvsi3Rqx/06SeakDBK0xzVeAdY+lqK3ZMUkWXiIjWvMFHH6Fkt6vEz3Nreg?=
 =?us-ascii?Q?Nv+alksZpLlX4ZrJ8udk6UgMtuzxxyqrOG0DMtliIsdZSi1VIVIVTHDrPjzm?=
 =?us-ascii?Q?BKbLFQAWTsSru/lruoJL2Y3L2UMeFB2TugqGnMn4iAVXEzXifXkMxgGnVxci?=
 =?us-ascii?Q?ceLekc7qAOd78W7PM9WKvc908xtvx/qz1vST9bsy0TbzucJgj467jxPmerBT?=
 =?us-ascii?Q?8Ac0oHAU125eYiDXuMgIRemKy6YYE+vEP8iJehAZwSFt7ZATbv8NG0tc1TwY?=
 =?us-ascii?Q?joVhZMu3Y9XnKdkMvz9RtIwbIk9XzaZeGY/O6ReGkVyy1b4tUnvXTlnybeVN?=
 =?us-ascii?Q?XENgBs4uwd68OiaQiTMdVF9si30MuYgnfDHIrcTfPwXQ6mUWgbQA8TvG0Wtu?=
 =?us-ascii?Q?A6UekJrSsgTseg+RLGJY9aTy2d3BitSVSYBOlPtZ9nweuhK7D0yEfpZjhQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 06:08:58.9259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75b4119c-4398-4fa4-ccf3-08ddc42f4110
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6825

Patches are based on kvm-x86/next with [1] applied

Testing Secure TSC
-----------------

Secure TSC guest patches are available as part of v6.14.

QEMU changes:
https://github.com/AMDESE/qemu/tree/snp-securetsc-latest

QEMU command line SEV-SNP with Secure TSC:

  qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
    -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
    -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
    ...

Changelog:
----------
v9:
* Set guest_tsc_protected during guest vCPU creation (Kai Huang)
* Improve error handling (Kai Huang)
* Disable MSR_AMD64_GUEST_TSC_FREQ write interception (Sean)

v8: https://lore.kernel.org/kvm/20250707101029.927906-1-nikunj@amd.com/
* Commit message improvements (Kai Huang)
* Remove 'desired_tsc_khz' from 'struct kvm_sev_snp_launch_start' (Kai Huang)

Nikunj A Dadhania (2):
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Enable Secure TSC for SNP guests

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/kvm/svm/sev.c             | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  2 ++
 arch/x86/kvm/svm/svm.h             |  2 ++
 5 files changed, 33 insertions(+)


base-commit: 87198fb0208a774d0cb8844744c67ee8680eafab
prerequisite-patch-id: 797bfc24c79c6b63fcc12cd93664fa04d99e2cd3

1. https://lore.kernel.org/all/20250716055604.2229864-1-nikunj@amd.com

--
2.43.0


