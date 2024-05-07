Return-Path: <kvm+bounces-16878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49DED8BE8B8
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B8141C238F3
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0127616C45B;
	Tue,  7 May 2024 16:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tyFFzb6t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF5C168AE8
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 16:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715098905; cv=none; b=lo8Jz/4xwn9iYXjOtNEQ6SDHWobv7OEDNFnmSerlvkow9ADEqjTk/LXSpE3YcgQRjY9Lc0NaeiXLbBD+LnikDerc7xWyyUiP1RSwYChJsJOjw1aLf3KoELf1rURe68xkKAwcHwp0NrjiEW9GKbCs1lIJL/hCdebTYVWCAYsxKrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715098905; c=relaxed/simple;
	bh=vspPBwfCR3bmmeZQ5EusjF8lVRuYv1ubtXwG70oU+DM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kcGb1EdZdjKLrbq+ObZifhOXUzNJtTsdqkdcgpHdvjjfmRtECMo/AZKygj0E6prVwUdjvXA3R8gGQ185ITtA2HVMW7daPKsiA1elhAjzpCqUg/oPS/WJOfo62d2wksZ0BGeEy4uEMq2HjsZD3I3idqGVahhj0t9TefmNHZNUZ70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tyFFzb6t; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f446a1ec59so3080562b3a.1
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 09:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715098903; x=1715703703; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ShcrSBR6L/ztU6jULZGVC9zQBLJvV7z+Ngxu7KBV4r8=;
        b=tyFFzb6tSzPyCEubYeTRjDHXgbCC8WJtZNv6r3Q7igu6WrhzE1pFODAdlj3NXCIIKq
         3E1r7eeFup6uivouwrF6rRIQaKezdV0+IyZ7NywEOcIYMpwXG/SNCSz5vQ/qhpkvbThN
         0ORD6/19FYcUIlXMLYMa1uFIpRUtdJ99Lo3cy9lztwoKMIzrTeZe+XtqcrLs0FERZTyY
         TmQ1oR6yJtROX3djKew7sLhcgUtj/bViy6u/xpo8/lS/9QsjB/FXDEWzNPf7pXtX2NLP
         4paDhnW660C30MEs/6ykUgBtJ3KxtOJcSw28nfGZqf080SwKDH1QmS1Lq9Z9Fo6Os+uo
         YpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715098903; x=1715703703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ShcrSBR6L/ztU6jULZGVC9zQBLJvV7z+Ngxu7KBV4r8=;
        b=FevD3is2r9Nw9Z/zaTNRq4r3UxoInJJtpatbKbvgLJc+Jj9bH7fsgPc6H5SPgEeGPR
         LmmmoXK1tSeXfzMz9CDwAUCb0/6+QS71/hTrObgE3t6dwaSN18D+3/XGqos2wJSJ/rr4
         BO58d5lW2RDU8OGwvZkqwFYjjjwm8LXH0PPiE4jwvUyZoMn9OXsYP/+drcRix8bAuCot
         A0qQvSCcyq/vogIJRfq8UtsjJhLLrop0kNtwxeKk1HMf5CWnv99+TOx8FClY4rUnj5EU
         dln6VU2KdWeIRkG5Ma4c1oACSxIG9HCzlVMhY1znYIRupuCzBxn2CRiTBz59QuwBlFG+
         zkaA==
X-Forwarded-Encrypted: i=1; AJvYcCWSniKrO4OKBomrkNzJIMJWIjvJ45WPhdvQtZJPkHfQGufd1sJLwVEe9a4h3d87Ps3LwtBuu/cFszCjEiQH9Qv7TFee
X-Gm-Message-State: AOJu0YyOGNmh42U2coHXlvZMnOewGID/2uqSquuYCprQ1PNZC6mIaMJ2
	8Ge7hDhcZ2DshJaI2keNawfwiCAqC+hruXBPDWlXt+Gd97Np6C/6GTqfxdGn4zisEt0OxW7bzDE
	xPg==
X-Google-Smtp-Source: AGHT+IEQAgGUUiNs9ueiQI8ezbZWTyayde6E7x9Utw9Z6xDB+xZmpi54Evri6lqVD4w6PL4czEL0J1Y+26c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b8f:b0:6ea:baf6:57a3 with SMTP id
 d2e1a72fcca58-6f49c464c18mr445b3a.6.1715098903272; Tue, 07 May 2024 09:21:43
 -0700 (PDT)
Date: Tue, 7 May 2024 09:21:41 -0700
In-Reply-To: <ee8c0227816d546a0a02f3db9519d289d3e275b0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
 <ZirNfel6-9RcusQC@google.com> <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
 <Zire2UuF9lR2cmnQ@google.com> <f01c6dc3087161353331538732edc4c5715b49ed.camel@intel.com>
 <ZirnOf10fJh3vWJ-@google.com> <3a3d4ef275e0b98149be3831c15b8233bd32c6ea.camel@intel.com>
 <322e67ab6e965a70a7365da441179a7fa65f2314.camel@intel.com>
 <Zjo5QBVXjO2/wLE6@chao-email> <ee8c0227816d546a0a02f3db9519d289d3e275b0.camel@intel.com>
Message-ID: <ZjpVFa0vUMitP2wF@google.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 07, 2024, Rick P Edgecombe wrote:
> On Tue, 2024-05-07 at 22:22 +0800, Chao Gao wrote:
> > > 2. There was some concern that exposing non-zero bits in [23:16] could
> > > confuse existing TDs. Of course KVM doesn't support any TDs today, but if
> > > this feature comes after initial KVM support for TDX and KVM wants to set
> > > it by default, then it could be an issue.
> > 
> > Do you mean some TDs may assert that [23:16] are 0s? A future-proof design
> > won't have this assertion. And this case (i.e., some CPUID bits become non-
> > zero) happens on every new generation of CPUs and doesn't confuse existing
> > OSes. I don't understand why it would be a problem for TDs.
> 
> Intel defined these as reserved. AMD defined them for guest MAXPA. So, yes, OSs
> should be masking them. I'm not suggesting that any are not, but TDX module
> folks were concerned about this, and that then KVM would not be able to turn
> this on later without breaking them. So just circling back here to double check.

I'm with Chao, a kernel/firmware implementation that asserts some CPUID bits that
are currently reserved on _some_ CPUs are always zero deserves to be broken.

