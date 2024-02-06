Return-Path: <kvm+bounces-8073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A95284ACF4
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 04:36:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CC371C21E2B
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 03:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128B974E0A;
	Tue,  6 Feb 2024 03:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IWEb051f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2862C74E07
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 03:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707190520; cv=none; b=hYmwEyReHlijKM+RIaUqXP8rMsP+BhLxb+Eixjp65oVH53JeS05ZdDIfRbWW5xlpfnyW2dun3Jh8JqpECOdEAJWPKDtRyXLqGJ/OxEQ1iQnOkW7MraWj10mWE2A5mvr8abBDZPIzGcrqMjoiECByHt175fOV0f1lTponw+i/Thc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707190520; c=relaxed/simple;
	bh=+LEUIXV0lFwpLO3k4xpDM5EQvBUvVsuMxEq6CEOiPXM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZHmwcX/h8HoMfbuw2SqTEAXg9ib4vb+jDgpOBpCaT4+v3UTJrfV3qfs8ea1w9xQn2P3oHNdgSkmEnTFHxGI1BqhDBDbDmRn/wpjzMi73gZVpBEBbi3henas32WebFYCgNw0fGtN0E6p53kGISTCMhc8tMngJVRXfCUT5xurzwy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IWEb051f; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5ee22efe5eeso79970037b3.3
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 19:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707190517; x=1707795317; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lpqFA9NyY5bI4wueUVg/+/e+POejKlZHsq+ipwNoeKU=;
        b=IWEb051fCoZIZ7yWJuiu8ErVhzo8IGKhJUYfwypALdFXCvZp8pSok90mFRSknZeWLl
         TgHHTwXwKA5VvB3b9YKLk9nppp5X5RU9mQcpjiwkuos+mRjD7i/i6JPiL5LukpMh6p9S
         DW9TsxJTv0dMSFwRKypHtYUfzQ9biLn4NDMOOr9Syf2oi6l/1kHOUEN881z0lvYIZ5Y7
         DZD2oULtyvm4lwhqbwZsbSkQ3fIC9KHsfQRrplmNCzPRiF1Cog6KufJyb2e3toQD63CW
         8Tuu9JTN+zzMNjNwPYcGcJiG6F7V2YJh2AuyK7o5HN6+yLSU/xjEUXd11pg7VEXChivq
         3lvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707190517; x=1707795317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lpqFA9NyY5bI4wueUVg/+/e+POejKlZHsq+ipwNoeKU=;
        b=mU0vfsMdbQkkG0zif8dfiyt8ObqFPtPipOZuVc5sKyGtroM+azhoNBfq+e79LhBM7h
         XhtAc3k/sSBL0cQk5qMs5ib7lRiPuQSvVBpYcO3dX9GNtB5b50qG5k1sRrD33ZZIYuA4
         WP/LPybtZ1ToOKFQjvzW3Lw5FxgLIgaw8xBwwU9SYAvMfA9P/EOWdjgwphwBWfmQPUiv
         qMPAtehFBsZLNo+IsRw5eMDytR6U8VmWKYT4/3hM+LWdX7sJGV6AosITT7skSZb7xYIt
         +WagfOHN5R506U8wP0JOTpGXvjiGZZGC38+lWyVHfrTdYJ5+G+0LGtE/dNW3g47C5VwK
         /n7w==
X-Gm-Message-State: AOJu0YyinpYdeP1fd1ZfDJMtGiqkCR6VvqbfK4jhA7Kzfd7nAmVZ+J2I
	g2wzC/1+7JQEv3soIME/iNFsvQCvL8evyw/50ubCppmBG9/FNohKB0+94l81fRu+Ypfm8fhT05w
	sdg==
X-Google-Smtp-Source: AGHT+IFr2uxVl+q3AGojz+bZO6tfUszLovI2zdfqgieC5phJzxpTgflfE6Ekefg9f+gIKeMLk97J6P57cPY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:118f:b0:dc6:c623:ce6f with SMTP id
 m15-20020a056902118f00b00dc6c623ce6fmr16494ybu.13.1707190516967; Mon, 05 Feb
 2024 19:35:16 -0800 (PST)
Date: Mon, 5 Feb 2024 19:35:15 -0800
In-Reply-To: <ZcGbjstPnwVpR3Jw@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203003518.387220-1-seanjc@google.com> <ZcAoZ/uZqJHFNfLC@yzhao56-desk.sh.intel.com>
 <ZcEolLQYSlLEVslN@google.com> <ZcGbjstPnwVpR3Jw@yzhao56-desk.sh.intel.com>
Message-ID: <ZcGo8yr5oYV6Cf2K@google.com>
Subject: Re: [PATCH v3] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 06, 2024, Yan Zhao wrote:
> > Just to be super claer, by "repeated faulting", you mean repeated faulting in the
> > primary MMU, correct?
> >
> Yes. Faulting in the primary MMU.
> (Please ignore my typo in return type above :))
> 
> BTW, will you also send the optmization in v1 as below?

No, mainly because I'm not entirely confident that it's safe/correct to loop
there, at least not that "tightly".  At the very least, there would need to be
resched checks, and then probably signal checks, etc.

I'm not opposed to something of this nature if it provides a measurable benefit
to the guest, but it's firmly an "on top" sort of change.

> iff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1e340098d034..c7617991e290 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5725,11 +5725,13 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>         }
>  
>         if (r == RET_PF_INVALID) {
> -               r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
> -                                         lower_32_bits(error_code), false,
> -                                         &emulation_type);
> -               if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
> -                       return -EIO;
> +               do {
> +                       r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
> +                                                 lower_32_bits(error_code),
> +                                                 false, &emulation_type);
> +                       if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
> +                               return -EIO;
> +               while (r == RET_PF_RETRY);
>         }
>  
>         if (r < 0)

