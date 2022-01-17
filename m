Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA1C4903C3
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbiAQI0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiAQI0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 03:26:40 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BACC061574;
        Mon, 17 Jan 2022 00:26:40 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x83so9583496pfc.0;
        Mon, 17 Jan 2022 00:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JQRUg3gR0ppfza0XnAdPPccFiH1XKMMktwvrtu7u03c=;
        b=c9VOh4K9pcUFXm5zm2ILaD4J5qqt6v/rL2yQOp4+uh2/cY9mDbwapQzYFKkHU7Fv41
         mkq0eJS8J3coFc7NXkprelt9KlJBT6UW5Y8l0SZk4w5I5xgiw9QX9W/v+TO4oBYd0Sin
         tCfBqtAFqAvZXtJPzwl9voPdbjFYy6F8EMqdT54+X9czrs3uS/2vb4lPmwoM5BYu2O5M
         fqZpZBbSxUoCxEXF27bgb/REeqNtOpyynhPvUJRYDIOinAdJ+ArhUIpjs1uocWBy8eWi
         dJG8Negifima70Zt325/tT5E8fDQhJa6oY8Y6CWTTTiN1/20mgvK63h2s4sUhFMi4j46
         Bc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JQRUg3gR0ppfza0XnAdPPccFiH1XKMMktwvrtu7u03c=;
        b=07Vp00kBWGQMFRtDE998jUmTPQ3YjaCoi9jNJdXE/fFBwWZ8a7J7uhY48zOr4DVtPY
         xMRd3/foMj0cPH7YfG9c2ZLkndMk7f8tWQMN6l+bEtIui8oCEVySZDA0sv8VDk67diji
         C3MJYZWaSATu3TVxR9S1lQLTvf5mQ5QqlqbHoTpQ5Hy8NkmTwrAAK4zg+lrG9nU464eF
         3J+yi3/3AXrZmSvQ7amR5G+zSOj24mzqWBOJHJHRfH6/7B6+mN6SDJKIZUXtbeyfwLQd
         KD9wGDIyCr5uUhfN+cEZzKzjg6b+K1UspKuZnxq6YKKCGvZ4ccYTx4xuwEyNjQMjxTBB
         52Og==
X-Gm-Message-State: AOAM532TTv3C8n4TudZyqlIcFJGM6/tEEZkskxhe/bq+9HLTpk4bEG+n
        8/iJsVdgWDZnzhZ1yRxH3c11ZJ02kV6eTA==
X-Google-Smtp-Source: ABdhPJzE058AYXCZCAh7ybcJnt642fqYmbBUDG9qzWgeHMDUYpKZw8sjvLt/04XmNXdpO86wjAdxaA==
X-Received: by 2002:a63:9dc8:: with SMTP id i191mr18267040pgd.601.1642408000402;
        Mon, 17 Jan 2022 00:26:40 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o184sm13213034pfb.90.2022.01.17.00.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 00:26:40 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Update the states size cpuid even if XCR0/IA32_XSS is reset
Date:   Mon, 17 Jan 2022 16:26:31 +0800
Message-Id: <20220117082631.86143-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
both RESET and INIT. In both cases, the size in bytes of the XSAVE
area containing all states enabled by XCR0 or (XCRO | IA32_XSS)
needs to be updated.

Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76b4803dd3bd..5748a57e1cb7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11134,6 +11134,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	struct kvm_cpuid_entry2 *cpuid_0x1;
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
 	unsigned long new_cr0;
+	bool need_update_cpuid = false;
 
 	/*
 	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
@@ -11199,6 +11200,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 		vcpu->arch.msr_misc_features_enables = 0;
 
+		if (vcpu->arch.xcr0 != XFEATURE_MASK_FP)
+			need_update_cpuid = true;
 		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
 	}
 
@@ -11216,6 +11219,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
 	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
 
+	if (vcpu->arch.ia32_xss)
+		need_update_cpuid = true;
 	vcpu->arch.ia32_xss = 0;
 
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
@@ -11264,6 +11269,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
 	if (init_event)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+
+	if (need_update_cpuid)
+		kvm_update_cpuid_runtime(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_reset);
 
-- 
2.33.1

