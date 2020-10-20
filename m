Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31A0281884
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388208AbgJBRDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:03:19 -0400
Received: from mail-mw2nam10on2070.outbound.protection.outlook.com ([40.107.94.70]:47009
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbgJBRDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:03:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEOlKOpI2NaaFolVRzp1BD+M56dZfXySoABh4UVD7hFf2Fstf6GVGVuaIrQdPFnTbmc0VBRzG/hfRTBh9PkXcuSo7rUEt5FtQ8asPjPIgO1nF2NzHKkVMVOc4fCAhy22yLcFVlY0yU6jq66FbhkYRPmfEHfL6eQ3UFGbXdjjOlgohGJd1W6uUD0yAvjaq84ZO8QFfzPeXapQB0UIHxaKZF3rKo/S2/nGH6lP6eon4QdyK6AGAehDTJPNt9I4Ywc/0XfXydQQNkd19yJSVylIklgzl1/8tkjrGbX44SJuHAmFHu2j5zeeIW6KAylgeYMNwN5eMa/Ji+i2SeXkT64JkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/hFUML1z4GtZgMMRdtKLHjxDcERlIOilWMysLeE7nc=;
 b=US69HKu0gvCSzzQcYVHBzDxxNUbUdcv9oDwnOOc5yLOGPSiX6SX88zrZpOF8iqMzlC3dSif5p6nbJi+xU/0wKe+aFC672bCjHgvZJv+qH/QbZkbrXbXhXxsgdFZfX4YZnxQMwkYg9naENLaWKOsOuq7NrtntTJTeE5SPdDjyv6WppOnk9M4jpKoRX5NjYSUvcGSHOk0FdCq0LJGz8Iv8WcgqKzSMA3D2/fSiU11KazBd1KuNm10zA1y5n2vd6mtCUsRVMiZ+ehehiEk/+LjKxmI7fw60dKo8A3n85x+VXHnoxbUjB5QUp22taOlbTLMmy0ahcE51Uinpgc9Bg4Qu8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/hFUML1z4GtZgMMRdtKLHjxDcERlIOilWMysLeE7nc=;
 b=sBtVvUUHapHPYvIkTLovNWIXoRA5eIexyOdYLp1FPXfPjvhJMGBAF+yPYZBLYbYBMUdHrvkZMvGbQoN6CcIUju2Igrtt7s1UxNx7xOMsIanBWJXL2Q7uNY0UK6fuIekor6AWgEFjy2f2lT8OcfjyWgGSDdAjl11Pz1lD9FNABtE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:03:14 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:03:14 +0000
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
Subject: [RFC PATCH v2 00/33] SEV-ES hypervisor support
Date:   Fri,  2 Oct 2020 12:02:24 -0500
Message-Id: <cover.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0020.namprd04.prod.outlook.com
 (2603:10b6:803:21::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0401CA0020.namprd04.prod.outlook.com (2603:10b6:803:21::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend Transport; Fri, 2 Oct 2020 17:03:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 754e4b59-a84e-4f9e-8145-08d866f50cea
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218CF1C83B27A6A822752FBEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lIn7bRdN67EaOQuTGtx4kzoWGCgZm3t5idNHyUM+irXGokRu2NJHUW/IF2OKaUfNBNejAB3EedZ3lIqxUjbWgnJiGwtkH7YL/imk67eSs7lDNpz7mVmEwxmapW4auREv0ku+pnucuRHV0isu7rPA+nabF0eXa5GhrA6cqJ4O89B72qzUrUNmMurJ3pInUxUdeHexm1+P3mVHCKXfs6JXNIMPbYvYIWsdA1WTjSAA7YNikYZm8Wf0naLSRSRlga43eaYrkRhoQt1Y4o3xZKkV3izW/WvCkYesdKGTcQszeOkN/rXcjyUZkDHoEfsuqrPwDmPu61ywPKAjIotO61WNg31NVhPBUowMhggbT70IsDbX57MljjvF9uB70L09vJG0fPuqombqawIaQt/KOhk4mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(83080400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(966005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 61hu1bcywvcmlcA+Ve9dUGmb/0qQ+bOyFJilV/C1iGhVj7WQCZ4WHy9F2LgpeNsyxEkWK1rzGPOa1mbU2enTH8Tq47zyfCPWmvQoHN2jNcc3C0E/nVqxO/qsNII8rOnHjgWUMnOTA2Z5kpZK2Pxe5xZE6SStjqfHGcEOcKhRzhCe5OcvEz5nhD+3cmrm+MOiXYUJy0p3I9A+2DPL3AeyWMd5t3+yYLcSN3CFx9w+Hmn6dGKNqtyG4RoU6PJ4upxWq1D6j1cDcw8cGI4x0NkdZUZxoMvxrWh2yc1jBF9JnxZDc5yiFSAUAyxWSn6iSznwKeNOsz/NzWZ4RxMN0dNjwRJC/So752/IMqO51LkXdrASb3YPrzgQ1eQb8aZvSZVHQm8K3amSGe8jnW81F+r5lXUbn7rmh9Kh8uneVKUmAtNz3nRHQ1uDOpoqmvDEUVgzbT3yHJSuBSkKD4HWSOSXL1WNNBf1eKCUnbQ5MMo0CNGY8JgCJ0uLAKPJfhivC/c0aGhxVUT+HIZD1DZpm7HxUKxhDTGZEv/dYtYgyGWy7BwO+3bRdE1GABWcPFDzVf1wS5qIl82vTd/HXCme+sznA4CVOc/8DQx/EBkBLc20m/uVnh/kvpEWW1bRXEl0MUQktTtPol6gLHon6FCovimgMw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 754e4b59-a84e-4f9e-8145-08d866f50cea
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:03:14.4320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uq0S5xEJSaFs99+/MlmURlUWTR9h+SHiY4dG9Wo5bduNfGSFffK8mWw1WclTHGsXwq7OgRp8rUKPZc8s3MhsDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
https://github.com/AMDESE/linux/tree/sev-es-5.9-v1

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

Tom Lendacky (33):
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
  KVM: SVM: Support port IO operations for an SEV-ES guest
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

 arch/x86/include/asm/kvm_host.h  |  12 +-
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/include/asm/svm.h       |  40 +-
 arch/x86/include/uapi/asm/svm.h  |  28 ++
 arch/x86/kernel/cpu/vmware.c     |  12 +-
 arch/x86/kvm/Kconfig             |   3 +-
 arch/x86/kvm/cpuid.c             |   1 +
 arch/x86/kvm/kvm_cache_regs.h    |  51 +-
 arch/x86/kvm/svm/sev.c           | 837 +++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c           | 465 +++++++++++++----
 arch/x86/kvm/svm/svm.h           | 165 ++++--
 arch/x86/kvm/svm/vmenter.S       |  50 ++
 arch/x86/kvm/trace.h             |  97 ++++
 arch/x86/kvm/vmx/vmx.c           |   6 +-
 arch/x86/kvm/x86.c               | 364 ++++++++++++--
 arch/x86/kvm/x86.h               |   9 +
 16 files changed, 1892 insertions(+), 249 deletions(-)

-- 
2.28.0

