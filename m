Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BA42B6B1B
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgKQRH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:07:58 -0500
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:21025
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbgKQRH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:07:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnM7c5BwQ9NyzaeBsykKq9JNZb+SZIdNSWO9sLB8P03BAMUvydDBHhDhmKtFEz/sWCAxQqMOrLmptp7znCzuSOorNbpv2mbKNyInpuhFMVwtAe7qmlniscrYMl2yHp99woA3uPiOsIGxgyT+/6zTrb2o6VMnWhOwnzGv0OW+4q3Xj/hZz3ELxcfV0FS7Gd9ewn0Wzl0BvgbKtUdBxJK/779wLM5u2EIzSOIKlSD3rPf1hS4JoWLDqlsgg/mhw3d5Wr+1JzVFpAm+LCHB3KQAul8zNJ3P+HPfO+Qvuz7MazR783h5Ew7u+Z/2Kg0Lv9Gh3/bXMDptJp82ZVsYosPH6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QPq4P957Lt2TG0Cu4EqSX37L8K2BvOe+zhhY8IKFdeU=;
 b=ilGCNR615ngynEL/umkLI1XnqC+sr/S8vDOA+DbvLyy+iSrwmnMKg4Z39VWSzoWwhEJGvwBOp0oZilsAPljMDFNMPLul/iFTNJGq5L2RpmnO7PQM1ABNeLlIe6TuDpDq45X7SLoL9tTf4AFAGc2dC0QOajwqSxoi379JAYucMLPEio+n+cHadpVsNDxAdh4SFafadH/NT5kjtXzKGOfFDWhe1yDRHqLf70ZCqM6v5tPeDuXohYakJr9swd06jXqY58FwZv57xCSOl6heHGWq6pItv5Mkn4j94au3Dl7yIzeCP3H4Fypjw12ehM/WQu8sogc4uiUa5/IrILL/6VFGsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QPq4P957Lt2TG0Cu4EqSX37L8K2BvOe+zhhY8IKFdeU=;
 b=d/kRYDN1h2/+eVsIRfm0NIoDKLSRtLKt5yfPSeuGdGKei05P4VWbM7Wokl866ALBcaBHZb6vvjygr18t/Z9e/NzQUQ8X0oXl1Y4AIBxWGT7Q2QxKQl3fnrLuNRMWzM246pQN3TFMF/U/vLyXeZx+T9wDUzNAOmYX+sYNCOq6jak=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:07:51 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:07:50 +0000
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
Subject: [PATCH v4 00/34] SEV-ES hypervisor support
Date:   Tue, 17 Nov 2020 11:07:03 -0600
Message-Id: <cover.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR18CA0065.namprd18.prod.outlook.com (2603:10b6:3:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:07:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 236cf3bc-f903-411f-59e3-08d88b1b5086
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17724203438EE1AEBD691846ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fa0pgxhaAvG9LX2hMBLy0Wkdo87cVMgYTRsJDbY6+zOkrtv+wDXdlFQh8aw0lKYItbpqfeSytuQPX/8pwQEFMzqtQDKlRoT5UVAqDPKy6o0LwExw7IkY/dZrGOKPT+GT2w45ohKbT8dyySw/M9WocLTqShtSD6Uz5G2nyx7GPvH65GqWd6f99Q0WiBbHrwgAa0kjvpdsCE8HYZ+r+61u7dK2f8p53G4oXBYBNWuQSw/Mc5pHBBsc2hDLVAJ3AXf3uSvPKQRzWvwuPabUuluEuNPFLYYPJ6TGVtu272Hwi82MbXdQbwh1TYTMQdbtvtmBte0AY/pFUbQmbvzD7rndFdsJSFHpNsoW0/3eIkn3OssL5agm3RoIfFlnWLToQub3xPdmks5CDMlI+6g0KvVZ+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(966005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: v1cQ7quFotwsn0pv+paAmyizKouqKld1XzfeQOQhMXYtoZpiF6Blz3GQOo6GU4ZoJez7Lku8UFJVkU+GciZVi7p40/a8cA8YhzMuzpsh/xJyKjTa4O0y6h1Qvn1IvyzXcqHrZLS0AxQvJsjL1Itrnp+JGEg0wBdSwFmMpOJ2GDN6mFmEqmd3X5aQiepRxbk0EWZuv2tYMKw4dGkm+gMlQ3esitaEkbI97yZNjJdry3H+FvG7/M7/C2DcC5lA3Jt4SI3IAmqVWGKX/+RGGkEb8bg9appj7D4ER5LQmPjsckZWDfXSQlT263pNam1eobSKD1JCdH6/h23cVKGDxKTT4gwpPNv4mswCqTGIHClfgPJCCcAjkNgrUM3oBezo8uAMCnyRcWQVheQbWhebEA2L/SZUxBpGorDG7B8+o9+RdDQyzdL8Bn6UpMnuJO21AEadbkCZpX/SFjbyjxNU5Kd8wD1Z2tzFzUBNYJC0oJ4AAQpq7AZVG+3qzwh2WrsMzkVJ6wA5DCiuSbL7hgeLg+bg9j1A2t9Y1j6W5EIGD/qh9Dw8QE60xgC5P5YMlyOLKiwhBTQbkYQgzyi8QXu4HSXHZs9FC/ypszoWILI9akkO/sO+9FR6pQ0bHDzvk2pIPkFM1QVfCQCzVGufmcWgVkUR5w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 236cf3bc-f903-411f-59e3-08d88b1b5086
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:07:50.6384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/lyJr/JBplWFuAFrlTB4IZfePofFylUeE8WiJXPpA7HrJDpzTPeuvv+PyqnXJHxfbpiQC5H52rdWHk61RTEmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
https://github.com/AMDESE/linux/tree/sev-es-v4

Changes from v3:
- Some krobot fixes.
- Some checkpatch cleanups.

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
 arch/x86/kvm/svm/sev.c             | 933 +++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c             | 442 +++++++++++---
 arch/x86/kvm/svm/svm.h             | 166 ++++-
 arch/x86/kvm/svm/vmenter.S         |  50 ++
 arch/x86/kvm/trace.h               |  97 +++
 arch/x86/kvm/vmx/vmx.c             |   6 +-
 arch/x86/kvm/x86.c                 | 368 ++++++++++--
 arch/x86/kvm/x86.h                 |   9 +
 18 files changed, 1971 insertions(+), 250 deletions(-)


base-commit: 6d6a18fdde8b86b919b740ad629153de432d12a8
-- 
2.28.0

