Return-Path: <kvm+bounces-32631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 433479DB05E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF70E2820B5
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C327F86252;
	Thu, 28 Nov 2024 00:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MZtoZRpu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4831A270
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754638; cv=none; b=VbFjjtc04we+lQleJlr7FJ54GJ3aRQx6XDSScB7Shjyt74gl+yDzS6RMUsQD9ildziL/FkqP+fp3ccy9q1rTxCOszo2R9MyoSJCZHl+YhMKcL2lr+FHNxSqcFVZhImU2XRAbCw5Gvo7BFm5Cg1bpjGAPTg7Bsaj8wijG9XEbGH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754638; c=relaxed/simple;
	bh=AEDUeCL/zaARx8onXji3t/YtfDw26liZdxyZL4gPBeI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VOLsNLLggXXPMAQR+cTB22xa1VKnqPdrxICBxJOQ3oyAERdy4WvXsO8+6mivB0k2I41BA603L2BvBxMm+favDvWhEHRoMZ0okYz2NjPMLqmoiXP0chK0vSqOS/yoSl8yX+hhgnuJm8DvhQHcW3NZ+Q+rP5wz1MqB4V/6Oz6odAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MZtoZRpu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2edeef8a994so339944a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732754636; x=1733359436; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=b+5GMpw/w1WHRIobpEWm5+/qy2gHIU4YsE7Y113p5dg=;
        b=MZtoZRpu338MJJmHtfYKDG3uwOHPGZhCnZm8GIf4tqm7RH1/zF1uxd19ucKx+2kR7I
         Z2TZ0yj/J4FGEjMswLH5BOp1Jo9br5CPk3AfnAEK4fBNt0KLywDDACvH8iGZ2r+GHO1s
         AX8dNAqsPiFUnYjKSG2fObPhN+6HwSzLo3V9YGRk7t3hpxTbcRCzGI10T8V0moGMxqUA
         MQjVNzYVELrzaoWSGPH7KIH9i/BttK1uuMvWSwbQsA81SMvFPfm7g9njcYMj8Nrqur9C
         qV1tjaKctHyQecApKVZIsMMpIVF64gXGEHRp+GVZYA0PY0jLacygQGGqxyczhEAON5M2
         afVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732754636; x=1733359436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b+5GMpw/w1WHRIobpEWm5+/qy2gHIU4YsE7Y113p5dg=;
        b=bKzzlL6xvpXb8hU14RTn6+EKCnxYv0RWcY++tz9A3YRujXxjxvz30G7W3Ad9T3O4Kd
         xTiX2iBPEfZXoHjXihQyrisIQ1jgkXtb6Sp3IZ74xNkBZOFZwXmWyu/iIbzyymmCeY3I
         JPbAqDYYczmEvyrcxWc8ev+5LthxGuavN8sJwGh85cLusLsTGyfSkZqblmdDT6rg2C4O
         1jrJObBD2AQEejRvUKKhtOU3kQmXZw0jKwMEySZXqwuNjQyVO3sexjgmhnY4cNHVFbH9
         nxqBYvCqv4NF/fxd5r0MIQcP8LEqfIY53Vvo9CHgd16/a/vStXL88xGHDUfj0FnTjDdd
         KRTQ==
X-Gm-Message-State: AOJu0YwcQ+8OsRQ1xj/Q6bCyajrhJjmL3NyIOKhWWZY5D1v14jXHmSW5
	/JyjENYoddaXm7AZv5SrqycJBjKB6Tj6RsRgqEQzcaq+iQ5izkHyLbBAtxhz0Ud+MxiuqaqN5Ek
	d9A==
X-Google-Smtp-Source: AGHT+IGosbHKAV+rkitlr6k2kWiYww6vT/dEz80J0WwFs8XqNGHk+Uosu6KGRZs/IjB6xkH6D7120BnwA0M=
X-Received: from pjbli14.prod.google.com ([2002:a17:90b:48ce:b0:2e2:9f67:1ca3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48c1:b0:2ea:9f38:993c
 with SMTP id 98e67ed59e1d1-2ee08ecc4d9mr6651891a91.18.1732754635965; Wed, 27
 Nov 2024 16:43:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:43:43 -0800
In-Reply-To: <20241128004344.4072099-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128004344.4072099-6-seanjc@google.com>
Subject: [PATCH v4 5/6] KVM: x86: Always complete hypercall via function callback
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Finish "emulation" of KVM hypercalls by function callback, even when the
hypercall is handled entirely within KVM, i.e. doesn't require an exit to
userspace, and refactor __kvm_emulate_hypercall()'s return value to *only*
communicate whether or not KVM should exit to userspace or resume the
guest.

(Ab)Use vcpu->run->hypercall.ret to propagate the return value to the
callback, purely to avoid having to add a trampoline for every completion
callback.

Using the function return value for KVM's control flow eliminates the
multiplexed return value, where '0' for KVM_HC_MAP_GPA_RANGE (and only
that hypercall) means "exit to userspace".

Note, the unnecessary extra indirect call and thus potential retpoline
will be eliminated in the near future by converting the intermediate layer
to a macro.

Suggested-by: Binbin Wu <binbin.wu@linux.intel.com>
Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++-----------------
 arch/x86/kvm/x86.h | 10 ++++++----
 2 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 11434752b467..39be2a891ab4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9982,10 +9982,11 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-				      unsigned long a0, unsigned long a1,
-				      unsigned long a2, unsigned long a3,
-				      int op_64_bit, int cpl)
+int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+			    unsigned long a0, unsigned long a1,
+			    unsigned long a2, unsigned long a3,
+			    int op_64_bit, int cpl,
+			    int (*complete_hypercall)(struct kvm_vcpu *))
 {
 	unsigned long ret;
 
@@ -10061,7 +10062,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 			vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
 
 		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
-		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
+		vcpu->arch.complete_userspace_io = complete_hypercall;
 		/* stat is incremented on completion. */
 		return 0;
 	}
@@ -10071,13 +10072,15 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 	}
 
 out:
-	return ret;
+	vcpu->run->hypercall.ret = ret;
+	complete_hypercall(vcpu);
+	return 1;
 }
 EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
-	unsigned long nr, a0, a1, a2, a3, ret;
+	unsigned long nr, a0, a1, a2, a3;
 	int op_64_bit;
 	int cpl;
 
@@ -10095,16 +10098,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	op_64_bit = is_64_bit_hypercall(vcpu);
 	cpl = kvm_x86_call(get_cpl)(vcpu);
 
-	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
-	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
-		/* MAP_GPA tosses the request to the user space. */
-		return 0;
-
-	if (!op_64_bit)
-		ret = (u32)ret;
-	kvm_rax_write(vcpu, ret);
-
-	return kvm_skip_emulated_instruction(vcpu);
+	return __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl,
+				       complete_hypercall_exit);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6db13b696468..28adc8ea04bf 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -617,10 +617,12 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
 	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
 }
 
-unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-				      unsigned long a0, unsigned long a1,
-				      unsigned long a2, unsigned long a3,
-				      int op_64_bit, int cpl);
+int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+			    unsigned long a0, unsigned long a1,
+			    unsigned long a2, unsigned long a3,
+			    int op_64_bit, int cpl,
+			    int (*complete_hypercall)(struct kvm_vcpu *));
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.47.0.338.g60cca15819-goog


