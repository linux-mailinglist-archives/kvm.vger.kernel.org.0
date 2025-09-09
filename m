Return-Path: <kvm+bounces-57050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B69B4A252
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 08:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B51AC4E496E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 06:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8FD3303A07;
	Tue,  9 Sep 2025 06:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="k2N2QPhj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F551301480
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 06:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757399624; cv=none; b=D8twrKxd92HmljR80dDzLXyFym1qDE/IC3pIzrz13HEzG8CtIWE347q3wE6rrRr1uAlsTX7GBlYhYb9VcTtM+17VE/NcNxGlhmaV1Sj+EOO7GaMhbLGnt+I4iDdZjf6LEb48UIYdX4W8wDsOWeyW3fyiMYArHb1a5qXm59Zw7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757399624; c=relaxed/simple;
	bh=gj7jt79vO8I2a3MZuHzK1aFx+qemfKe3mIiu3tvr8Xw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bZyB6lO5+snlB/8uPLW+Bo/clz12z45BFpVJ1PTW5TNKJyfO0RUzmQSWFykuxrQX0texoCKeu28fT26vuZWMR8gi0mS/1wsUCtDO6pEHwyT3MkklmZwee9bpX0HFoHPKQhLc5C2OQZKDTVI0a80hYEJHnACwUHFCEmBgix9PI4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=k2N2QPhj; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7726c7ff7e5so4435829b3a.3
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 23:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1757399622; x=1758004422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KlYPumXZ2GNPPhioX83eHuWYdzwsk2NeU2T6+Hb+h+o=;
        b=k2N2QPhj5eobtFZkxe1PMD1y/HGzjAwtzW9SqeEOVu3256M+Iu/x1WPY66yNkfvibq
         9vRazQlOPs5XBf8he6BxkUKE2J+DgCVOvSiiKckNxgABBzk8dGQFY+ejIrA6ITyTkpLx
         ovsdjpJ5Ft1TRroCrFGke4Lizq0RoRWAkQBM1Qn0DUURY1D/p1FUjpY7M8oYCTyVD5w8
         tO1B+gWlYJkmxywX7t+OgQORtM49Me/5EEVXIbhMkZAkLoGq+04JDDPC20985bc+gyGZ
         HZP7s7gXfIhoymmlZgSfb9ZbqE8biv1RFh8XM9Y0a1L5SAvfaYQow13Ww/gWCk38hlq5
         OPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757399622; x=1758004422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KlYPumXZ2GNPPhioX83eHuWYdzwsk2NeU2T6+Hb+h+o=;
        b=UL6WAmm3N6LYl67HGXj71MvRTQhpkVp+q+pGWjmxWt1sMFz7J5aQdZDJ5FJ5KDuDHa
         mMiWBZLI941/rBtxAv1+124s+bIQJzJ3J6IUdpLlUAgsl+4tVCkVu4s/bGh5hJURXsil
         dCbGQ5queYq1354uvdHeKSctCn0hiGg7wmjDqOE9X3JTUW4qybxNEmhgxiuh8O/Z+kS/
         bzoMIAeOURNuHq4uD+I++OAsjbGpKIAbQWuXJB3N1lh2mYXRbOGmlxeSSiAJTu8Qqa2z
         sCsFoSYLaQEHnkLhnNFjKFLKmPsTruC9sHMjge8qdgpPCvMMWlvygMrQKV4+92bgERNN
         YOIA==
X-Forwarded-Encrypted: i=1; AJvYcCVbN32WvzCwCRq8twexprrw7Br/Rl4mZuCFFx2wksSMaU8kutea8LIsxfqz2LxFXVY9PGw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzufgQqlMQ5vFO18TUY4AMye61RLQZLi0qsVEOj7awYoutzehoc
	cpuqnxFPcD8PW7I0dnfX6iknNdxXxgd9jawVNlGU2RPiOrDEmTAKdaNuHOgHkJvomoQ=
X-Gm-Gg: ASbGncuSwZTBaQXrzJfZNttkAis5MWdh44J/KEn+N7a+kut8Qj9s8vsB2H0eWQ4naxq
	+vn6bVigB+UI0N/OKlmV00iKexfVO3Wnmb42NKb6fkufaTEDmwyXsSdr8j8bnOUkiKcwq1xyqxn
	zUGnh7cBKE8aqR+U5idslkqBpLkCV0l28yYraZnI+9GndwMqn3NGP3J5U9vARL9LKPfCUL/eAns
	Wtgyhf6nikYCrb4z25HRcuL52GX9oAHuCObMqmIaHcoJSCM6X5m/g07nq5hSRs5M/rCoR2npfS0
	M991uwy0YtMPR1udxrHZdzhZVcrpdmjgY9HvED9R7na3f075dAOS61IG6Kj5+NDxiqAUrXI6ZA0
	PLdIMFiuf+WiNvSjT8QFvSucr8HIlzwA6Mdoc0cup2smIiHr8RjuSlwlQhgxyAA==
X-Google-Smtp-Source: AGHT+IG5VjYQNMdw/MpShOmZhgIpumMJ2z8imKGQ/mFwUjSsWb6PA2uPoGsX+egsKKVRJhRC4n1lfQ==
X-Received: by 2002:a05:6a20:9392:b0:24e:2cee:9592 with SMTP id adf61e73a8af0-2534547a6c6mr15549901637.46.1757399621653;
        Mon, 08 Sep 2025 23:33:41 -0700 (PDT)
Received: from localhost.localdomain ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b5235c0c3e2sm4213501a12.20.2025.09.08.23.33.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 08 Sep 2025 23:33:41 -0700 (PDT)
From: Fei Li <lifei.shirley@bytedance.com>
To: pbonzini@redhat.com,
	mtosatti@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: qemu-devel@nongnu.org,
	Fei Li <lifei.shirley@bytedance.com>
Subject: [PATCH] KVM: x86: Restrict writeback of SMI VCPU state
Date: Tue,  9 Sep 2025 14:33:27 +0800
Message-Id: <20250909063327.14263-1-lifei.shirley@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently, we meet a SMI race bug triggered by one monitor tool in our
production environment. This monitor executes 'info registers -a' hmp
at a fixed frequency, even during VM startup process, which makes
some AP stay in KVM_MP_STATE_UNINITIALIZED forever, thus VM hangs.

The complete calling processes for the SMI race are as follows:

//thread1                      //thread2               //thread3
`info registers -a` hmp [1]    AP(vcpu1) thread [2]    BSP(vcpu0) send INIT/SIPI [3]

                               [2]
                               KVM: KVM_RUN and then
                                    schedule() in kvm_vcpu_block() loop

[1]
for each cpu: cpu_synchronize_state
if !qemu_thread_is_self()
1. insert to cpu->work_list, and handle asynchronously
2. then kick the AP(vcpu1) by sending SIG_IPI/SIGUSR1 signal

                               [2]
                               KVM: checks signal_pending, breaks loop and returns -EINTR
                               Qemu: break kvm_cpu_exec loop, run
                                     1. qemu_wait_io_event()
                                     => process_queued_cpu_work => cpu->work_list.func()
                                        e.i. do_kvm_cpu_synchronize_state() callback
                                        => kvm_arch_get_registers
                                           => kvm_get_mp_state /* KVM: get_mpstate also calls
                                              kvm_apic_accept_events() to handle INIT and SIPI */
                                     => cpu->vcpu_dirty = true;
                                     // end of qemu_wait_io_event

                                                       [3]
                                                       SeaBIOS: BSP enters non-root mode and runs reset_vector() in SeaBIOS.
                                                                send INIT and then SIPI by writing APIC_ICR during smp_scan
                                                       KVM: BSP(vcpu0) exits, then => handle_apic_write
                                                            => kvm_lapic_reg_write => kvm_apic_send_ipi to all APs
                                                            => for each AP: __apic_accept_irq, e.g. for AP(vcpu1)
                                                            ==> case APIC_DM_INIT: apic->pending_events = (1UL << KVM_APIC_INIT)
                                                                (not kick the AP yet)
                                                            ==> case APIC_DM_STARTUP: set_bit(KVM_APIC_SIPI, &apic->pending_events)
                                                                (not kick the AP yet)

                               [2]
                               Qemu continue:
                                    2. kvm_cpu_exec()
                                    => if (cpu->vcpu_dirty):
                                       => kvm_arch_put_registers
                                          => kvm_put_vcpu_events
                               KVM: kvm_vcpu_ioctl_x86_set_vcpu_events
                                    => clear_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
                                       e.i. pending_events changes from 11b to 10b
                                      // end of kvm_vcpu_ioctl_x86_set_vcpu_events
                               Qemu: => after put_registers, cpu->vcpu_dirty = false;
                                     => kvm_vcpu_ioctl(cpu, KVM_RUN, 0)
                               KVM: KVM_RUN
                                    => schedule() in kvm_vcpu_block() until Qemu's next SIG_IPI/SIGUSR1 signal
                                    /* But AP(vcpu1)'s mp_state will never change from KVM_MP_STATE_UNINITIALIZED
                                      to KVM_MP_STATE_INIT_RECEIVED, even then to KVM_MP_STATE_RUNNABLE without
                                      handling INIT inside kvm_apic_accept_events(), considering BSP will never
                                      send INIT/SIPI again during smp_scan. Then AP(vcpu1) will never enter
                                      non-root mode */

                                                       [3]
                                                       SeaBIOS: waits CountCPUs == expected_cpus_count and loops forever
                                                                e.i. the AP(vcpu1) stays: EIP=0000fff0 && CS =f000 ffff0000
                                                                and BSP(vcpu0) appears 100% utilized as it is in a while loop.

To fix this, avoid clobbering SMI when not putting "reset" state, just
like NMI abd SIPI does.

Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 369626f8c8..598661799a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5056,7 +5056,7 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
 
     events.sipi_vector = env->sipi_vector;
 
-    if (has_msr_smbase) {
+    if (has_msr_smbase && level >= KVM_PUT_RESET_STATE) {
         events.flags |= KVM_VCPUEVENT_VALID_SMM;
         events.smi.smm = !!(env->hflags & HF_SMM_MASK);
         events.smi.smm_inside_nmi = !!(env->hflags2 & HF2_SMM_INSIDE_NMI_MASK);
-- 
2.39.2 (Apple Git-143)


