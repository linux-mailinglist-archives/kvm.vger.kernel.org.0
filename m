Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7844486A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404518AbfFMRDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:03:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36835 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392731AbfFMRDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:49 -0400
Received: by mail-wm1-f65.google.com with SMTP id u8so10904644wmm.1;
        Thu, 13 Jun 2019 10:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+pz3R1djvSsBldla2VhDwFQOgKC5gEcy56s+Wxv1xbs=;
        b=MYkL/DHsfAE8JOcPMgiU/WgT0Dp3Vpn5/MIqVT45Xq0cSYCnXETwJ4zrST2WNU3B31
         64RNQNa4qOMc5q61nrNOlGgi6T2RdkCr7Ft/hkeuzfsGJrR4P5eWXMiI5ou+6i3Ogxwm
         AQdShaB/bnsZChVnldW2kuDVI8Tyji/eXlIG9Px+iSFBfHARtZb68exQG/81r6MM2TVg
         yDgO0nXu3d1nC9vTVwhZNT1LjfknmssPVkpRB6g9h4mOyaQzGtUUD50L6NDFYLQVBZnc
         ASh9yrYQ80eUhBapwRXHOHIs594B7OEQQUPcpOu1VwtqLwrUFxvFP+42t0QE7cFg954D
         hRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=+pz3R1djvSsBldla2VhDwFQOgKC5gEcy56s+Wxv1xbs=;
        b=ZASMmjUOWxc5FUvisg6s9ZwHXRP2KcoRB7LUU9b5mfaOA9Nw2jMTGqhrLiidnOCN2l
         Wp3fl0A2HWk0rNWzGvhcQ+cvQmXWVQzHIfprmQM6EcAgnwk5LmtTZZEqQkQ0PfCcHLGe
         Hp/nT63yP+x9rQXI1schavuQEWXIBbL/wx1jkwOE0hfa7pQ9mA6R3dBBgyHOd22SuKgS
         qphad0q3c+u1T5XK0fiXJQZDZ0ncTDAGwzVDQI0D3f7VQPDDfc3vF7dCQLhltlmX+ml5
         Zix4YjW/O4xfqEMS0ZAibPvQk0K5sD2GmZDu+ZRV43QodPgeHAaUhKPBFSmbzvE6YIjE
         uE0w==
X-Gm-Message-State: APjAAAUBkyJdjZdUebS43vIcCMZp92iojd0hi2tLBY8u/GTPKv45VVWZ
        CmJXdXUlDCWmpQrFa3nO10kEI5eS
X-Google-Smtp-Source: APXvYqzz/GJlk+vfE8h3MH+Xf/GvZEIgxRQZPTeYC/sgK6Ta27HH56CFL9ZiBZfxCXQ0Ier47BY73g==
X-Received: by 2002:a1c:e28b:: with SMTP id z133mr4230068wmg.136.1560445426973;
        Thu, 13 Jun 2019 10:03:46 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:42 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 12/43] KVM: nVMX: Add helpers to identify shadowed VMCS fields
Date:   Thu, 13 Jun 2019 19:02:58 +0200
Message-Id: <1560445409-17363-13-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

So that future optimizations related to shadowed fields don't need to
define their own switch statement.

Add a BUILD_BUG_ON() to ensure at least one of the types (RW vs RO) is
defined when including vmcs_shadow_fields.h (guess who keeps mistyping
SHADOW_FIELD_RO as SHADOW_FIELD_R0).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c             | 71 ++++++++++++++++++++---------------
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |  4 ++
 2 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fc2b8f4cf45f..a6fe6cfe96f6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4420,6 +4420,29 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	return nested_vmx_succeed(vcpu);
 }
 
+static bool is_shadow_field_rw(unsigned long field)
+{
+	switch (field) {
+#define SHADOW_FIELD_RW(x, y) case x:
+#include "vmcs_shadow_fields.h"
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+static bool is_shadow_field_ro(unsigned long field)
+{
+	switch (field) {
+#define SHADOW_FIELD_RO(x, y) case x:
+#include "vmcs_shadow_fields.h"
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
 
 static int handle_vmwrite(struct kvm_vcpu *vcpu)
 {
@@ -4503,41 +4526,27 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	vmcs12_write_any(vmcs12, field, offset, field_value);
 
 	/*
-	 * Do not track vmcs12 dirty-state if in guest-mode
-	 * as we actually dirty shadow vmcs12 instead of vmcs12.
+	 * Do not track vmcs12 dirty-state if in guest-mode as we actually
+	 * dirty shadow vmcs12 instead of vmcs12.  Fields that can be updated
+	 * by L1 without a vmexit are always updated in the vmcs02, i.e' don't
+	 * "dirty" vmcs12, all others go down the prepare_vmcs02() slow path.
 	 */
-	if (!is_guest_mode(vcpu)) {
-		switch (field) {
-#define SHADOW_FIELD_RW(x, y) case x:
-#include "vmcs_shadow_fields.h"
-			/*
-			 * The fields that can be updated by L1 without a vmexit are
-			 * always updated in the vmcs02, the others go down the slow
-			 * path of prepare_vmcs02.
-			 */
-			break;
-
-#define SHADOW_FIELD_RO(x, y) case x:
-#include "vmcs_shadow_fields.h"
-			/*
-			 * L1 can read these fields without exiting, ensure the
-			 * shadow VMCS is up-to-date.
-			 */
-			if (enable_shadow_vmcs) {
-				preempt_disable();
-				vmcs_load(vmx->vmcs01.shadow_vmcs);
+	if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field)) {
+		/*
+		 * L1 can read these fields without exiting, ensure the
+		 * shadow VMCS is up-to-date.
+		 */
+		if (enable_shadow_vmcs && is_shadow_field_ro(field)) {
+			preempt_disable();
+			vmcs_load(vmx->vmcs01.shadow_vmcs);
 
-				__vmcs_writel(field, field_value);
+			__vmcs_writel(field, field_value);
 
-				vmcs_clear(vmx->vmcs01.shadow_vmcs);
-				vmcs_load(vmx->loaded_vmcs->vmcs);
-				preempt_enable();
-			}
-			/* fall through */
-		default:
-			vmx->nested.dirty_vmcs12 = true;
-			break;
+			vmcs_clear(vmx->vmcs01.shadow_vmcs);
+			vmcs_load(vmx->loaded_vmcs->vmcs);
+			preempt_enable();
 		}
+		vmx->nested.dirty_vmcs12 = true;
 	}
 
 	return nested_vmx_succeed(vcpu);
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 2cfa19ca158e..4cea018ba285 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -1,3 +1,7 @@
+#if !defined(SHADOW_FIELD_RO) && !defined(SHADOW_FIELD_RW)
+BUILD_BUG_ON(1)
+#endif
+
 #ifndef SHADOW_FIELD_RO
 #define SHADOW_FIELD_RO(x, y)
 #endif
-- 
1.8.3.1


