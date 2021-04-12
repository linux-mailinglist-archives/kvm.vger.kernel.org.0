Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CED835D146
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbhDLTmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:42:49 -0400
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:55880
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229676AbhDLTmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:42:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5TKQyEpJtkZh1ZoTsBPMA/pmEv+lvjOldQCokYuABt8DyCLZDjvUnRhxMlfDioLYQ6lWeyaKHmPvMnpdlGnkAT5yF5URJPkex4d0lWpf9UPgAxzF4oRtaUJxcSA7t3AwUBgsYgHqfez3EmJCgGju9yQFctiYJq05epYeK2OjYchl9iZYunihJ+aa5V5w+3tHILuGfbdGEKe5/qzoyPcOoAuJ8bM8VdXsP85YhMf0/Xf0pa5kKO4tBepJ6axGaKxkORjuuh99RPo/Dn9OxZ5nesLGnkSPQSbK6SEWZgMpHugD0et3YsG9AOPYMMeSM7rEtPZPgm6WjSCpyfuwVFoxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BawN9Uv/MbzHfJg0olJ89xQLad74fVBDL9NvarR0NjY=;
 b=HSSNPysAE2FwJMpIuOQHrpGx7Wy+k7hPHPp3pIltZRODCF/RBBUJHX/rEEtACSL7LXFi6XYiAlm8U78ufM3+hewOvTL8oU/iAYoK7lDW4ld6eNgAd4Tisj1NxGKeS7MAmNIEhNQQIC2eVwLrB5j+tg0apB597tAiHyclnPFInFD/vYako3hlCPby8UfPyvTgwzskYF+oLxKx4VUtoUbh7W37pdl+sYWZMd4KbxqbdPngN4dCjD7GCnbnyVAl3Mt9e651/jZMw0qELqFminsDAi1wciqDKzi/gknWcDxC7Ea+Ral7/e0dKL+qXr5yM7T1eeCqilg92+uXHNGBY8Z10w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BawN9Uv/MbzHfJg0olJ89xQLad74fVBDL9NvarR0NjY=;
 b=nLQQX15lfWHVw80RYJqKmEj4tgBmMD4LQQTJqiTTrGmHgC9hRKD77fg5lLdb5R+c+Sig0xOU9jbIam91qmc/pQD1FhDY6vzsWsqiNmLhG2KrhNqnibWEHha0NjGI8NMj5sqQ1841CGkAgZ95qm+aggJ17EXzXLOxb+XHroEo3bo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 19:42:25 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:42:25 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 00/13] Add AMD SEV guest live migration support
Date:   Mon, 12 Apr 2021 19:42:15 +0000
Message-Id: <cover.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0601CA0013.namprd06.prod.outlook.com
 (2603:10b6:803:2f::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0601CA0013.namprd06.prod.outlook.com (2603:10b6:803:2f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 19:42:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46f4eda6-6ec7-45b9-0d27-08d8fdeb18ec
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2640756FFFD8FDF4168C0C0F8E709@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZAy1RYoAkYcgPp1Sj4xs1UWB1ZXeegS0lvxqxiZUXSZmJY9DfvxHGTmAud4FJgYGj1kjBhxradeY6MlXzGuCWO7JEOLwDK4MvcOWs1IzD0MiR9kZA4x43E+uP8DWzAaDYV/3mSRj1y4WvMCPbJhJZCWE0GTWXO+LScTvLsWwDSOtFli1v2xu393OunizePF+rC5+yxWGvEJWit+5WCZp4xwK4uqh37kegP3x4OjRvtX9WlbHVhs0ZJZ6BjdY1o4kJBMX0ITr1mxAEP/vjHCEKcaaYMlpZsMUtzW4DPFxJxiivK3NQO7yINyBLdHdNKcNLHIB5/YoEdl+Udxhh6WwSHMnfkas1xrg1FLSiOeNx4ob+TOYeDKE8u+YLwONU0f8YL9u3Np+blroPX75E6qvv0zxtp8dkJrMxvfRtui8F0Qo/WMdWZFDUJRy9PhQsowD0g0BsfnLmcZsoAhRmfiEVN+PmqfjwtHawd3NjvC/t7Vx3V+CGiQfa2+FC030BTAEd3qBIiAc2nuKUuYtLiemMzswGjOQhdLMPs7HLejeSIZB3r1no2JDORJjbbvqulBTgAsWg5wCcd5NPiwPt5Z53+dfxuAehpNBeOOzcfMn0pkPYX+MiFBi8tmux2aqb8rvKa9sIoCduU9Xr2J14Ym4tGPq50R/r0aAT3XeTv2OpMdxLoQNd9Jc28p/SvfUL23TA/Kjc5PudXd2ekYiNTZIrYXvGrsHTH7KVjYGVFfcA48=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(38100700002)(38350700002)(52116002)(7696005)(6486002)(86362001)(2616005)(8936002)(956004)(6666004)(16526019)(316002)(6916009)(186003)(36756003)(66946007)(2906002)(83380400001)(4326008)(966005)(8676002)(5660300002)(66476007)(7416002)(66556008)(26005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aFpMaXU0SkZUanJrWTZKMkYzb1dGZHVIdldRUlR3U1V6ZHo0QTJqdWxRZVFR?=
 =?utf-8?B?Y1FKN1hOZGlSdXVhRWp5RXF6K25KeGRMSm5GZ2dEUXFKLy9xUXJ5cmt3U3Rk?=
 =?utf-8?B?Zk5JeXpOSnJQbHdmaWdZaDlSb3RGemRoTVZaZFBZb25pd2xvcHdHT0dsNkhE?=
 =?utf-8?B?K0pOQmY1a0doOHczZEprbFZaaHdpUFMxSk9wUzZmeHRsczBIZnVlNjgvL2cr?=
 =?utf-8?B?bTZ6N3VUSDV1eWVZR1RwUlBGaDFiODZ6UVBmaW5ub3laaVA3em4wUkNHbTEw?=
 =?utf-8?B?d0wyRTk4R2xDSTBGVTR0R0lRY3FOekh6VlRYSW51Q3pMZmU1bnByb2NFclp1?=
 =?utf-8?B?UVMwTmdiT1VmUVJUeDlpZ0JRSkt1K01XRndSaUg5NWR0WjJtZ2xKUExsVDZs?=
 =?utf-8?B?WS9GWjRSUzZ4cmxhZXJRZ2MyK2VrSE80SVhOVDdROURrUXlQYWVJd082UVBN?=
 =?utf-8?B?Rm9kQUx0YUdweGhsM0dvQlJRbDc3OEp2eUY1aHBPOEVKRk9kN2FvdVhqS29u?=
 =?utf-8?B?UEFaR3EreStQM3I4TktQeUVSOVZpZzlabmkvaFd6YWovZzd1YWNzR2YxZ3pO?=
 =?utf-8?B?czB3MlNITmJDeVFMTG02blNLNXhZRk14a1F6eU5wbWxxbGJVOExiQVFzOGp0?=
 =?utf-8?B?YXBpVStnTmpKQW9NRGQzNW83ZEVaYm9Sb2xLUHFONWNrUGl0UVRnOHJ4SlNj?=
 =?utf-8?B?RTdDSDV6WUtWOEF5ZEgyY2l0YUhiL2FwU3RjbWk0RzVkSXVJNmxtbGFaTkJu?=
 =?utf-8?B?ZGtKbzBxUFNEMFh3cUREN2dWV2M1M3J0REU2SDdvakFxWUZ2STNZbjBlM2p2?=
 =?utf-8?B?WnVRVWtldlNsZytXdzZPdFhiQ0ROanRsaGNiUkJTblR5cSt1TmRuUzV3ZEN2?=
 =?utf-8?B?SVlDVU9VQkdnSE1RQ0JJZmFhNVlzRTk2Q0NEM3RyYjBpMHBaWFpMbExvVE9w?=
 =?utf-8?B?SzJheG9WL1RJb3h0VUZYcUx5MThsUnFVb3NYU0YzNTFIeUt1N21aSjRCVkN6?=
 =?utf-8?B?OEhXRFdwSHVKY0x3TXlOMVBMV2VoUkZQN0puVXJUaTB5dDByeW5URWxaZEtH?=
 =?utf-8?B?dERRdHpEaDkxWWw3cm9zZEdqTGJWT2REdUZPbXRrSURFK1gwVjZ2cERtbzl2?=
 =?utf-8?B?ZWgxWWhWZlpKZG9ZVDhJc3hYWUFDYjg1M2lhNUJOUkdUUkg3VjFVOTJnOTdM?=
 =?utf-8?B?M2RuTExuYkVaQ2Rkek1xdjF3dGpFRm5OY1B5eVZFRkJyajRTRVpZUFZiSXk4?=
 =?utf-8?B?WWdIS0tIZEtGSUVPQVpNQUxTVEhCWUloVnZaMm5VTHVna2VYcE9EWkwzUWxu?=
 =?utf-8?B?My8vRWorclBwVTYxV3JJMWtER3FxSUJsTkVMS1BWMDRnK2hhQyt4TjMxUW9u?=
 =?utf-8?B?Y2FXYlJzc2FFbldkTENHMmFidWxRbzNPbDlqOFRaSlV0T0JCS2pSUmJCUFZ6?=
 =?utf-8?B?Y3czcUovNTBFdzRzUWRwZDVPUzdIaDR0azJZV2dMdDFQYUVOckw5ZHpscTVa?=
 =?utf-8?B?MUROMjI2VWtuM2c3dzkxR2JLWUNxSXJxSTlKaXc5SHVsMklCZTVVZEI2MFFx?=
 =?utf-8?B?dk5Zb0pac3VFbmZTcjVOTEYzb1JYSklyQmJXNjJlc1RXbTFRQmhFU1RxMU43?=
 =?utf-8?B?alNZMWVrWWpqczg0U3VqNmJEcnc4TzlBVVR1SlJtNVJxTlplQ0ZvTlhtSDNm?=
 =?utf-8?B?U0R5T05kL1YzbWU0WS9udXZ5WGxOTjJDTXg5WEFlS2l3aWtUZ2NHTzlwaDEz?=
 =?utf-8?Q?4QwTD4Hs3rOjkhrKeM14eh9MeL4JlPy7iZnp4Jy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f4eda6-6ec7-45b9-0d27-08d8fdeb18ec
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:42:25.1889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNUXRn2C94pjQEgEYKAI+/Zb4UkBTcfpp38wD6jPruKLVbn1fOXbPgGbiPXkqM0NnKzgq2CAcLZAcAaSUTuMrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
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

The patch uses the KVM_EXIT_HYPERCALL exitcode and hypercall to
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
https://github.com/AMDESE/linux/tree/sev-migration-v12

[1] https://developer.amd.com/wp-content/resources/55766.PDF

Changes since v11:
- Clean up and remove kvm_x86_ops callback for page_enc_status_hc and
  instead add a new per-VM flag to support/enable the page encryption
  status hypercall.
- Remove KVM_EXIT_DMA_SHARE/KVM_EXIT_DMA_UNSHARE exitcodes and instead
  use the KVM_EXIT_HYPERCALL exitcode for page encryption status
  hypercall to userspace functionality. 

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

 .../virt/kvm/amd-memory-encryption.rst        | 120 +++++
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
 arch/x86/kvm/svm/sev.c                        | 454 ++++++++++++++++++
 arch/x86/kvm/x86.c                            |  29 ++
 arch/x86/mm/mem_encrypt.c                     |  98 +++-
 arch/x86/mm/pat/set_memory.c                  |   7 +
 include/linux/efi.h                           |   1 +
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  39 ++
 include/uapi/linux/kvm_para.h                 |   1 +
 21 files changed, 901 insertions(+), 6 deletions(-)

-- 
2.17.1

