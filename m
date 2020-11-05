Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D2C2A7A30
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 10:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbgKEJNW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 04:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730511AbgKEJNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 04:13:17 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE87C0613CF;
        Thu,  5 Nov 2020 01:13:17 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id z24so979676pgk.3;
        Thu, 05 Nov 2020 01:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=it/aUNucb+eS7C5uHmvXlw2AU+ivxXZX3tKWa1g129A=;
        b=Aj4bInwyaphGTX6fTa2ceBsFKzIuLADKM48JtK+GTW6s03bSUhcT6dBpMLVZp3iAvS
         XyTm/nYnhLFJ9H3vCEiwBGDg0QEhJE3dmKanNa8jF2yDP8QYHRIVB//qBO2WtLYDl8/w
         NcWFjqHQF3Rrch8TI5tHGDufElraqHO17JRm5Cphcy/m0a1n8R4FA6JQWHldJJtG3a/J
         2tlOWIM5wvEnF/akzKDvDFGt8Tyk63oubn2F+WN8OvugTYql/iI1ixpcvka6B709xdja
         yiA93bI4V/JAjE8ri1NcxzDezknNqhj/mdmsxh3XOJil2/AJwb3mbvX3+syCtFFYXU2f
         9iCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=it/aUNucb+eS7C5uHmvXlw2AU+ivxXZX3tKWa1g129A=;
        b=Pc/0Z6tAyOBP+vF593AVyhgx8laO8AeS4YajCrKmR3TdW1AnyqO25myQE42Lp/PEIH
         WOC21zxqTif/m0LATX/Axx0fTc6Lirpe1DvOAkCEW5gtJByQxv4K1x18FpWYC0epfzZY
         eKB+DVKX0DEtCBcPTDhzoLnLCaOEi2PdxJEyBqA183VocQ0d6wBDYVMnR66xKbSJXpzQ
         GhAtc52vOM3pK+w603arJAW4g2Iz6kGwfsPn9W/OVMXqRoJ/ICo3sKg8VmtFk/4NpGq1
         u6DlVuISe+WlBC14BS0BCDvmwh9xeNkXEGRC5prAyucbiHZXLIV4rbzdubOGtTMSytKE
         4k4g==
X-Gm-Message-State: AOAM531CikEP4s2Vyf4rdAc8P37qqSeKDmo/LOBWpWQMflo7R9tp1hZ3
        6Pw3RBe63jK1Jj7uAQ+WbDhURfg8RIWTVQ==
X-Google-Smtp-Source: ABdhPJxOCFM30PXg4bz3cULiea6le6eGSaNWAP6cq6k9a4aWDii32DyXTILEprpgOQ63l8V3nwm7Xg==
X-Received: by 2002:a05:6a00:44:b029:155:18ee:a71e with SMTP id i4-20020a056a000044b029015518eea71emr1573317pfk.1.1604567596694;
        Thu, 05 Nov 2020 01:13:16 -0800 (PST)
Received: from VM-16-39-centos.localdomain ([124.156.183.47])
        by smtp.gmail.com with ESMTPSA id g3sm1551789pgl.55.2020.11.05.01.13.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 01:13:15 -0800 (PST)
From:   junjiehua0xff@gmail.com
X-Google-Original-From: junjiehua@tencent.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrey Smetanin <asmetanin@virtuozzo.com>,
        Junjie Hua <junjiehua@tencent.com>
Subject: [PATCH] x86/kvm/hyper-v: Don't deactivate APICv unconditionally when Hyper-V SynIC enabled
Date:   Thu,  5 Nov 2020 17:12:17 +0800
Message-Id: <1604567537-909-1-git-send-email-junjiehua@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junjie Hua <junjiehua@tencent.com>

The current implementation of Hyper-V SynIC[1] request to deactivate 
APICv when SynIC is enabled, since the AutoEOI feature of SynIC is not 
compatible with APICv[2].

Actually, windows doesn't use AutoEOI if deprecating AutoEOI bit is set 
(CPUID.40000004H:EAX[bit 9], HyperV-TLFS v6.0b section 2.4.5), we don't 
need to disable APICv in this case.

[1] commit 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")
[2] https://patchwork.kernel.org/patch/7486761/

Signed-off-by: Junjie Hua <junjiehua@tencent.com>
---
 arch/x86/kvm/hyperv.c | 18 +++++++++++++++++-
 arch/x86/kvm/lapic.c  |  3 +++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 5c7c406..9eee2da 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -899,6 +899,19 @@ void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	hv_vcpu->vp_index = kvm_vcpu_get_idx(vcpu);
 }
 
+static bool kvm_hv_is_synic_autoeoi_deprecated(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = kvm_find_cpuid_entry(vcpu,
+				HYPERV_CPUID_ENLIGHTMENT_INFO,
+				0);
+	if (!entry)
+		return false;
+
+	return entry->eax & HV_DEPRECATING_AEOI_RECOMMENDED;
+}
+
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 {
 	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
@@ -908,7 +921,10 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 	 * not compatible with APICV, so request
 	 * to deactivate APICV permanently.
 	 */
-	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
+	if (!kvm_hv_is_synic_autoeoi_deprecated(vcpu))
+		kvm_request_apicv_update(vcpu->kvm,
+					false, APICV_INHIBIT_REASON_HYPERV);
+
 	synic->active = true;
 	synic->dont_zero_synic_pages = dont_zero_synic_pages;
 	synic->control = HV_SYNIC_CONTROL_ENABLE;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 105e785..0bb431f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1263,6 +1263,9 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 
 	trace_kvm_eoi(apic, vector);
 
+	if (test_bit(vector, vcpu_to_synic(apic->vcpu)->vec_bitmap))
+		kvm_hv_synic_send_eoi(apic->vcpu, vector);
+
 	kvm_ioapic_send_eoi(apic, vector);
 	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
 }
-- 
1.8.3.1

