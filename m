Return-Path: <kvm+bounces-50524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F11BAE6D46
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CE5C18951C0
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 17:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABAB52E1729;
	Tue, 24 Jun 2025 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qr1RvsdH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8489022D4C3
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 17:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750784805; cv=none; b=HJhkzu++sIrz40bmUmUx8u2+Xxcc8w5wKZelEkRX0LlMSWtdT08/9EiUrv8dZj14oVC46BAuCQnQaBvh5QEvdAMTmnxeWCR0ynPovrbw8x/Al8PkG71KGgI24EiZpFuygvnRvQQ+w8Dnqzl1B6BxYsMT92sRAY9HHSdpfD6+1bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750784805; c=relaxed/simple;
	bh=El96RS2GoB+xf+x5xkRmmKhAycZmnaHN2uzD4493RT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TSjtXhV7AvGpqW730xmAV5oIli7AIzy6bUdBNLAw7IUyTJ/6zZJc57MCf/sTYPEaB/F3tlVS8cCPpVyCbWRlpeIy9URyhc9GjUXjrCxoXp4I7GH/IJAJBSZxXe+KkP+33pPRy6STSaTHZgrroAFEIyee/hZDSh+gmoMYIaSk+Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qr1RvsdH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31366819969so699457a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 10:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750784804; x=1751389604; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Fj3ia1xYcZY5Hv5rbn8TPDKNjSzgo+utgMvYqBwh94=;
        b=qr1RvsdHys8bD6enK9LV1CLvZkESbZ+H5V1Rmf08jNW6fx8qVmVEN9/5fltZQzOfyv
         Acnu3EHojahxOi00XI3SCNZOGLUqfcSjxlXRN1nPGvRoklAUxf6JlITItqNZP61fEFm2
         S6DulUrj3P49OdiKoQn4oj7RxVchQA9fC6xmdvxq/8ltPSfYSB7IT4grf9KADqvIZOQO
         P+aqDNZzpma0RIkUShr6lxlVExxIoW3l5ghyC1TRyvBMxVbJ+y7j78JoNltMipyMIfPK
         Tou0FY5OhMhN4HZzgg4roIdfb4r9DIFZnl3ojZddhQ3+1lIt4vQSvg92EuN9QCgL23uc
         lWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750784804; x=1751389604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Fj3ia1xYcZY5Hv5rbn8TPDKNjSzgo+utgMvYqBwh94=;
        b=iW/OiKDiYtkS1bWEzwpVeZCfsYweT19BaVvudN44KQUg1RS5gzSjtIdXXQO+7JVbDz
         whZuMqfSHQFsDSc8dHi+Vvln0/OwzY48jBfRe1ciBdEuWTRylR511eo8Viz4swOc5AhF
         u2V8o0aqr7okvI/rshHC4K9MVsKKvVbD7lhoPWRGvwRqunPKPkYOu+EpuEPWdwJDZPkB
         qJACzBBqOFqdzv66Wjuv1iXOO69v+BTXs3oRKmkhiAICY9r7JN4vtMnoQVYUypXqTlkW
         Kuco+ffg5y0s0YjG/PiOYRxknkICvRl6kdG2JkbSihqdIYYMX/bs7HXZJScJ4R3GglAJ
         np/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVi5XAeANdCX1cwkuIxaX5dm2VzgfH4z/DwpDRxCEKIXkYHoAFbfiVHWzoJdK3E+YNnXJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YysKogQ0dTwO9sp7qVeNzufBX+mqE5K/2Ip0gNSkL1L7PYKvUZ8
	8yKi4JfAa50Fh7r4i8qruEZvRuHvQNY/3Q8Ar5W5PqmKIy26z6BKa7mMYdAJDw5WuwuCL14R/ka
	HvNGlsw==
X-Google-Smtp-Source: AGHT+IG91rtujOF1URlp+uwPQ5xYFcxtfL51NMrhKNtKVdmuwx1+g9oU1lsxSZXSOfImxql2jLw2G1l0m9U=
X-Received: from pjbqc8.prod.google.com ([2002:a17:90b:2888:b0:312:1af5:98c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b47:b0:301:9f62:a944
 with SMTP id 98e67ed59e1d1-315eddb82cbmr578213a91.33.1750784803871; Tue, 24
 Jun 2025 10:06:43 -0700 (PDT)
Date: Tue, 24 Jun 2025 10:06:42 -0700
In-Reply-To: <d243d203-7514-4541-9ea2-1200f7116cc1@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328171205.2029296-1-xin@zytor.com> <d243d203-7514-4541-9ea2-1200f7116cc1@zytor.com>
Message-ID: <aFrbIgouGiZWf51O@google.com>
Subject: Re: [PATCH v4 00/19] Enable FRED with KVM VMX
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, andrew.cooper3@citrix.com, luto@kernel.org, 
	peterz@infradead.org, chao.gao@intel.com, xin3.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 28, 2025, Xin Li wrote:
> Any chance we could merge FRED ahead of CET?

Probably not?  CET exists is publicly available CPUs.  AFAIK, FRED does not.
And CET is (/knock wood) hopefully pretty much ready?  FWIW, I'd really like to
get both CET and FRED virtualization landed by 6.18, i.e. in time for the next
LTS.

