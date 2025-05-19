Return-Path: <kvm+bounces-46984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E67ABBF3B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 15:33:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B5B74A025E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 13:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7AB827A117;
	Mon, 19 May 2025 13:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uX4rMEit"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED2B27817D
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747661598; cv=none; b=O5oRxhULc1pBPxYqJUv7XkDuXOF91HWJ2+1C0dcJ8y5X/GmeB9VYZARpDDLBdoMdFnQgS0T25Pg4lToCbH7zipJN3Ma9RVlDe4dspFp4uF7CjQxjCiLPeShu4psWE5f9TNxUXfqqSARSur5MUw4EjmjqHCeXGPpGhjhBIJEj8Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747661598; c=relaxed/simple;
	bh=jHgWOBxzx5dTInArSIe2BM1FoAAaw/NBzedcsnz5NiY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gugsv3fTLlpbiK/m76Fo4Vyoxmw4lzt1Hq/rk/GezGm05rrfWxT2o3gzR6Mgrmxz/3KQ8KJ8YWGKjGa0tUGPt2A7t7vDit6UKpp2Ijq2j1QrehCO+JLt5eU46w/O1TC0h171DAXvzXd4oZ3fSmEzUgsczNvQvZS4nVC5Kaj9nKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uX4rMEit; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e33ae9d5so4792394a12.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 06:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747661596; x=1748266396; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FvLZsiXrPAyh1Bbl3HJpRcMEjvQv6pVW+DaknJ9dPg0=;
        b=uX4rMEitfhxweSgvsu9e45FBuL/Tur5rKF1/8TrLANNnsSX0UfRNJG8LeRO1/qlume
         hpeBuMNGuIHDG0mmbGGNfXYUu5CgM4u06n1uGcwecLDETyOhHHZYH4mAwLCFP/1/gpTx
         RL+u/caZAG5EfOwzGOnhRNMVNFysgPRieqq4ZuF5GE/YVm4pgQWVVcKs1txuqlkGZuyE
         s2gE5/RX8cY0aVsJH64IElo1plxSjCNsiLznnf1GYEibi81S/7otcjvyXUoe+jxxxnmo
         uyZ1qwWrdEUnzvVm4uSAyLic/83oQ14/M7hzp/as7nOgmHOEB1YrpV/B5lw8Q5vGUPM4
         4OxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747661596; x=1748266396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FvLZsiXrPAyh1Bbl3HJpRcMEjvQv6pVW+DaknJ9dPg0=;
        b=HjzTaGIlinE6Q4XBJlku1bHyAm/FFO9J8qinUbMa1wBthNMU1fM3PwxY1OQ+lE8auJ
         XL0rpg9A4H5LuItpESZIpQfvnKOP9+5jOGTBMQjfpiimS3e6bjnCPxRR5J1uzv5OoxDo
         VImY9s26wiOO6GwP9TOzUCm3YVJCG8M274j9x9SEye8OkDRHCegcJmbqiqZJ8uRzYWzW
         4b7AfHs4FCTtglZARodfNR8+Atjn42FU6A3raj2BKnuRXRAK8/3rSpXSmNBmOExxC6aM
         32m8CHPNdUKBP8eiZXizG8TT850GP1nbmI8cng2L9dYmtABfzwVtKY1LwLXuCFIUoSd0
         HjVg==
X-Forwarded-Encrypted: i=1; AJvYcCWybZV/QRlW8VdS2F9WTS9NHiy5bUjlpJX1kxPDthSeKPIZLSHN0MiA1S/G9hz7td2FtKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkxpR9nYqHdabG3zXIbeECXmN/tUaTRzHUmzzYADTYhAQKSb2K
	C4KGryAmUmN5cG91i4q1utb06TijqRZ3vZpItgyYtzXxJMukSDOVIXSweePfvTh9FauaXTgtKKH
	loMGNXw==
X-Google-Smtp-Source: AGHT+IGQlGMHnXyN7MNExTzbVjD8L4K8e0/XtLxpgEgmqpztJypbMSbyEuiKFbd5p6Qcw+tH6FD0+BpYANo=
X-Received: from pjbrs6.prod.google.com ([2002:a17:90b:2b86:b0:2fc:d77:541])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b01:b0:30a:dc08:d0fe
 with SMTP id 98e67ed59e1d1-30e8314fd42mr22256449a91.16.1747661595689; Mon, 19
 May 2025 06:33:15 -0700 (PDT)
Date: Mon, 19 May 2025 06:33:14 -0700
In-Reply-To: <20250519023737.30360-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519023613.30329-1-yan.y.zhao@intel.com> <20250519023737.30360-1-yan.y.zhao@intel.com>
Message-ID: <aCsy-m_esVjy8Pey@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault
 retry on invalid slot
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, reinette.chatre@intel.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, May 19, 2025, Yan Zhao wrote:
> Introduce a new return value RET_PF_RETRY_INVALID_SLOT to inform callers of
> kvm_mmu_do_page_fault() that a fault retry is due to an invalid memslot.
> This helps prevent deadlocks when a memslot is removed during pre-faulting
> GPAs in the memslot or local retry of faulting private pages in TDX.
> 
> Take pre-faulting as an example.
> 
> During ioctl KVM_PRE_FAULT_MEMORY, kvm->srcu is acquired around the
> pre-faulting of the entire range. For x86, kvm_arch_vcpu_pre_fault_memory()
> further invokes kvm_tdp_map_page(), which retries kvm_mmu_do_page_fault()
> if the return value is RET_PF_RETRY.
> 
> If a memslot is deleted during the ioctl KVM_PRE_FAULT_MEMORY, after
> kvm_invalidate_memslot() marks a slot as invalid and makes it visible via
> rcu_assign_pointer() in kvm_swap_active_memslots(), kvm_mmu_do_page_fault()
> may encounter an invalid slot and return RET_PF_RETRY. Consequently,
> kvm_tdp_map_page() will then retry without releasing the srcu lock.
> Meanwhile, synchronize_srcu_expedited() in kvm_swap_active_memslots() is
> blocked, waiting for kvm_vcpu_pre_fault_memory() to release the srcu lock,
> leading to a deadlock.

Probably worth calling out that KVM will respond to signals, i.e. there's no risk
to the host kernel.

> "slot deleting" thread                   "prefault" thread
> -----------------------------            ----------------------
>                                          srcu_read_lock();
> (A)
> invalid_slot->flags |= KVM_MEMSLOT_INVALID;
> rcu_assign_pointer();
> 
>                                          kvm_tdp_map_page();
>                                          (B)
>                                             do {
>                                                r = kvm_mmu_do_page_fault();
> 
> (C) synchronize_srcu_expedited();
> 
>                                             } while (r == RET_PF_RETRY);
> 
>                                          (D) srcu_read_unlock();
> 
> As shown in diagram, (C) is waiting for (D). However, (B) continuously
> finds an invalid slot before (C) completes, causing (B) to retry and
> preventing (D) from being invoked.
> 
> The local retry code in TDX's EPT violation handler faces a similar issue,
> where a deadlock can occur when faulting a private GFN in a slot that is
> concurrently being removed.
> 
> To resolve the deadlock, introduce a new return value
> RET_PF_RETRY_INVALID_SLOT and modify kvm_mmu_do_page_fault() to return
> RET_PF_RETRY_INVALID_SLOT instead of RET_PF_RETRY when encountering an
> invalid memslot. This prevents endless retries in kvm_tdp_map_page() or
> tdx_handle_ept_violation(), allowing the srcu to be released and enabling
> slot removal to proceed.
> 
> As all callers of kvm_tdp_map_page(), i.e.,
> kvm_arch_vcpu_pre_fault_memory() or tdx_gmem_post_populate(), are in
> pre-fault path, treat RET_PF_RETRY_INVALID_SLOT the same as RET_PF_EMULATE
> to return -ENOENT in kvm_tdp_map_page() to enable userspace to be aware of
> the slot removal.

Userspace should already be "aware" of the slot removal.

> Returning RET_PF_RETRY_INVALID_SLOT in kvm_mmu_do_page_fault() does not
> affect kvm_mmu_page_fault() and kvm_arch_async_page_ready(), as their
> callers either only check if the return value > 0 to re-enter vCPU for
> retry or do not check return value.
> 
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>

Was this hit by a real VMM?  If so, why is a TDX VMM removing a memslot without
kicking vCPUs out of KVM?

Regardless, I would prefer not to add a new RET_PF_* flag for this.  At a glance,
KVM can simply drop and reacquire SRCU in the relevant paths.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cbc84c6abc2e..ceab756052eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4866,7 +4866,12 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
                        return -EIO;
 
                cond_resched();
+
                r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
+               if (r == RET_PF_RETRY) {
+                       kvm_vcpu_srcu_read_unlock(vcpu);
+                       kvm_vcpu_srcu_read_lock(vcpu);
+               }
        } while (r == RET_PF_RETRY);
 
        if (r < 0)
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..e29966ce3ab7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1920,6 +1920,9 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
                        break;
                }
 
+               kvm_vcpu_srcu_read_unlock(vcpu);
+               kvm_vcpu_srcu_read_lock(vcpu);
+
                cond_resched();
        }
        return ret;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b24db92e98f3..21a3fa7476dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4266,7 +4266,6 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
                                     struct kvm_pre_fault_memory *range)
 {
-       int idx;
        long r;
        u64 full_size;
 
@@ -4279,7 +4278,7 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
                return -EINVAL;
 
        vcpu_load(vcpu);
-       idx = srcu_read_lock(&vcpu->kvm->srcu);
+       kvm_vcpu_srcu_read_lock(vcpu);
 
        full_size = range->size;
        do {
@@ -4300,7 +4299,7 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
                cond_resched();
        } while (range->size);
 
-       srcu_read_unlock(&vcpu->kvm->srcu, idx);
+       kvm_vcpu_srcu_read_unlock(vcpu);
        vcpu_put(vcpu);
 
        /* Return success if at least one page was mapped successfully.  */

