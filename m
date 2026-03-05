Return-Path: <kvm+bounces-72926-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ONsTH8XDqWl3EQEAu9opvQ
	(envelope-from <kvm+bounces-72926-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:56:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BB8F2169FF
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1136630AB177
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9B53A5E97;
	Thu,  5 Mar 2026 17:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SKFE1Zpy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8495928FA91
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772733033; cv=none; b=aZb+iZUYDRwmqvgHLAlUkcRUL6RF5pEXjVDEkwhxJzzTJPhiWiBOdd3ls1KtlS/3YnRnZQqq4YrR7ZHiDMXp6mkJu9XxFaJPcKOUV9EfQFrpxtfEpVw7jIBmXywvnQKVm1zCCs3FkUhoyqFg0h2Q/Nagn+9wgnKfdBeYmL6ep3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772733033; c=relaxed/simple;
	bh=pJQ8g5TP0hmDQ4/6b83s3S93OAhZkcoXKYKt/g76WnA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pxkA2SLBhinpb0xzxDUw0apAagEnQLt5XXTNfDdQwtzATpOCQewARDTrIIJ3JHHJFukP2TwLpw7dkKX0ybJv0l6dfBWaWaY0bP+n6PhKpzns/OYbzqf7q5gV34/1Z1jt3r97wHKvmhTXeZ+rZFe3SpZ032rfhqdPpb41ZytCZQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SKFE1Zpy; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae405e95f5so56828545ad.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772733032; x=1773337832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8au/7yipgWN1+r+E+RWXdIOdOFOabndtCd9xTFDxZq0=;
        b=SKFE1ZpyLJzAdAN0vF4cO+2purwAMbjfQgioTnh/BnmDoWp2+M28wQlzDFdCo8n9E6
         ezde0wsKykOTeb5yTk2FKho0sUNBcfIZrK9ItG8lI1++MovNE8e0dovDDwc3r/eX7xMm
         VXXMwSsoMep9dGwffa7LgCffnF9BOJlG8GWacAPlO3qO2l3kLL2fBhjERe+Mwv68x4+6
         zn+AjHF9qosuE19Up/IRl7GdZHuxPr0Tac+Tm8gLjYmndYQ+wzKq0yMm/TdKSaO9Nq9e
         DAM+cDSRIyJfjxjb5K2qhIU6igUItGhBisCT1ZGq5II02iQFzEJJkcqblakce8OsTNsP
         VguA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772733032; x=1773337832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8au/7yipgWN1+r+E+RWXdIOdOFOabndtCd9xTFDxZq0=;
        b=baJKyuYAmbuDi454+zu828yg1flWvjVHUzrfZe3PTbLE50zHk2yBr2Dnyuk0cCA0fn
         sHWHtFxj2lfjMMYB+DzK6+EZL2h4D1nMP8nBP2duK/ToE0Q8Gbs9QHNEC7adGEeFbEC2
         Xby24mP5PO2Y0FZc6sJMdCN4IQZv/4EdYxgp4HK8Ipc19V1Un1VTdgyd4CEHYGZRzVFA
         t3NI6J60spiYkEYIjNIX0z+2LakYivHmKEtJ08lASO7gR+21XGRCMMiTsDuwrO14j7wt
         7mPo5UfZGvzzi9BgPz2R4XaZmI24EB1XsgHHoBY9Dc+VvCfFeBmIoY1UyRj3AqFwSFGj
         VsOg==
X-Gm-Message-State: AOJu0Yzyg1r64MFyHdLiB4iwV7islI2+7BhFPE+hwpAX2nix+uZkBWUC
	Avee2fwmUbFBw5obT8oQ1tnmgGDcn7+bSEsZdXAeqmbapWmMW05dUOOSDxKy7/yKZmsdVBvyOza
	ZzEpLyg==
X-Received: from plge4.prod.google.com ([2002:a17:902:cf44:b0:2ae:3af2:e21])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c68:b0:2ae:4cb8:484a
 with SMTP id d9443c01a7336-2ae80156882mr5060795ad.17.1772733031675; Thu, 05
 Mar 2026 09:50:31 -0800 (PST)
Date: Thu, 5 Mar 2026 09:50:30 -0800
In-Reply-To: <20260226135309.29493-2-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260226135309.29493-1-itazur@amazon.com> <20260226135309.29493-2-itazur@amazon.com>
Message-ID: <aanCZqjXd0YiSmjR@google.com>
Subject: Re: [RFC PATCH v2 1/7] KVM: x86: Avoid silent kvm-clock activation failures
From: Sean Christopherson <seanjc@google.com>
To: Takahiro Itazuri <itazur@amazon.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Patrick Roy <patrick.roy@campus.lmu.de>, 
	Takahiro Itazuri <zulinx86@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 5BB8F2169FF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,redhat.com,google.com,kernel.org,infradead.org,amazon.com,campus.lmu.de,gmail.com];
	TAGGED_FROM(0.00)[bounces-72926-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026, Takahiro Itazuri wrote:
> kvm_write_system_time() previously ignored the return value of
> kvm_gpc_activate().  As a result, kvm-clock activation could fail
> silently, making debugging harder.
> 
> Propagate the return value so that the MSR write fail properly instead
> of continuing silently.

Hrm.  For better or worse, KVM's ABI when it comes to PV stuff is to silently
ignore failures.  I 100% agree it makes debugging painful, but it's unfortunately
also "safer" in many cases, e.g. often results in degraded behavior versus flat
out crashing the guest.

The other wrinkle is that success isn't actually guaranteed, because the actual
writes don't happen until KVM_RUN via kvm_guest_time_update(), i.e. only failing
in _some_ cases creates a weird ABI.

And most importantly, this would be a breaking change in guest- and user-visible
behavior.  So while I agree silently failing is ugly, all things considered I
think it's the least awful choice here :-/

> Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
> ---
>  arch/x86/kvm/x86.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a447663d5eff..a729b8419b61 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2438,7 +2438,7 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_o
>  	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
>  }
>  
> -static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
> +static int kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
>  				  bool old_msr, bool host_initiated)
>  {
>  	struct kvm_arch *ka = &vcpu->kvm->arch;
> @@ -2455,12 +2455,12 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
>  
>  	/* we verify if the enable bit is set... */
>  	if (system_time & 1)
> -		kvm_gpc_activate(&vcpu->arch.pv_time, system_time & ~1ULL,
> -				 sizeof(struct pvclock_vcpu_time_info));
> -	else
> -		kvm_gpc_deactivate(&vcpu->arch.pv_time);
> +		return kvm_gpc_activate(&vcpu->arch.pv_time,
> +					system_time & ~1ULL,
> +					sizeof(struct pvclock_vcpu_time_info));
>  
> -	return;
> +	kvm_gpc_deactivate(&vcpu->arch.pv_time);
> +	return 0;
>  }
>  
>  static uint32_t div_frac(uint32_t dividend, uint32_t divisor)
> @@ -4156,13 +4156,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
>  			return 1;
>  
> -		kvm_write_system_time(vcpu, data, false, msr_info->host_initiated);
> +		if (kvm_write_system_time(vcpu, data, false, msr_info->host_initiated))
> +			return 1;
>  		break;
>  	case MSR_KVM_SYSTEM_TIME:
>  		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
>  			return 1;
>  
> -		kvm_write_system_time(vcpu, data, true,  msr_info->host_initiated);
> +		if (kvm_write_system_time(vcpu, data, true,  msr_info->host_initiated))
> +			return 1;
>  		break;
>  	case MSR_KVM_ASYNC_PF_EN:
>  		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
> -- 
> 2.50.1
> 

