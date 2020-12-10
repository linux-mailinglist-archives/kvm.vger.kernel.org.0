Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED252D6477
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392575AbgLJRLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:11:17 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:37494
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392493AbgLJRLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:11:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ml5ny42DvJmYfJmV5VdrSlL1suoYjkCCiuP0INDLUOSn9ynj74Uh2CE4qPnCFG8lFISx0y6xTzLVgMQYWQ58VzX4BCcDrQrZQm/YFP2eT7pgmZwdx4O3+8xeP1voS10xdHXmpdlUnrQEAU9dkDj63uH5bl9kZTwwy5LA1GY8yxxzkQo+gY3mtdpv8w1clNAH86d5v+a/uzde6iEM/vPTex+A6q6A9Ka8TjKU8zpQWqY14f3EgBGw7qIBAiim3gSlOXmaskAl15xK/IpR13YS2Os2WO0RcuT+6a/7ibjBgjELOrCiDK3y5J258I6ryp5JDN8VPfe5Vdh4rX0ATZqUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/DvzQL9xKzyTXbZYKjvi8n7XHaRooTRZc8KiicSfMk=;
 b=PkHbTBkn7Wmurwta4YpdW5zz3+eH3R5P3n/5jD5pvFVi2kqQykDXHQfJgLmPDdyv+Kyqx8+Yimpd/Jdt775P2CPyNqHXZd82omMAnLO0XVDTPT5zf9cWvZwUi3Ec9dZO0l+j7nVcpXE/6GAWkCjd2DPk0SzZ11ZmGloRJxMMGYCyHPYznePWkr76XqoAGwyLRV0QAsTI8+6xGkPzEtYV8CgjErG/Ny/7jshrMP3/TAj8ZIWXK+DW2GcP2tGuY6Ioj0qoSLOs3aJxB1UlK2YTCMI2b+74XQLgCv5bG+9oYy8/nkm7Cwtz0LtPdyAqCUuSGeGokBURRZaAoO7jJiADNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/DvzQL9xKzyTXbZYKjvi8n7XHaRooTRZc8KiicSfMk=;
 b=k8zyidoqk3Da59srDb3AuzuPYCjOQTN8nzYjZUy9CxV+XE/d1pGmJrab4I0Fn7nnWbNTC860dfP7V4MrwicVl5rZKavvm6rkYUHPclF3qcqFDNpUx/SH0jUcUYeqIBKvGdtLnTWiICxrtGXrALdH/YKu/wyDZQj/si9Eu0K5sSY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0168.namprd12.prod.outlook.com (2603:10b6:910:1d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Thu, 10 Dec
 2020 17:10:17 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:10:17 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v5 00/34] SEV-ES hypervisor support
Date:   Thu, 10 Dec 2020 11:09:35 -0600
Message-Id: <cover.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:610:76::26) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH0PR04CA0021.namprd04.prod.outlook.com (2603:10b6:610:76::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:10:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9866072-873b-4415-6ffb-08d89d2e77c0
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB016863C27047549C41B29B1DECCB0@CY4PR1201MB0168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMf3R6//vSHxSn62G/fd0pcuJeRv2Mhi7bX0noA/oGepm10ZRCLwCKqi8maKbmEl3yZHrGVxOMmzGjDQifP7qflne0EImLS8hNX+a0xEKVla7KncL3VA3+F0wSl9iXHE2jpus8K0u8nkrLHqYDeFhuOXHCIFLuxZ9Icr4ZKwx7TFQWtsKXfdF2hySMJKjzXKFdYSYyayeiI1FBLR86+ehkKaYtyKgwqaJUE3jkTTrVtzwkYVe2J98QNGWESrqWrSFZaJhTCe6W19apiedMGZ4iv/sGCnWKJvr8j17zKa63a+Haqe2duJaGJeyKGFWp7J8og84QvvUK6n0XtaAX1KRl04tVBZfPN6mamaxzjZh899kEm2xkR/vP9WwryZiH0kRf7xoJO+mEjRlz8o3U2ZTwghFEZoQfk4Iw9HznhxbUtBBPYijBSlsLSOOMmsj5rIWd9zspPfEztvBgTss2cnBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(36756003)(8676002)(6486002)(4326008)(66476007)(86362001)(7416002)(66946007)(7696005)(54906003)(6666004)(26005)(16526019)(34490700003)(66556008)(8936002)(83380400001)(966005)(186003)(2906002)(2616005)(52116002)(956004)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jZtloFjBhIhNgk15jS037ybZYay4E2M65Os1ANL6lbsjmxj2EhfKGFuoItI/?=
 =?us-ascii?Q?EIVw/hcqQJWim3+rZN2yicDeybKeRlrPS8WpvwXsUSZlC8NVJJw6PtFNcaP4?=
 =?us-ascii?Q?tMC9xHY8/YRyaiqdN00/xwM3Hjpc27Oh4zZDuXpMK3VzWNIroWBgNz2jGuvB?=
 =?us-ascii?Q?jrZkYYndAUXgTTBloQ6MkT0HPVcwm6ZlGLMx4SzlvIZ7JW4hubdnCZkwtF2q?=
 =?us-ascii?Q?QQRR7l4/pahPKI9+cJDbCB+r5l+MXjqZVABAYmvMd0pMXTTOZ78qJbp80Y5f?=
 =?us-ascii?Q?dBkXh8q3YeGuJIgg+kl4H8o/5JzXRfNWnyhyRY5yV+Qd0XOXVIwc7PHS8+TE?=
 =?us-ascii?Q?JSALgQmb/nFhloT750ZOdFzYL5Ra1JI811FduXAyMvRF8UudIAMrqwb50fY9?=
 =?us-ascii?Q?eQhnZMjOEW5w/Uh0J68zq7n+y8i4QoO0sTAAmSzKuo/IR48ez26Y0coGjdiQ?=
 =?us-ascii?Q?5Py+MMhGtFfnkTes5aTdwT+Gp530oeOvshToCa8Xeo7719t4dn4tvXK/2DpT?=
 =?us-ascii?Q?dLaJBp9qZUDkY5hOgDj5S9gIAkTSpL2apWSr7u8Xvczfv8SDXMWYsP3nrGGW?=
 =?us-ascii?Q?VKWBRDWfbg+sLp3LwL5N3X+C+iXwDC4qT0LTeKmledQdqwbQ5JvJ9fdLE8Mv?=
 =?us-ascii?Q?LmT9m/uBY/FQ/sSSoCwL/6Euzyt+TFNLf3UscpgcrrE1pupynnAIsGtui/CO?=
 =?us-ascii?Q?Rv1VhH1fKfEef8VQ5qfXPEbokY76SMTvZ9MxrU92kNtWKl+2tEksXw5lHcAH?=
 =?us-ascii?Q?SwS5JQti3EDq1u2lTKSXP0DVv0ivuAWA73bMsMAMDk7C2RUO/yckMbAKgrJP?=
 =?us-ascii?Q?XvhRqGEJh95uipuDk6s1hoXaKrohpdU1Mh277rnDng9dQe8jri2XXFMtqttS?=
 =?us-ascii?Q?BQUrQX5LxGwpZyqIrEV9zrHN+zIEQ63/bf9MWMVptmkpppQVoX3rU4KuWhKB?=
 =?us-ascii?Q?/fVn721aX0aCpj8004B/Mh/jsp5JEsv/GxfQHKmx2VT2s1d1T47t3uwd65n4?=
 =?us-ascii?Q?kUQg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:10:17.5432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: a9866072-873b-4415-6ffb-08d89d2e77c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdGcQu06biRhMXdx+YW3a70Hs3Mi1u3R+izdJRIh7nD5PCpMgDO13KnzFThSmGy8fSoKEcEQwdLvK9H2DDBXxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0168
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

