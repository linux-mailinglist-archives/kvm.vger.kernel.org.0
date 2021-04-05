Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8937B3542AF
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241290AbhDEOUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:20:50 -0400
Received: from mail-dm6nam11on2043.outbound.protection.outlook.com ([40.107.223.43]:5344
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241285AbhDEOUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:20:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gH8MPMuRFCBJqET4QS3Xt+omEpn/DKZFH6ljV9H1ht1i/3ddqBjSwg7owjCVryci7mqS1ok5xgEoCqIRLlzuzTHeIiw4PaJCfAO3JbKmEGfhW4IITMQMtU6SVBMb0Xh/7kG4VY8sBqndsb0OiO5W8o4GAIBKVZBoepoo1UI4VHXXbt/EvafrOmNs4ORBTTkRwCBXXli1lpcze12n/d7Kw4Xn5VZ+m/xuURdCTWXcM4GvpNctOH/ajZzwJ5WuSRws+1G9CICL4flqL42o+8k6L/P604AfSQ8o5w9iTm1bhT0skkOkiUn78MMP4nOeIiuYagcIQzFN1CLEsW+rnJDjwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yBUmNzq58fChSIyMl3GhEFPjEyREF3DDN0ESwFRImU=;
 b=Ek0kuQTrFpd7VZ5ntc6G4sAxMv8EkNXGCgNC69oUe7TAjc8rhXQw0oIWsU1i0wZ2UDLHyByMZRyzezioaS1rojLq0ypUiPn/C2DabDBmjanZw1qdzfVVbO2k1jKJ3dVxi6ezxgrnk1Lu6hDLJTviVUka2X6cNIM4dHejYo/NJQXHchTM0pcESsOap2ew2gr7f4Pc9BBxRb7ismFpBPIU4es9KJpkwxZ1byRj0IKW1ZqeLrfvEyyuzwc/oPUA6CWrn6a+trU91fLr+onN4ITTeJIE+2BivEadx+Refz3iymoX+JpMQtzFzORQAfFsOEKJv4dLVBH86ypBF8SW4ZOjMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yBUmNzq58fChSIyMl3GhEFPjEyREF3DDN0ESwFRImU=;
 b=g5fWTmIkOppvZhxvqTjNPQGurMLQYpunj5yIInjBFXT5HCAYq12+IoIG4VZk+mJHSCweTgkUrFaUy6RNm0nvIvL+t9pTAGqyffcVZlf+tltctmcXv2NNGXBhbmyc7qlpucAYivt1BtJK2zteN+yyTSYRabzx8pVA0giL0yKlO8A=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 14:20:41 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:20:41 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 00/13] Add AMD SEV guest live migration support
Date:   Mon,  5 Apr 2021 14:20:29 +0000
Message-Id: <cover.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR04CA0088.namprd04.prod.outlook.com
 (2603:10b6:805:f2::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR04CA0088.namprd04.prod.outlook.com (2603:10b6:805:f2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29 via Frontend Transport; Mon, 5 Apr 2021 14:20:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69e95bf6-8212-4fbc-032c-08d8f83dfe0f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4510AEA69DD6CF623F9A16668E779@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F1jZF05sv8KpUXHoBV7R8+2fTIcj6vgd3d85OanNvvieMah4WrURnz7jEPq0SiAeebYr/6FzAc/sOUMdAwJ0MuqNxWUAU5i3MM6CYr1mA/tiwoImwyf4A23Vrj01KSagb0zWx6cWZoyzZDF8Z4IxNyuCBlox1gD6Xw3TC2e8QN4T5MeuTg31hQMZs6269iAcJQFqo3hoJF38y3BNxTlRMR5Lv6+RjOUJbsYHGfJDIpEK418R5zMO63D/ABgA3GYpnVTXLDpVPmR+0ZGBBUbsIaacIblh9aPXS5Px+YJzMwNrKe6H45iy0jPlslnUaNrM5WfEGHJTMmv9IeTmRPV9w0+xINpB28QZ/XSAg4OzVgnvA9tgd6pkaNtbfUq7g7fCG0S+JPn4GRzEqWIoKUt8z2IGWUfYAqnziJ2O7MZv3fIq+OVpl+fONSIE3MJpVy0Icajs6lTMh6V5wB413qyRKhSIcVp3t3AofdN/CnbinVkTFgHJHU+qJ67kyZ26tMfMZhP6oVu/hPHMUVmTBoDlWwhbouYYY9H/t1z0W/dQnZWOST0UIb6ebffZTx7cQ20u0ucHvTX3tZBzp84wrTjibyDOZeqjIv8Nm6dukXgUVuZA5Z5OGWVoOtINROJXXiURK0GFau3wwOd0WhkGaZM8wB1pShnZtFRwHBdrUWfiRlHwr7/d3TTs0YtjhZowRZdBVxiel/cpLg9rVWRoBgQ8yPU9iHpAc3UjxVkuF/1WvDA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(66946007)(86362001)(66556008)(956004)(66476007)(2906002)(5660300002)(6486002)(7416002)(8676002)(8936002)(16526019)(6666004)(26005)(186003)(4326008)(966005)(6916009)(52116002)(7696005)(36756003)(478600001)(83380400001)(38100700001)(316002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MUJNZFgxeWI1WTVFRlVmT3JPbmczRS9lMGN0V3JRb3NhWW9FM1RkcjhkbmRU?=
 =?utf-8?B?bXVsdkpvdHc2VFVSSEducmwwWCtKQjQ1eUJwektQS0cwbXVaOTRBZWFUaytV?=
 =?utf-8?B?RU9OYzVOS0VGTDhkVmFpOXdqY0hzRFB6aWhjaXFKRVozUGtuZUdtWTZaWmZw?=
 =?utf-8?B?a0ZXZEk2SHBPZkxHZ1NpQTVtWFA2S0xOeUlmeW5NZ013Mks4dlFWcnd2VndX?=
 =?utf-8?B?Sm5vM1RxbU5jTkxvSHpXekFtbG1nNVlFUDdxMEpVSkJkbVcweittM2RsOU1T?=
 =?utf-8?B?Z1E5cEJnU1dJRDVhWS93OVRLdG9PcWg0UnFyU3pac1llWHA1N1ZyVUdFbmpp?=
 =?utf-8?B?VnZBeWUwNW53MUYzVHVBcUl1SGRvMW9PdUVnUVdEcGZyQmJZd2FlVXNrUWRx?=
 =?utf-8?B?QXNIZnBzZzNhZDlMblFEWmE2ZlhiaTlJM2hTN0xZOHdaY0ZURkJrOVFKMFpj?=
 =?utf-8?B?c0RNLytiNWlRSkxrbVYrMmxEU3NsaFRCR1hYV2xQdXkzbmM4UXZiVlFvektx?=
 =?utf-8?B?cWRWVjVDbjlCSmpHaXZydHNySThlWC9TWW91L1ZUVm9mQXVUaEJENlBlMm5Z?=
 =?utf-8?B?Sk83YW05SWZJUDR6anZ5TGlsT094NW5JbVBrU1I4SEY0aVJoODVnTnRDd0Zq?=
 =?utf-8?B?T1hwcFNWdTNzQzRRcFdtRDlWQm9aT0ZUMHlhZU4zSVY4eE12Y2N3N0pLRjgw?=
 =?utf-8?B?aUlEOWJhSW9zcUwxRml4a2Fkeml6dXhOR3FONUhrU3kxcHF1a0JETElYN1l1?=
 =?utf-8?B?UEU5cTdZY1pMbDRIQThNWmhOcmxjRXhwSFltaGRTTDM3Qm5tUEtkZGUvSnJI?=
 =?utf-8?B?KzNjdjJCczIzWlhmK2NCclJyYWtuY1BpNFlQK05aNVkxNXdCVW5YZ09hQ3F2?=
 =?utf-8?B?M2FCSjZ2aEgxK2o1dW9FRExRNzNxK3k1VDl2aTJiZ1BuZHpOUk5vQkVNbmlj?=
 =?utf-8?B?SHFoaWdNNEdjRDZMV043cVRnSlRvZ3ZENFlraDFRNUpJK2RKanRBWUc2OGZm?=
 =?utf-8?B?bnN2TmlVRk1TZ2JNdDBpb0hOUXRLa0xiZmtPa3FvU0N3YmZlSnU1R0IxVXIv?=
 =?utf-8?B?ZXRwWmFHaVFvSkhJTHhnTjZwWUlnb2NqbHN5N2NpVCs2UUVuYWVNb2hiMUYw?=
 =?utf-8?B?TEpLTlBiSHFHeVVDUmNlVHNIS0FnQ2dFWnptejlnRko5NDc1cStIRy9aMUdW?=
 =?utf-8?B?UEpxRzdaZVlGeHprd1d2dnRzZkc4cmY1MGM3OGx3cEo3YmI3cjNMU3M1b0FZ?=
 =?utf-8?B?akZIMzgyUXJaNzEzOFNlaWROWUgyM2hyTHlxbGZQdFNnajhEZUxZVFhMUk15?=
 =?utf-8?B?WkFpc2JzOHI4Q3BTNS9tekJIaHlGMUdad2JLK05OaVQ1NmNNUFdoK1I2UjVo?=
 =?utf-8?B?TVZ6M2QyY3FadVE0cTVieTVzaUdkaGJ6U1ZsV3E2NStEQWwrNFVNczFaTXp6?=
 =?utf-8?B?bm5iRGtNSnVDdlgwUDlveHR3ZDRVTzdwa0dYbGVlWVlHcHpVVDJOTDlObDRM?=
 =?utf-8?B?ZkRwTHY0YmtlSUloOGdGbndMekVCWjdpUHNLSGI0dFU3TXJvZGJRMDFSOERJ?=
 =?utf-8?B?Kyt4MjhNWDJQODJEcGE0Nm5Tc2JFR0FDdkpVME93UlZOUTI0N3F2YzAyT0ts?=
 =?utf-8?B?WHp6b1Q0WWE1bG5nNnRPcG9qTlFIbTZXbmJSLzdScVpsUjIzOURLMzFoODU2?=
 =?utf-8?B?aHdNR2tvdCtPaXF1MlU4ZTl0WFFUZmN0Q29TRWticXl0N0NpWkR2N0JMM0kw?=
 =?utf-8?Q?SrkzzoW08OG8dDNOcLeWoVGT1Sqdl5ZLpLzBPo7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e95bf6-8212-4fbc-032c-08d8f83dfe0f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:20:41.4154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /aCULXv0+rBWawuWPqmV9QpdO18E1vC/xioYHIVUhFZjqzcJ2DFw/lEU0WCCD8lWKBEZjKnVRPpiY2raUFuEoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
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

The patch adds new KVM_EXIT_DMA_SHARE/KVM_EXIT_DMA_UNSHARE hypercall to
userspace exit functionality as a common interface from the guest back to the
VMM and passing on the guest shared/unencrypted page information to the
userspace VMM/Qemu. Qemu can consult this information during migration to know 
whether the page is encrypted.

This section descibes how the SEV live migration feature is negotiated
between the host and guest, the host indicates this feature support via 
KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
sets a UEFI enviroment variable indicating OVMF support for live
migration, the guest kernel also detects the host support for this
feature via cpuid and in case of an EFI boot verifies if OVMF also
supports this feature by getting the UEFI enviroment variable and if it
set then enables live migration feature on host by writing to a custom
MSR, if not booted under EFI, then it simply enables the feature by
again writing to the custom MSR. The MSR is also handled by the
userspace VMM/Qemu.

A branch containing these patches is available here:
https://github.com/AMDESE/linux/tree/sev-migration-v11

[1] https://developer.amd.com/wp-content/resources/55766.PDF

Changes since v10:
- Adds new KVM_EXIT_DMA_SHARE/KVM_EXIT_DMA_UNSHARE hypercall to
  userspace exit functionality as a common interface from the guest back to the
  KVM and passing on the guest shared/unencrypted region information to the
  userspace VMM/Qemu. KVM/host kernel does not maintain the guest shared
  memory regions information anymore. 
- Remove implicit enabling of SEV live migration feature for an SEV
  guest, now this is explicitly in control of the userspace VMM/Qemu.
- Custom MSR handling is also now moved into userspace VMM/Qemu.
- As KVM does not maintain the guest shared memory region information
  anymore, sev_dbg_crypt() cannot bypass unencrypted guest memory
  regions without support from userspace VMM/Qemu.

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
  KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
  KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
    Custom MSR.
  EFI: Introduce the new AMD Memory Encryption GUID.
  x86/kvm: Add guest support for detecting and enabling SEV Live
    Migration feature.
  x86/kvm: Add kexec support for SEV Live Migration.

Brijesh Singh (8):
  KVM: SVM: Add KVM_SEV SEND_START command
  KVM: SVM: Add KVM_SEND_UPDATE_DATA command
  KVM: SVM: Add KVM_SEV_SEND_FINISH command
  KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
  KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
  KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
  KVM: x86: Add AMD SEV specific Hypercall3
  mm: x86: Invoke hypercall when page encryption status is changed

 .../virt/kvm/amd-memory-encryption.rst        | 120 ++++
 Documentation/virt/kvm/api.rst                |  18 +
 Documentation/virt/kvm/cpuid.rst              |   5 +
 Documentation/virt/kvm/hypercalls.rst         |  15 +
 Documentation/virt/kvm/msr.rst                |  12 +
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/include/asm/kvm_para.h               |  12 +
 arch/x86/include/asm/mem_encrypt.h            |   8 +
 arch/x86/include/asm/paravirt.h               |  10 +
 arch/x86/include/asm/paravirt_types.h         |   2 +
 arch/x86/include/uapi/asm/kvm_para.h          |   4 +
 arch/x86/kernel/kvm.c                         |  76 +++
 arch/x86/kernel/paravirt.c                    |   1 +
 arch/x86/kvm/cpuid.c                          |   3 +-
 arch/x86/kvm/svm/sev.c                        | 514 ++++++++++++++++++
 arch/x86/kvm/svm/svm.c                        |  24 +
 arch/x86/kvm/svm/svm.h                        |   2 +
 arch/x86/kvm/vmx/vmx.c                        |   1 +
 arch/x86/kvm/x86.c                            |  12 +
 arch/x86/mm/mem_encrypt.c                     |  98 +++-
 arch/x86/mm/pat/set_memory.c                  |   7 +
 include/linux/efi.h                           |   1 +
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  47 ++
 include/uapi/linux/kvm_para.h                 |   1 +
 25 files changed, 997 insertions(+), 6 deletions(-)

-- 
2.17.1

