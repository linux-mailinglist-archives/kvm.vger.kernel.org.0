Return-Path: <kvm+bounces-22978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 909A19452A2
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33BB51F24869
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F151487E2;
	Thu,  1 Aug 2024 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ibjTmkfO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0DC13C901
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722536141; cv=none; b=S2LxMYpbfidYkz+Asx1yFlzUq4LnhU5+nEBvnkpk8+WbQmatPSjeuZhgL/06W1pcA7liqvStedh1gJ3bNE7z1X8CcGJqJr8UJVxGe79culLjIzU//uAO9GzoqX17SU8jWqH3A0cCow03Lc4vTjeBn+fxe+vN6mafzo2oWKtEBKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722536141; c=relaxed/simple;
	bh=SUfyZKUo0IFCp9KDhlQwd3l6b/z5WFA0jaDZUeAQ/tg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIz/UxCLz+uDS7P2vt9UQ7Q9TIurs9UcMd8gwmsZ3ZZeV440byYdDlhTUTt+4lqXowUAUt8/yYdNPqvkosuEie07DAUw/WjWHcTaHb/MnuJHCbEJ2nWGB8H6JK4iOiCwvgjzHxapq86TzmBsz3MKOL8DgX50e4H17MLHaEpFH8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ibjTmkfO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722536137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UaZOROEvjpdbqu1dopLC2Lkrj6Dr9/VPZUA+DhTI8M4=;
	b=ibjTmkfO2XoxUoWWakcEr02B04XguFk2Mb3hZX6pbzVaf0XCRUHmbAFsJcVj/l+yXWjUsL
	Ef7DH43XN8rdynqLbSg474Xal7dBverwkSY5djAZfNTfU5oG8FofMqM9d0e7JOrCewjUdW
	QvigC+u/TODJl9DFfHnU9oB9p5evLYI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-C1Y6RfQJNZSZ820fa7dkIw-1; Thu, 01 Aug 2024 14:15:36 -0400
X-MC-Unique: C1Y6RfQJNZSZ820fa7dkIw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-52efd629749so9139470e87.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:15:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722536135; x=1723140935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UaZOROEvjpdbqu1dopLC2Lkrj6Dr9/VPZUA+DhTI8M4=;
        b=N2cM4GEHZlRT1/yPYG7wtfAkKewc89Ko0pZmyfECWkgQMFQEJvhcSaCsGM9duRkOig
         onkBgivrNVSJgr71GZAWqWM0uS5jGuF0RcoCOU944qYoG7YQyApzbRyig2apGX2E7M1A
         uWisgLb+FsvEJPWkItJLhZzb8pcipf4dPy9r+jp/fqyGj/UMLYKatkORkiIAD8FUoMzl
         tPGtcmrq2J8vBDdiE3tkfXcb3q8Xqzx2b0wncVpgEKnDYsY8J7ynk4zEDFQthqFC73SE
         1wyMeFfuMXulGYwG3qUUqcufnnUxD8FVeO+TmcQeS92gwQfwM09XmAV3IbvIgrSIR+cf
         h0YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx08xiZrEvR/Ph63pjn3ZnqklswIpPnEamiW4fqzPZqrz5iCztcTeUsNulD0Z+PNSZut/vMyIqFohJO8yagxXw9Gun
X-Gm-Message-State: AOJu0YzECR4vlaXRHOUL2BMF5Q/1cGry1LZhyLBnoIRuukoJG+H6c10t
	qWE1AReEqfXA8xFm3eA7hNf6nW4VcH0PIFeachRuGHSDFolG/rnoLSpbWB28upqozeqvdrVtBQI
	92S0HqBYvLoZC1DB/hZlg1dXXkHr8SAtns82iecFvfQQdXMqhsQU+ZQBHrVWEF61Iv8NRWUTAiG
	LvHiHw0kEbchWOCLpmEeiY5/Wp
X-Received: by 2002:a2e:874b:0:b0:2ef:29b7:18a7 with SMTP id 38308e7fff4ca-2f15ab0c224mr8027081fa.37.1722536134885;
        Thu, 01 Aug 2024 11:15:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW/QthBnS2n2JpnEiBTz7UDN3Rn0ZpSHt4zKv0qUnmJfmwCaik8m91bLxVWR1bJoJl2RmwJ89dnkiDtZdyq7c=
X-Received: by 2002:a2e:874b:0:b0:2ef:29b7:18a7 with SMTP id
 38308e7fff4ca-2f15ab0c224mr8026601fa.37.1722536134319; Thu, 01 Aug 2024
 11:15:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-3-michael.roth@amd.com> <20240801173955.1975034-1-ackerleytng@google.com>
In-Reply-To: <20240801173955.1975034-1-ackerleytng@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 1 Aug 2024 20:15:22 +0200
Message-ID: <CABgObfZbS7LsKM_w2ZSpb82oBAHF=pJfVJ+45k7=vVVWHK5Y6A@mail.gmail.com>
Subject: Re: [PATCH] Fixes: f32fb32820b1 ("KVM: x86: Add hook for determining
 max NPT mapping level")
To: Ackerley Tng <ackerleytng@google.com>
Cc: michael.roth@amd.com, ak@linux.intel.com, alpergun@google.com, 
	ardb@kernel.org, ashish.kalra@amd.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, dovmurik@linux.ibm.com, hpa@zytor.com, 
	jarkko@kernel.org, jmattson@google.com, vannapurve@google.com, 
	erdemaktas@google.com, jroedel@suse.de, kirill@shutemov.name, 
	kvm@vger.kernel.org, liam.merwick@oracle.com, linux-coco@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, 
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com, peterz@infradead.org, 
	pgonda@google.com, rientjes@google.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, seanjc@google.com, slp@redhat.com, 
	srinivas.pandruvada@linux.intel.com, tglx@linutronix.de, 
	thomas.lendacky@amd.com, tobin@ibm.com, tony.luck@intel.com, vbabka@suse.cz, 
	vkuznets@redhat.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 7:40=E2=80=AFPM Ackerley Tng <ackerleytng@google.com=
> wrote:
>
> The `if (req_max_level)` test was meant ignore req_max_level if
> PG_LEVEL_NONE was returned. Hence, this function should return
> max_level instead of the ignored req_max_level.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Change-Id: I403898aacc379ed98ba5caa41c9f1c52f277adc2

It's worth pointing out that this is only a latent issue for now,
since guest_memfd does not support large pages ( __kvm_gmem_get_pfn
always returns 0).

Queued with a small note in the commit message and fixed subject.

Thanks,

Paolo


> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 901be9e420a4..e6b73774645d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4335,7 +4335,7 @@ static u8 kvm_max_private_mapping_level(struct kvm =
*kvm, kvm_pfn_t pfn,
>         if (req_max_level)
>                 max_level =3D min(max_level, req_max_level);
>
> -       return req_max_level;
> +       return max_level;
>  }
>
>  static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> --
> 2.46.0.rc2.264.g509ed76dc8-goog
>


