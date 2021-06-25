Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F3A3B4190
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 12:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhFYK0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 06:26:54 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:62675 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhFYK0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 06:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1624616668; x=1656152668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=emG7j8fZPGMdCYAjeHFKGkXfq8HitffOpSus8mjL/7E=;
  b=HUbyySQdeH/vG8yyP4FMVFRrFV5NeO4N3+RmWCVFFqBcHTIJlAngs1vV
   Duirf9i14S74T4BHDsCLnnF+UxSzh3x4a8kms+1VYckOD+Tyg7MnhgaTS
   Iutyf6zJuhaFJ/l2TBwWtW6T9U3mwqmhAk3HbCoYb3sf0GnOuaM88Mekb
   4=;
X-IronPort-AV: E=Sophos;i="5.83,298,1616457600"; 
   d="scan'208";a="142145158"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 25 Jun 2021 10:24:21 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id BA5A3220122;
        Fri, 25 Jun 2021 10:24:20 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.183) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 25 Jun 2021 10:24:16 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v2 4/6] kvm/i386: Avoid multiple calls to check_extension(KVM_CAP_HYPERV)
Date:   Fri, 25 Jun 2021 12:23:29 +0200
Message-ID: <c11046833369b3bc006ce4fb95d9657b2d7dbad4.1624615713.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1624615713.git.sidcha@amazon.de>
References: <cover.1624615713.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D05UWC004.ant.amazon.com (10.43.162.223) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_HYPERV is a VM ioctl and can be cached at kvm_arch_init()
instead of performing an ioctl each time in hyperv_enabled() which is
called foreach vCPU. Apart from that, this variable will come in handy
in a subsequent patch.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 target/i386/kvm/kvm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 03202bd06b..bcf1b4f2d0 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -93,6 +93,7 @@ static bool has_msr_misc_enable;
 static bool has_msr_smbase;
 static bool has_msr_bndcfgs;
 static int lm_capable_kernel;
+static bool has_hyperv;
 static bool has_msr_hv_hypercall;
 static bool has_msr_hv_crash;
 static bool has_msr_hv_reset;
@@ -716,7 +717,7 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
 
 static bool hyperv_enabled(X86CPU *cpu)
 {
-    return kvm_check_extension(kvm_state, KVM_CAP_HYPERV) > 0 &&
+    return has_hyperv &&
         ((cpu->hyperv_spinlock_attempts != HYPERV_SPINLOCK_NEVER_NOTIFY) ||
          cpu->hyperv_features || cpu->hyperv_passthrough);
 }
@@ -2216,6 +2217,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     has_xsave = kvm_check_extension(s, KVM_CAP_XSAVE);
     has_xcrs = kvm_check_extension(s, KVM_CAP_XCRS);
     has_pit_state2 = kvm_check_extension(s, KVM_CAP_PIT_STATE2);
+    has_hyperv = kvm_check_extension(s, KVM_CAP_HYPERV);
 
     hv_vpindex_settable = kvm_check_extension(s, KVM_CAP_HYPERV_VP_INDEX);
 
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



