Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EA736FA77
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhD3Mjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:39:47 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:15105
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231936AbhD3Mjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2NxnDHRlcmX6hfUH1a3nyZ4NrsYnSm/otwkUYZ1YeCryhqL0fwp8WLLCVXQZnc08GZcSFyRZuAGYv7FIfZMoGSXXi/tsjiAPF9hjA/c14mDsG5UZAPE+nNqW/EyEZ1ExcI+20mJJdWsrG71LGynIoiQ24/oqsM2+qyQ21ZKiId66GDR9Jz+RYHeDqpE+g/Nz6RT/jUOfV3M+wDIMmYcKQVyWOSAHq6KQCDRyq3e/vdd6gbz+CqxlYuJIYh+XJVnudaF551Z/nabgBG5Ymd3xpin5WyhqwiZ2XF2RVYdqd1VolYs0gVNKcNyqbCGjZ7PDkm9WpVeA4xbZl16L0LAvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEy3noc9TJ2juUdBem469NqB23jPpLN6Qy2bYVZAThU=;
 b=cjRgwlk0S2+e8cO8jIW0tB9Vio+a34XISXPqkRzzPgTMLqYQo/MXXNV6s1dXyCDPJV7u5mJqQh0sp2dZP0TQ9KNXD9Hi+J/ym3dfML0b4zRNhUwMgN/P8HNZwp/TZ8cMpzeg39FgafaKLqvPuFyEfVlBQGlqn730fHQGaBgZ41BR3hXopYzqmxrDw0DPKLEnUeAM11Z6pUr/LUqhJf5DMQblGMOBK5p3fSD0DLS1RM9WgLYgKxsl8gUm6GBHRGhYFee9BhEuxc7LadIefKQBG6PAPOSD/wVuW77AELZ1UX5lVzBe9ZZqbQms89Ggdi7ONw0FeZ2xUgj2dIrSyNIuLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEy3noc9TJ2juUdBem469NqB23jPpLN6Qy2bYVZAThU=;
 b=Eu65HG+m9DjoBRpf5tToMk8+QmNoIMTwnocxrQALKcEOBwTdl9OZAgBzL2fzlMjl/MbEKLHF2QBUS8/S/hHno2w+Alk2WKHwbvz2csHusLrxYVfU/Wsh3UQj/UfTpQbnE7YGksoLPNJptDQcbTQIH31o1sy1/kPS1wV8hKj0kBg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:38:54 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:53 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 00/37] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
Date:   Fri, 30 Apr 2021 07:37:45 -0500
Message-Id: <20210430123822.13825-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:38:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bb143a0-f1de-44ba-52b5-08d90bd4ea04
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4511F5B30656881348556E94E55E9@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MikdWGIy5e9IW9P2uktl7CT7I57hI/huVT3D8L0ZOFQ++MP0Tc2kNx4dsbzxF0ufnfJaBZ1Dcsncp8MiYO2/2l0Z43trEAK0XRsPndeboPbYNcYBle4v8uCtGbZ6M07YKKHh5uRRk0IgNwWZmlZvZy1OzgrC1fQjiCXupzwjOXPPf6oJZHwhEuehOMQpGeL9Gbr3UdrdskzdW3H7KkMo4pyCzh+HNxdleHji+ED1iYoAr77HVjlvnACmGnJGSv9RGlWRXF+KMUkX719oW38Xhpa9RYyTS/MJfjD/BewnnhUDUJfueaFWa5JebRr21kjAW8lO4WJ/cY+DzUpSSm42VJYbFcNKxm2bKNboVsYW/9tNN6pC63cm2LZTgGCdKxpaOpTULkOsiAmrIbL1zJy35vBVMqYxwKPS0cYFYyfvy7ex4k2sJJbKwYHx9cGi6ZHtmhhww3F0qnNhmWQpqQn5Q2HOVvLQSBvOH+LICMGTUVSJokpNzkSd2FlSL5J9GkpEBy+s4GUip0TbYJaDEyrUCOKJN8XY5k+0lEmvyt45Nv/H9Xcv1AA+qk+rkjQgsc5mCKKoHvBocIhNdJUlkAJW2snC/BOQLALdcqk8KersdQ6mTlxgQCKDYNNys1ZYvRVXdzISk7GdAftoiP6zXYIH29JoYNuzz0h43YhXNPhA54xxZko3zjK3vBeO4XIuZLHo4soVCg8CyRAMloQL4b8pgX+74F8WH5+7igsIcSZcuAJ/GHSpOD6xQoynSrpiIQr0/F189kASb4a5MT3oXxaf7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(83380400001)(36756003)(8936002)(86362001)(966005)(66476007)(956004)(186003)(38350700002)(16526019)(6666004)(6486002)(44832011)(52116002)(5660300002)(38100700002)(7416002)(66556008)(2616005)(26005)(478600001)(4326008)(66946007)(316002)(2906002)(8676002)(7696005)(1076003)(6606295002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?77cxu7s40lplpjlLrUygEUrcYI7ke85FPQSyPrUPuFmmJLBhWuf9E8uQi/TD?=
 =?us-ascii?Q?qlbqcyDoAu1jX0+yEVqZri9q9SfNMr6X8ZmVcAKngW+BPTVYGXK6DDShh+5d?=
 =?us-ascii?Q?6lmOnes16TcsSgjZRwbeaGnf0kqkpy6Ae45Vi/EonTZ7+mtqwVqk+4SC5Liq?=
 =?us-ascii?Q?0yhuCIyG9QbyYiPp1T3ffzPkqYa9/9ypPhk4DT683IdOa57BcsDdPldMeGzL?=
 =?us-ascii?Q?pYeFYtWVvQJYZbFLpHWxomlV7HfyE+Xxh1A7GoyBUeMIzY1O6ZSw0bskdcrW?=
 =?us-ascii?Q?korFRyPQ9dMQt9RMAuWu4ok6c6oahFe9C7PfgLoC4YKWi5NKAdj34iEMONkt?=
 =?us-ascii?Q?+t3W1kM1krXZLPaPfLiEZD5VTaPpcWnchW4QId3NU13D98YD2p32C/U7dJ3E?=
 =?us-ascii?Q?dyws1XWlICHthcmOQvDqO8hItX1izKcOw2gNhD8+gMttVtU2w67YId/+10ml?=
 =?us-ascii?Q?WH7ZID58LeCXnzXr+F7PUsdC77AniiTR/9FnYXMis1lx4+VDj+AvICNShds/?=
 =?us-ascii?Q?+6mjtdDBzMO/ed6XMby3wclGAi/GeFS5JaTtSR8fA3XEzMK4ZsBAoX3LLYHI?=
 =?us-ascii?Q?9ucdr+2FAnfg+KVb+pJLPaMAi5/Tl2AADTMtJz6UmvatvdvI4eNqc8YGiok7?=
 =?us-ascii?Q?iXCgC84GhmrcmrZYS4KUFEFF10NTa7ZP5EfL2HZ9Vvm2pY1gnoOs/j63Exod?=
 =?us-ascii?Q?vVXepU11T1cIHOBwcxBbVgCuyWFzn+zOZdHDVVtIoTjkKbwcp0tehrt7UzPz?=
 =?us-ascii?Q?KXiegPRt9rSFUF17xQZH+c/64vs0aESVzu+pMljx1khPX4hjX1kki5HC6llw?=
 =?us-ascii?Q?u5uSL3edOX1dRpsKfDyypqMRcXNRAsr5sq+jedHZUcIYzT/5t88Sl6q6X6KK?=
 =?us-ascii?Q?aXau+BuERBT0UiBkMhPQzhefLeypeIPAg/ulpseB5OQ24TB77rGTRaih5qPV?=
 =?us-ascii?Q?yvsUIeT1xKPXrhX5fvIGgnOD8HjH7aiUTaL/b9G2TcSsblFwO1hX+Cknwdvi?=
 =?us-ascii?Q?GFmuPUiSQTh+UCZTP5wEThYEmBT+dKbUHrC9cezDmX78z3mlbSwNFXhj83Ed?=
 =?us-ascii?Q?S6LNjKyTrMRFcd+ZEk3lWl+a6EzJ/9GYI+BgjoKglxzRsW4GtW7Z+VNk7pCJ?=
 =?us-ascii?Q?D5uA8EpHq0ua0H+CNciLfdlRU/N0Ko/jwlDQsx8gmGyT/XULITvpwwv1LcAk?=
 =?us-ascii?Q?KjiKvKeCSkIz3aMks3lp8WKkJCDAi5w2XccaeHjrsLVZwKr/nwE5As2JATz+?=
 =?us-ascii?Q?tkkjl+6cX79wNsuwFIizKWhTIAh1SgPwG6fR020ByWjQnbp4kYYiTPFdSb0f?=
 =?us-ascii?Q?z+pK/EFFOOCVSAEJRHVJo8m5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb143a0-f1de-44ba-52b5-08d90bd4ea04
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:53.8039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3/mLmi0Kubi1TWmiPoN7IwC3+SlygREY/pxGKVeWa6bg6BvO75f0MHWfoMRzqu0SyrQvJl5oxZFC8T2FgqGIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
changes required in a host OS for SEV-SNP support. The series builds upon
SEV-SNP Part-1 https://marc.info/?l=kvm&m=161978500619624&w=2 .

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
* AP bring up
* Interrupt security

The series is based on the commit:
 3bf0fcd75434 (tag: kvm-5.13-1, origin/next, next) KVM: selftests: Speed up set_memory_region_test

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

Brijesh Singh (36):
  KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
  KVM: SVM: Increase the GHCB protocol version
  x86/cpufeatures: Add SEV-SNP CPU feature
  x86/sev: Add the host SEV-SNP initialization support
  x86/sev: Add RMP entry lookup helpers
  x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
  x86/sev: Split the physmap when adding the page in RMP table
  x86/traps: Define RMP violation #PF error code
  x86/fault: Add support to handle the RMP fault for kernel address
  x86/fault: Add support to handle the RMP fault for user address
  crypto:ccp: Define the SEV-SNP commands
  crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
  crypto: ccp: Shutdown SNP firmware on kexec
  crypto:ccp: Provide APIs to issue SEV-SNP commands
  crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
  crypto: ccp: Handle the legacy SEV command when SNP is enabled
  KVM: SVM: make AVIC backing, VMSA and VMCB memory allocation SNP safe
  KVM: SVM: Add initial SEV-SNP support
  KVM: SVM: define new SEV_FEATURES field in the VMCB Save State Area
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
  KVM: X86: Export the kvm_zap_gfn_range() for the SNP use
  KVM: SVM: Add support to handle the RMP nested page fault
  KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
  KVM: SVM: Advertise the SEV-SNP feature support

Tom Lendacky (1):
  KVM: SVM: Add support to handle AP reset MSR protocol

 arch/x86/include/asm/cpufeatures.h       |   1 +
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/kvm_host.h          |  14 +
 arch/x86/include/asm/msr-index.h         |   6 +
 arch/x86/include/asm/sev.h               |   5 +-
 arch/x86/include/asm/svm.h               |  15 +-
 arch/x86/include/asm/trap_pf.h           |  18 +-
 arch/x86/kernel/cpu/amd.c                |   3 +-
 arch/x86/kernel/sev.c                    | 167 ++++
 arch/x86/kvm/lapic.c                     |   5 +-
 arch/x86/kvm/mmu.h                       |   5 +-
 arch/x86/kvm/mmu/mmu.c                   |  76 +-
 arch/x86/kvm/svm/sev.c                   | 961 ++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c                   |  22 +-
 arch/x86/kvm/svm/svm.h                   |  31 +-
 arch/x86/kvm/trace.h                     |   6 +-
 arch/x86/kvm/vmx/vmx.c                   |   8 +
 arch/x86/mm/fault.c                      | 207 +++++
 drivers/crypto/ccp/sev-dev.c             | 647 ++++++++++++++-
 drivers/crypto/ccp/sev-dev.h             |  14 +
 drivers/crypto/ccp/sp-pci.c              |  12 +
 include/linux/mm.h                       |   6 +-
 include/linux/psp-sev.h                  | 323 ++++++++
 include/linux/sev.h                      |  81 ++
 include/uapi/linux/kvm.h                 |  43 +
 include/uapi/linux/psp-sev.h             |  44 ++
 mm/memory.c                              |  13 +
 tools/arch/x86/include/asm/cpufeatures.h |   1 +
 28 files changed, 2664 insertions(+), 78 deletions(-)
 create mode 100644 include/linux/sev.h

-- 
2.17.1

