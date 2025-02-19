Return-Path: <kvm+bounces-38582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CFBFA3C360
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 16:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F59A189C0CC
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 15:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAB0198E8C;
	Wed, 19 Feb 2025 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yC/4Bt2W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE416381AF;
	Wed, 19 Feb 2025 15:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739978221; cv=fail; b=CPVpYtmnimoTma86DZHx24mtfGX4o/Y3atfkOKEHd94qEqsYW1fpnjkKY+GIndd+U8vJ1hLTn/sxAhACvY9AphTS1urFfoynEjQgUBW4/aPH+ZiiDfq8Iu79VovbYAwn2p8eHdfmyof04fO4XTtVsKueiRGudhtdgylP/fQy55w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739978221; c=relaxed/simple;
	bh=E9ZYaQ5hmlgenksxHfpPKy1eP2U7B6rX7Fghym6DtBI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NPxhf+M9S3gQsL52UndVUSUxg9zNMRqV/s1zs6AuFz5+DQAVRT01HsWQMfUWOhlWrbCBxMz9qf6VZDZY01D76cAGwWA3Jj2AvM8bnHsMU3KPJDm/mEBlVXKXyHxLexTBdnEGD1BkobhitaOVJHQVMPYjEjB3di19fBuZeju9tEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yC/4Bt2W; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AuQ5E6KCVpVGNRdAWBSYiX6tewGDRe+a3+3BjQR+iLzmGbMc3wK+M9oKWhMGecAI8qgL8xd73MIJOfMLXbCbPtW0oSU0Wj32TB5A7Rhl+JedmE6HJbihwqtGu5Bh8olLTI7cZaBv9tm4fAbf4HdnaQCBNvYLjvcRZ+Em38MQjn/YtHwUiW8d0BWAwTuOqjR1Kpns4puVZz9h3r5q7B5QMARPs9fzj26xKaKsvsxdkh0LRwkKuzjQCF65I3P7TgUER890Zib/A5/6QpFA89dBXzHN0R0hQJLsyBr+cnKXa9Ahab6lrw72YxOfbm2a2GZL/oWy/Wuy2nWQ1yxn/BqHEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEkfKICmsAFoxHEeFYdPQAxZknm7cYKvAjShsadoGZ0=;
 b=lUfvBrkkSECelsz9A8+3SUxsA6eD43tZRM3hqYjDRX3H9lgcPUFKiMKECf0nC3lmVabAd0SMCrVVGax+w9zWWfmrrvpCPzhyaSEV/9i5ZoT4ycQW2P+ouRl3gIrloaOUUjJmHTXwKfih342mqySgZ71rF3xe9pJwrR1PjtiWyye8dsPcLZXSlFJ4Nxv1iJ5vOd+WkcDEELI0m4/K6/ffzGL9tZG8Ljj1HaIxTCGduqTxl6uJbjFlt+RIep6vNkjX/SNHwZVB9QzF1cNrC49wkbrCOLuBkk/k7JakadhSavp0DxdIDh5lnc14liA1HpuuIzpdw0DelJyafUlQryH62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEkfKICmsAFoxHEeFYdPQAxZknm7cYKvAjShsadoGZ0=;
 b=yC/4Bt2WloUPNObORMDnKatMxDG54hLql300lc93Rm+iVjKTFk/TuZs4PpZ2nDtx27JpFctD/k+GpDKNfaFsVSINQe67ZY6BFAjiR4uNY6McbHw1MMsUenZVTazw3+RZEBnMKkw6Og2K1BSoP35ZQgET7RdrQ8o6DzqfHFy3CGU=
Received: from CH0PR03CA0107.namprd03.prod.outlook.com (2603:10b6:610:cd::22)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 15:16:57 +0000
Received: from CH1PEPF0000A349.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::5f) by CH0PR03CA0107.outlook.office365.com
 (2603:10b6:610:cd::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.14 via Frontend Transport; Wed,
 19 Feb 2025 15:16:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A349.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 15:16:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 09:16:56 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <ashish.kalra@amd.com>, <liam.merwick@oracle.com>,
	<pankaj.gupta@amd.com>, <dionnaglaze@google.com>, <huibo.wang@amd.com>
Subject: [PATCH v5 0/1] SEV-SNP: Add KVM support for SNP certificate fetching
Date: Wed, 19 Feb 2025 09:15:04 -0600
Message-ID: <20250219151505.3538323-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A349:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: bf6cdbf0-58a7-4b27-628b-08dd50f87374
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9VD8zc7+iNvRAMgPfZb3F+Oj/sRMATU4I4ESPKEjBJ6GkaaMGfxMQBNAfUL4?=
 =?us-ascii?Q?eJXBVGTiJOdBeD3Qm8zq8AAJ7v1j90zSGtxz/P4XoHS+QSjnfR/J8csiPpna?=
 =?us-ascii?Q?Svq2wWNUxVx/NFXQIKU+Z2HG3tAQNaVKRDHug9URd2xeFhwNS0x3BaplR646?=
 =?us-ascii?Q?+E0mM+5cxrkONV8eCFsiySXkDcpxG6Ht3I/Ffs3YPhpFgLakmh1y1SDs8CXQ?=
 =?us-ascii?Q?TszmXx++hYuFL6/mKsiQJOKEZSCM2ZgcNVzJ+C1M11fcrvb/RUamL03h3vV8?=
 =?us-ascii?Q?OC+pW9mYLLZBgA7H/6pK5pQpFCDDcC1wuhOlB2zszjkUQf/Kjhszc9Oqsxcc?=
 =?us-ascii?Q?fsN1htKmNjpLe5cXYiQkOLvajIsrjinOfAbJCA7UdRYMhVzNJTbo6++97sCA?=
 =?us-ascii?Q?/pSPZkgdvOuoQGmcpbXStZZajFenp+00PnAfyN+qmvhmgEy+sCLzbkBiDnIo?=
 =?us-ascii?Q?p3FdybBk4TpI8CEQjjliZbm3oqSnF0IwD+issaclW7YUAwKRRIFDkOpfXUtb?=
 =?us-ascii?Q?OoShugQJ11A0NHa+vu5Q0vspd7lSGt2BLz9XJZ2fyaF+jZV+n6vto0IEZyXe?=
 =?us-ascii?Q?Pjgls/djn/T84h7gKo+XxjadC9wxxZzBL7IvT+Oa2E1B3BztJRVZcTBeVwxf?=
 =?us-ascii?Q?e61dOZ4uC00AWW9HtSnn2hl2Ee65du8D6RTLPaNT3PqlIyv3LZ8GRbs08Ru5?=
 =?us-ascii?Q?2X6IVevjpbKuZQGWbSkZlZcPq/FCShivPZLFzogfLC9joT4kAPOfl9TNfZPn?=
 =?us-ascii?Q?qoqBpobJeE6Ij1Fc9+xI00Lvxm8qeffPr3rZ9oIK5qWfqNSaoPgv4m0QHY+C?=
 =?us-ascii?Q?h2PQRZIFlfqlW5rV9kkEBHdzD8GvTPf3NALQnqGN4AUpnsWh1thLzg3d2rPd?=
 =?us-ascii?Q?r0Ty6tJHFulxyfmSg6wULPiTHgZ9SQ+oZnzgK0v27i47GwlKkkeW1Wt54AIt?=
 =?us-ascii?Q?NWj+HMsDyCCd6QbgMFdlq4/6WDiAhuamO+Pl3lBBM/Q3a2n4TbqnP2TCObhl?=
 =?us-ascii?Q?Eb35FxTiGbbNOJsPEe4shseX7/Bwss0JPhlkUq01kyWhjJA2SHhlGXZe6gD4?=
 =?us-ascii?Q?lecbXVDFTjgknVueGY7SfyMPak2qswuozOMCnrMAQxmF2EzZ2Wo+QMi81IiH?=
 =?us-ascii?Q?CEIwB7m+ZwcmJyJPbkTuvp0ty9qu6fg3L1l6hjf+M7FIKmd6zomRQhjAoA/Y?=
 =?us-ascii?Q?uzVvdigJOLvpAsVkEUlvSIslaTgya1DenSwD2mVqnX88AqyUm7+x1nFYgamt?=
 =?us-ascii?Q?6nn6cPI803GK/K78AQajPVyeAcHguFnzbdYDibOy2xvkn46v5QUwy1cQUhyY?=
 =?us-ascii?Q?1OyU+0lkA+LO9eRYtODuP9g0tgAzNhnH1FhyRagE8jBaSm1ddM3LRL0NjM4c?=
 =?us-ascii?Q?fAePKoDe2IzC0b6cKHLNaMppR2XV1IfmSjM9A8wQ1B3AVU9URfpJXkCcJSxx?=
 =?us-ascii?Q?ckEstKkJsI2jKR3rN46Sm+mdXABSqpW98UmpCUfz17F4sBOB8RppJw3BgnFP?=
 =?us-ascii?Q?8tGNGsH3q78wdhI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 15:16:57.4815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6cdbf0-58a7-4b27-628b-08dd50f87374
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A349.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5748

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-certs-v5

and is based on top of kvm/next (d3d0b8dfe060)

v4 of these patches were previously submitted under:

  [PATCH v4 0/1] SEV-SNP: Add KVM support for SNP certificate fetching
  https://lore.kernel.org/kvm/20250120215818.522175-1-huibo.wang@amd.com/


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

-Mike

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
Michael Roth (1):
      KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching

 Documentation/virt/kvm/api.rst  | 100 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm/sev.c          |  43 ++++++++++++++---
 arch/x86/kvm/x86.c              |  11 +++++
 include/uapi/linux/kvm.h        |  10 ++++
 include/uapi/linux/sev-guest.h  |   8 ++++
 6 files changed, 167 insertions(+), 6 deletions(-)



