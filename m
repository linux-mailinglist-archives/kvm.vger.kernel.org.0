Return-Path: <kvm+bounces-19615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFEA6907C9A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 21:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59B59B2739B
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 19:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BF514D29B;
	Thu, 13 Jun 2024 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EQGF5ZXc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0DF2F50
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 19:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718306932; cv=none; b=Ujk2pt2+yu8BBUrdSFLLOm5dPJ7UFtlxZ3Mbvs1Qj89//k33Rr9tjq+ZpWBmg1RJP6UqrB50M3/tW4VgA+4zXdxMama6tvD5Yg4bWuUXiZCyr2FJbVixR8rNnbF6/1I39AOdWNOknjDLEfNYaGgmCbLrVN+xTytrIw8+ixJUw+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718306932; c=relaxed/simple;
	bh=6wKy9PT/NktJoBzOitFFb6HPMmfgKy7I4AZPdskERR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GnACfnGpy/PIJYGS94P1cqNE2pquVP6Ykju9nsbeHKxoyNCHlAboy7Hvrq95xZQwJBL8AI+aQdf0F7hqPaOWIwLM6FQJkEYI7qkeUN2VjXqvmD7oMQi9NlY0ARpRje2Npx2v3s/2TPu/fYejYFmAqFMIE6rw9jUgvyVs3rxwI/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EQGF5ZXc; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4216d9952d2so14575e9.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 12:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718306929; x=1718911729; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2T99o2a/TaV4fzv62WaEty4y6EzpA0YkXeldKL2GHA=;
        b=EQGF5ZXctcWXgHWYLmaP2c2xpSy7lqS3Tuks1SARxqT8WgRv4WyeDuZiSU+ujmsV+r
         lUM8NCmzWiwyt6bEcBao/CCpqh7+WJcwvC39ALNcBSgwYk3MRAMqwYpFINHQRdvmkt1R
         gqqwBsYiDsU3mv+NlUInPcYBZWQ3XK1WMsJIjPqYiTuU6+JiA+vD6DkuLXwMgQpCzTym
         7jexcNWYTrk/U/A9C4RDpKLx6B/oXYm2Q+80lWjYUOuWEXKmZL0dRB3Fl2hb++ZTNL2q
         65k60ZtjK6A8TNVDdeYwnKlHEdTuL1neKXbV9PO4edQBYSC0mEFubKb8eyHwFMoW16xr
         Nkeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718306929; x=1718911729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y2T99o2a/TaV4fzv62WaEty4y6EzpA0YkXeldKL2GHA=;
        b=Z1LnOGUTgrUc2d5T3AG4VsD0Iho/4QacUvc1cpH+Jii6+75NNavGm5sdQW4tym6k0Z
         C02Y/4cQP9MhTRojVj265emgOmWP5gRoYb4tpLNsPmUUdXD15/j9/sew2VysenJNiSkR
         dnFkYx/X3Cp7oWH4i4GoNWe/UDYQepGo2iagUAPFdr3juw1VDtFb9dxpCmx2H3cEpgql
         hMhbTiwAwtm4R6LYKtZn4QOSSZXAcnch5nYrjhvvN8ri5eqEKac6zOPXX0DiPhK6UulQ
         tY4N1+0dgWgMVSkO//T1ZVzcUvabKP43g2SjmPCRT8/ky2oeNFjo1OrSqXkyO0AyrfAw
         9O0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWTCsexI0y06WZrp3yOfEg8wUDGKYvdcver0l9GRY7n0cYCoO1ootnq7BkhJaxm6AbnDXGHWYCwkgZYJcGcmQpFMiz9
X-Gm-Message-State: AOJu0YwPvofLVGHobsYLNNWmLxW5k0Tioh4Xp1bQ4QtJg1msadihI/UM
	kq2wH+9USWVqG3j9mOhZu2zKII+ER0PXxbhPA7OSIo5bRX0cwaHRrM5A7AWiT/AoHIbj9G/9FbJ
	Zp8RsuRsEsOeZQl40pIrfskzNCdgi6YuqVPSp
X-Google-Smtp-Source: AGHT+IEIYrzwKHZSbxPq/DJPfJU8wVaUyVr9U0Sz7bmed6P61nysyTTs3KAlUwekbtF5X9I4FSfRYC3gJjq4daDcuRw=
X-Received: by 2002:a05:600c:3d07:b0:422:ffac:f8c0 with SMTP id
 5b1f17b1804b1-423053880abmr198785e9.7.1718306929423; Thu, 13 Jun 2024
 12:28:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240613190103.1054877-1-seanjc@google.com>
In-Reply-To: <20240613190103.1054877-1-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 13 Jun 2024 12:28:32 -0700
Message-ID: <CALMp9eSw65i8SpjPKxcu=g8dTRRR+eXLuj5rQNfeJjeTNNQJAw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Update VMCS12_REVISION comment to state it
 should never change
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2024 at 12:01=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Rewrite the comment above VMCS12_REVISION to unequivocally state that the
> ID must never change.  KVM_{G,S}ET_NESTED_STATE have been officially
> supported for some time now, i.e. changing VMCS12_REVISION would break
> userspace.
>
> Opportunistically add a blurb to the CHECK_OFFSET() comment to make it
> explicitly clear that new fields are allowed, i.e. that the restriction
> on the layout is all about backwards compatibility.
>
> No functional change intended.
>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

