Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86F31628C3
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 15:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgBROoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 09:44:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41791 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726605AbgBROoW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 09:44:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582037061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fhZ0I3YWrEhOWa29fWSP+eeinOmrWp9ss357sd3bjMY=;
        b=A1gm0B5OEgRFKCyeLpv0QWqLP65mpR6mzRjjKDbcGP+qQiyPQmY79W3zN/zk3exG1tAjqF
        W71VzQRuy9pMCZpXgs3QmuInru0QTjqGlK/y8j43Gp6CBz13CxZVhfVPL9ild8FSSXPE9Z
        kWccAZ8SIFHLAuT8OxGZJWLC9vLsUu4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-cAWyZ9CYP0yMuDtEywkuTg-1; Tue, 18 Feb 2020 09:44:19 -0500
X-MC-Unique: cAWyZ9CYP0yMuDtEywkuTg-1
Received: by mail-wm1-f72.google.com with SMTP id g26so149163wmk.6
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 06:44:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fhZ0I3YWrEhOWa29fWSP+eeinOmrWp9ss357sd3bjMY=;
        b=bzEVfnXmjyzPjG8mxwC70wzBU7IEoFDLJ1TfSRvvd6RitMPRg/w7JlPkI1BBxGj8z4
         Ns2G8g+TNKLTfRG7F9VBwzawr+8/OnoEjceXeEcn9Pg6hDeysCCJsXzRlhJmvAvmSlb/
         6fZAyVgnyjLKEw1+nxTcvExlmFOPaNPj6Sr0FoRGFiHNTfE6xnlIeeYnoOUT6hYMTN9b
         J1xzEKIe+oza0H4F7YM3fDxvu2H6YZ5d+V3GI7gzwL15GARf2+Rpe2sc42JvXN/XmA/M
         vOm+YNteX/wWwkdkZssBDwBcf8Wyao2b5+2YPgSmeK0e4dk+FjCP30IY6N0lTgT5qvHx
         U9HQ==
X-Gm-Message-State: APjAAAUXebmLltXKSDzSbls1lrsKo5JuGeH6zTH1xTP9ZA1mzO21eQ94
        n5UYjPZDxOcwH5cqdUM9YzfeF7RXT68Rz45hXOSqrTiIE9lBZ4uYu/HVBmTaChZ56n4hEl3asFn
        ANDNCGwl/T8dQ
X-Received: by 2002:a1c:7717:: with SMTP id t23mr3688914wmi.17.1582037058139;
        Tue, 18 Feb 2020 06:44:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqwqyat2sqLbmEAil4KU1aSm4DesjlvwfePK23mCqjFAU6F67Sm42Y9pWvOTl46vSBYIORUf+A==
X-Received: by 2002:a1c:7717:: with SMTP id t23mr3688887wmi.17.1582037057826;
        Tue, 18 Feb 2020 06:44:17 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l15sm6201826wrv.39.2020.02.18.06.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 06:44:17 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>, kvm@vger.kernel.org
Subject: [PATCH RFC] target/i386: filter out VMX_PIN_BASED_POSTED_INTR when enabling SynIC
Date:   Tue, 18 Feb 2020 15:44:15 +0100
Message-Id: <20200218144415.94722-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a multi-vCPU guest is created with hv_synic, secondary vCPUs fail
to initialize with

qemu-system-x86_64: error: failed to set MSR 0x48d to 0xff00000016

This is caused by SynIC enablement on the boot CPU: when we do this
KVM disables apicv for the whole guest so we can't set
VMX_PIN_BASED_POSTED_INTR bit in MSR_IA32_VMX_TRUE_PINBASED_CTLS anymore.
(see nested_vmx_setup_ctls_msrs() in KVM).

This used to work before fine-grained VMX feature enablement because
we were not setting VMX MSRs.

Fix the issue by filtering out VMX_PIN_BASED_POSTED_INTR when enabling
SynIC. We also need to re-order kvm_init_msrs() with hyperv_init_vcpu()
so filtering on secondary CPUs happens before.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
RFC: This is somewhat similar to eVMCS breakage and it is likely possible
to fix this in KVM. I decided to try QEMU first as this is a single
control and unlike eVMCS we don't need to keep a list of things to disable.
---
 target/i386/kvm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 69eb43d796e6..6829b597fdbf 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1366,6 +1366,7 @@ static Error *hv_no_nonarch_cs_mig_blocker;
 static int hyperv_init_vcpu(X86CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
+    CPUX86State *env = &cpu->env;
     Error *local_err = NULL;
     int ret;
 
@@ -1431,6 +1432,9 @@ static int hyperv_init_vcpu(X86CPU *cpu)
             return ret;
         }
 
+        /* When SynIC is enabled, APICv controls become unavailable */
+        env->features[FEAT_VMX_PINBASED_CTLS] &= ~VMX_PIN_BASED_POSTED_INTR;
+
         if (!cpu->hyperv_synic_kvm_only) {
             ret = hyperv_x86_synic_add(cpu);
             if (ret < 0) {
@@ -1845,13 +1849,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
         has_msr_tsc_aux = false;
     }
 
-    kvm_init_msrs(cpu);
-
     r = hyperv_init_vcpu(cpu);
     if (r) {
         goto fail;
     }
 
+    kvm_init_msrs(cpu);
+
     return 0;
 
  fail:
-- 
2.24.1

