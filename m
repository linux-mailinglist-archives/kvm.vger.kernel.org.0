Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055FE6CEFD
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 15:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390482AbfGRNhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 09:37:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40028 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390440AbfGRNhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 09:37:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so25751944wmj.5;
        Thu, 18 Jul 2019 06:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XD5tmOgtPa7vXNP63daYHuxPI1sQd31xndlVFa2zPOs=;
        b=vEUl21v1PpifJYDeS8/e5yge+7xRpK6GIcxB+QlfShB9kaDtHThqUb9uQJLTK5ywPp
         b/RNrKRCkd22d6LZuCOm7fwPELBJhJ4n2ih7bpte6imsZGm3nGis3DsC7kINj9DZ+5Yx
         L6z3LtuuCcGMsp9lBcsRCZ502RbKauEzDmmZMkowh11eonmRYoTK9EA/MN2MSn4RcOep
         /9icXH2YIdY2stwDNNbhYuRbzmy5GWTpVovI0gyWELN8OilQ4Ot/lQAg6r3Uf0AEWXCn
         OiyRV7HM82nid27xGoYY1/iu13Mfpv3ulqD8wQnPm67vqO22lwH21LE4JZUaKv1utvfH
         kQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=XD5tmOgtPa7vXNP63daYHuxPI1sQd31xndlVFa2zPOs=;
        b=NX7KJqJps69j/7t699X9xM9XT04k139jVKXwQxPgCcnRt/to2w9wAfBJbVAWic7wdT
         T173UIWDPjOJs746eSZ3s2BvXos3CtA4kaPjJxhIl/JOhavPVX6s/i/9R8eIS4lJctJV
         /B+MOmklee35fROjWkuRdGZ+/CV7Ud/7IKyQ8SrxF9FTtiRGN518h3ar4uVte1t/4iu+
         cCSLEPIswnFopJBXfws075uHF9ymdNduyacZz/A2F10uy+kEcm5kTDUJh7GXTpoMWkhP
         3ij0p1LtNM6AVRy2VKwxkosWl3l9QFsW62q5IbYcMF9k6B5aEnKlLox8F9fm/i3Glo1D
         COCw==
X-Gm-Message-State: APjAAAUzbVE6mBaBG8LjPS+GOtCijqX0qvTgHAV75lyt8hcAf1Fx7qLa
        7OXSXMKWtRfGRopP06r81eW1hgHbhFQ=
X-Google-Smtp-Source: APXvYqxQDaBP4QmjYsA155mTv91AjV/8hr5rDrF53DiFJdR7dj+suGS9AFgWZQ3tEk45e0Y/R/oBFw==
X-Received: by 2002:a1c:f408:: with SMTP id z8mr17233015wma.97.1563457034371;
        Thu, 18 Jul 2019 06:37:14 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t185sm20479790wma.11.2019.07.18.06.37.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 06:37:13 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, rkrcmar@redhat.com, borntraeger@de.ibm.com,
        paulus@ozlabs.org, maz@kernel.org
Subject: [PATCH 1/2] KVM: Boost vCPUs that are delivering interrupts
Date:   Thu, 18 Jul 2019 15:37:10 +0200
Message-Id: <1563457031-21189-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1563457031-21189-1-git-send-email-pbonzini@redhat.com>
References: <1563457031-21189-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Inspired by commit 9cac38dd5d (KVM/s390: Set preempted flag during
vcpu wakeup and interrupt delivery), we want to also boost not just
lock holders but also vCPUs that are delivering interrupts. Most
smp_call_function_many calls are synchronous, so the IPI target vCPUs
are also good yield candidates.  This patch introduces vcpu->ready to
boost vCPUs during wakeup and interrupt delivery time; unlike s390 we do
not reuse vcpu->preempted so that voluntarily preempted vCPUs are taken
into account by kvm_vcpu_on_spin, but vmx_vcpu_pi_put is not affected
(VT-d PI handles voluntary preemption separately, in pi_pre_block).

Testing on 80 HT 2 socket Xeon Skylake server, with 80 vCPUs VM 80GB RAM:
ebizzy -M

            vanilla     boosting    improved
1VM          21443       23520         9%
2VM           2800        8000       180%
3VM           1800        3100        72%

Testing on my Haswell desktop 8 HT, with 8 vCPUs VM 8GB RAM, two VMs,
one running ebizzy -M, the other running 'stress --cpu 2':

w/ boosting + w/o pv sched yield(vanilla)

            vanilla     boosting   improved
              1570         4000      155%

w/ boosting + w/ pv sched yield(vanilla)

            vanilla     boosting   improved
              1844         5157      179%

w/o boosting, perf top in VM:

 72.33%  [kernel]       [k] smp_call_function_many
  4.22%  [kernel]       [k] call_function_i
  3.71%  [kernel]       [k] async_page_fault

w/ boosting, perf top in VM:

 38.43%  [kernel]       [k] smp_call_function_many
  6.31%  [kernel]       [k] async_page_fault
  6.13%  libc-2.23.so   [.] __memcpy_avx_unaligned
  4.88%  [kernel]       [k] call_function_interrupt

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v2->v3: put it in kvm_vcpu_wake_up, use WRITE_ONCE

 arch/s390/kvm/interrupt.c | 2 +-
 include/linux/kvm_host.h  | 1 +
 virt/kvm/kvm_main.c       | 9 +++++++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 9dde4d7d8704..26f8bf4a22a7 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1240,7 +1240,7 @@ void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu)
 		 * The vcpu gave up the cpu voluntarily, mark it as a good
 		 * yield-candidate.
 		 */
-		vcpu->preempted = true;
+		WRITE_ONCE(vcpu->ready, true);
 		swake_up_one(&vcpu->wq);
 		vcpu->stat.halt_wakeup++;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c5da875f19e3..5c5b5867024c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -318,6 +318,7 @@ struct kvm_vcpu {
 	} spin_loop;
 #endif
 	bool preempted;
+	bool ready;
 	struct kvm_vcpu_arch arch;
 	struct dentry *debugfs_dentry;
 };
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b4ab59dd6846..65665e13ab9a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2387,6 +2387,7 @@ bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 	wqp = kvm_arch_vcpu_wq(vcpu);
 	if (swq_has_sleeper(wqp)) {
 		swake_up_one(wqp);
+		WRITE_ONCE(vcpu->ready, true);
 		++vcpu->stat.halt_wakeup;
 		return true;
 	}
@@ -2500,7 +2501,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			} else if (pass && i > last_boosted_vcpu)
 				break;
-			if (!READ_ONCE(vcpu->preempted))
+			if (!READ_ONCE(vcpu->ready))
 				continue;
 			if (vcpu == me)
 				continue;
@@ -4205,6 +4206,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 
 	if (vcpu->preempted)
 		vcpu->preempted = false;
+	if (vcpu->ready)
+		WRITE_ONCE(vcpu->ready, false);
 
 	kvm_arch_sched_in(vcpu, cpu);
 
@@ -4216,8 +4219,10 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	if (current->state == TASK_RUNNING)
+	if (current->state == TASK_RUNNING) {
 		vcpu->preempted = true;
+		WRITE_ONCE(vcpu->ready, true);
+	}
 	kvm_arch_vcpu_put(vcpu);
 }
 
-- 
1.8.3.1


