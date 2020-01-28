Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBAB14B1BC
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 10:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgA1J1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 04:27:36 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:51696 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgA1J1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 04:27:35 -0500
Received: by mail-pf1-f201.google.com with SMTP id z19so8246739pfn.18
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 01:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4hAb+9+PFKE4UE+q8aj578+DRIxxwyVpmw+zN6tI7Xc=;
        b=FMJiwLj+Fwn2zTkI0mDxkWt05sWOgN+9HTOnO4H5LZIEaNYiq4e5rXw5ZQgiu15n09
         AXjaw2rFOa79n7v2KWbWLgLf0IVY0SJe1pnr59d+j9uz+qCvPx8WiU6YK4R7Wle5k3sm
         BqzZsepJE98smqnaxAWeHmVU9dPvn61a+UtGx1UXEecIxIIAMNNeyId+r19F4G4Bcug+
         /qkwtMLRwOkF/TKZE6tHQBp/AUJ7eYaClu3iOYl9TS6TOUYr9pLYMqt0I+Lk9JifND9j
         6su/dKYmLr3XFiw4uNb0xG3IazC6SCIDBPed8p83KbBOaA8QOw3gbb2krkiFRxsRcz6g
         EqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4hAb+9+PFKE4UE+q8aj578+DRIxxwyVpmw+zN6tI7Xc=;
        b=Bnq+cmxB0ePSRjo1Ds5JlnOt2qzmpggpn/G3cwDvAFJ95+urzg/vQLfeTxrcEmytFS
         9jOOpaye4Ra8JbnEf0WRWKih+BvzOKfrk3QbB5j79phnF7DWMHAD7TbLQuK5mIV3gtAo
         Z3EKfVgWNLQYEkQAnqLQaFuvKQNj9pfK+zm8G6T5ZHGsaXafGlHEEOzuGt3IedvGgFmD
         VhUooM7pzf9OCOqZA64E80kDqdb/Xp1TRrX+Xodh05xVezPO6MzY7QPe4b5GznIrDqhm
         IyI3LKqZ33uNroRJV4xQ/svt2OyivaNyxLKEMbc3mfMg0PM02UtqQq2izFB7NORUGmZu
         sdPA==
X-Gm-Message-State: APjAAAXGAthc4jLZGJ6KBd2MTPaE5OWziBl58XcxaynCUqoulksxdDvJ
        NiMtt95pILceavDCSDX5xLRuUfLCtAfRWwlJ9M5hvs5hve4m7zl1Vdnk8NpDIh1LEy4YMLv0BE6
        Ov1rNAzLAP7uOHroAaX3Y9Q7FUHhu4NoaV/MALr8jjbDeMQ5MS/jRnwG4vQ==
X-Google-Smtp-Source: APXvYqxN5CBDtyuh7Tgk8FQ9N7ZpzWeBwhIyHBexcSEK+NUjANqNputcSiLTxAQ1DawMlrMt8Ph+3wqN9G0=
X-Received: by 2002:a63:874a:: with SMTP id i71mr10592621pge.55.1580203654909;
 Tue, 28 Jan 2020 01:27:34 -0800 (PST)
Date:   Tue, 28 Jan 2020 01:27:13 -0800
In-Reply-To: <20200128092715.69429-1-oupton@google.com>
Message-Id: <20200128092715.69429-4-oupton@google.com>
Mime-Version: 1.0
References: <20200128092715.69429-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v2 3/5] KVM: x86: Deliver exception payload on KVM_GET_VCPU_EVENTS
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

KVM doesn't utilize exception payloads by default, as this behavior
diverges from the expectations of the userspace API. However, this
constraint only applies if KVM is servicing a KVM_GET_VCPU_EVENTS ioctl
before delivering the exception.

Use exception payloads unconditionally if the vcpu is in guest mode.
Deliver the exception payload before completing a KVM_GET_VCPU_EVENTS
to ensure API compatibility.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a341c0c978a..9f080101618c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -497,19 +497,7 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
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
@@ -3790,6 +3778,21 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 {
 	process_nmi(vcpu);
 
+	/*
+	 * In guest mode, payload delivery should be deferred,
+	 * so that the L1 hypervisor can intercept #PF before
+	 * CR2 is modified (or intercept #DB before DR6 is
+	 * modified under nVMX).  However, for ABI
+	 * compatibility with KVM_GET_VCPU_EVENTS and
+	 * KVM_SET_VCPU_EVENTS, we can't delay payload
+	 * delivery unless userspace has enabled this
+	 * functionality via the per-VM capability,
+	 * KVM_CAP_EXCEPTION_PAYLOAD.
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

