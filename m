Return-Path: <kvm+bounces-36076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB2DA1746D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 22:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26284188A9D3
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 21:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084A51F03F4;
	Mon, 20 Jan 2025 21:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="47XkHBHM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0431F03C3;
	Mon, 20 Jan 2025 21:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737410319; cv=fail; b=ro3s8Bg1of9B3B206ve9uTff70k8I2+fWbIpK8XAlZhMJBdsUkb/NT3VcO05AQGmGh105CpN7Hb+cMKa17Q1iRen1X9NyNzXPy0kF3Nw3CDJNQktcLbkPY++P7ZHKU2cCIaXgKBl8cfA1BLfD5Bj3QLAU5Sgsh8s8+i3DqED67w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737410319; c=relaxed/simple;
	bh=bh1No9nHVuCA14K9NcJDamYq/uZ9dFGjEH08sqbq57Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tSI5sWL1MJeBNRsS0q6hkNEytPBtXoPvel0BCdhdoDTJie+CY9p7FXEY3atZ6P1tHd3tD488DVJJjlczcOgGcIcn/EYv/mAvO+2bMp0G2wWMNWT57wrBM8hYaLAbWvnqZwLJaW9pOFaUgBhobf7nk1vKFn5KqqAfv3jEWpNoacE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=47XkHBHM; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yw8IgCdVbrI01Net3xvZ4xq3dKvr7vhbfFU1wvG4CQz+3K2seNAsJJ5jVNwwwcGJH7PYfadMIPjIWN/UVjMMKILYW9HhLPlUSpT/nAe7lSgJWIc2G+wQ8WAa3qDss2GR16HObc55VDU1aTRQW5V3CvQVSYOi6prxOQi86LuQFx+TOqm9FGDu7qArB3d+aCT5Cp0xzRb59KQPHOR0Yzz0G7rBpApuDhif0Rn3Gj5vyfNkoI40QrrjILm84Y0a8VDkW2ayaY352uKatVi/9Alm3fA3sZ9HivK6LUixLn72sjixCV4z5S4LuFh26Jao7T2tGs7Gky5pY2+Mb+EMSFjo+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YijSi5W6zJAIpYk2UF1tyrJGTz9hd/aT5jUUILb5SnI=;
 b=KAgr9uvLJZjqPYytVnKF4f3xliKpJraIB0NzLF2OIf2RBnFBU1XVrR2Fl54vaf2dgShiFPtf0aebCC5DyRed1JGDsnAaxOd+VAGS80U+g4FwZr8GdbVdgaKPceN/0VvvqnkyKjqNM7/v+OqqOuVRbGryCzxD0A9guCw/EjyEYUHiywsRrX5qEAzY+Io4gjXZMXHnMXGoPTVJwyuXTeY2CGrjtxhovIuwCTwBQRAEiTb8eMQfu4BCkADSdQOn4a7/c7lkZwT3vx/WXepi6rLyKGndf40Ia9hBITEcYQiq7XSVZQMFTgMoPy/rC6bFdxP8Mgruc2xnnrRYj+XIyMRvGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YijSi5W6zJAIpYk2UF1tyrJGTz9hd/aT5jUUILb5SnI=;
 b=47XkHBHM+w4JUea3dIC8hiv+XpTUJo4uf9NAnZwMaHPy3bn1uyE7ylz1oRITSY5yMZpR/c6OsqCfOF99L4WncpzAR9jm5CzgOmOAtzZjvo7lJirpPvcX86dHrlZoMA1xqXCuUyWRnAzbIwOUvaOq4ksQsi9NqBTjyp1eDAb0ywI=
Received: from MN0P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::22)
 by DS0PR12MB6630.namprd12.prod.outlook.com (2603:10b6:8:d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 21:58:33 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:208:531:cafe::db) by MN0P222CA0017.outlook.office365.com
 (2603:10b6:208:531::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.22 via Frontend Transport; Mon,
 20 Jan 2025 21:58:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8377.8 via Frontend Transport; Mon, 20 Jan 2025 21:58:33 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 20 Jan
 2025 15:58:30 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	<roedel@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <pankaj.gupta@amd.com>,
	<dionnaglaze@google.com>, Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v4 0/1] SEV-SNP: Add KVM support for SNP certificate fetching
Date: Mon, 20 Jan 2025 21:58:17 +0000
Message-ID: <20250120215818.522175-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|DS0PR12MB6630:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c3a6f63-dae4-4416-0c2b-08dd399d9538
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nyp/YWTrKT7m3SqNdtJHx3C5/AgFOqiQmZ1dasKX9jQiIgwJUQrYPIjEcMc6?=
 =?us-ascii?Q?+Ggj+3EHXYnwhqhL7hNcE45Iz3B40ylUWgqfB9Csj5aI0GhDDWGIvrMvcl+L?=
 =?us-ascii?Q?YUuPAm52zOXvz+5y3Yu1fmB4wiPiEwD3/3OC8ajNXaGAuQ0CZNy/Ql5uWay5?=
 =?us-ascii?Q?WltA2LmTU4Hkn7IAvhDPpjaqUQmWzb9Nkt0spdq6zDv9o7ynTT+03JGrrFUk?=
 =?us-ascii?Q?XKbVBX0jrLYE0Yc4+CCnaOn7Fm+prcsTT7dfKa1wavroVHJGuRLwG57pcvB0?=
 =?us-ascii?Q?YRvWRCA3QB2UJdoyaDR0/qNDwpdNaaCw6xl73wm0fJ3SmrHmyMJMByOXqdts?=
 =?us-ascii?Q?HDzdRm11YG9G3UAa9YbggZj9xPHcUqoh3O/bNDnC53lZhw825MbmeI4bJabY?=
 =?us-ascii?Q?jbg4oFE8llydIah7BWE0DpUkr3dlNOFU+n951fgSKsJYs/e30iitnRpLHwVr?=
 =?us-ascii?Q?FqRjd1nEEgpJVbvGj1O5mZyPVOVmPUI3YaERB75M4nNAvPDAtyuAWE7S2toN?=
 =?us-ascii?Q?iDWKV8zgvk6yTmsLNSdPnvQzpzst1xBGibgHSi/AXRQlmTKC1OA0XLtT1QYT?=
 =?us-ascii?Q?j1vPq+T0XfO+l8LsKhRJYzt+gbBd8I+tfl56AMJi5bvzEIgJAyyrsBxXC1+W?=
 =?us-ascii?Q?X+v0gA1fKkZs2dG9Lo2JSg9X6QmS/wurSLSzTsXl8eMAst2/lxdzGOka9AQC?=
 =?us-ascii?Q?zRrIAFvaoZPRRiovG4v9oS4hVaX/H2KxIyFjGzSQoSnzYIffVELqMfRQghjf?=
 =?us-ascii?Q?v3GmWP9BekgtbB2u/FVKorhIsErGNCh/carlYOsHFS3htiML8m18iIFIA6F2?=
 =?us-ascii?Q?OSvWkCbjkC3b5SJuYO5TsDjA0hhGr1gORJfqYr5DgPSkdC9I5f1eV1ECrpX5?=
 =?us-ascii?Q?jKercQyysrZzUxsIR8Df/0fJlRrMlJhRFRMjd5NtZRpV3JJ5s8U5H/2svpgy?=
 =?us-ascii?Q?Z2GboMynWmLmVKGAUTNFQGrZxRnDbH23i+3+UdJ+zcRcleVdhgJFqOG/YvIp?=
 =?us-ascii?Q?K36fQNMJ7L5rEwSF3dBAwz/ZC2bGoHxvD2y0gY9GraP0K/9wBSyRA/A1ydBp?=
 =?us-ascii?Q?d1oAx7vGeGQpiH7VZohFiYyQMhyscvzmJzT1NFT4badtIfdwP4ez7EwtWfaM?=
 =?us-ascii?Q?xh2Qi/qbx0G7LGg0mJIaKUgtlsYM4ah+5KZcuiwqh5yWd9IUeom2EbhuyRfG?=
 =?us-ascii?Q?T0lkbFYDZXBEYRTdziz8nJgdRg1KnNbx9EP5GWJXymMlTJv8hGEYepO56KA3?=
 =?us-ascii?Q?BqKSo/ZuXMMHCoSG7zNEWVCvpIM4vt1NIQXNHCc8lwI6PjrjtGJdcrQNuZPx?=
 =?us-ascii?Q?mCK7ie4HdNSCdBNr0q1xciMMj+n3Z1fA4O5UYekpGk11e2e0XBZpHm7/kwlO?=
 =?us-ascii?Q?x8FRl3mdyXuoyeNxKFL8zbMP2+PHZikl4lHHLx1jxllsfKLC5tKFN8Gx2wYc?=
 =?us-ascii?Q?AwwpFzew+C+VuqWTYkmscggleRHKzV1e?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 21:58:33.1824
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3a6f63-dae4-4416-0c2b-08dd399d9538
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6630

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-certs-v4

and is based on top of linux/master (619f0b6fad52)

v3 of these patches were previously submitted under:

  [PATCH v3 0/2] SEV-SNP: Add KVM support for SNP certificate fetching
  https://lore.kernel.org/all/20241218152226.1113411-1-michael.roth@amd.com/


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

  https://github.com/amdese/qemu/commits/snp-certs-rfc1-wip4

A basic command-line invocation for SNP with certificate data supplied
would be:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,certs-path=/home/mroth/cert.blob
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

-Melody

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


Michael Roth (1):
  KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching

 Documentation/virt/kvm/api.rst  | 106 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm/sev.c          |  43 +++++++++++--
 arch/x86/kvm/x86.c              |  11 ++++
 include/uapi/linux/kvm.h        |  10 +++
 include/uapi/linux/sev-guest.h  |   8 +++
 6 files changed, 173 insertions(+), 6 deletions(-)

-- 
2.34.1


