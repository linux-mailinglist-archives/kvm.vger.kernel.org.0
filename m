Return-Path: <kvm+bounces-67643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1C4D0C842
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 00:18:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8C2C930049C1
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 23:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B9E339875;
	Fri,  9 Jan 2026 23:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="14KDchpH"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011042.outbound.protection.outlook.com [52.101.52.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC1C86353;
	Fri,  9 Jan 2026 23:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768000712; cv=fail; b=oaVVMDqeB0lqcpWd0RHwfwO2aoEn2tGNfmPjPmVag/AJcu4DHWYH0ykWgf/SB7rd61heObvm1h5TWlHaCeodueuktzpPYclvOMJyl+fFpADiw2APjgWfjfV7dD9Hr49K5CF6xCRx6Dpl7vpgt3YGQMZSYgImm23Nkd7WE7EKAms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768000712; c=relaxed/simple;
	bh=SUQuKeWpR4RdI2jlda7DwYZrGbG9KCMje9BfQdXxv00=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t/9zLpd3ksLa/FuZrTaE6tmpMbWYy6Aig/7Oj+59PpoglxikI/vddzPFdxcM4WtxWdhuf0vP7zPZatWBt0229kgS5EAT13hMoOXA6OrIWuwkMh+7lHcqwXs0Nj+DLmTKZh3iftrTN/rljc4GIiO9trEAqdmZME4ee/zhNeL/Yzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=14KDchpH; arc=fail smtp.client-ip=52.101.52.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=alYXJv6XwmZ3SyX1WI6blOV5XVM9Nz8fVFF8WGUdZn2EMRBbW5ApcaK5mO7cdvZKmuj8HvavYR89Z5nuOmIc7RUfg+8dN2Z/0nudhDMT3ZyAIFLBtzcHayCTHDzIzxQ/sDjt1BorCnwAUMk2fIpXr4iIqeG1aHF6doIdYi1lPaYFlbPLKl8sVAPfMwLmFTWzAktQMv1sHYHkUR0XavaE38+eFYZth91tXgfAsNsGfb6R3XfkwtXJu4JzZJkKkmStXT67oDOFrwPymgP8qofEsE5oA5n3fiTJS4UWMBzsB4KhpR8LOO2g+AjqRnHrl/B7rZEbG9ITN9H62Yg/CrBYLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJFLxA9jW0t0oeSRW0vndfV57nuimw7m0PIQznjO+Kc=;
 b=Wg0T7jOsdztxyxZIVyxohsjhy3AbBgNzFMa+ELoeXN1xIOC8jqgDrWAuVNrRxXR944VomDXC1SQhC76cGwpXhxDcGnmx42f/5bY2kk5DgIqbFl+bcNRabFSm1fwBbgfuLr5HFgRxLc4tXHD8M6+dgBY5X6ZD/rYdBXnXqvxC2LfhkyCN1FcqRLKTk2euemUNEAvO9ijQUNziRnVHaGTn9+mlVeOoIoRX8Zke4hB9jZ9Drzi2K8/mWdAAiXmqEWPYAIqrzBQUL9N8V+aaQp3q/1ME0/zkUkY7BefbmAzVY0v/7abREYzlr1R0Yy5ytHL9g6N/hF90RecxlT8ZcnThQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJFLxA9jW0t0oeSRW0vndfV57nuimw7m0PIQznjO+Kc=;
 b=14KDchpHxVpNdP1X8pjq1+0tjycq5bFtFq5rgRozugYj3xGFOCRCRopdTlx1lqdJDD1uLEudTT/V61x4c351AGCFF6SFFR7BXC7KTFD1nKJu1H+zSUH/YeXo0l8DabjR+Z7g+j+e3hy81byXkSDikwikbXbnhjLr1e/6PCMLTvY=
Received: from SJ0PR03CA0256.namprd03.prod.outlook.com (2603:10b6:a03:3a0::21)
 by DM4PR12MB5987.namprd12.prod.outlook.com (2603:10b6:8:6a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 23:18:24 +0000
Received: from SJ1PEPF00002317.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::69) by SJ0PR03CA0256.outlook.office365.com
 (2603:10b6:a03:3a0::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.6 via Frontend Transport; Fri, 9
 Jan 2026 23:18:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002317.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 23:18:24 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 17:18:16 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <liam.merwick@oracle.com>, <huibo.wang@amd.com>
Subject: [PATCH v7 0/2] SEV-SNP: Add KVM support for SNP certificate fetching
Date: Fri, 9 Jan 2026 17:17:31 -0600
Message-ID: <20260109231732.1160759-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002317:EE_|DM4PR12MB5987:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ac722ce-a9d7-43f9-b6de-08de4fd56311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UXigvxchhrak+4MvBDT13Bi7EMLFfsLn61b29u3ph7/vCMIYy6kIgZCNDtnp?=
 =?us-ascii?Q?C1ZS0qoACHjzS88UBCOWIhfSMvZ4YGY0769hs3kuyGZvV/h02cXctvneA3GD?=
 =?us-ascii?Q?DB62Tb+fneFue5ueJnXWBz6cXzVyNEK2mBjxGYCmbOHBCg1Lzaic8o3+rsWT?=
 =?us-ascii?Q?LscwHpRG+tGM1hyF14Ke3fOTAdBloYIPbh3jvYCVYiJprE1b8JgP4PLm4IGr?=
 =?us-ascii?Q?sMkDjEIk5Kaq68b7hlV93kxKurFklZwvwUa1mR7a0ZqmEOyWFGPDEirwl0Cl?=
 =?us-ascii?Q?thVd/3HapbRuWNHjoNTtvXZ/vE+6m0GIfkO66CIF1MDS2Q4lRp8bxN8n/yAV?=
 =?us-ascii?Q?mhT3p/gm4Q0IOVqyF3mYYOi3va5aS84nWpoEKeBTw/KNsZGgEtTtuCjBju0s?=
 =?us-ascii?Q?B6oScqJVOkvxwUi1+xWe0v+DDNqpP+M1unAkA33idTWXEArzE/EkewFzo8Lc?=
 =?us-ascii?Q?mZbxdn7PtPU/auxElyPzUdoofQEbXURTuGzgdcIDozjCL5uEuFCVFRJAV2Fe?=
 =?us-ascii?Q?EkBxrVgD6rbFc8sM/gssWILZuLUx7GU6esBSNVvcCEyMSKkhlV+jmV5M1khj?=
 =?us-ascii?Q?9fm5kkMpn4O/mr5wf7G12dMlYpiqKhbZ7i/sp+HfFzhOXiAiva8Wcxg7qt1T?=
 =?us-ascii?Q?lsjy9Nr3SanNbVhBsyw1Sd3XYJ27WoMIwBeAFbz7aul3XW6ax/E2sGrOWx3Z?=
 =?us-ascii?Q?zzhZ/h1fEpTQmU4v9s9TjoKbR/cx4KXiUw+6HXnSODm7xHJcbVvLwKUHjtyi?=
 =?us-ascii?Q?S5l0OMjgfYzD9d6V6NobpMr3T/FqLCCHv6enz/e4ydWHmYzG5eTg023HF7To?=
 =?us-ascii?Q?cxU7RU+mJpE8re6fEwuCWNTcPFBNHA78wiYM4qWjtW7P+JvJ7EBH3zi6hCgf?=
 =?us-ascii?Q?m/qL23fY92sZeK31936lFTGdX67O+JrcDH1jilKFWD9tB8VFv25ZL6vcksJ8?=
 =?us-ascii?Q?5YJgoGIoAUUF22j8GXnMxID2NTKonX5kNrJPYDP7FPtWwUuTs+H7kXCtVfDH?=
 =?us-ascii?Q?eek49abEIsbeIX0AX25JyvwE00FTntRcYsfDjVlrnu8yGUUnh1In9lVGo61g?=
 =?us-ascii?Q?UAOktRvT7lPisF9AHD1J6Bxd+1s/o5VA3naeLJumpam8MUF1z77H0yuYxDKW?=
 =?us-ascii?Q?vPwCchmYrQdNkJrfcy1nbOapvfZlogPNzkfX2JSkvCwx3qujZ1iLcodeaM2j?=
 =?us-ascii?Q?3P4LBP3B/994S2Xddry8diB3Yn0ESChS08oLDWtpEwKCKHuMDeonF/gHhpuj?=
 =?us-ascii?Q?Kz2/oj94WW30D2916P8RDgiEEJIOvxk81c/fla+zq4kz8y55MHy3D4RQKczt?=
 =?us-ascii?Q?pB33zwVc676POlZ2/ojQAEKwPX26XXTotx/rbN/t5M1Yw5hGABPHnI8TgIxG?=
 =?us-ascii?Q?+gXyNmn1ujmT0+q9uclFU/076yaroE7i2U51XTwGPwrO8f8AEHqiqLlmVdQm?=
 =?us-ascii?Q?V6kWysc0oHY0Uy7/5M95ZOCTyI7SvYHrDcFeXpntVdiua2KDWhVQsP8/HIOQ?=
 =?us-ascii?Q?dyHkyN0o2cDc5OpzpAcIlRa+TZPrYECxdi3NWG9E9aU9QD0moqVp07bU1KS8?=
 =?us-ascii?Q?NE7+YgERQqtOECu38rAlgD7MXrKeMIknfpKm8/XN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 23:18:24.1117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac722ce-a9d7-43f9-b6de-08de4fd56311
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002317.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5987

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-certs-v7

and is based on top of kvm/next (0499add8efd7)


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

  https://github.com/amdese/qemu/commits/snp-certs-rfc3-wip1

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

Changes since v6:

 * Incorporate documentation/comment suggestions from Sean, along with
   additional clarity/grammar fixups.
 * Don't define SNP_GUEST_VMM_ERR_GENERIC for general use within kernel,
   instead limit it to a KVM-specific choice of value in lieu of any
   formally-defined guest message return code for generic/undefined errors.
 * switch struct kvm_exit_snp_req_certs to using a 'gpa' argument instead
   of 'gfn' (Sean)
 * rebase to kvm/next, re-test, and collect R-b/T-b's

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

 Documentation/virt/kvm/api.rst                     | 44 ++++++++++++
 .../virt/kvm/x86/amd-memory-encryption.rst         | 52 ++++++++++++++-
 arch/x86/include/uapi/asm/kvm.h                    |  2 +
 arch/x86/kvm/svm/sev.c                             | 78 ++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h                             |  1 +
 include/uapi/linux/kvm.h                           |  9 +++
 6 files changed, 179 insertions(+), 7 deletions(-)




