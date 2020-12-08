Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBFC2D35C5
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgLHWD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:03:57 -0500
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:57761
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730495AbgLHWD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:03:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYCdBBodJ0uxIhM3eJqHQKdrR0x0lsag4GNqe9TohITuzGoUuDtAVlK0nS4FH1etdcnwXDt+569A6AlrP2+xzQ7lwWGYjp8ghS2Ro8ZTzspy6nIO8AtcG76Y/9fJI1hlfgzgoBsLGjbSQLdR/fALF3+ztjYiSKjUFNYqG7EnM3ysKGh6Vx8dowzX+f3W5b5e/73k04gTeCZz0BoXwVEh3oa3PIdAcXqW7l9s7oRKeVD3HEmtAA/c84vEesSdsyK/LhCeoiH9wQUgJJr/ctil/j3iK5+BNbKnQqmFEeSIOLuVXak/CqQYlmxloy2PqBVMPU6Bf0j5hARdD6L6MA1k5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqb9km6Xdj9sv4bC5TjdtD0HVPfNSBqbpBU7dlNqzBo=;
 b=EnScbryHnJlnOHAoEKtGDwl7WddeOhmIIlUq17oqFBMHDy3Es7X0xtZZnL700vZb1OZ4XyLJX2GCaKELXQ2+/NAjfqkZBHUcOGw7Qxpq3U0R/6ZKvwMVxobWVO9pA8h6GKcmTHPfovG1swA6U+hy+mYzXD3ck2yZeQ9DzT5XneUkNn/S+iv0Y7w1Z/8nb8rvW9LRsgOSKRaNTWug+sb/XfIKjKuCDBlxxJqzbV11b8Q5awV6mSDOxaBdlIXqfQAzxqcWwhZm2BDQkPYZ8uqviyMynh3XYTJMmsR2YGOADwGZ+0R5/Q+dOhEpBquIWSmotYQeY9pgfsHEXNC0WOyDKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqb9km6Xdj9sv4bC5TjdtD0HVPfNSBqbpBU7dlNqzBo=;
 b=hivDEw7qV5tbagUtYAwarlb1g4UWo1+MT+prPL3M+s6OC2W+iKm4kcq9LKylHJma2uRoQD2ANZpsZp32zml/UxAojWkIuTug+EM9WWiYA4g8LxcHoXJxsX23ARlQh3xrFN4WXKbnljncsgkACneCU0grBYEKyvuYf/zlSLKQkmo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 22:03:01 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:03:01 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 00/18] Add AMD SEV guest live migration support
Date:   Tue,  8 Dec 2020 22:02:51 +0000
Message-Id: <cover.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR16CA0067.namprd16.prod.outlook.com
 (2603:10b6:805:ca::44) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0067.namprd16.prod.outlook.com (2603:10b6:805:ca::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 22:03:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa2952ad-7ae3-47fa-14c0-08d89bc5080f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB436532B8B06B0C38E55B7D538ECD0@SA0PR12MB4365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/nywQT84B0vCP+xZodJ1JHNwjcL1WWgDr9hnqiZjVOvyoE59WOdE7ZryzpUJhLoCgZ37kLaaPuSmcKJSpIKoEOE2fwaeqtzmj1elAOQATZ1YSjYX7DZJlYC4YwMiyRc4X3bGpyXr3+J+yEnkRhXL42WBXptSQkTHWZbMq3NRnaIh/8uymoH0qXXXF2ouvYsFHCklbQuoanX3+7PYb+I1tVWwuhu7l5qWfN/CIkjgrQybvF/UAtGK6k1HuYwCK6EFlRQ1vu920FXkLaWTSa0vd6bwhhdysrtb68VITF0WCWwNofDICOABtxw6/FxzMCUMwuzMYYF38cjdY0c5SV7dF3he3UC58xzyMzH05e44UjG8ZDetE7IWFkkx0A/nLFzFw97+ylsXSBRNm3zYh4jP7G+mwlxo9To6Bd/Mr1V20BB8Jd01ipLbEZ+bfwcrNSI8JFx1hrUk3uTz6J8YfYttQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(7696005)(508600001)(6666004)(966005)(66476007)(66556008)(4326008)(66946007)(52116002)(5660300002)(186003)(2906002)(6916009)(34490700003)(86362001)(2616005)(16526019)(26005)(956004)(7416002)(8936002)(36756003)(6486002)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MVVYbk52ejE2ZUVKNGdBYTd6ZWlRa2ZyamkwZG9uM2doS1hqd0d6Mi9naEwv?=
 =?utf-8?B?TWZNUzd4eEM1WjNEMG9sQ1c1M3hjMnpaVmFUazdrSFhPZXg0K2FIVEN1czA0?=
 =?utf-8?B?US9NVEVVYjJkc1FSd05XZnB1UFFNM29sU0Rob0g4VnRsaVRVVFFWNUdyb3c3?=
 =?utf-8?B?dkZiZVIwaEFsbisrRXNROVRFTnBaam9sYmp4WDZldGlxK0xvbTRnaGRiN1dZ?=
 =?utf-8?B?QUIyOFdYeEZPbHgzWU9iVEN0UUdTcTZKRlpjdjNSQ05Nbm03WkdPZ3hTSXVB?=
 =?utf-8?B?blFJQTNScmppRXFYOWIzSkNtSC9PVHo3cFdiZ1M4UGcxbVVzSSsxV0cwU2VM?=
 =?utf-8?B?VkRTR3BMdWlNeTVlbmlQZEs4czFtbms5NFVTSm95dk5sdTBFMkcrWGIvTVpl?=
 =?utf-8?B?bWVNRHI5Q1pvREtLaHFJa3h3aFdCcUhpcGJrU3pieDNuT3VmOUJudU5WNndp?=
 =?utf-8?B?M05Ia3RPaEVGM0dnZzdIOFhnN2xZSUtVNE53L2pCdDFicWFNZmJ5WGxoQ1k2?=
 =?utf-8?B?V0Z0Q3IvQWNjTjRGS1BUektIbk1JNG13V1ByQkRuV1NiRFM0MzdiN0pyaHhY?=
 =?utf-8?B?M1Q2MkFwUHN3V2h0d2RvWGNBQ2pvN3lxOFQrYW9JZ0M2WWJsak5DRXVLYk9C?=
 =?utf-8?B?R3FSNUN4RFRCZktKdEJrbTZLUG5mbWxtUE1nRDBOQ2VRcWtBRmxWTEY1Ykky?=
 =?utf-8?B?MXJyRjhKUWZoaWxYa3VHZHpnRE1kNXplR3JEY0IwT25NSUpsNUdZRWxqUVFO?=
 =?utf-8?B?alFmTDV1ZlpOUVE1b1VrWHluS1FPTEk4TEhkRU5rSUxlTGlwbkNZOUwxaVFP?=
 =?utf-8?B?bVl0K3ZVVStIYU9ud2J4ZThRK3JRVkVYUEZZa3U2NFo4eGRPU3V1REZVM3Vi?=
 =?utf-8?B?U0RlZWwrOFdKM01CYjdRVkN2cUZZQ0FBUWtTSWFMTjhucnhIUkgzTXUwdzU5?=
 =?utf-8?B?UnI1OHI4MWFFMEs0TW9tRDNCdzU2SStGWEJybktnaWgwV2EyNnhHZE0vZTdD?=
 =?utf-8?B?RkhPRjVRZ28xT3RsYXB2V2tPRE5sakEraGxhTm9uamg4UmhQcVFkOGF4WkJL?=
 =?utf-8?B?R3hYQzI2YVpwdlBTT2lySE1EYVlDOFBTajBrMWg4ZVpRYnNpZmRGMDRMVUJP?=
 =?utf-8?B?ektMSm8rTktkeDAwd21ZeXdxSmlGczFSK01ubmowRXJ3L2hBdDc4SmkrdGo1?=
 =?utf-8?B?VUgwUkxQcDFBTDg2dkZLcjc4NDFjTTlHQjRwSDBWMmN6YjVucHdCLzc5KzFS?=
 =?utf-8?B?VkhyOVF4K000bFpUckY3QnI0M3pnVGNkdWx1Tmh2ZUtJdWQvcGd5aXFHdWlS?=
 =?utf-8?Q?8BKjBB9WtHTo0FdC1/zYZeyFo8lS90Tswu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:03:01.7534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2952ad-7ae3-47fa-14c0-08d89bc5080f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTe2UFDftKBVzL4LZD0S+G1PIKLA0egmcr9KCAgmF9w4U8dVx2ouvqlHEk6LLei2i5vl8Ge0QsSQNpwiisg7Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
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
https://github.com/AMDESE/linux/tree/sev-migration-v9

[1] https://developer.amd.com/wp-content/resources/55766.PDF

Changes since v8:
- Rebasing to kvm next branch.
- Fixed and added comments as per review feedback on v8 patches.
- Removed implicitly enabling live migration for incoming VMs in
  in KVM_SET_PAGE_ENC_BITMAP, it is now done via KVM_SET_MSR ioctl.
- Adds support for bypassing unencrypted guest memory regions for
  DBG_DECRYPT API calls, guest memory region encryption status in
  sev_dbg_decrypt() is referenced using the page encryption bitmap.

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
  KVM: SVM: Bypass DBG_DECRYPT API calls for unecrypted guest memory.

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
 Documentation/virt/kvm/msr.rst                |  16 +
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/include/asm/kvm_para.h               |  12 +
 arch/x86/include/asm/mem_encrypt.h            |  11 +
 arch/x86/include/asm/paravirt.h               |  10 +
 arch/x86/include/asm/paravirt_types.h         |   2 +
 arch/x86/include/uapi/asm/kvm_para.h          |   5 +
 arch/x86/kernel/kvm.c                         |  90 ++
 arch/x86/kernel/kvmclock.c                    |  12 +
 arch/x86/kernel/paravirt.c                    |   1 +
 arch/x86/kvm/svm/sev.c                        | 790 ++++++++++++++++++
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
 25 files changed, 1365 insertions(+), 5 deletions(-)

-- 
2.17.1

