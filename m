Return-Path: <kvm+bounces-21225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 36AB992C323
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 20:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC974B25E75
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 18:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2073D180037;
	Tue,  9 Jul 2024 18:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iO0fOfTw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E64F17B057
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720548685; cv=none; b=YHvvKNDhwvBDg+8U9fuDJONlxn+BveoAnV+bg6xoe2WWYD5J1j+mtHBatsva9CqxUZOAN+aZ1JFLhyDqiaoWqewNNnnqdRwnh98J10QVBvXtzBDId5fhN39nIF1ml6iGm+79ZJEjXkfE5dQ1Z51MJ7RnFjxy6rPwdmOVcRwmWpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720548685; c=relaxed/simple;
	bh=TOXIuMclA2k8tL837RtgO8TyXXk0WPbBnMUF/2eUGz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jg5OyKzNkOWbmKZrsTaZ4j4vyUtA6pc/Lba66Sowlt3X0qwPM9ReCMIsaiYcwPTkZFmQIRQ3HncWXdDhe9z3p1TRhp0iriZVjJTOJGrxjMyiTcYJjdq9nzB/569qnstHhKAZZTneSUSG282pfkhK4NYx+17wI+wO/p4cDyBa0cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iO0fOfTw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c974ec599cso12021a91.1
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 11:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720548683; x=1721153483; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ0zegn3XbPh6Zss1RAlAIrL9aW5oGVVSySJPUmQKpk=;
        b=iO0fOfTw4jFhnTtQjVjGH20mJejK6VUFE77ZZI8gc2M2DPaFxI3l78DKNi2lbFfIy7
         axvh+PCKNBkQQlPbcPXC49vQl8Xk7AtyshPUE3l903kgd3Gc0Shj5q3czEMUPVl9Qi54
         gEwBLT271mqS57RYq5QsUfsYY0gXLG43p7SVKjaKw2tNbUn74V9h1fjkBfOVB8kB3OuU
         HdT8WnrgjR5sE2VFHBlVnd0T7ed2MNzfOe8sc7ExRg/Lw9o8kVBdoiANlNrgVdh0XcuN
         /LqBR7vvsgm7eB2oMDrzSisCqUDHDT37S+EQk26h8VnwRben0xJwwx0f4R+LkC0xrEs1
         F06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720548683; x=1721153483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ0zegn3XbPh6Zss1RAlAIrL9aW5oGVVSySJPUmQKpk=;
        b=i0zKGotXXxwWpOVeQl3Ayb86cS9kJsdugaofjwjOD88IMAfRo9R0GV7KmWhCqE//rw
         9RFKGhqhYYjwefbXbhlyLT7EGmLLVooiMmScx2DSi31yfHpMMzftgsIA7xxvPMyDpoFM
         /XjWtkQRKKuprd3vdMqYlz8NheyyXVcwVkgMkTucPptniIQwKA8Y/qN1sQqJ2lB6WK/R
         yrn1r2wKCe7PdKWZIfAsZD5/tKdzQMDMmTjzp5Iy7dPsbftINcnmMevlAhK/WSM1oqEh
         i4UsQdBSPPPXJ2M0lX3u0oKJUPtbfp8NwtYW9I+sobU1KcMuUswNSOif/m0MpzqcW83Q
         BRGg==
X-Forwarded-Encrypted: i=1; AJvYcCWE5xeDZ3wDrN/54aKwdveLSW9ZponfLVQHDn9sWigKbcdg69+gil3s0/hZuYCJvovuz8sWmbpMFzOGf5ztP2/Mjtj1
X-Gm-Message-State: AOJu0YxiA6LKmDbZEFR0RUQj2ViOq+dDGKTqjeqOz0iiQu3IW1y5hn9X
	bip8C23la98Zw/zpk7I+CIS45ogYQ4yfX7/t6WcjdZ149enYyG6Uf3a9vmfKwhXDGX1t8ftdF8U
	mLw==
X-Google-Smtp-Source: AGHT+IEW8j5jCCdLqxLGS0NLhCB6rditdfbyBmG5H0mUepDvlfiJzMj9BMgGvp0sNCjgOsWUe5fRfV6jTr4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1004:b0:2c9:5ca5:4d20 with SMTP id
 98e67ed59e1d1-2ca3a708a4emr58889a91.0.1720548683215; Tue, 09 Jul 2024
 11:11:23 -0700 (PDT)
Date: Tue, 9 Jul 2024 11:11:21 -0700
In-Reply-To: <7c072dac426f77953158b0c804d81c664c00d1e3.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-26-seanjc@google.com>
 <7c072dac426f77953158b0c804d81c664c00d1e3.camel@redhat.com>
Message-ID: <Zo19SWre5eJm8XTu@google.com>
Subject: Re: [PATCH v2 25/49] KVM: x86: Harden CPU capabilities processing
 against out-of-scope features
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > +/*
> > + * For kernel-defined leafs, mask the boot CPU's pre-populated value.  For KVM-
> > + * defined leafs, explicitly set the leaf, as KVM is the one and only authority.
> > + */
> > +#define kvm_cpu_cap_init(leaf, mask)					\
> > +do {									\
> > +	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
> > +	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
> 
> Why not to #define the kvm_cpu_cap_init_in_progress as well instead of a variable?

Macros can't #define new macros.  A macro could be used, but it would require the
caller to #define and #undef the macro, e.g.

	#define kvm_cpu_cap_init_in_progress CPUID_1_ECX
	kvm_cpu_cap_init(CPUID_1_ECX, ...)
	#undef kvm_cpu_cap_init_in_progress

but, stating the obvious, that's ugly and is less robust than automatically
"defining" the in-progress leaf in kvm_cpu_cap_init().

