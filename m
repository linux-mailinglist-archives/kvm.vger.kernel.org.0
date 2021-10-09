Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7993242748A
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 02:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244003AbhJIANO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 20:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243989AbhJIANL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 20:13:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0128EC061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 17:11:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v203-20020a25c5d4000000b005bb21580411so2035045ybe.19
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 17:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bAloFfewj/zQRYhL5ulk5e0QyHM9EAunSNgXmDCR8AM=;
        b=ST0iL+WBV2iExe7rpojaTs4LjOuY0fc83FuN072lnEaXnt15bunbZZxjQIpMpHk9Az
         pADA8vjy5X05YVjPEyR2dJhczHcLph93LPTl/FDMc5XqqvXOu0+emZe6f+l6d/0qE8eD
         YXCwVZPS1e3ImmfezavyIEMi22XQV8lCVEV0cvoFpHRpFjnKqRGsRxobytIg6KWRRaAo
         9LCpz+qqDho/SaSTJ0fvl8nx5o51AstfZiaWitJT5cVihQ4ZWmNvMwcYFPXxCWKw9xqs
         9t5joeDe09xEjni5/DNRH/qv0/YdtycZ2Qcm5Q0IIisvoZM6jRESnhO56J0slezWX3Yq
         X33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bAloFfewj/zQRYhL5ulk5e0QyHM9EAunSNgXmDCR8AM=;
        b=PESsivRUM53WQxmADrWomXWARcd3rNqDeFArlJ4+MWbg0zqrDT7rfQ30IvMSVoPURE
         HMM990gW5W+tw+0s0HHkjeVdpZDeZvkm6IdZ0phWnNTGelrQiwlIhJz46W67OB52xgiu
         11CPoviVXc6EyBko5XT5fco58Ed+gRRHsQCHPpI+/VBeo/YsPQ9Nqsp4iMzHbrS9i3nl
         mVo43fdAvuvBjOkxSOdoU7jJx59LNZ6wNurYM5MJ9Hr0KBkeQ9tj0f1sRY0zJrD6dvMv
         YuZqHjE3wrH8WpqW0EZv+1oB6Ywa2lLkypgstvZ74RaKy8uam1NhqyM443IgImIdlE+s
         xLYA==
X-Gm-Message-State: AOAM531Bh8CpI1nm+jaAqQvCdSoGMe7AiwymxEinqng5AwcOhcH2XuQi
        +litt9LuBcD53NbwW6j34vrRwd6yxrM=
X-Google-Smtp-Source: ABdhPJzaXyLqc9LGIGZZ0X+2cVMG5q4bA4joIE0G1sjVHAYtPKe19e3qhXZKrHz4zpJSfPstsB49oxJ0V/4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:6115:: with SMTP id v21mr6954932ybb.462.1633738275190;
 Fri, 08 Oct 2021 17:11:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 17:11:05 -0700
In-Reply-To: <20211009001107.3936588-1-seanjc@google.com>
Message-Id: <20211009001107.3936588-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211009001107.3936588-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 2/4] KVM: VMX: Unregister posted interrupt wakeup handler on
 hardware unsetup
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

Unregister KVM's posted interrupt wakeup handler during unsetup so that a
spurious interrupt that arrives after kvm_intel.ko is unloaded doesn't
call into freed memory.

Fixes: bf9f6ac8d749 ("KVM: Update Posted-Interrupts Descriptor when vCPU is blocked")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c8b2b6e7ed9..bfdcdb399212 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7553,6 +7553,8 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 
 static void hardware_unsetup(void)
 {
+	kvm_set_posted_intr_wakeup_handler(NULL);
+
 	if (nested)
 		nested_vmx_hardware_unsetup();
 
@@ -7881,8 +7883,6 @@ static __init int hardware_setup(void)
 		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
-	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
-
 	kvm_mce_cap_supported |= MCG_LMCE_P;
 
 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
@@ -7906,6 +7906,9 @@ static __init int hardware_setup(void)
 	r = alloc_kvm_area();
 	if (r)
 		nested_vmx_hardware_unsetup();
+
+	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
+
 	return r;
 }
 
-- 
2.33.0.882.g93a45727a2-goog

