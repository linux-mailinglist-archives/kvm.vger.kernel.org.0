Return-Path: <kvm+bounces-61683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 711D3C2509E
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 13:36:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 258D5466E58
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 12:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85F834A76D;
	Fri, 31 Oct 2025 12:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yA5vOG4Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D0633E340
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 12:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761914073; cv=none; b=pakW8Va7jqoM6xSgtp4u8giqXuunE8MH+kButGCgBngsdfg9HiYgkHpUREM/xv107gqRg5/nm9WLaQr6UkAA0xTapuWb6R7aypNanBB96bnmAaw2fKqd8oCMMRwB8KkZOMbCpmdRlbR39NCRSGmINoRIaT2qrQzAzNIQPHSWgL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761914073; c=relaxed/simple;
	bh=bTdeYhN0flt+JtdbGVAbBVozbl8U54zjEej7Slodurc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g0YL1EWtCARM1yDalUnQDSGstozGt7c0Nel/+5BVfpX25XKE1S6Lnp3YDir2VA3GPRfR2I3JXOAjitBlAbnRtOxM2nFly64odLni551HSbIBWbm2VGzoG/6oS4z/XiRvsbza/tdJwNkRpMUPfNh77p2H3RNJ9EEi5TuAYwFL414=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yA5vOG4Y; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42851b6a659so1311903f8f.1
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 05:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761914070; x=1762518870; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bTdeYhN0flt+JtdbGVAbBVozbl8U54zjEej7Slodurc=;
        b=yA5vOG4Y5zGtNCQ9vpFnjJoeIx9dxjHH62fKxXrd6ozSTh6WkYzt0V/s7ronZCNTMS
         /7MCNWWTJGnmynaecg73crwLxKi5wK96JaBC1AN6v6WTURbCXIk0nQxrE3NyrUTmMysM
         4kGs4LLIKt4SH8SApZjFXvYALFQ2DOOunRk4Zd6ip6FRn6VfjgyecreJiIPSOszkgEYR
         g8uDC+AO9R9cppYsYp3jGJ/njX7U6wqXKA2quiFCT1G1gVgUC6H0CG2US5hyJ3lQMRB3
         kBOu+xchWj+ap+qayC3Msh6ZVlHa7bGh2HcsevVKPkrPmInR5LK3uknE4gazlU3cagLj
         ydCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761914070; x=1762518870;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTdeYhN0flt+JtdbGVAbBVozbl8U54zjEej7Slodurc=;
        b=jx6e6OGG4fE3Ta8F3Fdjp2ygyhSW+LxoofZOvslnrM1Jhco4/nskw83MMgB+hxP6vD
         Cb7HOOQM8pDMtQuQwMZZ6EtXDF/c3NhAh0hWUL9K9eKJk6NlOazeW9GmGyg7mLKVO+0W
         +HKie5wQc4zS3AC3qyldAZEbFGoMqO4WRZlf6kXHACPp0ux/1ebXsenaGPPD/TgEjQlb
         gsQBXvjSQWKi1ncr80/KFhWtQL9aGb8k0JHK0j7uepHPvw0TsolPmjVWNvcdUtMssN/Q
         vKGC9jYMDFlktMvVh3izcRw4DFzE+vhqphuVqdeBeVDUSCGUSxZU7gZNoeDev96dIEfE
         v4Ng==
X-Gm-Message-State: AOJu0Yzz1n7/9KuJhRTxoVz2uRUrTqsJeyXeSp0mvwwOH3pxnO++Jr5A
	DMb0eGabDvtjCIOyBVpLUZDoWBuhLPmywV20O1M74iYRMClwywvBBjk9XNWqxzRZGQARN/fmEZT
	sg7pKEZ64wAWncQ==
X-Google-Smtp-Source: AGHT+IEcmJDW+mdR12d71dV69TyMCqE2z9cLbKBFIHpu9vW9fhLESNvhwJbM2skNQbr67ZD5in1TdoBQvs6+DQ==
X-Received: from wrbew12.prod.google.com ([2002:a05:6000:240c:b0:425:7c33:42eb])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2f88:b0:426:d51c:4d71 with SMTP id ffacd0b85a97d-429bd675f4fmr2453446f8f.8.1761914069820;
 Fri, 31 Oct 2025 05:34:29 -0700 (PDT)
Date: Fri, 31 Oct 2025 12:34:29 +0000
In-Reply-To: <20251031003040.3491385-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-6-seanjc@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDWIETE937VA.1JV3X655CGIFC@google.com>
Subject: Re: [PATCH v4 5/8] x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM
 as SVM_CLEAR_CPU_BUFFERS
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
> Now that VMX encodes its own sequency for clearing CPU buffers, move
> VM_CLEAR_CPU_BUFFERS into SVM to minimize the chances of KVM botching a
> mitigation in the future, e.g. using VM_CLEAR_CPU_BUFFERS instead of
> checking multiple mitigation flags.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Brendan Jackman <jackmanb@google.com>

