Return-Path: <kvm+bounces-69506-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qDsvFTEAe2nKAQIAu9opvQ
	(envelope-from <kvm+bounces-69506-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:37:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E8731AC429
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:37:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 25EBA301D6AC
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3703793B6;
	Thu, 29 Jan 2026 06:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="elQKRpTg"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FA51E1DE9;
	Thu, 29 Jan 2026 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769668642; cv=fail; b=P8YXbtwArwPPjFyHMvEGpsGpX84XbrgSc9MeBG80Ox+K+SQ4/q5UBSMiv8ADMxOF+jtdUlVUM9kRtSjNDz9RirwdkiqteNKb8RnzNXQHI0fw/lN5cuFsiG+tEBZbn0opoifar9CM/G7PCT5+VvxJm7MxZbm0wy2UghFe/m9Gq6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769668642; c=relaxed/simple;
	bh=kb56FY2rS6sGZdXpisjQV0QrnPZ+nYH7vUclmIwpMhE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k4gd7DduX6ouslsYn792ycgLiJxlXpozbD0wo2kZ6gygjBBrOBvABSQGi9SSwxb7EURkVMGDLrmkL+DiQbQ2wnnHOa4U7mZYZ1H1ezrm/uTdqqr3NtVdqk5aoVIrUtgIebyL5SiVeYh6tkr+NQ9XxvKXkHhuYPZAISMgzL124u8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=elQKRpTg; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k9NTe03XwxnNE7G4dOgck4y2rtzLifXKBtwHxF82txV/KWR9nDWJBFo0ZP13+FgeHDOKqFvQDyvHBiLo2MxBkd4fM5gW8aoHRoQw21VdLCYOPcOTG1Vu9Ie4XEen4VX2tUJwD1fGbmbaut35n/Fh/kbgCx3tYwCP+WqkA4C/liCycdk4NQHEXtF8clt+Nz/K69y7Z8+AodD3VR69TMyoBC9Uo7oYSudKhOzeNQC7MiuzM0dLwQ+gRftx2KW0BVdusHbzr040bxrvXrfzQb/2AQEZ/ccJ979A4Qo72T4ZgDga8qSNZLF4uzcZ0f8/b+eAWCMYLwNH45AQWssonDIzeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ug3L2iEWDUJWPDz3zkqmD5UUVnx6U5O5TlFoU1ibp8Q=;
 b=Wf94EatnmbZ0TTXXTHDDfUgZiKweM2PNv3s6JKdhA6ZWL03bRWBZ4RsGzWNQr1kN5/ZB7zdwvC5RMrcuz8Qv7zFwlVe3y1xy2h8sWU2btl/Hyh7A8bGxT0QXR1ni2KhvP9tMmrf7hSNDWLp18uS697AOW4dpmkLEinuhe1a5tUkk5ok4zYj7W9nSVlBUX98RbHiguImZaJa1MciMPde27NXcx0MYGhlXlpjds2iAUvaOCx5gEFmBhk9FAyHkHC5s7ta+y6cqIQ8bwpuEN0DdS1Gu4I6DjcywUXFNOwTk8DtiuVH6yPwbiFGpB83lNpf1PG4rJME+B1NU6FMpYILmkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ug3L2iEWDUJWPDz3zkqmD5UUVnx6U5O5TlFoU1ibp8Q=;
 b=elQKRpTgWfmGIeTdlx0m9Q9ymd90bTdD51S8M33nsCfQT7yKR8GqRMbLYEC87IX3iC3GSHyXbNqGz0QSR0jlHKG70+ax9xZ5O1TRy/IxRtzT687EvofNHgdiRS+qpYGvc9t0RtoF4bNcibAivkmOVI3vL4N1H6NY9uS1Ns6rzPc=
Received: from CH2PR11CA0005.namprd11.prod.outlook.com (2603:10b6:610:54::15)
 by CY8PR12MB7708.namprd12.prod.outlook.com (2603:10b6:930:87::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 06:37:18 +0000
Received: from CH3PEPF0000000B.namprd04.prod.outlook.com
 (2603:10b6:610:54:cafe::1e) by CH2PR11CA0005.outlook.office365.com
 (2603:10b6:610:54::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.10 via Frontend Transport; Thu,
 29 Jan 2026 06:37:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF0000000B.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 06:37:17 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 00:37:14 -0600
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>
Subject: [PATCH 0/7] KVM: SVM: Enable FRED support
Date: Thu, 29 Jan 2026 06:36:46 +0000
Message-ID: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000B:EE_|CY8PR12MB7708:EE_
X-MS-Office365-Filtering-Correlation-Id: fc0ed10e-e03e-4a5e-cfac-08de5f00d92c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nQBtP4bPZ0w+X6ZA7xKfTMb7tHkyfkWkZdLw3V6xfwLsuTx2Zn5vLx5DLUcb?=
 =?us-ascii?Q?Er0JfGHEP1mYs0F7njowodlrpJnT8X4OxMRw9ITXib/ReIO3CVdX4PYhVYf0?=
 =?us-ascii?Q?X1sMFAoaq81XgC4aqEgytahb5RLNZ9dPxzEanwGmAjhWG+HckyEi7e7BNEQj?=
 =?us-ascii?Q?Re4WXYj74EHWAy1rrC84pFMinVOhUwCKfs1BAAgb5OMW/JclpDxOQJChHYDt?=
 =?us-ascii?Q?mnrVwOrUoTTwhx0OxDrmM/apQ+0HtlmWSj1i8sI0Ev9StPSUh3HeQkCtcICT?=
 =?us-ascii?Q?5vio32VfatNu+DuH1hATvRzH8xsvuk0Uh4QVTvW47kKdMzJw0iYBnsW2uP4/?=
 =?us-ascii?Q?bXDdb5cHA6KIbLT5XyrMj37nKS5fm0dQarcWqsLXd6wJC3Vc+VTXslc9TaDV?=
 =?us-ascii?Q?g+0fjiayAESwmFY/lLSQFhrNFs41Hv6yLZ76kZtCoOes7+H4DQZ/PdwDYVXP?=
 =?us-ascii?Q?b16FT7Ji+tXRhu7AopIMFdw0qcVWIPLK+wzjiFUJzk+92RAJXjx1LWGfFuDI?=
 =?us-ascii?Q?b3CYlSCxAn18fvsuaFEHQiFUa3jaY+XLJoMPeYsqK/vZ0eUqnNsx5NitlCi1?=
 =?us-ascii?Q?bQtS8ymcWMr77yk9eWEkACsnWHu8il1X/deRb8Dm2UDjhn/9ztcay4jxXNUK?=
 =?us-ascii?Q?vQ6RUC5qArVoTSBpv+YaCSZLY2VVIVWO6HDZoSu1EwQyAvzbRVySknWocwdi?=
 =?us-ascii?Q?TllCpRGwCq5XIZ3Vko7FBv7WetuJQDehxH+5f3o7ZGIvlvTdF0X5Q4CaZSX3?=
 =?us-ascii?Q?IHckCNCUXzNn9AeeLR57Yp7n5+a26vVOXO7n7qCi/IuPvMF6DBFXYrEmGlPC?=
 =?us-ascii?Q?jeBsvWZ1KAQX5voqsmj2vTKlbj++BNvzwqjG5QblcJ9EtiF7rmoyNFJSyObY?=
 =?us-ascii?Q?XIf2NEb6ayyU8nWaAr5dTj8YvRC8zuCrDdTQiBZRnmhxwd/NAfpDaImv2A3U?=
 =?us-ascii?Q?QRXSy+U0sU+7kzjyUYlI3HB8bI3zwp4qhj7DVkHcCruZe8REaYxEoCBb6ToC?=
 =?us-ascii?Q?kaM87y3OOopuo0NcDiBWk74lMyJgOsjo1Wh4K1NEZoi+isFX4ID+1P+iQ0L9?=
 =?us-ascii?Q?h1i2oDPS+uvHzFcFOjxZY7v9yUvDH9e30vylt1J+AWjOFQMUxVGVC3Esd1dE?=
 =?us-ascii?Q?FL2Zu/EjSx0jEPvpGzLZywJM/XnyLqzj+iFk6Hm+jQ42b4VkDeR01nkORwLx?=
 =?us-ascii?Q?2nIhDwAtdvcQ1xQBsP1g7XCtpyulXRbDNhJ0oNj0FubReDedfwAfJH2JvACE?=
 =?us-ascii?Q?isAz8ceefuv9WbRjD8wlBbwfJ/1HWiynoFk4NO+wniajO45aixNX2Lfiqs1N?=
 =?us-ascii?Q?uq9zHCRFftfc10r/0YJdU/Wf5Gy0SkYD59C95KYuz98JNRTAjY9c8wt8dq98?=
 =?us-ascii?Q?GorEVDFG1Rf7pg1/FcJizqmMmhlr2kJRarxX2Z+DxiMGcEpd+CbppstP4gWi?=
 =?us-ascii?Q?qb/1gHi0urwSTEJtdaoQne9Zl5SksG/ZcloYZNq9/z3rvmeQ51YIaB12Dkhl?=
 =?us-ascii?Q?Dc+spAP6ReeB9FwmOaNAeWnvowVmDG9YjrHrEQpG3a1zlQgFenFoiq+N67fA?=
 =?us-ascii?Q?Gqp3jdlSnBxDysV/Q9NqUKOs1s9xa2Uk3Ly8bMCu94rKNT/PTbeRoH80JbUP?=
 =?us-ascii?Q?DiCB0ZLJAmI8elWmCQSDjSrkh+lYv8DOk2W0znEua7tNu46oOGptou8JudzH?=
 =?us-ascii?Q?mah5TA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 06:37:17.8981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0ed10e-e03e-4a5e-cfac-08de5f00d92c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7708
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69506-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E8731AC429
X-Rspamd-Action: no action

This series adds SVM support for FRED (Flexible Return and Event Delivery)
virtualization in KVM.

FRED introduces simplified privilege level transitions to replace IDT-based
event delivery and IRET returns, providing lower latency event handling while
ensuring complete supervisor context on delivery and full user context on
return. FRED defines event delivery for both ring 3->0 and ring 0->0
transitions, and introduces ERETU for returning to ring 3 and ERETS for
remaining in ring 0.

AMD hardware extends the VMCB to support FRED virtualization with dedicated
save area fields for FRED MSRs (RSP0-3, SSP1-3, STKLVLS, CONFIG) and control
fields for event injection data (EXITINTDATA, EVENTINJDATA).

The implementation spans seven patches. The important changes are:

1) Extend VMCB structures with FRED fields mentioned above and disable MSR
   interception for FRED-enabled guests to avoid unnecessary VM exits.

2) Support for nested exceptions where we populate event injection data
   when delivering exceptions like page faults and debug traps. 

This series is based on top of FRED support for VMX patchset [1],
patches 1-17. The VMX patchset was rebased on top of v6.18.0 kernel.

[1] https://lore.kernel.org/kvm/20251026201911.505204-1-xin@zytor.com

Regards,
Shivansh
---
Neeraj Upadhyay (5):
  KVM: SVM: Initialize FRED VMCB fields
  KVM: SVM: Disable interception of FRED MSRs for FRED supported guests
  KVM: SVM: Save restore FRED_RSP0 for FRED supported guests
  KVM: SVM: Populate FRED event data on event injection
  KVM: SVM: Support FRED nested exception injection

Shivansh Dhiman (2):
  KVM: SVM: Dump FRED context in dump_vmcb()
  KVM: SVM: Enable save/restore of FRED MSRs

 arch/x86/include/asm/svm.h |  35 ++++++++++-
 arch/x86/kvm/svm/svm.c     | 116 +++++++++++++++++++++++++++++++++++--
 2 files changed, 144 insertions(+), 7 deletions(-)


base-commit: f76e83ecf6bce6d3793f828d92170b69e636f3c9
-- 
2.43.0


