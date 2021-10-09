Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E84427848
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 11:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244345AbhJIJLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Oct 2021 05:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244346AbhJIJLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Oct 2021 05:11:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBE5C061570;
        Sat,  9 Oct 2021 02:09:49 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so11009374pjb.5;
        Sat, 09 Oct 2021 02:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5PJU+XU0vlN8es5a+TrRvmtFB7fFaJwsggeevnxxFGI=;
        b=QPbUET5GeEqznIKylk2KRY06RBqPOq7UCQEdiK3Sxrtyr82B2BrmGZASKYfWJfulGk
         jcLi/LwTgZUYVuz3aGLZjkXqvQQY2QesvS+334iuzDPRgOFyRzhKBZBM4vu34BMCV5ru
         h2mxSPvWLSENDLqaODvFjY69+798kY/WF0i3PJZHIzBAAk++SjBfpCMFBOaoBD+YZVSt
         02U9kFDvEmbnYeWklbuy8CdKDMnn9k4byH4tw7lPoFbSILpcAlXEHWB6iRoXx9L0PUzB
         Oc5XEbM7qJK5Tgi5vdpKRUQ1uLPHIdhKQHgTSnVrDeQs3MgG80MzZJBnrQWxT6wvzcKY
         mzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5PJU+XU0vlN8es5a+TrRvmtFB7fFaJwsggeevnxxFGI=;
        b=Fvh3OO5BO7e54hfTk2YDakGAO8HiHzvep0AXIYuOxCMs4aFZUOsQ9v3T0M1yi+mcKj
         WKhlPneSBbYy5Ab4Z1WuIUqKhNxNRj1slLYXP//goPN+hrTTNixlFNtVP3YFgvT65Lgv
         iY48snrpE0tHexpORltAnDmEBBKnODf6LF1ucqydlqRZNu+62Qvi2uHbvAwqyRLbUKrN
         qhFX9iciQQOghL9JRfXK2kYdtB9ebfDKtpBQqeAkZaT6sQdRJPq7kyCDge2+zRIFvZmN
         DyxSpDwBes5fFctcBGdpkK8Pm7efzYfIz84H333S7X6WB8s5hEetepJvsn89qFqXFHck
         O+PQ==
X-Gm-Message-State: AOAM531DT+GdhlNKMhrdZs+N8RDrbmXST3oMyii2CnHTtuJISiO92LeH
        KrRX8jC7Zk1kzOcAAM2AjAHxEjstUkz1ag==
X-Google-Smtp-Source: ABdhPJwQcthW8ZkvjiBpCHPmuvllL38jBJtdQzwcAhzvKHHO8zwhhD9YykNmHIH1l/hT2ICDNe5HEA==
X-Received: by 2002:a17:90a:181:: with SMTP id 1mr17121215pjc.214.1633770588627;
        Sat, 09 Oct 2021 02:09:48 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.googlemail.com with ESMTPSA id u2sm13607217pji.30.2021.10.09.02.09.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Oct 2021 02:09:48 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 3/3] KVM: vCPU kick tax cut for running vCPU 
Date:   Sat,  9 Oct 2021 02:08:52 -0700
Message-Id: <1633770532-23664-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1633770532-23664-1-git-send-email-wanpengli@tencent.com>
References: <1633770532-23664-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Sometimes a vCPU kick is following a pending request, even if @vcpu is 
the running vCPU. It suffers from both rcuwait_wake_up() which has 
rcu/memory barrier operations and cmpxchg(). Let's check vcpu->wait 
before rcu_wait_wake_up() and whether @vcpu is the running vCPU before 
cmpxchg() to tax cut this overhead.

We evaluate the kvm-unit-test/vmexit.flat on an Intel ICX box, most of the 
scores can improve ~600 cpu cycles especially when APICv is disabled.

tscdeadline_immed
tscdeadline
self_ipi_sti_nop
..............
x2apic_self_ipi_tpr_sti_hlt

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * move checking running vCPU logic to kvm_vcpu_kick
 * check rcuwait_active(&vcpu->wait) etc

 virt/kvm/kvm_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7851f3a1b5f7..18209d7b3711 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3314,8 +3314,15 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
 	int me, cpu;
 
-	if (kvm_vcpu_wake_up(vcpu))
-		return;
+	me = get_cpu();
+
+	if (rcuwait_active(&vcpu->wait) && kvm_vcpu_wake_up(vcpu))
+		goto out;
+
+	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
+		WARN_ON_ONCE(vcpu->mode == IN_GUEST_MODE);
+		goto out;
+	}
 
 	/*
 	 * Note, the vCPU could get migrated to a different pCPU at any point
@@ -3324,12 +3331,12 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
 	 * vCPU also requires it to leave IN_GUEST_MODE.
 	 */
-	me = get_cpu();
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
 		cpu = READ_ONCE(vcpu->cpu);
 		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
 	}
+out:
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
-- 
2.25.1

