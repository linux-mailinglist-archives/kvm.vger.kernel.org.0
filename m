Return-Path: <kvm+bounces-69603-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNVlL5LEe2mDIQIAu9opvQ
	(envelope-from <kvm+bounces-69603-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:35:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFC0B442A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:35:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7E90302E903
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EBF93587C8;
	Thu, 29 Jan 2026 20:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZLiN8dIL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A401309DDD
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 20:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769718915; cv=none; b=sk5mVO5iYpTmcSHCcwAwsdVpQvqHtZ8imCsqahH+5EpTU0zhsbqrdznQIw/baDKPaBPwdtg9eEorzcLcopbiSQQ3kGG/gv7gowNO/9Bdf/a7wXCe0XtyaWBO1lQsl+XRA5yojwoXIex2CiNr4Ry6jIpwSMaWWu6Ny3990D5l/tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769718915; c=relaxed/simple;
	bh=MyNIcHQ3AtOtHcDNc7t7dV+X3P1pPKihf3RCfVQvvwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lq4oCadMNtJbgUdG78YkR/mv7h3OenXsm2WuftrFBgKS0zcHIavaUS4ObGNTLQYh4QonVKCWS6jPLM2Dsu+NW7JEfYYuZOehzkhmmzK6jh2T634Rn6iEP5zOk8tsZF2qWmmMPbNFHia7jq0gGbeb1bQZ/AllJXLewf9x8LERvo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZLiN8dIL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab8693a2cso2801494a91.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 12:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769718914; x=1770323714; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nRr0fknTEEftcLLsSBELlvbzRGlEtPa009sOBZT15IA=;
        b=ZLiN8dILaqotTFpIUbvSkzYgVoLyZmdQE6e+5qAXZWcjRBxCX7v+pDCogwank5TPU8
         6YXiPpPMNx0fC7b3xqBH6IPXdrUJgeIS7w6sS3dhthXXB3SQg/EElwZWU6P27svyQg7J
         TRE0XFI6xeU3gPwT4GHAD0gCzovTcUgEoKGz8Grg9IRINNu+OdSSOkPznOr1KuKQps0a
         XNNqQIdan87hnDwgCZmfontDQBII6nAHDUYEkJZoXS+LWFi5x23IKgQ+g5J+uCHmha66
         ts/lJcH1rRMZzTvUMNYpzNH601KwAzlOMGe6quxBnUWe9jbTUI0G8jIIZSUazIVltVrI
         dipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769718914; x=1770323714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRr0fknTEEftcLLsSBELlvbzRGlEtPa009sOBZT15IA=;
        b=JwBw/w/eJ2y+wZQGKNrg6SjIw6kjPmU2wIt/OIJ5iTMPn0CJ+s+AsDv7Uo33/FQ/Ix
         F8NjL85pSH2H1h9WCGiAA4z1wWJcsrVzKdppEb+JGCOGfWqRMn+8zD68rzjAz0pln8fR
         GUBpijjNF900Lsbnqcrcx+ca8kJAt+hXnvUzA+PGL3k8gnj/b7iK6kqyU+2/g/uO3qe8
         riEORLfJY1NlwgyUSgdwN7j0lRsC9kD9FrJn2q+7HxtTp0r7aidzHKJ18Yf1BEbqWxZu
         eFfTKA+/+FvbKnIMWXcQFE6nkQ90YmkGSKTN6STgdVxaDKHc9MWGjo/rt1eJb+BDUzbo
         P2hg==
X-Forwarded-Encrypted: i=1; AJvYcCV/qCL5bdzvT+VBRADq2UFSx8x8mYQit9Ou+dM9+JBzB7dY6nGuZ0sxmGJnHDTLfkVqfSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLcUnBAZI1yI4mZFBz26ojB0xtI4XL6w3+Jko9TCVi1dvq1eQv
	aD3LYGBq9DMqJ7lweUapuUpMz9Dw5Kmaf8FkUKTrz77W8VeQWfFFss2536uLfk+O5tGqq+ZuSm+
	vhHSxoA==
X-Received: from pjbov11.prod.google.com ([2002:a17:90b:258b:b0:350:fe17:1110])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3bc6:b0:34c:99d6:175d
 with SMTP id 98e67ed59e1d1-3543b2e0022mr605496a91.2.1769718913806; Thu, 29
 Jan 2026 12:35:13 -0800 (PST)
Date: Thu, 29 Jan 2026 12:35:12 -0800
In-Reply-To: <cd7c140a-247b-44a7-80cc-80fd177d22bb@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-12-seanjc@google.com>
 <cd7c140a-247b-44a7-80cc-80fd177d22bb@intel.com>
Message-ID: <aXvEgD69vDTPj4z5@google.com>
Subject: Re: [RFC PATCH v5 11/45] x86/tdx: Add helpers to check return status codes
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	TAGGED_FROM(0.00)[bounces-69603-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
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
X-Rspamd-Queue-Id: 6DFC0B442A
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Dave Hansen wrote:
> On 1/28/26 17:14, Sean Christopherson wrote:
> ...
> >  	err = tdh_mng_vpflushdone(&kvm_tdx->td);
> > -	if (err == TDX_FLUSHVP_NOT_DONE)
> > +	if (IS_TDX_FLUSHVP_NOT_DONE(err))
> >  		goto out;
> >  	if (TDX_BUG_ON(err, TDH_MNG_VPFLUSHDONE, kvm)) {
> 
> I really despise the non-csopeable, non-ctaggable, non-greppable names
> like this. Sometimes it's unavoidable. Is it really unavoidable here?
>
> Something like this is succinct enough and doesn't have any magic ##
> macro definitions:
> 
> 	TDX_ERR_EQ(err, TDX_FLUSHVP_NOT_DONE)

FWIW, I have zero preference on this.  I included the patch purely because it was
already there.

> But, honestly, if I were trying to push a 45-patch series, I probably
> wouldn't tangle this up as part of it. It's not _that_ desperately in
> need of munging it a quarter of the way into this series.

For sure.  The 45 patches are definitely not intended to land as one.  I posted
the mega-series to propose an end-to-end design for DPAMT + S-EPT hugepage support.
I don't have the bandwidth or brainpower to hash out a KVM design in two different
series.

