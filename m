Return-Path: <kvm+bounces-46939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AB03ABAF1E
	for <lists+kvm@lfdr.de>; Sun, 18 May 2025 11:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 654EE174986
	for <lists+kvm@lfdr.de>; Sun, 18 May 2025 09:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73114212D97;
	Sun, 18 May 2025 09:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6qqYV/7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20AC200130;
	Sun, 18 May 2025 09:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747561933; cv=none; b=sa2R9XP9ZVSd/OojxRNFnIbneS8vMPwax2kljF/WzB+7xf9LtVfevaQu8/oqT1adwcUBMOcGZPL1sgr+dUVEMJc0aoGIRHKbYnqmfYLFp0VclXfixDM8YjHMvH8LqbciGh5mB//wuml710m4HYQD9CYUd0jIpT8CE1LqkPGHWdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747561933; c=relaxed/simple;
	bh=SIzTm86F8HZ603Stt2xCx6gDTtju9Z6+Usy+NBetbtE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=Ec6gcxPk2GhQ1WdCyNcr4EC+RNziTHYMUdOdsTJwWICAV/9LnQO7+MTQxXh6yvh1cuzX/Nt9zLWhG4EqmWjb7B0Tdhi46FfseVzuwrZ54qKggsnwkLpFr8j7x0odwq/sE5u/RZVR0xaxWgJhqo0ZaUh+J3CGsffS1TWMGIOrrYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6qqYV/7; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-acae7e7587dso519186966b.2;
        Sun, 18 May 2025 02:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747561930; x=1748166730; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xNezKkV3ebczK8qcbRyMSzCKTpQqOqkTvCZZ/qTf9JQ=;
        b=B6qqYV/7b7/XdOFV1DSvxOeAh2k++dSIcaJpItyRvA339gkjliWlV2SYOz8Yx3MVLm
         N1E98E7itcu/KGRrqBjra/KYSCMmrtujZtHW7IZjAKURQFDSMTwkfNkXjtJKqI13GhFX
         XgJty3QSJaxglmA9UuRoZXwCobfoqTNyfHf5PoiRttj7xlB+wgxaap3eV2ouYNwXvzXD
         lLtw/3btmW494wamMPOmqXEKsrrtQXyO56RpmuxfwHCD5G9Rgx5hn5jQKm15ahjBGcHE
         tcOCpITwLzTvK9bCrxo77f68D8EQHQ1Cs/UL+hByX3rDkyX1yQBxv2TnCxYhr3vZqD2m
         anvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747561930; x=1748166730;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xNezKkV3ebczK8qcbRyMSzCKTpQqOqkTvCZZ/qTf9JQ=;
        b=wl82imt/AnPVNL6YhFAaYDZUOkB97EQwmRiC8nlzsD32K8WzJwLLx9oON2n0MrZmUi
         3YjA2k7p5KaNqtMJIIzBnjPaK1X7qFf0oc1DzndaQZ9JDE2aUq2uozro7JJiuOsko51m
         RrQUQE9HkcdaKnthcLXMSPohamTUQ/MYuP8izShB2nAa221OYOEDVuw47OUoDEQSgpfb
         BoPnLZWWaT7GHhQYFF+oMYOOD7nUseOTHXCI5s730T5Sr7g1HXLhxKCrlWizl5k7WtOV
         rTM9frYn2SnFtkP1nS01MH6wDQS1gUs5OeiQgGwge+HR0c0AzRqOpGBky7fxSCoGkkdE
         NDVA==
X-Forwarded-Encrypted: i=1; AJvYcCUd41dfEfCe+ylegTGsvUXpibUrUidrjk+vtyMlzkVjn1ICLgWNu8YsLc46sD+LfuQsiKce3tRf1HtscnH+@vger.kernel.org, AJvYcCWJ7dTIjbKOHQAvkHZCH1Ke8annQjyZPihA/3e0smEsF8TNGzOcJbcq/ertD5y81/dQ2ZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyebM8yJddyyG7nFNbSh653fj8Os+DPIZ4ZnzxpHSCiPAeTolEl
	AwrSAToLyzhaNUI3cRRy5agsAQI0764lMSheJjXVD85llH86itbK5eB4
X-Gm-Gg: ASbGncuA1zNMzdFtGc06n9IbTNsQ07ydvU1ByCRTtKfIYWlPnqVhlC9t9TWoYH02GJC
	SJ/JgyoxSFjGLdVqs62W/NSa2yRnF1sUmdxYNLT/TlgXw57BM7Dsecpo7wIAydASXZxA8rHLEs3
	2WXzWBj2abNYgBHCXs0fkD+ZCnCeRrlZ3iaoFPP6E7l0afw09sty0hDoapJLB0YmJ35PCa7u9tm
	w7Spt9iUPXb5pO1+Xzy11RZYEhh9edw0IzBV5AjimR2rkxPh9Vx1nshLn9adzfty5FtUSYLevk7
	fYn9HBIn69KPIXfDZftwYsB0GQScaoPFJqJzb6jewRAzHOThA8lE7y5l7Jx06mPeoTEjI2kNX1z
	FzzZKmWYPiqZ6lnuyEjVJG50nHGqHrpAZixsXTPFV
X-Google-Smtp-Source: AGHT+IHP1DmeZ8foZI3IYMKP3rpqfL/YaSVCgJnkLE879K6isE5Bxfz4HkwU1M93ur6uQywgpsPD9Q==
X-Received: by 2002:a17:907:7b9e:b0:ad5:c06:8d6e with SMTP id a640c23a62f3a-ad52d609a9dmr838369566b.56.1747561929754;
        Sun, 18 May 2025 02:52:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:3e7a:15ee:51c1:139? ([2001:b07:5d29:f42d:3e7a:15ee:51c1:139])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6004d50364dsm4040958a12.32.2025.05.18.02.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 May 2025 02:52:09 -0700 (PDT)
Message-ID: <4fde4c953a4204e70d89f2c3dfd24eccdac0540f.camel@gmail.com>
Subject: Re: [PATCH v2 5/8] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: seanjc@google.com
Cc: airlied@gmail.com, bp@alien8.de, dave.hansen@linux.intel.com, 
 dri-devel@lists.freedesktop.org, kai.huang@intel.com,
 kevinloughlin@google.com,  kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,  maarten.lankhorst@linux.intel.com,
 mingo@redhat.com, mizhang@google.com,  mripard@kernel.org,
 pbonzini@redhat.com, simona@ffwll.ch, szy0127@sjtu.edu.cn, 
 tglx@linutronix.de, thomas.lendacky@amd.com, tzimmermann@suse.de,
 x86@kernel.org
Date: Sun, 18 May 2025 11:52:07 +0200
In-Reply-To: <20250516212833.2544737-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2025-05-16 at 21:28, Sean Christopherson wrote:
> @@ -3901,7 +3908,7 @@ void sev_snp_init_protected_guest_state(struct
> kvm_vcpu *vcpu)
> =C2=A0	 * From this point forward, the VMSA will always be a guest-
> mapped page
> =C2=A0	 * rather than the initial one allocated by KVM in svm-
> >sev_es.vmsa. In
> =C2=A0	 * theory, svm->sev_es.vmsa could be free'd and cleaned up here,
> but
> -	 * that involves cleanups like wbinvd_on_all_cpus() which would
> ideally
> +	 * that involves cleanups like flushing caches, which would
> ideally be
> =C2=A0	 * be handled during teardown rather than guest boot.  Deferring
> that

Duplicate "be"

