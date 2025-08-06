Return-Path: <kvm+bounces-54187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98297B1CE02
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 166A818C6C79
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205C91A08BC;
	Wed,  6 Aug 2025 20:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q8bfvp1y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016471993B7;
	Wed,  6 Aug 2025 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513153; cv=fail; b=dsRTPWD8g6iiVeRyUrRKDEyioRknVBmlRSXQJwxxjK9wq3/JZIiVCAhFfiCtu/lBUL6oihOPnX4qiI41pM/79z5vxXaxUT4/a4pzpFuhu635Ak0XHAoAcuuOi8lFATjHU4G0lzYYjYvDHPk+bYtIotZSt2tEKFzisThfogLBtgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513153; c=relaxed/simple;
	bh=QOo//FNThZ4of45IVeSXUJ9aTJo9HbVeCQqLg0Efgqo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fi3RBe1upgg7mAS02NQMkqiEIicduKcTBoEwbtV0Rbbyh4Fc1bCraEdXcYuGqtpxQN4lPXcgKVp18FkCtdykJAtM+2MNhwX9sHtLJAze2ywhOCoc8/oS8dxiTFxcB5p/V0YOZeQoWRk/RJ+tpmwzmW0WqOBjys/BEuem9CPJ1Ak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q8bfvp1y; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PywppiWK/jfLoOnAhA0bmPp32I9fr6Hos8eW43MBkwogPol6JdnoNaKow1X/QRUIDbMKOUgPs15xrJOIWst4rRSFl4NB8X6YA7VxQ44hJalKJQNLA85yp8hMZj9dyr3vhvzIAIHM/qGTD88lwdj2Q/nVlyT//dHVe4XxQ6AMJ63yjozSZzHIlBVKMVkqh5SIYGW0yzo21S6G0grlRpaGzDj0K74XgLQZtI1eiX08HWMPDlTatBA+2dZixg72Z96ARbUy1K2oXOfrmXJytdWexMW7ZlJsvPYW8l+Xt4k+IpK8BLs1IhdHggW8Z2s4S63rwjuJX0CspW83zdAC4l8WIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iq9WVfFnqo5kmgzoUmO26oxXZQFXG7UXpLk21BQbB+Q=;
 b=QOLrW0+g4UtphQSTOtLg7xyNMDxSVoD5kPB0zV28zUiobexiQpdsVHCe70jvdEGszRw+eVdrtJvH/TLtdhw+HZ5bvtxtHWubcVUOVuAm1ozRsvlrGEkYYhNb8jsCbhw2GeIxGZQJaGiiYf7Rh7vOVGNJ6eyDvOgQNfMDDQk2jzwOhbPoX7SLJ2gV1Glqu2nITiGcHPuv4g4+mw9Sxsxxy/5OuJM41vbir3OO/P63/0GCLubLCuUhxz7/RjiDKEA7oJ5wYDDYrEwArf9CEqj32wR0VDVgxJoownk4uoGGILpXVHKVdsH+DnZ/84EBkQ8oq0k4Zi+Zn60KB8euih9RMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iq9WVfFnqo5kmgzoUmO26oxXZQFXG7UXpLk21BQbB+Q=;
 b=q8bfvp1ygFRxx/Pk5onE7kOwWqyCbBzfq4lF7/ci/d0UyI022p3wzdsj2ooSYXt4/gNNSSqOK/34qY2m7k8B4poB/Z8tycZ+4jbCfcgNHMLVvDm2JQYqGXh72l1nWPklu69c8fUS3s3koNpmXqI/1vNtP0zKwytktRa0cMNBPTk=
Received: from BN9PR03CA0911.namprd03.prod.outlook.com (2603:10b6:408:107::16)
 by CY1PR12MB9652.namprd12.prod.outlook.com (2603:10b6:930:106::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 20:45:47 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:408:107:cafe::34) by BN9PR03CA0911.outlook.office365.com
 (2603:10b6:408:107::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.20 via Frontend Transport; Wed,
 6 Aug 2025 20:45:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Wed, 6 Aug 2025 20:45:46 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Aug
 2025 15:45:45 -0500
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v3 0/5] Enable Shadow Stack Virtualization for SVM
Date: Wed, 6 Aug 2025 20:45:05 +0000
Message-ID: <20250806204510.59083-1-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|CY1PR12MB9652:EE_
X-MS-Office365-Filtering-Correlation-Id: a748d6c2-ace1-4f3f-e686-08ddd52a3847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GMnHonMeNRUG4siVWqqtxJgbu1pg2uq1At8fFnWSDBDoUrFDRy3Fl6Aglztm?=
 =?us-ascii?Q?8g4gekjJ2Xv78/jS08sShUm/dOikc0zkwLs81q10B+1Y8AlkIP+VHoHrfziW?=
 =?us-ascii?Q?0P0SFr8d43YoA9KVsJAsfPjFMNYaq/IYabm1qBDm6z+EC/i06gncY/Uq2Fr5?=
 =?us-ascii?Q?CpmIS+EldUtNNykmGpLvDFpdOWoxwaboLkuWMUWI07tL67giBt2et7tz1FKU?=
 =?us-ascii?Q?8DhA00KQfkphO1kgW15GhiOc6jOB1xL9QL5hCvJNjVGQv2D+tO887J89mnkx?=
 =?us-ascii?Q?kl1IY/ee4StTIe01fLSWd5/zu5ybW51+EYJsqGB4BEl0qzKGZ3/wbTnHJiMx?=
 =?us-ascii?Q?I0u+JV5EApmYmOd0gQOvww1PK2P43LM/Y3Up45mhgkd/h45UGB21Qdtfxb+W?=
 =?us-ascii?Q?FDR7w+ASBoG0DczW1E381qmXWsXaps2gZdVLScN7tY0DlrKAn3C++ATSh2I0?=
 =?us-ascii?Q?ho6uJX2+FJWhdfv2SOO4gsCnv81vz6CBadPRq+4NR+xS54r0sQy3USHWEcjo?=
 =?us-ascii?Q?H8wBRgFAkA700lRcj+yHO6Sc8bEg5RxMxQp7k2PqGBlDP+6ETMZzYPjRgcsC?=
 =?us-ascii?Q?aTyJp9mrU/XYGwbymWuhNlFFHTSeitRRLb2R59MHUvY5qP+Dprnpxmazt44+?=
 =?us-ascii?Q?lGWiivdH4lFBfcCtNLGeBHkBqt+fyElyQV8GfIK/MTvMgSWtRzTNM/Wfx6JA?=
 =?us-ascii?Q?JYXT3PM0ntKB/XyZO17zif24rJcpBEax35n9huZ56+Wc6HBe7GX6MnBIe6RW?=
 =?us-ascii?Q?ei8rDq2Q3ztN2qY/LsixKflCVk1714zE/IDhqegF/uwVjSLn6TQg44R5jDXA?=
 =?us-ascii?Q?OhynD5W01ij+5CU9AZNffuezPSHQtwI7Oj3uLbu3LsC3R/knH9ZGZN7iRJgR?=
 =?us-ascii?Q?lshg2eD48BFEzXTUAE7dvTFxWxWJEh77/K1bkokyQ2e4ZGw2s+qtHpgrZ3gx?=
 =?us-ascii?Q?XCSoF0uiD1Wvog2B5fJRsEjJ1wj59/iudvGfu9l3WKysfOTE5U/BdZXlfufB?=
 =?us-ascii?Q?XVVduVzDG5E929vYsA6LXf80VDmACz2NFsgX0I76jnQ0x86oUjVze8sbyEiw?=
 =?us-ascii?Q?vA9lbainCa4S+B1poGd+VduQa7fzSeQXRl57v7Wmru8EI3/2pyp2GLMsE8Ej?=
 =?us-ascii?Q?jA39g8j5Yf8yo/uqBepnJWGDrS6P/NFs+LTVpY6yxMuI6d48EqUk9a+GtD7q?=
 =?us-ascii?Q?sn9KviGd+G4ORHWnv4pcZGoMoUaBUKiBQzRyDH7bw9mvwEGc7wMPVXk6QK5a?=
 =?us-ascii?Q?s36dT5e1TVFo6//jf5gPG21/jo+IeMgSdwsxhKEJ2onzaMzCfPzATFsPgrJ+?=
 =?us-ascii?Q?P8TuATqFHZPAsxN6qW3CvzM3GsB3aNauhpeKpbZ/c0N0PfbafE13Wc25ovfC?=
 =?us-ascii?Q?kouQ3La8a+7XLc3GwZG0MpQ1UG7KeWvW4ODwQpWvpj/vk401+FzAdDLTJhWN?=
 =?us-ascii?Q?9kB4sm302CNhEthAF5YUKsZZyHmIC0FeqWnR/UpcP1Bjr527RyEWd27PfbH9?=
 =?us-ascii?Q?j1P7cZKFDH2zbwb2GaIZNjOaQx+7X5kvyrFFvZm2MTLUCOY0Zo93oQy5sQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:45:46.5573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a748d6c2-ace1-4f3f-e686-08ddd52a3847
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9652

AMD Zen3 and newer processors support shadow stack, a feature designed
to protect against ROP (return-oriented programming) attacks in which an
attacker manipulates return addresses on the call stack in order to
execute arbitrary code. To prevent this, shadow stacks can be allocated
that are only used by control transfer and return instructions. When a
CALL instruction is issued, it writes the return address to both the
program stack and the shadow stack. When the subsequent RET instruction
is issued, it pops the return address from both stacks and compares
them. If the addresses don't match, a control-protection exception is
raised.

Shadow stack and a related feature, Indirect Branch Tracking (IBT), are
collectively referred to as Control-flow Enforcement Technology (CET).
However, current AMD processors only support shadow stack and not IBT.

This series adds support for shadow stack in SVM guests and builds upon
the support added in the CET guest support patch series [1]. Additional
patches are required to support shadow stack enabled guests in qemu [2].

[1]: CET guest support patches (v11)
https://lore.kernel.org/all/20250704085027.182163-1-chao.gao@intel.com/

[2]: CET qemu patches
https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/

[3]:  Previous SVM support patches (v2)
https://lore.kernel.org/all/20240226213244.18441-1-john.allen@amd.com/

---

RFC v2:
  - Rebased on v3 of the Intel CET virtualization series, dropping the
    patch that moved cet_is_msr_accessible to common code as that has
    been pulled into the Intel series.
  - Minor change removing curly brackets around if statement introduced
    in patch 6/6.
RFC v3:
  - Rebased on v5 of the Intel CET virtualization series.
  - Add patch changing the name of vmplX_ssp SEV-ES save area fields to
    plX_ssp.
  - Merge this series intended for KVM with the separate guest kernel
    patch (now patch 7/8).
  - Update MSR passthrough code to conditionally pass through shadow
    stack MSRS based on both host and guest support.
  - Don't save PL0_SSP, PL1_SSP, and PL2_SSP MSRs on SEV-ES VMRUN as
    these are currently unused.
v1:
  - Remove RFC tag from series
  - Rebase on v6 of the Intel CET virtualization series
  - Use KVM-governed feature to track SHSTK for SVM
v2:
  - Add new patch renaming boot_*msr to raw_*msr. Utilize raw_rdmsr when
    reading XSS on SEV-ES cpuid instructions.
  - Omit unnecessary patch for saving shadow stack msrs on SEV-ES VMRUN
  - Omit passing through of XSS for SEV-ES as support has already been
    properly implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
    accesses to MSR_IA32_XSS for SEV-ES guests") 
v3:
  - Rebased on v11 of the Intel CET Virtualization series.
  - Split guest kernel patches into a separate series as these are
    independent of this series and are needed to support non-KVM
    hypervisors.

John Allen (5):
  KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
  KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
  KVM: x86: SVM: Pass through shadow stack MSRs
  KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
  KVM: SVM: Enable shadow stack virtualization for SVM

 arch/x86/kvm/svm/sev.c |  9 +++++++--
 arch/x86/kvm/svm/svm.c | 39 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 42 insertions(+), 7 deletions(-)

-- 
2.34.1


