Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB6C14B1B9
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 10:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgA1J1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 04:27:31 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:44855 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgA1J1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 04:27:30 -0500
Received: by mail-pj1-f73.google.com with SMTP id c31so1128595pje.9
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 01:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nioYHgWtzuJX0bGGHSnAcIx7clPoYS+RyTzHFfHLiC0=;
        b=k4wersvPQpScFKgypDDZhrTlz2Tiv91+qRRQMaNpNlAHjISZCuXpObMYK6G8w4xJ9U
         77ZWAhVxTCXsoMsx6kkhPFBAQNLE5EyJcHJpTw8KlHyoSwZK9lNsLFOkpM0GgNuWlilC
         DJbXzCjv+/ux8RyJP+p3CcVQXGcLwx6A7OFKG/du4GJehbgZkYahCD7vIiF/esJOO7s9
         IbxIjkmqmuETjqHytNnsoxUHAqxYBiXrn/8mq//XMeqzl96BiWT5Ns8d7M150bNCzuOj
         D8kVvv+azEBzZNX+xAnvTPGPCbB0p2qRp5sqrgFh+FyYCCNtzE4Eh9EvigzEk07zRWLV
         +Fag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nioYHgWtzuJX0bGGHSnAcIx7clPoYS+RyTzHFfHLiC0=;
        b=qanlwMKinkAOKSphOQKrZ9QOnrx272CeIhnEFDSNH/cCx6wHqG5DvyyJYVAC8ppnVo
         sN28GrKOdRow6tRyospkjgPEqL0dUfpi+Y9NQYFfJ7kyyIBDmANIOTcXnpE8p7eAqMXA
         mFdCet8IyKEdeUyKO/jTssaCzvNBKImYUNZv6aHhC2Ps/NwaLyLcfIDGStAabKhJSPqP
         i7wLmfM/A1ifqKGmtdkgPILlAMXOspLNPOvQ1g5GPdFYmMordLFjkN4YzAXjelMdwSJY
         GG5ymOf7a8CXAz/HsnENzodO+QX89PQ0yKEc07qO9+A2VgnPuYvs8oPo3IrrqAl0Zjpf
         LScw==
X-Gm-Message-State: APjAAAW/fRhooOip+I3lgZFtf+tfIkxBThYl1r6pQVodLSK7wCw5dUmj
        SLDyRiFflUQJEMc8YciHZOdpq8uJ+j8yxWQP7qjrtYcO7QyMSxxokk/Dyl8a+shtqySWiF4vWyW
        NWTrtB04AA15FrzXUVixlR4WOMJO1HvUQcpyt+ygBf4y435pNFQ3T/z1SSA==
X-Google-Smtp-Source: APXvYqy0cehjxUbWNumChAd1siL4XK+9M6zowjeV4zuou3ingY61ee2Z+Hjbqozv2qBQZ4wdtqm9RR46lmc=
X-Received: by 2002:a63:78b:: with SMTP id 133mr23439750pgh.379.1580203649548;
 Tue, 28 Jan 2020 01:27:29 -0800 (PST)
Date:   Tue, 28 Jan 2020 01:27:11 -0800
In-Reply-To: <20200128092715.69429-1-oupton@google.com>
Message-Id: <20200128092715.69429-2-oupton@google.com>
Mime-Version: 1.0
References: <20200128092715.69429-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v2 1/5] KVM: x86: Mask off reserved bit from #DB exception payload
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

KVM defines the #DB payload as compatible with the 'pending debug
exceptions' field under VMX, not DR6. Mask off bit 12 when applying the
payload to DR6, as it is reserved on DR6 but not the 'pending debug
exceptions' field.

Fixes: f10c729ff965 ("kvm: vmx: Defer setting of DR6 until #DB delivery")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e118883d8f1..7a341c0c978a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -437,6 +437,14 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		 * for #DB exceptions under VMX.
 		 */
 		vcpu->arch.dr6 ^= payload & DR6_RTM;
+
+		/*
+		 * The #DB payload is defined as compatible with the 'pending
+		 * debug exceptions' field under VMX, not DR6. While bit 12 is
+		 * defined in the 'pending debug exceptions' field (enabled
+		 * breakpoint), it is reserved and must be zero in DR6.
+		 */
+		vcpu->arch.dr6 &= ~BIT(12);
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = payload;
-- 
2.25.0.341.g760bfbb309-goog

