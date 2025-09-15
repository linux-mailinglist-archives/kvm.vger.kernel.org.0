Return-Path: <kvm+bounces-57616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 592C6B585A8
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 135C93A4325
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B732874EA;
	Mon, 15 Sep 2025 19:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ex1p2K4H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4EF1E9B1C
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 19:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757966383; cv=none; b=H2FnWy3TLrVtokDcLS2qrBGJhqkr/AzOjjcV/Bwa5Rz4CuYX+Oe04VkGyUy2LcCvnoC4YDifOU0tJT0ubgxS8ek0JIhgFS+fyAw1/Qr9RzRTruX8jVS9oeMFHyxFqdcwduClGgsGurIbs7/wjlwkPG9OMe6mPb4Teap6LAKdXeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757966383; c=relaxed/simple;
	bh=TwEjtrkYLFvkJ7xB60thdV7Pvcy58zg1Y+Tnxn4xxm0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rLneuDWThVZtK/96QUof3AvYdq96IlADShOcjFf7tQ5WX8cMfhnpw938Zzd/bRmjwDfcvTlXCrxXynFWwkX+qpC8q804FjWFdsl2jqCwOVRLjOmC+V1Pa6xvlkPe+IpF6OZVWBfL9u99lmde6+tt9wvghjPmDjvEZFq1bi74tv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ex1p2K4H; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2675d9ad876so14602725ad.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 12:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757966382; x=1758571182; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=snJLcy8LDYOL3DOWrAlxceQ+Sxh1E7IKuFPFIMhsvUU=;
        b=Ex1p2K4H9V1Ly+NrqoV6eaz9YnlAE6yiQ3nZ9edJ+k8Ov9Hm9pjis0zRGzn1wC/C/o
         CBYu/I06S0cWY8doB3HonTixuNc4Pm+ERCNo9UrHRWrtf/2C7Oo6qFVkyxsghVHmuhpU
         5V61JxnAucWg4nu5FODl9DU2FZaj5A3WGNkATWPxwwqbGQjr3F43Q0GlGSgbMTC5T7a4
         q25aQN2ZuBkKZVWxLGlsUX/67VNFx7aGJc1IJ7tCKePavJJq3ingc1EkLWz+62tDTtbd
         jI+4hwMDe8a9JQRlaeRGNL42+COUvZm8ZEfDaALMRHXlcX+Fgu6bsbu+11eUALQWBJau
         hCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757966382; x=1758571182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=snJLcy8LDYOL3DOWrAlxceQ+Sxh1E7IKuFPFIMhsvUU=;
        b=BU56Hi62BxYdaiM8RF5ZxwTAHXGV7RJkbqg3IUypMZwxRzoyqLhscoQVoiXuKFAII1
         fgQyG0neHgUIprRsZIzlev4uQmg5CiQ6IhIpL1rdaK+5Turu4DgOTYgsWmIcsvfB47lf
         2PmdiD8Kd8FU3XQIgIm73pQUo/nWa87YK4dc17uK0+EU4+zVNcbBaPQYDcWbqE7j8gWg
         nBJ/ogG7kxks22vaMGHp3QdQa1ZgLX9rrYgA99Rkh5tPGX2sV9kfq8bCCINyqSZ+QJH6
         t2GAbFzK/D6SIUD1ePcymymeT8rCrwiSUsgXvTU2pjO4c3/hyDe3IBbV5HeQe7fu2N4P
         cSBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXnb9sy0+jo8xmBYVLQmmMwoAtCygJidiHzx0ctcFdsq+fWD0INLFDpdxN4dYcaAHeDvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrkBcsAvHjeEySOJLyDr0tpB7msO2K69AMEokQxFUwi3zZyZ5r
	8aYqiCokAn00b3eCjy+c9+W8lCAcC5OiQdpM3aDfBNXnfO09B3g8N5oWaez+LpKb5OoTwU4EQnB
	tzmwCRw==
X-Google-Smtp-Source: AGHT+IFO1UlVm0v6LLk9j9pmLODl0QfWf0J1aVSdH5Gxe2iugeHtAJoWNAIRD/T4T1I07FI2vHYj80AKJXw=
X-Received: from pjuw14.prod.google.com ([2002:a17:90a:d60e:b0:32b:95bb:dbc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1aa3:b0:246:2b29:71c7
 with SMTP id d9443c01a7336-25d2607a10amr162771615ad.25.1757966381932; Mon, 15
 Sep 2025 12:59:41 -0700 (PDT)
Date: Mon, 15 Sep 2025 12:59:40 -0700
In-Reply-To: <aa7c82543158f6ac27c7aff8feaf6c7830236894.1756993734.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org> <aa7c82543158f6ac27c7aff8feaf6c7830236894.1756993734.git.naveen@kernel.org>
Message-ID: <aMhwLGxyEipwu-SE@google.com>
Subject: Re: [RFC PATCH v2 3/5] KVM: SVM: Move all AVIC setup to avic_hardware_setup()
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cb4f81be0024..d5854e0bc799 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -162,7 +162,7 @@ module_param(tsc_scaling, int, 0444);
>   * enable / disable AVIC.  Because the defaults differ for APICv
>   * support between VMX and SVM we cannot use module_param_named.
>   */
> -static bool avic;
> +bool avic;

I'm all for consolidating module params and globals, but they should be grouped
by "area", i.e. the AVIC variables/params should grouped be in avic.c, not in svm.c.

>  module_param(avic, bool, 0444);
>  module_param(enable_ipiv, bool, 0444);
>  
> @@ -5406,7 +5406,7 @@ static __init int svm_hardware_setup(void)
>  			goto err;
>  	}
>  
> -	enable_apicv = avic = avic && avic_hardware_setup();
> +	avic_hardware_setup();


I would prefer to keep a mix of the old and new: move "avic" into avic.c, but
have avic_hardware_setup() return true/false and use it to set enable_apicv.

enable_apicv is tied to kvm.ko, and so I find it helpful to have it be set by
svm_hardware_setup(), e.g. so that when reading code in common x86, it's easier
to find where/when/how a global variable is configured by vendor code.  More
importantly, I don't want to create a hidden dependency between avic_hardware_setup()
setting enable_apicv and this code reading enable_apicv.

Alternatively, we could have avic_hardware_setup() clear the svm_x86_ops hooks,
but I wouldn't want to do that without having avic_hardware_setup() also _set_
the hooks, and I think doing that would be a big net negative since it would
make it harder to see the vcpu_(un)blocking = avic_vcpu_(un)blocking connection
for the soon-to-be-common case of AVIC being enabled.

