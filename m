Return-Path: <kvm+bounces-34054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 387BF9F69ED
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27F3B7A1842
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 15:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280941F2C31;
	Wed, 18 Dec 2024 15:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xtL0g+v9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FCF1F0E32;
	Wed, 18 Dec 2024 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734535385; cv=fail; b=DKgRQVIFzQw+xWPdLlzz7orpsY2cJ5byKZHo3vuliu9QY04ba3UtvuAd5W9YL1fOzRNmBZJcFMS+QoLCfGbjz2P7CSTaxuGcT2X/Z87hubdk0cbb7fvq01G9xLCDP8BYBUSLGZQkqp2rzhpWEnoA/yPL92X3UPTOdM5bQHKc9/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734535385; c=relaxed/simple;
	bh=JghGgdKurdZJs9V8kNDCzZBbucvQt/hG6ibUSNNgc/Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iBXPljx02lWMk7RcrFNjONVEXcfbh1POtd84xqW9QXzz3zYVwlOVa+KZ9pIwMTHzJYnIpKv7Q64QrCYz2m+yulImHpaHirGwu3t6lqvkmqpXeXT0ELQUTRk1OiK6Kn4hcWulFyD6uRrX9De4ctm7T6rnaEv/WEqitj4c32PKHbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xtL0g+v9; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NB+8pXmuru5SPkKKwN1bcWl8Y2IBXpSUK0qEPTx+uQUUdINB1WU509UId92CGRiCQryzq6pFijt02ypmPz82YPwNLmtLcQMotoGoKPCV5sxevX15je6aTFUTf8wTcO1A2XNVdW1mbkZ2pYKHArI3hjg0CNle7VkzdBCOKx+UZV+bH4Tv8E+ENduKPUgSj6W7WasdTFdEpzAww0nJBbC5J/uCocBAbjKQTA7rjbJV5RZeZbZ81celXb5LJ75tK+sG6YCbo5QQcnFIGjucriQYGIbZMKFLDbXPeOEdFrI9whhg6WjglRWUkg/w/4lx1euUaPbm7Z+FAd7Qe8EJzp1v6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTUObpzjFlOBT3ok3P0A51UwHpSQmCI0hRJ5U8Rd7Hs=;
 b=APNd1LKMdHI5xuQenv/dImwTe1u5qQXYgci8XnN9MRv7gMyUQxTP5uxY8fFoJQoKmtWiYPIwu2WWTx/Nfq2Ii1ZaImjI+cBp73eWJda92CtPa7U2QY0CnRCsGuWNJev47eSZUzze7AS1431IOph6mwbwnNCw41/3JkFUpJNduWo2Z6Axh4xTjcaFWIvnwqQZcRfsnEN1Jqdj2cZixlwcVn5ZBsUawoP4Fsj4dQqJmbcAUJvbq04R0hs0HfVBq/ICDpnoxYzAQ87zwkqRBCtpnwzyXWze4cTudk/8fMtgQtlCkwuD7+07fclgysSfDf0Y62th4OFeeUbTuEU12eowtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTUObpzjFlOBT3ok3P0A51UwHpSQmCI0hRJ5U8Rd7Hs=;
 b=xtL0g+v9iOlgTQh/fnLSdnRJ0VxoIIz/Tf/ZMqeN3eDSt1frDLOfzq+6mICGcs9QL/d5FT44ff6qF0RKvICY8kpwavBxpf4XffWk328UpRtqTNStgEXC81jmwkHey8K+n9foT4g00Scv3C0P1TuevA5/x/n+7fnrq8LXq1RSmMU=
Received: from SA9PR13CA0089.namprd13.prod.outlook.com (2603:10b6:806:23::34)
 by IA0PR12MB7776.namprd12.prod.outlook.com (2603:10b6:208:430::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.14; Wed, 18 Dec
 2024 15:22:54 +0000
Received: from SA2PEPF00001504.namprd04.prod.outlook.com
 (2603:10b6:806:23:cafe::a4) by SA9PR13CA0089.outlook.office365.com
 (2603:10b6:806:23::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Wed,
 18 Dec 2024 15:22:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001504.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Wed, 18 Dec 2024 15:22:54 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 18 Dec
 2024 09:22:54 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <ashish.kalra@amd.com>, <liam.merwick@oracle.com>,
	<pankaj.gupta@amd.com>, <dionnaglaze@google.com>, <huibo.wang@amd.com>
Subject: [PATCH v3 0/2] SEV-SNP: Add KVM support for SNP certificate fetching
Date: Wed, 18 Dec 2024 09:22:25 -0600
Message-ID: <20241218152226.1113411-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001504:EE_|IA0PR12MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dfc7245-28a7-4340-9368-08dd1f77d83a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MU1ChP4/eoyB2ObI74BkrUwy+lHnIMVC0wJU5y69XzeWMyKYpigZtPo6rYB2?=
 =?us-ascii?Q?15NI1laat0NZDA3UJvxmTZgV7ST5FAgA+T1yLaQJBbvssZtmKfXnydbQ73yy?=
 =?us-ascii?Q?GMUJLIkZz0PBw9nUwcyzu/Y5uYqwFfVZ2Au5twoUQri9WJhKUTHE4HpMC0O7?=
 =?us-ascii?Q?hSlqcbTPPv1tYR8tuH4Ycz1x/ofO2koL6lZTK5r3uism0jSFtFrf7plt7BMP?=
 =?us-ascii?Q?JkvNmZJGeb6e9vvaYI+PozKjlpta//q0AV3g8KPFKNzI0oiqdZEVICxPg0DL?=
 =?us-ascii?Q?YOytcNB6Uxq8ZPi5fPdm+og++O6TWIngqof8XqWRc11ijodVa28Q81yMEftp?=
 =?us-ascii?Q?ke9DbX1jsL6pwL8VWzyxOcLBD7Vnp51JDiG9VkWae6leG9LFkzzlhekdWnh4?=
 =?us-ascii?Q?t47d6/dZ3HgUtHR0ljEQPSHQQncHCZMq+fEJ5GCQdKrM+GSw7YoRdgKfCe8V?=
 =?us-ascii?Q?xwZlGGdeVApSRR3J8jTsNW3htkYwhuhz8GcrWn56taEvYGCqbk6mEaRnLAc9?=
 =?us-ascii?Q?7UvyRKWCzEKjQhfCvGNba7k3leRVbs89LWby4uweZj1KtjyyqK+I+LCUFB+E?=
 =?us-ascii?Q?t4MLMxclpa4PMQiG8PseSiWG10Ug0CFsYjwHqIFljbw+3E2/vwAkr6cyoRl9?=
 =?us-ascii?Q?AbK7VTZVBQ1VnpTgY5BPoSXCpc4Zzi7AtZ5VkaMDYxPMAFouubUmzwdj6qym?=
 =?us-ascii?Q?y8Si1MtBMIge02oHusbgNz+sBUsTeHpesetgQ5kS1M0vBkvxukG/Qgrh19BV?=
 =?us-ascii?Q?2TlGnx3o9uyoPMEDIGfDMkpheaurtWQLNak11AoAhdYoYRbTNL+BErS73WHM?=
 =?us-ascii?Q?fURmrdE7rJmehEGZ5P59SbYhC+l5oa7Sp5zWrGzzEXIevPKsMnysDkERkX3n?=
 =?us-ascii?Q?KXrRxJ6ob35VHf/rZx04NTe9BnykRJPORbb+mO1BHdbRsN073aZQPSbSTo5v?=
 =?us-ascii?Q?+JvAOAiaInPoE3l9gHFp1LIq2xc2WqBkDZ7yNXnC8drLJ4ML6QDLHV7nYIFa?=
 =?us-ascii?Q?pm1d+gaJLqjiUcHFjDaN4lZJGmxxp1I76BZ5IcW36altNY7SoWg1mFGrT8vJ?=
 =?us-ascii?Q?/i1sP+VgictFCk0/Cm54tgGfW1QpTMcL84OXHGRcFuszhpFXDQ6JdYhBtMgO?=
 =?us-ascii?Q?Po57RLIHW32lSCBNUL9do0rTQSPEjdT1mol/Rhl6TSGIEGZF7aEsbWjSh6rw?=
 =?us-ascii?Q?dzaoxdsasrpy/ra2B7H05mSSj/CjB2xi8K1cNAmVK1Q20J6HsQ9RdOtjSJtL?=
 =?us-ascii?Q?/Fru+zNnOralW8Onexyz/KSWdQLAKh34dXULC5bbFcNmzwmU+an4/49HwSuO?=
 =?us-ascii?Q?YG3Ugk0ss7xIncgga49/cj2Hh/CuArTtBHWKxzeZgXhDp3bTKadxpZmyP6H8?=
 =?us-ascii?Q?/kbSOzjZolCmwguWZ7JgY6dsfRzFExkXIIthgkw5bb3UXblxPcf9m2c8nRl6?=
 =?us-ascii?Q?RbjMYxCqEp1Hxf4PdOdIcevslnVGTICF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 15:22:54.4983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dfc7245-28a7-4340-9368-08dd1f77d83a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001504.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7776

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-certs-v3

and is based on top of kvm/kvm-coco-queue (14cfaed7621d)

v2 of these patches were previously submitted under:

  [PATCH v2 0/2] SEV-SNP: Add KVM support for SNP certificate fetching via KVM_EXIT_COCO
  https://lore.kernel.org/kvm/20241119133513.3612633-1-michael.roth@amd.com/


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

 Documentation/virt/kvm/api.rst  | 93 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 43 ++++++++++++++++---
 arch/x86/kvm/x86.c              | 11 +++++
 include/uapi/linux/kvm.h        | 10 +++++
 include/uapi/linux/sev-guest.h  |  8 ++++
 6 files changed, 160 insertions(+), 6 deletions(-)



