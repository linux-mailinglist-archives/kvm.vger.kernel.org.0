Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D722C1117
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 17:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgKWQwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 11:52:39 -0500
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:56288
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726417AbgKWQwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 11:52:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fReeecNBlC70fb2eGhVj5AlNmy05ug6H1xdHLFrcdF2g6Y+rRQs4KBQvHkEoOIjH9X3/qVNMgd4Q8xzNp3E25XfRZru/SeU2K1cPpvN0NTLyPPXTIUboXdnnR+NMbdfr7nXty/uygJSPSacmMDosCb/+OOpwZrgmVu5dJSy23OLonbWP4pVXJpEGfrmf43LPZDapVwcpa1cmx9ou5oLurBZK7suuIXSP+RqqMU7Me41Nsam1FfI15tUGaW/eKGhp7MRsbkmz7sMe/tSqnFLYEbqOiL2SLqbm9mH8D/oPonGfmC8cH6pu2lJesHZ2XbGJ/YhbPo73xG7o2taqVzMj0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyXc+cvch+FcFZFKzoBvxECsPLaaLsocN0aBh9fEchQ=;
 b=DOxCTc9MLWQAq25VBjrlPe25FeQ8/6g82T/Ew0tqypPlLiDvzSe1gHuBU3Mt3nA213qVe8WuOfa0CjOk+m9JeksMk7QXJDQwtRc2g+tHN3E095nXlbPvIlwiuJ6gmCkBp6oDdls+2Xo/iQoESEVNEE2n1ARIHenzJvRiFmytUDnOQzM7Hucm3PCoa2UdL2asp/uvrTpf7eqoVR/2E12bLSxXLdMBMqf6yDCY9CvegkrPnNAmLijBE/tOizo5Ws5MpSnSXxeayrphyRxSV+sjOzi+7QfDAfhAXAmhoUqbHXEMvGt700aQ1rK6MdEEyqo6yeg2hEweeUQjt829BJ5Utg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyXc+cvch+FcFZFKzoBvxECsPLaaLsocN0aBh9fEchQ=;
 b=ssn7gIJD1jOmzxJXm1X0F1ZVjkbjtYFf5gVvJ5+7ACihO1++dQR+4IjXP7WgQgfqXSeXvQQkguEl7IRv/Z8SDcE4iF989QKyx6uXAx309+KC1qIqjaWpBYWEqqAUzYryHEJ5eBcbECubnQIXM05Wyr8VnTABIXdUb8lBz7kNjvg=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3371.namprd12.prod.outlook.com (2603:10b6:5:116::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.28; Mon, 23 Nov 2020 16:52:34 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3589.030; Mon, 23 Nov 2020
 16:52:33 +0000
Subject: Re: [PATCH v4 00/34] SEV-ES hypervisor support
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Message-ID: <347c5571-2141-44e5-4650-f63d93fd394f@amd.com>
Date:   Mon, 23 Nov 2020 10:52:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN1PR12CA0080.namprd12.prod.outlook.com
 (2603:10b6:802:21::15) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0080.namprd12.prod.outlook.com (2603:10b6:802:21::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Mon, 23 Nov 2020 16:52:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5c4ffe9-6eb5-4f03-0778-08d88fd02c82
X-MS-TrafficTypeDiagnostic: DM6PR12MB3371:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB33717F6B6EEEFF9FAE301E67ECFC0@DM6PR12MB3371.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PVybtJI1vtsmHiwMb9COO/C8Hmhds97/WlAi5rqV9mxdlBUsRz9d8j2vILHRLzpwZR9hoPZCFSpEWXiNvqwGMy62HNA1eKNtSNs1uPJdOrjA0EPFk06pO6Vt4BNRSmUfLbEoiRI18yqQz3JAq6RnJZOWGsQSjVwt3GSXpxy9SzMNSe+AJ2hI2UEWdg2ilVK9TNvMsap5qB7rffXFG4c9pOw4u9kbij0nChaHEXBOx237WlCKuURxhU+5VarPwc+noJelowVNSq+3TnRIGBdZHepyRh4eM8Tfzv15Wtjnc6i/3qOp7hnE2bek8s51IjMdnomqbmfuchx+YE8uw/41qVPjY2qRFbaUvAEqR2j4SujnKk7BRZbwYEUMs576OiZ6pU/PDjCi89d0rFplZQw65uwwkNpozy6JZRnxmgVwEOhRBkCRMaXGwCsTuA4OADU4kX954V/JwelUB/qYi0ZkBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(4326008)(31686004)(83380400001)(26005)(54906003)(8676002)(5660300002)(966005)(956004)(86362001)(2616005)(31696002)(6512007)(66556008)(186003)(16526019)(36756003)(66476007)(478600001)(66946007)(316002)(6486002)(8936002)(2906002)(7416002)(52116002)(53546011)(6506007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xiY/TRTJNPgpYWqjnhiwe/9uFW4xFd/nGIlU+gsqVFqU/F12bbCrBNwCfxYCIq+jFSHw6vHItVn/iEfKRr6xcvKOVKZmvopWsTIJnz7AYWy1EkZzK7ulJFGQNt+zjbdUpw6UvYVQyPkSQdmS5fnyROG7gbtFNxjHVqx+ke5B1uUJbNxC+TYpJVGVWnN2/c+MZ9JXOXTVz7bbJwN/qy1JMFSYZDLNavl8PrWNIroLTChjPCbcQa6rsyNRo5Tz50fiGo28C+sBINCfzNYk+g89GKJrji3muigHM2X4Ymntkslx1jVs+Ke2VLipHX30K9WiWd62HoC2/VXN//aOB/cAyZAOzuDAZng5k09HvbRLr6ga8iZ6Vts8qIDbnZRXOJFPKFAZKm3UAO1vFYE0CcDg9TcOYCxJX8mU/XABDuT0XwrhaaBCfSz7cIdTJhWUBv/dCwyN0+EjaW68PpBQvPkUm2AAVwCwM3ccEP8ub+LBY5DVz7eLYVgmeq1PjHUXcf7MEZ4hS+h3rN8TuHacx8EX7LTy0E9klB5mniABLMSc76i1r6cFLjThuzBSxac7VPoQ5mNxY9/96Lm751E1Qwrx9vqiSJNsgp1QAejvzQZ88VG6kqXO5mlnP9kBQmybJ/50w0QlxHj4deVwzGbDMd/uaFOgzpi0XnnICxRkREwLaGWu8U66gHQy6Ah+hHTmEIlaPDWnO+UIgtT9s0GkgxwvWxa3ch0mlt1ZBFgnXJO8cb6PGFMSBmIP2N2CWpChK3od+MreWU4cFF6ZPxd3Z2jc7TUWOsZz8AS1AbL0Jd+irX2RpEfUlaHxNDRH8rn2cKL7A54tRI6neYzMyeFBCA08WC3CP/Bw0XG625QQb4gJrOEnyltB+a7s+1+NVPm2TYXaPtjYS5LOhnzwI8zjNKsn9Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c4ffe9-6eb5-4f03-0778-08d88fd02c82
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2020 16:52:33.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3U2TDJDX7hTrWUjJiCUWE1W8vLhTpH2knWuWMmPnRWp4Qn08o63xc/c7xCBeeX4f+fpzpz1gB4c71+Qdq6IWKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3371
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/20 11:07 AM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> This patch series provides support for running SEV-ES guests under KVM.

Any comments on this series?

Thanks,
Tom

> 
> Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
> SEV support to protect the guest register state from the hypervisor. See
> "AMD64 Architecture Programmer's Manual Volume 2: System Programming",
> section "15.35 Encrypted State (SEV-ES)" [1].
> 
> In order to allow a hypervisor to perform functions on behalf of a guest,
> there is architectural support for notifying a guest's operating system
> when certain types of VMEXITs are about to occur. This allows the guest to
> selectively share information with the hypervisor to satisfy the requested
> function. The notification is performed using a new exception, the VMM
> Communication exception (#VC). The information is shared through the
> Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
> The GHCB format and the protocol for using it is documented in "SEV-ES
> Guest-Hypervisor Communication Block Standardization" [2].
> 
> Under SEV-ES, a vCPU save area (VMSA) must be encrypted. SVM is updated to
> build the initial VMSA and then encrypt it before running the guest. Once
> encrypted, it must not be modified by the hypervisor. Modification of the
> VMSA will result in the VMRUN instruction failing with a SHUTDOWN exit
> code. KVM must support the VMGEXIT exit code in order to perform the
> necessary functions required of the guest. The GHCB is used to exchange
> the information needed by both the hypervisor and the guest.
> 
> Register data from the GHCB is copied into the KVM register variables and
> accessed as usual during handling of the exit. Upon return to the guest,
> updated registers are copied back to the GHCB for the guest to act upon.
> 
> There are changes to some of the intercepts that are needed under SEV-ES.
> For example, CR0 writes cannot be intercepted, so the code needs to ensure
> that the intercept is not enabled during execution or that the hypervisor
> does not try to read the register as part of exit processing. Another
> example is shutdown processing, where the vCPU cannot be directly reset.
> 
> Support is added to handle VMGEXIT events and implement the GHCB protocol.
> This includes supporting standard exit events, like a CPUID instruction
> intercept, to new support, for things like AP processor booting. Much of
> the existing SVM intercept support can be re-used by setting the exit
> code information from the VMGEXIT and calling the appropriate intercept
> handlers.
> 
> Finally, to launch and run an SEV-ES guest requires changes to the vCPU
> initialization, loading and execution.
> 
> [1] https://www.amd.com/system/files/TechDocs/24593.pdf
> [2] https://developer.amd.com/wp-content/resources/56421.pdf
> 
> ---
> 
> These patches are based on the KVM next branch:
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git next
> 
> 6d6a18fdde8b ("KVM: selftests: allow two iterations of dirty_log_perf_test")
> 
> A version of the tree can also be found at:
> https://github.com/AMDESE/linux/tree/sev-es-v4
> 
> Changes from v3:
> - Some krobot fixes.
> - Some checkpatch cleanups.
> 
> Changes from v2:
> - Update the freeing of the VMSA page to account for the encrypted memory
>    cache coherency feature as well as the VM page flush feature.
> - Update the GHCB dump function with a bit more detail.
> - Don't check for RAX being present as part of a string IO operation.
> - Include RSI when syncing from GHCB to support KVM hypercall arguments.
> - Add GHCB usage field validation check.
> 
> Changes from v1:
> - Removed the VMSA indirection support:
>    - On LAUNCH_UPDATE_VMSA, sync traditional VMSA over to the new SEV-ES
>      VMSA area to be encrypted.
>    - On VMGEXIT VMEXIT, directly copy valid registers into vCPU arch
>      register array from GHCB. On VMRUN (following a VMGEXIT), directly
>      copy dirty vCPU arch registers to GHCB.
>    - Removed reg_read_override()/reg_write_override() KVM ops.
> - Added VMGEXIT exit-reason validation.
> - Changed kvm_vcpu_arch variable vmsa_encrypted to guest_state_protected
> - Updated the tracking support for EFER/CR0/CR4/CR8 to minimize changes
>    to the x86.c code
> - Updated __set_sregs to not set any register values (previously supported
>    setting the tracked values of EFER/CR0/CR4/CR8)
> - Added support for reporting SMM capability at the VM-level. This allows
>    an SEV-ES guest to indicate SMM is not supported
> - Updated FPU support to check for a guest FPU save area before using it.
>    Updated SVM to free guest FPU for an SEV-ES guest during KVM create_vcpu
>    op.
> - Removed changes to the kvm_skip_emulated_instruction()
> - Added VMSA validity checks before invoking LAUNCH_UPDATE_VMSA
> - Minor code restructuring in areas for better readability
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> 
> Tom Lendacky (34):
>    x86/cpu: Add VM page flush MSR availablility as a CPUID feature
>    KVM: SVM: Remove the call to sev_platform_status() during setup
>    KVM: SVM: Add support for SEV-ES capability in KVM
>    KVM: SVM: Add GHCB accessor functions for retrieving fields
>    KVM: SVM: Add support for the SEV-ES VMSA
>    KVM: x86: Mark GPRs dirty when written
>    KVM: SVM: Add required changes to support intercepts under SEV-ES
>    KVM: SVM: Prevent debugging under SEV-ES
>    KVM: SVM: Do not allow instruction emulation under SEV-ES
>    KVM: SVM: Cannot re-initialize the VMCB after shutdown with SEV-ES
>    KVM: SVM: Prepare for SEV-ES exit handling in the sev.c file
>    KVM: SVM: Add initial support for a VMGEXIT VMEXIT
>    KVM: SVM: Create trace events for VMGEXIT processing
>    KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x002
>    KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x004
>    KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x100
>    KVM: SVM: Create trace events for VMGEXIT MSR protocol processing
>    KVM: SVM: Support MMIO for an SEV-ES guest
>    KVM: SVM: Support string IO operations for an SEV-ES guest
>    KVM: SVM: Add support for EFER write traps for an SEV-ES guest
>    KVM: SVM: Add support for CR0 write traps for an SEV-ES guest
>    KVM: SVM: Add support for CR4 write traps for an SEV-ES guest
>    KVM: SVM: Add support for CR8 write traps for an SEV-ES guest
>    KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES
>    KVM: SVM: Do not report support for SMM for an SEV-ES guest
>    KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest
>    KVM: SVM: Add support for booting APs for an SEV-ES guest
>    KVM: SVM: Add NMI support for an SEV-ES guest
>    KVM: SVM: Set the encryption mask for the SVM host save area
>    KVM: SVM: Update ASID allocation to support SEV-ES guests
>    KVM: SVM: Provide support for SEV-ES vCPU creation/loading
>    KVM: SVM: Provide support for SEV-ES vCPU loading
>    KVM: SVM: Provide an updated VMRUN invocation for SEV-ES guests
>    KVM: SVM: Provide support to launch and run an SEV-ES guest
> 
>   arch/x86/include/asm/cpufeatures.h |   1 +
>   arch/x86/include/asm/kvm_host.h    |  12 +-
>   arch/x86/include/asm/msr-index.h   |   1 +
>   arch/x86/include/asm/svm.h         |  40 +-
>   arch/x86/include/uapi/asm/svm.h    |  28 +
>   arch/x86/kernel/cpu/scattered.c    |   1 +
>   arch/x86/kernel/cpu/vmware.c       |  12 +-
>   arch/x86/kvm/Kconfig               |   3 +-
>   arch/x86/kvm/cpuid.c               |   1 +
>   arch/x86/kvm/kvm_cache_regs.h      |  51 +-
>   arch/x86/kvm/svm/sev.c             | 933 +++++++++++++++++++++++++++--
>   arch/x86/kvm/svm/svm.c             | 442 +++++++++++---
>   arch/x86/kvm/svm/svm.h             | 166 ++++-
>   arch/x86/kvm/svm/vmenter.S         |  50 ++
>   arch/x86/kvm/trace.h               |  97 +++
>   arch/x86/kvm/vmx/vmx.c             |   6 +-
>   arch/x86/kvm/x86.c                 | 368 ++++++++++--
>   arch/x86/kvm/x86.h                 |   9 +
>   18 files changed, 1971 insertions(+), 250 deletions(-)
> 
> 
> base-commit: 6d6a18fdde8b86b919b740ad629153de432d12a8
> 
