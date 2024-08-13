Return-Path: <kvm+bounces-23932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C30C94FC8E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 06:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EF3B1C22379
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 04:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246A91CD02;
	Tue, 13 Aug 2024 04:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pttmDIC3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1284A1B815
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 04:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723522123; cv=none; b=glpCDB5l3to+u/QYrdpw4qYDMhN+iLrW5gphrCzC2S7eexSoUMxwQMG0xr7g2UBoyWvCn//SI4CINh8VU/UQYxmeuzCNAbMMyP/21RkM71P9lGCuiGi28XxWg+tdjYs8BCJaTs+xflqaKAFvWVuq9eLVnMvXANVpkEsE5d+vRtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723522123; c=relaxed/simple;
	bh=fntJhyjcOy7oflqhtRO9KzJcdMa1SeI7MODbm3MN5k8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eE+AZ0v+qCiQ/QQE5VC9xynM1TFuKhvt8kcz5rourEOFZYCC8UUTcswt4fdatYsye6reNUJ5YYx69Bpz/JPTg8yl74lgO6sXKYh2VlmgjT7LHpVyGAe7h0glHOP0gtAc4iwHhAKa1xDa8BnnxIQFozxYZAi0aMjqrnfkQ9L3obE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pttmDIC3; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a134fd9261so4398139a12.3
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 21:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723522121; x=1724126921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SHWstkZJouFpjxURopjUp/N24tS1IjVlq4SVfgNsTjg=;
        b=pttmDIC3mo2QvDY0rB/HLf9xG8H5+2h+oxtP6JF3ueCkClU6ipnmFiGJeRgp0Fr/fP
         O08xiI9cALKHYN41+5BpUkYRtc5zfqGUTZddwWnzg0lOvdwqShPDQNPwyI7aOZSiWMct
         kfcVxEqDk2C83YJ3kr3jAuibwGaYdzi++0YfhuZcGV9kX23UwoHdpYoyQCdbvWs3rFQ3
         xESPpvKpmZUe7rSgLiOh/ttK9TwXkCZnhfgCgPFfvHkB3+YrBLl6Q8YxUMdDxG5308mG
         OZkTouYL3WQibvAiG7WvLAtXtYSBGbfiYk/BCRUhIh81e1qha42K/zV62q+MFdYf9XUC
         AlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723522121; x=1724126921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SHWstkZJouFpjxURopjUp/N24tS1IjVlq4SVfgNsTjg=;
        b=trCojWXtUknbzmjMDQfZhiyhWe1JvBg/57TcRFZDG2gShvuA15Lswcnwxo95EtHRKO
         Mybiq1A0ODy6bxEafGZ01gBSROeRsw9eVaYSiFCC+EE/rpGG+dQ6yXIkiQhT9dcdKKIC
         3qtUNDGnBIxgRgk+ebi4BXyfLVsCR0TeXOqzbgoUiHssFiBVrqynazFRUSDKwZs137TS
         VlMonRw0BsUrSrdEVpa+nOtnUFgH7edndbd/hcYIPSUgaFLE2/XUZLTDXk/x0vBslHJu
         l8D0QKoONa4OdbFqWsDLIV2zbhxRrkAo9kT2BXOlqXy+kMhICgFdiJbtBtYuzVtNE9OG
         UqLA==
X-Forwarded-Encrypted: i=1; AJvYcCV43dE7OmnKjaEw9ewgInTc0u/RGVcdHtJ2XiiR/BB+TovScS95iXm8ujcUpSvaV0inHbRlO+qgZwhAGM/d+fJiQBQZ
X-Gm-Message-State: AOJu0Yy9uU4J0QeRFfQunNMgHEh5Eqj09GFu0sNCQ/vYIovOzW4zsAF0
	S51fzElDaycq6amDN1jTWLZzbAJLinuplEJGoJOGbo4tnxWL7etDHJ8LZZoQpATHMKPKP9MaJVe
	+QQ==
X-Google-Smtp-Source: AGHT+IFy3tS0mDbLSJ3VFDM24v3F0/Bto9CsIFpJ5YeCwKlmxhaKPoZAnTM6U8EqvRJ7bCMM985q93CMz9Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:db46:0:b0:6e3:e0bc:a332 with SMTP id
 41be03b00d2f7-7c69507d656mr4242a12.2.1723522121034; Mon, 12 Aug 2024 21:08:41
 -0700 (PDT)
Date: Mon, 12 Aug 2024 21:08:39 -0700
In-Reply-To: <20240612115040.2423290-3-dan.carpenter@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240612115040.2423290-2-dan.carpenter@linaro.org> <20240612115040.2423290-3-dan.carpenter@linaro.org>
Message-ID: <ZrrcR-kJ8hP6afWb@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix uninitialized variable bug
From: Sean Christopherson <seanjc@google.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: error27@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 12, 2024, Dan Carpenter wrote:
> If snp_lookup_rmpentry() fails then "assigned" is printed in the error
> message but it was never initialized.  Initialize it to false.
> 
> Fixes: dee5a47cc7a4 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> The compiler is generally already zeroing stack variables so this doesn't cost
> anything.
> 
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 43a450fb01fd..70d8d213d401 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2199,7 +2199,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  
>  	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
>  		struct sev_data_snp_launch_update fw_args = {0};
> -		bool assigned;
> +		bool assigned = false;

I would rather delete all the printks, or if people really like the printks, at
least provide some helpers to dedup the code.  E.g. sev_gmem_prepare() has more
or less the exact same behavior, but doesn't have the same flaw.

>  		int level;
>  
>  		if (!kvm_mem_is_private(kvm, gfn)) {
> -- 
> 2.43.0
> 

