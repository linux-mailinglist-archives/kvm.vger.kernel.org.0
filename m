Return-Path: <kvm+bounces-1187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B9E7E556B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:25:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA1D61C20E25
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48DE415EAE;
	Wed,  8 Nov 2023 11:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="lpv9ixHt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF73101D2;
	Wed,  8 Nov 2023 11:25:29 +0000 (UTC)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0251FE6;
	Wed,  8 Nov 2023 03:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442729; x=1730978729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pKFAR2whklJOfx0aE2YbJs1djQGs6K3PfD1UPNSSZz8=;
  b=lpv9ixHtv3vsCQrayxp3rZEZ1aMCCZtv2Ex0GTnkf7QGEq+jVR0RVBHD
   Gt5PPp2pBc9vsTotBUFYExN9lLZt7EbH78gjtCU8pSc4kLzPE+s5b7wHC
   +yAhecJ/HG2TTnxJrYXeP0ba+SYcm9xiM7Fv0/64ut0+/NK36E43X2T4F
   Q=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="375132593"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:25:28 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id BAE6980718;
	Wed,  8 Nov 2023 11:25:27 +0000 (UTC)
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:32548]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.45.210:2525] with esmtp (Farcaster)
 id 5bc3b812-def8-49f3-9115-267bad567819; Wed, 8 Nov 2023 11:25:26 +0000 (UTC)
X-Farcaster-Flow-ID: 5bc3b812-def8-49f3-9115-267bad567819
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:25:26 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:25:21 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 33/33] Documentation: KVM: Introduce "Emulating Hyper-V VSM with KVM"
Date: Wed, 8 Nov 2023 11:18:06 +0000
Message-ID: <20231108111806.92604-34-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Introduce "Emulating Hyper-V VSM with KVM", which describes the KVM APIs
made available to a VMM that wants to emulate Hyper-V's VSM.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 .../virt/kvm/x86/emulating-hyperv-vsm.rst     | 136 ++++++++++++++++++
 1 file changed, 136 insertions(+)
 create mode 100644 Documentation/virt/kvm/x86/emulating-hyperv-vsm.rst

diff --git a/Documentation/virt/kvm/x86/emulating-hyperv-vsm.rst b/Documentation/virt/kvm/x86/emulating-hyperv-vsm.rst
new file mode 100644
index 000000000000..8f76bf09c530
--- /dev/null
+++ b/Documentation/virt/kvm/x86/emulating-hyperv-vsm.rst
@@ -0,0 +1,136 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============================
+Emulating Hyper-V VSM with KVM
+==============================
+
+Hyper-V's Virtual Secure Mode (VSM) is a virtualisation security feature
+that leverages the hypervisor to create secure execution environments
+within a guest. VSM is documented as part of Microsoft's Hypervisor Top
+Level Functional Specification[1].
+
+Emulating Hyper-V's Virtual Secure Mode with KVM requires coordination
+between KVM and the VMM. Most of the VSM state and configuration is left
+to be handled by user-space, but some has made its way into KVM. This
+document describes the mechanisms through which a VMM can implement VSM
+support.
+
+Virtual Trust Levels
+--------------------
+
+The main concept VSM introduces are Virtual Trust Levels or VTLs. Each
+VTL is a CPU mode, with its own private CPU architectural state,
+interrupt subsystem (limited to a local APIC), and memory access
+permissions. VTLs are hierarchical, where VTL0 corresponds to normal
+guest execution and VTL > 0 to privileged execution contexts. In
+practice, when virtualising Windows on top of KVM, we only see VTL0 and
+VTL1. Although the spec allows going all the way to VTL15. VTLs are
+orthogonal to ring levels, so each VTL is capable of runnig its own
+operating system and user-space[2].
+
+  ┌──────────────────────────────┐ ┌──────────────────────────────┐
+  │ Normal Mode (VTL0)           │ │ Secure Mode (VTL1)           │
+  │ ┌──────────────────────────┐ │ │ ┌──────────────────────────┐ │
+  │ │   User-mode Processes    │ │ │ │Secure User-mode Processes│ │
+  │ └──────────────────────────┘ │ │ └──────────────────────────┘ │
+  │ ┌──────────────────────────┐ │ │ ┌──────────────────────────┐ │
+  │ │         Kernel           │ │ │ │      Secure Kernel       │ │
+  │ └──────────────────────────┘ │ │ └──────────────────────────┘ │
+  └──────────────────────────────┘ └──────────────────────────────┘
+  ┌───────────────────────────────────────────────────────────────┐
+  │                         Hypervisor/KVM                        │
+  └───────────────────────────────────────────────────────────────┘
+  ┌───────────────────────────────────────────────────────────────┐
+  │                           Hardware                            │
+  └───────────────────────────────────────────────────────────────┘
+
+VTLs break the core assumption that a vCPU has a single architectural
+state, lAPIC state, SynIC state, etc. As such, each VTL is modeled as a
+distinct KVM vCPU, with the restriction that only one is allowed to run
+at any moment in time. Having multiple KVM vCPUs tracking a single guest
+CPU complicates vCPU numbering. VMs that enable VSM are expected to use
+CAP_APIC_ID_GROUPS to segregate vCPUs (and their lAPICs) into different
+groups. For example, a 4 CPU VSM VM will setup the APIC ID groups feature
+so only the first two bits of the APIC ID are exposed to the guest. The
+remaining bits represent the vCPU's VTL. The 'sibling' vCPU to VTL0's
+vCPU2 at VTL3 will have an APIC ID of 0xE. Using this approach a VMM and
+KVM are capable of querying a vCPU's VTL, or finding the vCPU associated
+to a specific VTL.
+
+KVM's lAPIC implementation is aware of groups, and takes note of the
+source vCPU's group when delivering IPIs. As such, it shouldn't be
+possible to target a different VTL through the APIC. Interrupts are
+delivered to the vCPU's lAPIC subsystem regardless of the VTL's runstate,
+this also includes timers. Ultimately, any interrupt incoming from an
+outside source (IOAPIC/MSIs) is routed to VTL0.
+
+Moving Between VTLs
+-------------------
+
+All VSM configuration and VTL handling hypercalls are passed through to
+user-space. Notably the two primitives that allow switching between VTLs.
+All shared state synchronization and KVM vCPU scheduling is left to the
+VMM to manage. For example, upon receiving a VTL call, the VMM stops the
+vCPU that issued the hypercall, and schedules the vCPU corresponding to
+the next privileged VTL. When that privileged vCPU is done executing, it
+issues a VTL return hypercall, so the opposite operation happens. All
+this is transparent to KVM, which limits itself to running vCPUs.
+
+An interrupt directed at a privileged VTL always has precedence over the
+execution of lower VTLs. To honor this, the VMM can monitor events
+targeted at privileged vCPUs with poll(), and should trigger an
+asynchronous VTL switch whenever events become available. Additionally,
+the target VTL's vCPU VP assist overlay page is used to notify the target
+VTL with the reason for the switch. The VMM can keep track of the VP
+assist page by installing an MSR filter for HV_X64_MSR_VP_ASSIST_PAGE.
+
+Hyper-V VP registers
+--------------------
+
+VP register hypercalls are passed through to user-space. All requests can
+be fulfilled either by using already existing KVM state ioctls, or are
+related to VSM's configuration, which is already handled by the VMM. Note
+that HV_REGISTER_VSM_CODE_PAGE_OFFSETS is the only VSM specific VP
+register the kernel controls, as such it is made available through the
+KVM_HV_GET_VSM_STATE ioctl.
+
+Per-VTL Memory Protections
+--------------------------
+
+A privileged VTL can change the memory access restrictions of lower VTLs.
+It does so to hide secrets from them, or to control what they are allowed
+to execute. The list of memory protections allowed is[3]:
+ - No access
+ - Read-only, no execute
+ - Read-only, execute
+ - Read/write, no execute
+ - Read/write, execute
+
+VTL memory protection hypercalls are passed through to user-space, but
+KVM provides an interface that allows changing memory protections on a
+per-VTL basis. This is made possible by the KVM VTL device. VMMs can
+create one per VTL and it exposes a ioctl, KVM_SET_MEMORY_ATTRIBUTES,
+that controls the memory protections applied to that VTL. The KVM TDP MMU
+is VTL aware and page faults are resolved taking into account the
+corresponding VTL device's memory attributes.
+
+When a memory access violates VTL memory protections, KVM issues a secure
+memory intercept, which is passed as a SynIC message into the next
+privileged VTL. This happens transparently for the VMM. Additionally, KVM
+exits with a user-space memory fault. This allows the VMM to stop the
+vCPU while the secure intercept is handled by the privileged VTL. In the
+good case, the instruction that triggered the fault is emulated and
+control is returned to the lower VTL, in the bad case, Windows crashes
+gracefully.
+
+Hyper-V's TLFS also states that DMA should follow VTL0's memory access
+restrictions. This is out of scope for this document, as IOMMU mappings
+are not handled by KVM.
+
+[1] https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/master/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v6.0b.pdf
+
+[2] Conceptually this design is similar to arm's TrustZone: The
+hypervisor plays the role of EL3. Windows (VTL0) runs in Non-Secure
+(EL0/EL1) and the secure kernel (VTL1) in Secure World (EL1s/EL0s).
+
+[3] TLFS 15.9.3
-- 
2.40.1


