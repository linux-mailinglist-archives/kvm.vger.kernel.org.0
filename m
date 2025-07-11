Return-Path: <kvm+bounces-52213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E700B02745
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 00:57:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 730D21C87FC9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FCD2222BF;
	Fri, 11 Jul 2025 22:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L15sDWPH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3A21A3145
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 22:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752274618; cv=none; b=ZLP1oFWlqSleyUOemlNq3DIHlCj8C9ig9c8mJFUbfbKKrK+I66Z4qtUSujNIoQV8ttSldZ/cTFQ/hog8R7S5TMpivRfEIhqwygK+81RZnZgfMQoocNevOuALrTfUTacGEzTMZAMiyLKk5QfawdY+ntCT/cEMBPe8Wee1A+BXkKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752274618; c=relaxed/simple;
	bh=h9zHF6VE+0eqNEZ8zxM9gDNEFFnpkyeCMx79te09jd0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BOOuGjf4k7t0zVZ4Sqe/0OgyuNDoiTV7zLccM1E/eF1OvMs55sbWVOdvcuay4b7IjeP2YSsoSRDg41OULp7LXrVNnGJAGXrJu6A1omtClhVoZMZ+LZY1CSD7aBmL3PjrYR3UYTLO/sXNj8LhCuvZ6pWRmWWrZTePJiNY1XgtY/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L15sDWPH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313fab41f4bso3518735a91.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 15:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752274616; x=1752879416; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TBnhHyNjVozUiSHGI/NT5N6cTiyZUXOYCL1PDt1SEWI=;
        b=L15sDWPH37GmjMczCLs9LtgIY4w5wMG9QfFGhyZujdk+1HTAJiCRbHNLpeL94WfLgB
         LL13uIcagDuywrDmoCMNyaxR1GzLMetKx277aORXML235/OqinTKR39Va0NMzQyKhhNt
         Xf+xnawjMac2C+qJ5b03VgpadeNEaJXIR09lu/OKtdAuPVer9D3AxFzoc3+gPHitWP0q
         ApadhOm3qpxt+g8ZeNB+UB/Tean7JKSYHanxbxPxqpmZbpgMCUYu1FumeGa+LLmghdcL
         xdMwIQDFNB/TLcLK0NUrurovSMKccoN01EhTfdVnElLCA5/jwvr2j0H7GCEzECX4BAAR
         USyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752274616; x=1752879416;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBnhHyNjVozUiSHGI/NT5N6cTiyZUXOYCL1PDt1SEWI=;
        b=dbhQYk9+hQNd8DbdjWhFufdbfMfo9yUAtdo9jcZavo+7f1/joOigWFr82LrEYqttpL
         KbMZFH8X2r2k7Ha7YzDgz8fF6vEZz8ofKdr3ctXzvKZ9QmYsvaIjtk5el41FFsYlHTX9
         417P235GPcNJAeylKVYWXWzfEDlgkLyWtJTKhaM+oh+cpdMrtVf0URRa/H1dYvFXMF62
         XoeUIAmFvwtmtGEcFzpjPw0Br7/bBdMwCN4vO3oUSiNRLaS2ajGV64Lkyo6M88JlNjZZ
         hUgM03uQz3f7C/r5rkiHRPfluHjyoBLQtOzDtR3Zat1CcquV1NuUe6lmZexDaqxev7m0
         5a4A==
X-Forwarded-Encrypted: i=1; AJvYcCWoH4guES80qpX3E1yQjj5o1AehAG0NvNjj3wx4V30wMTypMxiIkHIu+uNEwa+1WqE+E7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgrU8YPQGLZic6A06lasLH9HRheS6LCfe1330T+pEjXPhSVvaR
	R56Cz7/wynRj2OCtLyBuwpiGmXR9i3JKb8r2jJ3sXU6dPlk71jy8kCy7L50+6cwa9iLrIaSmVaX
	44/5abg==
X-Google-Smtp-Source: AGHT+IFTwpjOGEpY7in+6Q9QAChwD2WYoDhkfpFI7Y0NI55xdEHGPdGSm/P946VFNcW64oQiC8Ewdl+dk4w=
X-Received: from pjbge18.prod.google.com ([2002:a17:90b:e12:b0:312:f88d:25f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b49:b0:312:db8:dbdc
 with SMTP id 98e67ed59e1d1-31c4ccea7a7mr6240843a91.20.1752274616462; Fri, 11
 Jul 2025 15:56:56 -0700 (PDT)
Date: Fri, 11 Jul 2025 15:56:54 -0700
In-Reply-To: <68717342cfafc_37c14b294a6@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com>
 <20250711163440.kwjebnzd7zeb4bxt@amd.com> <68717342cfafc_37c14b294a6@iweiny-mobl.notmuch>
Message-ID: <aHGWtsqr8c403nIj@google.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, binbin.wu@linux.intel.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, vannapurve@google.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 11, 2025, Ira Weiny wrote:
> Michael Roth wrote:
> > For in-place conversion: the idea is that userspace will convert
> > private->shared to update in-place, then immediately convert back
> > shared->private;
> 
> Why convert from private to shared and back to private?  Userspace which
> knows about mmap and supports it should create shared pages, mmap, write
> data, then convert to private.

Dunno if there's a strong usecase for converting to shared *and* populating the
data, but I also don't know that it's worth going out of our way to prevent such
behavior, at least not without a strong reason to do so.  E.g. if it allowed for
a cleaner implementation or better semantics, then by all means.  But I don't
think that's true here?  Though I haven't thought hard about this, so don't
quote me on that. :-)

> Old userspace will create private and pass in a source pointer for the
> initial data as it does today.
> 
> Internally, the post_populate() callback only needs to know if the data is
> in place or coming from somewhere else (ie src != NULL).

I think there will be a third option: data needs to be zeroed, i.e. the !src &&
!PRESERVED case.

