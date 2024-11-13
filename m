Return-Path: <kvm+bounces-31773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB2139C79C5
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 18:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E72F6B385CD
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B8A148828;
	Wed, 13 Nov 2024 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qhh5aAa4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50C57083B;
	Wed, 13 Nov 2024 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731513290; cv=none; b=USyeV7+zn4vumAzvZC68yrFpNxiTwXQD8CkM+6yhf3+4d2kB/268d7D33b2efJpiSm5BzbNZt2sR0Dc9JRChaKeHhsT0ivIVotFDdwD9vZtBUps2+1jnBYM3vl3wk52nui9eBUXaZNkFk6q1I87RaGqMUbEpP1NBiCcVqpva8Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731513290; c=relaxed/simple;
	bh=pyVSoto7EgHVHubfrt9+zqMhvoXUPkIR6CjWMi2lGS8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L9MOBaVMCJSFDMUkoN8txFbGmR1m9IwUzrn17DouexMy/eBoBHEC8qmjjOgsAxs7Mcl4BHVK7ZLgbz1N+1U86o/GZgkuvaTPWU5d4duHA13dAz9BB3vL7LHsKZpNuJPnvpro/fOWwDmrCwvpd7d+xepTyvFC2xwhl5AkI8q57Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qhh5aAa4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732D6C4CEC3;
	Wed, 13 Nov 2024 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731513290;
	bh=pyVSoto7EgHVHubfrt9+zqMhvoXUPkIR6CjWMi2lGS8=;
	h=From:To:Cc:Subject:Date:From;
	b=qhh5aAa4ZvMil6qFjRNcbPk4GYRdhRdR/QuZ2UQhQp7zA1FL0EX7rRnO+4N8PO5hZ
	 0vjLLsdy+acA9LeJaY0VG5tcvnLYr4a23x4kde/ACbpSTncUMOTqsYb0JoSgpMAYX5
	 ++uL8h0Ad+eX71FEICJ6gaGteABEXPj89p8D8g3/gIDHZzbrjMvIriiW0IQ6L3bpwk
	 g3qlVdqzCkAmf1KpO3RRKaSVTX5w+l5/ZN4xY/+qycIp67YhAH8t4xpWVNVZH304AH
	 hMzahtrBdI+nDgEswdMJNGooN8r3+g9P3sxYuyGzZG0Xzb2nF1Z3d1SEwRbj1V1i7x
	 EPM1xErhNQRGA==
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
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] x86: kvm: add back X86_LOCAL_APIC dependency
Date: Wed, 13 Nov 2024 16:53:48 +0100
Message-Id: <20241113155444.2355893-1-arnd@kernel.org>
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
[v2] move the depdendency again, to CONFIG_KVM
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 1ed1e4f5d51c..d79e907b8e77 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 
 config KVM_X86
 	def_tristate KVM if KVM_INTEL || KVM_AMD
-	depends on X86_LOCAL_APIC
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
@@ -50,6 +49,7 @@ config KVM_X86
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on X86_LOCAL_APIC
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
-- 
2.39.5


