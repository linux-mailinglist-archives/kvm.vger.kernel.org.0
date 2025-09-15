Return-Path: <kvm+bounces-57617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E58B585AE
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 22:05:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29CA13AB897
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 20:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01AB285CBC;
	Mon, 15 Sep 2025 20:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZDfquvbU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7271F3D56
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 20:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757966699; cv=none; b=bRrD5+z5c8wR2qJWIjQTULjmmP6g9nJME3HQLIFmo1RHBlE8IfXZ3utaKL2XocCikrrl6nsD5PBW7zJ/uTV5IxbmDrnjg//nWsq3qHrvbAJufcE5kXM7Oaoa4hDEE2QpXvX9+llzE01T8Pdd++AR3fEBN4laaHKIj0Koi+wnnBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757966699; c=relaxed/simple;
	bh=cxprLMyeiYsYZYFhwOsc81Wj2lgtfio7iO5nBM3TpAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Elq3QZ9+sp2/fF7aX766ugD27gCpwYT6J3F+w/1Kd5GBgguxlvrKLlS5jcS85fa0ZiR4vc5S6lbs/CEdTipuPsdK06jpLL6lxwilAmUSDXOJQAjKSd9/JS9g43rejCBQuXmXUgAwh120v7uymf1xs0403u553OQsUe8+bDmTvv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZDfquvbU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244582bc5e4so55406415ad.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 13:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757966698; x=1758571498; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PWxlF/glqD1PuEILI4g+VJGULYpEgKXJq0w7ElXZiVs=;
        b=ZDfquvbUitzO4E3M6L1wy4TRUxjp14/Kn+rwNxT0JLjPZxV21/4e65M3mYJgzHvmzE
         wT4we4n43yWp58FyiSUsTyJD5TqC1Q63RlvUrQ/LV7UbdK5Ks2uocEqpTS6Jnmj996k5
         ceXLQru5ChAnyNbxp9/MEsIilXklNmVDWXXHftSjM9MTbg9By4Z241JdVExSgL729tLK
         t2N0LkOKEjou52mfxJJKsZtacuIHTuXTL9tBxuRDgTeukDukibmbNBgmVfzOz0YmSwZ3
         JpNdFiUTHpA69EdeN+sKmai4Z32zpm5ZSl2v//ZDOlidKoM82VzIOIZBpGKhi0wtMS+w
         CT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757966698; x=1758571498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PWxlF/glqD1PuEILI4g+VJGULYpEgKXJq0w7ElXZiVs=;
        b=TFk4Pq6rRZrSRSS7Dzmdyox1mdv5tSKe47V8NJAkMuccRyAhwlseVjjapTJ1N2Qk2g
         c/+TtZu31Kbl+KTWsWQ6kviM1GK7NUPLtaD9o1EGBWqS2kQdL5qobdfU4HKx0p5J6krN
         T1aJe+mwemXWUi8zEaki6rC4HDM+n6sQHOt55CAxGL0vFSj+c4er+j09wsufgNbTHStf
         BiYIPWvyVmF3LKmGdnF19VXtoGcQlM+3ViFOX7uwIaIvzIlIBFkwdMc08yb2ECCYxkC/
         rO47V6XzW83F0alJqbjdvJU6rxKWRJmEiOurkwgy3BhkWtjU3wQC4rxKn4ks1Ui1SLWF
         yzdg==
X-Forwarded-Encrypted: i=1; AJvYcCUADF9H4BV1CNCxQDb9Ay1DjwvS6FFrEdfVLrjLfwU6uil6Rp2y0xMSxuFy13uqMScfAAk=@vger.kernel.org
X-Gm-Message-State: AOJu0YysRoExaJUpG2p4TklnIVCwuYItRDdEJQnKDeIqERHDUElrl7kd
	nWmYbWXjv0ITtkbCH/POXs72zWE9BItBgMIWFk4ST85+ybtpo2+GLYtOr0Nxfo5FzjRoT34yhII
	7Lrevpw==
X-Google-Smtp-Source: AGHT+IFfbA5oWzYDc2B1zY4OiwhxLSitTeiVQqc6S8Wr9/dcBpgJGIqh8IJTIPOYOCme1CRKCtr0SKBNct0=
X-Received: from pjbqo13.prod.google.com ([2002:a17:90b:3dcd:b0:32e:8ba7:b496])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4405:b0:267:b1d6:9605
 with SMTP id d9443c01a7336-267b1d6a44emr24950755ad.10.1757966697765; Mon, 15
 Sep 2025 13:04:57 -0700 (PDT)
Date: Mon, 15 Sep 2025 13:04:56 -0700
In-Reply-To: <62c338a17fe5127215efbfd8f7c5322b7b49a294.1756993734.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org> <62c338a17fe5127215efbfd8f7c5322b7b49a294.1756993734.git.naveen@kernel.org>
Message-ID: <aMhxaAh6a3Eps_NJ@google.com>
Subject: Re: [RFC PATCH v2 1/5] KVM: SVM: Stop warning if x2AVIC feature bit
 alone is enabled
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
> A platform can choose to disable AVIC by turning off the AVIC CPUID
> feature bit, while keeping x2AVIC CPUID feature bit enabled to indicate
> AVIC support for the x2APIC MSR interface. Since this is a valid
> configuration, stop printing a warning.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  arch/x86/kvm/svm/avic.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a34c5c3b164e..346cd23a43a9 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1101,14 +1101,8 @@ bool avic_hardware_setup(void)
>  	if (!npt_enabled)
>  		return false;
>  
> -	/* AVIC is a prerequisite for x2AVIC. */
> -	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
> -		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
> -			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
> -			pr_warn(FW_BUG "Try enable AVIC using force_avic option");

I agree with the existing code, KVM should treat this as a firmware bug, where
"firmware" could also be the host VMM.  AIUI, x2AVIC can't actualy work without
AVIC support, so enumerating x2AVIC without AVIC is pointless and unexpected.

> -		}
> +	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic)
>  		return false;
> -	}
>  
>  	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
>  	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
> -- 
> 2.50.1
> 

