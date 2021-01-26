Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C91304C52
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbhAZWgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:36:36 -0500
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:3264
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392492AbhAZRiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:38:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hx6BJSqImoZVpgnZMkBP8a7Kryj7ebJniOKWLQVviaYBBVwnEAF0xpdzLj1Ag2b6SyAXjjQPtu5420O5zREs8Sq5EXOKkMEm04FHD5qn71wDk34dpsFDtOhDlmhk2nlsQuN5ZnAQKJbZzlMPkLZ4305rRxxesBcVwqeXYURdBOxpGjlVuCRrL1A4OKYNo9quFeFXsacX9KIcQh5LlrSkoGKIs2TW+eesWWLzoawdr246FxdD527lggvA/GanxNQlKoEK3znvat5jwIC48uPtbjm+uqj9n4hUOM8wpeM+r2Afa5ZNFrz0XX8lt/q14/YofhGDCf/uIS5JqL4k46kPlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6MOkBBcpubOvgl4hCEAjOyS4NBnDXd58l2abFH7eNs=;
 b=CWjg2oZGgIdBw2S1XqR7mE9uEkGx84BnhPtHQ8WF3BT83GXfvxC6pBvfn9fqF5DU7k2mHm228F7b63tWnHgmQj+M2SK3qjwo0blrfxWWeKxREO2I5vUcd2p4bBjmn11OYMSVYDf6Olfy+7pZtLVO5AE2YC6ZQseA+KPbv1XdsZ42a46FoahRclM1XTIW/EhgHFanIN2/y9onzGavMpV590PQQTfifuMxKGmLt0NKJuAHFwPUhyn8/D9HYcCZ+okjlczAOA8as3TugA/k3R9SaJOgvemCVke6E4EJkfa7oVAPbzIo3RuWFH9lhrO4RNg3HHFB+uWVcT1zvvMaX1bpdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6MOkBBcpubOvgl4hCEAjOyS4NBnDXd58l2abFH7eNs=;
 b=eedsVTutuTES6NJZ7f2NvBZ/nJE8B3QIR26XYwrSxK8ughLX3bxVHH7V29vVZWl0dVT/kiX3UK5d9+x46d0yhtjF2BbYROsQHRUzBWOvDl5tdSfWO1mQ3qzBpsumyY3+RnIA6r7ppeEczF6QkuE9zDEds+YBrSzWbf/mtyjsXUU=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Tue, 26 Jan 2021 17:37:05 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 17:37:04 +0000
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
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v6 0/6] Qemu SEV-ES guest support
Date:   Tue, 26 Jan 2021 11:36:43 -0600
Message-Id: <cover.1611682609.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR04CA0102.namprd04.prod.outlook.com
 (2603:10b6:805:f2::43) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR04CA0102.namprd04.prod.outlook.com (2603:10b6:805:f2::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 17:37:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56da634a-aa8a-4cc9-01a9-08d8c220ff11
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4153244D31AF13197756FE1BECBC9@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Om57hovJUlyALvCSA/3I5q9cel4P3AkBLE3vo9z5daIYv6AWzcGmOdNHrT9IPg5UKv/iWvmVxwrznjvKEZOpmuUuz33ROFV4p6amjHowD3iRygq/GAdRky+bkKJhbSPXcYxYSMhO5OPGAVgMtkhgRKzGSoqm7gm9tkt2RjRyviExYThH0BRmve9hN1fpreHupRZs4yW7/HO+DxMCfy1xG3CRlYUGruEgjX9v6nNOyHcpJHgKrwXT8UgHkxkMQTRJw8zr5NLajbTm4rJHxTuDesxOrkedel0hkr+etVttbr3PvY6bCJ8Itv7StbZ/ib5yJkkRPoNGa/oFdpz16dU1bDhpXbN8wx+qcDyJv9DJq5uu9wUBWFPRYXiGxqEUwjxpH0Bd1vbjomhBXSrvvNnSjeUcOEeoDJQh05pWTZdVbdFw4PDPTJCAXQG3RzvmLilZp4MRYls2Oo35XfEXEezsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(8676002)(7696005)(52116002)(478600001)(6666004)(966005)(7416002)(4326008)(2906002)(66476007)(316002)(54906003)(5660300002)(26005)(2616005)(956004)(86362001)(83380400001)(36756003)(186003)(16526019)(6486002)(66946007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JCvcO06qKEUTTohkc8qMkLa/Tg5XV7sE5cVR6+dYjxjU/qJSaVo6yJqmSCFr?=
 =?us-ascii?Q?xS1mCq6OnQGPzIZynZOMNDFgydwPsTHfL+lYpgD6hiXjyisT6X4s0piHpb0q?=
 =?us-ascii?Q?Zo4hNfh05oGJn6+vQ7XNWdpPnchnsoYkYYJNnWG/VN6XnbLQe+nY/6aLocgv?=
 =?us-ascii?Q?Pr6nltwMu0YV5hlYoZIV79dk5tNLOFoG5H4P0OF3gMP7AiCH+0MF3ebIgIlT?=
 =?us-ascii?Q?fSgHwtc7RoDE2KVsM5f5FMjPNqFMpkPz0jCkUnMO/xvIT9mD53U90UtseCAp?=
 =?us-ascii?Q?MEsb2p/3f5haf2FQbCXOrKdyvwgCYKPqHjfJO/1t765J8pNJ4iT4ebl1IhNd?=
 =?us-ascii?Q?8Knivh9Fupg40ibKTlC7Fw9jxamKNulZsyy/0nEOlsC/KtM/3DlaAIj52qnS?=
 =?us-ascii?Q?NmTZ283ndQztC/B/BiGIJobskYQZrXlyzC350I/bqCl7LjreG4u6bVA2l1Xh?=
 =?us-ascii?Q?Q1m6jW8X50vkoOI7JT6PG56Xejg6PJbc5u354/u19Aa8wXhoS1zLb7s4Tr3H?=
 =?us-ascii?Q?13E3XDIIFmwOGL1VfDpL8PD8vIGolBwO1r4rz6lcLKQ0MP8JDMeY5kF4uo0S?=
 =?us-ascii?Q?BuutwC0JQ0xbP2+fIgXPEtTAvcMLJ+N8WnR0vdb2kGplbx5DvXWDuCChsjS7?=
 =?us-ascii?Q?7RHMYXaYF676Asm3v48RtVTjlDaeIEpS6+iWi81ese31EAQF5DTsbJcVvRf0?=
 =?us-ascii?Q?iepckVkdgmjFdiaLqlCxmg3FY7Ezj88YM7oxxD/Gg9WhYnRzNmXsXjlqDyTJ?=
 =?us-ascii?Q?qgtgvdYA4Y8lBXzesxS1r6I6dKQsA+WeqQhnmBec9/y5exJvBsR1W3LYeyQ/?=
 =?us-ascii?Q?mpKpezeGSn69oiNfsht/iWoG+nesEJZOz10A4paY6518UyE9RdoyNR+pyhes?=
 =?us-ascii?Q?/NUIdwbkJAeMRfhD2cdLIIk1oD1EEFH494etQPMyQ+br4TZx91wdylw7xvyT?=
 =?us-ascii?Q?kvy92XF1gSS9veTepXEyHw75PamS7DIBBb5ac9/jbNy8vR1FF2b/C+oX8+vu?=
 =?us-ascii?Q?WJDScUnLLtXto7Agw0E5T0ptpHJCD323sRHBtrojhGy/4QLKDrR797o924tn?=
 =?us-ascii?Q?KEgkgUoh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56da634a-aa8a-4cc9-01a9-08d8c220ff11
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 17:37:04.8321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83DCcZb4IzaeJ2nlNqWnMRMIUSqVzjxHArzQsgG3LDipNakIr6pid4i1DsS5VnXfSE3EUgJg4U6ZS6qLaTgViA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
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

Cc: Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
Cc: Aurelien Jarno <aurelien@aurel32.net>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Richard Henderson <richard.henderson@linaro.org>

---

These patches are based on commit:
9cd69f1a27 ("Merge remote-tracking branch 'remotes/stefanberger/tags/pull-tpm-2021-01-25-1' into staging")

Additionally, these patches pre-req the following patch series that has
not yet been accepted into the Qemu tree:

[PATCH v2 0/2] sev: enable secret injection to a self described area in OVMF
  https://lore.kernel.org/qemu-devel/20201214154429.11023-1-jejb@linux.ibm.com/

A version of the tree can be found at:
https://github.com/AMDESE/qemu/tree/sev-es-v14

Changes since v5:
- Rework the reset prevention patch to not issue the error message if the
  --no-reboot option has been specified for SEV-ES guests.

Changes since v4:
- Add support for an updated Firmware GUID table implementation, that
  is now present in OVMF SEV-ES firmware, when searching for the reset
  vector information. The code will check for the new implementation
  first, followed by the original implementation to maintain backward
  compatibility.

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

 accel/kvm/kvm-all.c       |  69 +++++++++++++++++++++
 accel/stubs/kvm-stub.c    |   5 ++
 hw/i386/pc_sysfw.c        |  10 ++-
 include/sysemu/cpus.h     |   2 +
 include/sysemu/hw_accel.h |   5 ++
 include/sysemu/kvm.h      |  26 ++++++++
 include/sysemu/sev.h      |   3 +
 softmmu/cpus.c            |   5 ++
 softmmu/runstate.c        |   3 +
 target/arm/kvm.c          |   5 ++
 target/i386/cpu.c         |   1 +
 target/i386/kvm/kvm.c     |  10 ++-
 target/i386/sev-stub.c    |   6 ++
 target/i386/sev.c         | 124 +++++++++++++++++++++++++++++++++++++-
 target/i386/sev_i386.h    |   1 +
 target/mips/kvm.c         |   5 ++
 target/ppc/kvm.c          |   5 ++
 target/s390x/kvm.c        |   5 ++
 18 files changed, 286 insertions(+), 4 deletions(-)

-- 
2.30.0

