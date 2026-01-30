Return-Path: <kvm+bounces-69652-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kK4wMb0JfGn1KAIAu9opvQ
	(envelope-from <kvm+bounces-69652-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:30:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 23969B62A5
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:30:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E49C13010DB7
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 01:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88F332B998;
	Fri, 30 Jan 2026 01:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ihlLXpBK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172BF14A0BC
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 01:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769736622; cv=none; b=AWmg9NjZfNsMSF8y4K/yi5Mi02WjVUwgJICxcmctbWrzEkyVIW0XcUI/lN8/FUCc934FKGaBk1cVo2rSW8yHsjLa7s9D9MAOQ9cfe+vSJ/2gHwvI0y9g6AFAU7UuMMIlRGTPi4KEHzXqrP+WzTAjp2x4KA4zC8JhsebWnqTh+cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769736622; c=relaxed/simple;
	bh=OWbo5+AC/7MNSmt+smFsiU1JrGaXjjA5PVj06qv+38c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=IIECvAIpnThB3VoCiVn9WzTQoPGTcnIJ8a0XVAt1n00iFkM+PfNytMHOy8n78PGd/rXbO39IaJ9cuJN0m5X9htGchGwrD6s49O4yRwSnviL5hsy4bSFpyydPLFEFLMrGWyBEyKPqrSOJKh4FqLETxY06X9G+ho/ftP2MzsW7Vi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ihlLXpBK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352e6fcd72dso2577953a91.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769736620; x=1770341420; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VQBtu95IXBz7ZXJTgTL37RQFlBFs8n039CcrQPqipBA=;
        b=ihlLXpBKidiUdXGYKngS6gVSCMXHjlsEvcErsSGa70DK4v41kn9Va7+hXxaf4wE/CN
         R6ulenxbWl9/NDX2sCCy0gzOeoP/NOc5dInn9+2Y3JUq7yFjVPESL7QfOwGNlLFIEBcE
         n+0xmty/CpmEFAoYbPBACfuji9VcP1R8K9+3en8M9baOqSOy66v7rjEIQaANPpakoMM+
         bZOEO+yIrtuTOF5e1E8byshJUCRHIGCOuFj4xlVfRcsdRPjLdbCrF2GNxWmzmTaruPEj
         4N2ieqkDJhTcFPVZHzWxHHglXYrfUmD2advmxeE0M/jMO9614mapqrXxx+zE2by96Y+N
         /xyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769736620; x=1770341420;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VQBtu95IXBz7ZXJTgTL37RQFlBFs8n039CcrQPqipBA=;
        b=vUNlPSjy1Z+YavG4pWzG+NXx6qtbnH8aOyKjnlspjsBAGSc+F4wsx4XrvWF7RrTN8R
         isj0CS1vReiPw4qQFnEeITtyY2pRZJpTWotVaDznSEykhxYWTCvDytMTIUlPFYCnujzc
         iUpTaTwOC/mVLWMsekkdLdlWuXpl94yVAFdiiQUkTDyi9xauDDAeDFiUmRRSzopyO0gg
         1Hb9jIq/Hc4NyUWBpNT/GRVXJyGRLS45VVdTR2d24aI4PVYIm9UmQ1/0ZAcCO1hS3oh/
         F/P7YNE/N9qtykdkG/XLdNvYuVzwM3pOxq0y2D/thC7bGtdu9feRncoPFppVXt7jOFQc
         DLuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgUqMNzSQM2iBFmcPoXSCy4Osw9ifgCK3Rez5uedEU9WgBf/iciS5CgWryTig/P1WCV/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiCq/5MezgJM6N+txG1EDr7bwIuEuxyifdlWU3zUPq88ZXyFk0
	xzhu+6SZfS+97Wn/E6gwJ9f/jYDCap4/5n4bqAT+HAHYFYczHnpr4j1HBX5PvLPNyjqwixCz1jS
	xJg0evQ==
X-Received: from pjbcu19.prod.google.com ([2002:a17:90a:fa93:b0:352:d166:32ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d4f:b0:341:88c9:6eb2
 with SMTP id 98e67ed59e1d1-3543b2dedf9mr1401283a91.1.1769736620318; Thu, 29
 Jan 2026 17:30:20 -0800 (PST)
Date: Thu, 29 Jan 2026 17:30:18 -0800
In-Reply-To: <20260129011517.3545883-17-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-17-seanjc@google.com>
Message-ID: <aXwJqkVErsY3CBuX@google.com>
Subject: Re: [RFC PATCH v5 16/45] x86/virt/tdx: Add tdx_alloc/free_control_page()
 helpers
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Sagi Shahar <sagis@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69652-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 23969B62A5
X-Rspamd-Action: no action

On Wed, Jan 28, 2026, Sean Christopherson wrote:
> +/*
> + * For SEAMCALLs that pass a bundle of pages, the TDX spec treats the registers
> + * like an array, as they are ordered in the struct.  The effective array size
> + * is (obviously) limited by the number or registers, relative to the starting
> + * register.  Fill the register array at a given starting register, with sanity
> + * checks to avoid overflowing the args structure.
> + */
> +static void dpamt_copy_regs_array(struct tdx_module_args *args, void *reg,
> +				  u64 *pamt_pa_array, bool copy_to_regs)
> +{
> +	int size = tdx_dpamt_entry_pages() * sizeof(*pamt_pa_array);
> +
> +	if (WARN_ON_ONCE(reg + size > (void *)args) + sizeof(*args))

The above closing ')' after args is misplaced, this should be 

	if (WARN_ON_ONCE(reg + size > (void *)args + sizeof(*args)))

I'm still in disbelief that I managed to end up with such a horrid bug that
compiled without any warnings.  *sigh*

