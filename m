Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072CA27914B
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 21:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgIYTEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 15:04:21 -0400
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:21825
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728069AbgIYTEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 15:04:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxX2xakAVsIBbq2zuTif663+UBd9mXhVNS0I2JDYkIFhaF5Nip6MRT1f/jOQJcmLXqb8ScvS5WT8o06OTe7VH0/WKfDHe7xPgK8dbXAeLNwGxqELtjnrH6NH5n7aRbTdFQwLPkYkRewoFSN6A7Br/qptup2euz9EFgLjbva2XEkW4/vZ8bStXrwYd5aXCFjrBFe6AaCen/XuOhnJCjaqTNpsGsygIay88j5N0vgnWtV9JAg4LejxQd3JX265EXmSfWVSRMiwz03okEQqU4wu+UpCbJiNz6iwchK3ocGddOetBrGarjT04HNoopoDBJpZ205XN3+n0jQwLua9/MGlYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPq7mKywqVJZ1A0hpheU2wUMay/4kqACwBuweMnWVm8=;
 b=b6BNrJRobVah4dj4C6KVDfZGjNYdldkBMirW0kPrq+fHw9y54CDYvXSPOefAzkc3H+6C0t0a1R6BRmePtbVBR0TbzTctt4yrMrwiSJ6UDlUuiBg8ycHrOugria6p7AzLyUqdJqHs/NcCE1vVwey97TDuZbF0i2AiNr/lXwpjEZvabsRrh1kEVGm410UkKij8gSw7+QJmOs/lcIXuWDhuveXlBEp6qX5lhSU8EP2YVu5g/TBju6lC7UikGvjUAEHSmIH3EdcYfZ58WyDNezm/aQDxYQIMTQtZiJpPtR0ChBV9hH927pRKEkNMVPQt674wGGVpvH+YGCYPtY7xCgvKuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPq7mKywqVJZ1A0hpheU2wUMay/4kqACwBuweMnWVm8=;
 b=lx10b1kXswl+Kz0TmPyL+DHYmjXZs4Nu7PsD+6logpwhCRivvnRWEcz/yOLsE9F2spbX0U5l96UPbhfYAUodHxK68dmSuXmKb9c1EcE2jVuEBI+V/LHbMeo7di6f3l/cyy3ubWYJRpjV33njFSRGExXR3KVEttedqkFiRL4yS5w=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.22; Fri, 25 Sep 2020 19:04:17 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Fri, 25 Sep 2020
 19:04:17 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v4 0/6] Qemu SEV-ES guest support
Date:   Fri, 25 Sep 2020 14:03:34 -0500
Message-Id: <cover.1601060620.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR12CA0121.namprd12.prod.outlook.com
 (2603:10b6:0:51::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM3PR12CA0121.namprd12.prod.outlook.com (2603:10b6:0:51::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Fri, 25 Sep 2020 19:04:16 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f15d430-0b96-41ec-9823-08d86185cd27
X-MS-TrafficTypeDiagnostic: DM6PR12MB4297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4297E6EAEA873DBD2D0A6BF5EC360@DM6PR12MB4297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +IFiiFfKISANgFubJdQuc+wHLNU7TYsrSmKfrDRJ7OwJCuXxed3QlttaEtb7dnLWMVNYkjiMzN/5uAngIILqA3S8BLFvIPRWZdM7tMXQq5tHHi2Q0O0HXJJy9oSQpqKju6rQ2WemNngoUC1WRHK8lnTuJhx6pQ4FOhW5vqPCmXy2GRPvHnD1y7YUKaKO2BPeZ+JyyIEekCmrnkXl0BH85MIhMHOBPGICuWAQckKxY/i2qOQ5ydMJG1pZ0fv5YI4lPLUC83HC0vBZklLi5RVzv1qPkhDR3d204DW3LFTml4qutzC0Pxy7cGNJ78KbaA8MLTDlSE8RervHgDzGE+4D9CLwpwpyztxcC6Pf/kmLQE9f+VCzCFd9ho4RpVXfLmQbT9TAP9wdc9lX6oYfNhYgTHqen9DOo50oNfgugVuMeIlo+euiI4gTIqoEx3bYa5PP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(26005)(7416002)(956004)(186003)(6666004)(16526019)(54906003)(2616005)(6486002)(966005)(66556008)(66946007)(36756003)(8936002)(66476007)(86362001)(316002)(478600001)(7696005)(52116002)(2906002)(5660300002)(4326008)(83380400001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oohA0++EeEjP/DszGoBcm+KVazAN3iYU4BcXMfDWttpZWVWLro/qP1pBLlHJw0fGZZ2twoYRqhLVkoNOoDcZYn3kjOB9CZy4WJO5aRy/t96Z3IwUDItJlpXvzZiWxrCN0wgO2yXbg69Gj4iQ1oqhsrqFyOunYYr5dkfnciz7/7O0uJYnreZAwndaDqRstGIanjM2jtBU7RkADOn0U1o3lW8Wo6cijmDZdSli+36FuW2cwpN8l5iP4mLr1Bm1IaXWmh/al+ZmLtTciV1uPL2WmrWh/bOCgAwU9a770Z6wLAc742fSkh+hqNEEgK3ZaZsyM4z4huE5uDhZ+F1uhENp+P/+3xoK7Z18FUD23Yyg1sn9co/Aoq9kfewAOzYZVTIGrDZOFE1O8unHvKcJIovFU3xAqPSXu1BR53gOo2EiCozMZD9CPtP4G9B7RH5i4Qnyv9GRUR8hybl8jhDhCYrXdPr4S+g1BT2M2U/6EKnU25A1FgBqppJ3lS1V9Gqtp7srxjzd9+xEWS9RCsyWEPoiJNlA1zu7SwfGouffi1PN7qgNFw/MGCNodgKBQ2olaKaiCRsYBq0rabCA8we0+uidIGl1XXnoV7KatjLGMbppoFsH2KumUoZ/9tC1/4cHeMaUqijjp/K7uNBymQyd8pVvJw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f15d430-0b96-41ec-9823-08d86185cd27
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 19:04:17.5872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WX9G5PjvDfdbtrDfHSljWf7LC96YXzguo4Wp9kEydbHgYYAX8yI/wnx4vvJ1T+DVbDYeMG99w2LbYNg1JiLLyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This patch series provides support for launching an SEV-ES guest.

Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
SEV support to protect the guest register state from the hypervisor. See
"AMD64 Architecture Programmer's Manual Volume 2: System Programming",
section "15.35 Encrypted State (SEV-ES)" [1].

In order to allow a hypervisor to perform functions on behalf of a guest,
there is architectural support for notifying a guest's operating system
when certain types of VMEXITs are about to occur. This allows the guest to
selectively share information with the hypervisor to satisfy the requested
function. The notification is performed using a new exception, the VMM
Communication exception (#VC). The information is shared through the
Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
The GHCB format and the protocol for using it is documented in "SEV-ES
Guest-Hypervisor Communication Block Standardization" [2].

The main areas of the Qemu code that are updated to support SEV-ES are
around the SEV guest launch process and AP booting in order to support
booting multiple vCPUs.

There are no new command line switches required. Instead, the desire for
SEV-ES is presented using the SEV policy object. Bit 2 of the SEV policy
object indicates that SEV-ES is required.

The SEV launch process is updated in two ways. The first is that a the
KVM_SEV_ES_INIT ioctl is used to initialize the guest instead of the
standard KVM_SEV_INIT ioctl. The second is that before the SEV launch
measurement is calculated, the LAUNCH_UPDATE_VMSA SEV API is invoked for
each vCPU that Qemu has created. Once the LAUNCH_UPDATE_VMSA API has been
invoked, no direct changes to the guest register state can be made.

AP booting poses some interesting challenges. The INIT-SIPI-SIPI sequence
is typically used to boot the APs. However, the hypervisor is not allowed
to update the guest registers. For the APs, the reset vector must be known
in advance. An OVMF method to provide a known reset vector address exists
by providing an SEV information block, identified by UUID, near the end of
the firmware [3]. OVMF will program the jump to the actual reset vector in
this area of memory. Since the memory location is known in advance, an AP
can be created with the known reset vector address as its starting CS:IP.
The GHCB document [2] talks about how SMP booting under SEV-ES is
performed. SEV-ES also requires the use of the in-kernel irqchip support
in order to minimize the changes required to Qemu to support AP booting.

[1] https://www.amd.com/system/files/TechDocs/24593.pdf
[2] https://developer.amd.com/wp-content/resources/56421.pdf
[3] 30937f2f98c4 ("OvmfPkg: Use the SEV-ES work area for the SEV-ES AP reset vector")
    https://github.com/tianocore/edk2/commit/30937f2f98c42496f2f143fe8374ae7f7e684847

---

These patches are based on commit:
d0ed6a69d3 ("Update version for v5.1.0 release")

(I tried basing on the latest Qemu commit, but I was having build issues
that level)

A version of the tree can be found at:
https://github.com/AMDESE/qemu/tree/sev-es-v12

Changes since v3:
- Use the QemuUUID structure for GUID definitions
- Use SEV-ES policy bit definition from target/i386/sev_i386.h
- Update SMM support to a per-VM check in order to check SMM capability
  at the VM level since SEV-ES guests don't currently support SMM
- Make the CPU resettable check an arch-specific check

Changes since v2:
- Add in-kernel irqchip requirement for SEV-ES guests

Changes since v1:
- Fixed checkpatch.pl errors/warnings

Tom Lendacky (6):
  sev/i386: Add initial support for SEV-ES
  sev/i386: Require in-kernel irqchip support for SEV-ES guests
  sev/i386: Allow AP booting under SEV-ES
  sev/i386: Don't allow a system reset under an SEV-ES guest
  kvm/i386: Use a per-VM check for SMM capability
  sev/i386: Enable an SEV-ES guest based on SEV policy

 accel/kvm/kvm-all.c       |  69 ++++++++++++++++++++++++
 accel/stubs/kvm-stub.c    |   5 ++
 hw/i386/pc_sysfw.c        |  10 +++-
 include/sysemu/cpus.h     |   2 +
 include/sysemu/hw_accel.h |   5 ++
 include/sysemu/kvm.h      |  26 +++++++++
 include/sysemu/sev.h      |   3 ++
 softmmu/cpus.c            |   5 ++
 softmmu/vl.c              |   5 +-
 target/arm/kvm.c          |   5 ++
 target/i386/cpu.c         |   1 +
 target/i386/kvm.c         |  10 +++-
 target/i386/sev-stub.c    |   5 ++
 target/i386/sev.c         | 109 +++++++++++++++++++++++++++++++++++++-
 target/i386/sev_i386.h    |   1 +
 target/mips/kvm.c         |   5 ++
 target/ppc/kvm.c          |   5 ++
 target/s390x/kvm.c        |   5 ++
 18 files changed, 271 insertions(+), 5 deletions(-)

-- 
2.28.0

