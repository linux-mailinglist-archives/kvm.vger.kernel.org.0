Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23F21C62BA
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgEEVOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:14:05 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:6184
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726350AbgEEVOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:14:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3EehEmi30G9aN/ONUdl64uKYJP1AHjjmfJcTZzvTsRYut3aqHKjcDigYxF0fC4TcbAFO/BswSqRBKsATuswhJ+TrlcVV1VGU8vtB0I+y4mXkM72GjSFkno4CUfomcVTXILAgfOehQ3zwKg8iMed08q+edy8a9JjjcvX9LKI8clq7td6gF42T0BJ0K1j3/AXB5HcDfp9gfjRSzwJgsRlGey124WJgzyhdk8RZEOvCEjc42y15bJMH+e7QlbpLXvAhlBSy51vYKQ2p7+Ds5GOYNgBHaW7b9wOo1LXiBqnxr95bjvCrDwFTODiM3b1iSvRjywddjZPwbBz68TTu8qpNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQ0DRrQtL1xSXgKOx0Yl+9HFkiA4WpumX4oMlpwWUXs=;
 b=lMxHQ8zI4dHo+whtKqEYo8Jvxd02pcyB2ikuosDYOvJtV7o/JLVG7reJBPwgXmT+8KlLsfpqroMcPcthKtJcS+yS0TqVfVFWAZznwTZL/QE5JLYnNQgkkSoMcwX/eoFDjx6T7KSLZuhsEDQyV+xMj+oFSeaozU5zgrFoh6Tk2BOCsdkduFGPojaN97hioLPZv6kcM+4CHa3CJ51pQBGbHrn1Hd1KOtkEs7hA8Z3pKpa6D2GEQhqDp4lJOlklmlSJamDCbdaEPAkWl8X+aFodBlNe5sLFRHM5Yq2XywfIQQ+DNRHznRHDmwLDPc7AbONlB/YlxM7gAJpN56Pg1KbS0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQ0DRrQtL1xSXgKOx0Yl+9HFkiA4WpumX4oMlpwWUXs=;
 b=4SuVa8pxyr2dlqt6MsFF7OABZVjqi5fXsHRKypopGETdyNprsdfPcST+XzDVCUdtT+o/Xqi0PMJDnsR4WG0HQDS1JOhWP9qfwTABNdGGxiYgjfrwdtLO9drb1pOGDzpSvZfIpUNZtFF4nLseknC4bqpO38cimBgUrrZePJXLB4U=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:14:00 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:14:00 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 00/18] Add AMD SEV guest live migration support
Date:   Tue,  5 May 2020 21:13:49 +0000
Message-Id: <cover.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:3:ef::23) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR04CA0061.namprd04.prod.outlook.com (2603:10b6:3:ef::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 21:13:59 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 019c3616-da4d-45fc-36c3-08d7f1393ac0
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB251843CC345F8C2D2ACFB77A8EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WD7W6n+t6jJkfmHFZkhUEKCQ63rbtu8zr6cT7ii2M6ax+8+OrqQ0xBidBYkiO9vasWRVpaByDo10gdEggVtxUZUIHq7PV2WKY7hV5hPW7h1GWg2l0V+YIaZa9geeAuvGJ4sjlu1qivmpKXJBqj7s8L0TCvsADR+M3QBAOaFghbNtcfZSfHq6/vTRWawD6ll2UlqijPW5KgyG75jdmFZdT7ccf8X047WJO0KOgiAz9kwdfSCqD2Okc3weF3LIb1dPmsO6qFEScRMrrFzCGaC30DLC1ff+CijdXc84ar4RRcO22GZmQi2hpa+3D74F9w5QNL1Wt36xF1ghnf5fUYJbyeSfhoj0b8T8ZeEx1dyjvQ097EhOi99D2mRCVR3ZS/ECgSv1Sh31qHLOEKV/s/pJh5SWdK6b9SRNm2Uus0qL6jTnS6YruboSe2fbl+WVIz8ZrW90kbtC+JJofzfPUZpijbR5Ewip10VfM8I826+W3D98igdyrs3HZai7zdewLshXnpvJNLdinqUBFjh4zT/TTSms61TOAwhvuE7wevDgcQ6MZ3Ia0RrgntgIL5QgW5AWy5rXupcBg9jn8kns5gpMYEwtFJhhZo7yuAyTm9KN9mXulxhQc5p/WRpNh2PsLBYDCL7Qt8Bm7OZqetvDd+0png==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(186003)(966005)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3iDiNNsEaihwnUjf//XBhxMXjbZZ9mc/lSFHbCRs9ZTpwmzOs3CgxTWda4izI2uWpXzXQZuRSmOukJLZ+PYR6ni3+bKtSzyk4B/eTXK+VTdx3uPjF7rMe2RFL8HDdKYBUBgB+f14v671AzIVtV70Y++749wg6whqxNun/7Q3TLRQiGr8+6DMPWO1rN8yJkiKFIvVC0DsI6cZgm/0+6O0Sx0YOShVZVoiw0SU/+P2a/eq0EOCCd4YLs04suq7ScubviW59vGehbj6czN3Z4HpUoWzO+VgVc0FVq28C9JOQ5bOX0gBb6opye4BGImmn12QMGLIVHpFBfOV+TFnBacDLpO+PAewNGfy6UA95ZInHbt3RSvoaE5FBS5JQTAiVt3qwHI5Y4OW0qA0w/n1dT8JKa/9gv/dM+9v/8tF9+vNXJFDbRnFeN0M4PpyQUjMhetFaGsIZikkg44TQsQxg4eJEld47qi36trnH8z2nB2sa0YQOrs+AM8pTXrHRJYbrNH7SbLZHxabPfuCTE/jG8hCjqfOcmLBkvYcRhHoST4l1jOP1Y1iuRTrAlqu0QtwCSmBgQFwPi1rRdakTH2S6Pi83fXOpTKf4CJCRP61YmG2G3kttKnWUeTScarb1BUGCjhgU72nFOJNnl+6TQEukrKpOQvkHjWOQcR+H1wrOIaFRz23Xh8RF/wiJppJ/YlGPDDhWSicewq7HlLBZxVKKOdVeZ9yHFb60ZW7CP/S2z1x04gX5P54TQFgo8e9L6vPyHdurmvi7DYvhuqZftF4P513v5gDrLOTxO9+4l9VNoUun5s=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 019c3616-da4d-45fc-36c3-08d7f1393ac0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:13:59.9269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5IsrfyBe2SWd5Gcoz4wB8gsPGH7Mdp2R+07Bvcyi1j1ELktCm9Jm/Yx+FCketLAlsYHzs8MF9ISQbdfRwA4IpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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

This section descibes how the SEV live migration feature is negotiated
between the host and guest, the host indicates this feature support via 
KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
sets a UEFI enviroment variable indicating OVMF support for live
migration, the guest kernel also detects the host support for this
feature via cpuid and in case of an EFI boot verifies if OVMF also
supports this feature by getting the UEFI enviroment variable and if it
set then enables live migration feature on host by writing to a custom
MSR, if not booted under EFI, then it simply enables the feature by
again writing to the custom MSR. The host returns error as part of
SET_PAGE_ENC_BITMAP ioctl if guest has not enabled live migration.

A branch containing these patches is available here:
https://github.com/AMDESE/linux/tree/sev-migration-v8

[1] https://developer.amd.com/wp-content/resources/55766.PDF

Changes since v7:
- Removed the hypervisor specific hypercall/paravirt callback for
  SEV live migration and moved back to calling kvm_sev_hypercall3 
  directly.
- Fix build errors as
  Reported-by: kbuild test robot <lkp@intel.com>, specifically fixed
  build error when CONFIG_HYPERVISOR_GUEST=y and
  CONFIG_AMD_MEM_ENCRYPT=n.
- Implicitly enabled live migration for incoming VM(s) to handle 
  A->B->C->... VM migrations.
- Fixed Documentation as per comments on v6 patches.
- Fixed error return path in sev_send_update_data() as per comments 
  on v6 patches. 

Changes since v6:
- Rebasing to mainline and refactoring to the new split SVM
  infrastructre.
- Move to static allocation of the unified Page Encryption bitmap
  instead of the dynamic resizing of the bitmap, the static allocation
  is done implicitly by extending kvm_arch_commit_memory_region() callack
  to add svm specific x86_ops which can read the userspace provided memory
  region/memslots and calculate the amount of guest RAM managed by the KVM
  and grow the bitmap.
- Fixed KVM_SET_PAGE_ENC_BITMAP ioctl to set the whole bitmap instead
  of simply clearing specific bits.
- Removed KVM_PAGE_ENC_BITMAP_RESET ioctl, which is now performed using
  KVM_SET_PAGE_ENC_BITMAP.
- Extended guest support for enabling Live Migration feature by adding a
  check for UEFI environment variable indicating OVMF support for Live
  Migration feature and additionally checking for KVM capability for the
  same feature. If not booted under EFI, then we simply check for KVM
  capability.
- Add hypervisor specific hypercall for SEV live migration by adding
  a new paravirt callback as part of x86_hyper_runtime.
  (x86 hypervisor specific runtime callbacks)
- Moving MSR handling for MSR_KVM_SEV_LIVE_MIG_EN into svm/sev code 
  and adding check for SEV live migration enabled by guest in the 
  KVM_GET_PAGE_ENC_BITMAP ioctl.
- Instead of the complete __bss_decrypted section, only specific variables
  such as hv_clock_boot and wall_clock are marked as decrypted in the
  page encryption bitmap

Changes since v5:
- Fix build errors as
  Reported-by: kbuild test robot <lkp@intel.com>

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

Ashish Kalra (7):
  KVM: SVM: Add support for static allocation of unified Page Encryption
    Bitmap.
  KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
    Custom MSR.
  EFI: Introduce the new AMD Memory Encryption GUID.
  KVM: x86: Add guest support for detecting and enabling SEV Live
    Migration feature.
  KVM: x86: Mark _bss_decrypted section variables as decrypted in page
    encryption bitmap.
  KVM: x86: Add kexec support for SEV Live Migration.
  KVM: SVM: Enable SEV live migration feature implicitly on Incoming
    VM(s).

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
 Documentation/virt/kvm/api.rst                |  71 ++
 Documentation/virt/kvm/cpuid.rst              |   5 +
 Documentation/virt/kvm/hypercalls.rst         |  15 +
 Documentation/virt/kvm/msr.rst                |  10 +
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/include/asm/kvm_para.h               |  12 +
 arch/x86/include/asm/mem_encrypt.h            |  11 +
 arch/x86/include/asm/paravirt.h               |  10 +
 arch/x86/include/asm/paravirt_types.h         |   2 +
 arch/x86/include/uapi/asm/kvm_para.h          |   5 +
 arch/x86/kernel/kvm.c                         |  90 +++
 arch/x86/kernel/kvmclock.c                    |  12 +
 arch/x86/kernel/paravirt.c                    |   1 +
 arch/x86/kvm/svm/sev.c                        | 732 +++++++++++++++++-
 arch/x86/kvm/svm/svm.c                        |  21 +
 arch/x86/kvm/svm/svm.h                        |   9 +
 arch/x86/kvm/vmx/vmx.c                        |   1 +
 arch/x86/kvm/x86.c                            |  35 +
 arch/x86/mm/mem_encrypt.c                     |  68 +-
 arch/x86/mm/pat/set_memory.c                  |   7 +
 include/linux/efi.h                           |   1 +
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  52 ++
 include/uapi/linux/kvm_para.h                 |   1 +
 25 files changed, 1297 insertions(+), 9 deletions(-)

-- 
2.17.1

