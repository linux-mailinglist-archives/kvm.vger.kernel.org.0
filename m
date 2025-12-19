Return-Path: <kvm+bounces-66406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35E60CD161A
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 19:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C77D3049D12
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBFE32AAD5;
	Fri, 19 Dec 2025 18:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t3pqwoNJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5C01DE887
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 18:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766169332; cv=none; b=CTMGx4NvQ1I/r6gPca4SREtOoNNsN/9pFmJvhzJYB6VP0UfsJV0wBu0KPXkSm/TB8iQhVUBrk/OXWSadhYfpV0VztDlWFdsku2SUyX+JVngNu4wGs2hm2Vw0LE7tFkkCQJMeVjMKEQGlAFsthYfdNo1089AHHELKHjhvEUtcD3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766169332; c=relaxed/simple;
	bh=iG8mGeVNEvXsd1t76CZqu0+1NQVejONyUMDBb2xBiKA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qlrVGYT2udaQhTIOUS7lzw5PV93osantaUWokDal2lN8QotuBR6ajLs7foNV1BPl2Xjl1uFaaQTV4ZOZvMYcgJtYXVzE6FqKxGXnFkieF1vMth1/IEDFFdvqBvFFFbgHdkV/mAVGXU92RJK8AO5rlooO+LtTWWddBdK3825R8Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t3pqwoNJ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0e9e0fd49so31326545ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 10:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766169330; x=1766774130; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E7j42xcc07Siwvvg0leIJ0Z0gl7G5h1m94yUilkbF8k=;
        b=t3pqwoNJ9gPbcXGv3NJX1oNHNs3wS0imoVh/4ERQiY9Xq/zPqYKfwouRSwDtUlatsL
         psfUlWn96Y95xlr27bUoNSSM6X4lh8afFhPBuNNYCdSyYF1NtdfoEVqKOMYqXSi2kGE3
         C97xzKwCzmqBm4lY+tgz9o+cPPWlFHVVEk0Ev8fT0AXNEaHQjdTPpB0pUIXaKv2YgyfI
         OpV+YVB5gvP/uxDIl6JzBMFSIZYFJE52123fphO71KE07DFn7hKDVUewU6cXUZQ1OxqE
         a179bl+pN5gYa12YcoxiSo9BfiDFyFZRJiaSytL9nw4j0DBqh5+mgryEqaADFMdimEHT
         7I+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766169330; x=1766774130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E7j42xcc07Siwvvg0leIJ0Z0gl7G5h1m94yUilkbF8k=;
        b=qtEDnrWWhvLS0e8z6h4EECk+DKmjFmuO0joRmQ3eQQT2bZ4kvQ3fsL1lNOkuFVxLg3
         tydZiEss29SaFZTqsRbiVZhGkBmJWo9O3l7EzFsSVRuLcYd0fmyZka+4TVawdE/Xp7Ub
         KFZaCF3uCyqVj8bx4ChY1XJE72FCcnWZZ14zyj79UTqRWB14fI6VzzGMRC2x4FGBEzbJ
         UYRSDdpU1VMWWzvdyOEB5duKL+4sCvUxz49kVYIOF33JmB3evJ1OFKYR5qlfP6RlIQ4B
         8U5etB/pjFfQ5mmK4uzAcKTQl99SKN7pTlGG+8VyhwOSDt5+/72OInXmK5FyBIVKYkbE
         O1aw==
X-Forwarded-Encrypted: i=1; AJvYcCXEBovPLeHwX327eUs28/3PfgUCJnc03+yhu0lptOc4CmPwgj2QB6FKGQN4rkNW8EW08l0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCSWsIyOATc8gibvstC6B0Q/jdKv9zNGtn/AmCoaa+get/9wwK
	O1Tsb42zDg85p6s1kbf5iY3FAzyGq5TOZGKuGIhD/m0jmlU9nXhj+dZR3FQ94kL/oLD2tPpFEvi
	YByKGCQ==
X-Google-Smtp-Source: AGHT+IGvd+XfHbhthTzkZFT+g/Baf1kbE8bktfWBbuaDWMKWgA1wLhpc2ZL5cUoEo9s4pLMCpJWmqB/MBhg=
X-Received: from pjqv1.prod.google.com ([2002:a17:90a:af01:b0:349:8a6d:dfd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d50:b0:343:43bf:bcd7
 with SMTP id 98e67ed59e1d1-34e90de0291mr3447619a91.13.1766169330430; Fri, 19
 Dec 2025 10:35:30 -0800 (PST)
Date: Fri, 19 Dec 2025 10:35:28 -0800
In-Reply-To: <90837ad5-c9a6-42da-a5a8-fcd2d870dac8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com> <20251206011054.494190-3-seanjc@google.com>
 <90837ad5-c9a6-42da-a5a8-fcd2d870dac8@intel.com>
Message-ID: <aUWa8LOEJ6JeczJz@google.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 19, 2025, Dave Hansen wrote:
> On 12/5/25 17:10, Sean Christopherson wrote:
> > +static int x86_vmx_get_cpu(void)
> > +{
> > +	int r;
> > +
> > +	if (cr4_read_shadow() & X86_CR4_VMXE)
> > +		return -EBUSY;
> > +
> > +	intel_pt_handle_vmx(1);
> > +
> > +	r = x86_virt_cpu_vmxon();
> > +	if (r) {
> > +		intel_pt_handle_vmx(0);
> > +		return r;
> > +	}
> > +
> > +	return 0;
> > +}
> ...> +#define x86_virt_call(fn)				\
> > +({							\
> > +	int __r;					\
> > +							\
> > +	if (IS_ENABLED(CONFIG_KVM_INTEL) &&		\
> > +	    cpu_feature_enabled(X86_FEATURE_VMX))	\
> > +		__r = x86_vmx_##fn();			\
> > +	else if (IS_ENABLED(CONFIG_KVM_AMD) &&		\
> > +		 cpu_feature_enabled(X86_FEATURE_SVM))	\
> > +		__r = x86_svm_##fn();			\
> > +	else						\
> > +		__r = -EOPNOTSUPP;			\
> > +							\
> > +	__r;						\
> > +})
> 
> I'm not a super big fan of this. I know you KVM folks love your macros
> and wrapping function calls in them because you hate grep. ;)

Heh, kvm_x86_call() exists _because_ I like grep and search functionality.  The
number of times I couldn't find something because I was searching for full words
and forgot about the kvm_x86_ prefix...

> I don't like a foo_get_cpu() call having such fundamentally different
> semantics than good old get_cpu() itself. *Especially* when the calls
> look like:
> 
> 	r = x86_virt_call(get_cpu);
> 
> and get_cpu() itself it not invovled one bit. This 100% looks like it's
> some kind of virt-specific call for get_cpu().
> 
> I think it's probably OK to make this get_hw_ref() or inc_hw_ref() or
> something to get it away from getting confused with get_cpu().

Oof, yeah, didn't think about a collision with {get,put}_cpu().  How about 
x86_virt_{get,put}_ref()?  I like how the callers read, e.g. "get a reference to
VMX or SVM":

  x86_virt_get_ref(X86_FEATURE_VMX);
  x86_virt_put_ref(X86_FEATURE_VMX);

  x86_virt_get_ref(X86_FEATURE_SVM);
  x86_virt_put_ref(X86_FEATURE_SVM);

> IMNHO, the macro magic is overkill. A couple of global function pointers
> would probably be fine because none of this code is even remotely
> performance sensitive. A couple static_call()s would be fine too because
> those at least make it blatantly obvious that the thing being called is
> variable. A good ol' ops structure would also make things obvious, but
> are probably also overkill-adjecent for this.

Agreed.  I'm not even entirely sure why I took this approach.  I suspect I carried
over the basic concept from code that wanted to run before wiring up function
pointers, and never revisited the implementation once the dust settled.

I haven't tested yet, but I've got this:

  struct x86_virt_ops {
	int feature;
	int (*enable_virtualization_cpu)(void);
	int (*disable_virtualization_cpu)(void);
	void (*emergency_disable_virtualization_cpu)(void);
  };
  static struct x86_virt_ops virt_ops __ro_after_init;

and then usage like:

  int x86_virt_get_ref(int feat)
  {
	int r;

	if (!virt_ops.feature || virt_ops.feature != feat)
		return -EOPNOTSUPP;

	if (this_cpu_inc_return(virtualization_nr_users) > 1)
		return 0;

	r = virt_ops.enable_virtualization_cpu();
	if (r)
		WARN_ON_ONCE(this_cpu_dec_return(virtualization_nr_users));

	return r;
  }
  EXPORT_SYMBOL_GPL(x86_virt_get_ref);

  void x86_virt_put_ref(int feat)
  {
	if (WARN_ON_ONCE(!this_cpu_read(virtualization_nr_users)) ||
	    this_cpu_dec_return(virtualization_nr_users))
		return;

	BUG_ON(virt_ops.disable_virtualization_cpu() && !virt_rebooting);
  }
  EXPORT_SYMBOL_GPL(x86_virt_put_ref);

> P.S. In a perfect world, the renames would also be in their own patches,
> but I think I can live with it as-is.

Ya, I'll chunk the patch up.

