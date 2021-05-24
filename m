Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7A038F3E7
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhEXT5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:57:25 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:44734 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbhEXT5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 15:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1621886157; x=1653422157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=5pzt10yIIjzwUF6BelVfnSNpnXyncgMpqkanGTHNZ9E=;
  b=TKe3CGoBqzL/VWMppq3GKJtjexJos4mdvzhgxlOi63u/QYBJo1737Azp
   ysYciTF8xunHzQzhq3kg2exOotQXD1KYiDoGkwZAF0+OILrTxUTRPx0Je
   Oe8GyaHUmmD8/mpXZ6ZPBSYAsHVwILFfQAdJhcF0vffdCvsCQE5LuJ5f5
   A=;
X-IronPort-AV: E=Sophos;i="5.82,325,1613433600"; 
   d="scan'208";a="136607583"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 24 May 2021 19:55:49 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 66646100B25;
        Mon, 24 May 2021 19:55:47 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.253) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 24 May 2021 19:55:43 +0000
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
Subject: [PATCH 4/6] kvm/i386: Avoid multiple calls to check_extension(KVM_CAP_HYPERV)
Date:   Mon, 24 May 2021 21:54:07 +0200
Message-ID: <ff4e06369b32aa715ac37fb51d151681cd66e401.1621885749.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1621885749.git.sidcha@amazon.de>
References: <cover.1621885749.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
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
 target/i386/kvm/kvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index d19a2913fd..362f04ab3f 100644
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
@@ -715,8 +716,7 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
 
 static bool hyperv_enabled(X86CPU *cpu)
 {
-    CPUState *cs = CPU(cpu);
-    return kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV) > 0 &&
+    return has_hyperv &&
         ((cpu->hyperv_spinlock_attempts != HYPERV_SPINLOCK_NEVER_NOTIFY) ||
          cpu->hyperv_features || cpu->hyperv_passthrough);
 }
@@ -2172,6 +2172,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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



