Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18919C1189
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 19:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbfI1RX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 13:23:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbfI1RX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 13:23:26 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 13F39898104;
        Sat, 28 Sep 2019 17:23:26 +0000 (UTC)
Received: from mail (ovpn-125-159.rdu2.redhat.com [10.10.125.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4839260C4B;
        Sat, 28 Sep 2019 17:23:24 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 02/14] KVM: monolithic: x86: disable linking vmx and svm at the same time into the kernel
Date:   Sat, 28 Sep 2019 13:23:11 -0400
Message-Id: <20190928172323.14663-3-aarcange@redhat.com>
In-Reply-To: <20190928172323.14663-1-aarcange@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Sat, 28 Sep 2019 17:23:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linking both vmx and svm into the kernel at the same time isn't
possible anymore or the kvm_x86/kvm_x86_pmu external function names
would collide.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/Kconfig | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 840e12583b85..e1601c54355e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -59,9 +59,29 @@ config KVM
 
 	  If unsure, say N.
 
+if KVM=y
+
+choice
+	prompt "To link KVM statically into the kernel you need to choose"
+	help
+	  In order to build a kernel with support for both AMD and Intel
+	  CPUs, you need to set CONFIG_KVM=m.
+
+config KVM_AMD_STATIC
+	select KVM_AMD
+	bool "Link KVM AMD statically into the kernel"
+
+config KVM_INTEL_STATIC
+	select KVM_INTEL
+	bool "Link KVM Intel statically into the kernel"
+
+endchoice
+
+endif
+
 config KVM_INTEL
 	tristate "KVM for Intel processors support"
-	depends on KVM
+	depends on (KVM && !KVM_AMD_STATIC) || KVM_INTEL_STATIC
 	# for perf_guest_get_msrs():
 	depends on CPU_SUP_INTEL
 	---help---
@@ -73,7 +93,7 @@ config KVM_INTEL
 
 config KVM_AMD
 	tristate "KVM for AMD processors support"
-	depends on KVM
+	depends on (KVM && !KVM_INTEL_STATIC) || KVM_AMD_STATIC
 	---help---
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
