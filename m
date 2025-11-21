Return-Path: <kvm+bounces-64255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE10C7BB4B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:01:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EA8EC34D94B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 21:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAAD7303C8E;
	Fri, 21 Nov 2025 21:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HvBVKNHP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C2B38DD3
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 21:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763758904; cv=none; b=d2lUaEmZN5AGlrCsvaraiOc+ldePp1k8mUemL3CU11L5IRGM5uehbH1eNIAWMOQI/OJI4xR7SdJnpyXz5EqCdUXC7yQJuAuRSA8YnqZacrFHS6VxbuBfCkrxK/rUpwQ7azwzqkNr+/wzQPHoaOYbd0umXcyzfjGwlyNCCBWApPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763758904; c=relaxed/simple;
	bh=B7YNKrTt0enCvD/EaWKSxNm453HZnVYYtkLLVSDYh38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LDZKO3FMy1qSIzuVLHfmxp3IsL6kjKQbmga72mtfAJfClvWJN8yZp/MJstR1aHlR9JWk72dUkUTeIpp9Hg7GYmmSPboY0XitIb30yT1dj5nw/uOwjOoKoKs3ULiC47WW8xbEi5ehsVPOmoBv3X6L6e2RV6v+tpLc1q9vZMEuQI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HvBVKNHP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958c80fcabso72323465ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 13:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763758902; x=1764363702; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ac4mMM3g/g/BW6I267EGCP3uaTeAwf3nNqGsbiLSgLg=;
        b=HvBVKNHPevv5WvcyOgGDk+xeG4CN0nCkDc4tMqsAfI6gCYlTH7LkJrYS0Dx8QFuwZi
         yMgTTukqXIwnyh8LFB08X4BeBRbzzaLeoynYqXgw6o75m5XkO+43/bRb0HMGejH/Xm6O
         lFlimJn4eiLFlRzWAKnTl74f+ECapJyNutGca3pKSK84IuD/WO+Ql9MAwtSWzhkG6LVb
         BwG0YEeeObkKO7FPX7pVJpifTxSpdoT6bYOyB/ozIIaeAtkENutHtWW5/ddYL2yQNYKB
         7xLETcMMc+Cx2L7s/zC8Ta+WqikrY1MxhSzDg5xLwRu9AEHhl485OPn3rSF7n+vXA59+
         Ul/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763758902; x=1764363702;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ac4mMM3g/g/BW6I267EGCP3uaTeAwf3nNqGsbiLSgLg=;
        b=dQQbBJMQgLgGFBkRl2M8LrLvTx7AEXyLPU7aurHizowWPxlP37CFcGdueqOZ2PSH6S
         XDemigz/4GrpBzORoaL/LzuPpPijH9gig+T/9eWq0A2Q3DqVXgKUo9DsS+wdSz4aBdWK
         jKDfg+HoDyLeTPL9PzIAPFSB1ebySqcenczu9ydoQoM6j5K+AsG1bTnIhnokw5f9TtPP
         i89lZXvGUm5JXyX6vlx4G19erR5y4m2omoNypoiScIaI1ZwmBuxUCq3xqRA8kqLSruP/
         PAPl9LVpvjCqJDHVVO7Mw71Zm1f6Ul0ReVDxn3m/RjnyViweuvcfWQanPeUmKow/2v4Y
         A8PQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMCeV1iO8wkMbX5wpYynzo3Q1/xMLe2br2kl8AnFQ8oe3pW6zQXYgzd/+/KjWe+1R+its=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUNBIoLY/irDhfopukOr6AGsByMYCSC8G/cVX1Gs8Py3/1MjFd
	L24HBlsM7ACDqGlKV4DA+uWIhS0cNYRv/ULyBOh6g39pMFbHJAaKByMjtfCTe/C9pOzU5Hbc5jx
	v+IVL9A==
X-Google-Smtp-Source: AGHT+IG+D6xVfuLOyYVH8atxIpnhXqnxRFlYbCYlUdYQ4U/01c6opVAwt3tuglj1k/9led+mVyyXzaw1xvU=
X-Received: from plbla16.prod.google.com ([2002:a17:902:fa10:b0:298:a8:6ab2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:11c3:b0:297:e3f5:4a20
 with SMTP id d9443c01a7336-29b6bee38ecmr54624235ad.26.1763758901795; Fri, 21
 Nov 2025 13:01:41 -0800 (PST)
Date: Fri, 21 Nov 2025 13:01:40 -0800
In-Reply-To: <20251121193204.952988-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121193204.952988-1-yosry.ahmed@linux.dev> <20251121193204.952988-2-yosry.ahmed@linux.dev>
Message-ID: <aSDTNDUPyu6LwvhW@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Add CR3 to guest debug info
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ken Hofsass <hofsass@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> Add the value of CR3 to the information returned to userspace on
> KVM_EXIT_DEBUG. Use KVM_CAP_X86_GUEST_DEBUG_CR3 to advertise this.
> 
> During guest debugging, the value of CR3 can be used by VM debuggers to
> (roughly) identify the process running in the guest. This can be used to
> index debugging events by process, or filter events from some processes
> and quickly skip them.
> 
> Currently, debuggers would need to use the KVM_GET_SREGS ioctl on every
> event to get the value of CR3, which considerably slows things down.
> This can be easily avoided by adding the value of CR3 to the captured
> debugging info.
> 
> Signed-off-by: Ken Hofsass <hofsass@google.com>
> Co-developed-by: Ken Hofsass <hofsass@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 1 +
>  arch/x86/kvm/svm/svm.c          | 2 ++
>  arch/x86/kvm/vmx/vmx.c          | 2 ++
>  arch/x86/kvm/x86.c              | 3 +++
>  include/uapi/linux/kvm.h        | 1 +
>  5 files changed, 9 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 7ceff6583652..c351e458189b 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -293,6 +293,7 @@ struct kvm_debug_exit_arch {
>  	__u64 pc;
>  	__u64 dr6;
>  	__u64 dr7;
> +	__u64 cr3;
>  };

I really, really don't like this.  It "solves" a very specific problem for a very
specific use case without any consideration for uAPI, precedence or maintenance.
E.g. in most cases, CR3 without CR0, CR4, EFER, etc. is largely meaningless.  The
only thing it's really useful for is an opaque guest process identifer.

KVM already provides kvm_run.kvm_valid_regs to let userspace grab register state
on exit to userspace.  If userspace is debugging, why not simply save all regs on
exit?

If the answer is "because it slows down all other exits", then I would much rather
give userspace the ability to conditionally save registers based on the exit reason,
e.g. something like this (completely untested, no CAP, etc.)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6d899d53dd..337043d49ee6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -127,7 +127,7 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
-static void store_regs(struct kvm_vcpu *vcpu);
+static void kvm_run_save_regs_on_exit(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
 static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu);
 
@@ -10487,6 +10487,8 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 {
        struct kvm_run *kvm_run = vcpu->run;
 
+       kvm_run_save_regs_on_exit(vcpu);
+
        kvm_run->if_flag = kvm_x86_call(get_if_flag)(vcpu);
        kvm_run->cr8 = kvm_get_cr8(vcpu);
        kvm_run->apic_base = vcpu->arch.apic_base;
@@ -11978,8 +11980,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 out:
        kvm_put_guest_fpu(vcpu);
-       if (kvm_run->kvm_valid_regs && likely(!vcpu->arch.guest_state_protected))
-               store_regs(vcpu);
        post_kvm_run_save(vcpu);
        kvm_vcpu_srcu_read_unlock(vcpu);
 
@@ -12598,10 +12598,30 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
        return 0;
 }
 
-static void store_regs(struct kvm_vcpu *vcpu)
+static void kvm_run_save_regs_on_exit(struct kvm_vcpu *vcpu)
 {
+       struct kvm_run *run = vcpu->run;
+       u32 nr_exit_reasons = sizeof(run->kvm_save_regs_on_exit) * BITS_PER_BYTE;
+       u64 valid_regs = READ_ONCE(run->kvm_valid_regs);
+       u32 exit_reason = READ_ONCE(run->exit_reason);
+
        BUILD_BUG_ON(sizeof(struct kvm_sync_regs) > SYNC_REGS_SIZE_BYTES);
 
+       if (!valid_regs)
+               return;
+
+       if (unlikely(!vcpu->arch.guest_state_protected))
+               return;
+
+       if (valid_regs & KVM_SYNC_REGS_CONDITIONAL) {
+               if (exit_reason >= nr_exit_reasons)
+                       return;
+
+               exit_reason = array_index_nospec(exit_reason, nr_exit_reasons);
+               if (!test_bit(exit_reason, (void *)run->kvm_save_regs_on_exit))
+                       return;
+       }
+
        if (vcpu->run->kvm_valid_regs & KVM_SYNC_X86_REGS)
                __get_regs(vcpu, &vcpu->run->s.regs.regs);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..452805c1337b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -494,8 +494,12 @@ struct kvm_run {
                struct kvm_sync_regs regs;
                char padding[SYNC_REGS_SIZE_BYTES];
        } s;
+
+       __u64 kvm_save_regs_on_exit[16];
 };
 
+#define KVM_SYNC_REGS_CONDITIONAL      _BITULL(63)
+
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
 
 struct kvm_coalesced_mmio_zone {

