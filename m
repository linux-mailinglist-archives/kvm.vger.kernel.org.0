Return-Path: <kvm+bounces-50588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5059AE7275
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60800169F9B
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C588125B313;
	Tue, 24 Jun 2025 22:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bH2hfsEJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05FF170826
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 22:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750805341; cv=none; b=d4EaqqzFgj6TZ9szXk9SWkB+y1ewWqx6n7xjwhEaoC8FunckEWqcUooyirhuvlzzj0EtHNrRY9ygMVT0+SGGpR90Rk+UoVYa6+SqdEOwmNXfe3bdOoiM4W3MTVSABKfbEyF+sMeT38A7+ygQmaK+v/hAW1P3YtgFA25JaRWJe+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750805341; c=relaxed/simple;
	bh=tKiCEWoC9S/+PezCVVnVqszcAo6lmpt/ehelyNKt5Xc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ipVRiYvM0DDPwsi4ZJxMc7jvUBegvrH0QLsg6e7DTdCrrdcjOWq0p4mkr0pgikFJQJEJH6yS+LBI+eej5S0ewz0dO+zlTs9BGdAipA/Z79M1eSUxmmA1hVUe4JZ3JBxobg0zKlvQ4Amy/RYM7kcmliv56HiDCpIH2cP1TV9sUF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bH2hfsEJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-315af08594fso3681842a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 15:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750805339; x=1751410139; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pakrfgZ40BEaKLVsq66zFAHqKBjQfVwDd34V+Ag+OKE=;
        b=bH2hfsEJm8EGlg5Wj07/F4rQv9W3IoXnh/1TIidWr6xgI588vDZ+rndgakeov68mbt
         yuQioel4aQem9AZJpT01VvQhouLwMxYiSQ8BMt6KaUSaS4+HPdnGUsCQTPkmt0f2Q5I3
         xyUdzZOEGJJFAaVus23iab7i9WaSOwaXsZTNxosKBKctDMvLUaoj5kBqMclJ+dOpuVEM
         m3tixcd0z5jBJgzQy16ZPE66apRdeTvvR+fr8hx6Q9QP2CZ/zmIbnyNF8T+RPZjeT+Fl
         4jyDmt0Ab+bLzranm708SsCJJ72dB1opGYTO5pt8D3wcpvNBQe+KMOfctDJcetGrS9Wu
         SyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750805339; x=1751410139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pakrfgZ40BEaKLVsq66zFAHqKBjQfVwDd34V+Ag+OKE=;
        b=ixQhckCngRRf/enx0dXZ/gl4W5r6eaHvIhtIGFz+3NiXqyDP8A2K7e1zvpq7z7BxNj
         9llr2X5KiUkD5i4Lfvk+R83yEFCBkd8iQAD+uFr67c3yTfiJXO/CvU+nC+QgHyHcCEmx
         xYtZ5ngDj3i/1iAod1hPMj1DXzcStQIue32IUMQIyxjK1WXO9Yaar7ITBQYV8TqlZtNL
         1VhgXwruWvhNEXEaMEd48mEU0gXxhWwBFh+033WbvfbIbZ9GmWJiB4shrCZ23Vs5ErmG
         JL5LSeKK6szDbGNJpfZbg7jSu1O8hf5DwQ8HXEfbM8SVWTj7UE9SZI3cWWFxdRfUKUfW
         NhCw==
X-Forwarded-Encrypted: i=1; AJvYcCV5vW5si1lvfUEKrsBgh+rCjkix+/ymh1y15a5fENJgR/Xv5UZ57f49KTDMmkMLGeiIhug=@vger.kernel.org
X-Gm-Message-State: AOJu0YxojXzqvExOmbEPI6Kh/KwwfHOzM3CNFtH5BdCEV8JEaANKnv+Z
	ofHycpz1qgCDwNMeFJY5ZMNNjo3PAz2HPoke/lnIxHS1vvXgxDDkGOkeefB/5GlPhB2OpNjgRjo
	DjC4vHw==
X-Google-Smtp-Source: AGHT+IFtxnJNBQX398hfbuOcQH3X57w1Ez2xpJMM8EDgXELaWyuLtPEm3RcRY9M/lHgpgKlMyhZIiePSNc0=
X-Received: from pjbsw11.prod.google.com ([2002:a17:90b:2c8b:b0:312:3b05:5f44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3948:b0:311:ef19:824d
 with SMTP id 98e67ed59e1d1-315f25e2e0fmr897420a91.2.1750805339102; Tue, 24
 Jun 2025 15:48:59 -0700 (PDT)
Date: Tue, 24 Jun 2025 15:48:57 -0700
In-Reply-To: <20250612081947.94081-3-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612081947.94081-1-chao.gao@intel.com> <20250612081947.94081-3-chao.gao@intel.com>
Message-ID: <aFsrWYaF9Ces3lIl@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Simplify MSR interception logic for
 IA32_XSS MSR
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	dapeng1.mi@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 12, 2025, Chao Gao wrote:
> Use svm_set_intercept_for_msr() directly to configure IA32_XSS MSR
> interception, ensuring consistency with other cases where MSRs are
> intercepted depending on guest caps and CPUIDs.
> 
> No functional change intended.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
> With this patch applied, svm_enable_intercept_for_msr() has no user.
> Should it be removed?

I'd say leave it.  If it's a static inline, then there's no dead overhead in the
binary, and I like having parity between VMX and SVM.

