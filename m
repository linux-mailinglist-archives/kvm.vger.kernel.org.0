Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E872AC852
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgKIW0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:26:20 -0500
Received: from mail-bn8nam12on2080.outbound.protection.outlook.com ([40.107.237.80]:57211
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729247AbgKIW0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:26:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGbbVc3CPGMVnbMqx9ft43V3ZLG5HIeRiYOQdnInrZTww83Ph5Vpzm1lXe/MN7Q+9ecaTMDjyLOdN66nxUKakjAj8fPwS9BVM5DsVylOmF/oHbnGTks+l9QUvbFszyXaEiqyhKXoMIb79/YDe9u+XlrpkTVydoZN6a64fpFSYFRNEX3X90FAX9fat9ce1YldnCFK0xRTCCIK0ZBjS81iNsAJcyC/U8zC0eQG59d+jDlJTXDJVf6UZxpgoZ0q2VJTDa1piRX6AumnhU8bSPg1GCmnWGyatCJohKuwA1cEguhhxhSgtPVSCxzt3uEwvMWgXPaHCh0flT8N7CMOWrL4Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZecpU8TB8bdxSMlv1o2rDcWT0a3Zsnxf/3ubLg10/4w=;
 b=nEeAsxqmnItn6P27SkY6ClqxZ42oKtjGks0U2dnKVXsytcBgD6CEr6fY5XYZo1Z9rsVbsUMAybq4KImlEILwRR02vtmNMXDxCOFCLNp2XemYnSDSt/Xqn3jh7SkdGhL44P97lPTcjrzcjEqBIn87Da0H4Y7fiXSLYqzpHs/24WzYWMbtQ8AFyj3xpBktYYC36rgJv2QNnuLwHxv+HqVcHNIXdmAuwXEdzvoJo+OU7MtRew1c1gWw9mLoaD2etEJUxL0n+H9lNH7bqrgmsYA/HhCaeQhEwifL4riUuXM4tnnP5Ogt9beYS4YCseXa0ummaXYjmPe8SenwmLBzaxwjaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZecpU8TB8bdxSMlv1o2rDcWT0a3Zsnxf/3ubLg10/4w=;
 b=17x+OhdFhP8XuHyazKlJ+fRdfg3KV44S6lotyTk1G14SWTyRyiU4eV11I08VpERlPNjLux6Npnf/N2rr7/8QRHWInbgZeUF6GdiI47BdkntWpWEeHRTuLwv3xlGCw4Bp+oRzvQP0DYdQ2n/x8X0/Gq9CWw6qM74Ky7UA4VM2lYU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:26:15 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:26:15 +0000
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
Subject: [PATCH v3 00/34] SEV-ES hypervisor support
Date:   Mon,  9 Nov 2020 16:25:26 -0600
Message-Id: <cover.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:3:151::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR19CA0008.namprd19.prod.outlook.com (2603:10b6:3:151::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:26:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23f7b5ca-7478-4ce3-c6a0-08d884fe7892
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40587C7F008979334D15C57BECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CrgWnswjvbztBg0+tCi7F9WF/YBmxkAb1xfkCzDURf53tlMwaE42HQznSS8YJK+cNGC5KT10pB3BG8PVlJZnHuoFP6ARHgu/vUrMbjlb3LyGJ2N8WLweUaRjlumGGBAzhLlFpA4LuMoa6pH1VlQgQ8p1WYvJTFab7jdcASPQ/EwTdF0P5arSFww/m+EPQzLGkcMhAbJ8N6Jm4ySFq+1hZYXU1oz3e5DQ7uhgucEsMi8RxbDWSFXzuCej7Avzz4xXNni39bS6eC7Z2Pe2VxqvQpBLethKaXnnhptlp8kXSxtIS6/ZXv+fzT47m2fgT2rxfwt11CSQIM2xLqaEFzEVc9ZDWELLbrO5aYD/wJbygFm8yD3f656c/mF2PBj9dDW4pOS9fPqHCIbEal6lb6M6kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(966005)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sPS0irrVx+cOzrENJGDPpLZIO0SN6f5ZWPXqvQ7GdbTOKI5NvTz279QLk8fdX0ggvzw/sfHcyuBh9JaiEpDiBGEBESimQ/g6l7opYQptasZ0w9utercQa6VhWPFqlefPoT/d7gZ4BQPm2wTLU6v/MnLMtscrjCBxO5YznaS49cTkTi8F9Yg5jqBrDCR4klxgr9wWoYal8dSFudK84HFH6CBurTu2EmpHRmVEYQk1XN34yumI85KHMrjYz/T/q9qUVqGN+eiCx+xPRJ6DyNV61pQWmQg10KGhUrXTlqpJkbVvVDCZL6QN1+Wmmgwc10QWVgHo6L+FN1XYcTICmBhhcxK60iL1zyKWZBRjMdZWZSIvrUzECOb/ul4KUNE4Z+ntQvRbf5gymynl5QCCUNvSRfSMu4Ww1OHZNDsBu1PLgeqZAxbz2dGCoJpq/XBcczu/PBwDfD9+bRBkMoSyPW8J3PESeHgrGaBYj2k0vr7wZ1dyrYOova+69INiAfhZ5QrsDyNzWuJPYIf/b+65shoylhwFdEUj4IqWSlSclatofAk+7uWVv7eLC4VrcaW5W1+Fva7lfo7HkYgGdqbJwdCUIPB0/VbO7RH/ggC07vA3uVjxqmLA9LsH7tI3k8EJCfhJLM+HujLo0MhsESP7h8kP9Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f7b5ca-7478-4ce3-c6a0-08d884fe7892
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:26:15.3949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7PYm1jawzcUi6HzXMlYwEe7tII3JyjGxmo944h2TtCIiIuGZicXST3ak5j49CqMRPysk7LcdP5AAcBnzDn5ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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

Register data from the GHCB is copied into the KVM register variables and
accessed as usual during handling of the exit. Upon return to the guest,
updated registers are copied back to the GHCB for the guest to act upon.

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

These patches are based on the KVM next branch:
https://git.kernel.org/pub/scm/virt/kvm/kvm.git next

6d6a18fdde8b ("KVM: selftests: allow two iterations of dirty_log_perf_test")

A version of the tree can also be found at:
https://github.com/AMDESE/linux/tree/sev-es-v3

Changes from v2:
- Update the freeing of the VMSA page to account for the encrypted memory
  cache coherency feature as well as the VM page flush feature.
- Update the GHCB dump function with a bit more detail.
- Don't check for RAX being present as part of a string IO operation.
- Include RSI when syncing from GHCB to support KVM hypercall arguments.
- Add GHCB usage field validation check.

Changes from v1:
- Removed the VMSA indirection support:
  - On LAUNCH_UPDATE_VMSA, sync traditional VMSA over to the new SEV-ES
    VMSA area to be encrypted.
  - On VMGEXIT VMEXIT, directly copy valid registers into vCPU arch
    register array from GHCB. On VMRUN (following a VMGEXIT), directly
    copy dirty vCPU arch registers to GHCB.
  - Removed reg_read_override()/reg_write_override() KVM ops.
- Added VMGEXIT exit-reason validation.
- Changed kvm_vcpu_arch variable vmsa_encrypted to guest_state_protected
- Updated the tracking support for EFER/CR0/CR4/CR8 to minimize changes
  to the x86.c code
- Updated __set_sregs to not set any register values (previously supported
  setting the tracked values of EFER/CR0/CR4/CR8)
- Added support for reporting SMM capability at the VM-level. This allows
  an SEV-ES guest to indicate SMM is not supported
- Updated FPU support to check for a guest FPU save area before using it.
  Updated SVM to free guest FPU for an SEV-ES guest during KVM create_vcpu
  op.
- Removed changes to the kvm_skip_emulated_instruction()
- Added VMSA validity checks before invoking LAUNCH_UPDATE_VMSA
- Minor code restructuring in areas for better readability

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

Tom Lendacky (34):
  x86/cpu: Add VM page flush MSR availablility as a CPUID feature
  KVM: SVM: Remove the call to sev_platform_status() during setup
  KVM: SVM: Add support for SEV-ES capability in KVM
  KVM: SVM: Add GHCB accessor functions for retrieving fields
  KVM: SVM: Add support for the SEV-ES VMSA
  KVM: x86: Mark GPRs dirty when written
  KVM: SVM: Add required changes to support intercepts under SEV-ES
  KVM: SVM: Prevent debugging under SEV-ES
  KVM: SVM: Do not allow instruction emulation under SEV-ES
  KVM: SVM: Cannot re-initialize the VMCB after shutdown with SEV-ES
  KVM: SVM: Prepare for SEV-ES exit handling in the sev.c file
  KVM: SVM: Add initial support for a VMGEXIT VMEXIT
  KVM: SVM: Create trace events for VMGEXIT processing
  KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x002
  KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x004
  KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x100
  KVM: SVM: Create trace events for VMGEXIT MSR protocol processing
  KVM: SVM: Support MMIO for an SEV-ES guest
  KVM: SVM: Support string IO operations for an SEV-ES guest
  KVM: SVM: Add support for EFER write traps for an SEV-ES guest
  KVM: SVM: Add support for CR0 write traps for an SEV-ES guest
  KVM: SVM: Add support for CR4 write traps for an SEV-ES guest
  KVM: SVM: Add support for CR8 write traps for an SEV-ES guest
  KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES
  KVM: SVM: Do not report support for SMM for an SEV-ES guest
  KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest
  KVM: SVM: Add support for booting APs for an SEV-ES guest
  KVM: SVM: Add NMI support for an SEV-ES guest
  KVM: SVM: Set the encryption mask for the SVM host save area
  KVM: SVM: Update ASID allocation to support SEV-ES guests
  KVM: SVM: Provide support for SEV-ES vCPU creation/loading
  KVM: SVM: Provide support for SEV-ES vCPU loading
  KVM: SVM: Provide an updated VMRUN invocation for SEV-ES guests
  KVM: SVM: Provide support to launch and run an SEV-ES guest

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm_host.h    |  12 +-
 arch/x86/include/asm/msr-index.h   |   1 +
 arch/x86/include/asm/svm.h         |  40 +-
 arch/x86/include/uapi/asm/svm.h    |  28 +
 arch/x86/kernel/cpu/scattered.c    |   1 +
 arch/x86/kernel/cpu/vmware.c       |  12 +-
 arch/x86/kvm/Kconfig               |   3 +-
 arch/x86/kvm/cpuid.c               |   1 +
 arch/x86/kvm/kvm_cache_regs.h      |  51 +-
 arch/x86/kvm/svm/sev.c             | 929 +++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c             | 442 +++++++++++---
 arch/x86/kvm/svm/svm.h             | 166 +++++-
 arch/x86/kvm/svm/vmenter.S         |  50 ++
 arch/x86/kvm/trace.h               |  97 +++
 arch/x86/kvm/vmx/vmx.c             |   6 +-
 arch/x86/kvm/x86.c                 | 365 ++++++++++--
 arch/x86/kvm/x86.h                 |   9 +
 18 files changed, 1964 insertions(+), 250 deletions(-)

-- 
2.28.0

