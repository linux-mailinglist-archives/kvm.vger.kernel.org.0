Return-Path: <kvm+bounces-25204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F679619A8
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 059B82852DD
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFEC1D416F;
	Tue, 27 Aug 2024 21:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WSx0/uZZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A801D415A;
	Tue, 27 Aug 2024 21:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724795992; cv=fail; b=uDbpEpLQN42Xj4FViSdA2NbvqQvoqX4StsxGWMRz93PZF0FU0qFteiyNmc9KZ3bvHlOCaXfS5m/ucgIKwOpzmIK2l55+kcVgH+h1TpqOnHK7vngxmBTPNde9ttu3M7CTCgjeEpUPeMPB5x2co4anyxpau0oC/pq8bztg8tu/IoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724795992; c=relaxed/simple;
	bh=EKdJdVl+/au4iJtqr2jdUJ9T5YJvxhViWWZb9Pp4OWs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UrXKDfrNUrdx6onjR+4zcp8kHB8nvoEUG0wb6nXvHu5gZWYt4tjb3bTbBa64E4IurSPQUNQ7s+b+yG76Lvrsjfqf/pguE/nt5CQuUJIQBilYdlcwuI2DH46HQy1t3VrMIFA+DZIacFEiHyTi5V5qYr2FThPL4fLRsjJLMgRR5hA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WSx0/uZZ; arc=fail smtp.client-ip=40.107.236.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZAQRz+Iq6KPjKxCew1FN9xeTC+hz/Bz/WbHf7Cb6jfX+E32h+vjmBYtZ8f2vNqsTLVcmrsDPzSGCH29nnmMjPg3vgTyShCUJV4aKVniAw8zPNXPyJoUuCYAiAs7NcW9dyUD92jdRikR2HMkbdTw6lO+XINHs8aHdaXliHJ1nDheQXxL9A2sV9zJjxw/88mUEf+MupDaftMlHGsdFGn268QqLPVuqPD3rI+b8bndFaDb0LiHbBSvqjLyEKNxpay60/HpsUjraJXg3nsKQcFtD9vErtItaSMK2dJchugxBeWeBILyosidZA0abqsEzxAp0JLAnENWMUFZXooMBjraE2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJC7XSKhdd7thNdK+sjbO4AAoN7ITpvePUn2PW8hKgw=;
 b=YSSjj0nZkgTUoSdj66IbwUO9sVvYXR6kYV4w1LPPRAxC166tNnQSjUyupqq5hY3oHaGy1E/0eh4DlQgaz0OpF4O4IBIXQo8rNA2IrA2IiZ3i1bgHDbK9ZhVhV+O9FJyhVt1hwYe9g5c4uItbC/cM2ZJGWQwUTf4l3OMWdjiXqAQhjKXUk9yyUT7CLVtlwMOakcWlNVhRMD6er+ggiVOlcgx8wZsJwoTVZB53Ti2kmwmiWax+DV0ERgZxC/FWa3k5dJ2Exs0ykAs+2GcqmYZUSP2w/iWTxyXY+h8q+yCfwOyxJgLDOYbx+9+gWGpo80pRxlFRSfoqlCkI7lKJDKAIHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJC7XSKhdd7thNdK+sjbO4AAoN7ITpvePUn2PW8hKgw=;
 b=WSx0/uZZoPtlllankGKYvZXCQanig+uex74C3XGSdvoc5MJD53KvFPfSZoE3ztvicqMHx6ijYQiD8n+8gjiRhMkFR1OT9GqyhuGRe5nRSdUm66Ve1Uzj5VBBaEEu2o25rFUCqLdZEyEAeUhbvkU7OQsRaQFTakTCc1fp2XYLqm4=
Received: from BN0PR03CA0038.namprd03.prod.outlook.com (2603:10b6:408:e7::13)
 by CYYPR12MB8752.namprd12.prod.outlook.com (2603:10b6:930:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 21:59:47 +0000
Received: from BN3PEPF0000B06B.namprd21.prod.outlook.com
 (2603:10b6:408:e7:cafe::29) by BN0PR03CA0038.outlook.office365.com
 (2603:10b6:408:e7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20 via Frontend
 Transport; Tue, 27 Aug 2024 21:59:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06B.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7939.2 via Frontend Transport; Tue, 27 Aug 2024 21:59:46 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Aug
 2024 16:59:45 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Joerg Roedel <jroedel@suse.de>, Roy Hopkins
	<roy.hopkins@suse.com>
Subject: [RFC PATCH 0/7] KVM: SEV-SNP support for running an SVSM
Date: Tue, 27 Aug 2024 16:59:24 -0500
Message-ID: <cover.1724795970.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.43.2
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06B:EE_|CYYPR12MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: 906b25ad-0c1f-4872-e912-08dcc6e390c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OEpnBu33TdRZHF2J8nAd6DKlhvrYTGmuscBqi0GkoreMnwpv9TjiTAZgunjL?=
 =?us-ascii?Q?7zZFkGXLgNGpdy06dCT9KR9W5k5RlO8SnvGHWcUiZT4NUAnRQwLUZqQ+e5dg?=
 =?us-ascii?Q?h1djG36rih8GRwLv67XKmz11wCV43BxyvqCMMmMmMzOF790VXmlSEOmweBOd?=
 =?us-ascii?Q?4Vs+aiN345epmstaXpONIeqneffuZlRAmwsYQdBH4ZzTuZ0N/fU5UU5dCRK6?=
 =?us-ascii?Q?eBOjNydw/biuhMxrOIqXZZpJeDYi3JYXczjqpudoLRk1lG6mw8XOK3//lLAN?=
 =?us-ascii?Q?PWvnWd24vBB4t9QB8SScmDLDTFcnO5eyN+PKC0jGnx666VgJjucka0+7X9oE?=
 =?us-ascii?Q?rlAlQ98xqZOPlD6uY54zoOQwGAEPYQTtXzOIObAe8NLBXYca0VLLumvRf58c?=
 =?us-ascii?Q?ZRkIvo7ko/OzCL1/YI+O+mK2jVG9UbQpWYzfuMBR4V3UWSGAsuFMVQt+WxEA?=
 =?us-ascii?Q?8/AE3y9esuPLqRHs2ztqHtoDO6agKoGGbeTXel9OPT8SqkPIRc6wFFjo630I?=
 =?us-ascii?Q?Xo9vegoLobLaHsOmNLmb1VLxgkU+EHXGaMRW5YL3V1M+rlFtqmH2wCQmAj+6?=
 =?us-ascii?Q?PH36/ms8npmVpPh5CHGsaDYNkdlDAapYuQKNS8y7arhKfsCk2tjCa/lgwM5t?=
 =?us-ascii?Q?MdXvFJx1wNwmMSySZorvTsEXCeU8cWqklq8N321P4FzWAc6/RVnxLwsJliuG?=
 =?us-ascii?Q?tOCF6JL5CNuUTtUFs7ENiPhiNzV0If90a014wudP03U5zSe6RDxvlRMQAdAm?=
 =?us-ascii?Q?M0gjzyV407jsRkCCopi7MqbajRtfHVXDYeusW8OLih0ShEuy+OncVVVGrMSn?=
 =?us-ascii?Q?flu+7hEenXtsmsgu+XfothXkypR5lD/KZDz/pBg9BqPY7jJe1e6VBN5XqmRd?=
 =?us-ascii?Q?XgO+Ko+I6r/wuge+B30/67KTgDEdSE8fXniOyw7dNBpwqD9Vff+voPbSFSwB?=
 =?us-ascii?Q?mzu3rwHSy5AWX3dbpDuLGQM4ZhdKfS9BWo3PH8l/VT3D/zKN8II7zrzlMLu2?=
 =?us-ascii?Q?ndfV+KsSSIqwwhS98BNPQLloo5qzEUVp/IASlg+IYrTOUusctAp780TBRDmB?=
 =?us-ascii?Q?aGqnDtvTm+Sn5wD66O1jgupVZIjJ7lq+9ahlJYA4KoF3cC8ID9XLUHXMGnBN?=
 =?us-ascii?Q?YQcAA9lFFdou5c6HVYWnIqU0k5hJSQsTl1eIHgQ26AGGb0xxaOmu/RK2QPJu?=
 =?us-ascii?Q?X7Fyk/+CE6BgKtWX6ELxoxVgq5kaNGdD/b8rHTN0TTkZ+GhmKs7YNWe/ZEM5?=
 =?us-ascii?Q?gw5cH6b8348XQnXNc3UCr+wVkr4Euo9PAkAtE5EQsZzQKscf1wseRkwQpAF5?=
 =?us-ascii?Q?fNVlfiKLMXwHDI/blNMmszhEaqQyq0lstktt3LZst7cYJDDRgrdlnilcPslX?=
 =?us-ascii?Q?ZNrYbwwHVO0iE3TgSIbZUcO2+MIpGxaojYaNXk/eTauw9x8l7JGnUl7YWh/0?=
 =?us-ascii?Q?wjjVR1uFMVC+bJjMphjYMu+zBqtU4t/4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 21:59:46.7489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 906b25ad-0c1f-4872-e912-08dcc6e390c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8752

This series is meant to start the discussion around running a guest with
a Secure VM Service Module (SVSM) and how to transition a vCPU between
one VM Privilege Level (VMPL) and another. This is Proof-of-Concept level
code, so definitely not something looking to be merged.

When running under an SVSM, VMPL switches are needed for validating memory
and creating vCPU VM Save Area (VMSA) pages. Going forward, different
services running in the SVSM will require VMPL switching, e.g. a virtual
TPM service or Alternate Injection support. Therefore VMPL switches need
to be as fast as possible. The implementation in this series has KVM
managing the creation of VMPL levels and transitioning between the levels
without transitioning to the userspace VMM.

Going forward, the userspace VMM may need to be aware of VMPL levels. It
may be necessary to transition VMPL creation (AP Creation at a specific
VMPL level) to the userspace VMM. But keeping VMPL switching within KVM
is highly desired for performance reasons.

This PoC code does have some restrictions. For example, when running with
Restricted Injection, all injections are blocked as the SVSM is not
expecting any injections (currently). This allows for a single APIC
instance for now.

The patches can be further split and the change logs improved, but wanted
to get this out and get the discussion going.

Implemented in this RFC:
  - APIC ID list retrieval to allow for only measuring the BSP and
    allowing the guest to start all of the APs without having to use a
    broadcast SIPI
  - vCPU creation at a specific VMPL
  - vCPU execution at a specific VMPL
  - Maintain per-VMPL SEV features
  - Implement minimal Restricted Injection
    - Blocks all injection when enabled
  - SVSM support
     - SNP init flag for SVSM support
     - Measuring data with specific VMPL permissions
     - Measuring only the BSP

Things not yet implemented:
  - APIC instance separation
  - Restricted Injection support that is multi-VMPL aware


The series is based off of a slightly older kvm next branch:
  git://git.kernel.org/pub/scm/virt/kvm/kvm.git next

  7c626ce4bae1 ("Linux 6.11-rc3")

---

Carlos Bilbao (1):
  KVM: SVM: Maintain per-VMPL SEV features in kvm_sev_info

Tom Lendacky (6):
  KVM: SVM: Implement GET_AP_APIC_IDS NAE event
  KVM: SEV: Allow for VMPL level specification in AP create
  KVM: SVM: Invoke a specified VMPL level VMSA for the vCPU
  KVM: SVM: Prevent injection when restricted injection is active
  KVM: SVM: Support launching an SVSM with Restricted Injection set
  KVM: SVM: Support initialization of an SVSM

 arch/x86/include/asm/sev-common.h |   7 +
 arch/x86/include/asm/svm.h        |   9 +
 arch/x86/include/uapi/asm/kvm.h   |  10 +
 arch/x86/include/uapi/asm/svm.h   |   3 +
 arch/x86/kvm/svm/sev.c            | 530 +++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.c            |  25 +-
 arch/x86/kvm/svm/svm.h            |  71 +++-
 arch/x86/kvm/x86.c                |   9 +
 include/uapi/linux/kvm.h          |   3 +
 9 files changed, 575 insertions(+), 92 deletions(-)

-- 
2.43.2


