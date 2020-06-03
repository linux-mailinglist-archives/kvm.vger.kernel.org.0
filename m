Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810011ED9AD
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 01:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgFCX4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 19:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgFCX4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 19:56:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602D8C08C5C0
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 16:56:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u6so5899424ybo.18
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 16:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=esuDLQ5YIiqnB7jmaMDCOvaz2pEkozZla8OGqrKe1Bg=;
        b=aXFGHUo/LkSP/Cc2GO6tC0Bv96PpTh1D1HN8AHPF4R8/ZwhcFOS/Ni8pIg3XNGdKCb
         Kmr202XnPBORQensek1r3RgR8yBb+5sGaaQBFgcWmIc5rsm8wtZPn2JTihVieH9WXVkd
         UILUal53DbMV+WVEp+4ZEcfuApyP4adCIbbQjUo3Ro0Tu0YDw60TFZbCdzudgMA0bk5V
         YJnbGif7Qi1iR6eJTDouwrS0d3X3bC0KBOUNrD/v+lK7M4Gu910eK7GsjNpmhWR3zn/h
         Ti69vrb5xvStIUEzOdIWpX72dC378zkQsKdWr/wZfp8i753LRO/Hk4wnSLKfWTueSD6Y
         2RJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=esuDLQ5YIiqnB7jmaMDCOvaz2pEkozZla8OGqrKe1Bg=;
        b=Fdx5NVJMpD/3oeP2Zi1DMLr7ebLFyqj1cdPCKz3fZpPCQdfvfJwiu1lgjFOV8IQxW2
         W3GHateGOgLJj9doHOCufd8GXF6zIVRnrTyTg3zcvp4C8LmnQUgmwIy9sITm95q1t/D7
         8t9XylGbVYwr3kdIrf37asRo24yGWIp3sFBGa10DdEPxQ6eOL1CbkadTxw1Ev/2ZIhNr
         /Z1Pp12wxcZg2yAL2KzvOaUhg1CkbDluewDUhNTomeaqswf5ZUn6zAGuQokIOrNPwqY3
         T77HpN2a2uZkmhWieQVXBy0bCwAQBjysFfBEL1Odu2SSjuhuTrHdcLvn9FgFdNVc6Cx7
         lQWw==
X-Gm-Message-State: AOAM532KMDPDy4TGOSiU4PyOaNPxaGTPW4JI4m/ChzNHUjcI5aDmIPmS
        KziUdI2xefrwzJIfO2UxuVy1DW/CB2oia84LWoSzSCQen4bfiSHxPsUopemM8kvPG4v0gguuotI
        ib5b5wiSaLfm8DeKhWBZBYew5a0ActBw12upgqU7e08mr2ohQK+WD7aAVo0TvO4k=
X-Google-Smtp-Source: ABdhPJzkMMq27plk7U4783x4sWW7rNc08QIZuKAOEEwBlRRDy91TUc70pY5ySI0lrCDJMQMe9gx1sJrw4ikFfg==
X-Received: by 2002:a25:dd87:: with SMTP id u129mr4428129ybg.83.1591228596537;
 Wed, 03 Jun 2020 16:56:36 -0700 (PDT)
Date:   Wed,  3 Jun 2020 16:56:19 -0700
In-Reply-To: <20200603235623.245638-1-jmattson@google.com>
Message-Id: <20200603235623.245638-3-jmattson@google.com>
Mime-Version: 1.0
References: <20200603235623.245638-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v4 2/6] kvm: svm: Always set svm->last_cpu on VMRUN
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

Previously, this field was only set when using SEV. Set it for all
vCPU configurations, so that it can be communicated to userspace for
diagnosing potential hardware errors.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 -
 arch/x86/kvm/svm/svm.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 89f7f3aebd31..aa61d5d1e7f3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1184,7 +1184,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	    svm->last_cpu == cpu)
 		return;
 
-	svm->last_cpu = cpu;
 	sd->sev_vmcbs[asid] = svm->vmcb;
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	mark_dirty(svm->vmcb, VMCB_ASID);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f0dd481be435..442dbb763639 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3394,6 +3394,7 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
+	svm->last_cpu = vcpu->cpu;
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
 #ifdef CONFIG_X86_64
-- 
2.27.0.rc2.251.g90737beb825-goog

