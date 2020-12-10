Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C4A2D630A
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392477AbgLJRIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:08:34 -0500
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:38097
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392453AbgLJRIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:08:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQrniI5wkHDUSp2gGCi1sq0E9pAG8JeiXsZDnKmJlGWoJGx7B9oCze4xzJ9t6iLnnoo17Vo5OOF1dpPksLHL8Gq3B3C1hm6cSuMoIC35oH5GrfB3Mbe2xlNktTjI7tT3yuuvvtwX7Kfdgo82cI77FkFN1G5GpKdDb5qK0xBgkJ/erIjuJa9LoB1aNrmsZHVcmzE4FvvsJqw08iCtNmkSmp17WyQ/upcb4wIIzXx8SubYW+Ehe9oJtu5DZO8wmfjiBRmUElJQFH45+WTU6hIAx1f7z66cemFGdtMJvMBO5W2Ch7lAT7bPpSqecymUr1h/u6OtFthoV8v+wxPVpJBS+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/DvzQL9xKzyTXbZYKjvi8n7XHaRooTRZc8KiicSfMk=;
 b=HEx9jwOfssW6Ol6jZ3DEX9OZwHdiUWJxovkYFNzVSiZSmUqRmuqOOSvp7l7miQNlyG4Lqs1tATYO11CvFenIWHei9hB/4hBMZIIyp1Dqz/NhnuBwbVdHOcfNKUMEiR/gYEikK5JV4SL424ETOrWold8LYHPZiO2eu6YIXXbsyjAwWMVKu+F2cbNt6+YufX/Kk8ZQanrk7Nj7VE5W/zWa+5tCAfhiPG0UoPm4g9ZwszndcvkJ0k2KVexrlr9ANEG3KDbm0+mQDECG2peYSdCNTxsf8dzuiv5UkDz10ULI1V/UoB1yXe4pZbejTf/i5Gc2NcKnLiOzTMPkyZuh+T4DyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/DvzQL9xKzyTXbZYKjvi8n7XHaRooTRZc8KiicSfMk=;
 b=3VDqiisRQZSohjJsIhdfpjAAmdDcddDmWXybZ4A9YfxIEjdn7nuA+FQcpBu/o7itB9dJMV5EyqzRogJ9Tt1BLAlG3gTs1vfHfpGSTz/1O2l/bmdUQThAuVB2mrHb5I/7HNZ7kKtXHyf1+LDRcPxm4lX3/8Liuf9NIevxD6RevgE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1493.namprd12.prod.outlook.com (2603:10b6:910:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:07:34 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:07:34 +0000
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
Subject: [PATCH v5 00/34] SEV-ES hypervisor support
Date:   Thu, 10 Dec 2020 11:06:44 -0600
Message-Id: <cover.1607620037.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:610:b0::7) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH0PR03CA0002.namprd03.prod.outlook.com (2603:10b6:610:b0::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:07:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 98aad429-7c2f-4a96-6c06-08d89d2e166f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1493660C2358559FA8C1D596ECCB0@CY4PR12MB1493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LLERGHvM9ZExwdXp+I4HubkiwtLmjd5QlaWuRrRkLO19Or5S28qKhNaKqxMQ0+eLP3ThyW1UMqI0Yy2lce7p1vAOGD8DGpvkQDuJNHvcyiP46AayBxoIsNbyn+pN165WsGej2hgwFnLXvwlImxsc8j8ABE4D+jTW5EH58LZvZnHCdsQ1hoz6hJ6yBmk/uYY9YN/XSbedWrm05365lxeeqiX9bUd/1iTPWEMPBnSUFytnFsZz2vNqFum92IzDUDebxXr1apLVI2OZdYeNHSFcZ31rv3fa7DV5RqNEB48jlvgNMrUargOP9nAGXkhK8smjJ7UXth1upHhwYyy9wFPAUrTK6WxOoNFwayDfS28XO8ZmwXsUSSeHBM+OuNrDd4En8EcPssqA1euxH6h0OAr1cH1tklRgdIH7Qw9mHvpIdRuYn35GeYBFNnav1beK6ZEiGblTlzCrZz63ysM+K7UovA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(34490700003)(508600001)(7416002)(26005)(956004)(6486002)(2616005)(54906003)(7696005)(83380400001)(16526019)(66946007)(966005)(8936002)(186003)(52116002)(5660300002)(66476007)(8676002)(36756003)(86362001)(4326008)(6666004)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9tS0+3cs7vc1LNHkpGgwrZTt9MYe9s++5Wm2yadtu//lWbcmjR2hK1NZkcfD?=
 =?us-ascii?Q?Zpx76CYLbsxwsSHI9z9syv0A7BNNz0kJEbT9bY8s2teezClEymSpdmpv8c4g?=
 =?us-ascii?Q?giolyqHXuFVV98wbFqbQaDwGx06a18J2rf7cQKf2ZqkTvK3yO2ptV6TMgojv?=
 =?us-ascii?Q?Iysrj8JR6xAhAerNVlZy6cV4KOMb5EIEp0gbNt9hnyhKwqvI5J1WwPjEzM8S?=
 =?us-ascii?Q?1Tee2PYue7mcs3kh9uDpaTtFGiDPhATl6kOCSZ5Iqd+llB2VwBlGoSy0ebit?=
 =?us-ascii?Q?iYdIN7+7MX029QF6E3sTgAq1iXTQa7izNRZRBrlxi+XGAyhAFmPo41xfHHPU?=
 =?us-ascii?Q?aIeUu8WRnt+EErq2HaK5i6eTZkreAM3NkqtwOt1rkLza5EvIMm8zMl/VMmoZ?=
 =?us-ascii?Q?7oZ932oXx1nnGWkH4fIwChwl7KYYucS1/H5UcWY3OT6tD2b8NGDoJyKNJU7I?=
 =?us-ascii?Q?lcV5vlxh+VbmK4wxH3mqk0hpbIe+G7X5gIpHvMGj9HWbP6tlByyCLZZvMTpQ?=
 =?us-ascii?Q?5p7NuYI+NocjkR3w5JUU9aMs5FHj/i8FUG0I7CsGt/oTBOtmw8qcW9zVbwFm?=
 =?us-ascii?Q?FnWzsALbyXB3LWpD0nZonSJwtWhHvxIohmki5n18TBYLlZYyXmX774KbMbyw?=
 =?us-ascii?Q?4sHa/TfUHJnnZJoOmHegfl+l7O8LwBBVv1sVc3b27PiuQnm+Fgc6bhcdK8Zc?=
 =?us-ascii?Q?F5T0ZmNZyQjEpvkJxNMpbWJ4k1yBHfpRA/mh5WwM3HeC6CgYwkeMzk29F6+R?=
 =?us-ascii?Q?WkSwI2Q4tMAmHb9KJCKFX6ni0Dx05I5Ud3USQJMA4ORuouYtLlA0LlmRqFpw?=
 =?us-ascii?Q?NkIS2c6Bz14Xe9KGxB9DGgUigGUDzVr3W77liEChNemQB+3laZxjtwNslVoA?=
 =?us-ascii?Q?v5PHdPj/k2JqeKkVj123esiMSPGuLHcmouUJbr1OiBhytLAwD5uwQfLNOmfG?=
 =?us-ascii?Q?UkHdL8RoLQeJx/3h/v66C7NmOcZSN8+ovl+XN1XRshIVkXNMkM0qaQmqpLhI?=
 =?us-ascii?Q?+gTH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:07:34.2742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 98aad429-7c2f-4a96-6c06-08d89d2e166f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crrh3Iamfq9Azl3J9VNBBtaZFS5/Zllp33FB2TZ3kDlWjH2EVwDUIS8hijtV7kUNX0qbGV/NutHb2mBGsi+6hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1493
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

These patches are based on the KVM queue branch:
https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue

dc924b062488 ("KVM: SVM: check CR4 changes against vcpu->arch")

A version of the tree can also be found at:
https://github.com/AMDESE/linux/tree/sev-es-v5
 This tree has one addition patch that is not yet part of the queue
 tree that is required to run any SEV guest:
 [PATCH] KVM: x86: adjust SEV for commit 7e8e6eed75e
 https://lore.kernel.org/kvm/20201130143959.3636394-1-pbonzini@redhat.com/

Changes from v4:
- Updated the tracking support for CR0/CR4

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
 arch/x86/kvm/kvm_cache_regs.h      |  51 +-
 arch/x86/kvm/svm/sev.c             | 933 +++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c             | 446 +++++++++++---
 arch/x86/kvm/svm/svm.h             | 166 ++++-
 arch/x86/kvm/svm/vmenter.S         |  50 ++
 arch/x86/kvm/trace.h               |  97 +++
 arch/x86/kvm/vmx/vmx.c             |   6 +-
 arch/x86/kvm/x86.c                 | 344 +++++++++--
 arch/x86/kvm/x86.h                 |   9 +
 17 files changed, 1962 insertions(+), 238 deletions(-)


base-commit: dc924b062488a0376aae41d3e0a27dc99f852a5e
-- 
2.28.0

