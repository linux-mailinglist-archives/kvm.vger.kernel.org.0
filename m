Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108E530E89B
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhBDAgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:36:31 -0500
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:55968
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233575AbhBDAg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:36:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbnKD/8As3O3Uw+57afmgabbka8JMNFgIi6LFO9du1Lq0R2wLfGFdtOzFcJu2YCbrJr9F0HXuqqb1ypuhC/CFFtaQJ4bm5XLhrwOjY7UbwGIgqXVFXrYV+TyCOL/CHA7Gwdos58tbvRQ1HaZDjPb6mZHc1tCz8K4L5+Kn7gGJU7yOH0Oftr1KMezs/5pVLqWdzRtseg+GHg0gL01jOVSQH1+p63YqR5C9OHy5UXr6xQtgyS7HWZF9Sm1LkXwagKrEbkjx0BaEvH61vh3nSQt2BU/xIbohCNg+GNGpMqcppi4ud6Cwb6GjgW78RbNOnftAaZTRtBYZO9Xwx80rW0JVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7T+vhpMPPLIGK0XLHtGgpLkvORNt5FKH7o03p7ELsM=;
 b=gK/smQp8m4XR7uxYHNK3h/QP/0V3c0JidqzIWAu1p0LOtQKpPT0RW/P2xwz0ppl9uiAKidMlubbg1nWZuaaW4tmP42ZPy9OFUZsJPnQeL7C0YTOIc0rBom7gGp3IkEyQ6cLiiW63KOdXXTOVqxcQL7vw0eaAEjNf4K+Y98UQpdL72spH4pdF5QylN/Lo05PqhTdNdfF7qGr27U5RF+aS7ufPmscOgNEeqYaDK59ifwBta4eP2r6/PssaM8YdargldBlCXq5YL+9JyMsjJKISGRh3xHzBI8MDnLHrI8hUbVPnPuCN47EwTelYZubMQqK2vm6PLFKyed6YepWeM6/OJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7T+vhpMPPLIGK0XLHtGgpLkvORNt5FKH7o03p7ELsM=;
 b=xa7aiyUGxQYn1oM0HElhTdTkdfQ3mBHWyMRb0tLhpXdRhvc50lh+SWOLOS99Qgtkxr/oYYUUW+m1BjEvydr0WPJvPCpN8k4c2/EU3XQYPSmuycUZAEg4tfN+haguGypwpHFBQp4a/Lr6oRgwClIQtNmuW3JS4OUSMzwdgSjQlGo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:35:31 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:35:31 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 00/17] Add AMD SEV guest live migration support
Date:   Thu,  4 Feb 2021 00:35:22 +0000
Message-Id: <cover.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:806:122::6) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0091.namprd04.prod.outlook.com (2603:10b6:806:122::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 00:35:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 89a5064d-b174-47d2-7f88-08d8c8a4c718
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384B002174F2A217CDF1BA08EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UDhpB7XIkMq81uygGRz+7QFBZtnAin1f8YWN0zOFZVbFWl52d0b+EYRXHpDOe54GtfKaRuUADyMtxEU90zWc6oqTr4O2sGTqZSCu60Uv77b9MXy3tnE2ukjxQYqkn3Ca+t7c+jep7gE6xHeGrw9FBp4pwj3mSfhPvdJQ7Z4mk+MVkjCzjeQiPnm0IEghGId2dEVhaip0Uml58khVULHnCTF33R2RTlce6iUizBFZaiNPGx2qDo+sMSjUwvGFLBeXplpl9l1s56LeslxHHPuFeZWeROiRIbXLR/cm3vpO9A+FRCWwaDy9K56uBH19I91I4vwO3/tpC4eEi5c8YMKAEkjmXkbMYPe6Lyzn1ELkY9mSEkZflkv8Zy4GHdpH3rzJBd9+im9Czvbw38+1S4s1vbpP838seWKKmTO+YSZ8cv4dkUVdIaUX52e1U56zJAgh1zoJvLRY6e5/qN4KM81FVrdVN3M2z1uvqKgiwTMMUZJ4U/a0j9qrlkEIkUG0iQin+7bBzuCq2VcQuJDtBjcp4dj7DP32fSU2odRCMjrJcNn4ucRDa1aykUJ/hq0YqPd4Z12CkVb9LVS+EEYaEPA2F3+z6VB99MjgdRkR/U4DNT8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(966005)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YkN6MzhXSm5JZ2JTeU9OeG1SN0pTTVVRSWd3MWhKTFB2M3J2OFlzTTFQYTdn?=
 =?utf-8?B?V2R0RFUwNThKSCtDemUycnpuT3p5WXBwcVlGdzlTNFJrOUQ1QmNmV3U1dHpS?=
 =?utf-8?B?TCsvcFVoSHlwV013dXM2N1RiOXBMNXB1MUpiNXh5eVAwVWpQeEoxM0hoeGpO?=
 =?utf-8?B?Q1hYUjNFOGdJYkh4L0VzOXY5OVRjWkRDMEJGelJNZ1BlTUh1d2duLzMrNmhK?=
 =?utf-8?B?bTViVHZjcEtjRjVzQXBqTHFXcDNleTdSdmNhN2ZjcjVjUWY0M2t1clBkY0xI?=
 =?utf-8?B?OG81VmNZUCtyNFhicHREZFVFTkIxUjhVT3NMcytkL0lidmZQZ2tDQjQ0YVJQ?=
 =?utf-8?B?TURRRzVieEdYWCs5K210Y3QrYnZiVEtWVjF6UGNOZnRIVTUxUjdja1B5OUJu?=
 =?utf-8?B?WXFoUVk1SFFVUmErcVVyYTVrU29IemRYSDV6bmVIcGxxVlFXbmJvOExvUW9x?=
 =?utf-8?B?NkdIV3ZBNTRxUHdQSWxTQjJQSnREZTNzb05Zc3JSN01DTG1DMmZEeHRWdGZL?=
 =?utf-8?B?S01waDBwVFJnbFYwOXFmQjhUdWVLT0tjcVMzM21DWVd0Zm5CQm9DeW1qY3U4?=
 =?utf-8?B?djkrTTREdGFMRGU0YTFEeUJab0MyUC9xNy9PcDdod0toQjdUSERRU01PUFBt?=
 =?utf-8?B?SkNvR1lmdnBJL0M4VSsxczdUeExXSTZzYkcraUxjMVZFbDJzUlJISGNYVVo4?=
 =?utf-8?B?bUY3dkdTWWlJZlFLOC9NM1lNOCtiZ2lERkRvQit3M1luM3NXaDhWR21rL2tK?=
 =?utf-8?B?eXo3aU9nVnl3MTNUb1VmY2ZkeC9TVUgxLzR3UERwa0NwWlBPSXluUzBodWJY?=
 =?utf-8?B?UmtzZDZxY2dLRHorUkNjR01WOXhVcDVlYlVXOVlrQWZudWZwNE1YVGZRellq?=
 =?utf-8?B?RlpCOXloNlEwRWcvM3pUNkF1R0NVUlEyb3o1UjdXNGNBVXYwcEFWWjBQREdJ?=
 =?utf-8?B?TVpQVmU2bkg5TnFVeDdJVElNYTk1anQ4cG5NZXhqSlp2eHgrS2E1M2Y0MnpW?=
 =?utf-8?B?T0k2ek1qYXk0T1ZwV3hvRHcxZjB5clZoRkhNV2RIalJZQ2VGVUtSa0R6NUpa?=
 =?utf-8?B?d0dINmNZbDlzK1pBUkluc1BxZE0zSjN2VzZmL24wZUd1Z0tPcjhhSXRFVzF2?=
 =?utf-8?B?R0NXK3hVYTdmaDk5dTZRbC9NOFJwaklYTmdPNjRIbTVBbG9iSVNiR0UxdWNW?=
 =?utf-8?B?bFdNL1VFNndCYk8xYmcyd2JFeWl6U0VxdzY5Tnc3Umx0Vy82a3UzVkxZSCtL?=
 =?utf-8?B?K3c5OGNmWFBsV0tMdElmd0lDaTFmV3VNUS82dDQyRUZsdFZJczluZzFTaWps?=
 =?utf-8?B?MHVST0poNkM5T3BmcmlpckVpWVcrcHd6QSt2dlFXeXRlYjRWT09xUkFhSndj?=
 =?utf-8?B?N0lVTXVtV1VJYkIrOE9BZHo5eXBEV1UvTmNsb1dheitJVFFnN2k3NDNRS2I4?=
 =?utf-8?B?a3A4Z3JmeFRtcmR1YUEwQm5RenFJS0JiM0tjSXlGUFduVmVaSDNoRmFEVWRk?=
 =?utf-8?B?cVNqeDIyVnQ4M1E0bklMdnRiMGdDb0duZEkxSTQ4NTkyWjQ4c2pFbnhaZzNV?=
 =?utf-8?B?N0JGR0FkdjNhQ2VYK0NNQU1QYzVETFdIaSs3bFpLSy8wenVzYVREeUt3Tmtz?=
 =?utf-8?B?cEt5amw4OE1kRzlaYVVwM05tOTQvUzlsb21Ud1ViTlJiekxjLzF6eFVqVWk2?=
 =?utf-8?B?ZHhIVGtTK2N3MXVCWUlQbUlWZGxHZmR3SDZ2Rk9JN2dLVDVtSG5rS2NTdlVo?=
 =?utf-8?Q?2GGwKVLIQo1KcsCbfHGjV7XeqGsF+3IXAz89vGj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a5064d-b174-47d2-7f88-08d8c8a4c718
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:35:31.5357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sXHXYWnGVuvXxb0p1dD/quLF+LKX7H1h8QZOq34cbfSbnFuqRvTVPx066pOSwaYo2h4zcp5CJ+WrChzewjqo3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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

The patch adds new ioctls KVM_{SET,GET}_SHARED_PAGES_LIST. The ioctl can be used
by the qemu to get the shared pages list. Qemu can consult this list
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
KVM_GET_SHARED_PAGES_LIST ioctl if guest has not enabled live migration.

A branch containing these patches is available here:
https://github.com/AMDESE/linux/tree/sev-migration-v10

[1] https://developer.amd.com/wp-content/resources/55766.PDF

Changes since v9:
- Transitioning from page encryption bitmap to the shared pages list
  to keep track of guest's shared/unencrypted memory regions.
- Move back to marking the complete _bss_decrypted section as 
  decrypted in the shared pages list.
- Invoke a new function check_kvm_sev_migration() via kvm_init_platform()
  for guest to query for host-side support for SEV live migration 
  and to enable the SEV live migration feature, to avoid
  #ifdefs in code 
- Rename MSR_KVM_SEV_LIVE_MIG_EN to MSR_KVM_SEV_LIVE_MIGRATION.
- Invoke a new function handle_unencrypted_region() from 
  sev_dbg_crypt() to bypass unencrypted guest memory regions.

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

Ashish Kalra (5):
  KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
    Custom MSR.
  EFI: Introduce the new AMD Memory Encryption GUID.
  KVM: x86: Add guest support for detecting and enabling SEV Live
    Migration feature.
  KVM: x86: Add kexec support for SEV Live Migration.
  KVM: SVM: Bypass DBG_DECRYPT API calls for unencrypted guest memory.

Brijesh Singh (11):
  KVM: SVM: Add KVM_SEV SEND_START command
  KVM: SVM: Add KVM_SEND_UPDATE_DATA command
  KVM: SVM: Add KVM_SEV_SEND_FINISH command
  KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
  KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
  KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
  KVM: x86: Add AMD SEV specific Hypercall3
  KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
  mm: x86: Invoke hypercall when page encryption status is changed
  KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
  KVM: x86: Introduce KVM_SET_SHARED_PAGES_LIST ioctl

 .../virt/kvm/amd-memory-encryption.rst        | 120 +++
 Documentation/virt/kvm/api.rst                |  44 +-
 Documentation/virt/kvm/cpuid.rst              |   5 +
 Documentation/virt/kvm/hypercalls.rst         |  15 +
 Documentation/virt/kvm/msr.rst                |  12 +
 arch/x86/include/asm/kvm_host.h               |   6 +
 arch/x86/include/asm/kvm_para.h               |  12 +
 arch/x86/include/asm/mem_encrypt.h            |   8 +
 arch/x86/include/asm/paravirt.h               |  10 +
 arch/x86/include/asm/paravirt_types.h         |   2 +
 arch/x86/include/uapi/asm/kvm_para.h          |   4 +
 arch/x86/kernel/kvm.c                         |  80 ++
 arch/x86/kernel/paravirt.c                    |   1 +
 arch/x86/kvm/svm/sev.c                        | 861 ++++++++++++++++++
 arch/x86/kvm/svm/svm.c                        |  20 +
 arch/x86/kvm/svm/svm.h                        |   9 +
 arch/x86/kvm/vmx/vmx.c                        |   1 +
 arch/x86/kvm/x86.c                            |  30 +
 arch/x86/mm/mem_encrypt.c                     |  98 +-
 arch/x86/mm/pat/set_memory.c                  |   7 +
 include/linux/efi.h                           |   1 +
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  49 +
 include/uapi/linux/kvm_para.h                 |   1 +
 24 files changed, 1398 insertions(+), 6 deletions(-)

-- 
2.17.1

