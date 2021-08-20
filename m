Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9637C3F3072
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhHTQAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:00:35 -0400
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:44288
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238344AbhHTQAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:00:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6HqVE3EXPKvf8CiWcNZ5UAMUSRzFiuKaCSYQxoi1+vo4vBWFqVumHb+CWU0rfH0r0B9ZTjA6EfodswAczoMFvMIvxGAVPDT+hTEYj0RgcoW90OSTrYSJfC5AhTw8Q5O00Gn0PRuAg8PXZr4XUJaDS7LEo4GRpLVsyeWqy7FIUIq7GEVkkwtKCmZBK8r9ybvYtQ6wqziaP9g1bKckzWnjQ8j+SzExle2vKj5TxYrL+irzdQTE9yLsfVgLI85MUsdMvwzSiROvjEFWmw474RWvRkLgPsGfC5VG67zI7y0tU0RiCeG5xz8mbykG9L4gwz4pv6ynwpOUBiyiAGjOEIiPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXcDqIVCebPrGDnoXSve7KqTN0VYrYGXx4N4y/NMvhY=;
 b=II9yOm2Pije7j7wEsIzrPyYvc1aAUQeDi+GDL6UHH0KHXdEB1mbgwQd5A6uBAE9Bx09HkmbdEnNOvNypnZVOPaXrPLicLsGnpwZZAdfgKVRlmFwDzZQCxQJ+kNUykGT7UllDZGxzBthZDBbPoL3fB9xXzGCA6GHo68p+L/ytN/9RKZeNvpIBNM4zjdfqfYJW754UMk/kNXGlCbdAUMwZHbqS6NI090wD2rzDMi+Jc4Qdpv+8029GTxxurtBUN6u9QMsVbFIcB6I0gbZ/R7KdLLMY8TzNrY+QNO7gJUNwnN980tPA9ghzUKjIzKxm65eK1hfrp+vs9tzIZZ/le0tBSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXcDqIVCebPrGDnoXSve7KqTN0VYrYGXx4N4y/NMvhY=;
 b=a37bP4JEtQl0v0h8H6W+CLSZfA+Yq91aByamBQEvNM6/6DUTDtLdV/4gGRM7l0+DmSeTt7E3MMtIiLN2uSFuvnhG+b4joNjvY8RhxZtSyhiuVD8Y1VS1ueiqx5Eh9wA2I3BWHsc5sfyfI5DGbirO+sLyaC5sHTyCxszHo4VnUFo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 15:59:53 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 15:59:53 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support 
Date:   Fri, 20 Aug 2021 10:58:33 -0500
Message-Id: <20210820155918.7518-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 15:59:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 752393c3-85b6-4c79-b040-08d963f38c7d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26858E612528AE06AD3EB429E5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YXqHsztskmxkc1WFQMuz8S9HlKIyvBcZOX/YWcVSzQ7RZEigPbkVj5PYOEiXH6mBNMdFjQkks3YBpPC+T63kDAT5+qNNqKFe8+UtUPUdoi5xT33LuYvGLQjFL8e/ONvEC2TrT1Z+kf3WvsPuo2UasQEP8q/AE63mr+vjmIw869BHrpL/t7YJJoca3gOrSOvAtwkYAhs9V/o3QBcXfBtJs46VnroCZedTEOYrPgjVmeA8TCP/FKTBSgvguKxZdlfGO54WmL3fLwIF28SPQJRqqHGmv5iR03qXUI1qTbs5Bsn/BpScdgvm21Qw3se5Zy8+SzxdE3SHIn4GxY+9pDxOXAOh0yeF52hReZQ+2lXjX1GSdwIShduHJsfIHxrJ7vnqbUrQbgxMqtwz1LTSYOOlptLwWD3GaCNsD/F867MYhNp2K9bqbWNCSxZLbbVA9djN3FkKq64+41O0RlzKCHGW6jIxPNDlsYj/PmPs51shT7xNodVy08Wh/J34KT0U9TVfXxnoTyrWI2IMntUO77L7JGP0RIeS019zlXHw87Z1o04LsTSUQcl0IEur6MwzMyBNzk4vIIMIoFWfAJ6Oa5RA5x2Jlvn8QIpgPa5BmpcBttmn4VWOMwK04Sn3ya1R8zPG8BcufT0vBw7aP4prYEKKjKkR4vOuB5YZS35qedIgIQinhHiw7J9OcWxvVGxhfq5PdaE7jJN1i8V5fawUghZnJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(8676002)(316002)(54906003)(5660300002)(8936002)(1076003)(2906002)(478600001)(36756003)(4326008)(38100700002)(38350700002)(86362001)(6486002)(26005)(83380400001)(4743002)(186003)(956004)(2616005)(44832011)(7696005)(66946007)(52116002)(66556008)(66476007)(7406005)(7416002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4y+BuhCb+vhp1PghbtSxzUszwr9+lD4qPgh8LfItKVYuo8ka2iYxxEPKqYJJ?=
 =?us-ascii?Q?R5m8pNi63G0OVHash3ClY7Ml/qxIjrtpDI54LlNmWMuBn0k1KgnrRUBjt0rd?=
 =?us-ascii?Q?9iYd2Vfqd/GXfGwxT0MI52HHbm8SNlEuqg+D97fvtNgI0oAcoWb19yxd+AyT?=
 =?us-ascii?Q?0r+N3rlh6hkobFqaEBzI4ka03VQxpONCPdXDZAk/lDtzg+scP4ivKT7dw99F?=
 =?us-ascii?Q?4R1FudxMQ96ut455GgAbaXbrUeeUKvKUG6pqS9PZ0yrLrpQA1VL/E4bHEqL8?=
 =?us-ascii?Q?5yhFhU+BenGftmss+upYLLSQk0Es0vcMugJsOlt7XSVMHSxgbQ7RyXpork1e?=
 =?us-ascii?Q?kVa0oqNHbOOh2t3x5K5X6YTlIju7r+oVQDIPWs+DR+NddbVmo9lk2uIJctrq?=
 =?us-ascii?Q?nIss138SwCWQlhcn0nh2Cm0hHxDxcobo56VG57C2ds7SJsQ2kG22F31dQDdS?=
 =?us-ascii?Q?/f3mpiFaoCpVGhqPg5EMu7/f9FDF4v9VbGX9RQYDk6lCbazknRDOrvvOROyb?=
 =?us-ascii?Q?MLb6NCB/ltwGlVdLTFlUVg2XSAUugV862hCSv18zSFZIACLpHabBTXNN0sq4?=
 =?us-ascii?Q?2AtIkVYsx7ZAXCI79BaTqIfeWyfuMXZwsVfw6awvlheHx58wm40iwmqZJHQS?=
 =?us-ascii?Q?yuqKCEhhtPzroeExRzgHuDWptmEJknIVAmHAc4CXsd2iuQQGO4JgFcceDjN8?=
 =?us-ascii?Q?MFseaiSuAkMWHoObTVs6B58JOVvg3gX41kKfP3GtLyBeBejprvMgOtV5Oq4c?=
 =?us-ascii?Q?K3bUsdtYSew3KFYZhYC19I2cszRuJBjp/V4Y6boyZA8sNRdES7b7XkNQQvsT?=
 =?us-ascii?Q?w91ZK6qngEiUCHAg/vIIkFbkRNTBD8XbW2mltC+lc5jeSyAeueekMyXg8HjS?=
 =?us-ascii?Q?GtCDhkH2pCB54IXtE2BBTeo5H7AL6r1RJT8ADUCxsKVblCKaa2tYCU23oYVD?=
 =?us-ascii?Q?kdnvVkRGGKSwvVonnx1Kx2T9eXEYj6eioUKZfMIebXOoIE/JAV0bRE9Vzb5d?=
 =?us-ascii?Q?sxFIQL3iNdWqscWFCedE6oRGo9N3Y3RVN1i3AkpuJaNpzMVqPh6WwRMmW8vk?=
 =?us-ascii?Q?hP4AGIjqNpMQ0JOY/AYfmltrpGonJHSgAQ5fi/WHW98PSRPMeTKh3FNeD6O6?=
 =?us-ascii?Q?tp4HMm6SwVzRRT81mzP1XCRtUk80D7Ezsee9UDXhdNi7ynaLBb9NntxGObFx?=
 =?us-ascii?Q?r0lcyNrcRYSTpIXWIL8wt61Fh7IcU4exm0IIV10AxslJbfg10N38YZReTzJG?=
 =?us-ascii?Q?D+J+UCb/cpGXZh54M+8RvNtFZlZoX8vrsxbI/zahNH8rSincs71IloBu9/iZ?=
 =?us-ascii?Q?b46UIMeKyHOtk64ZzxDKB8za?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 752393c3-85b6-4c79-b040-08d963f38c7d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 15:59:53.7264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcDxnSxdrOuIBkgQShNPufCmIToylw40x2njY6T6/3edKClXovEnQWhmS/W1P3P3AMAgPxYHMKXe5yNchoAJKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
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

The series does not provide support for the interrupt security and migration
and those feature will be added after the base support.

The series is based on the commit:
 SNP part1 commit and
 fa7a549d321a (kvm/next, next) KVM: x86: accept userspace interrupt only if no event is injected

TODO:
  * Add support for command to ratelimit the guest message request.

Changes since v4:
 * Move the RMP entry definition to x86 specific header file.
 * Move the dump RMP entry function to SEV specific file.
 * Use BIT_ULL while defining the #PF bit fields.
 * Add helper function to check the IOMMU support for SEV-SNP feature.
 * Add helper functions for the page state transition.
 * Map and unmap the pages from the direct map after page is added or
   removed in RMP table.
 * Enforce the minimum SEV-SNP firmware version.
 * Extend the LAUNCH_UPDATE to accept the base_gfn and remove the
   logic to calculate the gfn from the hva.
 * Add a check in LAUNCH_UPDATE to ensure that all the pages are
   shared before calling the PSP.
 * Mark the memory failure when failing to remove the page from the
   RMP table or clearing the immutable bit.
 * Exclude the encrypted hva range from the KSM.
 * Remove the gfn tracking during the kvm_gfn_map() and use SRCU to
   syncronize the PSC and gfn mapping.
 * Allow PSC on the registered hva range only.
 * Add support for the Preferred GPA VMGEXIT.
 * Simplify the PSC handling routines.
 * Use the static_call() for the newly added kvm_x86_ops.
 * Remove the long-lived GHCB map.
 * Move the snp enable module parameter to the end of the file.
 * Remove the kvm_x86_op for the RMP fault handling. Call the
   fault handler directly from the #NPF interception.

Changes since v3:
 * Add support for extended guest message request.
 * Add ioctl to query the SNP Platform status.
 * Add ioctl to get and set the SNP config.
 * Add check to verify that memory reserved for the RMP covers the full system RAM.
 * Start the SNP specific commands from 256 instead of 255.
 * Multiple cleanup and fixes based on the review feedback.

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

Brijesh Singh (40):
  x86/cpufeatures: Add SEV-SNP CPU feature
  iommu/amd: Introduce function to check SEV-SNP support
  x86/sev: Add the host SEV-SNP initialization support
  x86/sev: Add RMP entry lookup helpers
  x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
  x86/sev: Invalid pages from direct map when adding it to RMP table
  x86/traps: Define RMP violation #PF error code
  x86/fault: Add support to handle the RMP fault for user address
  x86/fault: Add support to dump RMP entry on fault
  crypto: ccp: shutdown SEV firmware on kexec
  crypto:ccp: Define the SEV-SNP commands
  crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
  crypto:ccp: Provide APIs to issue SEV-SNP commands
  crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
  crypto: ccp: Handle the legacy SEV command when SNP is enabled
  crypto: ccp: Add the SNP_PLATFORM_STATUS command
  crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
  crypto: ccp: Provide APIs to query extended attestation report
  KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
  KVM: SVM: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
  KVM: SVM: Add initial SEV-SNP support
  KVM: SVM: Add KVM_SNP_INIT command
  KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
  KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
  KVM: SVM: Mark the private vma unmerable for SEV-SNP guests
  KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
  KVM: X86: Keep the NPT and RMP page level in sync
  KVM: x86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
  KVM: x86: Define RMP page fault error bits for #NPF
  KVM: x86: Update page-fault trace to log full 64-bit error code
  KVM: SVM: Do not use long-lived GHCB map while setting scratch area
  KVM: SVM: Remove the long-lived GHCB host map
  KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
  KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
  KVM: SVM: Add support to handle Page State Change VMGEXIT
  KVM: SVM: Introduce ops for the post gfn map and unmap
  KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
  KVM: SVM: Add support to handle the RMP nested page fault
  KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
  KVM: SVM: Add module parameter to enable the SEV-SNP

Sean Christopherson (2):
  KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
  KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX and SNP

Tom Lendacky (3):
  KVM: SVM: Add support to handle AP reset MSR protocol
  KVM: SVM: Use a VMSA physical address variable for populating VMCB
  KVM: SVM: Support SEV-SNP AP Creation NAE event

 Documentation/virt/coco/sevguest.rst          |   55 +
 .../virt/kvm/amd-memory-encryption.rst        |  102 +
 arch/x86/include/asm/cpufeatures.h            |    1 +
 arch/x86/include/asm/disabled-features.h      |    8 +-
 arch/x86/include/asm/kvm-x86-ops.h            |    5 +
 arch/x86/include/asm/kvm_host.h               |   20 +
 arch/x86/include/asm/msr-index.h              |    6 +
 arch/x86/include/asm/sev-common.h             |   28 +
 arch/x86/include/asm/sev.h                    |   45 +
 arch/x86/include/asm/svm.h                    |    7 +
 arch/x86/include/asm/trap_pf.h                |   18 +-
 arch/x86/kernel/cpu/amd.c                     |    3 +-
 arch/x86/kernel/sev.c                         |  361 ++++
 arch/x86/kvm/lapic.c                          |    5 +-
 arch/x86/kvm/mmu.h                            |    7 +-
 arch/x86/kvm/mmu/mmu.c                        |   84 +-
 arch/x86/kvm/svm/sev.c                        | 1676 ++++++++++++++++-
 arch/x86/kvm/svm/svm.c                        |   62 +-
 arch/x86/kvm/svm/svm.h                        |   74 +-
 arch/x86/kvm/trace.h                          |   40 +-
 arch/x86/kvm/x86.c                            |   92 +-
 arch/x86/mm/fault.c                           |   84 +-
 drivers/crypto/ccp/sev-dev.c                  |  924 ++++++++-
 drivers/crypto/ccp/sev-dev.h                  |   17 +
 drivers/crypto/ccp/sp-pci.c                   |   12 +
 drivers/iommu/amd/init.c                      |   30 +
 include/linux/iommu.h                         |    9 +
 include/linux/mm.h                            |    6 +-
 include/linux/psp-sev.h                       |  346 ++++
 include/linux/sev.h                           |   32 +
 include/uapi/linux/kvm.h                      |   56 +
 include/uapi/linux/psp-sev.h                  |   60 +
 mm/memory.c                                   |   13 +
 tools/arch/x86/include/asm/cpufeatures.h      |    1 +
 34 files changed, 4088 insertions(+), 201 deletions(-)
 create mode 100644 include/linux/sev.h

-- 
2.17.1

