Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE5B7BF3D
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 13:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387393AbfGaL12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 07:27:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36688 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaL1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 07:27:25 -0400
Received: by mail-pl1-f196.google.com with SMTP id k8so30376917plt.3;
        Wed, 31 Jul 2019 04:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VHS57PmtuwPLtfBLBbltEv6DFT+0iXK6WiNzQSWrzrE=;
        b=dSzE4VGKLVc5cptEp5NMZBvonc0E/Mbzeb3v3kZ2sxvS3MocB+Ey4AdqyrtDCd6y9v
         DCf8ngnHUtuo4l20ghiUhdYu6+Q/lyQ8YQWECVv7FndGXX5UKvoZVCitKN+DrOyJQWm7
         hgoAjRHZSDUtBTLnwIHv1IYkMXQylL7hCoaD0lRfZK7+eMPyoHp8kmoPJqKu0aVLbkCs
         /NrFg0TZLA5QR8NH12QCUVHuPdD+N3VDuDmGkAuwmA1WXBFBY/tacPzvhs0eoT2+l4I8
         1YsCb9omqhQgf5Hp95OJNL2jHAtRHp6lVTj/EndYIFZ8Fle7RoKtMaVvt1Ky2kxVKzAS
         +eug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VHS57PmtuwPLtfBLBbltEv6DFT+0iXK6WiNzQSWrzrE=;
        b=iEWWK25ljgyrrUkgef5PlzvgB8xX+Mur5wrq0dpoHxWY9Xtd0n0ZqqnAFzPvWVES71
         ByYxRhfRftT0ZjM76RSneEfPVGPk3rMczt2cABuB6lYYO/EgsFhjK0viv1scMmmRdnBX
         Nb1BDZ1KiNuzTvu3F1+dQOp6BcoTW7W7r5lFfQS0D2bOdR+vvYnXHfs9/H8LGwb86x6/
         DUT+zHU5dthM2nGCdXaoRi343MRywIIhD/nMBq1y2ZQ9aBZGY8egv2EqpHtvx8XAoFnZ
         fzKZVlokyGP5p0pjBN8F6QGnUc7ribH/2JaYCgTzXHBRgcRCCOVFkWVD/KKwFHNbOACM
         r3vw==
X-Gm-Message-State: APjAAAVp6rN/3ATY58vUtSMnQww+pBNVqXhbNU9iaV6P4N/WbUly5rtQ
        dZI5VTkisq+du019wif7fFgBhMj2Y8Y=
X-Google-Smtp-Source: APXvYqy2Umcofp2a7ba/gLc41pb58cmWuK120xoCrZgYeHsxJpEp44GERukISjQ4a835VZZtogc5YQ==
X-Received: by 2002:a17:902:ba8b:: with SMTP id k11mr119794439pls.107.1564572444762;
        Wed, 31 Jul 2019 04:27:24 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id e3sm1211441pgm.64.2019.07.31.04.27.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 31 Jul 2019 04:27:24 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/3] KVM: Check preempted_in_kernel for involuntary preemption
Date:   Wed, 31 Jul 2019 19:27:17 +0800
Message-Id: <1564572438-15518-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564572438-15518-1-git-send-email-wanpengli@tencent.com>
References: <1564572438-15518-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

preempted_in_kernel is updated in preempt_notifier when involuntary preemption 
ocurrs, it can be stale when the voluntarily preempted vCPUs are taken into 
account by kvm_vcpu_on_spin() loop. This patch lets it just check preempted_in_kernel 
for involuntary preemption.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 887f3b0..ed061d8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2508,7 +2508,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (swait_active(&vcpu->wq) && !kvm_arch_vcpu_runnable(vcpu))
 				continue;
-			if (yield_to_kernel_mode && !kvm_arch_vcpu_in_kernel(vcpu))
+			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
+				!kvm_arch_vcpu_in_kernel(vcpu))
 				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;
@@ -4205,7 +4206,7 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	vcpu->preempted = false;
+	WRITE_ONCE(vcpu->preempted, false);
 	WRITE_ONCE(vcpu->ready, false);
 
 	kvm_arch_sched_in(vcpu, cpu);
@@ -4219,7 +4220,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
 	if (current->state == TASK_RUNNING) {
-		vcpu->preempted = true;
+		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
 	}
 	kvm_arch_vcpu_put(vcpu);
-- 
2.7.4

