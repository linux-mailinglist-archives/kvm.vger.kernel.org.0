Return-Path: <kvm+bounces-44599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1E3A9F9F4
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C67CA5A4A19
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 19:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4F3297A43;
	Mon, 28 Apr 2025 19:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hmy/fUM8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B6D289363;
	Mon, 28 Apr 2025 19:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745869926; cv=fail; b=HVSZGOzNzFNkDmUpf7HpKYMCCc5qGMNxb7kreV7CcxPEvwivqiwyqbwuYm5NZc0LOf1Mek/CdzXjnAYXf4gBhK+0hyjPsMD04BLRrjgUjk1kancbw0tjVXZ7gimgMKOkNbQRVYHUYHeAvx0DtRfM9pj2CRTQvY59748PI8FP2Ww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745869926; c=relaxed/simple;
	bh=WAp3oKWpSUR2OWeJ9X55pmLzCTuQWxf0GZaKaGyjDeY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aGirjvEotm96zJr0G6x8Bfku5aPb87lCQeZiJUO1FUJMPf5JerY5Y3cLrFI9TZ9xl4g5KXg8RiPPaasm9U7CrmbMx9Uh7uEMKmwJMgY00AicRXctfqzklVJrngvr8z1o6Kk4JZgyH/8lHQj0WhF/BU8gRXJ0yWOybbpSXu8+SeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hmy/fUM8; arc=fail smtp.client-ip=40.107.223.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xP+p97JKM4dLftvznwGN+jU9gGjLH8iI2GzTSPJail35o0STZhwY+aH5SFSmyhtZ1wiFyppv7MhPJrv/j5IzkpJQ7mhNieiEV2JDI0V/tSmC2/LjbQ1SMrnA70xE8pAp8pKk/Bz9IQS5JpBS0xBzxLL6rvNb2JO2JK6JbU828k4992Oo08ujLL1fLkXlw1zsrVotZ7D0PaiNSd3uOlA8oz1lW0+ZgNDRmyDJuK3yckfIfsubTExQ1w78YXQCQKqHtfQk9oQSa2+Ok8YrOMvKFOJxaGDnWueySQGPZFyMU9AK/4VFmy5Mn3VPgaW2ouwG/tZBJFqiR/NgboQ6T3euUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZTcuQyw6SCBi/nHv1o0d/hAOWbGEon0djLqqFSRJNwY=;
 b=F0TaQqZfFNpEcM6OfofRTzrBgihDS1Z4EIDzHBrfEe1SyJitw1liKwfFOMOWYcWYiP/u70KsnOwsBpXxvDWZkB59agrw0SmTe+4S1DkOVv8YaV1bol9936Mfl2inLhS3EpkCzhXkWgWnJb1/XAw1ReJzd3DxlAxQLjaYVgO+J5q3gz3LKigNguECA96oSvR6t2L6etSaCnyzlNYEuP/hrm75z4+Lzenc5dpeIi7LGejTds1oJyyuQoAlUOs1q2dXmpVMxzBUG60OXKWr+HyDxLb4oFUXY/xdRqzEEcVwZCOPy5c62N6iUJRRfGh+PX0Z11T0kHjpVEb6I9YT1HOGqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTcuQyw6SCBi/nHv1o0d/hAOWbGEon0djLqqFSRJNwY=;
 b=hmy/fUM8x0KdPn+CiN2euKXPLaIAhHlRiDAGsM127uy75Wnog4/s+14IX8sDkvEv2ycBpLWe0MjUpiSpMflHdzEvlK6wm66FORAP1HluCRnMcHyHhGfNtOe6zoHBMMIFYOsC2yc7gs+TGJwckRdTbI5XW/2W8dMvuVamv1wHJgQ=
Received: from BN1PR12CA0012.namprd12.prod.outlook.com (2603:10b6:408:e1::17)
 by PH7PR12MB8108.namprd12.prod.outlook.com (2603:10b6:510:2bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Mon, 28 Apr
 2025 19:51:59 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:408:e1:cafe::5d) by BN1PR12CA0012.outlook.office365.com
 (2603:10b6:408:e1::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.40 via Frontend Transport; Mon,
 28 Apr 2025 19:51:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Mon, 28 Apr 2025 19:51:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Apr
 2025 14:51:58 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <liam.merwick@oracle.com>,
	<dionnaglaze@google.com>, <huibo.wang@amd.com>
Subject: [PATCH v6 0/2] SEV-SNP: Add KVM support for SNP certificate fetching
Date: Mon, 28 Apr 2025 14:51:11 -0500
Message-ID: <20250428195113.392303-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|PH7PR12MB8108:EE_
X-MS-Office365-Filtering-Correlation-Id: bc926ba4-9653-49b8-eccb-08dd868e2349
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?68p4s2H3Ztp+KQFrSUoUVYkMUHKKKgLL5JEwvJWD81tdBAplRY7G46yMB9/v?=
 =?us-ascii?Q?1iAT2nQykUUz7m0vLqZsrrdkzfMh2fJD0PyI35NSJBzlYsVGcJgEFt+6wr8l?=
 =?us-ascii?Q?ylkjf0cu611mEpjuVye6lFeXvPpsRTc0iQElzoGzcTKjHNzPicQPuKmisiwp?=
 =?us-ascii?Q?jdXmgDH+6ttVS6vtIBDfUnPh1pyi0P9os4XJyXnnjhm3VvSZTC1iMbPl17sP?=
 =?us-ascii?Q?GMvjiRQLL69A860PYrw9Dik0AMO0BaS/ajXiIDRne9FydYwAslpaLcMxAN1U?=
 =?us-ascii?Q?tcYmlPS9QzoSnUv4bxh5KNTTswJYAj1NrvRAP4NkAJ8jYNzFi2cVbAtehxOh?=
 =?us-ascii?Q?qxXP53X7+C4F+Oeb5KrX6sg8KA4b66R0FtBZqkpBIK7qPGgJP0izftmFzDRo?=
 =?us-ascii?Q?VAqrLoOx29ramYL5b0f2JtFznkdEp017Mw/ZckgyBy9C1epWdyHK+xAEoOQx?=
 =?us-ascii?Q?4BaA6Vk0D9Knx0SnXKs21LtMmMg1YrSnNZrpLc2ATJgc75w4pJYe1yIw1NOh?=
 =?us-ascii?Q?rWmEaMvQcn0n4PVU0OVIXHD3Scm6qGRqLceX3HAYVvAQW8tGqiPG7h3GMf22?=
 =?us-ascii?Q?8C3yS2fSh9eYXgQFE9YMYgTzkkhhQ4+QXrxdDnCf7hT8CuS8QPt5vz0IkqUw?=
 =?us-ascii?Q?YEyvd/vUamlolkgrks+t+5n59bS3uUiyZfl5oa8EXIyTTu0q9nqHnFDDw1yE?=
 =?us-ascii?Q?LvTb9ujItwwgVnK+G0Ixyk/uBfFlve5+SzzAtmQkLiLcIrMAVs9yAZAYXydI?=
 =?us-ascii?Q?Yb3APDH/MHpOOOoP6Oy6I+EwnuJAJ7ItOSLp48yS9g9LfRz/pdHgRY19roAp?=
 =?us-ascii?Q?lPgpi3spkIz0EfwOhKdhGEYvIqO8CWJyZQMWa2GeKJO1FUoSZWNFgX9/4+1s?=
 =?us-ascii?Q?N/0Yy5y+m9R2cysVeL7DAaAJJkv/zY44IqM2tqDHwqLNtZlbK62MWXVPCUbk?=
 =?us-ascii?Q?S37Zk9WwLa/KIMCEnSqE5mRfkdJNLuwPcQszY3t4QLhGNC0TPk8nhw3TsxV0?=
 =?us-ascii?Q?kVieqAsPsDl2O62i6VZ5h1iMechsoDr89QfkiubdoOKPOPeuNH+ycUoBRkIK?=
 =?us-ascii?Q?DTgP5yna4lfRNMDL1ihIwJ6pUHqWItYywKgUN4MWoUV2GvJb9kMrVyBB8qgj?=
 =?us-ascii?Q?+xc9M1tADMWTp5ZJZOYmjxA7Psxun6Fimf50g0ZibO2ndBSk+x3oUM9WeLLG?=
 =?us-ascii?Q?NWo7hI9S32phJQujyn6B31Rm2zAe6iG3c2rY/s6sXW2aE9iAxl7jFvStYLG6?=
 =?us-ascii?Q?LN6zmA3TKD8CRX2lG1c59Fa9p1HRtQ5g+4C1HToxJZhcOfONLuyqfwyNDyrc?=
 =?us-ascii?Q?/fQv4Y+NZfKizG4BN4jRpl7TkeQA9To5BnDqvhkaLDSKNqG47gPrz4ZPKeHt?=
 =?us-ascii?Q?Ghxs8gwh2wrBB5u2PSHzSDTo+006qldaLHKjT0qC4h1MRcrnwKQtAFEDC4t7?=
 =?us-ascii?Q?TIQUHmkRV+oTASNb93ovLgEZ0T8F+KOvZ8vEDUey6J1Ba1mfH8ncsqYwshgN?=
 =?us-ascii?Q?+UNLib5roaF4L7G67Q6AJZHrlKqYHNYARvhDwmkoMvoZChFzwreAq+4sHA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 19:51:59.1580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc926ba4-9653-49b8-eccb-08dd868e2349
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8108

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-certs-v6

and is based on top of kvm/next (45eb29140e68)


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

To support fetching certificate data from userspace, a new KVM
KVM_EXIT_SNP_REQ_CERTS exit type is used to fetch the data similarly to
KVM_EXIT_MMIO/etc, with an associate KVM capability to detect/enable the
exits depending on whether userspace has been configured to provide
certificate data.

[1] https://lore.kernel.org/kvm/ZS614OSoritrE1d2@google.com/


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-certs-rfc3-wip0

A basic command-line invocation for SNP with certificate data supplied
would be:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,certs-filename=/home/mroth/cert.blob
  -bios OVMF.fd

Something like the following simple example can be used to simulate an
exclusive lock being held on the certificate by management tools performing an
update:

  #include <stdlib.h>
  #include <stdio.h>
  #define __USE_GNU
  #include <fcntl.h>
  #include <unistd.h>
  #include <errno.h>
  #include <stdbool.h>
  #include <sys/types.h>
  #include <sys/stat.h>
  
  int main(int argc, void **argv)
  {
      int ret, fd, i = 0;
      char *path = argv[1];
  
      struct flock fl = {
          .l_whence = SEEK_SET,
          .l_start = 0,
          .l_len = 0,
          .l_type = F_WRLCK
      };
  
      fd = open(path, O_RDWR);
      ret = fcntl(fd, F_OFD_SETLK, &fl);
      if (ret) {
          printf("error locking file, ret %d errno %d\n", ret, errno);
          return ret;
      }
  
      while (true) {
          i++;
          printf("now holding lock (%d seconds elapsed)...\n", i);
          usleep(1000 * 1000);
      }
  
      return 0;
  }

The format of the certificate blob is defined in the GHCB 2.0 specification,
but if it's not being parsed on the guest-side then random data will suffice
for testing the KVM bits.

Any feedback/review is appreciated.

Thanks!

-Mike

Changes since v5:

 * Drop KVM capability in favor of a KVM device attribute to advertise
   support to userspace, and introduce a new KVM_SEV_SNP_ENABLE_REQ_CERTS
   command to switch it on (Sean)
 * Only allow certificate-fetching to be enabled prior to starting any
   vCPUs to avoid races/unexpected behavior (Sean)
 * Drop unecessary cast in SNP_GUEST_VMM_ERR_GENERIC definition (Sean)
 * Add checks to enforce that userspace only uses EIO to indicate generic
   errors when fetching certificates to ensure that other error codes remain
   usable for other/future error conditions (Joerg, Sean)
 * Clean up setting of GHCB error codes via a small helper routine (Sean)
 * Use READ_ONCE() when checking userspace's return value in struct kvm_run
   (Sean)
 * Use u64 instead of u32 for npages/ret fields in the kvm_run struct (Sean)
 * Use a switch statement to handle individual error codes reported by
   userspace (Sean)
 * Move 'snp_certs_enabled' flag from struct kvm_arch to kvm_sev_info (Sean)
 * Documentation fix-ups (Sean)
 * Rebase to latest kvm/next

Changes since v4:

 * Minor documentation updates to make the implementation notes less
   specific to QEMU.
 * Collected Reviewed-by/Tested-by from v3 since there have been no
   functional changes since then and only minor documentation updates.
 * Rebased/re-tested on top of latest kvm/next (d3d0b8dfe060)

Changes since v3:

 * This version updates the documentation scheme about how file locking is
   expected to happen.

Changes since v2:

 * As per discussion during PUCK, drop all the KVM_EXIT_COCO infrastructure
   since there are enough differences with TDX's quote generation to make
   unifying the 2 exits over-complicated for userspace, and the code-sharing
   we stand to gain from placing everything under the KVM_EXIT_COCO_*
   umbrella are of questionable benefit.
 * Update/simplify documentation as per the above.
 * Rebase/re-test on top of latest kvm-coco-queue

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
      KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
      KVM: SEV: Add KVM_SEV_SNP_ENABLE_REQ_CERTS command

 Documentation/virt/kvm/api.rst                     | 80 ++++++++++++++++++++++
 .../virt/kvm/x86/amd-memory-encryption.rst         | 17 ++++-
 arch/x86/include/uapi/asm/kvm.h                    |  2 +
 arch/x86/kvm/svm/sev.c                             | 67 ++++++++++++++++--
 arch/x86/kvm/svm/svm.h                             |  1 +
 include/uapi/linux/kvm.h                           |  9 +++
 include/uapi/linux/sev-guest.h                     |  8 +++
 7 files changed, 176 insertions(+), 8 deletions(-)




