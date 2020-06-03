Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A371ED9B1
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 01:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgFCX4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 19:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgFCX4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 19:56:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06292C08C5C2
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 16:56:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g15so5876127ybd.20
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 16:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wWCKn9ltRt9CYrTgEB7AQJne8Q4xu3HLXvC1DA8IJZ4=;
        b=j25/soJxvne6NJ038UhLzu8JuVaJc92KvjcTHVN/I4KSuhtnahS1BCw+nzwiH80bok
         5lAHV90oFFvqpjcJrVp39wAxxtwCOyqJGP+yTly712/uYsbHdShMhQeHgbl5YJmblXEU
         iZ1NBmWBQfxn8K0p18hogA3qr9zKAFeY2PIni2B+EQQNqwNUOXJkJ3hbM/O52kL8zf7b
         XHFQuxNCVcMUWfknJPEjmgLCpVKLI2HFj11XRv8QLhDkNTd/4vtpFdcTokP9SatCf7en
         U/7Vr4pesSLQuZXCbFSi74r502HcVtPIo5wPIGSzWhqbPn+/ndKSKczZyMeHSk+62PHt
         2Mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wWCKn9ltRt9CYrTgEB7AQJne8Q4xu3HLXvC1DA8IJZ4=;
        b=tucWGESH4W4RSZDp9nBMcmCn79e8lBdxL75Bg6DAeO19OsNmgMUj0Eh/oAT23iPOby
         N6nvKPbG/+sHqJ4AZkOvJLf5Rg70qHCwzkMdEPf2rLNMzcV2UzFOl7RMECb96f87X72z
         b6Mkc0EbhoV/Hqxy3ulEDG4BKdazDU/15swjbveQN/vcrUCNmTPjoNgH8bdfZQEcT8zF
         rzb95HWWflWNCiZSXWjr4Pd2ZndJQORUhfsXxy+LAqk4uPnT7H1lBO+qwV0a3lj979ri
         89dwWWb6m6Soe4EmUNqE/9GikAy7uzCqqr1VeacNHnHyL+BqdEAB4VFjOYOeFNtjt8gc
         T6YQ==
X-Gm-Message-State: AOAM533iSQQmziCS0wIEdzqOWC9iPa15YVhSD29iqOWU+HVa5ZP8Uud+
        BZRfC45XFBYOKQMm68YdZVfjafLhmONNAMSZ+wr5rMLtFqXOO7de7MLLMk16CiBBB3G6gT/oLGZ
        ZJ2VJfz3WoriFox5j+gA+VFeVKAtWQj5Er9A7Pj5g5wUwhE+TMg7JFfQzRrEAnis=
X-Google-Smtp-Source: ABdhPJwlSskV4yCjP0Vvs3LbCai0ydvI5Qz9RGoXWQk1eyV8XAO8EMMy3a0XEDariV+kGGFrVC9bNxSbQbtYeA==
X-Received: by 2002:a25:338b:: with SMTP id z133mr3899067ybz.329.1591228603191;
 Wed, 03 Jun 2020 16:56:43 -0700 (PDT)
Date:   Wed,  3 Jun 2020 16:56:23 -0700
In-Reply-To: <20200603235623.245638-1-jmattson@google.com>
Message-Id: <20200603235623.245638-7-jmattson@google.com>
Mime-Version: 1.0
References: <20200603235623.245638-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v4 6/6] kvm: x86: Set last_vmentry_cpu in vcpu_enter_guest
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since this field is now in kvm_vcpu_arch, clean things up a little by
setting it in vendor-agnostic code: vcpu_enter_guest. Note that it
must be set after the call to kvm_x86_ops.run(), since it can't be
updated before pre_sev_run().

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 arch/x86/kvm/vmx/vmx.c | 1 -
 arch/x86/kvm/x86.c     | 1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 78b64d1ab7b1..bc8223df698f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3396,7 +3396,6 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 562381073c40..c6eea58b5e66 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6736,7 +6736,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.cr2 != read_cr2())
 		write_cr2(vcpu->arch.cr2);
 
-	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
 				   vmx->loaded_vmcs->launched);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20c420a45847..512db3c39392 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8554,6 +8554,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (hw_breakpoint_active())
 		hw_breakpoint_restore();
 
+	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 
 	vcpu->mode = OUTSIDE_GUEST_MODE;
-- 
2.27.0.rc2.251.g90737beb825-goog

