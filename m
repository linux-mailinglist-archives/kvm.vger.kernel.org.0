Return-Path: <kvm+bounces-67982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FBB2D1B8B4
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 23:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 384183019674
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 22:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3769C35580A;
	Tue, 13 Jan 2026 22:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jPqWjmn6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3220830FC03
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 22:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768342016; cv=none; b=d3htrKBjrpaiS15VHCHuJQ/CehpkjhYigmG7EoyNwXdk+8ECNb+Ja1BWGY3s1qjXqwH1Y51UcmqMatBVoGmTCbEHsRPIYV4kowWv+KQp0jTgPBIKcwALyNmVdn7RZS1XwAn39++3auSpkB5vE+pC80+14OP8PS/htPrp/8sE2G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768342016; c=relaxed/simple;
	bh=iW37PkhVimeAsRI9+U1iwDmo+G0sNY16lfYsThWb4ME=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KSjfjhLsB5hvzoLM+gmWdYP9zxMsdqdsUPNIk5dLnC0zPNi67ufSdoyWYpvyDLhg7G8njLbIl31q3ppoI2LBJiNEABRCejmlzTQRq7ZgHI9Govt+Dc5yEowlf9fei9A8ShP7fM+bv4Sgzq0ce3lVYNU4IB/2mJSmIKt5JDbWXCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jPqWjmn6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c5859a38213so1812754a12.3
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 14:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768342014; x=1768946814; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H47TubffnoB3LJi9WbWx6JWYlmT0g/2zrK7ql8Qwt/s=;
        b=jPqWjmn6vDFiJzWjPVKGUIEfRWL4pdVITKO4+2Qrho4nJQtoE+SUue4YfIK55WQCNK
         NDxNnXrkd8QjEgv3eaN9X9HlluoMGWHXKTmVRzt9ObJIRqgu2a/j3ss+JpgABLS/XDqg
         yUyG05WTDdIMWPxYFVl+XXM5w4Ew4S4DUZGqUKdgwFkgbktb2UNnf5oVtUbUoVbBoe7L
         4ohZ7vWX206dggfndM11BKeQ1gjRuGvUsa1nM2obi6ciEy7E3os/LLZQ/o5gx3RY6EeT
         pAT96Y0shL2OGzNf3eRHLSefUs7vOqHBjIgnFPGRoPsVOH9UGmtOgoqJF7wwqVVWn0HY
         fCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768342014; x=1768946814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H47TubffnoB3LJi9WbWx6JWYlmT0g/2zrK7ql8Qwt/s=;
        b=Z8EFmW+lZOgU6zO+u0Bw31l+IzPyZz9I8MKuFXwp9FxKWu1/BCOK8EvJK0H2n65GhV
         ca6u0xh55BNGau7Qge7Vpmh/vOjsZe/RKwVpR02skyZtgw2hDzQbzFnp2osH5VlIWpME
         lW6gDBj2uH0UUO53DjYqzkUrm4fIHzjwZdyzBcmcwQ2cGjvxDv8d1JTd4mRJ/z5KxPKk
         EthkhMtB5y4ccicKs8CwMTD5c+uArhnj9s/5ICjpgJZbS0jRKYW/zJm6wFirCCLiFIFy
         egqpc2Yf6cHplJCnzn+OYOsRbocv+wwHaeq01xXkZmCo9l8NxIq+uOC9MiPgMNNjrAQ4
         +oiA==
X-Gm-Message-State: AOJu0YyWKpEq5FJSYWpe7mJSfpkf405bwYv8NG3miaUURoU/+J/YQDHp
	Q00QXHpo4Y23YHVWG9r5S6SvIOjAdOSGIEi5W8HwCQtdQYrmNoj2ULmSH2K9rqm0dMAzj3Hs3FT
	feEWWgQ==
X-Received: from pllj12.prod.google.com ([2002:a17:902:758c:b0:29f:22e:147c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1c2:b0:2a0:b461:c883
 with SMTP id d9443c01a7336-2a599e2ed67mr4408825ad.45.1768342014462; Tue, 13
 Jan 2026 14:06:54 -0800 (PST)
Date: Tue, 13 Jan 2026 14:06:52 -0800
In-Reply-To: <20260113213556.rwihf3v3ek3c5kwl@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-7-michael.roth@amd.com> <aWabORpkzEJygYNQ@google.com> <20260113213556.rwihf3v3ek3c5kwl@amd.com>
Message-ID: <aWbB_Dd94rngPfgm@google.com>
Subject: Re: [PATCH v3 6/6] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 13, 2026, Michael Roth wrote:
> On Tue, Jan 13, 2026 at 11:21:29AM -0800, Sean Christopherson wrote:
> > On Thu, Jan 08, 2026, Michael Roth wrote:
> > > @@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  	if (!file)
> > >  		return -EFAULT;
> > >  
> > > -	filemap_invalidate_lock(file->f_mapping);
> > > -
> > >  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > >  	for (i = 0; i < npages; i++) {
> > > -		struct folio *folio;
> > > -		gfn_t gfn = start_gfn + i;
> > > -		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > -		kvm_pfn_t pfn;
> > > +		struct page *src_page = NULL;
> > > +		void __user *p;
> > >  
> > >  		if (signal_pending(current)) {
> > >  			ret = -EINTR;
> > >  			break;
> > >  		}
> > >  
> > > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
> > > -		if (IS_ERR(folio)) {
> > > -			ret = PTR_ERR(folio);
> > > -			break;
> > > -		}
> > > +		p = src ? src + i * PAGE_SIZE : NULL;
> > >  
> > > -		folio_unlock(folio);
> > > +		if (p) {
> > 
> > Computing 'p' when src==NULL is unnecessary and makes it hard to see that gup()
> > is done if and only if src!=NULL.
> > 
> > Anyone object to this fixup?
> 
> No objections here, and it does seem a bit more readable. Will include
> this if a new version is needed.

No need, I'll fixup when applying (already have, actually).  If you want to double
check that I didn't fat finger anything, the patches are in kvm-x86/gmem.

Thanks!

