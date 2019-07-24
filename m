Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C436172B9C
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 11:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfGXJnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 05:43:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34492 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfGXJnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 05:43:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so14722533pgc.1;
        Wed, 24 Jul 2019 02:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dfGfB3xwwf3iQZ8pUv1Cce8BeLxDLL9fV/CFtRrfuaU=;
        b=TbGLMcMIOmm+LtHtnas4F9H/XOneNA7H5ua3fknsao5aQPVc7pNzn/HHb6FQZFQTex
         419/Z8qJ6swsZgE6Bl0WzbCMIB9etUZPgjqOgQyt8m0S6jIrNYsd23gli3uwV8aHL1Gc
         bW0iWhhi9Rz9wkn998rGGla8JsywPVNYKWm33aSaJujOzTnQ5yBZXHTnXIIt/CUakOq3
         xgIPR0mTH4ZnguwR1hhZqVNh9umXepJa588iKGy2g2lTcO4LyOnfpNmuxteJx/HPCBqX
         c+0gj6xb0FU2VZXa7uPmam9yVFRw10yCk+ZfdLuBGJHp3+aPV+0ugDi/ma1wJcN//3Jf
         cY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dfGfB3xwwf3iQZ8pUv1Cce8BeLxDLL9fV/CFtRrfuaU=;
        b=IDB5L/l7G3lbDA5wFj+GooeL+o647nIlp5vPvzJzMCkfQdIZxDXdQ/x+6oN4KyfhmO
         2qhiU0f6J0UAc4CulPnkYL4XzERrIyHVdVNZuxQAGVolPC6mRWcJrjZXpu2fkOPuyJrL
         hMe/gy2OAHIh1Gj3pqG78Yr61/hLGo1U4SMLcnHF1PMhdivTLVXfVD0FqjHByoQkVC7H
         8MwBPm2d66DTETe45a7Q+x5wCJhJl2Dq/0VZ8IeLe6Eym3pD6uzldyeCr4vGAonD2o8Y
         DYBMQewk7nrxYcrplIs+Y/+cbzWfJSF90Xdy6C9i+yMB++JZvrf24rMRTPm6YqeTdM/9
         8a5A==
X-Gm-Message-State: APjAAAWNrNRgACsuyckA7+O7ZWcqRRP/fb8dBJjySKDVoneP5i1z6e2B
        rhiJHWOGtuAOJDOGJqHJTJ3UDuz2Dyk=
X-Google-Smtp-Source: APXvYqxoKsM5gyvJ5hPl4B1K+JyJhCr20cKUNHQXvVSTIIHVYMjxT2XeJLcsE7cvSoMk8shTsz+mZQ==
X-Received: by 2002:a63:58c:: with SMTP id 134mr84192409pgf.106.1563961398634;
        Wed, 24 Jul 2019 02:43:18 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id o3sm86318789pje.1.2019.07.24.02.43.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 24 Jul 2019 02:43:18 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption
Date:   Wed, 24 Jul 2019 17:43:13 +0800
Message-Id: <1563961393-10301-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit 11752adb (locking/pvqspinlock: Implement hybrid PV queued/unfair locks)
introduces hybrid PV queued/unfair locks 
 - queued mode (no starvation)
 - unfair mode (good performance on not heavily contended lock)
The lock waiter goes into the unfair mode especially in VMs with over-commit
vCPUs since increaing over-commitment increase the likehood that the queue 
head vCPU may have been preempted and not actively spinning.

However, reschedule queue head vCPU timely to acquire the lock still can get 
better performance than just depending on lock stealing in over-subscribe 
scenario.

Testing on 80 HT 2 socket Xeon Skylake server, with 80 vCPUs VM 80GB RAM:
ebizzy -M
             vanilla     boosting    improved
 1VM          23520        25040         6%
 2VM           8000        13600        70%
 3VM           3100         5400        74%

The lock holder vCPU yields to the queue head vCPU when unlock, to boost queue 
head vCPU which is involuntary preemption or the one which is voluntary halt 
due to fail to acquire the lock after a short spin in the guest.

Cc: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01e18ca..c6d951c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7206,7 +7206,7 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
 
 	rcu_read_unlock();
 
-	if (target)
+	if (target && READ_ONCE(target->ready))
 		kvm_vcpu_yield_to(target);
 }
 
@@ -7246,6 +7246,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		break;
 	case KVM_HC_KICK_CPU:
 		kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
+		kvm_sched_yield(vcpu->kvm, a1);
 		ret = 0;
 		break;
 #ifdef CONFIG_X86_64
-- 
2.7.4

