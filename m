Return-Path: <kvm+bounces-53682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF32B1557D
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B514A7A4188
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E001DE2BC;
	Tue, 29 Jul 2025 22:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZXsa+UtG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0BB285CBB
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829735; cv=none; b=KGZWmfBr4zja+7XEH6wmmbWq5uAu0iSs9BjocicWCyxdV9rYymlQ6D0MfZto3G0KP8HuVN0yH/vVPJUQ7Fzrg6GpXqE8Agdx+9DY0sE+cw7VuBh52sBsAZDOC6WVRmb3Sf0j9pDPeGuRr81FKWuY0IUQNTp5NsSi2v6jlU8llwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829735; c=relaxed/simple;
	bh=KGm9ovBIIPFL/eToRSLYCEL3qJQ5QwWTWLDQ7V661s8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bPZE7csexlPOoHWRmT+qonfTuJ5DR4tciffK5W7YFvsEC4VHXx+0/Fax37WNBbnFWyvivm2ryqyYsyDIN5MpewpF92Jqg0iupGfGFB9BxVMlC/UEXhsokv67lH5ykg10Gihctrf/Vw9RJtrdippJbD2hR1vtbckokgay0e4+4fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZXsa+UtG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b34abbcdcf3so196944a12.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829733; x=1754434533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OmVLrvkZP9+4Qi6hccAHfp26jMTaOxOppUd09YnTXa4=;
        b=ZXsa+UtGuymLMNS0ox/NIZyKTi4uKxlfZCXSHJFt6lm58Ixx+YOsXM+rlGcYYi4any
         i2+G6yjY7u+TC361CyT45hwgUoP9RzFbDCVHQ0h2fit4MgdcdEd6TlV4uWMsj4mPNXJy
         02w4TWmhxeVSEy0+V8Ah/kz1pXYZkZUvoV7PUopLSFq4zwHYOG7DwiaW9UR+KH8XKpyK
         EQsJLFAzXy8h0DkKzV8tNcdj1mHp2fmC6U89p8ijwqQcMn6g9BF3SRE4tnsx4AMVn/vF
         GQgUuFBhPyRPVzkRvaWwAhqPzSCF0SbI8SC9O2XEJJMZto5dwM4U25HhWbd+uJgDz74y
         hd2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829733; x=1754434533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OmVLrvkZP9+4Qi6hccAHfp26jMTaOxOppUd09YnTXa4=;
        b=K2tvbUtOz/JCs03MtljcQbFhoffqdV4/hGOT+qeFEVnwKpT08RcZenZxLBudepnhBg
         BFixwU3vWmH1GiXFXx1Ua0yRgaoF25CWpUVZbw8uYpxx1Mb722RU2iy3/Jc0djCN2mRQ
         +1DgAwfQS82mlpsO1mXmMnz9myeXArjMfiKVjjG32v1C17DVfUaQnAj/tF/kkyg1OisF
         wyrZeHjxw4z8N2hyPcV3+13iurelnpBPxh6wFdVWodKv3s5SF1U3gpKlwfOxQNvKiWNa
         e5/W3HTAkq6rbNG4RZJZj6chAs3y0fgiNKyr0I2TSh758CjS9eLDrJKhXfYCbLgyqOsd
         /2KQ==
X-Gm-Message-State: AOJu0Yw9xM3yOrzayOeHyMXLTp7SyeXgNpawJKnsiVFh1xbdkrY3k5Kh
	zdMYGg7/LaHFSoB6tOh+vikUP5r3gpG121mc1XeYVVPAYWDt7Cj9tEOPQtP1D2jMUH9mOWNKHmu
	rjdreeg==
X-Google-Smtp-Source: AGHT+IGSrd/EFwxUHSw007+6nrRVXNMPdERz2RNXYrRaT6Ik++IdE/tI3gPpnLHNIaoiETPbklCVAOToMMI=
X-Received: from pjk7.prod.google.com ([2002:a17:90b:5587:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2689:b0:31e:d9f0:9b92
 with SMTP id 98e67ed59e1d1-31f5ddb4545mr1642509a91.14.1753829733349; Tue, 29
 Jul 2025 15:55:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:33 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-3-seanjc@google.com>
Subject: [PATCH v17 02/24] KVM: x86: Have all vendor neutral sub-configs
 depend on KVM_X86, not just KVM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Make all vendor neutral KVM x86 configs depend on KVM_X86, not just KVM,
i.e. gate them on at least one vendor module being enabled and thus on
kvm.ko actually being built.  Depending on just KVM allows the user to
select the configs even though they won't actually take effect, and more
importantly, makes it all too easy to create unmet dependencies.  E.g.
KVM_GENERIC_PRIVATE_MEM can't be selected by KVM_SW_PROTECTED_VM, because
the KVM_GENERIC_MMU_NOTIFIER dependency is select by KVM_X86.

Hiding all sub-configs when neither KVM_AMD nor KVM_INTEL is selected also
helps communicate to the user that nothing "interesting" is going on, e.g.

  --- Virtualization
  <M>   Kernel-based Virtual Machine (KVM) support
  < >   KVM for Intel (and compatible) processors support
  < >   KVM for AMD processors support

Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2c86673155c9..9895fc3cd901 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -74,7 +74,7 @@ config KVM_WERROR
 	# FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
 	# Building KVM with -Werror and KASAN is still doable via enabling
 	# the kernel-wide WERROR=y.
-	depends on KVM && ((EXPERT && !KASAN) || WERROR)
+	depends on KVM_X86 && ((EXPERT && !KASAN) || WERROR)
 	help
 	  Add -Werror to the build flags for KVM.
 
@@ -83,7 +83,7 @@ config KVM_WERROR
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
-	depends on KVM && X86_64
+	depends on KVM_X86 && X86_64
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -169,7 +169,7 @@ config KVM_AMD_SEV
 config KVM_IOAPIC
 	bool "I/O APIC, PIC, and PIT emulation"
 	default y
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides support for KVM to emulate an I/O APIC, PIC, and PIT, i.e.
 	  for full in-kernel APIC emulation.
@@ -179,7 +179,7 @@ config KVM_IOAPIC
 config KVM_SMM
 	bool "System Management Mode emulation"
 	default y
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides support for KVM to emulate System Management Mode (SMM)
 	  in virtual machines.  This can be used by the virtual machine
@@ -189,7 +189,7 @@ config KVM_SMM
 
 config KVM_HYPERV
 	bool "Support for Microsoft Hyper-V emulation"
-	depends on KVM
+	depends on KVM_X86
 	default y
 	help
 	  Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM
@@ -203,7 +203,7 @@ config KVM_HYPERV
 
 config KVM_XEN
 	bool "Support for Xen hypercall interface"
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides KVM support for the hosting Xen HVM guests and
 	  passing Xen hypercalls to userspace.
@@ -213,7 +213,7 @@ config KVM_XEN
 config KVM_PROVE_MMU
 	bool "Prove KVM MMU correctness"
 	depends on DEBUG_KERNEL
-	depends on KVM
+	depends on KVM_X86
 	depends on EXPERT
 	help
 	  Enables runtime assertions in KVM's MMU that are too costly to enable
@@ -228,7 +228,7 @@ config KVM_EXTERNAL_WRITE_TRACKING
 
 config KVM_MAX_NR_VCPUS
 	int "Maximum number of vCPUs per KVM guest"
-	depends on KVM
+	depends on KVM_X86
 	range 1024 4096
 	default 4096 if MAXSMP
 	default 1024
-- 
2.50.1.552.g942d659e1b-goog


