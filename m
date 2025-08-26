Return-Path: <kvm+bounces-55775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B26CFB37100
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 19:10:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 032918E4760
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 17:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0F12E2DF1;
	Tue, 26 Aug 2025 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0CrZSKZf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5B7234973
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756228225; cv=none; b=jCrN7dI5EkHePzz0zH2wsWVuUf54P+6HxF3foa8PRTGHRdaXXKhTRO4b3o8bLz4GfXopyujyw8XkEJnlbUJwugyg/QtC4EOeoc9inhzz+hc1LT81oTxvcWwfyCWQuYTM0iLYgdqB0jwqJ5xaV3EkITRPmMtlj4X4dXRsC2gJg8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756228225; c=relaxed/simple;
	bh=QUO+kvmsY5YH63Em44lRGDPBilShneN9/HrqfZ7Q1LM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UENVFHevyoXygW7jPcl4kv9F+MTBVN/NANQrn18AlH7Laf6KcgysgwhWDwh5yKmFdMw4oBEIbsXtvq0ta0sVu3wXDBr6C5HyyiCWMUzXE04EIW7/fPfw2vJ6rzb75E9o9GDZHfdERCfiC5esNvb5tyEWtExVKTzdQveHR3Zhti8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0CrZSKZf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-244582bc5e4so72280145ad.2
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 10:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756228224; x=1756833024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EownB3vAsU2c89zF95l+GmdPluihHYmNBg7xdEmdumo=;
        b=0CrZSKZfX5062CRGl/XWqBzOjICRnB+M4dd9PmPfJ5kP4YGjueNcaBqfQXwN8j4wjT
         S7SQ53mjnB2dIWowJdoY7hpVliIUxrA5/zKUgae0lPG0i1t2WTRfRvlY22Wev4tRu0TU
         PQi6v7jKwgBG0BR4elp06OA71ZAQh21uGVdmAirHLFyXYT0W1wbWav5E8bJBQhU+HizI
         Rv5nLtilMoQ7dvupAHqQTVi8VZWjnXISYbKSMKCwe7Plf8Uxw0bfN6XpsD9YEx7zki7B
         wgh2SYrHomeIPJyepEQ5GnJAH5Em5u4kHv6zvuMij9kAHXqjsffwjzNmMSkLEEqK3Z1O
         xZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756228224; x=1756833024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EownB3vAsU2c89zF95l+GmdPluihHYmNBg7xdEmdumo=;
        b=m0fQW25k7/UcOXmdFZoDhtjXHJeC6/S3F1Kdtmqdp8RzE/3rhg91N2/iPJqfzJA0A1
         CvW4Fg54N8/05FPlvo8+mET04tzEuamA2SRYibkkbRdv1ofMnV1LDmph5FodrGmVNDgv
         UlJXIfGlIG169A1Iqfmk41YTtEtq/J3qOPqyrsxLS2dqAt/7TyPNshZycF+iuKFYMXsg
         UiY6tmN+pWcjUtImMkta+STpRi8P24k6v5EE8d/B6V7sWZINVXpOnTpCobeVWeCTHbFF
         ypfV8hytFQCLt8mFxMJdB7YyOYVrODroBNkN9SqYN+kjk7w8IIV+MX+IJSTItvVSiDbc
         9EEg==
X-Forwarded-Encrypted: i=1; AJvYcCWR/DkrxF6fcCleKf7xHbWeqUC0VtPYC2WqMDGnqheeJwHfOW033cHzjaZocswoSwTgruo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXqGiYi8WnxVxiqgNB2RKR45LehekyASbH9+fayCzNgrt1Idg5
	qRGCIV66Qz0vSgsvLF4amPREIc8qph0XmG82QxqtIIFBRT2Gu5ggPnDqQPwPX5qoQcpY4XbBD5I
	fGdyijw==
X-Google-Smtp-Source: AGHT+IHRLlt3zeA2aVRArIy2R/qVnR7QPU7LMcHxv8NGLB1glHB3fzv5nkgHNu6rY2W/ZqoC9EkHt79E7rQ=
X-Received: from plox5.prod.google.com ([2002:a17:902:8ec5:b0:246:9673:3625])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:234e:b0:248:6d1a:42e0
 with SMTP id d9443c01a7336-2486d1a4610mr32584015ad.14.1756228223537; Tue, 26
 Aug 2025 10:10:23 -0700 (PDT)
Date: Tue, 26 Aug 2025 10:10:21 -0700
In-Reply-To: <14f91fcb323fbd80158aadb4b9f240fad9f9487e.1756161460.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756161460.git.kai.huang@intel.com> <14f91fcb323fbd80158aadb4b9f240fad9f9487e.1756161460.git.kai.huang@intel.com>
Message-ID: <aK3qfbvkCOaCxWC_@google.com>
Subject: Re: [PATCH v7 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: dave.hansen@intel.com, bp@alien8.de, tglx@linutronix.de, 
	peterz@infradead.org, mingo@redhat.com, hpa@zytor.com, 
	thomas.lendacky@amd.com, x86@kernel.org, kas@kernel.org, 
	rick.p.edgecombe@intel.com, dwmw@amazon.co.uk, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, kvm@vger.kernel.org, reinette.chatre@intel.com, 
	isaku.yamahata@intel.com, dan.j.williams@intel.com, ashish.kalra@amd.com, 
	nik.borisov@suse.com, chao.gao@intel.com, sagis@google.com, 
	farrah.chen@intel.com, Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 26, 2025, Kai Huang wrote:
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 2abf53ed59c8..f8f74e213f0d 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1872,3 +1872,15 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
>  	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
>  }
>  EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
> +
> +void tdx_cpu_flush_cache_for_kexec(void)
> +{
> +	lockdep_assert_preemption_disabled();
> +
> +	if (!this_cpu_read(cache_state_incoherent))
> +		return;
> +

Can you add a comment here to explain why this is done even if the kernel doesn't
support kexec?  I've no objection to the superfluous flushing, but I've spent far
too much time deciphering old commits where the changelog says one thing and the
code does something else with no explanation.  I don't want to be party to such
crimes :-)

> +	wbinvd();
> +	this_cpu_write(cache_state_incoherent, false);
> +}
> +EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache_for_kexec);
> -- 
> 2.50.1
> 

