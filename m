Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBBC197458
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgC3GUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:20:17 -0400
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:6183
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728489AbgC3GUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:20:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRTf8V+kVRrsXE3XbS1WQTBA4RKU7Bz8OeYd4XQ2te9rngYJ/TQSYgvV5gjYkliwajaOYJsy/ox2/j5jFGjfdsab5vm3k9pTaSeTcGiI+v7CiVFUrjymcGGGqCx80p1JDLtVXnSDRtIemJHb4KR07opvOG930UJcyLbZTwYo0zWpHxJSHMz6Nrys32XUH6FEfWP1POJDLMy+vwqdkQcN6dzY9MwV04cI5zp554GWGbNRSFVpiguKVUS0OXedy8Zw59ztJr13jaNiNpkt1ezKz2sAIr81pEi/LnsgxYRM/jNR7ERPUFYuh4G6Lkd9NBFzpi5oQkIs8RA9vGi7Ms6tvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WnGl5zuqJkS3t1nm5ALpUQkzWFUxidgCJa/hj9Lbg4=;
 b=YSr3rg9siM5dc78SoMkv4ogR+/U5WGBjGXaDMK85J6otItTOwPx6iOeYxcqeDk6mEhGjXsdkIXDy3cld6MYiFTcObL14UsneN1XRabaWMG0xyQCkHjZ4XsXeb1NB3WxK/dxkMpvzw4O1KRYh5mD/9L0tA2Rsnc2+j1bI/4tjj9rLkHvV80QumxYr/QCCZokZ6BV4xxPzYG3z1ZlAfwMKSaGpo+wLPWthYhudUgVjpMgfW5rdGTZUzQEopV+7VkQZmeuPpJlwHVuDeN/DLeKhgVhVm41dw4I1Z0La/Ab+QYHHqctUIsgo+YSDEMVUS25fWalRtdduTkfsi1ubsO/UQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WnGl5zuqJkS3t1nm5ALpUQkzWFUxidgCJa/hj9Lbg4=;
 b=clLUatEhnMuJ6L8TRvx8JjN7wgcOMr5EcsmnlDxF8xnU0Z1+XqWEO0Q+HQyso4kEBS0XB3w3oMus90nRkUK4edobyAt8ltAbr+0jRdD96Ig3k21dCsuVvsDWR67wIJOJThbQWqrflGbaUmVM/ijNKejIwXikI9VSSYf6TmBxPGk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:19:37 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:19:37 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 00/14] Add AMD SEV guest live migration support
Date:   Mon, 30 Mar 2020 06:19:27 +0000
Message-Id: <cover.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0028.namprd05.prod.outlook.com
 (2603:10b6:803:40::41) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0028.namprd05.prod.outlook.com (2603:10b6:803:40::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.11 via Frontend Transport; Mon, 30 Mar 2020 06:19:35 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b9429555-3c66-4b82-89a5-08d7d4725235
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1692483A75A829F4DDD00C708ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(16526019)(186003)(26005)(5660300002)(6666004)(8936002)(6486002)(4326008)(2906002)(36756003)(7416002)(316002)(66946007)(966005)(66476007)(86362001)(66556008)(8676002)(7696005)(81156014)(6916009)(2616005)(956004)(81166006)(52116002)(478600001)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i4m0oHPA0SUSflTRKYj8WFJViKa/O1EnlPrtczTWOwP9tamgBAD1fipmkhI2VrfdQMPYDdX7U26zhbbjcwH5Nk2ev+xp+I6yoayHzDSACC58drwkop8lhnpLTcz7krWc8rfsyC/iSC20cr3I0/Ux92kHFkryGL1Tizz7FxqUTtlrw4EM+x5cZg2oxiO5GcTwXqAoKuL36bseMtZAQ8kDcsyNciRikR3wMpPRS9bO9BGtizDYMcVxQ5UX6hfVIynZsjM/AhT8RrXiRIYWAYtEtjFc6k57S7k26duUyPoUgOF1xxQDUDizXEB5dte88UjqMVfPQBrE9yZMzcEZ6mzuhOZXgx9mSzBzjV+EDJOz7Dxj/hk5wLUJvbAQ7xCkHqLEQS1CvLpfmVSKgzKHTjEMhhvGqfh0+XWKHKjUUKpv109Mq4NEwhG0/+cV6EIkULuahEVXgwdcskkQD4dfCJM/wUy9r1HVchvNXzI8KeA1vKkDzxhGEGUG0+ovQvdTlBYPakMUM7nzBqaPptQRZoxIlw6uU09zSkN0rcZ/b/NrLcvzvJxvLNRpsn5z53w1ppAgCt7NgnC/eIg5AAVLRS1HWA==
X-MS-Exchange-AntiSpam-MessageData: Amdk+kp+0RjBCwHiyaHoQ6/Uxv9lpu1vEl29OgJVBW08NKlLazYwZdb94sguHQIeuj3tRPkBLeYsblIrdoMNh+pmFKYh4HRymRSugZMGSNhoCu7TIePRLGQIR1itaOiTxbOkNhe+2jkO5uqR0gVUnQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9429555-3c66-4b82-89a5-08d7d4725235
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:19:36.8584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qh6+zaXxk59HyIarYXKzP+6UlXJTgXvABmd4tVHi7WlFOtJHEOF7BSd6o7Xrirjwr5+Uv9IAdqhejV1iCEKFJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
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
 arch/x86/include/asm/paravirt.h               |  10 +
 arch/x86/include/asm/paravirt_types.h         |   2 +
 arch/x86/include/uapi/asm/kvm_para.h          |   5 +
 arch/x86/kernel/kvm.c                         |  32 +
 arch/x86/kernel/paravirt.c                    |   1 +
 arch/x86/kvm/cpuid.c                          |   3 +-
 arch/x86/kvm/svm.c                            | 699 +++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c                        |   1 +
 arch/x86/kvm/x86.c                            |  43 ++
 arch/x86/mm/mem_encrypt.c                     |  69 +-
 arch/x86/mm/pat/set_memory.c                  |   7 +
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  53 ++
 include/uapi/linux/kvm_para.h                 |   1 +
 21 files changed, 1157 insertions(+), 10 deletions(-)

-- 
2.17.1

