Return-Path: <kvm+bounces-45594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D89CEAAC6D7
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 15:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D17D1C0081F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 13:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25716280A4C;
	Tue,  6 May 2025 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I5R7RpsL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0B91E3DF4
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746539212; cv=none; b=sGe5xxTK9bUeIibxHcn7VJ8uvQyD19mgnRSF1y430U+AzK1gqiDO2rQKAM877doJZhyjNDnvKWr4RnzUMIF9ldIilxhxuXw2xHgwsvAVfKGi6EeL+KUaG8XISysySvLSfjEcGKITST/GJ1LPGZFKoBkaMQ/jl8P6HoiQ0CeME1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746539212; c=relaxed/simple;
	bh=ZLyUWVGxg9mrrO7r5vzX+fzEqwROgV3Odq3dd0jP07g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lS/TD1c6UR1HKoeTTy+uXCJWTd++YjDV1gWU40eZZWP29yBYN570q8f/R55zIHDdpSd4w9NTPV5eCGWFwZxNT9ynljDCDMw51A/VUJoiGUrEN0PGBhXvEuaRgYxQLz8ceBKupjNGLMqHSiyxQ8eYF6BktLk5/L3vmRb3Q3YzV34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I5R7RpsL; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2241e7e3addso50699335ad.1
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 06:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746539210; x=1747144010; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LQUJg1xdsag4lcsUrEd4LaUAGtstgHq/VhuMBGkni7o=;
        b=I5R7RpsLsgCyODVY7TJDKwLtrD6KpoDhmKsxc0q/3HVpcUqT9MQjueUFAvjE9lA8ks
         oMiMe08x2Uw0YXa41wtx76eTlaIhBplhAlrpbQ0ig/lEp4teXHvqjlkSDkg1IKo8qDHQ
         4x/JM12SyAAku1FBNvGowuyxXgjsiLjsoJPgaeXDqw6/2zKnH2lIyvfkeGbKMu2lm8ST
         87NXeMXhPf2ObDnDchdTAl8BxU1x+dNYNhnL6zbHXVwfs+hJGfBgblykgnYu7wbijZj4
         D9nCGBeL5zUyXgIdDH291ILIrLhnfb1gmrshTG+z/xNMQWrrcWjHCtwmERDbY9I4+g6a
         OqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746539210; x=1747144010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQUJg1xdsag4lcsUrEd4LaUAGtstgHq/VhuMBGkni7o=;
        b=LaPeDpC4hdGR/9zh8rvE82H/g6alWbpoGacQz9+DXm7dFYK9g6I3+pxi5QBFg+KQRG
         /eZycPRzGg9hUTHwcPFSMrUpRj5o567mIYQwXkb8/XrW++lWsSqgLQZr+QMeK1HWyzaK
         YQ8+Qcqbbjbqw4ZRnNsmYqfLbS+iQJl+01kWtSgJDdi07OuNRDMD6clnoZ9znVNTV9rG
         QrH9lzI6VpGRsNU8ieDVPOjRurwJ4TLYG5+GckkEDmbpzNXu6hbaA8BSUo2IiAox0HOA
         otYCTw56QY7ovixhXX/ZSavYEg3jUocP6RSJEp9U1miMIfL/EHMW1j/eYQs1XO3WaHwz
         pcEw==
X-Forwarded-Encrypted: i=1; AJvYcCVbJSyYMopprNaH75b2OwqonRcE9XcKYlXnXA5g5UwnOOOdj2/n0OpG/VKOsu4l/jGcvlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKMYvRgyW7lPqTNlOMGEo/PQdp7bdq3wXGpeAg9TAMN31cCSjw
	wGLe1ilGS7wjMkAOpEEqo9gCqbxQ2O7BZML8NN1icJbTeLDC1rwolfSp6VNils7yd0tmEPhYH3D
	ekw==
X-Google-Smtp-Source: AGHT+IHsYV+dxxS1ThICcQGbnerUzrCgNQIzKxNK/VWU507udswWRGzpamo7g53Ivg5sJVmAE8gcPACNnXg=
X-Received: from pljs14.prod.google.com ([2002:a17:903:3bae:b0:223:225b:3d83])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:240d:b0:223:66bb:8995
 with SMTP id d9443c01a7336-22e102f3417mr229950135ad.20.1746539210171; Tue, 06
 May 2025 06:46:50 -0700 (PDT)
Date: Tue, 6 May 2025 06:46:47 -0700
In-Reply-To: <09ee8a01-9938-4ae7-bdbc-4754b7314e73@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250305230000.231025-1-prsampat@amd.com> <174622216534.881262.8086472919667553138.b4-ty@google.com>
 <b1cc7366-bd30-46ee-ac6e-35c2b08ffdb5@amd.com> <aBlGp8i_zzGgKeIl@google.com> <09ee8a01-9938-4ae7-bdbc-4754b7314e73@amd.com>
Message-ID: <aBoSx-rAmajPZq07@google.com>
Subject: Re: [PATCH v8 00/10] Basic SEV-SNP Selftests
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, shuah@kernel.org, pgonda@google.com, 
	ashish.kalra@amd.com, nikunj@amd.com, pankaj.gupta@amd.com, 
	michael.roth@amd.com, sraithal@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, Pratik R. Sampat wrote:
> On 5/5/2025 6:15 PM, Sean Christopherson wrote:
> > On Mon, May 05, 2025, Pratik R. Sampat wrote:
> > Argh, now I remember the issue.  But _sev_platform_init_locked() returns '0' if
> > psp_init_on_probe is true, and I don't see how deferring __sev_snp_init_locked()
> > will magically make it succeed the second time around.
> > 
> > So shouldn't the KVM code be this?
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index e0f446922a6e..dd04f979357d 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3038,6 +3038,14 @@ void __init sev_hardware_setup(void)
> >         sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
> >  
> >  out:
> > +       if (sev_enabled) {
> > +               init_args.probe = true;
> > +               if (sev_platform_init(&init_args))
> > +                       sev_supported = sev_es_supported = sev_snp_supported = false;
> > +               else
> > +                       sev_snp_supported &= sev_is_snp_initialized();
> > +       }
> > +
> >         if (boot_cpu_has(X86_FEATURE_SEV))
> >                 pr_info("SEV %s (ASIDs %u - %u)\n",
> >                         sev_supported ? min_sev_asid <= max_sev_asid ? "enabled" :
> > @@ -3067,12 +3075,6 @@ void __init sev_hardware_setup(void)
> >  
> >         if (!sev_enabled)
> >                 return;
> > -
> > -       /*
> > -        * Do both SNP and SEV initialization at KVM module load.
> > -        */
> > -       init_args.probe = true;
> > -       sev_platform_init(&init_args);
> >  }
> >  
> >  void sev_hardware_unsetup(void)
> > --
> > 
> 
> I agree with this approach. One thing maybe to consider further is to also call
> into SEV_platform_status() to check for init so that SEV/SEV-ES is not
> penalized and disabled for SNP's failures. Another approach could be to break
> up the SEV and SNP init setup so that we can spare a couple of platform calls
> in the process?

Nah, SNP initialization failure should be a rare occurence, I don't want to make
the "normal" flow more complex just to handle something that should never happen
in practice.

