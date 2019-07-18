Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E7E6CD79
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 13:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfGRLjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 07:39:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44210 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfGRLjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 07:39:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so13722078plr.11;
        Thu, 18 Jul 2019 04:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmxGcGhhhPgISj08dbFbh46iPwYGrMKIu9SeI7KQRpY=;
        b=CuDFDNHQVLkTwYCuN4InUnJUAMEXhqoQxlPt9ex9Hti+TJuifdje7dzehm+92qgO0r
         uqjEiKOxSvMQ4Z0jo8CpzMX/LPMbilIPW3pZhFy5vlKb2iDafMG2eCB+vLDg4dxGg8Se
         Ldhj7VrwvGLzPZ7j73GH113S9a5QqDXpPwy5cjxw9SmAvq6pQU0Sf2OkcET//xai6u3d
         blfU7eGRjoz2YzMqnx82dQuIrSRmOAUOca0nRMNo2t2caDW6HEIc8hyKxrhVFpWLw+N5
         58p8WjVe1VmWm7QLa7fH4pcvDt0I+PynXd7UklGS3MpPqsmHcbGDdH/VORpQT6EisbDe
         hwFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmxGcGhhhPgISj08dbFbh46iPwYGrMKIu9SeI7KQRpY=;
        b=L23ZrRWQs0x6GCVzfEDvDrpDWUleQ8YPjNZSGs+aj5z6eaRh83aPX5nxk4Ibp02RSp
         OM+kD5TPKSIL4+Y+uEKy356RnuBE8cCS7VQSEgRaB8xSflXPYdF2ShWFV9hUK03hxgvM
         eXbW8AtI4UbixIHiESq1mp9aclbCoSfFsfMNhvr7ZewTLrMAUW792OO83nbAJlJ6IumA
         YngV5RP9MuTWV3+SKm1eTI6mhYaVMiRTrc9a+NxpxBMOCr1Am4nt+vgdMpWhTwq0g628
         m4rFLjHSwaOrz89h6usP5v29OgJffRFiZerz9vQydZUIOLMMgcTX1HcqZ4O2Hgmd5B1P
         FK7w==
X-Gm-Message-State: APjAAAXOlTg9XTemiRfexG8aQtHPeibEiJmc0WY6OS6GQqB1DtHlav3y
        AKf4woozyIOOFRNO5RStqdugRg7D5d4=
X-Google-Smtp-Source: APXvYqxLC4gzsgo2wx1PJJ+ObDrzz9h8I6f5ofIvI45cg0CcrS8JSHSajBOGak9Wcm+1AaSfVQ768A==
X-Received: by 2002:a17:902:7087:: with SMTP id z7mr49036394plk.184.1563449953088;
        Thu, 18 Jul 2019 04:39:13 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id f15sm11908581pgu.2.2019.07.18.04.39.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 18 Jul 2019 04:39:12 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH v2 1/2] KVM: Boosting vCPUs that are delivering interrupts
Date:   Thu, 18 Jul 2019 19:39:06 +0800
Message-Id: <1563449947-7749-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Inspired by commit 9cac38dd5d (KVM/s390: Set preempted flag during vcpu wakeup 
and interrupt delivery), except the lock holder, we want to also boost vCPUs 
that are delivering interrupts. Actually most smp_call_function_many calls are 
synchronous ipi calls, the ipi target vCPUs are also good yield candidates. 
This patch introduces vcpu->ready to boost vCPUs during wakeup and interrupt 
delivery time.

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
---
 arch/s390/kvm/interrupt.c |  2 +-
 include/linux/kvm_host.h  |  1 +
 virt/kvm/kvm_main.c       | 12 +++++++++---
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 9dde4d7..26f8bf4 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1240,7 +1240,7 @@ void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu)
 		 * The vcpu gave up the cpu voluntarily, mark it as a good
 		 * yield-candidate.
 		 */
-		vcpu->preempted = true;
+		vcpu->ready = true;
 		swake_up_one(&vcpu->wq);
 		vcpu->stat.halt_wakeup++;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c5da875..5c5b586 100644
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
index b4ab59d..8412900 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2404,8 +2404,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	int me;
 	int cpu = vcpu->cpu;
 
-	if (kvm_vcpu_wake_up(vcpu))
+	if (kvm_vcpu_wake_up(vcpu)) {
+		vcpu->ready = true;
 		return;
+	}
 
 	me = get_cpu();
 	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
@@ -2500,7 +2502,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			} else if (pass && i > last_boosted_vcpu)
 				break;
-			if (!READ_ONCE(vcpu->preempted))
+			if (!READ_ONCE(vcpu->ready))
 				continue;
 			if (vcpu == me)
 				continue;
@@ -4205,6 +4207,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 
 	if (vcpu->preempted)
 		vcpu->preempted = false;
+	if (vcpu->ready)
+		vcpu->ready = false;
 
 	kvm_arch_sched_in(vcpu, cpu);
 
@@ -4216,8 +4220,10 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	if (current->state == TASK_RUNNING)
+	if (current->state == TASK_RUNNING) {
 		vcpu->preempted = true;
+		vcpu->ready = true;
+	}
 	kvm_arch_vcpu_put(vcpu);
 }
 
-- 
2.7.4

