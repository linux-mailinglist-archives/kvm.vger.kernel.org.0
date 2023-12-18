Return-Path: <kvm+bounces-4748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C24817A6F
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 20:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47E291C20A73
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 19:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8EC71449;
	Mon, 18 Dec 2023 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hbMWFed4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909805D758
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-db410931c23so3955868276.2
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 10:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702925936; x=1703530736; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+5LKDBhc5fRoSDl3DvXUXj0YLkc9CYDv3070at1ND/Y=;
        b=hbMWFed4knB4fJd+HYjR7uhkg1NgF95s5mot2Z8wtYDIn9GBd1F5+Uzf3Abuft5c6K
         wsbXYbY7q/hp9sDq1biQ/hTA/w9HJXXhbpTDS58n3373djDGAQwAQ2FYWdB5RvYNgQXh
         BnhhAgBejvVtpZFkQ8751FiquDohoWEUHYULj3OHXSpZQ0HrQaHvinaBQ6ux+9FZirXC
         +qEU9h0BATK1CoPl6irM41XfTZ6zbVqwiMlWi6DSjy45HHK45kP2Ms0AAC5ZGFmMSojo
         CV0/Urby44QWZXu19sVKk7LJ7PiXXIorwk7Ee3SJfBh2dyh0ik8ur4rOaktGaiW/YS6M
         7zvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702925936; x=1703530736;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+5LKDBhc5fRoSDl3DvXUXj0YLkc9CYDv3070at1ND/Y=;
        b=AWrKMqPAW3r8jAxzfdT80CVMaFagRCqEB3HJ+INTpyp9/4z7QiztzhSQ6cxV0eNZev
         NQLaYV2RIXn9lef5Bk2iYRqEiFft8Q+4p+YMk3A4KWmfVLEXlqdupVks/wsBNVxTx0Ee
         aB4zj6oH3I3nlWPg0CRxnQz58Tcvsq+oFWUS6LoHArThWZmSgi+mycCF9RBghM9hiGJJ
         t/7N+10XHOXeEiFi27Zn6aiebmr3VL0rZCEOSLEWztXaoT6s4SKPK5xqA2N+cjaSl6Jb
         eSqa6ZQr7xyrIS2fTpcrYkAXrcCXJYLrbuBRCobdWrXfj7b6jwWtUxxnAGiYhilh7lS9
         yRRQ==
X-Gm-Message-State: AOJu0YzCGdpHh4VhvHejXgpEnkXJGiWrL01Wcfn+5NNXdp90XViSUIaj
	OeHGEik/nRZKkUYBi2zibgstDJMVyaiazw==
X-Google-Smtp-Source: AGHT+IGz323sSvFnT7+opscjBFUeMTzoS9h1gAUmovTH2ezGL3ef9NjWCuUdyV43YjCnebLQi9J4xBgQmxHwnA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:9705:0:b0:db5:45eb:75b0 with SMTP id
 d5-20020a259705000000b00db545eb75b0mr1778119ybo.6.1702925936590; Mon, 18 Dec
 2023 10:58:56 -0800 (PST)
Date: Mon, 18 Dec 2023 10:58:50 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231218185850.1659570-1-dmatlack@google.com>
Subject: [PATCH] PRODKERNEL: KVM: Mark a vCPU as preempted/ready iff it's
 scheduled out while running
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Mark a vCPU as preempted/ready if-and-only-if it's scheduled out while
running. i.e. Do not mark a vCPU preempted/ready if it's scheduled out
during a non-KVM_RUN ioctl() or when userspace is doing KVM_RUN with
immediate_exit.

Commit 54aa83c90198 ("KVM: x86: do not set st->preempted when going back
to user space") stopped marking a vCPU as preempted when returning to
userspace, but if userspace then invokes a KVM vCPU ioctl() that gets
preempted, the vCPU will be marked preempted/ready. This is arguably
incorrect behavior since the vCPU was not actually preempted while the
guest was running, it was preempted while doing something on behalf of
userspace.

This commit also avoids KVM dirtying guest memory after userspace has
paused vCPUs, e.g. for Live Migration, which allows userspace to collect
the final dirty bitmap before or in parallel with saving vCPU state
without having to worry about saving vCPU state triggering writes to
guest memory.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb6c6109fdca..14b645c12d19 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -377,6 +377,7 @@ struct kvm_vcpu {
 		bool dy_eligible;
 	} spin_loop;
 #endif
+	bool wants_to_run;
 	bool preempted;
 	bool ready;
 	struct kvm_vcpu_arch arch;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..066c6a41a43d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4158,7 +4158,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
 				synchronize_rcu();
 			put_pid(oldpid);
 		}
+		vcpu->wants_to_run = !vcpu->run->immediate_exit;
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
+		vcpu->wants_to_run = false;
+
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
 		break;
 	}
@@ -5968,7 +5971,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	if (current->on_rq) {
+	if (current->on_rq && vcpu->wants_to_run) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
 	}

base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.43.0.472.g3155946c3a-goog


