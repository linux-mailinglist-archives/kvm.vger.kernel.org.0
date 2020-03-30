Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF919720D
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 03:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgC3Bfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 21:35:50 -0400
Received: from mail-eopbgr750052.outbound.protection.outlook.com ([40.107.75.52]:4518
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727954AbgC3Bft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 21:35:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDuVqgxLnhkz9LttfW0aUA+TK5G23egxFxX+BbSayUYgu9/NE+JrAZb2/7qN3biEez3blwH366effWhuCUhEA9w0ePFlatO4F+uvE8xLv6eOzaxS/vz4cBTwMgFv9Iw/Jfu+911Ih52OWQZ099UnyQNYM3fpbIO+MbKq0sYxzW0wt6Z42hDmcnxTihr9m++NDDb8rwJm4c+om/1tc5N9QmqQXwQ/mE2vZ8Pfw9xrzc8o1uaBoMR6dkdF4MnEuWymydbsMNJTs032/T0Pd39Qde39o88VL29u/sJM2E9eGx2zSaTnH/6eJnbM7ORSm3eYBWsWE2oU77Ei4VIoeozCpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJuY1bwe+LrxCM2EkNzzPXVKo8EfquN0WAI8ekNFYCs=;
 b=Jj45yfedUA9BejDK1Oczd+v33ad/C2VdU2uSrZiqFCoVlor6/7abwFpU5otmsfPEJy2GoW8uyV9mkjogGaIZ8gdq3Jv7NyPWkoBwjgKaTU5IM2Z80I92DxQZg03nl4Xy9ejBLkMI/Xk14b+1fRkpX+VBf74UmJIAeBjjyKINwk3R72HomCi/fNOybYarlVkk9c/XfI5bs+zxPYPAAcXwaEURZH58UqedYHuCRhqsQkZUOsXDduQAozEf8yRtU6pCrs2q7rLmqT5cmOJeMEEbuJ7+5TwsO7nltewRmqYrUJZghgVeiOPfP5dnyYk+41UJN+geHJg2RN0qQ6gpWfdWjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJuY1bwe+LrxCM2EkNzzPXVKo8EfquN0WAI8ekNFYCs=;
 b=0wlmazFxhZOqLQSBDc0xuRm9EM9j36bYWBkoCF7aNByW32z+gWEXE1IcVeyKOvVjYajUq9AOT94gcG0lf7F+KruOyiouh7lD995QKGz9t0hxM1gYwB2uMoUMncfT2XBSfcwFCM93afDoTM4k4ZSzon2rvvoWwuM61AJCVMCYbUk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1387.namprd12.prod.outlook.com (2603:10b6:3:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 01:33:10 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 01:33:10 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v5 00/14] Add AMD SEV guest live migration support
Date:   Mon, 30 Mar 2020 01:32:57 +0000
Message-Id: <cover.1585531159.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR2001CA0010.namprd20.prod.outlook.com
 (2603:10b6:4:16::20) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR2001CA0010.namprd20.prod.outlook.com (2603:10b6:4:16::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 01:33:09 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d9af49f2-5158-4eab-e9ba-08d7d44a4e16
X-MS-TrafficTypeDiagnostic: DM5PR12MB1387:|DM5PR12MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1387F6097C91803B4C65A2D58ECB0@DM5PR12MB1387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(186003)(66556008)(6666004)(66476007)(86362001)(6916009)(66946007)(316002)(4326008)(7696005)(52116002)(5660300002)(6486002)(16526019)(26005)(36756003)(966005)(478600001)(7416002)(81166006)(81156014)(8936002)(2616005)(8676002)(2906002)(956004)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wiuSB24KUMUK9A357aX7Woi6F9W/VGonSTyQOmURFjncZK/V21xEAeJSkadTEI3h7tZhTBmzXYp9Nizd4zMjZ74RrmHefyE73v9ME+SXqJte3IRKleu6z6WAZ8ZPL47GOE8FTgyed/gCclBPF68z73NQZzstcM8ubApCuF5TTiwJGV5GCeKFUXFLZLqe7dIsHmFXiQfL0nAEpjcFxa76cnjqdeXTaP9ShwpXc9RX0D50Fs2v5e2EyZR952N6xOjczMpec2LHDqOFwvr6Hj8XOzg0z3taHQPyRCph0hW9oluZT2ujJnF6xj7ExIAadCN0vKOw0T+3yU3EEBUS/Xqfd4SV2FHMEZpHkGDoHhDXHEH/c0lMFnOl8U4yuh/QIQH5DAyzD96+OngFr6tQkXFqIrfsREFjDw8Qijpne5sAw12d31cqRdvTSi88jFWGkECK4ULGOFvFFnGJI4n7fAOfp3uqOaunL3GvSIo1YLpJmhAnwap/h4RDc36Z46IcqTkD67VW3d6RaVM17sdWCON62MLFlrScIT6dShRfgoJed+/3xLsosRZiRIPWddnIxJfdiKk4ZGlaZ/ps+zE2t85eZg==
X-MS-Exchange-AntiSpam-MessageData: UKjZ40Zwb9o2+mPWYxApRaZtH2uqSKYzFwnRy4G6guEvPIabwqgjELGwVBkrzazEzl4PNWQfvjAyOMqi2R/UBALlih07kKNk8jNd9LzxbCWIP0FJ7fckz3QgsZlCeC4TsrzCPA2BC6ZpE6CDpwQLWQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9af49f2-5158-4eab-e9ba-08d7d44a4e16
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 01:33:10.1286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BD6uYHcS/kcLWLOxhaGS/z7BQi+vd7+ZT8EamO3g7zEnCteiBkWf9JxE/JfKJwgZr+ojPgXQdRNlXTGtKXvXqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The series add support for AMD SEV guest live migration commands. To protect the
confidentiality of an SEV protected guest memory while in transit we need to
use the SEV commands defined in SEV API spec [1].

SEV guest VMs have the concept of private and shared memory. Private memory
is encrypted with the guest-specific key, while shared memory may be encrypted
with hypervisor key. The commands provided by the SEV FW are meant to be used
for the private memory only. The patch series introduces a new hypercall.
The guest OS can use this hypercall to notify the page encryption status.
If the page is encrypted with guest specific-key then we use SEV command during
the migration. If page is not encrypted then fallback to default.

The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can be used
by the qemu to get the page encrypted bitmap. Qemu can consult this bitmap
during the migration to know whether the page is encrypted.

[1] https://developer.amd.com/wp-content/resources/55766.PDF

Changes since v4:
- Host support has been added to extend KVM capabilities/feature bits to 
  include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
  query for host-side support for SEV live migration and a new custom MSR
  MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
  migration feature.
- Ensure that _bss_decrypted section is marked as decrypted in the
  page encryption bitmap.
- Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
  as per the number of pages being requested by the user. Ensure that
  we only copy bmap->num_pages bytes in the userspace buffer, if
  bmap->num_pages is not byte aligned we read the trailing bits
  from the userspace and copy those bits as is. This fixes guest
  page(s) corruption issues observed after migration completion.
- Add kexec support for SEV Live Migration to reset the host's
  page encryption bitmap related to kernel specific page encryption
  status settings before we load a new kernel by kexec. We cannot
  reset the complete page encryption bitmap here as we need to
  retain the UEFI/OVMF firmware specific settings.

Changes since v3:
- Rebasing to mainline and testing.
- Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the 
  page encryption bitmap on a guest reboot event.
- Adding a more reliable sanity check for GPA range being passed to
  the hypercall to ensure that guest MMIO ranges are also marked
  in the page encryption bitmap.

Changes since v2:
 - reset the page encryption bitmap on vcpu reboot

Changes since v1:
 - Add support to share the page encryption between the source and target
   machine.
 - Fix review feedbacks from Tom Lendacky.
 - Add check to limit the session blob length.
 - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
   the memory slot when querying the bitmap.

Ashish Kalra (3):
  KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
  KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
    Custom MSR.
  KVM: x86: Add kexec support for SEV Live Migration.

Brijesh Singh (11):
  KVM: SVM: Add KVM_SEV SEND_START command
  KVM: SVM: Add KVM_SEND_UPDATE_DATA command
  KVM: SVM: Add KVM_SEV_SEND_FINISH command
  KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
  KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
  KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
  KVM: x86: Add AMD SEV specific Hypercall3
  KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
  KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
  mm: x86: Invoke hypercall when page encryption status is changed
  KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl

 .../virt/kvm/amd-memory-encryption.rst        | 120 +++
 Documentation/virt/kvm/api.rst                |  62 ++
 Documentation/virt/kvm/cpuid.rst              |   4 +
 Documentation/virt/kvm/hypercalls.rst         |  15 +
 Documentation/virt/kvm/msr.rst                |  10 +
 arch/x86/include/asm/kvm_host.h               |  10 +
 arch/x86/include/asm/kvm_para.h               |  12 +
 arch/x86/include/asm/paravirt.h               |   6 +
 arch/x86/include/asm/paravirt_types.h         |   2 +
 arch/x86/include/uapi/asm/kvm_para.h          |   5 +
 arch/x86/kernel/kvm.c                         |  32 +
 arch/x86/kernel/paravirt.c                    |   1 +
 arch/x86/kvm/cpuid.c                          |   3 +-
 arch/x86/kvm/svm.c                            | 698 +++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c                        |   1 +
 arch/x86/kvm/x86.c                            |  43 ++
 arch/x86/mm/mem_encrypt.c                     |  69 +-
 arch/x86/mm/pat/set_memory.c                  |   7 +
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  53 ++
 include/uapi/linux/kvm_para.h                 |   1 +
 21 files changed, 1152 insertions(+), 10 deletions(-)

-- 
2.17.1

