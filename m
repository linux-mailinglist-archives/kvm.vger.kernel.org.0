Return-Path: <kvm+bounces-31554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 635B89C4EF5
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:54:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3238B21C38
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 06:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C00D20ADCC;
	Tue, 12 Nov 2024 06:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBgRBsF+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578A420A5D0;
	Tue, 12 Nov 2024 06:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731394471; cv=none; b=SH5uu0E//z8d8vEj1epqs6JeuqKnYIz+B7L8QSvPijK99NzcoLO3tKaJDScAWf4tjDJprvFmfu3J7xOQ7fF3Mt21eDDl9dp7LDb11W6HFXAyVN5RhHTEvhlTqM5nyq3LFvu9Il+JBEGYmSZ3wujReubcbRo7rhMYPUuiYaUIIaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731394471; c=relaxed/simple;
	bh=kbIwNgbZcymYi2G1mqtY5ucLa1jgluUy+KbsLIwS+GY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HJxze2W5R1VUsyvwK/KzYH+ZSGBMR+cNjAO7Yo2vKrVp3RGWV3CkD0CDlmbg6DsIOnTAN1J6epDfj2dbHmyXgWEcDYvNeoB1iEP/PFZY7mFHIA+KtjmsKYkIO63Q7X94uLtMHlJ6iXz9MTQ3yGffW/VCtwudYuXO9yjb/eOEGVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBgRBsF+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6341FC4CECD;
	Tue, 12 Nov 2024 06:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731394470;
	bh=kbIwNgbZcymYi2G1mqtY5ucLa1jgluUy+KbsLIwS+GY=;
	h=From:To:Cc:Subject:Date:From;
	b=VBgRBsF+PIoYLpwmI/yzmsWztx4o2CvLGhbxmdiTrxscyF2iK8o8ELZxtX4dJgXsv
	 4N7s86Gi063qakb7dtnVaEyadiGMRhusokoQsCtWNOiI1Ae2Fq6jgvZlJ78WSdJvAX
	 UNzPBjptr9ST2lY2ameLR8sodC/wrONl9MbQwj6k9k3mGsGLQbt8WppDHA2yjK173K
	 l/x8XNDPAxVIFSJehcnradRXhDQA1e+KHRYDvhLOprNDwtDoXHCBehh9nljqzplUQC
	 Kw9Hwddf+YH3lzOIn0x3Mf8q07di+7lbkLLqNo++Ehp7ukjvVlGM1CSUZzPWigLvLY
	 opKJGCOQmzZZw==
From: Arnd Bergmann <arnd@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	kernel test robot <lkp@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Michael Roth <michael.roth@amd.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kvm: add back X86_LOCAL_APIC dependency
Date: Tue, 12 Nov 2024 07:53:59 +0100
Message-Id: <20241112065415.3974321-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Enabling KVM now causes a build failure on x86-32 if X86_LOCAL_APIC
is disabled:

arch/x86/kvm/svm/svm.c: In function 'svm_emergency_disable_virtualization_cpu':
arch/x86/kvm/svm/svm.c:597:9: error: 'kvm_rebooting' undeclared (first use in this function); did you mean 'kvm_irq_routing'?
  597 |         kvm_rebooting = true;
      |         ^~~~~~~~~~~~~
      |         kvm_irq_routing
arch/x86/kvm/svm/svm.c:597:9: note: each undeclared identifier is reported only once for each function it appears in
make[6]: *** [scripts/Makefile.build:221: arch/x86/kvm/svm/svm.o] Error 1
In file included from include/linux/rculist.h:11,
                 from include/linux/hashtable.h:14,
                 from arch/x86/kvm/svm/avic.c:18:
arch/x86/kvm/svm/avic.c: In function 'avic_pi_update_irte':
arch/x86/kvm/svm/avic.c:909:38: error: 'struct kvm' has no member named 'irq_routing'
  909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
      |                                      ^~
include/linux/rcupdate.h:538:17: note: in definition of macro '__rcu_dereference_check'
  538 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \

Move the dependency to the same place as before.

Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410060426.e9Xsnkvi-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Question: is there actually any point in keeping KVM support for 32-bit host
processors? From what I can tell, the only 32-bit CPUs that support this are
the rare Atom E6xx and Z5xx models and the even older Yonah/Sossaman "Core
Duo", everything else is presumably better off just running a 64-bit kernel
even for 32-bit guests?
---
 arch/x86/kvm/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 1ed1e4f5d51c..849a03f3ba95 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 
 config KVM_X86
 	def_tristate KVM if KVM_INTEL || KVM_AMD
-	depends on X86_LOCAL_APIC
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
@@ -93,6 +92,7 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
+	depends on X86_LOCAL_APIC
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
@@ -130,6 +130,7 @@ config X86_SGX_KVM
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
+	depends on X86_LOCAL_APIC
 	help
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
-- 
2.39.5


