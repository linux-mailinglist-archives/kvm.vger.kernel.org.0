Return-Path: <kvm+bounces-17899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B1E8CB893
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A31451F230E1
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 01:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BBF18C22;
	Wed, 22 May 2024 01:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1zkgIPIF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD10568A
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 01:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716342020; cv=none; b=iAkrjMcjfYkXrKbd6BGy5ieay+FYgHeepsheHQtKnjMpBj10NoL1G/zRKE6Y9efw0VZIRRXd74Cci+QjGtHmM/0QEDvOl+UlpGoN4kStiQ4CBBwL4o5U/Jd5RC8L42RFLBu3/N2RZ+jeA6v/bF4+bl30G78KKAv83KZVdA4x2lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716342020; c=relaxed/simple;
	bh=8WkgXvFVZEpynasJJ48aoJTH4+LPLoJyE+T2vpEb3+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QJrqe4XRzcUCWbV1QZJfxhDuPxry5wnZiwDBRV7ZEecOacz41T8Q4SK2rDmb6mQebMvjmEIEeh9G78zZtBDdq8e6c59PeFwblK4yM4OK05KrFmnHLlhjstTvPqHzFqciWkTAPcwKEqa4wQhFnVqX5r0WNl6WyKWuw1Uw8AaeNQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1zkgIPIF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c670f70a37so12359863a12.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 18:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716342018; x=1716946818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ksrstYm4acNB+vq44uyCoC45OYvJ0DDPXjwdxHvKYos=;
        b=1zkgIPIFA1ATGYiwT7x71SqKp5i99vZIi4WBoYv5glURwdRwNDTXXNCijRW1H3RfoN
         uLkv89p9FWdXTjgNcPNoan87La0hhNBAFmckgkCyP4XhQh16av3VfuQgopgquUfwuwwm
         kDFHbXtRhmHGIFMy9V/45rYAk8sU4Aux4i0oNdNbf3qQb2viz4skoTwKg3U96m/jBCs2
         CIKJ5NRiGOvE+m0V9dd9ibWfo2Fc4hURmXJd/4WeKWMGvjNwNZMJLUAoT5ObPSK+bt89
         iHSR7N75a6c0gdPaGxVWPrNdZShmWdTkqleNlwKy/3lOX4F40Pk8/yXBODJ4zszm8A6a
         20Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716342018; x=1716946818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksrstYm4acNB+vq44uyCoC45OYvJ0DDPXjwdxHvKYos=;
        b=tjQaE1i/mmS0Kr/YqFbdILXL/odkyYV7FqsKCdXTpAorJA0JObVycYxCFiYrqMbt73
         XgV+SLXybdLYO1wGiAYqqGjdiYYv2RCZso+DXJfx1BxdzgPypVmnu9XjrMdFXE7N8RL0
         HAy7jXmJrYjydbfF4bsGxKvKi4TLF4gZEDElL5w2e4SsGzZeqvPX3geVqWupJ5DN8+hb
         oNnV90zBTwY/znmAl8d53Dcv8tgZj5Ps+7CEKCKcGDiLQkyQxDnkNy/mGRMMWG8vknV8
         FIFj3Q4TgpPgnHYhR7MK4JlO6+uZCAcy6qRqhuXO4ony+B1MDu3ZlRmXZ8IZfJv7GLr9
         gUoQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4fLrv0ho1bZJqreo+agnNUGj8hqr7tHH8pKcRjn5TLPiKIb3wStYhaRRBJjJdVx/jNb9kknC+Z/aTvw13lKG2smgK
X-Gm-Message-State: AOJu0Yzb6Yr1TSjdfPs/W1b1pJQuQH04dhA5XD0V/ZiHhuRf5h6ThrrN
	LXtWcdCmeyKt0sMIOP/IAVhjeIDJbIrUYEX5Wt1JwGiXz1J0mE6MohegRMIXaAnZOY20dSD0uDz
	eUA==
X-Google-Smtp-Source: AGHT+IHJLNUzIn6ctcMF+INwxFBaLeFnt3jt+tGT+n5clQV+H1h//pkXMDRUR1aNO5clBwbY0FCScT/OPUo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:484:b0:5dc:5111:d8b1 with SMTP id
 41be03b00d2f7-676492dc83emr2297a12.5.1716342017980; Tue, 21 May 2024 18:40:17
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 18:40:08 -0700
In-Reply-To: <20240522014013.1672962-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522014013.1672962-2-seanjc@google.com>
Subject: [PATCH v2 1/6] KVM: Add a flag to track if a loaded vCPU is scheduled out
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a kvm_vcpu.scheduled_out flag to track if a vCPU is in the process of
being scheduled out (vCPU put path), or if the vCPU is being reloaded
after being scheduled out (vCPU load path).  In the short term, this will
allow dropping kvm_arch_sched_in(), as arch code can query scheduled_out
during kvm_arch_vcpu_load().

Longer term, scheduled_out opens up other potential optimizations, without
creating subtle/brittle dependencies.  E.g. it allows KVM to keep guest
state (that is managed via kvm_arch_vcpu_{load,put}()) loaded across
kvm_sched_{out,in}(), if KVM knows the state isn't accessed by the host
kernel.  Forcing arch code to coordinate between kvm_arch_sched_{in,out}()
and kvm_arch_vcpu_{load,put}() is awkward, not reusable, and relies on the
exact ordering of calls into arch code.

Adding scheduled_out also obviates the need for a kvm_arch_sched_out()
hook, e.g. if arch code needs to do something novel when putting vCPU
state.

And even if KVM never uses scheduled_out for anything beyond dropping
kvm_arch_sched_in(), just being able to remove all of the arch stubs makes
it worth adding the flag.

Link: https://lore.kernel.org/all/20240430224431.490139-1-seanjc@google.com
Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7b57878c8c18..bde69f74b031 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -380,6 +380,7 @@ struct kvm_vcpu {
 #endif
 	bool preempted;
 	bool ready;
+	bool scheduled_out;
 	struct kvm_vcpu_arch arch;
 	struct kvm_vcpu_stat stat;
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a1756d5077ee..7ecea573d121 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6288,6 +6288,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 	__this_cpu_write(kvm_running_vcpu, vcpu);
 	kvm_arch_sched_in(vcpu, cpu);
 	kvm_arch_vcpu_load(vcpu, cpu);
+
+	WRITE_ONCE(vcpu->scheduled_out, false);
 }
 
 static void kvm_sched_out(struct preempt_notifier *pn,
@@ -6295,6 +6297,8 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
+	WRITE_ONCE(vcpu->scheduled_out, true);
+
 	if (current->on_rq) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
-- 
2.45.0.215.g3402c0e53f-goog


