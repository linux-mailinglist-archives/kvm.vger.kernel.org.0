Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305076677E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 09:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfGLHKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 03:10:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45667 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGLHKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 03:10:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id r1so3886649pfq.12;
        Fri, 12 Jul 2019 00:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=plx8G9KjIRkO9jPdKCCYg4fdY7Z/wFDK5+GicbywqU8=;
        b=eoWYo0hwuPniPy1VQBdQ+esk2rfgoQqZxdec/tuhyo13Bm3GDQFWP8eUxDLKDMqEXk
         eEoYaXYid8+336ZrFQ9T0t0F1vDYeTW79FtsT4RidrDDiju9ZSDWTGtyxhl8aAy0a9oJ
         iFWQYSkqXVAj2E+Nq5ssax5DLG0iwCLPlIQ+QXrzuQHGyUptSGT+bExBt8dsYLmJE6bB
         D2GNe8/eZrV0KpS0xchW6BZHQQpL6Vp0RhPJ6wAYrxzLw4UOp1luCJh89rm7Vmo7XKXY
         nxybTgZYbQ5xk+/I4HW2fTDLWdMMghBMO69b8DITOKpcSRxp+cE2iyPc5/EWBBqJXfDn
         35NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=plx8G9KjIRkO9jPdKCCYg4fdY7Z/wFDK5+GicbywqU8=;
        b=ic7XD/Wvfcdy7IyIOzWV00Kt6QDKkoZjkiDhkk/c91a262J5QQDSXtu4P6SFWia0Vd
         uBdLy/TUAXmNNYTZUcPPxfpUp81pnIby507Z6W7m/4VdhQXMX1dEZiptNhuV4m104PIG
         NXPGVNnxwCIKauAeXIytidEFoHQkLOeCmjyVDtMO2eQEkBRw2D8DSLmupc28auZOf4LE
         flDYPBJzCrtR4ir2W/02zZFEZKPkdWQRP3w+RQ/FrttO+1guY4ykoR3C04Xm/wqL8PS1
         QPgDyCWQnvJ4ACVSJzgcJ6ItI5lrUv1wk4+lU2pOp/P4wPdGYdnlov3fNGnCKxXbqMG6
         FDpw==
X-Gm-Message-State: APjAAAWcQOwFaxikw6Xs7dKtPeTy0L6mk0KVnYCVHt8pa+gHE9GSU4Rg
        KdlCXdw44P9KRJ+Bz0tPMZbJPB397Cw=
X-Google-Smtp-Source: APXvYqwqCicJgoVrmn8Lv6Ihd+dTRDGGFX+wlE/r5njF16gZBRJ55NKVTuxi8l7mTOQJZwssSzi7wQ==
X-Received: by 2002:a65:4786:: with SMTP id e6mr8830844pgs.448.1562915449408;
        Fri, 12 Jul 2019 00:10:49 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id b29sm14507006pfr.159.2019.07.12.00.10.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 12 Jul 2019 00:10:48 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] KVM: Boosting vCPUs that are delivering interrupts
Date:   Fri, 12 Jul 2019 15:10:35 +0800
Message-Id: <1562915435-8818-1-git-send-email-wanpengli@tencent.com>
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

