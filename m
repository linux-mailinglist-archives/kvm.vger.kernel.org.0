Return-Path: <kvm+bounces-23000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 816CA945628
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 03:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11C741F21D39
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 01:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313C117C68;
	Fri,  2 Aug 2024 01:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kK35YY6F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682C71C687;
	Fri,  2 Aug 2024 01:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722563901; cv=fail; b=fA4ioprh4f/7XfTGHDHeByFn2fJp1cov0oR3hgvFtM8/BPgeNhpZumg++CfgFkwnMWY/9o8q+o3GKdMAHQdU1WMeEPcs0YA0lZvEmpVqpsfx73A60eJ9QO9LyxNd8MaD8GyMzc936HUYtUJNClQsDelv8amwQef62KuUBSlRVBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722563901; c=relaxed/simple;
	bh=3xPfVJama6H62uJKTJMGtuxL1TcFLlwKv623eiQQW50=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e+xtNK3mkf/M3sFUz8FH76oDuqk2dqj/U5VQL8dfrcyESpjzSNWI4hs1JYnDV+3rM99PgAdeuISEzx+MIPJPMjncwIgeoRA7PkK1sIQT6cnfMkx2Q9kA+O3hpIcKTMuFDSnFJt+q6ob6bIDtb/ueF2LI55WHdrVM4xaQ3IBkZ4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kK35YY6F; arc=fail smtp.client-ip=40.107.237.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZ24xLpBH+nFdGWQSxTRAa2wio3xKaWMW/Mk3c+/tNVzyP9woZ2wBY6++yUnG266qxDRpuv6IVrl8bDYEJLll9tIObIg/YzuiRr83nR1qgnl1D97QTNiCRKDmztH/VnBiwi2BSbzGZTXgbh5ibNJxxWKjNDeCF4tXnXRWTKuCYgphKlfe6FxIafCeycl2zOLuX84SEq32SxOsunQ1/4vR9pN41r2FWw7qwqZGRfDikOr1QflVnoWLi2fjIRgzlMEhMVRv1zlHAP2wgcwEe7xIAs9ZHkrzTj4hRmUBQmQrvRXjgX2h0K3tTAoW6+prasPOPbBoH9U8EtWZ+vwaJ3bJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+M4+PQgUy0iTiM4NiefPywptx9N1mWZvpM8sdl7qYY=;
 b=eS2RJZIwS3SUYrmY1y+z8Jg+PNeHJrvzkbfMhAGEOCRkY2tuedGRIOef/HcZHHdnq5cMzdic7tpZrjflnBuQJYgAxeYVDfS0csuDKopuuFSYqQLxB45TWzFx3SjBENMYvI9VGCnkZBAA3/MlaJt6n3X+sqBVXZHe5v6XzaaZdtynyeskJhu4CqwcVmA8R6ZRNElX0pu6+AKQ9sCDhm+DFcc+GZiaRIrekU40KMaotLcMISyLGioBM9G1CO5pbx8hQi1CM7cVrFujMEVInOBEm8ucZQj0iczaugbJutDaQUgpCmcYRewpT6GCM6LLqPLEtCXL9l/+NJyC+k8lwO3xOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+M4+PQgUy0iTiM4NiefPywptx9N1mWZvpM8sdl7qYY=;
 b=kK35YY6FsCu35ZssOuvQsEAb6sotWHc0qWXbe1oUYJaet6AK1FHoPZBEyzpkC6g3dcYLAD6OsPd0emez+KOdK6nBxVSIF4yOSgaAre42+j65W7JJnNny0QYZiAaE5bIasmGi/w4qJwcoD1vfUWqwOXEmmcWbgDYtZmkEfE71XVI=
Received: from BN9PR03CA0044.namprd03.prod.outlook.com (2603:10b6:408:fb::19)
 by IA0PR12MB7773.namprd12.prod.outlook.com (2603:10b6:208:431::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Fri, 2 Aug
 2024 01:58:16 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:408:fb:cafe::b) by BN9PR03CA0044.outlook.office365.com
 (2603:10b6:408:fb::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22 via Frontend
 Transport; Fri, 2 Aug 2024 01:58:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.11 via Frontend Transport; Fri, 2 Aug 2024 01:58:16 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 1 Aug
 2024 20:58:14 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Kim
 Phillips <kim.phillips@amd.com>
Subject: [PATCH 0/2] KVM: SEV: Add support for the ALLOWED_SEV_FEATURES feature
Date: Thu, 1 Aug 2024 20:57:30 -0500
Message-ID: <20240802015732.3192877-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|IA0PR12MB7773:EE_
X-MS-Office365-Filtering-Correlation-Id: 10d0ea26-d839-44fc-8202-08dcb2969342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HX6rESqAKdX3u0fwSSBFpacxyDcbD+zeGxbsQcZRftL6spgb2984wQZtLRY1?=
 =?us-ascii?Q?cFP/kalLz3q2BSuerGuttkEeDWNWFi9O0LmQgS9/mcJZAZs/1dnO4rmIPipo?=
 =?us-ascii?Q?Wm671sgl7b2GVy1pPDVkz+p+V5ePF2vy7Rs2D7iHPxCRj3t1kjr85u0b5/26?=
 =?us-ascii?Q?IGFeWcXMCCyjxyjvSVJGQd5CrAK5nI7wEDd4K8D4IXlpNx22DF5D6OONKyJM?=
 =?us-ascii?Q?x6m5TNF/8oqmg9CeCf0huCE9dI0/9AKpxARAG45/cJZ571GQ3nFTsfiQupul?=
 =?us-ascii?Q?oUHT0m2HgaGf9uwMSN59MELlFPS0idpkUZTYJcg8gEgT/XsyHG7dUKHJwlJb?=
 =?us-ascii?Q?UUS2HQPNUFQKSACD6b7i/tuRdYH65ZI5tO5iqd1f/5rpSJeSUv8lg86fuJpY?=
 =?us-ascii?Q?MdHUCDUVKygbDYVZvb5/bEvksrimjbwX/YgSy94BMKIlm9Y18Y1QE5NnBfwE?=
 =?us-ascii?Q?bOVbj+p87s43R9GIDwMG7Dmw3rfNrbX7QLCeaCaTOhU1xHLFpnWEIvUY2ymt?=
 =?us-ascii?Q?+5z3GZsAHRIRYeasqyhlu+iI7loaI6Wsdq5UuasCI76TZg/FM7AIrlBbsrVx?=
 =?us-ascii?Q?cIipKEmPhQy3fzVV0uAjV7EQS6ZGQyT8bUsJuFs0hJNiY16xdkW+a1TtQQvJ?=
 =?us-ascii?Q?WM3H2ylgLx7v9/vjBgECiCkooXI6EaMM/+b8csdWmtmZYsAbGOpQEB/62M4g?=
 =?us-ascii?Q?6qlReT3PHZX2daCJvezFe0JEtCBjM5Lug5hlMo3r16lVl+f56+sLN7VBKmeF?=
 =?us-ascii?Q?LpxsWAMBx2tBbXFyeFlQK1NFi5raDAXxTrQsHlmBAVz/UCwRS0yFn3dZN+y0?=
 =?us-ascii?Q?zfAOwHJ8iph75YYDuBoUoLs9u2EfmYUnyxyhMYefhdd0xdIJSAlgrzk14oMB?=
 =?us-ascii?Q?/7p0m6fK/kJuYC5Ro7dqPRqQI8I8tVPynmSDm5nt9k75hqbei0Ym7F+JTNlp?=
 =?us-ascii?Q?2NDrvAWrwKGxeeSTWojFQVZM7ihTxC6NPfMLZ6Sj6QQNlXAUukBitseRf3aX?=
 =?us-ascii?Q?DFGC5sz9q5uvsKOCltYxvMV82x4HqE5IFRibCXo86GkHNCz8qgg8WpqVXIYW?=
 =?us-ascii?Q?yakDhrCYH8WDHzA36ztXzaBOgCwDqY4GMKATkX9ew9qJ4x6YV7kPIAr1VeTl?=
 =?us-ascii?Q?YQCzghdgm3/8MfdsTDLcPEevuOVJIziOb+TAVZHm5liU+srA+HnNWNaE9wts?=
 =?us-ascii?Q?Y4VM5J6ZTUmkKZkqVbNGt7k/a4HYK7yf1/E0e7l3PphVAUIghf9ElO1L8elW?=
 =?us-ascii?Q?5FAgtuUa9ovgGoaDDYfYw1+baXSVqddpQ6OmEARlwbnHeGQhuBAczsGs0YY8?=
 =?us-ascii?Q?WMSJ7003vLvNwdg3VSDfOBWffW2AnB7gcqlGustxUMzT0hHKvL++lLvv29Qb?=
 =?us-ascii?Q?YJWvQ3h5WSyjFoCNHr2LI0/21w1VaOT1jwUrKUab6u07D+xYhZeaibq3tkqA?=
 =?us-ascii?Q?SM/8VIZuGaum+YxC7wgd7OQTszQ7kLSd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2024 01:58:16.3653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d0ea26-d839-44fc-8202-08dcb2969342
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7773

AMD EPYC 5th generation processors have introduced a feature that allows
the hypervisor to control the SEV_FEATURES that are set for or by a
guest. The ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
that SEV-ES and SEV-SNP guests cannot enable features that the
hypervisor does not want to be enabled.

Patch 1 adds support to detect the feature.

Patch 2 configures the ALLOWED_SEV_FEATURES field in the VMCB
according to the features the hypervisor supports.

Based on tip/master commit a2767e7f31ad ("Merge branch into tip/master: 'x86/timers'")

Kishon Vijay Abraham I (2):
  x86/cpufeatures: Add "Allowed SEV Features" Feature
  KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/svm.h         | 6 +++++-
 arch/x86/kvm/svm/sev.c             | 5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.34.1


