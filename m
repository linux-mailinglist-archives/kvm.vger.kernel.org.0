Return-Path: <kvm+bounces-36589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC82A1BFF5
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 01:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9051A16398E
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 00:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B88FC0E;
	Sat, 25 Jan 2025 00:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mbXaXGot"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98664AD23
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 00:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737765856; cv=none; b=ZBBbj4NJGoYX/fE9/isyxLGvasooGt8n0raKZJZ7zz2vkOihPYVjvrEx2tTUcrQ93Suspl24rz/Mt3qygz4ZJbzZfSKoTbmMxm/YK+igY4mOqHtpOsmdXkTJla4QeMUXC+93xOxwJTCC3cmhcepyztu0rtpvT4g+SxFD+0pAAPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737765856; c=relaxed/simple;
	bh=pC7DUsJbI1YqlZ/8hq3CoUBqTwrwUjVf1DpFdOgMi2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sJUW4YEBxr3XaesbQNdq097jmNcvqAZ/oQOJ86fwSIt1nwS0Hc5Xq83LT7MQCUT63TgrLWc0Kyj1Kbs57uPwekQMTU2W906g8GSVV01MLSPiS3lYrYHlijFS/fxYVAwwjejYdogwmrvLLoNaMrbX0WfaAMlroGzjLSThffk7UKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mbXaXGot; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2164fad3792so43837475ad.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737765854; x=1738370654; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zivMCFxdca2P9n79tAqy7NBoMxKoIa9K+BO/Z86Wb3Y=;
        b=mbXaXGotJVYvuXFqDh28MQfiDu34/c7f9G2dufloeny5NI3uQRRP3ohMtlFkqh5Ay1
         ARfLppssy0OCPR/fcco6X7BzejHUiNOLG0q7RK0j7wKEPSAixPQb4AIUkMDRq5NnbE/H
         L4sEAVVAZJ3C/11mCNgPmfPBKJQLi8zPjFZh5KpsJ4bCrXf+XWCWJzmvgdBJ64FJu9EL
         PnO3yDVGCv2PygAQZTsO7ECqkegAVPH0AMv3soXOlViIjQl0LCS5G1H+t8pSrxJ/FGj5
         SGMzJFeP2T0Fm3mI9jye1EAkDvXh61Q+0wrqXBOyCiiBOii7h6bRMT3F16iAsv2c50mn
         +GEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737765854; x=1738370654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zivMCFxdca2P9n79tAqy7NBoMxKoIa9K+BO/Z86Wb3Y=;
        b=pGgRDx7h4kSxAFcHtH+QkMXzqJuJzqOU4nzDw0ULEpZIAzu16Oo9z6K9B3Na4co6Mh
         sMiIc2m8XluzDpRFTVAi1SBTL1pjMLE6DExqrRdMs99G29iJRDaqRyJtRymZtMIBN9rj
         rFoIksiIDWmCsz7aS/At/rYewV0notKl3Ndq8Fec4112YPWE9x8P3scfiXCU2vulcG4P
         DgrkupEmNuq2HkEONY4mVmSsr6UUHRt6iUU93u0Lf9PLodI/e3FE2c4dixKHvGlcyi0R
         +k+jT/UuGhmBMrlqi5kV9io6JraXxNKBSKq7w9yd8ooZ+dRLHh717dWNkmzcetA0cabd
         u6Zw==
X-Forwarded-Encrypted: i=1; AJvYcCVi24rl2TCjRTLzYXybRG7EPX35ZTzJ277Ckzz6gTzpMlEVpTC1wNY7hFiHiCf6Y3XS4uI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzrhv3DFb1uFMPaaGao9+iQVZ/ELXrGeWdJGmlYmton5c1wvQG
	Sk5WiJD3HE8h0hTYpeyk8/G5knC24hxVuqkQO8XAkrxy6FrpxAgfaS/8SpEXgsBPuV567XPxzg6
	tzw==
X-Google-Smtp-Source: AGHT+IG8OnjC+ndYgha15w7cowD2snF0FEnr0/HcEOPqssr8UmSQWO3pLxX+m+WGxUZaNu0fWRsEyrDLfQ4=
X-Received: from pfbf6.prod.google.com ([2002:a05:6a00:ad86:b0:72d:3c02:cd7f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a12a:b0:1e6:51d2:c8a3
 with SMTP id adf61e73a8af0-1eb21481781mr48007965637.10.1737765853808; Fri, 24
 Jan 2025 16:44:13 -0800 (PST)
Date: Fri, 24 Jan 2025 16:44:12 -0800
In-Reply-To: <0188baf2-0bff-4b08-af1d-21815d4e3b42@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124191109.205955-1-pbonzini@redhat.com> <20250124191109.205955-2-pbonzini@redhat.com>
 <Z5Pz7Ga5UGt88zDc@google.com> <CABgObfa4TKcj-d3Spw+TAE7ZfO8wFGJebkW3jMyFY2TrKxMuSw@mail.gmail.com>
 <Z5QhGndjNwYdnIZF@google.com> <0188baf2-0bff-4b08-af1d-21815d4e3b42@redhat.com>
Message-ID: <Z5Qz3OGxuRH_vj_G@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 25, 2025, Paolo Bonzini wrote:
> On 1/25/25 00:44, Sean Christopherson wrote:
> > SRCU readers would only interact with kvm_destroy_vm() from a locking perspective,
> > and if that's problematic then we would already have a plethora of issues.
> 
> Ah yeah, I missed that you cannot hold any lock when calling kvm_put_kvm().
> So the waiting side is indeed a leaf and cannot block someone else.
> 
> Still from your patch (thanks!) I don't really like the special cases on
> taking SRCU vs. kvm_lock... It really seems like a job for a mutex or rwsem.
> It keeps the complexity in the one place that is different (i.e. where a
> lock is taken inside the iteration) and everything else can just iterate
> normally.

I like the special casing, it makes the oddballs stand out, which in turn (hopefully)
makes developers pause and take note.  I.e. the SRCU walkers are all normal readers,
the set_nx_huge_pages() "never" path is a write in disguise, and
kvm_hyperv_tsc_notifier() is a very special snowflake.

