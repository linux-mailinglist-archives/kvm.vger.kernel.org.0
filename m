Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC42242748E
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 02:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244025AbhJIANR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 20:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244019AbhJIANQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 20:13:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3E4C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 17:11:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x15-20020a056902102f00b005ba71cd7dbfso4629625ybt.8
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 17:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/g/tOaytboKKQOf+1WV4h8GWSGDE4X+3J8EYHQwrp48=;
        b=dM5GcUBC4uMTGPNF4YR4bnr1ZgyBMq3RrHdn3dxrMFd1OqNYwuPw0LKgXiTWm10Ago
         DgpK5fdXT87SdyBOo9HFnddv/ZoFYhXxr4eHhMI4P44Tj+FmTitwCVPNcNHlyGTCnct7
         BgRFbVMkpmMFsmqO1Dxmph2LGVyAx/4tpwDVw/xLttAJuqUiKwT0xMqGw5rD1IpwRsM7
         vLPyYBDl/1hO465P8EtQySNDbI6uJUdSQER3fjkDo/Wu5Q1sUgGEC4bllCorz6abSH9s
         m81z3U7B+zKGj9K5hqY6DcGYtrY5dV/VWYy77W9labka29M3wwW+5w/r0R1/XoBtcXl/
         5ohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/g/tOaytboKKQOf+1WV4h8GWSGDE4X+3J8EYHQwrp48=;
        b=oBovcggOrNMzawHO2LWtg2jzgE8Y0qsNmHs0q8MOuH51/ITCEuoyZCuCwLdWh4pOra
         bVupcuFGKQuIZU1ZH0uVsENZQ5AD4IC72+rj4C7YijBg24MTkDjI99dCPjdyF0t0zVFG
         WROjl3QzNb2JVjsO2W6Ptya2xXhEhCXqdBw213P9CcUHSFnR2qRWnlMNH9/6zjhoxAjY
         363QPy7KnDEocPSl4ejWeb6VFITronRGSs2FOyDe8H6WIILCZ8uUQIGtcyBx2JfPUstP
         O5dg7dp54QoRdUr8kbQGiR+dc9WvDNQ3GWG/PqQ/Av7KAo/xSfhwXpVxxnA6TE+U36Wh
         0fxA==
X-Gm-Message-State: AOAM531n06SXgOmCD+/38YFASdG5FFDhhWTFtk19/x56ZKbDoVb3wu8O
        rmkMwB24aRKoO+IXa2lax7q1Kq/kk0w=
X-Google-Smtp-Source: ABdhPJxJjGOM6Gbdy2LWdjKNDGtaMgEMVcgeWJJ3VdMuQ2qNKXmEiiPiaTDADxdDoZZjGQeWEzOLK8Z/hwg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:393:: with SMTP id 141mr6606723ybd.534.1633738279590;
 Fri, 08 Oct 2021 17:11:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 17:11:07 -0700
In-Reply-To: <20211009001107.3936588-1-seanjc@google.com>
Message-Id: <20211009001107.3936588-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211009001107.3936588-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 4/4] KVM: VMX: Register posted interrupt wakeup handler iff
 APICv is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't bother registering a posted interrupt wakeup handler if APICv is
disabled, KVM utilizes the wakeup vector if and only if APICv is enabled.
Practically speaking, there's no meaningful functional change as KVM's
wakeup handler is a glorified nop if there are no vCPUs using posted
interrupts, not to mention that nothing in the system should be sending
wakeup interrupts when APICv is disabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9164f1870d49..df9ad4675215 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7553,7 +7553,8 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 
 static void hardware_unsetup(void)
 {
-	kvm_unregister_posted_intr_wakeup_handler(pi_wakeup_handler);
+	if (enable_apicv)
+		kvm_unregister_posted_intr_wakeup_handler(pi_wakeup_handler);
 
 	if (nested)
 		nested_vmx_hardware_unsetup();
@@ -7907,7 +7908,8 @@ static __init int hardware_setup(void)
 	if (r)
 		nested_vmx_hardware_unsetup();
 
-	kvm_register_posted_intr_wakeup_handler(pi_wakeup_handler);
+	if (enable_apicv)
+		kvm_register_posted_intr_wakeup_handler(pi_wakeup_handler);
 
 	return r;
 }
-- 
2.33.0.882.g93a45727a2-goog

