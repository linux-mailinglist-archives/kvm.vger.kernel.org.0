Return-Path: <kvm+bounces-20408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F6B915140
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 17:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4EDF1F21264
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 15:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D6D19B3DB;
	Mon, 24 Jun 2024 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E6Vfwtm8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D5E1DFD1
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719241336; cv=none; b=Bn55U9m1N5Por8Vh5hzv+agnETPJqMSSffZcIgOwBsuGJOIrblC7o20m3IcUmQnpQYg6Gga3Wb0yTv1BMxn0WZ8lHSGkRAAES4BUIajywA3Ps39977vjwCkxy/dMqdx7d7Zv/RcfuVrHJkN/BYYRROXLfu7Il6r34x2eeYi9lkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719241336; c=relaxed/simple;
	bh=RWPDDMkBBJI5GXg8+0PX2He/GP0QafCNoivJOEpVWro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XkElwpAtOY4+Kh3HnfphnOUfl22plDqbOm6ikL+f7W8DH6cy6WZQiXtB8DvqMn/IZwniCpxE5fxzckh3EU0Ah8vs2jYiPPg41PvhYOqUVCBF/ifBpuYpf//11OqDWPfxs9zf7FI+l+Q/ONp2qMHcOkEtHrUoywJv82tW0Ngm8m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E6Vfwtm8; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02b58759c2so8764530276.3
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 08:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719241334; x=1719846134; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4T/qiCTXUS9baKPXu/a0D1pfkxykAQu3gzK12/3rIc=;
        b=E6Vfwtm87ehpFyIXo+fkOHYO7v3tsnKiXc38gWep7jaywN66pWAHUgbd1gWIg4hzvd
         lQ5U5xYCdJInfvye7ABFsdKCYPnAKYPXYg4K7WHvD5GevKLRHFw2QD/nVbZNGWyZyDtH
         lDTEG7a0ZuMCIWq2pf8j3iZrFPRG6/WNJwH7tHbztWdlejbrZQT4f4hCocxtMEtDNvoA
         1efk/YQOgjsBQKJGt9uJKkcmzOX/OYuaUJF27RoqEj9yG5UFr7TBuO06bsW6trnJxUxg
         p7jdu4e3dGmMUx5sy8FLyMuSTmXTPewMtKifcH6uJOEI42AyVPTz+TOCiDeZG/Z1l2Jr
         84JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719241334; x=1719846134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4T/qiCTXUS9baKPXu/a0D1pfkxykAQu3gzK12/3rIc=;
        b=UIv8Ha9QvsN74trgKcuoNiWYpCiH7giN8hPfYppnJi6GDzkLEL7bNj5yM2s458MmBR
         c1wqLtojuDEfCp/DtIaMr0J54/Z2nY6eNTXXHOQJXW2kxSKEIweT5blUjGFvbTP28IAf
         jmS7Twk/cRXHKUcVqcrTQfn+D0vLgVhfr+Z2zaZPLnqy9rfajApd7Rv9fG+4vChp4xhI
         Sq7ULZDDsSD9V+H6nWiCLLqGRvDRxDf0fEeJP/IvyjInpmedZyj3D9Jku8dj1YTkx11w
         Bt0C9WCsLjzI2KgmIzZpQz7TeXBOUXic4wEPVqCPY+Cv9Dph1GPd7lmqJEoWBjY2jCbi
         jQ0A==
X-Forwarded-Encrypted: i=1; AJvYcCWSklrcBeUvtiAkp/bDMVu4+pgq463zRFVXiAhuKE8IwxjVL1/b6fA5uxHFtI2v4zunrACMztEUwtmmPXXhiQRgQ2yW
X-Gm-Message-State: AOJu0YxRflsPxKJ3QvNCLpaw7W6cXDGY89c8Alu7Z4B5gd8GQSnoRuQA
	QwQEQr6Xsv0Vu1IaH/yy9Mu3xm1nC+Ukb9BCvSEg3fWzEHNGymXcj+k5+QlsUqTVEWktnI15RLe
	2yw==
X-Google-Smtp-Source: AGHT+IHVuhaaP+AqJkLOnP2nm2zoMNpTnmJWMLB94vD9m0Y86WTHHHaebaE0uZUg+d3sb7uwTDEgx3Svrng=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102a:b0:df4:d6ca:fed0 with SMTP id
 3f1490d57ef6-e0303f28704mr13386276.4.1719241334515; Mon, 24 Jun 2024 08:02:14
 -0700 (PDT)
Date: Mon, 24 Jun 2024 08:02:13 -0700
In-Reply-To: <545135fe-adbb-bf95-5b60-0646a76afaef@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-4-michael.roth@amd.com> <daee6ab7-7c1e-45e3-81a5-ea989cc1b099@gmail.com>
 <545135fe-adbb-bf95-5b60-0646a76afaef@amd.com>
Message-ID: <ZnmHeGU29F-iFeNl@google.com>
Subject: Re: [PATCH v1 3/5] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST
 NAE event
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>, Michael Roth <michael.roth@amd.com>, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	x86@kernel.org, pbonzini@redhat.com, jroedel@suse.de, pgonda@google.com, 
	ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com, 
	liam.merwick@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 24, 2024, Tom Lendacky wrote:
> On 6/22/24 15:28, Carlos Bilbao wrote:
> >> +/*
> >> + * As per GHCB spec (see "SNP Extended Guest Request"), the certificate table
> >> + * is terminated by 24-bytes of zeroes.
> >> + */
> >> +static const u8 empty_certs_table[24];
> > 
> > 
> > Should this be:
> > staticconstu8 empty_certs_table[24] = { 0};
> 
> Statics are always initialized to zero, so not necessary.

Heh, the whole thing is unnecessary.

	/*
  	 * As per GHCB spec (see "SNP Extended Guest Request"), the certificate
	 * table is terminated by 24 bytes of zeroes.
	 */
	if (data_npages && kvm_clear_guest(kvm, data_gpa, 24))
		goto abort_request;

