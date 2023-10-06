Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADDB7BC0C4
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 22:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbjJFUyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 16:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbjJFUyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 16:54:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E42C5;
        Fri,  6 Oct 2023 13:54:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627F1C433C8;
        Fri,  6 Oct 2023 20:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696625661;
        bh=77r2KlFSGk08tldlnpzfUf4EEwr9qqvQObU5pu1mnrk=;
        h=From:To:Cc:Subject:Date:From;
        b=Ie2I9q4KGZOQto+yPy3NESQH0JBbLtjMYIBZAUiqQdnvk/pUCXfGUCf1Ar/XJcuKx
         cEMfcFvCNf3TYZ6zHh7IKg4fG4/zf4mtFFTgswyyUdrn1zzxcJNQyJHuqKYfL07aA1
         F80pJZEOYyW5DoeJb1jBg6UjC1WTk7gBnPxv2Q/2ogfQ8fr1d7TxVlvIMTUMPUT5Iu
         T8A/8IYtsJMjWjjixGqC8ihuT2Ny7gxUMRwx8JI+oyEsprv9B1ODteKGFQ+DQ0tO/l
         P7y6s80Q+uTwwjE40APs4KceuL2rzXtlwsJd9b2xYbzjWvlKpQuZaKth86QFexk3MQ
         6uLvW81I/jbSg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, workflows@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] KVM: deprecate KVM_WERROR in favor of general WERROR
Date:   Fri,  6 Oct 2023 13:54:15 -0700
Message-ID: <20231006205415.3501535-1-kuba@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Setting WERROR for random subsystems make life really hard
for subsystems which want to build-test their stuff with W=1.
WERROR for the entire kernel now exists and can be used
instead. W=1 people probably know how to deal with the global
W=1 already, tracking all per-subsystem WERRORs is too much...

Link: https://lore.kernel.org/all/0da9874b6e9fcbaaa5edeb345d7e2a7c859fc818.1696271334.git.thomas.lendacky@amd.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/process/maintainer-kvm-x86.rst |  2 +-
 arch/x86/kvm/Kconfig                         | 14 --------------
 arch/x86/kvm/Makefile                        |  1 -
 3 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/Documentation/process/maintainer-kvm-x86.rst b/Documentation/process/maintainer-kvm-x86.rst
index 9183bd449762..cd70c0351108 100644
--- a/Documentation/process/maintainer-kvm-x86.rst
+++ b/Documentation/process/maintainer-kvm-x86.rst
@@ -243,7 +243,7 @@ context and disambiguate the reference.
 Testing
 -------
 At a bare minimum, *all* patches in a series must build cleanly for KVM_INTEL=m
-KVM_AMD=m, and KVM_WERROR=y.  Building every possible combination of Kconfigs
+KVM_AMD=m, and WERROR=y.  Building every possible combination of Kconfigs
 isn't feasible, but the more the merrier.  KVM_SMM, KVM_XEN, PROVE_LOCKING, and
 X86_64 are particularly interesting knobs to turn.
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ed90f148140d..12929324ac3e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -63,20 +63,6 @@ config KVM
 
 	  If unsure, say N.
 
-config KVM_WERROR
-	bool "Compile KVM with -Werror"
-	# KASAN may cause the build to fail due to larger frames
-	default y if X86_64 && !KASAN
-	# We use the dependency on !COMPILE_TEST to not be enabled
-	# blindly in allmodconfig or allyesconfig configurations
-	depends on KVM
-	depends on (X86_64 && !KASAN) || !COMPILE_TEST
-	depends on EXPERT
-	help
-	  Add -Werror to the build flags for KVM.
-
-	  If in doubt, say "N".
-
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..8e6afde7c680 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ccflags-y += -I $(srctree)/arch/x86/kvm
-ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
 ifeq ($(CONFIG_FRAME_POINTER),y)
 OBJECT_FILES_NON_STANDARD_vmenter.o := y
-- 
2.41.0

