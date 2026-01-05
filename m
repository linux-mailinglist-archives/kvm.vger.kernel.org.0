Return-Path: <kvm+bounces-67000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9266DCF2154
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2FBF03009484
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB31026A1C4;
	Mon,  5 Jan 2026 06:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CDyAi640"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013020.outbound.protection.outlook.com [40.107.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615C72522A1
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595028; cv=fail; b=e7/vEsI6j+L39K3kXxiH6c/M16honhGb2T+0gWp65qZMzt28fubTv7NviaxBvLeQc1sg5CIjcLxL8wcOE5XZF4Yun7CqyWMY07Wj//IgU3mNGjDeeUVcDJ+H/wV9N2wMo1XQDvnjF3ihxMqchOvfLjKk1FzzoztzIvhpogUD7Uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595028; c=relaxed/simple;
	bh=wvh5KFCA+Faixjgs6faiQuf83iTaAADyOwZwI2vGzDo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tVLXx8epYXxXiGk09qFo51wDwuoHEY+Cyqh1Vt0lTNMGKBU/xfM4yxj4DdphvOTZNWSbs2RfhS0ItMcAH4/1aas5pWc0KuVCOOU7iqwpZBOmpnLM0YFrWLxxlkFhCwFAhCuJ5Jd7iFMUI8IfBM28594ax6suTKysoVJOcS3zk7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CDyAi640; arc=fail smtp.client-ip=40.107.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=or+UqtZmtzqxB9sF0UjHfXFgv43VLN74cjqnb6uGkNoErHk71VU+q+psLvh/KUWqfikAorBfeoln5sSS6J2jS6uNir1HCGMUdTG3jphvVuRwKFXcWwEf82vZ4eg0ThY0/rkHO66RfQ4adMoZ0pcZtApUjDPx2jSsGvqwb8ZjK9irstIQCEgfay5NKy3GnKbUMRluVkTBuSrdW3Nfwahpe06LEnf4LNbsAnLaKlK0r+lKl4t3JRkTkn75AFwPwvO6e28lTY6oNEb8SamRnuEbFe9QFBN5AcQLr3tUcIFmKuFlOxw0jZSsX0kXJHWIvqaBHUzNDOtzouRTQapsth6J9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5RzBMdEnGWbFADJK6QUUNSgYjSiejB3My1VQ3lkNLY=;
 b=ltaZ/7AzldBR1FbJkwExqgvAvRLD9NWaBJdssIFFmH+oJaf4BEOShvqi8wCHERPug6ipH6tXM9W6yY6cKtjr9r1DoB3TETxyIlG8viT4va9sEUQoHNDpv9+fNZD2ZHrbXTbo4ieuSyCT480XDRE88+MSJ9PvP5APebOgD2TqtJkR05267Oe/6zYbu5ubl0Az3h5ceP3HX+j5vzBTha+vKTMPCzaavAVegfPYTA6AV/o17ZITHBbcl7IrDMEK+czp8jG3GOue6ud8TVcYcCjp0gPhc39PpWI5QAXxMxXan8rG2z6nu67DQlPjdoEPXpZc3TU/drPHs3RZX1OvhdVC5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5RzBMdEnGWbFADJK6QUUNSgYjSiejB3My1VQ3lkNLY=;
 b=CDyAi6405nXRCNmI/sIr2FyJLmXE5tTJwn+6WEzY73oaX5YyLDJaWu6ATslNco32AWi8EsmV3EGHY2z/ZN44CWQqQ5MXqBSXkjR1UCb/cMEUWJQtQKGRe05lJaJ016NHgDoniSaN379JIGnEbBdE4IGLVlG1CNt/a9n6+7HGvrY=
Received: from DM6PR03CA0086.namprd03.prod.outlook.com (2603:10b6:5:333::19)
 by SA1PR12MB9546.namprd12.prod.outlook.com (2603:10b6:806:459::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 06:37:03 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::3) by DM6PR03CA0086.outlook.office365.com
 (2603:10b6:5:333::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 06:36:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:37:02 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:36:58 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v5 3/8] KVM: VMX: Use cpu_dirty_log_size instead of enable_pml for PML checks
Date: Mon, 5 Jan 2026 06:36:17 +0000
Message-ID: <20260105063622.894410-4-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260105063622.894410-1-nikunj@amd.com>
References: <20260105063622.894410-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|SA1PR12MB9546:EE_
X-MS-Office365-Filtering-Correlation-Id: ea39ee89-0122-42a2-caa0-08de4c24d5cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VAx4nng+SYTJVk23zrLHAhQnT8osI3oeI3g1srhBhkQM8KWAJT4Y6ajn1mvm?=
 =?us-ascii?Q?47E8STIkWPBSqs6hWauDRSNWLCUvfZloLRoJEVwNNL2sUCDTeNlM4uCgRl1c?=
 =?us-ascii?Q?bSUQh+l0LxfFY2NPrbIHsqPKLfPN3Xk+QJ3TisSvA8pI0sJIXhGx8mdpdyZZ?=
 =?us-ascii?Q?3cFoK4/bRGBwmo5cUxK6NM2fJJls4fuO3d/DwQDtLwGR91/sfSkY6q3e2/6B?=
 =?us-ascii?Q?LeLrK2QUj4Sh55MugADMiyQdlbl/fycNA4CUa5wyIs4eZYqYaxn9veSw6tpB?=
 =?us-ascii?Q?xyuwTTCD8t9vSAAgJnhELazIBXqPUD51QHJwEvfpYO77ZH/si41KMbZ3jmfm?=
 =?us-ascii?Q?Oiu4xc1hDz7zoMmQ0I2euqQK8MnU1XXt0/OjJBE8TrW7i3nR7XsrBcgL1P9i?=
 =?us-ascii?Q?ns0lUo6S1CJYr4d8GRF3ezR/8e1hqLZCP4Bh4+npbnIlJpn1E79+VOTOkLj6?=
 =?us-ascii?Q?EBmz+llKfA5AgcgB2Bh1iumZuLBACf5uMFgdEp1Kv3/ZgDXgo/kJfk9St8/d?=
 =?us-ascii?Q?yqYM1FnQyD66SPqVa1FjAwWjUfcjoVdRzfgoGwklV/QQkpJqRRGTEcaH31Tu?=
 =?us-ascii?Q?dsI4DYQijeuAFvEEeVkfML8LFO3JfQc3T9ctnx6mp/GyC9fQfh1+2ZEfHVvl?=
 =?us-ascii?Q?BpwMQFatAVZ3rosXUexv2MteQXIotmM7DjEsid2fkH2CMa1zY9ME3oy5PW8n?=
 =?us-ascii?Q?CemTOfNwSavE8OTnFmjN/A/qeL1vNF+EXEPvXKFmWn0/lsIQuCBczZ0fJpI0?=
 =?us-ascii?Q?Z+RFgPHZ3wCRO69gb0lHVSEaIZuYxASB8oA2frk8ZMuqJQj6UBO9MHgUBeRV?=
 =?us-ascii?Q?QFfZefCawUrnLADfHfTQbf0CreoGIqrLIwlMgxTDlYxNdCO336eO7mOCXo0C?=
 =?us-ascii?Q?NDwMoVLwfO5QFscom7Ii6y1RubDp0yKuq399PwUk+iniRcY7HKnLHLr2gB8c?=
 =?us-ascii?Q?b8wcIYW6qAVVRCVnbR1UI9b5jLAtn6CwirZgtZdJJvKwU97Kt2Lc5rLXaKk5?=
 =?us-ascii?Q?1ijB82bKS3EjBsey9qNK0fqq4VPgh9pA5zxG4Jp/ELLyvJEW+PewZ2itRZYa?=
 =?us-ascii?Q?+uCmfFufYCU2zvhmgh1Ek3nGjIgFx7s0OqseSsx9ps+5j3Aae2uO0z52XqIE?=
 =?us-ascii?Q?EXADy2SwFxKVRn+/EODOHYkN3sVVCWCmiVvn5Mq19eK3fqGTer55B68DJ996?=
 =?us-ascii?Q?v103vWO87uywy9kJb3reWmmA8taq5OQLB0L8F4z08kF2aAImAGpBOfp4etu3?=
 =?us-ascii?Q?5c7NLv2DcKKf1hO1uxxVNKeQHguWItPE+dzNtJ7pHPXe6Q0Ln5TYzyoAsxze?=
 =?us-ascii?Q?JvJbywEipssniJ/Da+oS5YPePXnRANNM4P96WmCZL5vrwIsCC81r+k7HOET+?=
 =?us-ascii?Q?Q/GiprpP6FRok1XZA73Vgx6cGjATu2e6J4hfWbTlNitXIS+x5GOrLwHSClkE?=
 =?us-ascii?Q?LqdUIlg4mPp/1fu5K7CjibFVkQp9uGSZPYysPwsylkitQpH4TZUGVyAlTYiu?=
 =?us-ascii?Q?gTght38U1LP6cxIog6NuYrWP+flUiy8hUZdEhsxRCyk+/Cu826MAZZH9/C62?=
 =?us-ascii?Q?K/CrqrqelvFlmk6f/Lw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:37:02.2457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea39ee89-0122-42a2-caa0-08de4c24d5cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9546

Replace the enable_pml check with cpu_dirty_log_size in VMX PML code
to determine whether PML is enabled on a per-VM basis. The enable_pml
module parameter is a global setting that doesn't reflect per-VM
capabilities, whereas cpu_dirty_log_size accurately indicates whether
a specific VM has PML enabled.

For example, TDX VMs don't yet support PML. Using cpu_dirty_log_size
ensures the check correctly reflects this, while enable_pml would
incorrectly indicate PML is available.

This also improves consistency with kvm_mmu_update_cpu_dirty_logging(),
which already uses cpu_dirty_log_size to determine PML enablement.

Suggested-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bd244b46068f..91e3cd30a147 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8242,7 +8242,7 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (WARN_ON_ONCE(!enable_pml))
+	if (WARN_ON_ONCE(!vcpu->kvm->arch.cpu_dirty_log_size))
 		return;
 
 	if (is_guest_mode(vcpu)) {
-- 
2.48.1


