Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E6F257D8A
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 17:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgHaPik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 11:38:40 -0400
Received: from mail-dm6nam08on2055.outbound.protection.outlook.com ([40.107.102.55]:38992
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728655AbgHaPhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 11:37:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZBS6/83ZB3hVKddpnqJwL3OmV4qHHOc5AN/LAhgdkSapndor5CRS7zQvPbMH0foK3wQgmTTKOGqnKMmB+D6lKkhBu7FweEJECK7Jf/nSKsp3G2eOyvLdzXD6+SwORq4I2ds/7C/M62LTbVhJA7zVqNkSyDWlLi8qDFkJM5q11waBbgsUDVoagruisZ41PXSC/w9m3Rs9v6DUK4cozXqsM1jFFwlcUAWzYXcJkQMHM64G0R7iUeREj5xvGs6LQ0dRl/A3q8l8cxfh+Ve/S5j4hdR9HbZdoC3AYHw5o4LAdAWOBuZl+yAJIGfrUe69ug6Yjfu/uJ5XDXpUaVRyKmjaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZ6+szD+ID4g5++/QKWSa+ebqnmajC9g4WYXGoRXiwQ=;
 b=LowbqtYso7k7WSaZG4R0wS5GAOYoE6tJZjLTWOLd8peVf/neml/xB437GLThmIWla30GTyERYKVZb/lflAMkocllVuKinCsNpYPhgZUelRkdHWjtpVcBpO05xuhM/IeZkT6/cVWLoZwBHvK8MZf0PN5Qd9xEVuXWTCMXkBEtT1GZG2/B1bcO2HT1DBUnvBeDkiNOgb0UQVpKOlnRo4qtYANIdGEC1F2DcrQJhEWzhwK3dwTyITZQ7cD/SD2xPS8rwR9ukiQ83yFVjdGdiSl6nO9rUSoPiEuKM3EjT0rrrmKGZg3bnxkrDWFDKSEY142waYBls7OqX9kn806MAwrGXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZ6+szD+ID4g5++/QKWSa+ebqnmajC9g4WYXGoRXiwQ=;
 b=SQgSFKsBxN4Z42pvB8kbGI7KsmqbKhE+rDtGZffWH3stiYx+7JafeyHdjmACTmllsB6wGKC8yzGS7OO9LGoTYEQm+ZjxV/P1Qt8GdgMSyuKOENCfMJ7Fu6mO6vGJjxU/ukhxJ2TCiCnSjmRB7JLrCRtPJFZEktJsOpyY+E7wTAg=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19; Mon, 31 Aug 2020 15:37:28 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 15:37:28 +0000
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
Subject: [PATCH v2 0/4] Qemu SEV-ES guest support
Date:   Mon, 31 Aug 2020 10:37:09 -0500
Message-Id: <cover.1598888232.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0011.namprd05.prod.outlook.com
 (2603:10b6:803:40::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN4PR0501CA0011.namprd05.prod.outlook.com (2603:10b6:803:40::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.7 via Frontend Transport; Mon, 31 Aug 2020 15:37:27 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 36f710d3-1b33-4f52-be30-08d84dc3c446
X-MS-TrafficTypeDiagnostic: DM6PR12MB4484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4484A3DDBE68747368978BA3EC510@DM6PR12MB4484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KyXrmsCQqJqETX5jC4xSEe3++XXr1IqP1htfHeJadNlAJmu4n+D13GqTYyd9GlHcQNAm00d3khkCGCBBAs0C3ozbZF9FjUGD7OhbXZMFo679K2dqQdfwz+v7gL43r70wDE2XxtC/h3d3wtbdTfZs1NiBf2lmAtCI5AAMbei4tYApgxcVMH5yZA5aLttwPLLtbh65HuabvDueAe65JnlnEKkunVmnZKCx9Q2J9jXv7gpsWnOzZxDZYskU3xMbgAxThq2F/4NWE2jZ4v4XBLunQfYPdYNqaaeHyRwlHi50GNKzxlIKXrpfiwLgVUQbwBkw16SZw9Tfn9lvpxOHFrmWgi1fmgdMQrEH6NWAewaGtcVsfrqac/gKOnsDk+4PdrgYbk+ChZBh7lYHz7/b+lB8kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(54906003)(956004)(966005)(16576012)(7416002)(2906002)(6666004)(4326008)(2616005)(6486002)(316002)(66556008)(8676002)(66946007)(478600001)(186003)(5660300002)(8936002)(86362001)(83380400001)(66476007)(36756003)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I2gbbspU8tDUPtqlRZ4vGDc6kwwJTPu+2NBt7GZTW4zuv8957GNSttltKgi9RRVAKHnl9dTaohZ3/rZHoFl3OkcG5LJraYeFP27lSeB63PKRwcs7SN1hyR3HaKclckXKAy79Dh3fwMKHXojczEi+2h8hijC38gjr3SGERthglseeAEFg8bWbK54IuCL+Tey23kQ8lwcYX2pfzu6olzrlwwR3RjX0/Xa4FAmb90vVHEvBuKtqDA4Scq96rLgUX+ffiXBTEpsGCoGCIf/brcooBVA6g62CX2h3PQDH79XeuixqJlK9MK6NqRE4YmTTmfBU16z92jbQzN8KylFKkP8SxuEatqfSNMjLWwixnRo10nOfQ3tWLdo9/WuNqsLAb+Oz6kxalQCpsPvMASgkshpQ/KsD5HKEvVCaaJvT8T9cgD8jcCXKbhOTkWYi4C2/+IFwTgGaL0HnYBwvFI+IJbKgD1RF4q5//ApRYBS+mLTBqYWPXnd8UDV8HgOaINz2S7yI7KLc05pkuuYothnY0mDnZzRJJeN/wtkvGhbLokoIhNzOtJ3VWSHU8Gzju72vjCOLlL0kUIGsf4DGkVE7rWO73I3c+/GpEmn9PeYFNTucHo2HeVa07gL1fi6K1Byb8PJPBuJqG8zrMTHyx8vCEOGB3g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f710d3-1b33-4f52-be30-08d84dc3c446
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 15:37:28.2925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6pKzLdbCWHE0mvw5ukuXiyQaDWhTZ2u4eE0RkhrdBcZssfpyYqFTtQiMdSF7kC9x7lQDeubaUQ7n0/pEBjI5mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
Sender: kvm-owner@vger.kernel.org
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
performed.

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
https://github.com/AMDESE/qemu/tree/sev-es-v10

Changes since v1:
- Fixed checkpatch.pl errors/warnings

Tom Lendacky (4):
  sev/i386: Add initial support for SEV-ES
  sev/i386: Allow AP booting under SEV-ES
  sev/i386: Don't allow a system reset under an SEV-ES guest
  sev/i386: Enable an SEV-ES guest based on SEV policy

 accel/kvm/kvm-all.c       | 73 +++++++++++++++++++++++++++++
 accel/stubs/kvm-stub.c    |  5 ++
 hw/i386/pc_sysfw.c        | 10 +++-
 include/sysemu/cpus.h     |  2 +
 include/sysemu/hw_accel.h |  5 ++
 include/sysemu/kvm.h      | 18 +++++++
 include/sysemu/sev.h      |  3 ++
 softmmu/cpus.c            |  5 ++
 softmmu/vl.c              |  5 +-
 target/i386/cpu.c         |  1 +
 target/i386/kvm.c         |  2 +
 target/i386/sev-stub.c    |  5 ++
 target/i386/sev.c         | 99 ++++++++++++++++++++++++++++++++++++++-
 target/i386/sev_i386.h    |  1 +
 14 files changed, 230 insertions(+), 4 deletions(-)

-- 
2.28.0

