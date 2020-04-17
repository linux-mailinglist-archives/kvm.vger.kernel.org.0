Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F4F1AE4DD
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 20:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgDQSfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 14:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729225AbgDQSfX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 14:35:23 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E436EC061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 11:35:21 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y84so2714384pfb.7
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 11:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0BuEBmYr75xPa7gC0bHFq8M7UvE4BnddAP9FXUAyrP8=;
        b=hTs2M2BNhqgtQKaBeJOV5n9UftZfpYuSTX/yiN0ir6+uVoD60NNqi5gCevO8wE7RPG
         Mv+6O64IUQhulKIPibo51rZa1v98jPldySHxthXe3khQbN6ZaNep+OaygNLFFlR7gNGc
         gahuKxWAZJaEDfI/GKvNmfKrvT6+A/0VMm7zMcANirW8oppepciiQkWJ9iv9zxk4ycBX
         Nl5aK6gQnNnmpOa+y6YNG6fCEHhwAse4S9l0O0ezA2Qe7GbFg8bseJ9waexJb9saU46z
         6B8P3cMR8ygsGhQrHFGu80Dk25sXfa1TcjP7dWv55VkvO9+wdiKa/vrkr3Tv6hHkPPM1
         MPhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0BuEBmYr75xPa7gC0bHFq8M7UvE4BnddAP9FXUAyrP8=;
        b=mHxb6gPSELz2wAllaVW57wjue9Aw9GN8TGNTzAuTsXho/YBF+5PmK0TQ+tY2AaQl9V
         wQH8gjaojKYu2C7Wzjjc/z4EHl6MAYQ/HK4WA/hA5lJmgpzbCOuiMMc+0daI9wrWPdUQ
         otSRInEt//BQJuyKsRU9PXwUlqjyHTALwW75B0o8Hw8oaS4VgBJNq1mnSyFRG1mGrk0d
         K8PVA+EcnMkC21v9hoI1qReDKgAklSVKQk61Q+14r+CsgD+qUFshIUWpHrrlFeFeTNai
         Qkjy7ozE7NeeoCPcAnPQBal3PJjaUWyfYwqKZhVfV1fupjWIq4z7SiVME8DcaxSw75PM
         9spg==
X-Gm-Message-State: AGi0PuY+pxjnNyA3S7HTUMI8PQ82GjUtZ80OHYnUFsDerKlaedkliyHu
        yGl9PcGLZtrSwa60kW7TnjkyL+HvLMCZ+RtWcWoZrNe8j2xadHFePcoIfWyjYYRGXZ9LZG/z827
        stkT0APW7eeEC54mcxlshJ7Ri3THeAe/wzeeDUZtvpFZueS6hr4jLiFw3nNsptrJCz8LP0XV8lH
        xZoYk=
X-Google-Smtp-Source: APiQypI0GYEEOW/Pk0W5Es7Sv1ul1duA5DR5/mIxLf8HukWp0LOQAjUsKV0Iy7U1r+3hmf9k8VGtYu0oh30r7v2qLdD1uA==
X-Received: by 2002:a17:90a:d98e:: with SMTP id d14mr5899339pjv.178.1587148521417;
 Fri, 17 Apr 2020 11:35:21 -0700 (PDT)
Date:   Fri, 17 Apr 2020 11:34:52 -0700
In-Reply-To: <20200417183452.115762-1-makarandsonare@google.com>
Message-Id: <20200417183452.115762-3-makarandsonare@google.com>
Mime-Version: 1.0
References: <20200417183452.115762-1-makarandsonare@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [kvm PATCH 2/2] KVM: nVMX: Don't clobber preemption timer in the
 VMCS12 before L2 ran
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't clobber the VMX-preemption timer value in the VMCS12 during
migration on the source while handling an L1 VMLAUNCH/VMRESUME but
before L2 ran. In that case the VMCS12 preemption timer value
should not be touched as it will be restarted on the target
from its original value. This emulates migration occurring while L1
awaits completion of its VMLAUNCH/VMRESUME instruction.

Signed-off-by: Makarand Sonare <makarandsonare@google.com>
Signed-off-by: Peter Shier <pshier@google.com>
Change-Id: I376d151585d4f1449319f7512151f11bbf08c5bf
---
 arch/x86/kvm/vmx/nested.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5365d7e5921ea..66155e9114114 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3897,11 +3897,13 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
 
 	if (nested_cpu_has_preemption_timer(vmcs12)) {
-		vmx->nested.preemption_timer_remaining =
-			vmx_get_preemption_timer_value(vcpu);
-		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
-			vmcs12->vmx_preemption_timer_value =
-				vmx->nested.preemption_timer_remaining;
+		if (!vmx->nested.nested_run_pending) {
+			vmx->nested.preemption_timer_remaining =
+				vmx_get_preemption_timer_value(vcpu);
+			if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
+				vmcs12->vmx_preemption_timer_value =
+					vmx->nested.preemption_timer_remaining;
+			}
 	}
 
 	/*
-- 
2.26.1.301.g55bc3eb7cb9-goog

