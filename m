Return-Path: <kvm+bounces-70108-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMygKaJ1gmm+UwMAu9opvQ
	(envelope-from <kvm+bounces-70108-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:24:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2240ADF335
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 83F5530309BA
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC9236F402;
	Tue,  3 Feb 2026 22:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KSVOMMy7"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C18341ACC;
	Tue,  3 Feb 2026 22:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770157463; cv=fail; b=EAu1A0RE59LAZAbIuzg/p3CNLEXBkyIK5chgLs9/Pp5QHrREfdhX9mJOND9UiZplf8Ow9Ki/7u7vq+2rsmFHi3to8w2xqGhCX5BILZs0OyvYqOnu2gT/wwKM60+cn9N/2w2dPYeQHrbXVWg4PqZwfbE5eOu1Jv3a6PScSHcjjgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770157463; c=relaxed/simple;
	bh=x29U8PS9Be6HTkwdVLISyCqwlyXVXos2X3xnVjVYBrE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cRa+jF363U/vwW7c/faUpJu22P0iYRGzCJijulTxJ+egViZfbVcoO/n7ByxKj6QCaFzhTFFAL64XGTcRE5fQnXzge54FwnWrDSaXVU3Bwve6Tqu47zlLi17qiPQacPHqRoMKKP3IYVuxBA4OSwZnjrVVcfsqplRkf8dAzMjnhuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KSVOMMy7; arc=fail smtp.client-ip=52.101.62.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ka9gqpX4M7Z+yjAHuxUQO6n5MjZivIIESVK0b7QTuzaX5mzOCJ5qzGzUVKPIZKVSF4TG6pdo3Pxr9S/L0kDvAlQXeYvXpqYEYvocB75ujQkhhcNbn8xlDm3RHwn93CBErYpE/ZAfBjNSy8X30zIf4AM7h3XNJoLxLXdOwS5rgCzWLoJ3Ds0AAevMuL/G39Im1V4lEaXG7Mc8rKUhpQ7qtRj0twE8dt0LrkTiF94p66gaEHJpne/NKQARjRjH5iOo87ekdlzLpvakmF1hdFkllAYKiW81XT87yg37ykEuWT4MBmnR2iMS9Iz07CuJ4vrdSR9Gr8c+jhWnrg59FZqyrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbygNZqA2Tw+GfFs6emQJHlIXgQkNRwnfHuHjsTFn+Q=;
 b=P9D9ogP+i5V9qYUhL0FIldZZOGYa3kmcHUgxqZhdejh10hFo5BLtNoX8mVu6wITIfygeJzsk4xPy0sVDH1WIhwGPIeiZUB/XWY13ZaQG9HXfclqM9QyU8HuHuFFwVXkmx6Y+OxvfyME5Jab/MhnqhnfI4plD1h787BCrNp+nmbjclPN1PuTdquh3SDSLtNPJUem79NNzxgrUg6qai4NJ5u50g2ojWgXXGJmOTnErraaKMMERIkh+EVnwbnkOGXb8JKx+2v3oGXfN4k9iAeyUNvY37kQn4j5NVTduIeiE1hSMC60by/xgYSVw2KjAmn889PiLwUn1zhT2+bQoZxsTjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbygNZqA2Tw+GfFs6emQJHlIXgQkNRwnfHuHjsTFn+Q=;
 b=KSVOMMy7zzggs/hPmnf2HE4i9M+IncAVoMSFjI4heWf2wdTiuJxn7ngSLGfUHfzyfLjKF2fDuTZPlyPXm8GntY4kVP/Dt8aFQJCs2VV36sIgWiJsLxQJHW2Idu/BtX02gVYupJ8K6TtBnd7TpfervTrXrASBL4vaJIcpDsFOG+M=
Received: from DM6PR13CA0025.namprd13.prod.outlook.com (2603:10b6:5:bc::38) by
 SJ0PR12MB6807.namprd12.prod.outlook.com (2603:10b6:a03:479::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.13; Tue, 3 Feb
 2026 22:24:18 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:5:bc:cafe::70) by DM6PR13CA0025.outlook.office365.com
 (2603:10b6:5:bc::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Tue,
 3 Feb 2026 22:24:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Tue, 3 Feb 2026 22:24:17 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Feb
 2026 16:24:16 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Borislav Petkov <borislav.petkov@amd.com>,
	Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, David Kaplan
	<david.kaplan@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH v2 0/3] KVM: SEV: Add support for IBPB-on-Entry
Date: Tue, 3 Feb 2026 16:24:02 -0600
Message-ID: <20260203222405.4065706-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|SJ0PR12MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: 158693e3-234a-4ce4-1551-08de6372f875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8yuwoabkh393Ns5FapkrOzODjVznkGaBNK683NcFaTw4hIe3yhkBMO8mqLiC?=
 =?us-ascii?Q?I5+csr3SfEeYHHx7RoJxm86iyEfjy8Ja84IYycCbIhLxP5OuLxc6LqCtmXnJ?=
 =?us-ascii?Q?L+pmoEBXCc85u1hZs10xPA7U6/N90it3QyrvLpe3vQnlKsDdGky4B20Mn+6n?=
 =?us-ascii?Q?mfH+88HQ4cMeJucdxZqGS0mF1spwEztYy1JMSVgiHDO0AY4uKiEq/qMd2K/C?=
 =?us-ascii?Q?lDXLjMypBRCU1DoOuc2w3rUlCAWE4za533I3ptqOsZxDERJkgnN26ca3DUUf?=
 =?us-ascii?Q?WEFyi5t/HYHB3mpSamkDi+nSf0tWQ6fYSjzW8P03fbt3NQA9/S4kGdSxEPzz?=
 =?us-ascii?Q?5qqMUrkUenFT+oXQlpcbd+hmDuNzha69+lUgr4tNIewIumzMqZX0kx6bx0oO?=
 =?us-ascii?Q?xioQepU4m3jvqDvQkzwOuWPz7Tg6LlXgvPrhqKhz4aiajV+QVPf4tGwZTcMk?=
 =?us-ascii?Q?NGONg4BEqBuHx98oR8groKgZmJe78GxQHGW/bUeFJYmBovjmEp7fS1qjS9nk?=
 =?us-ascii?Q?ykknkBqzbfVbb9Ty2PlI2jxXEVKm2pLs2U8YMccZvarnq+txHbBmvmBaZL6F?=
 =?us-ascii?Q?qdWoIhJoM/RcWktSlrjsJk1Y8qTAoFCWoF5cRECHk757p4SnOsNBfRFwQvBq?=
 =?us-ascii?Q?j96W5r418LjZ3CfCNLZNJ7mz46nFFkiaPQGHRaaXxDHXClUo/a7/y8/TB5fb?=
 =?us-ascii?Q?xstZhHUeaKPCk5D7h+6K0cz2foykZQOR+lBe+4ZHq+GIJtgXPIdKCu9OJlf2?=
 =?us-ascii?Q?Hh9T6d62grcPTE8cWSomvxxtVjrxqHRk+XflXKeHQs9++nxGsYlWfBIcBKYp?=
 =?us-ascii?Q?z+nTqbTMhSU0sz1gMvBot1e0Ik28Xn1WX6qE3XR2MbvQZeCCMGh0+6DJUAPd?=
 =?us-ascii?Q?oIIfRvHwtmaqOnF8D5vDvpMVdNy3hKh7Q9qD67hql1T0vCw6YY6ZHOjzConz?=
 =?us-ascii?Q?FwOCAi6O3PMc5hMst4jqnUxYvOP7pDjF//kS7T4c/szS9nbfaZA8r26jZAw0?=
 =?us-ascii?Q?NsIeq3ARkM3wOKVINYEX51thqRwXhN8nqEnkIe8JjNLi+9Ue17kMb/QFxASq?=
 =?us-ascii?Q?BvyK7m29Rsi7N47cEV2JpBLn8YOQlqkHVSmsAO8tx6X+cYaxkj3/JHRLNSLl?=
 =?us-ascii?Q?J5X2Twk8qxBGAPMG1aeOpQ/ADMmZL8Au9OwawdcZ1eYkzEYhHYbgFAm7mOVN?=
 =?us-ascii?Q?lzkED2uLQEQTKxN3vzl+taUVuJ7AIMhZVZQZ1xiz9/RyP6NbNKDXsO2HYF+s?=
 =?us-ascii?Q?Q2oF2GDrMry7W55F7UfB0NGa3iUhyrn+q/1Ov+fTc6Kt3iIRUCvB36/yavVg?=
 =?us-ascii?Q?YtdOge/Jk3WCppO0KPeEolPK5xkxMBCRYXrTQPjEz+cDpyzDRWxvWVeROylT?=
 =?us-ascii?Q?07RmrrDYm4kEjzmNPsniLyE72NAn6v2gWKK1kBzpeS1gQRqyOpO1cR2VQYDf?=
 =?us-ascii?Q?RNG+zf6rXuRXKBUVhEgZpJlgU/Zcu1pU1v6wCoghMmSOdsN3tnt5yKKW+spO?=
 =?us-ascii?Q?9NvxovkWNxvsYVOVYswgjMG9xTYvrdp7pM782rGDCLgCDESXwH6Eg20+AaBg?=
 =?us-ascii?Q?O2a4XuKf9mmLlG7XyFHXtejldB5dx7aHPyhD4v0fs4ONgmy8c5rjSD+KPOs6?=
 =?us-ascii?Q?x2Tgfz2iufhl1V+NwUb5LZowp3p9yOS0j4TrFDzUpeqmyDJyFCr6Qx4e0MCf?=
 =?us-ascii?Q?KN9q8Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Q7e9D+Jg/U7/xtRNGLpBLeqw0vTG7bpTM4e1M5JbFgM1t/3gSH5AaW03u+ksRvr+Ph/2yCC2M1FwT4IQTs2Q0sHOMdxeZmDThaVrUuFQaBB8RuDduYbxS+9XeGGyTgZJJAJO9QRd4P8ub1rP5BU7cYqatlAWGrFfjK+pvlOLTvlzb8O3PqGsxBpELlY/HmfmDKyivZl5d34uTFdRwvT9+MyTjfO+9ZcplFuZkk2x9oAI1ep2hduyRGV4w+aa5T9ZMVedl31vQUYO7TXXBFBq5Iw9NFX2cH/wcc/K5+10hxZI44umWmC8LQruTSxX//sQe7jIz/YeS6Qbn6+FBv+uAmaB3DcE3WhFmg8WorhbRyIPaKLA5oup6czNnWKckpap5f0Hs/AnW3aoeGiAM2tkqW+HKEuzp4gACfWo+r/Q29QG5iCFSZ+NsLE86Z+o71zw
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 22:24:17.8303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 158693e3-234a-4ce4-1551-08de6372f875
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6807
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70108-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 2240ADF335
X-Rspamd-Action: no action

AMD EPYC 5th generation and above processors support IBPB-on-Entry
for SNP guests.  By invoking an Indirect Branch Prediction Barrier
(IBPB) on VMRUN, old indirect branch predictions are prevented
from influencing indirect branches within the guest.

The first patch is guest-side support which unmasks the Zen5+ feature
bit to allow kernel guests to set the feature.

The second patch is host-side support that checks the CPUID and
then sets the feature bit in the VMSA supported features mask.

The third patch is a trivial #define rename that was a result of
the review discussion from v1's 2/2, to clarify SEV features
that are implemented in the guest.

Based on https://github.com/kvm-x86/linux kvm-x86/next
(currently v6.19-rc6-182-ge944fe2c09f4).

This v2 series now also available here:

https://github.com/AMDESE/linux/tree/ibpb-on-entry-latest

Advance qemu bits (to add ibpb-on-entry=on/off switch) available here:

https://github.com/AMDESE/qemu/tree/ibpb-on-entry-latest

Qemu bits will be posted upstream once kernel bits are merged.
They depend on Naveen Rao's "target/i386: SEV: Add support for
enabling VMSA SEV features":

https://lore.kernel.org/qemu-devel/cover.1761648149.git.naveen@kernel.org/
---
v2:
     - Change first patch's title (Nikunj)
     - Add reviews-by (Nikunj, Tom)
     - Change second patch's description to more generally explain what the patch does (Boris)
     - Add new, third patch renaming SNP_FEATURES_PRESENT->SNP_FEATURES_IMPL

v1: https://lore.kernel.org/kvm/20260126224205.1442196-1-kim.phillips@amd.com/

Kim Phillips (3):
  x86/sev: Allow IBPB-on-Entry feature for SNP guests
  KVM: SEV: Add support for IBPB-on-Entry
  x86/sev: Rename SNP_FEATURES_PRESENT->SNP_FEATURES_IMPL

 arch/x86/boot/compressed/sev.c     | 7 ++++---
 arch/x86/coco/sev/core.c           | 1 +
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/msr-index.h   | 5 ++++-
 arch/x86/include/asm/svm.h         | 1 +
 arch/x86/kvm/svm/sev.c             | 9 ++++++++-
 6 files changed, 19 insertions(+), 5 deletions(-)


base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
-- 
2.43.0


