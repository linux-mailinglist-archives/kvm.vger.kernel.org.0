Return-Path: <kvm+bounces-34072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3BD79F6D7F
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 19:40:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DF60188BF78
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 18:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B0D1F75B2;
	Wed, 18 Dec 2024 18:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qvWBAcMk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC89C1591EA
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734547246; cv=none; b=c2SHWnWOdoUVEX3ldqYYocaxjqunD8eb2p/NsoMpKZbVUi+PmGaDxBBAmERZWIgnE711ewimzZZ5345O4aQxchXH4ohVQ9J9H67/f5w5mvBjvk8bfUjezTYaFfA197OyzUIm9d3GPiTnOgj5KTTeH/p9MGuAFUaPW9l7EoZadHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734547246; c=relaxed/simple;
	bh=bFJEEE+0gBHYRNKBl9xpKnRhkLk0RNkVZrYyI7MVqYI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NkZvEEZr+u7DKLJEfVim+S9IsHPmYql6MWipzjhMoAYbfNSEEsWzvb/f6EKUJn6wkI9uZeJ/P+YO09hfpTYzE9fokN9Gy3WhUtINpGje38B/htjRGj828yltQvGxmqR84/wSEhvLt7UUXUq1lYZXpst4rYcooxBGaA4yfg3BD58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qvWBAcMk; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2163dc0f689so128335ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 10:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734547244; x=1735152044; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OzieiW8Tf7T8nD4mz7EFI6MUCvAAA+a8HPwLq2IuP/k=;
        b=qvWBAcMkgA6/J2ocwmUyblpMJLg2moHy5nvQekPiSY3hYSkISExir4No+RJH4lxheW
         Xna1UF360R94MfcZI2h28dUinH0BN+zqsztHK+dK1QSF0pihsjtuTfrp1QxGUSDhBYtx
         2VEHYKZRj+8T82+Gzwnm9PnAH3/lO8DTXHKxkIuoaz4U8vXes5O71VetuQGpwplsOEWz
         4sb+6E6O3RSPNJ7vZDFpL5WptfYwfqRAGFfuRcDrPJ6Qu69rhP3mPJ9xeE0rMhTYvudh
         4ieo/2WlO2TK9LbCNeGOB/MntFCLQG/0W0TUrxPwOT+BXJebwezmHXp8lXJoZ6Gz8NTb
         oGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734547244; x=1735152044;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OzieiW8Tf7T8nD4mz7EFI6MUCvAAA+a8HPwLq2IuP/k=;
        b=W/qvC1ciZbESnGrD68xH71BUlU3Y2j/Ix3PT/i0dn6P8mjGFUsv/EqzIEV1IIlckLk
         sX9RzYqpquv+df+4Y6KXNN0iMlV8w8PA3Xk2BCyltv8+FswL6xTNrzbJEZBEevwVFglo
         a0fS3ZA0Zx4xh9kQUyLb5Wov//UAb4QsVxJ1k3BR568751PaviSCjL9uKfq4grfPcl/l
         rLKZHeujoWSfbK3A8Qv7oB9f48ESz0BKnT0RdwN3Tw/h6TtVGZbKNb3V3S8884NCSau5
         RHSfqY/Vgw6lGjj5sTg7hD5gq9ghmBKL0kxP3fa76bntHUrYh6a5U2p68oDwsp7+gTLb
         rXRg==
X-Forwarded-Encrypted: i=1; AJvYcCVqXTrObgrWZMwYoq/FNgePPghdShnwTA0NscH0p0Dv6Wjm9fK0IMuu/xl/yJxBnDgNhx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUuk7/cXMhXwUJWcQOWV5ws4U/XbkHa+JjYDyb2xGe7cxi4kd5
	9h4gTeuinkM9YkZM3gXP+pZRIjaD/ghQXR4Cr21SoBU028/JHkvO8SF4PUZVPXKHshQzyQbZbVn
	oDA==
X-Google-Smtp-Source: AGHT+IGk6ZAVDZ0yAen+YI2vSFSw8kQboYKmNe7QWGMy5RhwOJRv4IMWSpKWYTEXY2oprjVAkemGMkREYuM=
X-Received: from pjbsz14.prod.google.com ([2002:a17:90b:2d4e:b0:2ef:8d43:14d8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54c5:b0:2ea:b564:4b31
 with SMTP id 98e67ed59e1d1-2f443d0574dmr430684a91.19.1734547243906; Wed, 18
 Dec 2024 10:40:43 -0800 (PST)
Date: Wed, 18 Dec 2024 10:40:42 -0800
In-Reply-To: <20241217181458.68690-6-iorlov@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241217181458.68690-1-iorlov@amazon.com> <20241217181458.68690-6-iorlov@amazon.com>
Message-ID: <Z2MXKkNb-aSLK2z7@google.com>
Subject: Re: [PATCH v3 5/7] KVM: SVM: Handle vectoring error in check_emulate_instruction
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, dwmw@amazon.co.uk, 
	pdurrant@amazon.co.uk, jalliste@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 17, 2024, Ivan Orlov wrote:
> Detect unhandleable vectoring in check_emulate_instruction to prevent
> infinite loop on SVM and eliminate the difference in how intercepted #PF
> during vectoring is handled on SVM and VMX.
> 
> Signed-off-by: Ivan Orlov <iorlov@amazon.com>
> ---
> V1 -> V2:
> - Detect the unhandleable vectoring error in svm_check_emulate_instruction
> instead of handling it in the common MMU code (which is specific for
> cached MMIO)
> V2 -> V3:
> - Use more generic function to check if emulation is allowed when
> vectoring
> 
>  arch/x86/kvm/svm/svm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd15cc635655..e89c6fc2c4e6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4802,6 +4802,12 @@ static int svm_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>  	bool smep, smap, is_user;
>  	u64 error_code;
>  
> +	/* Check that emulation is possible during event vectoring */
> +	if ((to_svm(vcpu)->vmcb->control.exit_int_info &
> +	    SVM_EXITINTINFO_TYPE_MASK) &&

Let this poke out.  Alternatively, and probably preferably, capture "svm" locally
and it fits nicely on one line (there's an existing user of to_svm() in this
helper).  My objection to a local variable was specifically about a local
"is_event_vectoring", not about local variables in general.

> +	    !kvm_can_emulate_event_vectoring(emul_type))
> +		return X86EMUL_UNHANDLEABLE_VECTORING;
> +
>  	/* Emulation is always possible when KVM has access to all guest state. */
>  	if (!sev_guest(vcpu->kvm))
>  		return X86EMUL_CONTINUE;
> -- 
> 2.43.0
> 

