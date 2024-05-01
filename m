Return-Path: <kvm+bounces-16389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD7058B9286
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79DFD282C2F
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 23:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F038516ABD8;
	Wed,  1 May 2024 23:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wT9WSWe7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30C1168B0B
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 23:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714607277; cv=none; b=hDk6gGtw/jYTP7j+cDWUPsg0TXfzCDDENQ3eJfZ3Lm3kIroa1YWfu2NXA0RtDoeX8jxm/tiZS1Ly5cn5xZA4ncRWWyLhea3TC8USr5dJ1Oh9+M2c/fQ//U6dPuoAaFrP71NHtduXdowt2qvyz/mR4hz5hMESuX9E7nkCHlNZC4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714607277; c=relaxed/simple;
	bh=zk7hguYQKFwSHRyp7R/vDvN5DFjovQ4oMdoyTqmcLWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IsCU6kSSSKJ0xrO8dFi+niBRrCOsIdudv2UD3fnWublzL0zar7o2tmu1WH3xART44haljO5k63zJeecXRa1m8ygAIKwqVCXhHleSPPlrKW2A005kKQoJB6G1VYT/VYBCc8we+U+NDb10fnkmZktcEzGGQXVoCqOiBmmG9UhmzDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wT9WSWe7; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61c9e36888bso36532537b3.2
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 16:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714607275; x=1715212075; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RoxPA6m+G5OUNgLu5u82aTZ89MVMLW7NEW4au0aEBfY=;
        b=wT9WSWe7/n5nqo9kGJ8f3NJbtTZNdstj2yux7bJS4wVCIWR9h+ePeU1LDtZiT3qxqh
         s26Dw3UymzpCp+Lhv+fObkcg4cPVvhbQnLR6JZl9/sxJ+Ki70nqe4oJ+4Vb3xrlP03nV
         JlBrOz4ec+q45rB/48lxy9Z4W/HO94ykDZYGQ83QTKvMdVssd1NpIVYOZXJ9SUpCs/3/
         lDWKHLZK3LmKZTYyj+PXlgw6uWdNfm9jyq+boqee6QsZinqSD3jk4yn+iJS6s1IAd/nc
         5f3bKssmbJ4CESxAhM0ZRP5PnZfnAMUL6yeZQymYpXF3xucOhQKjm9UylZ50uyzK/S11
         70SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714607275; x=1715212075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RoxPA6m+G5OUNgLu5u82aTZ89MVMLW7NEW4au0aEBfY=;
        b=J+4fybURpunI0y668LNUVdBkvNrXsEM+ufN331akKcdl+HGuiK0MD7jxxZImsqZoPz
         oq2zKF3vJNCsGQQwFeZSIUMSSjKsIJTEszEyfODMkt1kOl2oOeS+CoF2jJwYYOnMfbgA
         8x9mf509RPenE19ap0YyJVXhmDDJ+1UkghzVt5u5vd4nL/0E3ZMqODBhypwPHiJvLlyU
         5QXvmylEWdX8cdSnQRAlGkRhSX9i6sHYKBT7NsmFWSJvl0Tf2FECIX+yZJ4bvoQGNo8q
         a36+AtLJVqW7i/zy02/0MLdluhF4QnxBIz6yie64fccJg/LSMLhLs/tC9dNNwPv2qvlg
         NTUA==
X-Gm-Message-State: AOJu0YxMcjdY+qzts4sL4h7+GO7MKz75O1GoZWwIAI3tdvpVVBLr04p4
	B8wdmWna49wmKDPa4VebLiVyjLFckgLu8+wRXVPCQPWQAO6NdfIEkoeg+IjeDMPjOqxdFWAAfKI
	5Aw==
X-Google-Smtp-Source: AGHT+IE/lQuPOTvDxWjzkM/iusdROrnl0/N7wrOKUBofNs3qRmYLDyhVrHon2c6cmTGKid45nIAheN1qXvg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150a:b0:dd9:2a64:e98a with SMTP id
 q10-20020a056902150a00b00dd92a64e98amr425840ybu.9.1714607274831; Wed, 01 May
 2024 16:47:54 -0700 (PDT)
Date: Wed, 1 May 2024 16:47:53 -0700
In-Reply-To: <20240226213244.18441-10-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240226213244.18441-1-john.allen@amd.com> <20240226213244.18441-10-john.allen@amd.com>
Message-ID: <ZjLUqaDbRglCCnD7@google.com>
Subject: Re: [PATCH v2 9/9] KVM: SVM: Add CET features to supported_xss
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, weijiang.yang@intel.com, rick.p.edgecombe@intel.com, 
	thomas.lendacky@amd.com, bp@alien8.de, pbonzini@redhat.com, 
	mlevitsk@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, John Allen wrote:
> If the CPU supports CET, add CET XSAVES feature bits to the
> supported_xss mask.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1181f017c173..d97d82ebec4a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5177,6 +5177,10 @@ static __init void svm_set_cpu_caps(void)
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>  
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> +		kvm_caps.supported_xss |= XFEATURE_MASK_CET_USER |
> +					  XFEATURE_MASK_CET_KERNEL;

Based on Weijiang's series, I believe this is unnecessary.  Common x86 code will
both set supported_xss, and clear bits if their associated features are unsupported.

I also asked Weijiang to modify the "advertise to userspace" patch to explicitly
clear SHSTK and IBT in svm_set_cpu_caps()[*], so if the stars align as I think they
will, this patch should simply need to delete the

	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);

that will be added by the VMX series.

[*] https://lore.kernel.org/all/ZjLRnisdUgeYgg8i@google.com

