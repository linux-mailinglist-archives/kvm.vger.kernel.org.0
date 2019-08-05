Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595BC81022
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 04:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfHECDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Aug 2019 22:03:38 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45417 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbfHECDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Aug 2019 22:03:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so38824266pgp.12;
        Sun, 04 Aug 2019 19:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8vRU7XOXMncH2HX3CBvpyWbhKeVRVshARm7btXYP42w=;
        b=JRkjiLqhPiQzvIKEiCqljsdkL9L0PLKJGD0M8FGiSEQyGD+ayKEZ1oT7QXiCZFYHee
         11YGuCpYCC6khFTJMikwh8WVdxpDp8RPH3UCmQX5RNukpM62vOyZS/JlrSYBauHjkbI4
         ThhsMYl3X2EeTzmjEVV1jbSEz/RGq1kvDR3IcbnbmhmzBYr4MlWfX8lMILYtL3urNZ6v
         5T0IEg7vk3JVIckFDPvX1DR1i/ngxbrIKITnakd7yN0ctRDNZ/UXgiUaTgqQ0KemY0sI
         s/UgfztHXULBduVkloiO3K0ih2YFU/b8D8hrcWR9ZJdxdJJedNKudUKhkzSth7mLDLAF
         4QQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8vRU7XOXMncH2HX3CBvpyWbhKeVRVshARm7btXYP42w=;
        b=HYDXeY2IQHdkPCvCHQcws5ySpKdRohTsC3DPcYLtRo5rowoli++bH/73sK2kh49sTJ
         YUkEF6vxo6iePoaY28acGQNeGKY3ebBunqYIuz3ymaZC9O2pgKmQ12q31VD6zytnkL28
         USmMPIWRDYXBxwTL1NV32j8rfwzGJ0iIcadjsjQZZCRNUmy2vvCgnIPTQHpMuhbwOF3p
         s4Dha3frmoNjR0fY/0H+y2dG5PQlTb0KM5G64n93hsTlaZJoSJ1Q9NZNZMf3aZgyanHU
         HHyC0cjycK/oHV2Ap5sMcsrxK/GWEKLvYRCVQmPlOMUcgQTN5rmfBHlR4cYDc571Qtf2
         9mTg==
X-Gm-Message-State: APjAAAUfsGrTn663v1ZHPfCpT4BzDCiN2//AW7kOM6W7iWa/RtZEfJtV
        ac/KrV60dOdTrMPIIPSe8vavHbc9
X-Google-Smtp-Source: APXvYqysH9UkVdeV7dX871CfGOlNrU5gaJfRp3C10inbQrUR5nPcAsJ8RE+ytIeCd/Eih61gHq03dQ==
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr15787587pjs.119.1564970616325;
        Sun, 04 Aug 2019 19:03:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id o32sm14739365pje.9.2019.08.04.19.03.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 19:03:35 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v4 3/6] KVM: Check preempted_in_kernel for involuntary preemption
Date:   Mon,  5 Aug 2019 10:03:21 +0800
Message-Id: <1564970604-10044-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
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
index e121423..2ae9e84 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2522,7 +2522,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (swait_active(&vcpu->wq) && !vcpu_runnable(vcpu))
 				continue;
-			if (yield_to_kernel_mode && !kvm_arch_vcpu_in_kernel(vcpu))
+			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
+				!kvm_arch_vcpu_in_kernel(vcpu))
 				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;
@@ -4219,7 +4220,7 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	vcpu->preempted = false;
+	WRITE_ONCE(vcpu->preempted, false);
 	WRITE_ONCE(vcpu->ready, false);
 
 	kvm_arch_sched_in(vcpu, cpu);
@@ -4233,7 +4234,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
 	if (current->state == TASK_RUNNING) {
-		vcpu->preempted = true;
+		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
 	}
 	kvm_arch_vcpu_put(vcpu);
-- 
2.7.4

