Return-Path: <kvm+bounces-11314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C2887543A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 17:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C75DB287DC2
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 16:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4355A12F398;
	Thu,  7 Mar 2024 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gu84BMLI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55DF53366
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 16:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709829354; cv=none; b=k3swgzW+nYyqk8qKIb9QfCFRk+Zmv0yybB1FA/0JeWUPp0CZZyrDanAh0dWXox22cP1zdBpJsV4Fbqw92bFxIH1TZfR6oXt7UWuAjPZDuN4/F1vNTynqTe4PnsJDBcIJJg8GNwcStY6wLnJAakqhYxYNxa4urf4TgZvA/H5Xa6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709829354; c=relaxed/simple;
	bh=ovLcO+ArYsqwVJr0lJWnhl4OzaIopjYDqjX/lQIcKLU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AvTi9t14EYDhwpadDlqqqAkxtTlzCAYd0nbK3pxd6/yPMTdQs6I12urO5ul3t5X59If3NSApnHXDN8uL2oD+oVp8Bmch1b3Ik3sOSOIGuj9FqKG5KRLh09h+tIts+cums30oPOOGkl7t28wlylVZCY3vkfU0L0OFfYNH+AoaP6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gu84BMLI; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc05887ee9so1524085276.1
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 08:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709829352; x=1710434152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SYNo+R7zcBcCdJec9GfDUXBmVK9TVYpdgkY84ts0zNo=;
        b=gu84BMLI+CLVhpjkNqzqY8qA+vHMePtrNCfCzAwwVnCR8I7ATKeqgKSaqjzoDIVp9O
         6u8+TaFm2oZOwaKC+mX4oE4tR2ZFihJYd7YTKlyD15A56tfS8nFGDmAdyTU7abfAnIpp
         +yyew6nsyfg9ZU0zYkXsvIQayPAGneRUTqPMrFhJyRbtY2LZ1Pt0Ffam1Xulcte//bsK
         X0GMSYSYyGje7rguMKmoU8rGautDAVKTyuobgXoLcAaI3tw/PgVJI8uD+9PcKVpp2jiR
         Lw97S2+sLUiXFMe4wDZ8YZ2DpRMA1Gzum9eCeypH7HVfn/t5XJ4QcUIm5RxYk4L/H4XL
         wQ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709829352; x=1710434152;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SYNo+R7zcBcCdJec9GfDUXBmVK9TVYpdgkY84ts0zNo=;
        b=KQFCDNtlBQL7gXI3XKR3OqC0nGOdlk39MXAzlTl19aru2gl7SQF5OOBaTd6eQgvNpl
         9YB+RVhJNUp0gHi+lPAkOyUyajs1IOvsWEvAqSbeibLVasLO6RSZ8V4eA5Rc3Z29nmek
         NLgtOCoInyJ/9BoVC8PF1g072c9UiHawn29s16oZvXPZzTDuIVvTis9uNCxBOQ6AeDuF
         k4KICPNT8uS9LhAZoqw7hUN7FkoBJ0uLFv9HQTiqDcZrLnIRxsTT+cJtMfhzDf58yNc5
         G7jkrAgU0VurTrISkj4WraXT+JvNs8NyxcHbZMoZ4zf7s5lkNuZfCsf8+2XfFU7UO8jg
         Kisg==
X-Gm-Message-State: AOJu0YwW6EPQx2etr8X4+p+KSb8a+p95CCBqqfYRoLtp6UNApm5tBBh6
	aQKa9SewRljgcctTL14Kq9OYGM1ty5CRyBh1C6JaV2O8IPtxWZ/4FQnbGhk3QSKE0nOQ3vyrre0
	leIAEs1gpOg==
X-Google-Smtp-Source: AGHT+IH/qR9uUaBf6Ts/jDJbTeMQ575YzhN2Kk4eUXg0ntDQe0fSFTbYxetrAAcFI4Cd+rez5dkheX/CjKktrg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:a009:0:b0:dc6:b982:cfa2 with SMTP id
 x9-20020a25a009000000b00dc6b982cfa2mr619610ybh.8.1709829351768; Thu, 07 Mar
 2024 08:35:51 -0800 (PST)
Date: Thu,  7 Mar 2024 08:35:41 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307163541.92138-1-dmatlack@google.com>
Subject: [PATCH v2] KVM: Mark a vCPU as preempted/ready iff it's scheduled out
 while running
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
v2:
 - Drop Google-specific "PRODKERNEL: " shortlog prefix

v1: https://lore.kernel.org/kvm/20231218185850.1659570-1-dmatlack@google.com/

 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..5b2300614d22 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -378,6 +378,7 @@ struct kvm_vcpu {
 		bool dy_eligible;
 	} spin_loop;
 #endif
+	bool wants_to_run;
 	bool preempted;
 	bool ready;
 	struct kvm_vcpu_arch arch;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff588677beb7..3da1b2e3785d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4438,7 +4438,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
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
@@ -6312,7 +6315,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	if (current->on_rq) {
+	if (current->on_rq && vcpu->wants_to_run) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
 	}

base-commit: 687d8f4c3dea0758afd748968d91288220bbe7e3
-- 
2.44.0.278.ge034bb2e1d-goog


