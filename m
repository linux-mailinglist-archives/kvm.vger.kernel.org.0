Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D7F38B9F6
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhETXFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhETXFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:19 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01884C061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:58 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id o14-20020a05620a0d4eb02903a5eee61155so3556535qkl.9
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sEEFc7nxytPNhRyL7aSgTcAzNHBObQcmfsrv08SwNNc=;
        b=jJLMdJ0mRxDYGPBrizBxv6CjLCHeu1WyLXmVtBhxABQucChMmGOYPupiMnCPABBJwr
         euA3miJabiMbWLcNPoJBblFu5nzS3HqCFJ4TkbiqrKLrt9Ssn9CY9kqbzXLDqymDnfX0
         v1sUOjR/7RyjAkZfxJx1/pFRgRdkOQiBNttNZ6VoF6Th9/fn6r0zP+S0Xa6MxoIEzIRU
         fdKJ6Py64s5s+Kdnqw4DT9YWGarKylpU5XO7jGg0zd8MQ36Bo4dzBwSyQbhvwBLvABOU
         wi51nnBtifDgk2x/Sy3NsIYxHs/jniMheNEQc716BMLOl7982s48cY5PVKE+bdyciMkS
         hP6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sEEFc7nxytPNhRyL7aSgTcAzNHBObQcmfsrv08SwNNc=;
        b=YaRx+HMdEP3oHayKENNndLs75m88+fqWH6guSUN5tE/weLW+w6B1D7D/DNNfEEA3iy
         tF7rZWj6PcKnHm1swIkkJUW28WZ16vA3UiEZQugH3KuM2O+7i1rR8XTLxo2jbL98mj2Q
         uMjGMYX9IhZX2UrgDK/bvd1SiFQyX8m7vaZLbPuRE3GvALO/1gXrlTGcZXqjxnnct6AR
         nB/celA0XzJPKjVSWjkXNnTxeQbYIoHo8EVHobNl3yfRjJPlQAuE+6Qfh4ud6zgtze6d
         NHPtkN/6J3/B/dnSpqHnes9HRd0fLjmIwdzpjatI9gCA8cZfKARXJOyk4LlJRHv4k84f
         UpxA==
X-Gm-Message-State: AOAM5319zRaL1iHl78yZv0KiQcUEztR+ahjzoElqKb7Q8R4tVo65VKpe
        XdZMZUVEEXLGDAYEFQ+yEyfkRBtWRt4XwDeGrscWKvVode0KD/Gc17PVPS1RqxMrpEoSLue3Lun
        d8+g9Ib+h56zka9t/JKaQYJw6P1u0UyHfr+aN71h9atKFDq6ZXV+fru9Hx6pB95w=
X-Google-Smtp-Source: ABdhPJzFRTrsi99/WJOGnhUbdG/nxGd9roHIyD7LwCahNz4efG7rk3rNCtukGXCwG8lCrY0a6+bl0HlIC90M9w==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a0c:99e2:: with SMTP id
 y34mr8798712qve.29.1621551837024; Thu, 20 May 2021 16:03:57 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:30 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-4-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 03/12] KVM: nVMX: Add a return code to vmx_complete_nested_posted_interrupt
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Signed-off-by: Jim Mattson <jmattson@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..7646e6e561ad 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3682,7 +3682,7 @@ void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
+static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int max_irr;
@@ -3690,17 +3690,17 @@ static void vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	u16 status;
 
 	if (!vmx->nested.pi_desc || !vmx->nested.pi_pending)
-		return;
+		return 0;
 
 	vmx->nested.pi_pending = false;
 	if (!pi_test_and_clear_on(vmx->nested.pi_desc))
-		return;
+		return 0;
 
 	max_irr = find_last_bit((unsigned long *)vmx->nested.pi_desc->pir, 256);
 	if (max_irr != 256) {
 		vapic_page = vmx->nested.virtual_apic_map.hva;
 		if (!vapic_page)
-			return;
+			return 0;
 
 		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
 			vapic_page, &max_irr);
@@ -3713,6 +3713,7 @@ static void vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	}
 
 	nested_mark_vmcs12_pages_dirty(vcpu);
+	return 0;
 }
 
 static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
@@ -3887,8 +3888,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 no_vmexit:
-	vmx_complete_nested_posted_interrupt(vcpu);
-	return 0;
+	return vmx_complete_nested_posted_interrupt(vcpu);
 }
 
 static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
-- 
2.31.1.818.g46aad6cb9e-goog

