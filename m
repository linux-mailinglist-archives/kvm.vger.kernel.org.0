Return-Path: <kvm+bounces-46086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C482FAB1C50
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 20:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2535F50324B
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 18:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E8023E347;
	Fri,  9 May 2025 18:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WITzpjs6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB6023AE7C
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 18:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746815371; cv=none; b=Ufcwguy93AhjvjahTABVAEiULVxnhXdq8gxvgWiPZt12/jbTAU/4xsjbera2vEBn2IFSA5+/nVIDiE1b9MfWrZwDJp7BIoV8QGF453G97sm+zinfuq8hjmvULDCFL8kuLyLeuC3KUDt5PUMUc5JdWUI244kUmxAuH/YIk0CXWjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746815371; c=relaxed/simple;
	bh=TZ/CioQKPmReLVBRaY4JcPT8DKNM7VLtQX0w+Wrv/+I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=etmEuL1vbaYRXOUa3bCYLT34RosFxkpUYHL4bm0tu8/6LPo+0ZUBz929k9MPquHWsKsxTx8/FKrzN72bacC+VkE+bWOOM421R5g89Z12PrYAIJ7tO2xjRDi6My8UHWwDVKxyIDWCIuRsemnpy6vtdtSvefcf9Ml7eyFIcixrwWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WITzpjs6; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22e7e097ef7so20052925ad.2
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 11:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746815369; x=1747420169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OmUdZ7NWf24NGQucaka4MppQGDe1r3WG/B9nuhCN99s=;
        b=WITzpjs6JY4Ll1aVaTo3Pc8LltuVb5DqJxFwTJvf9FdYUhXfhkm9Q2huSqhQnM3txo
         aekxlXVx9YrHkOhy41JWljkE+ONcQfkGdOEKeePoJ0KJLe8EPkes8BrNBWBLGi+hp0ly
         QJYOQX+m5idx0bFHOuNjYdNxJDy2hY5hezUATrgAE1ujjm6veYJmD/x/N5yXLyJcWLss
         XzJYtGtoadFpb1ATZYFGdSwgnGQZddNmKZKX3E0TEqibntfdmYMjCqE3RYUG9VFS5/fX
         hcBMANDF/Dsv41g/IGaTbHNoLQVsSvPXU/7GQ+Ntqy7xx80HASDXViu/cnjWvLZbuwjM
         Lhdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746815369; x=1747420169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OmUdZ7NWf24NGQucaka4MppQGDe1r3WG/B9nuhCN99s=;
        b=vtREo/bZFPmYFMGAyRVzOaUEsLhtsz36KBnH78510ySn6Wqje5AsA4l47rU2ppxktw
         KDFbw6y9SjN2qmooIIKfL2nEyCGLURhiJiBh2Qw0A1V5akoYUVpOzNIOIeOgoDxRSvOp
         sBC/JzYO3JlnDCyM/6FC39CEWEJh2aHOVA8fy9Lv4nqO3xkoGSSRwzpvbXScoSVOHBEY
         vi5ueW249L6OG5d8hW8qOVliyuw0RvJvasg7HHFr3Vkqat+v8q9wiOrDcCe18de8BuPB
         WGyQpSGTVw+PxyaapB2VOi88IbPibGZIbSUTXKjLu9PTRy5S2EsqlF9YztxBQf7sYaa+
         2Xzg==
X-Forwarded-Encrypted: i=1; AJvYcCUTJGZO/Kf5MrWaAwkDGtCTpWaM46XxkVVWTIgYpBXt02ud8F1DnQObFpjd5w5HmyAcK+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPL5ab2riSnnz8MDknEZ4Gv35+IOWioWW89OfoesOSxlwQaHDm
	4/8yHG7FbIuUhaS5JA/bK5WI1Sjnejek9dOuuPBy8K4TCWHWQYUmkqrxandQYYo7STRllNasF4k
	MaQ==
X-Google-Smtp-Source: AGHT+IFrOu+Urvz0vnEY64t3GWYiH2n9+rMd9iGS1EvnXRCr73zi7B72X8HzZk53Hxmd3/d9MS5cFDIYAAg=
X-Received: from pjbrr8.prod.google.com ([2002:a17:90b:2b48:b0:2fc:13d6:b4cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e841:b0:223:60ce:2451
 with SMTP id d9443c01a7336-22fc8b33427mr57550815ad.15.1746815369640; Fri, 09
 May 2025 11:29:29 -0700 (PDT)
Date: Fri, 9 May 2025 11:29:28 -0700
In-Reply-To: <20250509081615.248896-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250506093740.2864458-6-chao.gao@intel.com> <20250509081615.248896-1-chao.gao@intel.com>
Message-ID: <aB5JiE6LupZhmqJ7@google.com>
Subject: Re: [PATCH v6a 6/8] x86/fpu: Remove xfd argument from __fpstate_reset()
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: bp@alien8.de, chang.seok.bae@intel.com, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, ebiggers@google.com, hpa@zytor.com, 
	john.allen@amd.com, kees@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, oleg@redhat.com, 
	pbonzini@redhat.com, peterz@infradead.org, rick.p.edgecombe@intel.com, 
	stanspas@amazon.de, tglx@linutronix.de, weijiang.yang@intel.com, 
	x86@kernel.org, xin3.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, May 09, 2025, Chao Gao wrote:
> The initial values for fpstate::xfd differ between guest and host fpstates.
> Currently, the initial values are passed as an argument to
> __fpstate_reset(). But, __fpstate_reset() already assigns different default
> features and sizes based on the type of fpstates (i.e., guest or host). So,
> handle fpstate::xfd in a similar way to highlight the differences in the
> initial xfd value between guest and host fpstates
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Link: https://lore.kernel.org/all/aBuf7wiiDT0Wflhk@google.com/
> ---
> v6a: new.
> 
> Note: this quick revision is just intended to ensure that the feedback
> has been properly addressed.

Both patches LGTM.

