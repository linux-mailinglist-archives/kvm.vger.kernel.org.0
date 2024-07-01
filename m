Return-Path: <kvm+bounces-20809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6547091EAD4
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 00:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8AE2B21566
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 22:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2DC171650;
	Mon,  1 Jul 2024 22:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ewMcn03h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA061366;
	Mon,  1 Jul 2024 22:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719873217; cv=fail; b=W32TsWlQy9p/pMuMFprobzANQMNr2AQo5SXBbLzvosY3j+wzbDxhZQDXtqlQoz1m1VHqasI/pHwzhiSCDtZxe9+sVa4V0TA5J2k2BfwrHwQvb2YyXd+rsAaxcLFU+sJf18Y/MY43GRNg4Mv625mNyASetywPJqQ7IrqnnYnGp3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719873217; c=relaxed/simple;
	bh=RBpmh9uAz2liCaWU3U74odaUU6W7p3WqnZmpyiqQ3Jo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=K7t83tbXuU9Fr3GwmxEXV341IJ6wq+dr/oIyT0nqzIKBNtjk1WUBvqYTZ1pvS+990Zv2RwXBcopJzDxGY5njvRgOR0hcwK9rgkW5t/q5eFNjpXtvxrNeIJjqrE8zUyO+FCKm1XtXhvxRJ6S3EwwOMA/RieOV9GyZno3wqmsgdqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ewMcn03h; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0rpA2gzg7v30Cv1cfrpPEgKUXVdPhbNuM2c3mqbUguuO04TFTvs6FCsZFbe3t2jw3mtlo1NXoIE4fRHSeBTJwlScyveYzAIgcY+j1R7un1ezLMnMhevqcO1EPtmU/SbTmRPUHPx1d9m4nw0fBofU1iaQzImNoB/BJsTFtqFnt+JRQ0AhUgIoMJkISTNsSLRwvzUIkXN7fTbM7+Oc4PCBOyk5DYlHmbb20IuK+Qztu24v1bczjOe35TM/Zqf3wCZNfb2SBpcwlj4sCr0h8qDtNlgmN5tUrrmveKAz8Rzm2L9itjJ4KfmLUglrCAOcbz6z9ROpKOmLpp3jhSs9rP0Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PmJQPF5VM8T5jNM7wIjkfPXedituaHY+j4u6cL4gj8=;
 b=aL2dGwz1Nz4LD76Es2Ottc4X5bomg5/dF5PrqCd3yiEMzY/xXa3W7pJXNPvIiWFEMYN/Rkj3LLLDixt3eYKmXluXeSN9sK6bNM7f+qic9CmB9GsbB6Tp5h7/AOE6euo2QfGVJb9P77VCym3DHtZMze3x1G7UnGxTu0VaU7BNhp2ejqVqY7pHFhfKeMrqIdcqmiyDYY1FqmdICV48TL3gjOxH4FddB5gzHRb0YZVsy5zX6R8iai9gaWPSolPBENmx+RiVuL3Hwn0sK38A5TLgBRTAZ6Jf58nBJmY+SkPTgxC/DR8v2taX2jINqsu1wU2EpqrtXGcXAcLOFjBmNqidvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PmJQPF5VM8T5jNM7wIjkfPXedituaHY+j4u6cL4gj8=;
 b=ewMcn03hOqTUh524OdT/dESLzg6dwZ+uGhj/8tm2n+rccnRY7xUpwHCDMmYv7bv6kMJZpFFwOoN6rijPjZHrjwLtkszcYSRZ76VFRROhUMwlBmWqEKaB9+BaPAa+j1DEuT4OeR/OSbyGczZcsxPEf1+c397KkWG4Bac4aHISncY=
Received: from CH0PR03CA0105.namprd03.prod.outlook.com (2603:10b6:610:cd::20)
 by DS0PR12MB9040.namprd12.prod.outlook.com (2603:10b6:8:f5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33; Mon, 1 Jul
 2024 22:33:31 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::d) by CH0PR03CA0105.outlook.office365.com
 (2603:10b6:610:cd::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33 via Frontend
 Transport; Mon, 1 Jul 2024 22:33:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7741.18 via Frontend Transport; Mon, 1 Jul 2024 22:33:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Jul
 2024 17:33:30 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: [PATCH v3 0/3] SEV-SNP: Add KVM support for attestation
Date: Mon, 1 Jul 2024 17:31:45 -0500
Message-ID: <20240701223148.3798365-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|DS0PR12MB9040:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a250f1e-25ae-4356-be0f-08dc9a1dd605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ezjuLk4HZT9HjylOiGCXsdXn8C9Hqw92INl9/Kbfbx1HZ4T8BG3IzJU86RL5?=
 =?us-ascii?Q?UiPmFDVz5rxavNJR7DSR4j+wsBZ4E5jzZ7oZv/2Q1RO8/yWfVolnmg2LqB50?=
 =?us-ascii?Q?N4feOdbYylUJ1E5CIbfLdV808N3x+3nnTFBxeZyiCaEqnxr6RNvC8Xx5zjEl?=
 =?us-ascii?Q?P9Ei4Z/WHeYiHuN7kNVSDpuubneIJQFzohFI8+Ud7jB2iRmMZghA4O9pw1JW?=
 =?us-ascii?Q?rBhRZAucaP1mahPSrKfc7VaJKx54xI2MQsDXguXN/rZdy3+ib5gup/r/OVq9?=
 =?us-ascii?Q?3kZHk3CtHRU4uYf9vJTton/QdsRUeI17T/qturmW/fcUaoguFP0haW2+DGCy?=
 =?us-ascii?Q?uGVfb/h33PSmFnQ/tFyV9a0Cvw0/lEYaKNSLOszpSKeKIRyHUv/SG2OBMOPV?=
 =?us-ascii?Q?oqoJVXp3TEnPq4ugX2U3zI6iC73wmqXei5HwQ9rz6h0q7o/XlfUIiuKw7xGZ?=
 =?us-ascii?Q?Im8qp1wbyTBiFCBMoPozxUbDVhi2oLrCjNS2ED0XLWnt5TzUjm/ntFNGdffo?=
 =?us-ascii?Q?yBrIw0JbiJXiLByU+ve1D5CVHdoQNE6YDEaLExc/GUr6XohnqKPqQI+xPtEV?=
 =?us-ascii?Q?9ZNHi4kjSCopKtXse19cpk7OaoqQgdTLQtMrhgpoKbhJyeYTKMi/QwZlMNQ1?=
 =?us-ascii?Q?t3UifjKj4qa4L3Dq/oxDmyUlYFEbBuBn+TVZRIMgJpWtjYST9X/3i0xjva3J?=
 =?us-ascii?Q?olNA5PcFc953jXJulu4YFWcQj0nu/mtT1Kri/5eqO9lNQb94NROJgT9CIEmO?=
 =?us-ascii?Q?PWL11qcSHDs3tPpQdvJfqlis6ym0UZYVxvLrnU4HzeQtlWfvHuNLCCy1wb2L?=
 =?us-ascii?Q?MzixZ0EQp2o+7kJpm5gAxceqF9xm53QdhJSMD3zh3rnUgHCDB2QRkkkcR123?=
 =?us-ascii?Q?wWdeqSvazn89UPyw1YBMUEjlv/B1J4d40XsvUIA0jDgZ6p+0IyFYAIntiItu?=
 =?us-ascii?Q?z5srSfYs/Zq9PB68E9y8cg28KLgQmCbEXcnMvnIAODYGXG/YmyibvIw8mxu4?=
 =?us-ascii?Q?jvxo+eiTIljlaaXSHB86Jv1nIF4JbpK+TwjWIOSng4DH/xZ3nUA4F3le5LXQ?=
 =?us-ascii?Q?0iXSa0lxxztscozc0pPQYkfNoXpypd3AmxZJTo4B9a8v7gs0SEMhwntT2mRA?=
 =?us-ascii?Q?BuEEIldi+svmRTr+QUXKeh4rk1rM7qPhHT0+BKJ+sv12o71XdOcehKfQnHcd?=
 =?us-ascii?Q?G6J77tCaxC8atpZxRVmlEz84KdmBrQaa66IHHvUQDjstvcsdlxFf4N2c6oD2?=
 =?us-ascii?Q?U1vcCEPfXx6gWC+Ifu8OpH6WU1WaQ5+40qeRTfNf6gtCc7StHNoF47hvqI7L?=
 =?us-ascii?Q?c9Qv2eEVS8B4IkzQQyVZI5OTw0Dwv9dfWVC5w1jvbXcuBAoWga0RQrWRJxEw?=
 =?us-ascii?Q?b7+kisBk8UaO8ENcNed4ptb65tHKjknyN+U/uZ+ZOFcDdxYmig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 22:33:31.4572
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a250f1e-25ae-4356-be0f-08dc9a1dd605
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9040

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-guest-req-v3

and is based on top of kvm-coco-queue (ace0c64d8975):

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue

As discussed on the PUCK call a few weeks backs, I'm re-submitting as a
separate patchset the SNP guest request support that was originally part of
the SNP KVM base support patchset that's now in kvm/next and will be in
kernel 6.11. This support is needed to ensure fully compliance with GHCB
2.0 specification and to support attestation in general, so I'm hoping it
can also make it into 6.11.

I've dropped patches 4-5 from v1 of this series that implemented
KVM_EXIT_COCO and handling for userspace-provided certificate data so that
there's more time to get the API ironed out.


Overview
--------

The GHCB 2.0 specification defines 2 GHCB request types to allow SNP guests
to send encrypted messages/requests to firmware: SNP Guest Requests and SNP
Extended Guest Requests. These encrypted messages are used for things like
servicing attestation requests issued by the guest. Implementing support for
these is required to be fully GHCB-compliant.

For the most part, KVM only needs to handle forwarding these requests to
firmware (to be issued via the SNP_GUEST_REQUEST firmware command defined
in the SEV-SNP Firmware ABI), and then forwarding the encrypted response to
the guest.

However, in the case of SNP Extended Guest Requests, the host is also
able to provide the certificate data corresponding to the endorsement key
used by firmware to sign attestation report requests. This certificate data
is provided by userspace because:

  1) It allows for different keys/key types to be used for each particular
     guest with requiring any sort of KVM API to configure the certificate
     table in advance on a per-guest basis.

  2) It provides additional flexibility with how attestation requests might
     be handled during live migration where the certificate data for
     source/dest might be different.

  3) It allows all synchronization between certificates and firmware/signing
     key updates to be handled purely by userspace rather than requiring
     some in-kernel mechanism to facilitate it. [1]

To support fetching certificate data from userspace, a new KVM exit type will
be needed to handle fetching the certificate from userspace. An attempt to
define a new KVM_EXIT_COCO/KVM_EXIT_COCO_REQ_CERTS exit type to handle this
was introduced in v1 of this patchset, but is still being discussed by
community, so for now this patchset only implements a stub version of SNP
Extended Guest Requests that does not provide certificate data, but is still
enough to provide compliance with the GHCB 2.0 spec.

[1] https://lore.kernel.org/kvm/ZS614OSoritrE1d2@google.com/

Any feedback/review is appreciated.

Thanks!

-Mike

Changes since v2:

 * Re-add 4K-alignment checks for req/resp GPAs, introduce an additional
   check that req/resp GPAs are not identical (Tom)
 * Relocate these to checks earlier to the common sev_es_validate_vmgexit()
   helper for consistency and to reduce duplication.
 * Slight clarifications and grammar fixes in commits/comments.

Changes since v1:

 * Fix cleanup path when handling firmware error (Liam, Sean)
 * Use bounce-pages for interacting with firmware rather than passing in the
   guest-provided pages directly. (Sean)
 * Drop SNP_GUEST_VMM_ERR_GENERIC and rely solely on firmware-provided error
   code to report any firmware error to the guest. (Sean)
 * Use kvm_clear_guest() to handle writing empty certificate table instead 
   of kvm_write_guest() (Sean)
 * Add additional comments in commit messages and throughout code to better
   explain the interactions with firmware/guest. (Sean)
 * Drop 4K-alignment restrictions on the guest-provided req/resp buffers,
   since the GHCB-spec only specifically requires they fit within 4K,
   not necessarily that they be 4K-aligned. Additionally, the bounce
   pages passed to firmware will be 4K-aligned regardless.

Changes since splitting this off from v15 SNP KVM patchset:

 * Address clang-reported warnings regarding uninitialized variables 
 * Address a memory leak of the request/response buffer pages, and refactor
   the code based on Sean's suggestions:
   https://lore.kernel.org/kvm/ZktbBRLXeOp9X6aH@google.com/
 * Fix SNP Extended Guest Request handling to only attempt to fetch
   certificates if handling MSG_REQ_REPORT (attestation) message types
 * Drop KVM_EXIT_VMGEXIT and introduce KVM_EXIT_COCO events instead
 * Refactor patch layout for easier handling/review

----------------------------------------------------------------
Brijesh Singh (1):
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (2):
      x86/sev: Move sev_guest.h into common SEV header
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event

 arch/x86/include/asm/sev.h              |  48 ++++++++
 arch/x86/kvm/svm/sev.c                  | 190 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h                  |   3 +
 drivers/virt/coco/sev-guest/sev-guest.c |   2 -
 drivers/virt/coco/sev-guest/sev-guest.h |  63 -----------
 include/uapi/linux/sev-guest.h          |   3 +
 6 files changed, 244 insertions(+), 65 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h



