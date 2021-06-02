Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4674398C0C
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFBOOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:14:38 -0400
Received: from mail-dm3nam07on2058.outbound.protection.outlook.com ([40.107.95.58]:30496
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230157AbhFBONi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAEzduR2eAxmRR+52fUwnw8reUTUWvsMd75YAbMBsIj85wXxAd3sXczVpxqiJLVX3Ip8AQK5UPxFDKizjK1AoTbrhRVBbblZ401uRrOb/y3+n444yFoxjRR21pJsN7VNgm0LoAkEJCEPN9LcsO/k41B2oMP+3sy9pxwcZJFDf23Z5hOMVcR5veD+b40TJpDFWQ2TdJ2KgifGIEZ4HlYaOaRuR1LZQ3l3iRrmGVDm7jxi3OCVBTz3d1fZwY+Mech5hsJaAXU0P2NZ+1liHMY9Bonhc2GSRCndh9A8Bf/MFX2p0DZViVF1wa1FKPuG9eCsUwv4c45SXs7L8kaYgw+V2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpeuEpV9xu1z2yLvaeOD1qK8FIR0AyraxNbDCRzDvrA=;
 b=DL/PgjfFAg3get7erWphPWgeOxU12nwI+4rIEj4GB/uaQNGPs9GDX19sXjXds8ayYPb527ITYUTygUsBiDeKOX/bckpnnCIPtfVz/8DjHD8ruQIMpnkXwyWEYotAHy/xRehLMfdoHgpeAM6FxjEvYemGVM6czlqNLMvp7lRzUCI9ktQ1dAbQmynmbTI0hptn4L2YUFj3LqDv4dUsxVbvlbjfecBEmG3QSDlEmwALah6knupZIsn8HI9cw4gjBYMNGlhTxQx/pVotKAinXY5pTDnSEswGD4d+P5dYlxaa3U/+Iti6LO1xfGcIJPWsIYSXu/PMQWzt8WQwBPHWZjpwfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpeuEpV9xu1z2yLvaeOD1qK8FIR0AyraxNbDCRzDvrA=;
 b=nELCPpPUD2MainJFB8DQu07udwZb528z6Jx9n4VuEahQqVHHh6RSP9KRuppuJm6rZWQFlESzUcv76SIenYLccBly6CxyCJrWLkwREYL1DJqttlfiguL1kETZLtDfl7BoUtoMBFdSvKUy9Vpc7RD4+2L57i0IblpcvYaQFwKhkiU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:29 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:29 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 00/37] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date:   Wed,  2 Jun 2021 09:10:20 -0500
Message-Id: <20210602141057.27107-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a749c7b-5671-4f6f-cb04-08d925d050b1
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB449542785B9F6BEA6E7C0294E53D9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQDU6XSVdYszdpTLU4ce4PQoFRrC8j2Ita7zHJKSDpR7IRXQbrebwM/8seUkJAjDB8kvHaXIjohW67sqi9+9yZ2RN/m3AIYbuVcq0vq4PEOuLHcPaKpDaUkN2A8g1Si27V6tCQ7k2j1o/Z9w4DY1IjUWT9ZwxSw9pCiY+ZDm7SFlT5GF9fNTofiqymw4pxL7JXeuJr9N/GfSSNwO5rHv63Ppq5RBd7W5bRnePR9Xq9hSNnv9fwkAnQbB14w96Dg/KJ3aXN5Q7B/gDxhs9vrbAHHr4jsZqoKB5O4yP5Oh8Drvetu3stXo6k8rMMAJcOI9pRf4B2JrPL1f32+dssKvy9ids6jfwiin9F3tyCTiDmWlmxmNGUHQ6EBm/NSVTZgERnN/srHIiGX8VCdqbMxje2uJACGFMHGYYdYDTmYfY+nt++lNq+WtyIG7ud/12GjUTzc1CcIxCBz5SG9bk7nzNoBTIwpqPjdpNj/hdGNSwSkddhojWgLHUIlgk75+6C6iFcNCpdwzswO7Dzhl/1TzvdL5xYLjtqUSQVncQd2dwCFgnaXKTfeK6pDzm7HLkGjIeTq+/ckDZODg2asPncDaWdTjXnL86mpm6siWpv94WQ9F5PsyhBwNGfqkGyCcjRi0TD3syzPGG+e3iIyTEmvUYNP1/6K6ZwIAeiXNg06ukSE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(54906003)(44832011)(8676002)(2616005)(956004)(478600001)(6486002)(316002)(86362001)(4326008)(7416002)(6666004)(38100700002)(7696005)(38350700002)(52116002)(16526019)(26005)(186003)(2906002)(5660300002)(66946007)(8936002)(83380400001)(36756003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dMvKT019mmGJmSJ3UFlQoofR1ZTvUpNQSUNhlOVK+gIklhHrgzl5x2Zd0/Jf?=
 =?us-ascii?Q?1rpjXC4OEZE1am1c+t8sCi/Ubi9PlED5ImNuhOMgZmcpKTxi7PjtUFiWobUQ?=
 =?us-ascii?Q?4Km6tI37ezQcTh/bhYjQH4/GJOl1ZRNjdYgupp2rLutiY73zwpV4negbx+5t?=
 =?us-ascii?Q?4C/SgfM9MJgtwTTpCJ4mST3UAjqjJHN5Gzayn3njNcQ03XhPQXKGFXhRba3t?=
 =?us-ascii?Q?kuHsbKUX79zpBTi87gQsGf+pD9xyQO3jEV/pUDaCj/qedI6kRr9Tbiygq0As?=
 =?us-ascii?Q?1wHw21PLG3nXx7CRglj+K2q7yuN+blFXwOAzLddh+UJXeeRuUJJDffHVv5fB?=
 =?us-ascii?Q?27wXn27R1f1jEDrs7h+TCM2ZWqDpt8kORAFgoIkWiJegD+l8mGmniQuMlhZY?=
 =?us-ascii?Q?rC7rGDsiFby7LmmKLZ4oVFT19QCkS5/9LZVa8j9xQ823Iupk8xj2M96cLXEA?=
 =?us-ascii?Q?39gfL5sdT4HZziXGAd3Pv5O5+3GFsopROi3tvLUMKWFDCSmWMJ/vUl7kJV3d?=
 =?us-ascii?Q?rdnNFdMoK49ab37t2UGeZr9zW8ACE4w5R+JrlATImxDG3DE3oKbhj4P6eXkX?=
 =?us-ascii?Q?GANOyFzymxSXU+u3u97VbidztZ03TRzzIWwpBeUYm9bQWbc07nmtcb3EEX8B?=
 =?us-ascii?Q?5Fp2hyVMWOj7cUPNKosjDXwjVRNNu1x7J+pVUji8yxIS/MZ5ulhJ3sZ49XZ8?=
 =?us-ascii?Q?1BPDcYdcDkoi+49KUd0XviM3Q37QHHARCg2NV06zOtwHIhHxD6yrfHu0eozh?=
 =?us-ascii?Q?BssyN5rbufxlQLEZHn8xigUjQCm2JZPRI1o6x/ewT6nZ4jQdJjK+OU11uymz?=
 =?us-ascii?Q?+XywFRcOR5BTEgp4NhyyBpCkrE6SFuS8A8V/Mmxixssp5I6yzcjcX/kDvpri?=
 =?us-ascii?Q?3RTxi4p5yVZJAtLczTRvaKvv6iFS/albXOt3A0DjDh1c7lPtQg+Qatt19Yyy?=
 =?us-ascii?Q?AL7VkbXCd4Aa0e8XQbtfrxtff1ovddfzHUAv1I0K6DEP1ja2NIIjFOdv6zPV?=
 =?us-ascii?Q?7Dv+6VRyhwMUwxqqca1MbXhTHsP6LmeNhIXQhM6lwfHFR/2E5wxPBjVO7wxu?=
 =?us-ascii?Q?KxxZbwZks6yLFlo15FWI8Wg0A1gok80A+Ryuc6zKZGPEjy27uLbzrNUZG49+?=
 =?us-ascii?Q?EjldMsYLSGzYbB/dKq1ugCf7a/B/2VI2cHGC5VYSvEV5QHtj0CzHrVZjhYxP?=
 =?us-ascii?Q?dfBfLnRBgo1kSulYlj0B9YGAa5waShj7LEjxRp9mOTTCrti4nspFDjCP1IwQ?=
 =?us-ascii?Q?q4+wOQg2eqUgvfB1Wbikeuu7pOqkelSnD9FoS1DDkGrkwPe/b3dLGHyV2qat?=
 =?us-ascii?Q?vE8X29a8RYRxAmlW3qNlaX0C?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a749c7b-5671-4f6f-cb04-08d925d050b1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:28.8729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q16B7QdudCLqMhCnZtJJLC1xrvqQ9KJHcOk2fd1EqO6wHmM9d4wvJ40A1XWPdrTvTfRqDDhEW7BeYM5b/aqXzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
changes required in a host OS for SEV-SNP support. The series builds upon
SEV-SNP Part-1.

This series provides the basic building blocks to support booting the SEV-SNP
VMs, it does not cover all the security enhancement introduced by the SEV-SNP
such as interrupt protection.

The CCP driver is enhanced to provide new APIs that use the SEV-SNP
specific commands defined in the SEV-SNP firmware specification. The KVM
driver uses those APIs to create and managed the SEV-SNP guests.

The GHCB specification version 2 introduces new set of NAE's that is
used by the SEV-SNP guest to communicate with the hypervisor. The series
provides support to handle the following new NAE events:
- Register GHCB GPA
- Page State Change Request
- Hypevisor feature
- Guest message request

The RMP check is enforced as soon as SEV-SNP is enabled. Not every memory
access requires an RMP check. In particular, the read accesses from the
hypervisor do not require RMP checks because the data confidentiality is
already protected via memory encryption. When hardware encounters an RMP
checks failure, it raises a page-fault exception. If RMP check failure
is due to the page-size mismatch, then split the large page to resolve
the fault.

The series does not provide support for the following SEV-SNP specific
NAE's yet:

* Extended guest request
* Interrupt security

The series is based on the commit:
 a4345a7cecfb (origin/queue, origin/next, next) Merge tag 'kvmarm-fixes-5.13-1' 
 3bf0fcd75434 (tag: kvm-5.13-1, origin/next, next) KVM: selftests: Speed up set_memory_region_test

Changes since v2:
 * Add AP creation support.
 * Drop the patch to handle the RMP fault for the kernel address.
 * Add functions to track the write access from the hypervisor.
 * Do not enable the SNP feature when IOMMU is disabled or is in passthrough mode.
 * Dump the RMP entry on RMP violation for the debug.
 * Shorten the GHCB macro names.
 * Start the SNP_INIT command id from 255 to give some gap for the legacy SEV.
 * Sync the header with the latest 0.9 SNP spec.
 
Changes since v1:
 * Add AP reset MSR protocol VMGEXIT NAE.
 * Add Hypervisor features VMGEXIT NAE.
 * Move the RMP table initialization and RMPUPDATE/PSMASH helper in
   arch/x86/kernel/sev.c.
 * Add support to map/unmap SEV legacy command buffer to firmware state when
   SNP is active.
 * Enhance PSP driver to provide helper to allocate/free memory used for the
   firmware context page.
 * Add support to handle RMP fault for the kernel address.
 * Add support to handle GUEST_REQUEST NAE event for attestation.
 * Rename RMP table lookup helper.
 * Drop typedef from rmpentry struct definition.
 * Drop SNP static key and use cpu_feature_enabled() to check whether SEV-SNP
   is active.
 * Multiple cleanup/fixes to address Boris review feedback.

Brijesh Singh (34):
  KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
  x86/cpufeatures: Add SEV-SNP CPU feature
  x86/sev: Add the host SEV-SNP initialization support
  x86/sev: Add RMP entry lookup helpers
  x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
  x86/sev: Split the physmap when adding the page in RMP table
  x86/traps: Define RMP violation #PF error code
  x86/fault: Add support to dump RMP entry on fault
  x86/fault: Add support to handle the RMP fault for user address
  crypto:ccp: Define the SEV-SNP commands
  crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
  crypto: ccp: Shutdown SNP firmware on kexec
  crypto:ccp: Provide APIs to issue SEV-SNP commands
  crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
  crypto: ccp: Handle the legacy SEV command when SNP is enabled
  KVM: SVM: make AVIC backing, VMSA and VMCB memory allocation SNP safe
  KVM: SVM: Add initial SEV-SNP support
  KVM: SVM: Add KVM_SNP_INIT command
  KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
  KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
  KVM: SVM: Reclaim the guest pages when SEV-SNP VM terminates
  KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
  KVM: X86: Add kvm_x86_ops to get the max page level for the TDP
  KVM: X86: Introduce kvm_mmu_map_tdp_page() for use by SEV
  KVM: X86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
  KVM: X86: Define new RMP check related #NPF error bits
  KVM: X86: update page-fault trace to log the 64-bit error code
  KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
  KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
  KVM: SVM: Add support to handle Page State Change VMGEXIT
  KVM: Add arch hooks to track the host write to guest memory
  KVM: X86: Export the kvm_zap_gfn_range() for the SNP use
  KVM: SVM: Add support to handle the RMP nested page fault
  KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event

Tom Lendacky (3):
  KVM: SVM: Add support to handle AP reset MSR protocol
  KVM: SVM: Use a VMSA physical address variable for populating VMCB
  KVM: SVM: Support SEV-SNP AP Creation NAE event

 arch/x86/include/asm/cpufeatures.h       |    1 +
 arch/x86/include/asm/disabled-features.h |    8 +-
 arch/x86/include/asm/kvm_host.h          |   24 +
 arch/x86/include/asm/msr-index.h         |    6 +
 arch/x86/include/asm/sev-common.h        |   17 +
 arch/x86/include/asm/sev.h               |    4 +-
 arch/x86/include/asm/svm.h               |    8 +
 arch/x86/include/asm/trap_pf.h           |   18 +-
 arch/x86/include/uapi/asm/svm.h          |    2 +
 arch/x86/kernel/cpu/amd.c                |    3 +-
 arch/x86/kernel/sev.c                    |  189 ++++
 arch/x86/kvm/lapic.c                     |    5 +-
 arch/x86/kvm/mmu.h                       |    5 +-
 arch/x86/kvm/mmu/mmu.c                   |   76 +-
 arch/x86/kvm/svm/sev.c                   | 1162 +++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c                   |   37 +-
 arch/x86/kvm/svm/svm.h                   |   39 +-
 arch/x86/kvm/trace.h                     |    6 +-
 arch/x86/kvm/vmx/vmx.c                   |    8 +
 arch/x86/kvm/x86.c                       |   89 +-
 arch/x86/mm/fault.c                      |  148 +++
 drivers/crypto/ccp/sev-dev.c             |  666 ++++++++++++-
 drivers/crypto/ccp/sev-dev.h             |   14 +
 drivers/crypto/ccp/sp-pci.c              |   12 +
 include/linux/kvm_host.h                 |    3 +
 include/linux/mm.h                       |    6 +-
 include/linux/psp-sev.h                  |  323 ++++++
 include/linux/sev.h                      |   76 ++
 include/uapi/linux/kvm.h                 |   43 +
 include/uapi/linux/psp-sev.h             |   44 +
 mm/memory.c                              |   13 +
 tools/arch/x86/include/asm/cpufeatures.h |    1 +
 virt/kvm/kvm_main.c                      |   21 +-
 33 files changed, 2992 insertions(+), 85 deletions(-)
 create mode 100644 include/linux/sev.h

-- 
2.17.1

