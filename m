Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFAA360F6F
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhDOPxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:53:03 -0400
Received: from mail-eopbgr680074.outbound.protection.outlook.com ([40.107.68.74]:19013
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233052AbhDOPxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:53:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pl/yZryx3Rfs3uDcSSenwweh9ivoA2LSqZXzwJRrwsmMQR4Zh2z5n2gbAfdaaUQ/zrOfsO2bmpYzfBc0MD9eeeFdcoYN42CT+qY4MQ90pWXgoekPXdvfrZd1GRyPzhMxtUNmBGKYXb65soa41FhUtHJ+rxaC09iObMe/mBZ0CSBx6a+u8MqVoHqOLH0Y3mmd2H4D2iCjtzTVUKhKjsS8Y2APdtLL2by4tPe3rsFGZD0WBeApe+5oeEtshVuqq4xU6ChpWImoSKeMEZmPp3nAfhxsMhJ/4iRtaRcWx31+o0gS8V0qDZ8rL+SFBfuuHGsl+RTIzP8ds7H2YwaJ+VlF/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkPov7yNFIv2s1xvgHvt6gR5zuxPeuFMJ/UsJaWqFBI=;
 b=PdJqUHbDPiRy7EH60S027NVkBdHbGWquNouAQtJskHRcXL3P6JYp1zToNPMegtJe0NaFW8LGtjRlQQ/CNAollY7OuuPrtDWskM008lwfgWIMrpqKHeCt2GFzja4Kn72Pvlvo/5p/iJkiWHZYFsxVRx2UAqnrVx6bJBi/Fp1h0+GeuZMxjpnOaJih7RHwLTAbUc0BJ06pyMyJLTHPhSpmDM87hN9GbjmId58Os1Z1KeP3K5T1vb/oErvpPYMunhi0ew6L3MHaTzMKohLpPW+y8nz/7hBn8TwO0+UB85qt3AlEGaWEOAUqbXV2lRAXjxgoh/waOpuaHyCO41dml74XEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkPov7yNFIv2s1xvgHvt6gR5zuxPeuFMJ/UsJaWqFBI=;
 b=VjHJYAYXKy4+2LKbgd1zlOVpbkqBusffxR2eVUFiVdIi+uSQcKjDag8okWfJkp/rhmzDG9BFlOudbc99rbzLjtgKOJ125ERwjVQlUccZHsUByaszeCwhxKxRnq2SQKCyq3lgukuxgZabG0V3rCX4gI2oH+3BL29T3KkW3rzHvHQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2366.namprd12.prod.outlook.com (2603:10b6:802:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 15:52:37 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:52:36 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 00/12] Add AMD SEV guest live migration support
Date:   Thu, 15 Apr 2021 15:52:24 +0000
Message-Id: <cover.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0210.namprd04.prod.outlook.com
 (2603:10b6:806:126::35) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0210.namprd04.prod.outlook.com (2603:10b6:806:126::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18 via Frontend Transport; Thu, 15 Apr 2021 15:52:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e18c3092-f05f-46d4-f97f-08d900267d97
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2366EE3371E62374544310508E4D9@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92bO5weH5i3Wlh+MFXbAGBPBPrXwwP+T9Ln0uKCyNskU6ur3sSHsXH2c146deR+m2yCvStgqyQ+ZVqGRCRqYJsHM1TlCJeZ2Pj8b+fjWL/P9mrj2i3eYQU7qSNSFwAJwuaimyDzGu6UiQBXxkSJgJL3dt1WBNCwyb1OexhH8OvKOLtPdzALY9z1O0j+l8VZiQZ6vUcIbCkJmZsdzHTZmIKV5onx52pkyV7on4K0Vhmr8ZIDTJ+s69HI4f/Ty0p6gadyFGaPZVUUwOX4Q4JSrol6vNy8643llbd8l4SnpCvBa4nITpBemWVijcx+oQaOezElzWZE3ao/yZ8cetI9vzEkiKKQQOKPoyUvYgQXyt5FMtgTauSYK82Ogy3ArIazAcDH9qV1P6ydY/u2RCwoDzGDU/K4akn24wfNB0MagytwcnZ8NkfU0kgx98SjEa50TysUDgsOKXNvBEBv6I/IbmVFOygAPXFVhCKGKI7agt8AkqzdsCQ9SRJkVg3lVnl1o+Bej+9+bKdHnmVhnIfu3cdAkeQ2awhBjMNLvir9947amLRsCnpuo4/BzRbHokw+N5Nrg26K0gcImrFDLIM548QT2ewVVCPC7tAeU6Vj+h+mW1NsPOHwlLpae8gcZZKYaP3r4kmkNf23ecPwFmiDDuhTxNcczDCaj1cKJsCrp/ZJSGDxQ3tWJr01RzXAic58a/UzFc9eFgVHduQs/ice/PX29D+Ej9v44Vsdv63osi28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(8936002)(16526019)(186003)(6916009)(6486002)(26005)(38350700002)(66946007)(38100700002)(966005)(8676002)(4326008)(5660300002)(2616005)(36756003)(956004)(316002)(83380400001)(478600001)(6666004)(2906002)(86362001)(52116002)(66556008)(7416002)(66476007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Yk9BOFZRQTRaQWNMVDNqRVBqWWpOU3N0dVppa0tVRU11L3JKZTBHQWNQR1pS?=
 =?utf-8?B?OXhQZ0ZaUURwcEV0dXJnMk54UEtrVFVOdUJwU01kb0Rmd2tWOFhxVUxiK1k2?=
 =?utf-8?B?anBwdE5ZOSsrRUdwcWRzUTRxV3pMYlUyMEpqcm5MbVhjeFZUdkxBVUVzcmR4?=
 =?utf-8?B?Rzh1Wjk1cTN4U21LWk8vakZYb1RFbTBmWTNOcUJpMGY2TUVSQnd1V3JWZnhN?=
 =?utf-8?B?VDdKakV3bmdlclZ2SU54UkRNdjFLenpmZW8zZlVhb1ZxVEJZcEM0V0EyL3Vi?=
 =?utf-8?B?cUZSTTZ2RTdzb2lGdSs3Sk9FWFBZcE1UVmJ6UHhtUG1ESE9TMzNHZUx2OGRa?=
 =?utf-8?B?YUExakx3ZFFyNGszbVFxbk1TWVNjV0d6WEZqd0ZjckJOTTZaOEFXUnhwcG9v?=
 =?utf-8?B?MGs2U3c0anBxVXFBMnFNN2lXS05kRHl6c1hadHA4K2tjenVHeWorTVVLVHpX?=
 =?utf-8?B?Q1FOVHZCUVBGd0dkMnVEUE96ckdNQTNGeHBYa0g5a2Q4dzdxeUpxelpWZm9O?=
 =?utf-8?B?U2EyWWlzYVpPZCtsR1JzdFV0NERjOE4reHQ2bHc5S25KNXlOTHVvOHRnVkZW?=
 =?utf-8?B?NGM2Ykd6SVkwOUpxbkhnVVNkM0FENGExV3dTOUNCS2xjOCtWOEpJWmU2dGla?=
 =?utf-8?B?VDh5NTBESU9LbWhwQXJsYmNTWTVBYUt3YlNJOUJWM0RlSnQ0Mm9ONWNoL3Bn?=
 =?utf-8?B?V0JZRS8wNGhkWERndHFuWDMwekgySkF6VW4xcnR6eHhOUVQ1b3cxMHFjVTUx?=
 =?utf-8?B?SjFXdzZxeWt5bFNSTTBZeTBOTG8rSjhJdkJEUXZ2aGgwN21zWEZscFFDUkdV?=
 =?utf-8?B?SFoxS1p5RVowcURmM2tWcy8zNFlEcHA3WWlSRDZPUUx5c3lla3hrZk8zN0R4?=
 =?utf-8?B?cC9lV2JCSjdITWdrRTRRa2dWbXhnTVN2ZHJta003TnB5RmVISEhNMnpubWdS?=
 =?utf-8?B?ZmNsamlrWmpjYW1QbVp4K3IzaUpld0lUWktpaFF2TG1GYjlNUGN5MHFUTnE2?=
 =?utf-8?B?cDJRZzJiaitDdXdMa2ZHQVlPdmR4NFBRNUFFZWVyY2pnbmd3QXZMeHhNdnpU?=
 =?utf-8?B?UXcrdXBLZW1pRnRVWXBGRHUrSy9uOFpKYVA3UWZxQ3k2YmE3T1hNUnc1ZC9V?=
 =?utf-8?B?VjZLYmpKY1BiMWJLTFMwcFd0dWFoaTFrMWtFd3lpS1l2T1ZlaGhJWVpGOXJM?=
 =?utf-8?B?UFVQRG8vU080MFY3bnViUHZzaWdkS04xM1F5a3FrREE1NmI3TVd5cENGdmQ1?=
 =?utf-8?B?NEhURzFIZkkwZDVQYmpsditITkR1SkxRekhqQ1JaWlVLRWYwVEk1dVAzZ0pk?=
 =?utf-8?B?aVV3YjIvZnd0YysrSjJzTkRmcnExUzJaM0k3K2M3S1FZZlNsQzhqaG5XZk9x?=
 =?utf-8?B?SGpWN2tvMWRHSWwvNVJSV29wYndEdms3aFNqWFVQUUJUcmxLWVhaSld1R0tp?=
 =?utf-8?B?UDNsbzhOQmtERkRFQzNlWllEaE1DZnRhWk1BaWQ2M01EcUlTbVlYVEtLb29Q?=
 =?utf-8?B?Z29JU3lhdFZTcE5VK2JncnlyMGlUeGlxaklubGFGazdkMkkvWjJtZjZnL3Zj?=
 =?utf-8?B?VzlrK01NN0pENnpOSkpqNG5oK2VWSUtIaWVERWp4N2lxcWJRamJnbnpHNkxp?=
 =?utf-8?B?R1BkUG5kWGpsdlFHejhTV1Y0U1h0UTFNYkRLY1U3enV2RzdoaWJxa1cwRnRQ?=
 =?utf-8?B?RElrQUEwSVdjZWtJelpnUnN4K2crbVNJeGdKeVZxRS9xak9PWDJFVURWaGsr?=
 =?utf-8?Q?Vo9WNjEOLBWWYFVnbWcWUED1JHfK8MqJkbS4bNg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e18c3092-f05f-46d4-f97f-08d900267d97
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:52:36.7353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xoVKtdaFjS5jZUXX6Tw6dHhdGAgGKLBqkCs0SJYCi3ROLVt90Pz1sW/6XirBLEZ26sgeOptxYYZhDtVn5NM40A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
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
https://github.com/AMDESE/linux/tree/sev-migration-v13

[1] https://developer.amd.com/wp-content/resources/55766.PDF

Changes since v12:
- Reset page encryption status during early boot instead of just 
  before the kexec to avoid SMP races during kvm_pv_guest_cpu_reboot().
- Remove incorrect log message in case of non-EFI boot and implicit
  enabling of SEV live migration feature.

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

Ashish Kalra (4):
  KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
  KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
    Custom MSR.
  EFI: Introduce the new AMD Memory Encryption GUID.
  x86/kvm: Add guest support for detecting and enabling SEV Live
    Migration feature.

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
 arch/x86/kernel/kvm.c                         |  55 +++
 arch/x86/kernel/paravirt.c                    |   1 +
 arch/x86/kvm/cpuid.c                          |   3 +-
 arch/x86/kvm/svm/sev.c                        | 454 ++++++++++++++++++
 arch/x86/kvm/x86.c                            |  29 ++
 arch/x86/mm/mem_encrypt.c                     | 121 ++++-
 arch/x86/mm/pat/set_memory.c                  |   7 +
 include/linux/efi.h                           |   1 +
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  39 ++
 include/uapi/linux/kvm_para.h                 |   1 +
 21 files changed, 903 insertions(+), 6 deletions(-)

-- 
2.17.1

