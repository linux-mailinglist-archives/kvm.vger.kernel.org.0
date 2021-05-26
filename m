Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7A53918FE
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhEZNjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbhEZNjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 09:39:10 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCD7C061574;
        Wed, 26 May 2021 06:37:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ot16so796072pjb.3;
        Wed, 26 May 2021 06:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gMhAQHiplLiJbjthLmFNsQo2WbujDec9IhjCf/s10ww=;
        b=LxDpw3yj7NxEWH+NZlve5IE+SFKmlgJ4RxbLkt6twITjjI2M5LoSVxK3SaQPrfECVl
         Ps59RV3T8ildfCGjQ27jF1Zt1Q0s7z/y6hJR0rJUdF5+O20CvibckIpq47OxjDz0tdbm
         aANZiccjMJT2f6w2nPXImHuTOJOy1yj8KcUcd5+5naFe3JgaKt3Ykvr00kLhDVgbXCXS
         YsXQUuBNJSj4Rw4vq8Ps4Z2AWPiOFBKJ5H1okzAk7FkiJV/EVQ+nrN0PwjpVj38fpcTN
         Uz5ck5MO3EZvMKoRbMX4GTOXnfQPT5Ubwh0eAK0t7A9I+myNg1fBJPRzV7MiWm0JapiO
         oFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gMhAQHiplLiJbjthLmFNsQo2WbujDec9IhjCf/s10ww=;
        b=tWCgBszKY4+IfGZ3kwcbq5bJVrot8NTmdx2LJ4+4BXuEDm07NU66ARW4EL83dkri+G
         0ptRTTsw5T4c4c+u7YEpjXU9WsdgSKcWHm16im8sEp05uUm2SqCVSW2f87k2qqtpH56/
         VjESrVClzivIKZYr/sPZoSFUDclHEF5Rfu6Dmb9q5jzp5L5c4daVEW/+kBxNq299yvz/
         R+FWwKCGM/sDma1lj7MAhxWzZb6eFZ2Oy+Z5WCUFwfG9PmabVyakyR09TXjl0Bh560vO
         pTUmwashWH8fmfJAbYXmkz4phbGy+0HHvrTi76j44UIz/2xsTBAn/BCuzW8B7RkKp2DW
         bEfA==
X-Gm-Message-State: AOAM530/jcbtnhjOl82TWFbDmQextxZC+JjfvkxUucmjaJ9upY1MrY7a
        AL7DDhhRgY1ss1woUC9Td5w=
X-Google-Smtp-Source: ABdhPJzqD2dcPWwdZIXhe4s5KBvjolOz/RjtPBS5ZU8qMOPzwD9kySvUM/UqzRYSxwnFdspEepOp0Q==
X-Received: by 2002:a17:90b:607:: with SMTP id gb7mr35200858pjb.5.1622036258946;
        Wed, 26 May 2021 06:37:38 -0700 (PDT)
Received: from localhost ([133.11.45.40])
        by smtp.gmail.com with ESMTPSA id z6sm239897pgp.89.2021.05.26.06.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 06:37:38 -0700 (PDT)
From:   Masanori Misono <m.misono760@gmail.com>
To:     David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rohit Jain <rohit.k.jain@oracle.com>
Cc:     Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Masanori Misono <m.misono760@gmail.com>
Subject: [PATCH RFC 1/1] KVM: x86: Don't set preempted when vCPU does HLT VMEXIT
Date:   Wed, 26 May 2021 22:37:27 +0900
Message-Id: <20210526133727.42339-2-m.misono760@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526133727.42339-1-m.misono760@gmail.com>
References: <20210526133727.42339-1-m.misono760@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change kvm_arch_cpu_put() so that it does not set st->preempted as 1
when a vCPU does HLT VMEXIT. As a result, is_vcpu_preempted(vCPU) becomes
0, and the vCPU becomes a candidate for CFS load balancing.

Signed-off-by: Masanori Misono <m.misono760@gmail.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04e67ad..b3f50b9f2e96 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4170,19 +4170,26 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
+	bool hlt;
 
 	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
 		vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
 
+	hlt = lapic_in_kernel(vcpu) ?
+		      vcpu->arch.mp_state == KVM_MP_STATE_HALTED :
+		      vcpu->run->exit_reason == KVM_EXIT_HLT;
+
 	/*
 	 * Take the srcu lock as memslots will be accessed to check the gfn
 	 * cache generation against the memslots generation.
 	 */
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (kvm_xen_msr_enabled(vcpu->kvm))
-		kvm_xen_runstate_set_preempted(vcpu);
-	else
-		kvm_steal_time_set_preempted(vcpu);
+	if (!hlt) {
+		if (kvm_xen_msr_enabled(vcpu->kvm))
+			kvm_xen_runstate_set_preempted(vcpu);
+		else
+			kvm_steal_time_set_preempted(vcpu);
+	}
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
-- 
2.31.1

