Return-Path: <kvm+bounces-63158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 73AF2C5AD1B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:43:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4158B35874B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587762264CC;
	Fri, 14 Nov 2025 00:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Dz4D+jH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502811DF75A
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080817; cv=none; b=vATkkjDSCEuJAOCr70MJti0TbjyeHM1fEZ/mGciaUd9UopVu1CYpFDMYMO3QjES0DBgMLko+Vv3s5S35owSmDPzKSpvkiEyHjlLeRKJuuHgsSVApE9U2fLpsYCm424n6ERP4jHYC4ubcjbezYQh68Qx/js6RmMTfN8EHJ+iKmzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080817; c=relaxed/simple;
	bh=fC6Lfx89Q6A/ILnNoADOpFsvqh5jt+8wGqirTtaveQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O28+r2NxHsdyeo2gCrN8F67dXZUo1rk3Q6xlLnr8lqVLaGCPzvWDcyyadKjzRgUVUg6hCHdE3fkFaOj9xZL180xU+aQoEB3Y55gueZjduwRZrQ9EOWxwRBmd6JOYzXtztNGnNs1FFwd0mv3FlIfxiHtQ0g/R9o/zxfjqJk84Cd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Dz4D+jH; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so1157335a12.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763080814; x=1763685614; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eCrzPbEJP0qvYkIYVG+EVFzb74TW2BhSX0GpAn9qGqc=;
        b=2Dz4D+jHdQ6bYFHIz3kQL88SqJJHVSOXftVygQefgmKWIJHIEiCE8KLJQI7o95k5m3
         cjSqYd6V3JSHkUYagiI234oMZAKvNgmIzhDWr+maeBzRfiD1d/Z+afXXcoHm5hO3sx30
         BeN3zJSk9lpEef1MtuJfWlBWL762Yr0xhEmIxgDZWzi2ptc2JkzXdHxEM09d2x3CMyUg
         mpfyiacr20MpunS0yaN1S0dXrj9RUAe2l8pExTg3ZntQY3EyRLeLfg3FqCDQJa6j3Vl+
         1ZjPMbChAG3dagZvCloGabs4ldgbS6zkSanH4qTZqf135htj6vQFRrX7dECUIYi5DXA+
         1PHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763080814; x=1763685614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eCrzPbEJP0qvYkIYVG+EVFzb74TW2BhSX0GpAn9qGqc=;
        b=KRbr9DWjnCu58fBKrm0IZCniiQX3n3VVT5ykngKiAagwGkPtZtbXxrzl5WR6fTliyW
         YMDIca+DABAew2B7iepygKjYCTM9ttI+e6kT7x/jOrf2yyje7Fi+ChbCufEJs4HugvxT
         bLN7/x3ts7OASgiHsxCYuT4JpJWlaCTlkzqmlf350vYl6iIZ5WsrQnkfkdROTOKM9ROE
         r5oJS3PY8Vy2OIPkjUrCp/eTUoU8OwkoM/fN4PJj/2Hy7jo6cM92oGcmOHzh5UQB59d5
         Edl352bJiNoghjHU3nuHN3dHp9mv3EelB119opmpK+1e8x37wg4TpF9/8YOCepBYBhLE
         V5mw==
X-Forwarded-Encrypted: i=1; AJvYcCWFsA3r+R9p7uK+P5j1fjdaZ1qu0gpX4JjnX6LGmGvei902snwNK77dyDvft1rorzRLZUU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzgp0JKbcigL2WmULwxM6tB31D70wVLSaMLPHJG7c/UvU6bSRtz
	JkjFy8zPrx34oHzidSXlDPT7vnTfu3RsrPVLMXAX4RVZePEiN3jSVbr/RWmdaQ/fr3F7/+sazGD
	K9p8OqA==
X-Google-Smtp-Source: AGHT+IHMUlT1trG7JPmyoJUWFnhHl2vLDOJ0OhAxADq01bwhnLfSA84iHljh7zSoTbkrtf907lwT8IEd9LU=
X-Received: from pgbda8.prod.google.com ([2002:a05:6a02:2388:b0:bc5:a3fa:e028])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d85:b0:334:95d7:3305
 with SMTP id adf61e73a8af0-35ba22a4e5cmr2028188637.28.1763080814498; Thu, 13
 Nov 2025 16:40:14 -0800 (PST)
Date: Thu, 13 Nov 2025 16:40:12 -0800
In-Reply-To: <20251110232642.633672-3-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110232642.633672-1-yosry.ahmed@linux.dev> <20251110232642.633672-3-yosry.ahmed@linux.dev>
Message-ID: <aRZ6bM_yVo9-zyDT@google.com>
Subject: Re: [PATCH v3 02/14] x86/vmx: Skip vmx_pf_exception_test_fep early if
 FEP is not available
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> The check to skip the test is currently performed in the guest code.
> There a few TEST_ASSERTs that happen before the guest is run, which
> internally call report_passed(). The latter increases the number of
> passed tests.
> 
> Hence, when vmx_pf_exception_test_fep is run, report_summary() does not
> return a "skip" error code because the total number of tests is larger
> than the number of skipped tests.
> 
> Skip early if FEP is not available, before any assertions, such that
> report_summary() finds exactly 1 skipped test and returns the
> appropriate error code.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  x86/vmx_tests.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 0b3cfe50c6142..4f214ebdbe1d9 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -10644,7 +10644,10 @@ static void vmx_pf_exception_test(void)
>  
>  static void vmx_pf_exception_forced_emulation_test(void)
>  {
> -	__vmx_pf_exception_test(NULL, NULL, vmx_pf_exception_forced_emulation_test_guest);
> +	if (is_fep_available)
> +		__vmx_pf_exception_test(NULL, NULL, vmx_pf_exception_forced_emulation_test_guest);
> +	else
> +		report_skip("Forced emulation prefix (FEP) not available\n");

To be consistent with other tests, and the kernel's general pattern of:

	if (<error>) {
		<react>
		return;
	}

	<do useful stuff>

I'll tweak this to

	if (!is_fep_available) {
		report_skip("Forced emulation prefix (FEP) not available\n");
		return;
	}

	__vmx_pf_exception_test(NULL, NULL, vmx_pf_exception_forced_emulation_test_guest);

when applying.

