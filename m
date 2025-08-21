Return-Path: <kvm+bounces-55221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51EFDB2E988
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 02:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6F091BA3561
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 00:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A131E493C;
	Thu, 21 Aug 2025 00:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PsDL5PWq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD0B1D6DA9
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 00:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755737010; cv=none; b=P4IgckqkERB+hhKx0s35+PrqAMNUndPvDwl0hgX5KEE+Izq7jVP6KbcJh2yEDjJvqTCQt+Nf42Csmyv6td8xjWCxNPLLV8QffhY0WNRJTrsPp6m9uASiP3YKNETzS+jlO0FlSGfqOc+PGd469FAIpakqVWYATy9nDwMLCf+tOCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755737010; c=relaxed/simple;
	bh=vhytZwPel8T830TlJ2/6ZDAycH6QqgmVEv+1cHUk4vQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S/71F6Rghm1SMpzZT0WmeFBMZsmAaLX0SmMjpfLb+6ofR5/GG4HlnNE4s3ohTL9Vf1aDvikb60lHGCj7npOz3JlXQIQSD4OIgdlA9ZFI4go2/evZ4HqCPHtdIHnqVO1s0aIDpRlq9j23dnzk5FQ4pUjzYgm8lgxpXvLl6LU8Paw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PsDL5PWq; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457f54bb2so14602685ad.0
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 17:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755737007; x=1756341807; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ps/kTtodZQa9TXI+aUEphNMUJfCKk7Drm2oBaNOi7Eo=;
        b=PsDL5PWqiF9iLmgtOIdEhMjF5WbHZC/j+YL/yYifSJRova42uwSsV/lLcAouxv9UdJ
         qdc0N7EddiUYSldlwawwzYPxGpRf85VQPfECIHzpvMfzCDL42Xg8cEizkxGL0u5+x638
         McpzNMq+v5RhKRLvTvuUl890mBr91kXPO2lhnlzWGDJYQE7FnUE82FCR58EPOx3gq+QM
         Bt9Jid5u0VYf53npxV8jiVoWWcZ38CKC5xLNZdXayQ6rH2S/rN8KSTY0/0y+FrFswiQB
         3rO6Z6ZDO4pzr+bAez28OfWDOEyt3xs/J3gckBatIngE6wGa0/ojs6Kc7Yc53P2WIVes
         sEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755737007; x=1756341807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ps/kTtodZQa9TXI+aUEphNMUJfCKk7Drm2oBaNOi7Eo=;
        b=GfZNVvG37ftI87pmGqNY6HuJQf7hj1erqa0xiPdNonScxMFSeeb7rZZMTfc5hyvCNe
         TSBG/vgweS4EHAS7pUoGL3d2MGYP/5QVboXKu7STCpqTU/oEoel4LjfCKJQ6WoINanMS
         xvJSyiZVad4nAKvGSXvnB9rysiurgIwdW4dlGcCDXPkenMas4IQnvBIixwLiRpqxfIcT
         2jB+A3YeI4zFVeckW76XwnSVKgUmBevChdqvvzsRSM8JGrYCu0AQBuQhvEMfjILwDa/n
         m06bXiprW8ULuRhF4bWuvnc6gbxCCdifTKZ7WJVzjlRoGJruKMJSJOTFHsfrelt7lY+z
         wyWw==
X-Forwarded-Encrypted: i=1; AJvYcCW4NPwEcUU4aHH3OUeXKd1JzOga26L8MhCtSPtX925H2fZ3dh8lm9fqWKYaJubJoFTa8dk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0M0MfOnu0GmgfoWshIfWL4XX4i1XLI+8HwqLgb2p9xYUnzBRW
	pxRLWe1LJkcKvpt8Lu1w/YHQQpCnle6isxJHYZS9gqyb8uUCJdqoVGL7KxbVmqMO44cPxijfhIK
	X+2EDsg==
X-Google-Smtp-Source: AGHT+IH6Dko6nhOYoApLod7mtAicFUQqfqjCRUh1qO5i3YPQu1reIPgbQGREjEMBdqt90/rsfwVY8E1bDbk=
X-Received: from plhs13.prod.google.com ([2002:a17:903:320d:b0:240:c762:e655])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:240c:b0:243:926:b1f3
 with SMTP id d9443c01a7336-245febef89dmr10048865ad.24.1755737007008; Wed, 20
 Aug 2025 17:43:27 -0700 (PDT)
Date: Wed, 20 Aug 2025 17:43:25 -0700
In-Reply-To: <20250722055030.3126772-3-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250722055030.3126772-1-suleiman@google.com> <20250722055030.3126772-3-suleiman@google.com>
Message-ID: <aKZrrW77QzB6ee10@google.com>
Subject: Re: [PATCH v8 2/3] KVM: x86: Include host suspended duration in steal time
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	John Stultz <jstultz@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, Suleiman Souhlal wrote:
> Introduce MSR_KVM_SUSPEND_STEAL which controls whether or not a guest
> wants the duration of host suspend to be included in steal time.
>
> This lets guests subtract the duration during which the host was
> suspended from the runtime of tasks that were running over the suspend,
> in order to prevent cases where host suspend causes long runtimes in
> guest tasks, even though their effective runtime was much shorter.

This is far too terse.  There are a _lot_ of subtleties and wrinkles in this
code need to be captured.  A persistent reader can find them in the lore links,
but I want to cover the main points in the changelog.

I actually don't mind putting that together, it's a good way to remind myself of
what this is so doing, so feel free to ignore this and I can fixup when applying.

> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index a1efa7907a0b..678ebc3d7eeb 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -36,6 +36,7 @@
>  #define KVM_FEATURE_MSI_EXT_DEST_ID	15
>  #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
>  #define KVM_FEATURE_MIGRATION_CONTROL	17
> +#define KVM_FEATURE_SUSPEND_STEAL	18
>  
>  #define KVM_HINTS_REALTIME      0
>  
> @@ -58,6 +59,7 @@
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>  #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
> +#define MSR_KVM_SUSPEND_STEAL	0x4b564d09

I'm pretty sure we don't need a new MSR.  There are 4 bits (I think; KVM's
#defines are horrific) in MSR_KVM_STEAL_TIME that are currently reserved, we
can simply grab one of those.

Using MSR_KVM_STEAL_TIME also makes it more obvious that SUSPEND_STEAL has a
hard dependency on STEAL_TIME being enabled.

> @@ -7027,13 +7045,52 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
>  {
>  	struct kvm_vcpu *vcpu;
>  	unsigned long i;
> +	bool kick_vcpus = false;
>  
> -	/*
> -	 * Ignore the return, marking the guest paused only "fails" if the vCPU
> -	 * isn't using kvmclock; continuing on is correct and desirable.
> -	 */
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (vcpu->arch.msr_kvm_suspend_steal & KVM_MSR_ENABLED) {
> +			kick_vcpus = true;
> +			WRITE_ONCE(vcpu->arch.st.suspend_ts,
> +				   ktime_get_boottime_ns());
> +		}
> +		/*
> +		 * Ignore the return, marking the guest paused only "fails" if
> +		 * the vCPU isn't using kvmclock; continuing on is correct and
> +		 * desirable.
> +		 */
>  		(void)kvm_set_guest_paused(vcpu);
> +	}
> +

This should have a comment.  I'm pretty sure I suggested this idea, and it still
took me a good 5 minutes to figure out what this code was doing.

	/*
	 * Force vCPUs to exit from KVM's inner run loop to ensure they see
	 * suspend_ts and block until KVM's resume notifier runs.
	 */


> +	if (kick_vcpus)
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static int

Do not wrap before the function name.  Linus has a nice explanation/rant on this:

https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com

> +kvm_arch_resume_notifier(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		u64 suspend_ns = ktime_get_boottime_ns() -
> +				 vcpu->arch.st.suspend_ts;
> +
> +		WRITE_ONCE(vcpu->arch.st.suspend_ts, 0);
> +
> +		/*
> +		 * Only accumulate the suspend time if suspend steal-time is
> +		 * enabled, but always clear suspend_ts and kick the vCPU as
> +		 * the vCPU could have disabled suspend steal-time after the
> +		 * suspend notifier grabbed suspend_ts.
> +		 */
> +		if (vcpu->arch.msr_kvm_suspend_steal & KVM_MSR_ENABLED)

This should arguably also check STEAL_TIME is enabled.  And regardless of which
MSR is used, this needs to be READ_ONCE() since the vCPU could modify the value
while KVM is running this code.

The other option would be to only check the MSR from within KVM_RUN, but getting
that right would probably be even harder, and in practice a false negative/positive
is a non-issue.

Related to toggling the MSR, arguably arch.st.suspend_ns should be zeroed if
SUSPEND_STEAL is disabled, but I don't expect a guest to ever disable SUSPEND_STEAL
and also re-enabled it at a later time, _and_ AFAICT STEAL_TIME doesn't work that
way either, i.e. it keeps accumulating stolen time and throws it all at the guest
if/when STEAL_TIME is enabled.

> +			atomic64_add(suspend_ns, &vcpu->arch.st.suspend_ns);
> +
> +		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
> +		kvm_vcpu_kick(vcpu);
> +	}

Compile tested only, but this?

---
 Documentation/virt/kvm/x86/cpuid.rst |  3 +
 Documentation/virt/kvm/x86/msr.rst   |  6 ++
 arch/x86/include/asm/kvm_host.h      |  2 +
 arch/x86/include/uapi/asm/kvm_para.h |  2 +
 arch/x86/kvm/cpuid.c                 |  4 +-
 arch/x86/kvm/x86.c                   | 83 +++++++++++++++++++++++++---
 6 files changed, 92 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/x86/cpuid.rst b/Documentation/virt/kvm/x86/cpuid.rst
index bda3e3e737d7..0fa96a134718 100644
--- a/Documentation/virt/kvm/x86/cpuid.rst
+++ b/Documentation/virt/kvm/x86/cpuid.rst
@@ -103,6 +103,9 @@ KVM_FEATURE_HC_MAP_GPA_RANGE       16          guest checks this feature bit bef
 KVM_FEATURE_MIGRATION_CONTROL      17          guest checks this feature bit before
                                                using MSR_KVM_MIGRATION_CONTROL
 
+KVM_FEATURE_SUSPEND_STEAL          18          guest checks this feature bit
+                                               before enabling KVM_STEAL_SUSPEND_TIME
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index 3aecf2a70e7b..367842311ed3 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -296,6 +296,12 @@ data:
 		the amount of time in which this vCPU did not run, in
 		nanoseconds. Time during which the vcpu is idle, will not be
 		reported as steal time.
+		If the guest sets KVM_STEAL_SUSPEND_TIME, steal time includes
+		the duration during which the host is suspended.  The case
+		where the host suspends during a VM migration might not be
+		accounted if VCPUs don't enter the guest post-resume.  A
+		workaround would be for the VMM to ensure that the guest is
+		entered with KVM_RUN after resuming from suspend.
 
 	preempted:
 		indicate the vCPU who owns this struct is running or
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0d3cc0fc27af..8e11d08dc701 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -944,6 +944,8 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
+		u64 suspend_ts;
+		atomic64_t suspend_ns;
 		struct gfn_to_hva_cache cache;
 	} st;
 
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index a1efa7907a0b..1bbe2db93890 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -36,6 +36,7 @@
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
+#define KVM_FEATURE_SUSPEND_STEAL	18
 
 #define KVM_HINTS_REALTIME      0
 
@@ -80,6 +81,7 @@ struct kvm_clock_pairing {
 	__u32 pad[9];
 };
 
+#define KVM_STEAL_SUSPEND_TIME			(1 << 1)
 #define KVM_STEAL_ALIGNMENT_BITS 5
 #define KVM_STEAL_VALID_BITS ((-1ULL << (KVM_STEAL_ALIGNMENT_BITS + 1)))
 #define KVM_STEAL_RESERVED_MASK (((1 << KVM_STEAL_ALIGNMENT_BITS) - 1 ) << 1)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ad6cadf09930..9dbb3899bee7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1626,8 +1626,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
-		if (sched_info_on())
+		if (sched_info_on()) {
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
+			entry->eax |= (1 << KVM_FEATURE_SUSPEND_STEAL);
+		}
 
 		entry->ebx = 0;
 		entry->ecx = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ba2cdfdac44..cae1c5a8eb99 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3784,6 +3784,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	if (unlikely(atomic64_read(&vcpu->arch.st.suspend_ns)))
+		steal += atomic64_xchg(&vcpu->arch.st.suspend_ns, 0);
 	unsafe_put_user(steal, &st->steal, out);
 
 	version += 1;
@@ -4052,14 +4054,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			kvm_check_async_pf_completion(vcpu);
 		}
 		break;
-	case MSR_KVM_STEAL_TIME:
+	case MSR_KVM_STEAL_TIME: {
+		u64 reserved = KVM_STEAL_RESERVED_MASK;
+
 		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
 			return 1;
 
 		if (unlikely(!sched_info_on()))
 			return 1;
 
-		if (data & KVM_STEAL_RESERVED_MASK)
+		if (guest_pv_has(vcpu, KVM_FEATURE_SUSPEND_STEAL))
+			reserved &= ~KVM_STEAL_SUSPEND_TIME;
+
+		if (data & reserved)
 			return 1;
 
 		vcpu->arch.st.msr_val = data;
@@ -4070,6 +4077,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
 		break;
+	}
 	case MSR_KVM_PV_EOI_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
 			return 1;
@@ -6858,18 +6866,66 @@ long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
 }
 #endif
 
+static bool kvm_is_suspend_steal_enabled(struct kvm_vcpu *vcpu)
+{
+	u64 val = READ_ONCE(vcpu->arch.st.msr_val);
+
+	return (val & KVM_MSR_ENABLED) && (val & KVM_STEAL_SUSPEND_TIME);
+}
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 static int kvm_arch_suspend_notifier(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
+	bool kick_vcpus = false;
 
-	/*
-	 * Ignore the return, marking the guest paused only "fails" if the vCPU
-	 * isn't using kvmclock; continuing on is correct and desirable.
-	 */
-	kvm_for_each_vcpu(i, vcpu, kvm)
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (kvm_is_suspend_steal_enabled(vcpu)) {
+			kick_vcpus = true;
+			WRITE_ONCE(vcpu->arch.st.suspend_ts,
+				   ktime_get_boottime_ns());
+		}
+		/*
+		 * Ignore the return, marking the guest paused only "fails" if
+		 * the vCPU isn't using kvmclock; continuing on is correct and
+		 * desirable.
+		 */
 		(void)kvm_set_guest_paused(vcpu);
+	}
+
+	/*
+	 * Force vCPUs to exit from KVM's inner run loop to ensure they see
+	 * suspend_ts and block until KVM's resume notifier runs.
+	 */
+	if (kick_vcpus)
+		kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
+
+	return NOTIFY_DONE;
+}
+
+static int kvm_arch_resume_notifier(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		u64 suspend_ns = ktime_get_boottime_ns() -
+				 vcpu->arch.st.suspend_ts;
+		WRITE_ONCE(vcpu->arch.st.suspend_ts, 0);
+
+		/*
+		 * Only accumulate the suspend time if suspend steal-time is
+		 * enabled, but always clear suspend_ts and kick the vCPU as
+		 * the vCPU could have disabled suspend steal-time after the
+		 * suspend notifier grabbed suspend_ts.
+		 */
+		if (kvm_is_suspend_steal_enabled(vcpu))
+			atomic64_add(suspend_ns, &vcpu->arch.st.suspend_ns);
+
+		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
+		kvm_vcpu_kick(vcpu);
+	}
 
 	return NOTIFY_DONE;
 }
@@ -6880,6 +6936,9 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		return kvm_arch_suspend_notifier(kvm);
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return kvm_arch_resume_notifier(kvm);
 	}
 
 	return NOTIFY_DONE;
@@ -11104,6 +11163,16 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 static bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * During host SUSPEND/RESUME tasks get frozen after SUSPEND notifiers
+	 * run, and thawed before RESUME notifiers, i.e. vCPUs can be actively
+	 * running when KVM sees the system as suspended.  Block the vCPU if
+	 * KVM sees the vCPU as suspended to ensure the suspend steal time is
+	 * accounted before the guest can run, and to the correct guest task.
+	 */
+	if (READ_ONCE(vcpu->arch.st.suspend_ts))
+		return false;
+
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
 }

base-commit: 91b392ada892a2e8b1c621b9493c50f6fb49880f
--

