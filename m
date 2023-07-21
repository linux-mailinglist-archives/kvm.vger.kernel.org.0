Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F57A75D597
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjGUUVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjGUUUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:20:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4A330D6
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d00a63fcdefso1716430276.3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970779; x=1690575579;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0ufOgL/ovXKIGQEYukNshYDCW2QOagoVOtmN2psRo9c=;
        b=b12Ttu/+eAKMYYr+ZtWZDhO9f8tIZzhiWDUyfkYKkQAGZ8PdoM7SUfhXHfFjda9SM8
         wHTbZcaIxbvpo6ZC55UJc/d6aRulVjhV0CUNJrul/2S2FZZweyArAU2EVJUBrcBBXquN
         vU05kJwjb1NAJHt3dCz+9FG0HhYvLHlgxT/IyC/seKzCxR/UFSkK+WuX3JN2T1Zjexz/
         cn2JU6UHxz3FopptseYCiqsx2AYAfIKAmTFUMY10/d1txCxH5yYIetLq3/s5ohB7VhvC
         xsH/zGKExBxyiHcmYi130rGplxqvQDFOSlqz2e7jwYp5AIvNTdYLOF8Ndw+tBLCt7PL8
         HW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970779; x=1690575579;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ufOgL/ovXKIGQEYukNshYDCW2QOagoVOtmN2psRo9c=;
        b=KlaVsPCkzlemjMB9Jg2d0OpXg/irNWlWhIK7jMNlibrcx9VWQcKx6U93CL01VxqzSU
         g4zmboNjqPrfthM/4g6ZghVPEPnNLy8Aqc4/CcHtfO3gwHLUFla5saBcg4q2g31U8oCK
         MAecZRQGojIzESj8FuWqsOhKMFapLqUIVrX4TKmuw5Xe7N7A3fBV+/hFrI36Ea65/LGl
         aycRb0k0ccpkB5yip0wmoiCrMoemHTlCYHefaGLzqW1qoW2lhf0GZyGauS1UQydpFDZx
         JuO20NsGe1FCBSTWBVjpg05/C52M+4e3iU7wbPv9ymlBWTMjekGJ1Y+jmqgBTPOPr5qS
         f8WA==
X-Gm-Message-State: ABy/qLbqiIFzEsvVR/WQagi8QsrJMlwOUFnimn6BB2p/31wJSmOQORdi
        OWheBA5RfCTrM5CAS0uK9mbYxe9b5Iw=
X-Google-Smtp-Source: APBJJlEMRg8khkFQs+v6K4Haj1LsdDQNVMJ0EH61NH5YR90us2W3yxUe/jzK4/gqbgOaQJvbK9pl9eS5wa8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:81cf:0:b0:c5d:dac2:cb2a with SMTP id
 n15-20020a2581cf000000b00c5ddac2cb2amr18048ybm.13.1689970779472; Fri, 21 Jul
 2023 13:19:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:57 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-18-seanjc@google.com>
Subject: [PATCH v4 17/19] KVM: x86: Force kvm_rebooting=true during emergency reboot/crash
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set kvm_rebooting when virtualization is disabled in an emergency so that
KVM eats faults on virtualization instructions even if kvm_reboot() isn't
reached.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 arch/x86/kvm/vmx/vmx.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 47f9c7156609..8d1b3c801629 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -605,6 +605,8 @@ static inline void kvm_cpu_svm_disable(void)
 
 static void svm_emergency_disable(void)
 {
+	kvm_rebooting = true;
+
 	kvm_cpu_svm_disable();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0e1f3856a9be..5d21931842a5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -771,6 +771,8 @@ static void vmx_emergency_disable(void)
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
 
+	kvm_rebooting = true;
+
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
-- 
2.41.0.487.g6d72f3e995-goog

