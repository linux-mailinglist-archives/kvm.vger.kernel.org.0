Return-Path: <kvm+bounces-57597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC90B58277
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 424541A205FF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CF02882D4;
	Mon, 15 Sep 2025 16:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BH2fRaPt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E6D23B618
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757954812; cv=none; b=qPbADTaiLbfpLf8tBv8BISWl4blq6dPBS/BPzO2VOSQYzTHbiecyyJYMS0ZJc6HEefd0ETcBSsbIIi/Y+Rr5Oo0EXVOwjC0wAoXvl4E/rUqMzGEIBylklCDciFLOMmMOnSFs/QNpl2wdYdI5EmpIwSHdlUYW2rSBQkimfnP2iaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757954812; c=relaxed/simple;
	bh=CXzPlvutPWKdlESNZVRVQx98sF9Awv2WxTK5w9NjF8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eInw0tBZgz4gU2ZXHwyE4EipHUEvPTMVUwK5UbyANtnWPlTTzoXuzhhsBE9PguuWwTr/US+L3/Vi1PogY2IkOOKr27/owBqhJfDyahok34tbomgS4MXLzDxBW3npI6zvgFCc5MvYgRp+1ppieCwodZ9nLu6tCptt02Vi0VCJo5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BH2fRaPt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32dd692614aso6551483a91.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757954810; x=1758559610; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h6/ZMWPFkdx/KzUTCHS9r9FitNYaY9pudHoMyjc+mhE=;
        b=BH2fRaPt3Hq/rdc2jX+E+TXgbgH7eOoVu7jDMdiOD7uh/imsKlnatzkvoQFFlTUUgh
         itF+QVx2lR879boFhbUkzMnzr8DvX5HsyMhVtNT9sSxd0XEPA+xblr5H9g5J1cOgGpco
         z8/GQQpnkQTSCauYi1IrEa367BXhj223TQxXIOA45EJYRyu9r7W3sk6aEktJFNZTKKHu
         N7IqiETrFh47f1yUnrxvkflfvbPR4V/k9D+rKl8fVCaNDKrUf3gUy1afn/Mpb7x4pLbT
         JmXM2RSqyBvOjQ+VykZ1tH9uWcOw62+i2Ljy6M92ODaK35Rn8zDTW4dxSRML9VKo8Cnp
         1IyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954810; x=1758559610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h6/ZMWPFkdx/KzUTCHS9r9FitNYaY9pudHoMyjc+mhE=;
        b=wY6NAIYeoLrRfFBDF5zOMFwdmZb8PNDby2opu+OVK+LElTRfoS4hLqK5BOLfqteNs+
         KLMf76WDxnIxgl/84u1FG/9cRq7CINyXOjmjAYjPxjPE1tGhqfol0keQfGvgFfa3nKYq
         gYMuP0WwtLFJ2D4URq9LpHWT3njk4Eyt1/KHt7sg9ajHD4tqH5qj1ZN97MNkFfkYrjc2
         Uh0IubXZdtAaSuTbwpQPLEWFkuTa7uoh6EkA/RRkWCPy7iFA8UToAcVDiQdDTIZgWZzy
         dxkMaGKZfcAS8dTAFPMSZerR67RAoRVMdbDZTpOiuHzfPMLKEc+iq8/c45ivI8oEt8gQ
         AR3w==
X-Gm-Message-State: AOJu0YxOOyEEW5zGaoGT1I8wUa5pUFibKB4bnkMGyfAnWBEXKo2bFtPB
	1ztv8hAX2pjBSiXCx+SOUTPQJB+Ci4y80QGgMf/YeRPk51JlbkVFY0Hvrf6uLMdVjZjc9pj6pQF
	HC83GOg==
X-Google-Smtp-Source: AGHT+IFA9rXmjCzkTEmAvIT/PTTJwVPmxCScwhbyC7Fth5S4LVT3spvgUbpO5p9/DN7nyS/dgvZep2zQesM=
X-Received: from pjbso12.prod.google.com ([2002:a17:90b:1f8c:b0:32b:5548:d659])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48d2:b0:32e:6fae:ba53
 with SMTP id 98e67ed59e1d1-32e6faebc19mr3488056a91.8.1757954809999; Mon, 15
 Sep 2025 09:46:49 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:46:48 -0700
In-Reply-To: <aMgoGLL65vUPGYW0@AUSJOHALLEN.amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250908201750.98824-1-john.allen@amd.com> <aMSkp7e7IryG2ZAj@google.com>
 <aMgoGLL65vUPGYW0@AUSJOHALLEN.amd.com>
Message-ID: <aMhC-EkMW0XSxxk6@google.com>
Subject: Re: [PATCH v4 0/5] Enable Shadow Stack Virtualization for SVM
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com, dave.hansen@intel.com, rick.p.edgecombe@intel.com, 
	mlevitsk@redhat.com, weijiang.yang@intel.com, chao.gao@intel.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, John Allen wrote:
> On Fri, Sep 12, 2025 at 03:54:31PM -0700, Sean Christopherson wrote:
> > On Mon, Sep 08, 2025, John Allen wrote:
> > > This series adds support for shadow stack in SVM guests
> >                   ^
> >                   |
> >                 some
> > 
> > I mean, who cares about nested, right?
> > 
> > Sorry for being snippy, but I am more than a bit peeved that we're effectively
> > on revision 6 of this series, and apparently no one has thought to do even basic
> > tested of nested SVM.
> 
> Hi Sean,
> 
> I have been testing nested with this feature (or so I thought).

The issue here is that Linux only supports shadow stacks at CPL3, i.e. only
exercises MSR_IA32_U_CET, and for whatever reason the KVM-Unit-Test only tests
MSR_IA32_U_CET too (and is stupidly not compatible with AMD due to requiring
SHSTK *and* IBT).  So just running those in nested won't provide any coverage
for S_CET.

> Can you explain what you did to test and what wasn't working?

Read/write MSR_IA32_S_CET to a non-zero value from L2 by running the proposed
selftest[*] in L1.  Because KVM doesn't propagate S_CET to/from vmcb12, the
writes from L2 are effectively lost.

An ever better way to cover this would be a selftest or KUT test to explicitly
read/write MSRs in L2, and/or fill vmcs12/vmcb12 from L1 and verify L2 sees the
desired value.

https://lore.kernel.org/all/20250912232319.429659-37-seanjc@google.com

> Apologies, and thanks for taking the time to look into the problem.

No worries, I didn't intend to single you out, I was essentially just yelling at
everyone involved :-)

