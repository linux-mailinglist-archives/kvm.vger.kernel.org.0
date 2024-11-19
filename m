Return-Path: <kvm+bounces-32051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB349D2751
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:52:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D675B28FE2
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 13:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659AA1CD200;
	Tue, 19 Nov 2024 13:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HhyFFXNu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B911D1CCB53;
	Tue, 19 Nov 2024 13:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732024255; cv=fail; b=BCaqi9YYNwvjIngMN43PdXtjXDI7nZSHP2ZFIf9RP5PNQUijWpPYz/RHsiZGwcsMpQpki8G41J5Zi8VgOrgpQ2JhH6u28wmlii2C5gW174Xf/ynQpc4r7ikhX4m6eOp7l3aXSyaqXfZ9VFAFQm/MhBEzXcI+fvJdPE3O5Ru5dA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732024255; c=relaxed/simple;
	bh=5/eA0HpsVgiqAlj1Lo+CTunI3Xco6f6ijNinSP5CYus=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P1mAzcwgFd3/dmUmhIKoM4SNf7UOIn2HHdsfGtHvHOOts4w4/X/oqCkfpEjHypXESUfjvxtEpVLiQlcKAiItNUiWCNpRLLmCN002XXUE0i9gKm1zFTEYjRzjvdeAOXnbQetQf2Ll16/8dBElJMDp2I7wUNLb8U2R78eSVuYKdDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HhyFFXNu; arc=fail smtp.client-ip=40.107.102.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L4EUbRc3fg0D0q73T6uXbO90Gj4LJjAOHAPLIdbmqkG0JNBqhS7qi8n1+uWWX9bqFEe2pbUMStGqWEqXxi30c1FG1XywlRWSnuA1GJi6NpsuMPevqznPTu4owB/jL3jMAU4/8FmsFu68Gc8up/QKhj2XTROUvlAOxTnXL2Gvc2vNKyW1reK/2wJbePGQwFGdFfJfehFarJ+O8So0H8R7mJSv3V85cL2I0YUXfgF9Eq+K+c30AzwBb9f9EXIrepHtNf5KGrFtGIReADqXSm0lwh5nxLburon2Q0JnumcOiwnbTHnCpFnRl1WK95qki7XBO/vHW6qpZZCgKmsO8YM5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0vl9T1I2vpykVdI24rWAG4S7AxqZ/gNNGKqysf2URM=;
 b=lDeBWjVI/kFHIZJMLzS/dQQ+YaKZDFasCrjQcs9/Saf4gO38fQQCE5xxr3k4q9gKK+k0iNbA/C7aPu/9QYxHERQNnSbbtTBIZIsdE+WXb/PhFfN3/fZxiG6BZYPeu8aOBgdT3Ncq2SGMp88JyIShfojtxzk+1ozEeCTCnc8bgPjyyB+AcaQMpIYPSBS6v3+jRj4IzcFaQbyx3bcXf5z1JPSCDwgz5hEJvv1gHpRjTQHF58rpMOBHYWc0ayePceQRl39Iw0Ez9OEiCQW0tNlZ3/Le2BUo+6ea8rZMqAHimJxUfVnqOQitYLUSGksLitNwj6rkC0SQqnRoZApM/v+HZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.12) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z0vl9T1I2vpykVdI24rWAG4S7AxqZ/gNNGKqysf2URM=;
 b=HhyFFXNuoGFUqA5iZoEGgCfYefCeO0BPGtLY+7BnetCKyQmIXT9eoRJaDHE2/2qa/DDpLEwC29C/0U/Vnjb5Ly/1IL2hEiIj7hkAy6PSfc8elCetnrbLHXlhRCvLNVad8rGnB2KIVmdnR8sYGkDJ5VMk9HIfY/qqoEXeGNZqdWU=
Received: from BN1PR14CA0023.namprd14.prod.outlook.com (2603:10b6:408:e3::28)
 by MN0PR12MB6127.namprd12.prod.outlook.com (2603:10b6:208:3c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Tue, 19 Nov
 2024 13:50:49 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::93) by BN1PR14CA0023.outlook.office365.com
 (2603:10b6:408:e3::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24 via Frontend
 Transport; Tue, 19 Nov 2024 13:50:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.12)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.12; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.12) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8158.14 via Frontend Transport; Tue, 19 Nov 2024 13:50:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 19 Nov
 2024 07:50:49 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, <dionnaglaze@google.com>
Subject: [PATCH v2 0/2] SEV-SNP: Add KVM support for SNP certificate fetching via KVM_EXIT_COCO
Date: Tue, 19 Nov 2024 07:35:11 -0600
Message-ID: <20241119133513.3612633-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|MN0PR12MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: 35c45b5b-1c86-455d-2529-08dd08a12d22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9uPcT8d5uJ8JcNry3xf0e8scdB1YGcrFzk0sJD8u5adNAOfIJGIsxSwBo1Pg?=
 =?us-ascii?Q?2/RujebUMcMIRKOxlhdDvBu+cA4oQR87p6GpjoKHwkAhq4w1XEN+63aSXO4K?=
 =?us-ascii?Q?EBo4xQcnDRnfVgSNLt9QYdpZjIojSoYWmwQG9dnc1TAQafAFSmdJpewZaIXT?=
 =?us-ascii?Q?jAQM04dLAVvcRG5Nq8eYA+VaZ/MfVLTK5W/3GBGRGp0wzO4eReRLdUKgMoBi?=
 =?us-ascii?Q?PJMZqsQ8Hv2oZ8MXmDyHH+QzqaRGKC/J3xOe1UjEh0yelbdb57N9+6+tcHgb?=
 =?us-ascii?Q?u19wPeRaeL0kORqG3BNUZS9H88+yTDERKOuQkNSMbnm6Dbyk75XuNXgTKdv3?=
 =?us-ascii?Q?KBViEp7E2vx1A3apF26DdZgVMtaXTSJcaOr1Tw/vU/9qJ/oqCe7FkTcFeUzO?=
 =?us-ascii?Q?w33gUl/0fuWJOiSPBjR2ZO9m/FrRaLZCUZ23EAabprOdL953YkffxYCcVZDx?=
 =?us-ascii?Q?dJs5fr/04b7ee3nJRFzKTGl5KLYtEq5ycTddSx77HW0I1JaW0zNGD09I+iWL?=
 =?us-ascii?Q?av5dAJRi3ATQuPy7yABghJqx/FsneIcX9godlZfH+Pv92OqKrWSAvJayeYat?=
 =?us-ascii?Q?6Acp6BITbCy3XwrVJA15b4EIrIHAozMRGhUl0f2BLtDUiKYzGhkw4o/p/Ouw?=
 =?us-ascii?Q?g2hxosBXHMLnnFtOtLTflBM9rWndjiN8Dlc6s3v3VGMv0Jr8XMMWHLjjjdl+?=
 =?us-ascii?Q?1PlLUaU8FpgL5Nll/B0yamL7DzMLAqRP5VBPoXd7LRTbRTL5TW1dlp204T1A?=
 =?us-ascii?Q?0iz/n1xEQqc2tIobJqAB8ZPpfvQg2BY1C9naAKl64drsgIcdv5ovVrFlRpBL?=
 =?us-ascii?Q?l2s0ShdeIYbH4xtXnh1A6j+Fw34yLGrRm1QRfRcA7Awur/yh50gOZ64f1DZJ?=
 =?us-ascii?Q?7RTrgE2/5HkS04SAbo9cj2htYzKYSlbn4qWdjq9pbUQqYN5XudXreR1ogL+q?=
 =?us-ascii?Q?RHsqaIYrQEMHwsdz+ZOZA89NxiW10k4BSphAEJOS0yhnCA+TwQe5QDWiIwdE?=
 =?us-ascii?Q?nyTOoyQxDXJF8U8viwTL4dkZf45mw5JKu49H4Gdp3oegWPunilFzTKkrXMWK?=
 =?us-ascii?Q?0mP3oocH+Mdbt/Fsnyy1/2BTPNlmFhGVyuFSYD13HzTqQF+rF5E65EhDEvIl?=
 =?us-ascii?Q?l/UCK0uP0fkPmwmn4Xfkee5rwXE5i09Pd8WmBv1SkVZ3oiOlMC7sQ8IoyAsq?=
 =?us-ascii?Q?2kt+nVmYIrMN4x15T8UwRdX02C/lqiVE6FpyqHQrX9hkB8DSTKP9ojw8hVkl?=
 =?us-ascii?Q?owHB7RVS9FUOcZNBIUAP6i1MVyG7K1Ge+NiHekEFmey+uAnxKl9nGx1VdcIq?=
 =?us-ascii?Q?TgX9SU9ON9drkeG8stldwBmVMk/UBga+DIDZMnJIqS+jL3Oc8JUuAJ0RdViv?=
 =?us-ascii?Q?jbpenes=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.12;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:atlvpn-bp.amd.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 13:50:49.5822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c45b5b-1c86-455d-2529-08dd08a12d22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.12];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6127

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-certs-v2

and is based on top of kvm/next (d96c77bd4eeb)

v1 of these patches were originally included as part of a larger series
that went upstream without the certificate support included:

  https://lore.kernel.org/lkml/20240621134041.3170480-1-michael.roth@amd.com/

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

To support fetching certificate data from userspace, a new KVM exit type is
used to fetch the data similarly to KVM_EXIT_MMIO/etc. Since there is
potential for more CoCo-related exits, this series implements this as a more
general KVM_EXIT_COCO exit type, where individual sub-types can be enabled
similarly to how KVM_EXIT_HYPERCALL/KVM_CAP_EXIT_HYPERCALL are handled, and
then introduces the KVM_EXIT_COCO_REQ_CERTS sub-type to implement certficate
handling.

[1] https://lore.kernel.org/kvm/ZS614OSoritrE1d2@google.com/


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-certs-wip1

A basic command-line invocation for SNP with certificate data supplied
would be:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,certs-path=/home/mroth/cert.blob
  -bios OVMF.fd

The format of the certificate blob is defined in the GHCB 2.0 specification,
but if it's not being parsed on the guest-side then random data will suffice
for testing the KVM bits.

Any feedback/review is appreciated.

Thanks!

-Mike

Changes since v1:

 * Drop subtype-specific error codes. Instead use standard error codes like
   ENOSPC/etc. and let KVM determine whether a particular error requires
   special handling for a particular KVM_EXIT_COCO subtype. (Sean)
 * Introduce special handling for EAGAIN for KVM_EXIT_COCO_REQ_CERTS such
   that the guest can be instructed to retry if userspace is temporarily unable
   to immediately lock/provide the certificate data. (Sean)
 * Move the 'ret' field of struct kvm_exit_coco to the top-level so all
   sub-types can propagate error codes the same way.
 * Add more clarifying details in KVM documentation about the suggested
   file-locking scheme to avoid races between certificate requests and updates
   to SNP firmware that might modify the endorsement key corresponding to the
   certificate data.

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
Michael Roth (2):
      KVM: Introduce KVM_EXIT_COCO exit type
      KVM: SEV: Add certificate support for SNP_EXTENDED_GUEST_REQUEST events

 Documentation/virt/kvm/api.rst  | 119 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm/sev.c          |  44 +++++++++++++--
 arch/x86/kvm/x86.c              |  13 +++++
 include/uapi/linux/kvm.h        |  19 +++++++
 include/uapi/linux/sev-guest.h  |   8 +++
 6 files changed, 198 insertions(+), 6 deletions(-)



