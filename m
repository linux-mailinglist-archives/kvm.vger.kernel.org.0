Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7858639BEB3
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFDR3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:29:18 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:41541 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFDR3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:29:17 -0400
Received: by mail-yb1-f201.google.com with SMTP id j7-20020a258b870000b029052360b1e3e2so12649135ybl.8
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HULabYlXk0tW3Y4DYJCJlDwv7KKOGlzX9lsq/vIfMJQ=;
        b=DpMAqgReqQDxRs5hKv1q9sPsnWBtRmQvXpHpvUo6jHi0jTJ9FIe+Ig1v9akWL1pQu4
         Sjw4N0HoVGxj5HAhJRyPVaGgVDfwJv0ViHPtrITkSAUw3iOF3IC10mx/ts7siU2f6VpT
         BU0459Ay6aSGyc4RKGbFJAD60le9XqUFbrTpg4s+rN8SR6dLzYBXQjgYXVPBV+tpWCfg
         ZX+DD/d/XACzFVT+L+yRVaGcJfe3wW933H3ySz7DUFeSar977NGLfLrOqggtJCUD+YOV
         LN3DXHwSNChWaDZm4cuknbvEpXqigf+c8y8m1fuByn0qowHb8ArRd1EjWRwJMbgnDcdj
         JU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HULabYlXk0tW3Y4DYJCJlDwv7KKOGlzX9lsq/vIfMJQ=;
        b=sTDfP/+4EwSJgKAV3PsyRgYSw5vx/2cBFAZGwKwbPq8IrzOG0aggdL4iFR14/tYEPE
         5MfmKXuiVebQsib17PL7+uUZPr2yz2UaVOkj3lJ1Aw7yfYPaDyrIDab6MsmFt6eidRPe
         p/FcxygfrrXn7ft+xJQx2YbFKbqqg9/WSVKD/AxYOmLeHW4YeSFDN0+b/+glayAXDrPi
         44iUYvwMiF00/eoTLQ1eiScqmggHXO2HDNdRYEJRvOYF5jApOo0ZvtQDyYFJwekShAmP
         kT0LRkW18m/ihBlbTUwxoYmCaHfxoFm9VCg0bNCgilWz5eiRR3nEfSjw30kpIBZFR03I
         bQZQ==
X-Gm-Message-State: AOAM532buQMEN1xSq2qA27Oca3+J9h5uN+mP3gaNPtC8UL3p7ShKmQYj
        k0de+6YzTqomy0lBUGxmI5Z+x5qsWeMNnStltcouZw0n1acW0k0u2lVSHlOAoMTuOH57iEYRTyC
        6EZfPzYywB3xZv4mOIRMOjDhQDrSqEq0aZtDUij8wMej+C2Jg29uXX0uN2YNIqFU=
X-Google-Smtp-Source: ABdhPJxBYVuPepeePEQ/83cwzxTgXNNW7XmRqVaFSG6wB5hxB33E9sepRngJimlf4PnS32cDuV5Op9icVdGpkA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a25:c547:: with SMTP id
 v68mr6706528ybe.361.1622827590598; Fri, 04 Jun 2021 10:26:30 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:01 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-3-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 02/12] KVM: x86: Wake up a vCPU when kvm_check_nested_events
 fails
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At present, there are two reasons why kvm_check_nested_events may
return a non-zero value:

1) we just emulated a shutdown VM-exit from L2 to L1.
2) we need to perform an immediate VM-exit from vmcs02.

In either case, transition the vCPU to "running."

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 882457e92679..83bc0a5b1aab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9471,8 +9471,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
-		kvm_check_nested_events(vcpu);
+	if (is_guest_mode(vcpu) && kvm_check_nested_events(vcpu))
+		return true;
 
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
-- 
2.32.0.rc1.229.g3e70b5a671-goog

