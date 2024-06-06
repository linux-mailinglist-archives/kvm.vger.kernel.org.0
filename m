Return-Path: <kvm+bounces-19014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E2F8FF039
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 17:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49C87283265
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 15:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05667197A95;
	Thu,  6 Jun 2024 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EZy/949R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBDB196C93
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717685729; cv=none; b=IykFB6Tcu0bEiTDB1BR2suiot7LLmighiOi0G1yCj6S4NcpdyGiLJohUDfSJ+vdsKJMBfxsecK0e22/Ow+aMyrYK7OavKn02M7KR02v3iVHy7PJ4LA7zPXv2eBSA5RVZ3ST17NXUtpDOhBJCaZzF+K8oYvXrjpG5LVSKiEiiyhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717685729; c=relaxed/simple;
	bh=1emOfc6sWAVNJYrDhkLHYVxsjkjT40hYcmoSgJYNLTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tdINhMgNNfo7TSjU9uwY2Dr+C+dkV9TxVD1xjYF4/P/eIJbYkHUd7VlEJRqh3mwSIt6+ZCJZnYV+6HWUFsMrhndApLVkGk58+qRurhGnvM8B4ClUk9/ULW8cgUJYFrlva6P7zy3g2KrjuKSvgdXbN/ejjlLG3QHbTM4KUNTdBH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EZy/949R; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c1a559a0e8so1788104a91.1
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 07:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717685727; x=1718290527; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bI+dkBP1bBqcBEByFqa0Zzf7Z65NtfQbzQwTEUpEDnE=;
        b=EZy/949R841ghNpLahx+tT/ZZvX4dltzlpO6zTR+azOUBeGnJf9FEvXinn3DOllg4Z
         A4spU19uHlfcC4o5QCXMbNJWdIEYtbj743/nTWfFEM+uTPOuzaLQYo3K4LTjnYSdUOyQ
         pHQkJBvC8fWhI/t1b/rXsuQyhTAV/vIpNYTyjx97tGxFlspNX5onpHt3J67K9jxSRkuo
         Lhe7D9NEcyD/d+aNKUA24rtsR2imcIHsusElQGn8Bv5IdvppIpAH1zCfO2FTKDxYqSzn
         lp+b44IQicA+C0CNinx2/I2iRz6abbb3AGUiEXr5uqUhtQdxI3707OTIUZvcZloK4J5e
         qvmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717685727; x=1718290527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bI+dkBP1bBqcBEByFqa0Zzf7Z65NtfQbzQwTEUpEDnE=;
        b=QXVyzleK1hz4+EJdnNA56Z7bPl/YYuz8mCrj9IEXKLNo41+Pdw9+AYg3zFtEltDP9x
         1tX1WmkillYVKCPG1cCgxIsM5cfrbW/grCAwlOL/fvnJYEc5eyT4JRB1LpQdgSCBwJWM
         LM45K54vLp6pkYKGMGJ3DRD0Wr7TXHdkBIqXwE5tFNgRT6RSYdOUwtJSWxKrk8Uh9qnh
         ung3JGUgFSMWoKyxGW5valm2DLazMslU5AGBip+fG+/sAkOLuwoFkZSs+KouM58i3yWU
         Y+DWFWR+VGoJMdQurtbUWf11x8yvazI+vSRAe2EbBgfa3BpmblXzYu7gBdsA5+BtAzVy
         c+Xw==
X-Forwarded-Encrypted: i=1; AJvYcCVhb+aBLKk+AK3FrUQvmu++Jb8Qh9zyn1J+5/onIZM2xQ2+6nvQazZfeKUKs0SP27gf5TLcXHpBbOHbyMU6MhlnLLTH
X-Gm-Message-State: AOJu0YyU1m0/s9KTQ/c1XeB6VkgEaTL2aB56gsiH3XD6hSg+rWrCrSWZ
	lA3ShHojWYmtsg5dbkdwI+ogWhqMb9QewTWzfwbcdilZOkA+jJP9czjfijgY5SmerA2sDm7wYld
	Z5w==
X-Google-Smtp-Source: AGHT+IEdsKI+Ho4iAX9vUKwS43x6LOlKLxQIxHdYgds0SiXzqovdG3nqW/X/SXZXkbCffsq08/VG+0F7LBc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fe8b:b0:2bd:d5ea:5b2a with SMTP id
 98e67ed59e1d1-2c2999c4161mr14451a91.4.1717685726504; Thu, 06 Jun 2024
 07:55:26 -0700 (PDT)
Date: Thu, 6 Jun 2024 07:55:25 -0700
In-Reply-To: <0ef7c46b-669b-4f46-9bb8-b7904d4babea@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605220504.2941958-1-minipli@grsecurity.net>
 <20240605220504.2941958-2-minipli@grsecurity.net> <ZmDnQkNL5NYUmyMN@google.com>
 <0ef7c46b-669b-4f46-9bb8-b7904d4babea@grsecurity.net>
Message-ID: <ZmHN3SUsnTXI_71J@google.com>
Subject: Re: [PATCH 1/2] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 06, 2024, Mathias Krause wrote:
> On 06.06.24 00:31, Sean Christopherson wrote:
> > On Thu, Jun 06, 2024, Mathias Krause wrote:
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index 14841acb8b95..9f18fc42f018 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -4200,7 +4200,7 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
> >>  /*
> >>   * Creates some virtual cpus.  Good luck creating more than one.
> >>   */
> >> -static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> >> +static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> > 
> > Hmm, I don't love that KVM subtly relies on the KVM_MAX_VCPU_IDS check to guard
> > against truncation when passing @id to kvm_arch_vcpu_precreate(), kvm_vcpu_init(),
> > etc.  I doubt that it will ever be problematic, but it _looks_ like a bug.
> 
> It's not subtle but very explicit. KVM_MAX_VCPU_IDS is a small positive
> number, depending on some arch specific #define, but with x86 allowing
> for the largest value of 4 * 4096. That value, for sure, cannot exceed
> U32_MAX, so an explicit truncation isn't needed as the upper bits will
> already be zero if the limit check passes.
> 
> While subtile integer truncation is the bug that my patch is actually
> fixing, it is for the *userland* facing part of it, as in clarifying the
> ABI to work on "machine-sized words", i.e. a ulong, and doing the limit
> checks on these.
> 
> *In-kernel* APIs truncate / sign extend / mix signed/unsigned values all
> the time. The kernel is full of these. Trying to "fix" them all is an
> uphill battle not worth fighting, imho.

Oh, I'm not worry about something going wrong with the actual truncation.

What I don't like is the primary in-kernal API, kvm_vm_ioctl_create_vcpu(), taking
an unsigned long, but everything underneath converting that to an unsigned int,
without much of anything to give the reader a clue that the truncation is
deliberate.  

Similarly, without the context of the changelog, it's not at all obvious why
kvm_vm_ioctl_create_vcpu() takes an unsigned long.

E.g. x86 has another potentially more restrictive check on @id, and it looks
quite odd to check @id against KVM_MAX_VCPU_IDS as an "unsigned long" in flow
flow, but as an "unsigned int" in another.

int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
{
	if (kvm_check_tsc_unstable() && kvm->created_vcpus)
		pr_warn_once("SMP vm created on host with unstable TSC; "
			     "guest TSC will not be reliable\n");

	if (!kvm->arch.max_vcpu_ids)
		kvm->arch.max_vcpu_ids = KVM_MAX_VCPU_IDS;

	if (id >= kvm->arch.max_vcpu_ids)
		return -EINVAL;

> I'd rather suggest to add a build time assert instead, as the existing
> runtime check is sufficient (with my u32->ulong change). Something like
> this:
> 
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4200,12 +4200,13 @@ static void kvm_create_vcpu_debugfs(struct
> kvm_vcpu *vcpu)
>  /*
>   * Creates some virtual cpus.  Good luck creating more than one.
>   */
> -static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> +static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  {
>         int r;
>         struct kvm_vcpu *vcpu;
>         struct page *page;
> 
> +       BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);

This should be UINT_MAX, no?  Regardless, the "need" for an explicit BUILD_BUG_ON()
is another reason I dislike relying on the KVM_MAX_VCPU_IDS check to detect
truncation.  If @id is checked as a 32-bit value, and we somehow screw up and
define KVM_MAX_VCPU_IDS to be a 64-bit value, clang will rightly complain that
the check is useless, e.g. given "#define KVM_MAX_VCPU_ID_TEST	BIT(32)"

arch/x86/kvm/x86.c:12171:9: error: result of comparison of constant 4294967296 with
expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (id > KVM_MAX_VCPU_ID_TEST)
            ~~ ^ ~~~~~~~~~~~~~~~~~~~~
1 error generated.


>         if (id >= KVM_MAX_VCPU_IDS)
>                 return -EINVAL;

What if we do an explicit check before calling kvm_vm_ioctl_create_vcpu()?  That
would avoid the weird __id param, and provide a convenient location to document
exactly why KVM checks for truncation.

We could also move the "if (id >= KVM_MAX_VCPU_IDS)" check to kvm_vm_ioctl(),
but I don't love that, because again IMO it makes the code less readable overall,
loses clang's tuautological constant check, and the cost of the extra check against
UINT_MAX is completely negligible.  

Though if I had to choose, I'd prefer moving the check to kvm_vm_ioctl() over
taking an "unsigned long" in kvm_vm_ioctl_create_vcpu().

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4965196cad58..8155146b16cd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5083,6 +5083,13 @@ static long kvm_vm_ioctl(struct file *filp,
                return -EIO;
        switch (ioctl) {
        case KVM_CREATE_VCPU:
+               /*
+                * KVM tracks vCPU ID as a 32-bit value, be kind to userspace
+                * and reject too-large values instead of silently truncating.
+                */
+               if (arg > UINT_MAX)
+                       return -EINVAL;
+
                r = kvm_vm_ioctl_create_vcpu(kvm, arg);
                break;
        case KVM_ENABLE_CAP: {

