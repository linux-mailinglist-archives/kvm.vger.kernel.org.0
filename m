Return-Path: <kvm+bounces-36136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A14A18198
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23BD516B65E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B021C1F428E;
	Tue, 21 Jan 2025 16:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oUn6XRqF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F18224D7
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737475230; cv=none; b=riDoPQQdCNufJ6dIZspTYhEVMhj2tgvGufZUCguc3WDqIWRvG9my51qGhYsRBmZYNYEptJM8obdnmQxuzmHiQ8dyDZy/ZGjcwF0CeJbPso+bGOBrFLcO1BoPGMuMPLPfVgzhvOAiyz6ncBm8RrcBCu593H/hwJmIbarydbwsmTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737475230; c=relaxed/simple;
	bh=EicM7X3YMAmO/4d6190TcVVMcOWHVZUm/HS8XF4cjUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=us9Krv7zK8eoJWacaWNNn+S6jvKhdrdUg/eOZTzrs69UhOtmRElaZd7n5rY4iYGrQ3Qgo9idoLhnJrlGVdtVPF4fuQrFsVUnXDVsMhfLAbcCGTxP8cul98ewC8DxDeYrGqqWpQj9ubSFPXe5jtMkrpydyuQzwmzhmLxKDEzuNTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oUn6XRqF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efc3292021so16694253a91.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 08:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737475229; x=1738080029; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FcvouzLzCbsOet6nyiRu1sxyIbD8hK9cg7WAyq0uGH0=;
        b=oUn6XRqF31l9L8r0ULhkrLyaUCJFz/js9sYqiWloCfAfcqng0bJW11AxpHgCaByd0n
         oCYoebR0bzEvfms7BqdNl4GEt6wYsE0p8mAaFyyrgm/ygcX5gPpLaKjJlv8GnV7rljXn
         8lYLXN/TSkfUhH+utCa/c+XFEul77g7ILiIYbzeLxHq87oKU34+5Evj8Ab/9rk/eI9tx
         ekeU72dCyjeg5+N4sFE6F7B4qPKJp1qZHpBMrP2Z4DfTSbFVQbbxNN07UZZbd30u5wDw
         GGi/uXNLsibLpejsKKg6oVkHrK6q923sTAQ89dsZhQll6teKm7egITB9TUq5iu4OH6V0
         0gsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737475229; x=1738080029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcvouzLzCbsOet6nyiRu1sxyIbD8hK9cg7WAyq0uGH0=;
        b=YdlsX+/3yHWc8azjiT7JuBRHfyfQMhqHX+1bRfeA2R8+ARIbu9zH8nBqC5YlMlKJiS
         66AYAK9kKkfWybtO2LF+n/2G3EzxqYnO0HyGlPtYG2iYHSAMPKVlgJg2UzCDWslCt61v
         ndclXcwQNQrrNOOHjDjzF3qCGxlHy7YUysuCssQTk8c7d7ouSjhAES6PSXbRSn6X9m93
         HDI4X75B0KMdo4ShqXWqk26D7xErh8LkkfpepCAT2E/Jjzx8Kn2IfHA8MPiQNkmDgJHM
         ds/bP8Cf07q3QHK8symI52LvmilbscZS17oY/K+JwitqktMkKVkPf2QGEs7FCKTktxSj
         byJA==
X-Forwarded-Encrypted: i=1; AJvYcCXvqyPmD8AV2rZJyO7kzZmi1BwTOO5WpEBv/2sRQL2osqOAaXScv7fCr8fCb5sWgT3ClWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfMaKYT2k3pGWZ4lF4oD8+lwJ31tvFWlm9BrnOVg7GIdt7ckUF
	CnmXr9KfOjeRc4YThIv+tCxDTx2H+chEO5kYyJgfDqU+aBgmEYnifOUZoMCLa9u65ST7OBK58O8
	aPg==
X-Google-Smtp-Source: AGHT+IFvQ29y/16pSDIesJONr3YtfNFhioLCrBobAQRpweKPd0JZ7QQznRTp9GRySClzqwYoEEjbzpPkMO0=
X-Received: from pfbbe3.prod.google.com ([2002:a05:6a00:1f03:b0:72d:4132:7360])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:811:b0:72a:a7a4:b641
 with SMTP id d2e1a72fcca58-72dafb71a28mr29231118b3a.18.1737475228851; Tue, 21
 Jan 2025 08:00:28 -0800 (PST)
Date: Tue, 21 Jan 2025 08:00:27 -0800
In-Reply-To: <877c6p8t35.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118003454.2619573-1-seanjc@google.com> <20250118003454.2619573-5-seanjc@google.com>
 <877c6p8t35.fsf@redhat.com>
Message-ID: <Z4_Em95xkvagPOHN@google.com>
Subject: Re: [PATCH v2 4/4] KVM: selftests: Add CPUID tests for Hyper-V
 features that need in-kernel APIC
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 20, 2025, Vitaly Kuznetsov wrote:
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > index 3188749ec6e1..8f26130dc30d 100644
> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > @@ -43,6 +43,7 @@ static bool smt_possible(void)
> >  
> >  static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
> >  {
> > +	const bool has_irqchip = !vcpu || vcpu->vm->has_irqchip;
> >  	const struct kvm_cpuid2 *hv_cpuid_entries;
> >  	int i;
> >  	int nent_expected = 10;
> > @@ -85,12 +86,19 @@ static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
> >  				    entry->eax, evmcs_expected
> >  				);
> >  			break;
> > +		case 0x40000003:
> > +			TEST_ASSERT(has_irqchip || !(entry->edx & BIT(19)),
> > +				    "Synthetic Timers should require in-kernel APIC");
> 
> Nitpick: BIT(19) of CPUID.0x40000003(EDX) advertises 'direct' mode
> for Synthetic timers and that's what we have paired with
> lapic_in_kernel() check. Thus, we may want to be a bit more specific and
> say
> 
> "Direct Synthetic timers should require in-kernel APIC"
> (personally, I'd prefer "Synthetic timers in 'direct' mode" name but
> that's not how TLFS calls them)

What about adding quotes to try and communicate that it's a property of Syntehtic
Timers?  E.g.

 "\"Direct\" Synthetic Timers should require in-kernel APIC");

