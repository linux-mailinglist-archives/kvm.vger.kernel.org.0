Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32CE269626
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgINUQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:16:11 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725920AbgINUQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsfooNT4d1WaM0poVYWFRpHbUm2Edd9SdWBDZ6k+q5RCfERI8/dAeONA7qgWU0Rl8DfFSlGMIPIGg+9L3Mcwikkr2/5QRDiYJwoZiYxYlZGzXzr2kmbksU62cbKEf2N9cfkQwIQFd03Bp2BwDoeU2OAHfx5/PND8vUG1NskpX19aBMlCKEQ1SDnGBHW0G7UXh1oZMFz2AXKEBa/Nz+H3+P4p+c2CyMHkYoE4JV8q/yWuIP90Kr+DnyWWnZNAlYqGgfdT0Bzc5EJ0gvEVMVbqpzb05ts5WlTzwzdncPM4HKrcwt0SwN2HTOX78dQAj6mbuAxba3ErRVH+M8YuCbhOyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYvn9Vebdcfz1oLEgLq7F1lIAuqBh67EZz7g/n1MHlM=;
 b=GCoo4BlOoePZo+4mbQlOCtHVpNMYWtbA7ni0xCgRVZE3TMFPR1QP54FSMjmRu3xHfnW2I3EpVcJQaCkdpVWbNYPUQR9LxiJuhyb2GILqo9KwKl2CedBTcXkyvhxJoADeptnE8ogjX7csERnqbuzYH1ntZYAEJs6P7D0ALmDn3/aHI1+qLTPIlz1/MV03xYW4ao85Wm3FIYQAlVDaXTDVHzZI0UvTs0/fdQwURB8ZsWuOU2stjgo2nxQCZwGMQ/qCj+QjH4j2og0zzkbdBdwOZlwdMrssL7d+2eaA/P+mfOJZrvHMF2c2iFDS8c6s0Dx9cY67IP/d4oqqFXNV+dDLow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYvn9Vebdcfz1oLEgLq7F1lIAuqBh67EZz7g/n1MHlM=;
 b=bED58Uk4n/I/YkdN+eiN2Eg9j4xr7K4p6TY4YXnJD1iXc0IA8yiV/KNlMeUi0IWwkpBUcCrEf4ANysq7hpmKthFpPWRs7f2IDCbmC7TiJqGFqPLu+/N5Pf3YKfN6BHuhhkBMbo4AcYIM1M+JV/+DUtZuO3pTV1Oj3WlwMJYEK0A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:16:00 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:15:59 +0000
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
Subject: [RFC PATCH 00/35] SEV-ES hypervisor support
Date:   Mon, 14 Sep 2020 15:15:14 -0500
Message-Id: <cover.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:806:d3::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA0PR11CA0030.namprd11.prod.outlook.com (2603:10b6:806:d3::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:15:58 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 219fb91d-e54c-45c4-e70b-08d858eafee8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11633EBF82D967597ED903F3EC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqc2CSoVQijDexCPTorrXOQVSdrB3RmtRtB46alV8cH36WeZxVsQx2roJoukb5jrkaTwLFOoSkXUh8fvyf36Jz3VcFJRWBxH39LIp0idTtxa65MIRaihS85qYb+HWx7MAs/A+ZX5/yBChg5R+ipi/t+R9XRhxKrFrBQ+oyRcQ9eF3zgZ/36B8vR0Q05qaPcLA724aVPILU8wcTwojvp/8MhO3HrIhmg2yFz4V73SvHZmzuTydTZuIv7uoyPcWaTg6Lg1ctTXG/HBfyhJ+MRnOKmg/irg5nSrawBRiR3oGKDMpoVsvc8kx00Cy4W4MdEigjiZ4JKPu09G/Xkx7w79ClHnVrsM961OJbJbbQFhHjE7qTumnRxvoNA0uqocZQYDKZMg/OJYjEd3wzgZlbWQUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(966005)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r24sUbM+9gCDKI0QHR0OXboIvyJa/NhWb/k6UKT17byypa0OG95DOrVFvTEtez/4ZCHgr7fJ5tesIb3y1LuMYqsJoJEPuL0MQGDvgNJVAj+8gc5sUjQw4QX5LYJqUDOjhXST5C8o//gtLhizHemHFhoQXw71C4CXdXlmDhXdCyZ5fXZxq/iwfuhwGc7H90Z+V/fEX1nsnddJYQcjonS1LugbSkp1hMcPW4rfKP3ktrjMHmAWdM6K1Qegjb2b+72x/iSAFm1kdvIGQEeH6gjXjOs17TdsUwdY9zdteta0J1xNGLB2qlOpzj1kqry/eESwmlX9C4DhJpAhPWBTOx9ttSWOs32xKhK9ts6bkKU00lNuOQ1FPhdQ4a3c78x3k3dB1d15Fra6MUWg4f78xjJOX1V8jvNGhN1P6+cyxRR4+WkxbFhnXb8/J/s4ymK9qVJ4VyIyObcov2cmJ3wGGwr6roPk/ykQaNyL7jAYKPoftWuZWrk1hMmfYWOM9nWiVTcZg5IX2VHqEzUu5QGn98F8jH6UijX2YV9x0TfzuFdzfELAv5TrMCfjMTo+25iVJ2vh9qS96hxgUQGPH8ZXEvv5rCxZJOuE99dMV8iPgU9GTcnlr/0QwPiFqNfs17l9yWX8XHgO1k4+VCUgqu9vKpZLEw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 219fb91d-e54c-45c4-e70b-08d858eafee8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:15:59.7162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 81hsqqIqJa4sgQT95Nsr/+hP0anQ1QAUeERsugdNF+5u39KKkRqyltkWP8b+0SpqI3rYYSQek34NkBQzFIvnCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This patch series provides support for running SEV-ES guests under KVM.

Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
SEV support to protect the guest register state from the hypervisor. See
"AMD64 Architecture Programmer's Manual Volume 2: System Programming",
section "15.35 Encrypted State (SEV-ES)" [1].

In order to allow a hypervisor to perform functions on behalf of a guest,
there is architectural support for notifying a guest's operating system
when certain types of VMEXITs are about to occur. This allows the guest to
selectively share information with the hypervisor to satisfy the requested
function. The notification is performed using a new exception, the VMM
Communication exception (#VC). The information is shared through the
Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
The GHCB format and the protocol for using it is documented in "SEV-ES
Guest-Hypervisor Communication Block Standardization" [2].

Under SEV-ES, a vCPU save area (VMSA) must be encrypted. SVM is updated to
build the initial VMSA and then encrypt it before running the guest. Once
encrypted, it must not be modified by the hypervisor. Modification of the
VMSA will result in the VMRUN instruction failing with a SHUTDOWN exit
code. KVM must support the VMGEXIT exit code in order to perform the
necessary functions required of the guest. The GHCB is used to exchange
the information needed by both the hypervisor and the guest.

To simplify access to the VMSA and the GHCB, SVM uses an accessor function
to obtain the address of the either the VMSA or the GHCB, depending on the
stage of execution of the guest.

There are changes to some of the intercepts that are needed under SEV-ES.
For example, CR0 writes cannot be intercepted, so the code needs to ensure
that the intercept is not enabled during execution or that the hypervisor
does not try to read the register as part of exit processing. Another
example is shutdown processing, where the vCPU cannot be directly reset.

Support is added to handle VMGEXIT events and implement the GHCB protocol.
This includes supporting standard exit events, like a CPUID instruction
intercept, to new support, for things like AP processor booting. Much of
the existing SVM intercept support can be re-used by setting the exit
code information from the VMGEXIT and calling the appropriate intercept
handlers.

Finally, to launch and run an SEV-ES guest requires changes to the vCPU
initialization, loading and execution.

[1] https://www.amd.com/system/files/TechDocs/24593.pdf
[2] https://developer.amd.com/wp-content/resources/56421.pdf

---

These patches are based on a commit of the KVM next branch. However, I had
to backport recent SEV-ES guest patches (a previous series to the actual
patches that are now in the tip tree) into my development branch, since
there are prereq patches needed by this series. As a result, this patch
series will not successfully build or apply to the KVM next branch as is.

A version of the tree can be found at:
https://github.com/AMDESE/linux/tree/sev-es-5.8-v3

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>

Tom Lendacky (35):
  KVM: SVM: Remove the call to sev_platform_status() during setup
  KVM: SVM: Add support for SEV-ES capability in KVM
  KVM: SVM: Add indirect access to the VM save area
  KVM: SVM: Make GHCB accessor functions available to the hypervisor
  KVM: SVM: Add initial support for SEV-ES GHCB access to KVM
  KVM: SVM: Add required changes to support intercepts under SEV-ES
  KVM: SVM: Modify DRx register intercepts for an SEV-ES guest
  KVM: SVM: Prevent debugging under SEV-ES
  KVM: SVM: Do not emulate MMIO under SEV-ES
  KVM: SVM: Cannot re-initialize the VMCB after shutdown with SEV-ES
  KVM: SVM: Prepare for SEV-ES exit handling in the sev.c file
  KVM: SVM: Add initial support for a VMGEXIT VMEXIT
  KVM: SVM: Create trace events for VMGEXIT processing
  KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x002
  KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x004
  KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x100
  KVM: SVM: Create trace events for VMGEXIT MSR protocol processing
  KVM: SVM: Support MMIO for an SEV-ES guest
  KVM: SVM: Support port IO operations for an SEV-ES guest
  KVM: SVM: Add SEV/SEV-ES support for intercepting INVD
  KVM: SVM: Add support for EFER write traps for an SEV-ES guest
  KVM: SVM: Add support for CR0 write traps for an SEV-ES guest
  KVM: SVM: Add support for CR4 write traps for an SEV-ES guest
  KVM: SVM: Add support for CR8 write traps for an SEV-ES guest
  KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES
  KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest
  KVM: SVM: Add support for booting APs for an SEV-ES guest
  KVM: X86: Update kvm_skip_emulated_instruction() for an SEV-ES guest
  KVM: SVM: Add NMI support for an SEV-ES guest
  KVM: SVM: Set the encryption mask for the SVM host save area
  KVM: SVM: Update ASID allocation to support SEV-ES guests
  KVM: SVM: Provide support for SEV-ES vCPU creation/loading
  KVM: SVM: Provide support for SEV-ES vCPU loading
  KVM: SVM: Provide an updated VMRUN invocation for SEV-ES guests
  KVM: SVM: Provide support to launch and run an SEV-ES guest

 arch/x86/include/asm/kvm_host.h  |  16 +
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/include/asm/svm.h       |  35 +-
 arch/x86/include/uapi/asm/svm.h  |  28 ++
 arch/x86/kernel/cpu/vmware.c     |  12 +-
 arch/x86/kvm/Kconfig             |   3 +-
 arch/x86/kvm/cpuid.c             |   1 +
 arch/x86/kvm/kvm_cache_regs.h    |  30 +-
 arch/x86/kvm/mmu/mmu.c           |   7 +
 arch/x86/kvm/svm/nested.c        | 125 +++---
 arch/x86/kvm/svm/sev.c           | 590 ++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c           | 704 ++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h           | 357 ++++++++++++++--
 arch/x86/kvm/svm/vmenter.S       |  50 +++
 arch/x86/kvm/trace.h             |  99 +++++
 arch/x86/kvm/vmx/vmx.c           |   7 +
 arch/x86/kvm/x86.c               | 357 ++++++++++++++--
 arch/x86/kvm/x86.h               |   8 +
 18 files changed, 2070 insertions(+), 360 deletions(-)

-- 
2.28.0

