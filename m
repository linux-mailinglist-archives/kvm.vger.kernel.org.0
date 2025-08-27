Return-Path: <kvm+bounces-55888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C55B38740
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 272F316D9A1
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED9D312819;
	Wed, 27 Aug 2025 16:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="joSbDcAx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A658A17C91
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756310491; cv=none; b=t8fKghBXYN34aNjgJB6RA/pjbUZKDSDJ43TcsiHv9TelPPfToFqZxg9bQsBZtGZ3QHiGG9YD8oTph1Oi9tCL8wuTv9T2kKA5hNHb+FgHlV5o9GpYYaew0tMcRwabW0ysUqgBnXt6Ieoa9ZTR5Ph/Ae19mWnY2WccSnLdweYeL4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756310491; c=relaxed/simple;
	bh=nc3e8kEsbLpVLgiGqT6OlZiM0Ugt7rKJ9+rmdukZ9n8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p+Z7853ZK/yZoYH2t3xdN9pgA4aOWz+U0otw/pmQvXhQ1HdUSQQ3QlTZNwrVbUgZZOj4tm5YuvLC6ZRVA7jjhA6XXEi7VWoqYU5LYuvXU/DGrpdFKLCZw1ubRrgsWZZVbFeOPA5BTFsadDFgzIqLrQeygAsm3l0PlYSsYHqWSOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=joSbDcAx; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7720f231103so26935b3a.0
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 09:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756310489; x=1756915289; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XNn3oBnzUviCor8j9vwLNJGK9RvbnNRy8Itw1smJX24=;
        b=joSbDcAxybJJukKD7AdJFODHjeCvmlYILNrq3QC+TAmju1lELCZkWXCmdn8cXmQiY7
         DMu2jyVONiqTE2anoEkylHPSMSU5IViq94b/OhkTVcwK7PmlEw5JGm0sDEl27m8KBeo8
         +QNaCfxzR4CDHsLQkKFV5ruiBL7c9JYHaZLRr3SmyDEy0BW/nnsEkzIQXawsB9/cJBLd
         tKxA7Hin9qFBehhjlPc8PtzcSVkGGrdLExELMQvLRfk2r7wPS8fXI/ezFH58iyAkSlKY
         Kft4SYI8+1O2IplyQ46Uwxh1W7qnevTnWxucKKV/OgV/S6YfzlmzmChOSql+lsneriiC
         1tYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756310489; x=1756915289;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNn3oBnzUviCor8j9vwLNJGK9RvbnNRy8Itw1smJX24=;
        b=QNDVQYWdOTK1Wry6TNSB8UE2fKt3NkMEvjmNuf6h8JJEjEtgVW2UNxVYAOQ86ZiCPw
         Z9zM/JlVZY4+hBBXxrKxkpEaLI5h/m0fpJSQFUad9tJ+UTMn8O+shQ5HNDUVY+VqwBKD
         dNnYUQFrbJ5XE07XuThn6VqPlHBdMGVdCczJ+usvp9Kc3Jee6D3N+hqbHYro9XqYC54/
         2ZneEUOnqUjtv06gdQx4sl6av6saaRYhaKX4YwwFZ/CbHFQEbXxl+VYGh08Q8EmbyZ0+
         KD5dQiXWf+s2s59qsjqrDnajyBT0qSotRkOf8qJUld2chNpGRYbfOIo5pbO3/491u8ci
         jnYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhAqgX6FkiRKcOaEvcc8DF+H10MkXWU/ar5LxWqc9tm74y4MGSS5ZuFbJPmmrXbmJoABM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2PwGiu0cbSCRMG8EqP4CGOJt1o3/Sf3bu37mdplIukWk7JzIA
	/RyGgb9fNqH37b3eYl0Bb4v/r6V9n5UggUVsw9TVnLBol7GTf0kWs9uKUSMoq/KEZ7myoKifiZh
	K1QGykQ==
X-Google-Smtp-Source: AGHT+IGfXcW+ZtXZL+XK3iEVs8Sxo/zDD1i/skcxqmUfvEK+HLI/XM5vZ3/WKZOmNWWC6w3e8UGwRabmkGA=
X-Received: from pfwz26.prod.google.com ([2002:a05:6a00:1d9a:b0:772:13b2:f328])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b4e:b0:771:ed83:557c
 with SMTP id d2e1a72fcca58-771ed835a5dmr11874598b3a.2.1756310488667; Wed, 27
 Aug 2025 09:01:28 -0700 (PDT)
Date: Wed, 27 Aug 2025 09:01:27 -0700
In-Reply-To: <20250827152754.12481-1-lifei.shirley@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827152754.12481-1-lifei.shirley@bytedance.com>
Message-ID: <aK8r11trXDjBnRON@google.com>
Subject: Re: [PATCH] KVM: x86: Latch INITs only in specific CPU states in KVM_SET_VCPU_EVENTS
From: Sean Christopherson <seanjc@google.com>
To: Fei Li <lifei.shirley@bytedance.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, liran.alon@oracle.com, hpa@zytor.com, 
	wanpeng.li@hotmail.com, kvm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 27, 2025, Fei Li wrote:
> Commit ff90afa75573 ("KVM: x86: Evaluate latched_init in
> KVM_SET_VCPU_EVENTS when vCPU not in SMM") changes KVM_SET_VCPU_EVENTS
> handler to set pending LAPIC INIT event regardless of if vCPU is in
> SMM mode or not.
> 
> However, latch INIT without checking CPU state exists race condition,
> which causes the loss of INIT event. This is fatal during the VM
> startup process because it will cause some AP to never switch to
> non-root mode. Just as commit f4ef19108608 ("KVM: X86: Fix loss of
> pending INIT due to race") said:
>       BSP                          AP
>                      kvm_vcpu_ioctl_x86_get_vcpu_events
>                        events->smi.latched_init = 0
> 
>                      kvm_vcpu_block
>                        kvm_vcpu_check_block
>                          schedule
> 
> send INIT to AP
>                      kvm_vcpu_ioctl_x86_set_vcpu_events
>                      (e.g. `info registers -a` when VM starts/reboots)
>                        if (events->smi.latched_init == 0)
>                          clear INIT in pending_events

This is a QEMU bug, no?  IIUC, it's invoking kvm_vcpu_ioctl_x86_set_vcpu_events()
with stale data.  I'm also a bit confused as to how QEMU is even gaining control
of the vCPU to emit KVM_SET_VCPU_EVENTS if the vCPU is in kvm_vcpu_block().

>                      kvm_apic_accept_events
>                        test_bit(KVM_APIC_INIT, &pe) == false
>                          vcpu->arch.mp_state maintains UNINITIALIZED
> 
> send SIPI to AP
>                      kvm_apic_accept_events
>                        test_bit(KVM_APIC_SIPI, &pe) == false
>                          vcpu->arch.mp_state will never change to RUNNABLE
>                          (defy: UNINITIALIZED => INIT_RECEIVED => RUNNABLE)
>                            AP will never switch to non-root operation
> 
> In such race result, VM hangs. E.g., BSP loops in SeaBIOS's SMPLock and
> AP will never be reset, and qemu hmp "info registers -a" shows:
> CPU#0
> EAX=00000002 EBX=00000002 ECX=00000000 EDX=00020000
> ESI=00000000 EDI=00000000 EBP=00000008 ESP=00006c6c
> EIP=000ef570 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ......
> CPU#1
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00080660
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 ffff0000 0000ffff 00009b00
> ......
> 
> Fix this by handling latched INITs only in specific CPU states (SMM,
> VMX non-root mode, SVM with GIF=0) in KVM_SET_VCPU_EVENTS.
> 
> Cc: stable@vger.kernel.org
> Fixes: ff90afa75573 ("KVM: x86: Evaluate latched_init in KVM_SET_VCPU_EVENTS when vCPU not in SMM")
> Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1c49bc681c46..7001b2af00ed1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5556,7 +5556,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  			return -EINVAL;
>  #endif
>  
> -		if (lapic_in_kernel(vcpu)) {
> +		if (!kvm_apic_init_sipi_allowed(vcpu) && lapic_in_kernel(vcpu)) {
>  			if (events->smi.latched_init)
>  				set_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
>  			else
> -- 
> 2.39.2 (Apple Git-143)
> 

