Return-Path: <kvm+bounces-52867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B45B09D00
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 09:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1BCB7B0172
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 07:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA9632951C8;
	Fri, 18 Jul 2025 07:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RPaYuF3h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDDC293B49
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752825167; cv=none; b=ccZZ1R5Zl7JhghTa/t2j9haOB+kMMl51V22EZMfyHPVHyZXVe45bmjFJuQmRfqAtxdXJn39AbR6DtDEpEPN1y06EwM6n90cUIRJ6vnh8ORNbk8bqLhtNIYNBIsNNXRmLDTfIlHv1JSg1i9x0o5jE4Vn103Q19bgKtSEIlTZflQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752825167; c=relaxed/simple;
	bh=2pi8KBcoIPlm4tOCt/inqjOUYuaGd1omaspVeZAZA8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MXB4oWON1hBfOECCnT+jTYMXO05BmIXNZ+zotC5WafnH/ulAySI5FquyXCSRfOZ2h9POuOE+5ejXfO1uqNhW4CAjhyEITGTSDtWqEFn+F35EwK4GSOSjHJDlG3U4KEdKRnohTLm8EXU2Oij0GBzd+U7ELvse+I9pvLjhMJ4CPl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RPaYuF3h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752825164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2pi8KBcoIPlm4tOCt/inqjOUYuaGd1omaspVeZAZA8w=;
	b=RPaYuF3h+bcigEPAjovnmbMBqzDoWJ41RVYOQG7XMf5kZXlQpRNIgdx11gDEqRwzJtplKQ
	tvb7Pg+mm/eBcDaRMipyoZT8AZbszu+/bfJQu8lPL+WX1yUYnz6FKqVgTxjNElI18ZpfQz
	2xBuUAGGi6u/YYcqSeYb4uFfcu4Wyx4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-xAwCqZ0xM56WjFOGVrQDWw-1; Fri, 18 Jul 2025 03:52:42 -0400
X-MC-Unique: xAwCqZ0xM56WjFOGVrQDWw-1
X-Mimecast-MFC-AGG-ID: xAwCqZ0xM56WjFOGVrQDWw_1752825161
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-234f1acc707so19032525ad.3
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 00:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752825161; x=1753429961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pi8KBcoIPlm4tOCt/inqjOUYuaGd1omaspVeZAZA8w=;
        b=MAyCv9e4RMkggtXEBnKDvpfh9CxR2oVMbNZ+XT6xn4YmLp2RzN094KIABUE1LWON9x
         2s6n3/aStdIteGq9PDagkiW9nmxji2adV/J8mEhVDnhni/qo8AwMUvqWnXYX4gKyK0ao
         N2noj9fvrJ1N9Qkk4bIu3booSK6+FWpI0AM9b9OWdwd57aHrhPzl7lkOmx2uZQWL8y44
         c1NxWmpqUfjEYh41cg+V81u9CuClHKl5Fpih+X/qIVY5Y+1WuBRNXL6y0L6VXqvbsTLR
         rUaLuGgMTYirxrB5ugIaMRv4c5Ew2nzVNG2lKfBuZgRGxguWtz1fR9q2z9pliBQJrRWZ
         CjhA==
X-Forwarded-Encrypted: i=1; AJvYcCUmMC4S0UNyO+GguxHQHcm8P6HzBF7ZcsgDWKK7FadjWvXUByJdiY6xJJ27FtycRQot084=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMZNJoRjqkISb6rF8sZxLqb+j5yv7BLWa+I/DpJtgkxSRri0YU
	JSETXdrwB4OszwOXkgIMS0Ef8E3X3Y8vWC24zFTlCYntHfLBW+2G4G/JO7To1Q6rxadzoeeZUHP
	rpywJKtVKTIqw9absA/bWwVQvkZ1kVdr0Uve5txiYQGuIJiKtALWNrTwpFDyMoOaI0Du1X9VG1S
	YwMzAXqr4dSLONxJyz9HZayxd4U5to
X-Gm-Gg: ASbGncsa4bFAKHfey1XgAbCDXBV30maBRwDcN1Z7jHQrMswAAlfBixSCpGOoON4VpEx
	pMV8UYfe4794JTsJG+B1fU6dM/0BBI2J8isvtYKsiKpAtulJuyxW3W+T8xtXheiLQzcpP7mzju5
	Np2fcPWJ0LeblFhEKNXAxNsQ==
X-Received: by 2002:a17:902:ec8b:b0:235:f3df:bc1f with SMTP id d9443c01a7336-23e257451fdmr133641845ad.36.1752825161540;
        Fri, 18 Jul 2025 00:52:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEczHEQLoKluvpGtGTxZAFG1Ct7SS0ET5wuggRJXsSha+pJGDGNiCavb0Lfm2+EHUkt6UvPo3yU43N4AaOjSqo=
X-Received: by 2002:a17:902:ec8b:b0:235:f3df:bc1f with SMTP id
 d9443c01a7336-23e257451fdmr133641485ad.36.1752825161093; Fri, 18 Jul 2025
 00:52:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250718062429.238723-1-lulu@redhat.com>
In-Reply-To: <20250718062429.238723-1-lulu@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 18 Jul 2025 15:52:30 +0800
X-Gm-Features: Ac12FXwBVT6a31yvU0qqbtQu-2z0AJwY7ghH6LYTEkWi9oJSf_Mb34yGWOF4UH0
Message-ID: <CACGkMEv0yHC7P1CLeB8A1VumWtTF4Bw4eY2_njnPMwT75-EJkg@mail.gmail.com>
Subject: Re: [PATCH v1] kvm: x86: implement PV send_IPI method
To: Cindy Lu <lulu@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, "Kirill A. Shutemov" <kas@kernel.org>, "Xin Li (Intel)" <xin@zytor.com>, 
	Rik van Riel <riel@surriel.com>, "Ahmed S. Darwish" <darwi@linutronix.de>, 
	"open list:KVM PARAVIRT (KVM/paravirt)" <kvm@vger.kernel.org>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2025 at 2:25=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> From: Jason Wang <jasowang@redhat.com>
>
> We used to have PV version of send_IPI_mask and
> send_IPI_mask_allbutself. This patch implements PV send_IPI method to
> reduce the number of vmexits.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Tested-by: Cindy Lu <lulu@redhat.com>

I think a question here is are we able to see performance improvement
in any kind of setup?

Thanks


