Return-Path: <kvm+bounces-54207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8378CB1CF2B
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 00:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52254562EE9
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A56523507F;
	Wed,  6 Aug 2025 22:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vljKhkOF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583491DED4A
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 22:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754520458; cv=none; b=QamKqq0yVv/IaEDgI1u05WklA/6hI6BzMVUvJKWf/x8IgmPlVAmrxocbwpEtQF70y+u2aqowKXK7yaBFf9CS0OixgS2noX4FSv0AsD2OYskb9zbQT2cRnusEkxI7lyuqap+/9vNUKjlG7iokIT6t1sxSa5GOi8scNrfYk3xpHnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754520458; c=relaxed/simple;
	bh=AQSRozzfLJWej5BeMHOzT/S5S6HIv/rXKAySkyRLD1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iXQSC33pAHvFtJok9L+7UqWDynONajFF3gevosod0UU1PVzlQVaQwLOlTC/XgEsMGZrD8jwBE+7972TAKm5QJtDml+DiLJd9lz2j3yQ+l99izbe6YXvxrFmmQI4A9JADg2rI49DP+vOa6QNZW1B+6SIFO4p6natEFup+Uqz9tKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vljKhkOF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3211b736a11so805382a91.0
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 15:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754520457; x=1755125257; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YHuoViYMSI0OwpL/rmjNIjufy/Pt0O/UUqyfzafEkIk=;
        b=vljKhkOFP0+Dnn6a/wAKqRTRW5x7jDhcMpasNhkWGbPQ8odOuI2eHHPGcWRtofpndv
         gy4jRZYZ880WHMc9lf+PoYYHuD5fdeF/iKev7G551ojiSwZFpeF43IYzq8lOLYVOfcO8
         cIG1eyhYktRfOrud2j4fK0aqg3/U+4/NRKUaO+4JZQZvxklEOTtE+JjpkYZWyS0pP5FO
         HmrE0IVVG5pLGG8UYISTBuV0knVRW0NFUS4vxOA1cRYn4BjnIhouEHLHrBfzs9Y00H3C
         7xDJkqruWF1WSlpCVQvfNL7vV4s5/ZwW+5vJ2JyLtp20GYWvPimNcBfFsWuLfOxHEzOd
         sJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754520457; x=1755125257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YHuoViYMSI0OwpL/rmjNIjufy/Pt0O/UUqyfzafEkIk=;
        b=vK50qHCsGPTZqg2bfYpksd31w33n+9n+tSi7x1jfNE/M8da07+PvElZ0NHEpV2TVjY
         +V65U17V4pvgpP/nylCp5tDU4/8ywVha+xUn/bblqgIFSwan0a50EmiU97iazG9F4wv3
         e4L4+JCQkTtq7zgj0GtnAz0jZLIP5wo5d5snsb7qyrrUvf9OnUlWDYI3DpcOAqUElUbJ
         8AzcdsRnydhli/PPcvVCBZs0zbwKuiLEMbal1q8A/HvSKo7w34Y9efSnT0Ykq2Okytds
         p/JFjnysFFR7AX9lL5xE7+m3zWTibo5c6E+AJN/qKcjQY1lOyuFGep11W9AsaA6e5iu8
         llbw==
X-Forwarded-Encrypted: i=1; AJvYcCWuIryXuFY2lU6Vzifjy5b6Cp1DSFCHt2xXO3RwQ9MPrZxdV5IoREMljQVlHnR6D/456eQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOcfDm9emGHlJC2CZqrLhxsg+v57nGJLY6AKkkCiw7zlaYRBir
	jj4IMpGN+fvnUsXBXwCOImieyGFNUfxmfz+UioLmXN3B+E7Ttg+HUB1kc3mOW03BZqj/X2DbVaG
	hy3figg==
X-Google-Smtp-Source: AGHT+IGfo0LH0u9LLu+2LfR4YNdq8y3iK3kQ7GzClkjVpHjdIOTwgrMX1KG0BkHCERAjRISf43ptQ7wrFiI=
X-Received: from pjov3.prod.google.com ([2002:a17:90a:9603:b0:31c:2fe4:33b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d2d0:b0:321:6e1a:1b71
 with SMTP id 98e67ed59e1d1-3216e1a254fmr4076071a91.29.1754520456741; Wed, 06
 Aug 2025 15:47:36 -0700 (PDT)
Date: Wed, 6 Aug 2025 15:47:35 -0700
In-Reply-To: <aJPB8Jd5AFKdIua3@AUSJOHALLEN.amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250704085027.182163-1-chao.gao@intel.com> <20250704085027.182163-20-chao.gao@intel.com>
 <aJPB8Jd5AFKdIua3@AUSJOHALLEN.amd.com>
Message-ID: <aJPbh_2VZWXbqYcs@google.com>
Subject: Re: [PATCH v11 19/23] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, pbonzini@redhat.com, dave.hansen@intel.com, 
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com, weijiang.yang@intel.com, 
	minipli@grsecurity.net, xin@zytor.com, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 06, 2025, John Allen wrote:
> On Fri, Jul 04, 2025 at 01:49:50AM -0700, Chao Gao wrote:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 803574920e41..6375695ce285 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5223,6 +5223,10 @@ static __init void svm_set_cpu_caps(void)
> >  	kvm_caps.supported_perf_cap = 0;
> >  	kvm_caps.supported_xss = 0;
> >  
> > +	/* KVM doesn't yet support CET virtualization for SVM. */
> > +	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> > +	kvm_cpu_cap_clear(X86_FEATURE_IBT);
> > +
> 
> Since AMD isn't supporting IBT, 

Isn't supporting IBT, yet.  :-)

I totally believe that AMD doesn't have any plans to support IBT, but unless
IBT virtualization would Just Work (would it?), we should leave this in, because
being paranoid is basically free. 

> not sure if it makes sense to clear IBT here since it doesn't look like we're
> clearing other features that we don't support in hardware. For compatibility,
> my series just removes both lines here, but the IBT clearing is probably not
> needed in this series.

