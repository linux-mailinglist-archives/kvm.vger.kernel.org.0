Return-Path: <kvm+bounces-20690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 758FA91C657
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 21:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 960E21C22590
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 19:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C266354662;
	Fri, 28 Jun 2024 19:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kxKeZecW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2074.outbound.protection.outlook.com [40.107.95.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F62D27E;
	Fri, 28 Jun 2024 19:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719601600; cv=fail; b=U3MecA/U85QpZDvFhpHj70ZQpCNA/b8xgBa40ej6RMBtPbm11eh3bP8uZSVWaWEcIJBJhjvka9awLvTsQkPN6dDoJPkrIjz97UVna2QwuBHZSiqqJGsYEShJXRLA9QABSi8qUhClASmMktTGOzeiB77+aEdwGE0rVA6ASmZhcm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719601600; c=relaxed/simple;
	bh=O4mP0hKRRp+U67TUPuIbeh2qaztYAX8CSkVLw9va644=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IA/NsmGqoodV383A3eNbuE9bD8cMCxd4amIuMut79Me0Cc+wZm17N3F1TKYDDoYZoBL9tNu82bbf9sXoiRMHfLztmI2Q/Kfo/gJTlWCTCb9wTHSiOaUW2Wu7ImBOyY2s6mISGm9vsT989PeQqpSElFr/Ne8X357FaimyxIUWLwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kxKeZecW; arc=fail smtp.client-ip=40.107.95.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mt88+3AfhV/EqDkxPrSJaJJyobq1J1P53zqooTySc+gWXzHMw0G5g9Uqe3Zo3wQRAoTaHsFhwBEaYn67loe4wO5dzjtMUSmp2+yeD3CgOMGOm8imQY9wE791yrzM5z2eSZkRYhnWR4VxrRjVrpY94LPn/z9+kLVJz3Fmznnx+lABTc9J9TT2RC3dYqnXCsYIaQgKO9X76fPldAhe+yN9gDxIN03ZIgTetbREukzACv8Ml+Slonw9VfvRaaf0xIhaJNamCQmag9syZwPKnAeGzGQtFCw21O08J0ZFRNa9pbw4Yl+d5FFEQw1V7qVhxmYJGQd26gIeOESAk+kWuAhP6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NOsa4Mm095MLyQ7NCM3Rm9AZJBkIk93daCFJU/eYQM=;
 b=Nx5GQb6OjyK00yKDdy78qmYeAIqM8tJf5cVgzL/3DmPEBnsb0AqxujiPaH8bBfqPUQRT9W9I3VjVx7PqphMEOqGcYx+jKgv8IrtLFfElMcsYp4v1uTR1wNREEJh8GefVJ/K5JQlnFUwuu9KEKpi6WvYhvcM3KETxXngsdVcmAUTSbZW8y2+2qDAXS5XTLpiLJbpcriA6VNf1CviLgTDj5cyfeAgQT43oeJlN5JE/+/7A1ZdFsIfs8K1FyktjFNk1E0qcMdfon4fGEK1yxqZ9PAg5qqflbxBUnelVWpVp4Cr4j+jeQWEKas+vKfb/4O3AYRpoJ3JgiicByiELskg6Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NOsa4Mm095MLyQ7NCM3Rm9AZJBkIk93daCFJU/eYQM=;
 b=kxKeZecWae+G7UaT5Y9iMlOjmEmbquOZzboosKTTuKlYEw1ibh4y2IF/WplxPXMmqQLWJZXREI2+5nEPp22bpW39Rk8jfugQQXhXi5eZSaEiJsQ6xUE8vXZglravMDIB3y3ZV+5UA/jzTBs5z95UqcZDvXITKD8hXENETdCkDGw=
Received: from DM6PR13CA0061.namprd13.prod.outlook.com (2603:10b6:5:134::38)
 by CH3PR12MB9314.namprd12.prod.outlook.com (2603:10b6:610:1c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.35; Fri, 28 Jun
 2024 19:06:27 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:5:134:cafe::45) by DM6PR13CA0061.outlook.office365.com
 (2603:10b6:5:134::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.16 via Frontend
 Transport; Fri, 28 Jun 2024 19:06:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 28 Jun 2024 19:06:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Jun
 2024 14:06:26 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: [PATCH v2 0/3] SEV-SNP: Add KVM support for attestation
Date: Fri, 28 Jun 2024 13:52:41 -0500
Message-ID: <20240628185244.3615928-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|CH3PR12MB9314:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e544698-c818-4b66-4304-08dc97a5697c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s+oPk8fkh7Ek76KwwMkK98Zxgw8otCIMsXGc7HB8zDOGUtwVxdiq1ZSZk65T?=
 =?us-ascii?Q?EdtQlpdKZ4ungg4/53fJC4B87AeJuxj/VhexFqvbAe8yan6FgGkQRDnL0MID?=
 =?us-ascii?Q?/7zPdqcodaShmF2Jiw73jnqcy+lwL5K/LZ+cIkgG1ItnGpIdAtHsV3ZktCOw?=
 =?us-ascii?Q?MH+KNZDfNtRWys0H7cDFN7cNJiQidg9aJMpqyVRlYDT88Oxhcp3FXDSIo/xE?=
 =?us-ascii?Q?J9PR3+x+8WHkasR+hm99tN6vzMIIWPrs3e0sGmGbWk1/QW74brVe3ancyrXl?=
 =?us-ascii?Q?/QxOGq6fWPduWxWJHBs9w73z1HL55COWWE4nQtGyfyWL7Z0qIH0X9tr84crr?=
 =?us-ascii?Q?f1YkkJlRLmStfIxZIiaiNzEe4gxPeTMZNTH62G1OPmMz5EV8MNsqaDUeRguv?=
 =?us-ascii?Q?Uzs0oAc7D+8dWBE7tLYFn3/CzbfV8k6J4ANebMdnrk+LEOdosXI2aAFA4cJ2?=
 =?us-ascii?Q?fnIU+d+h2IG5BcVgQWJWr0YATmTDFxoeoZPU3QO48xcZhidM488S9ivCfUS4?=
 =?us-ascii?Q?SbKAcXUiAgLdxYPSOxbyNduOp2QBo5Yoc1yFW3c+Fp6Hg83RFpaeTdC64zoW?=
 =?us-ascii?Q?DLafAVxfm5D30cCobgDpEjgNo9lP1zHVq8H2CBcSul/50Njj4gU2QXsYzijt?=
 =?us-ascii?Q?SvHLENgfNifhwUGLa2vr0INBGgtQN9bU35joHfD14j/ScuRiqtu4JdnEyqLo?=
 =?us-ascii?Q?WvlQ6sepaBODU+Kl6vDBMBDGQa3FpBgYu3NsOCIhKanWV6vS/YQjQejRg/bY?=
 =?us-ascii?Q?wt62b9FqVaHbce1NZb2uRzVw51SrNSj1CSpXWgU5mT/aN+9lr+HNkuT70uaH?=
 =?us-ascii?Q?72Ds4slFdtgfvUVrntoMFOApWhWeNb7tyqG3OiojtcxqB/Aimzy2NeRhwnPf?=
 =?us-ascii?Q?/GqXgCwrAPdl7QQbNWsPQwRlZByLMBoPGXWQI7CJ9si/Ti79W6wPNKzjTz0y?=
 =?us-ascii?Q?5XC4nebYhyT1ioq5fIfWxAgc+Sx+xMpBVNj2xnmkrWgkvr6PBwRx8Tk2zLMx?=
 =?us-ascii?Q?VEyvA4QzCZ9KW4u3Fye5o50JIjg62FKyqQlqTN2T1rWSaCuRDhfMpeCBB5OS?=
 =?us-ascii?Q?lpvZtkOGTETSE/1ir52WXXRWV158EIb3fxV/td2y2ytAO8KjQmzFLRzxvfGY?=
 =?us-ascii?Q?mhvUI/D70ktkDXJxIpZwIhMUhtmV3xi380WuzATBm6SBrlJ40MPv2JGBNe+N?=
 =?us-ascii?Q?Zjjqf6Fs3quu20wO+W8A1gZJ9ewXQ/GgWBB8Dki91RZP4QoMwGYPPRekhCqw?=
 =?us-ascii?Q?fL77Z7BXo2SEXjaRn6Le5bKRbrWdf7e0shPV9gnDAdT5Bb/BYdfrHEErWGMu?=
 =?us-ascii?Q?ybeWcaU48jps0LilkkGPZjxFd3MnSGITTit0qxvP99ZEKymwtbpn7O4rbD6l?=
 =?us-ascii?Q?SgG3oiFxg+umU5kMCt8d4vqYOf3EMwQbmqR4U0NSaUW0Y0H/LQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 19:06:27.3979
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e544698-c818-4b66-4304-08dc97a5697c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9314


This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-guest-req-v2

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
 arch/x86/kvm/svm/sev.c                  | 187 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h                  |   3 +
 drivers/virt/coco/sev-guest/sev-guest.c |   2 -
 drivers/virt/coco/sev-guest/sev-guest.h |  63 -----------
 include/uapi/linux/sev-guest.h          |   3 +
 6 files changed, 241 insertions(+), 65 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h


