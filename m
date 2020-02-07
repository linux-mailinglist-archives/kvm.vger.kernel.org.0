Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7679C1555E0
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 11:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgBGKgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 05:36:36 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:35070 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgBGKgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 05:36:35 -0500
Received: by mail-pl1-f201.google.com with SMTP id v24so1073556plo.2
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 02:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vh3v3X1DXxF+Ymma2gVlAjTYvpcrxrg4caBobl2XuBU=;
        b=nOy8wb3STmb9+NTXzXL4gVt1ksnDKObSWEHFb/bMEX1W+7QiX60OGQ3AsLeMAoa23e
         lBd6Fd4R/YQOjXI0dliYsC5QTCjeX5Vs3UmDunMVKRNQDwaDqhEAPKZFU22CTz/WuLi2
         UgSeq8K/EzfoUw3ojoeqKnmy8mP4x6F+R+d6Uw3o9onivthOyHLpBNxTjawELIomy/Qx
         Zb3kJJF2jyF03zSt0GvvKEAmVQnzJ3HrRhJk8VusvfyicJK//w997M5rkW2vBw8hBFo+
         NyL8W8ijts6dUjCoPVldDdryDV9rNVv8vKOyehFK7XuenNK19Ruw2WjQ31A0+NuZbWmM
         8xDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vh3v3X1DXxF+Ymma2gVlAjTYvpcrxrg4caBobl2XuBU=;
        b=hUu0LXTcFI8BPlQZkdpn7yKxdNt/rwm4zsfvyISOyTsEIRyk00Tini3ZdbdQ8j+QZ5
         sF45u+TnA9jrMlDs4jeidTICiazmiDI3sopWv+UFCNgfwitDpg+z7saOaAdai7jsvxFr
         fXIUq2SmQ1W1kJ05374ja4S6wxux0KEnp3Q2tFPR6yaJGakTG3onp+AD9vrslST7Af/t
         WGuxV50kG14pt5LkufrglBekpuTCFMjrFcpYtglWXsiM8SeITj2UCJdQ8vcZGkoPdtaf
         BtAtd5jTojz55Lf/OjaHW0U4G+3vEdt5hj23o8jH8MrWdMPDaCsJV1sW3HCXiVKSEbkk
         GfyQ==
X-Gm-Message-State: APjAAAWxPNsfvwVqDaq/zUhrxY+SkYszx5pkgHgCrGMvNUy1TmE01cFX
        E3LSL4oXANFjL48nYIvpEiuc0xxCnHTZ7e6We/YH0E7KS+KcqkxhYnOJYExvVcp89dJqFnfQTes
        r9f5I2foEaMpvlEVAFuZA9IcoyVMzJar9/4Qhf2Nq0n0IcZn3+MLpz3QB8g==
X-Google-Smtp-Source: APXvYqyQmdX0vgN9Hz/XcyhzRAMGVrlh82fZQE0TAvBrq6kmg8w9Rhzss9eF0HTXSownGVtjUeqQUVYqnw0=
X-Received: by 2002:a63:7a0f:: with SMTP id v15mr8668920pgc.139.1581071795043;
 Fri, 07 Feb 2020 02:36:35 -0800 (PST)
Date:   Fri,  7 Feb 2020 02:36:06 -0800
In-Reply-To: <20200207103608.110305-1-oupton@google.com>
Message-Id: <20200207103608.110305-4-oupton@google.com>
Mime-Version: 1.0
References: <20200207103608.110305-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v3 3/5] KVM: x86: Deliver exception payload on KVM_GET_VCPU_EVENTS
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM allows the deferral of exception payloads when a vCPU is in guest
mode to allow the L1 hypervisor to intercept certain events (#PF, #DB)
before register state has been modified. However, this behavior is
incompatible with the KVM_{GET,SET}_VCPU_EVENTS ABI, as userspace
expects register state to have been immediately modified. Userspace may
opt-in for the payload deferral behavior with the
KVM_CAP_EXCEPTION_PAYLOAD per-VM capability. As such,
kvm_multiple_exception() will immediately manipulate guest registers if
the capability hasn't been requested.

Since the deferral is only necessary if a userspace ioctl were to be
serviced at the same as a payload bearing exception is recognized, this
behavior can be relaxed. Instead, opportunistically defer the payload
from kvm_multiple_exception() and deliver the payload before completing
a KVM_GET_VCPU_EVENTS ioctl.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95b753dab207..4d3310df1758 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -498,19 +498,7 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		vcpu->arch.exception.error_code = error_code;
 		vcpu->arch.exception.has_payload = has_payload;
 		vcpu->arch.exception.payload = payload;
-		/*
-		 * In guest mode, payload delivery should be deferred,
-		 * so that the L1 hypervisor can intercept #PF before
-		 * CR2 is modified (or intercept #DB before DR6 is
-		 * modified under nVMX).  However, for ABI
-		 * compatibility with KVM_GET_VCPU_EVENTS and
-		 * KVM_SET_VCPU_EVENTS, we can't delay payload
-		 * delivery unless userspace has enabled this
-		 * functionality via the per-VM capability,
-		 * KVM_CAP_EXCEPTION_PAYLOAD.
-		 */
-		if (!vcpu->kvm->arch.exception_payload_enabled ||
-		    !is_guest_mode(vcpu))
+		if (!is_guest_mode(vcpu))
 			kvm_deliver_exception_payload(vcpu);
 		return;
 	}
@@ -3803,6 +3791,21 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 {
 	process_nmi(vcpu);
 
+	/*
+	 * In guest mode, payload delivery should be deferred,
+	 * so that the L1 hypervisor can intercept #PF before
+	 * CR2 is modified (or intercept #DB before DR6 is
+	 * modified under nVMX). Unless the per-VM capability,
+	 * KVM_CAP_EXCEPTION_PAYLOAD, is set, we may not defer the delivery of
+	 * an exception payload and handle after a KVM_GET_VCPU_EVENTS. Since we
+	 * opportunistically defer the exception payload, deliver it if the
+	 * capability hasn't been requested before processing a
+	 * KVM_GET_VCPU_EVENTS.
+	 */
+	if (!vcpu->kvm->arch.exception_payload_enabled &&
+	    vcpu->arch.exception.pending && vcpu->arch.exception.has_payload)
+		kvm_deliver_exception_payload(vcpu);
+
 	/*
 	 * The API doesn't provide the instruction length for software
 	 * exceptions, so don't report them. As long as the guest RIP
-- 
2.25.0.341.g760bfbb309-goog

