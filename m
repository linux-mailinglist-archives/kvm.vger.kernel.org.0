Return-Path: <kvm+bounces-70613-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QIY5BdINimlrGAAAu9opvQ
	(envelope-from <kvm+bounces-70613-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:39:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA4F112964
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3224304C136
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 16:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0389381709;
	Mon,  9 Feb 2026 16:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ql6P+TLK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CB3381703
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 16:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770655033; cv=none; b=ooYcKXCN3ZSPIfCcU9tCpBXiB/0HZJVWASZxvLA/0C8x3ma933950i+gD3Oo/4CyZM1kEj/BzlOBNryt6mUaWzPX0XildX0u5X8P6rL08sl58ChpsZK474iWVjhHMm+SlXNnnWbUif6Ce1uGnVBumMvBnaiYvEg/HF/eLyxIo/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770655033; c=relaxed/simple;
	bh=5EUUtb5uh5RoUhX4E+Fuvp0m3XUTmsvBWhZhSezBQg0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C534cbfko+vprck5JWheALHkoy0wrKj+tB9iyZAJnSqRkEA6zAHPQf3E5Zv7rtSE4CCOUu34t52ihtfGPqQ43UNUdPyxCI+xy5CMXh82IdQm7/u/VIF6//vtRgbqtZp8s+pytzwJDO/7hZXTshyT8XGXnsrtlPpW41j2S8nstpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ql6P+TLK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c72d23dfso6539897a91.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 08:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770655032; x=1771259832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZKHdX8ri1hG3E0/yuU4YwpP9v2mui2eL9oHLnAy868=;
        b=ql6P+TLKEhzwDk87BMBE1xb1vtEMyjw2my/D5Eb1Xg1og0AktL0WJhggcb27SivLci
         GSeCxLuYnPK8Fbh9pcGzno8vF+bCuCgWyRYp2KbZKIaxR5K/fhLNZoB2lqp5tWwunCbi
         jipghSGvvclWo4ReX2M9aRV27KelEJFhj2QvnD1ng3XlSI0/OVh7Mx2I/FuD2A8UzKyM
         xSXMh0inhxKPpxv0mbcv32AWLoXzPjsJiA78ro6JN2GiNu4sRZKkAPwMQggoHnWslLdN
         4Me7aHR6wixdCpyP07lDCFH4GHziYhcqAIE9NzclB2fBYlQ3nh570PUO4zor2tZmkwWP
         xhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770655032; x=1771259832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sZKHdX8ri1hG3E0/yuU4YwpP9v2mui2eL9oHLnAy868=;
        b=XUeJiIeH5UxbRuPl3dDXA+BTHWN63WvFhEYLy6Scq+QhfvvSqwmkAYmdscp9uks/Z/
         pIjoA/EldkpYbx9SyzYH6ANMnIPdW0df66M26nk2pHPH/4N4JqO3OUgqPRlpdG28yC+8
         kdpTjDfsav/Vu5PznXCXiDByt0BinOuW0MivzBPxPu6e4LhD5NwIXP/rQPFJFOjvclWZ
         az7aGFW0fSXAHuXmrAganeJa1mnJy/mYZcZAtcv8SAEQH0BVayiaBUlPYbgdtYhayaif
         GCAjutmy/lI2IAqdeMA94RCtlnsLTZcmskCfXQZy5aPd46zk/b7fHPW0gkHyJD3lpyCE
         JbZA==
X-Forwarded-Encrypted: i=1; AJvYcCXoHEqCBq/2ucwtlkfyeLfznrsGzNWQNvrfOEO12ZhWmUmOh/0NUh0K+ufLv5UW8s1FQYg=@vger.kernel.org
X-Gm-Message-State: AOJu0YznYWoB+ahemkqyTGAoYMCVRWVqfooljfgDPjoh5/ZQfKGx0Paz
	Evh652oRqxHQQKOgmY3Dfrr2vcgOyyOp70cShmzlkyO0GGQ2KwuRbyjAOouWFiuQvVyllEpBbzQ
	7qWQfRw==
X-Received: from pjjj15.prod.google.com ([2002:a17:90a:60f:b0:356:2e5c:5ad9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c81:b0:356:2872:9c53
 with SMTP id 98e67ed59e1d1-35628729f86mr5296613a91.14.1770655032317; Mon, 09
 Feb 2026 08:37:12 -0800 (PST)
Date: Mon, 9 Feb 2026 08:37:11 -0800
In-Reply-To: <20260209041305.64906-3-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209041305.64906-1-zhiquan_li@163.com> <20260209041305.64906-3-zhiquan_li@163.com>
Message-ID: <aYoNN64cAp9f_0k8@google.com>
Subject: Re: [PATCH RESEND 2/5] KVM: x86: selftests: Alter the instruction of
 hypercall on Hygon
From: Sean Christopherson <seanjc@google.com>
To: Zhiquan Li <zhiquan_li@163.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70613-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[163.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6FA4F112964
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Zhiquan Li wrote:
> Hygon architecture uses VMMCALL as guest hypercall instruction.  Now,
> the test like "fix hypercall" uses VMCALL and then results in test
> failure.
> 
> Utilize the Hygon-specific flag to identify if the test is running on
> Hygon CPU and alter the instruction of hypercall if needed.
> 
> Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
> ---
>  tools/testing/selftests/kvm/lib/x86/processor.c      | 3 ++-
>  tools/testing/selftests/kvm/x86/fix_hypercall_test.c | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index bbd3336f22eb..64f9ecd2387d 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -1229,7 +1229,8 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
>  		     "1: vmmcall\n\t"					\
>  		     "2:"						\
>  		     : "=a"(r)						\
> -		     : [use_vmmcall] "r" (host_cpu_is_amd), inputs);	\
> +		     : [use_vmmcall] "r"				\
> +		     (host_cpu_is_amd || host_cpu_is_hygon), inputs);	\

Rather than play a constant game of whack-a-mole and end up with a huge number of
"host_cpu_is_amd || host_cpu_is_hygon" checks, I would prefer to add (in addition
to host_cpu_is_hygon) a "host_cpu_is_amd_compatible" flag.

E.g. slotted in after patch 1, something like this:

---
 tools/testing/selftests/kvm/include/x86/processor.h  | 1 +
 tools/testing/selftests/kvm/lib/x86/processor.c      | 8 ++++++--
 tools/testing/selftests/kvm/x86/fix_hypercall_test.c | 2 +-
 tools/testing/selftests/kvm/x86/msrs_test.c          | 2 +-
 tools/testing/selftests/kvm/x86/xapic_state_test.c   | 2 +-
 5 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 1338de7111e7..40e3deb64812 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -22,6 +22,7 @@
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
 extern bool host_cpu_is_hygon;
+extern bool host_cpu_is_amd_compatible;
 extern uint64_t guest_tsc_khz;
 
 #ifndef MAX_NR_CPUID_ENTRIES
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index f6b1c5324931..7b7fd2ad148f 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -24,6 +24,7 @@ vm_vaddr_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
 bool host_cpu_is_hygon;
+bool host_cpu_is_amd_compatible;
 bool is_forced_emulation_enabled;
 uint64_t guest_tsc_khz;
 
@@ -794,6 +795,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus)
 	sync_global_to_guest(vm, host_cpu_is_intel);
 	sync_global_to_guest(vm, host_cpu_is_amd);
 	sync_global_to_guest(vm, host_cpu_is_hygon);
+	sync_global_to_guest(vm, host_cpu_is_amd_compatible);
 	sync_global_to_guest(vm, is_forced_emulation_enabled);
 	sync_global_to_guest(vm, pmu_errata_mask);
 
@@ -1350,7 +1352,8 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
 		     "1: vmmcall\n\t"					\
 		     "2:"						\
 		     : "=a"(r)						\
-		     : [use_vmmcall] "r" (host_cpu_is_amd), inputs);	\
+		     : [use_vmmcall] "r" (host_cpu_is_amd_compatible),	\
+		       inputs);						\
 									\
 	r;								\
 })
@@ -1391,7 +1394,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 	max_gfn = (1ULL << (guest_maxphyaddr - vm->page_shift)) - 1;
 
 	/* Avoid reserved HyperTransport region on AMD processors.  */
-	if (!host_cpu_is_amd)
+	if (!host_cpu_is_amd_compatible)
 		return max_gfn;
 
 	/* On parts with <40 physical address bits, the area is fully hidden */
@@ -1427,6 +1430,7 @@ void kvm_selftest_arch_init(void)
 	host_cpu_is_intel = this_cpu_is_intel();
 	host_cpu_is_amd = this_cpu_is_amd();
 	host_cpu_is_hygon = this_cpu_is_hygon();
+	host_cpu_is_amd_compatible = host_cpu_is_amd || host_cpu_is_hygon;
 	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
 
 	kvm_init_pmu_errata();
diff --git a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
index 762628f7d4ba..00b6e85735dd 100644
--- a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
@@ -52,7 +52,7 @@ static void guest_main(void)
 	if (host_cpu_is_intel) {
 		native_hypercall_insn = vmx_vmcall;
 		other_hypercall_insn  = svm_vmmcall;
-	} else if (host_cpu_is_amd) {
+	} else if (host_cpu_is_amd_compatible) {
 		native_hypercall_insn = svm_vmmcall;
 		other_hypercall_insn  = vmx_vmcall;
 	} else {
diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 40d918aedce6..4c97444fdefe 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -81,7 +81,7 @@ static u64 fixup_rdmsr_val(u32 msr, u64 want)
 	 * is supposed to emulate that behavior based on guest vendor model
 	 * (which is the same as the host vendor model for this test).
 	 */
-	if (!host_cpu_is_amd)
+	if (!host_cpu_is_amd_compatible)
 		return want;
 
 	switch (msr) {
diff --git a/tools/testing/selftests/kvm/x86/xapic_state_test.c b/tools/testing/selftests/kvm/x86/xapic_state_test.c
index 3b4814c55722..0c5e12f5f14e 100644
--- a/tools/testing/selftests/kvm/x86/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_state_test.c
@@ -248,7 +248,7 @@ int main(int argc, char *argv[])
 	 * drops writes, AMD does not).  Account for the errata when checking
 	 * that KVM reads back what was written.
 	 */
-	x.has_xavic_errata = host_cpu_is_amd &&
+	x.has_xavic_errata = host_cpu_is_amd_compatible &&
 			     get_kvm_amd_param_bool("avic");
 
 	vcpu_clear_cpuid_feature(x.vcpu, X86_FEATURE_X2APIC);

base-commit: 391774310e7309b5a1ee12fac9264e95b1d4a6ee
--

