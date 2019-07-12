Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C046B6678D
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 09:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfGLHPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 03:15:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38831 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfGLHPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 03:15:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id z75so4124779pgz.5;
        Fri, 12 Jul 2019 00:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=plx8G9KjIRkO9jPdKCCYg4fdY7Z/wFDK5+GicbywqU8=;
        b=VFej0D2SY2b0aJzuxn4i5qL4rCyfbMzLnd4yft2sxUqn7/W2P89+AJGX+FnPJnvsT0
         irWkaWdDMW44DbJLfgBR5O9nXuorUvZ6Ww6B1FPbwW9+iTf++esQLhqzCcfx/wtKT+9U
         zR7ZitX0lkbLSuxkeDbruoHLg7luCGcjO2ZcxWHCSCjsb0nHYZ1fp6507EjC4sknX/Xr
         HtF8HpTBgGvApSGSVe8JopMZx7aVXAT6+EbPjo0cQYnnYL63O9jWXvCHiCW7Do5SRHno
         iu6Syf+q87bnUAFEh4iL0PSZwYEGjFP416k/Cvr5uhN6X5hMhFh5VHRjiKFESfK8nPi8
         ozlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=plx8G9KjIRkO9jPdKCCYg4fdY7Z/wFDK5+GicbywqU8=;
        b=epqhc3WF3YRUD/dwrJBsUBJALbfuE8xfp6JgvfNZeEh5K+WR++ODFcWyIxGgSjSZWm
         mp6eJUTMmV4m5vdi2UFacRbXVbMGdEDFt55IDGPSZjDjrxJePa17s4Wg8hhXfil+Ivyi
         uFYOXryNQCpIZvUqLeWR3d5gEAK49YgZ9lwcigoXtbper+EI1zqXnL/M46xYUxGV+XZV
         qfTJNnpCbUSw8QSA7GxCODKQYOFNlX4NOVKwft0hgxTO9ekjjxPkV2C9WuTEKWtEyA+a
         NkjXxzcmxvbEOUl9oQpL/JHIr6iQuVMB9qQdXbwWTT7nlTWVMjAzITgS5t1VJFwubiTN
         UloA==
X-Gm-Message-State: APjAAAX8apj7vPOJPG8rpvcgZzs+jPm7FlsFOaZ2XXpIp172cg8KH84Y
        XMPK3D5i5QcBTJSSrJuraVAo2n/sHz8=
X-Google-Smtp-Source: APXvYqzFAKB2xsc1Z5Am6M03j3zFHDBf7PUfG1clved6rBmUAlipS3m6vkYlbCwEd15othE1pQ+XCQ==
X-Received: by 2002:a63:61c6:: with SMTP id v189mr3550132pgb.36.1562915734841;
        Fri, 12 Jul 2019 00:15:34 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 135sm7412600pfb.137.2019.07.12.00.15.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 12 Jul 2019 00:15:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH RESEND] KVM: Boosting vCPUs that are delivering interrupts
Date:   Fri, 12 Jul 2019 15:15:30 +0800
Message-Id: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
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
This patch sets preempted flag during wakeup and interrupt delivery time.

Testing on 80 HT 2 socket Xeon Skylake server, with 80 vCPUs VM 80GB RAM:
ebizzy -M

            vanilla     boosting    improved
1VM          23000       21232        -9%                      
2VM           2800        8000       180%
3VM           1800        3100        72%

Testing on my Haswell desktop 8 HT, with 8 vCPUs VM 8GB RAM, two VMs, 
one running ebizzy -M, the other running 'stress --cpu 2':

w/ boosting + w/o pv sched yield(vanilla)   

            vanilla     boosting   improved 
              1570         4000       55%

w/ boosting + w/ pv sched yield(vanilla)

            vanilla     boosting   improved 
              1844         5157       79%   

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
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b4ab59d..2c46705 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2404,8 +2404,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	int me;
 	int cpu = vcpu->cpu;
 
-	if (kvm_vcpu_wake_up(vcpu))
+	if (kvm_vcpu_wake_up(vcpu)) {
+		vcpu->preempted = true;
 		return;
+	}
 
 	me = get_cpu();
 	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
-- 
2.7.4

