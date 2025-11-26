Return-Path: <kvm+bounces-64627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93415C88C1F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:52:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DC413B6A22
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A1031DD86;
	Wed, 26 Nov 2025 08:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YwT9cL/k";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="odOo0H+c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A0031B823
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764147041; cv=none; b=O56lOd30i/698PHr5ebhbYjlMNvb1eKQw9DMcObi5/vkJj6zzUbBNRmqQoDMVh2Nj5juhWPgnpBpxtLmfxOEoBpqT7SdbBFXkwD3cpsTCEVCPamptvSmN/ueDsdMw0zu+og9CL5bm/u4QJQqpKw1XSjUgM0sU0Yp6J2spkoP2Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764147041; c=relaxed/simple;
	bh=+BAN7wmF78AWo5QjIEfjiK9EQYyey7GcbPoiRgfqrtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RVut491C9DdS8b58WoCIW09uCJxBs7pSmjxFKOJPeOMwt6HbUQ4KTSbI0fEn3y+fOsM7unDpl3SuoA9oCCfziiU9wH7jMuwPQhwXAi5Xx1x6bs+CoyiV9YmkmF9TIHDS5SbgNAsfUKlvS5/601gUgZ/dhAcmbrYZ2Wb99XN+v/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YwT9cL/k; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=odOo0H+c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764147036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hg1ji30+++dRQC59gvLKj+SGgHd9Y5796b9icRZDq74=;
	b=YwT9cL/kVrwxeZ1rIBjBFDsNLrrdvqy9daagyyYTYa5hBk3IsCYnqxK+lxDc3VIPYEibcN
	y7JMfiXkCTHhNcgo0HdC16rSY6A3a3eQOKkKF0LHteM4DlVWNc4Kr1VTB9daAr22GWQwxF
	rnAmpJL8kk2sCLbrg4LYeFW92FEJag4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-pEiXJNmpOrSi2larqbs91g-1; Wed, 26 Nov 2025 03:50:32 -0500
X-MC-Unique: pEiXJNmpOrSi2larqbs91g-1
X-Mimecast-MFC-AGG-ID: pEiXJNmpOrSi2larqbs91g_1764147031
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b2ffe9335so5133654f8f.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764147030; x=1764751830; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hg1ji30+++dRQC59gvLKj+SGgHd9Y5796b9icRZDq74=;
        b=odOo0H+clSk/FlriglAb8lhxeP1ODQObcEhW2XNwtm5ZST45i7LETLPzfDWGcycUMG
         P39nKQ9rI7NBiaDr959AZ8GnCycjSgFTMJWAH+252tTph1UYZZzuEqDJ0WQsZ/rCMYTd
         kz4E4hAoN4yY64JT7W3Ztfr4qLpSR9G7KFd880FOH3YUwrGKBjddAZSN2tiZI6wc+qrT
         Ht9Gfu8924cBpUQ840GiPBr5m+R9wsCxbMguNqHeOkD/aQ+Ux9Q2Aqn4yb3ov16Zh+DF
         zZbnqUrRqR9LrAy7wB2BIakkEM/31j+3kf0aMiVb/ZTxnegj8qPjdU4CDL9FLArqe61C
         +PQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764147030; x=1764751830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hg1ji30+++dRQC59gvLKj+SGgHd9Y5796b9icRZDq74=;
        b=VfTIC/S2ZcZMr5XfUYW1XmJd9DWgWje9p0MMCnBJDDhrEAJ5LYzJ2DYe2sdUihq/ug
         4rEe+JhV1B7sOF5nzUMAqSDI0lm8I+KblgQvibgbD+Vfquwq1S4adBa2KNnjyJNzQAKt
         3i+uB4MlsINI8Y/JyUj04gdhcaayXBB35Lej5eRb3B/Cu5Zsr2whh8X3yZHmVWKHiL8g
         POOvcRSW0HEODipw4WKlHyXHUTmBK2erLVa0yyQC7p1+a9BdtyEVfyvp93HEWC2Vtf+e
         kdDIcpjMzxizzoYhakYwzobxFMGBbcZzyeeLtycbWP2j+KAROoL4KURDlX+29KIHtuU/
         Ho8w==
X-Gm-Message-State: AOJu0YxCn1ELRdutVQJ15PLSVymC4FZJhuem28cdOgX0vMTqU9VZZ45k
	GcQLn4kAKynDCkFJjeVhlczvehhJmcy1SCjGAQa3tvXQYleg0fpyVbEjtmpXCdMl/X4JEffE7Ig
	d+DuE6LCB4EySbtF3hwW6SVC8GTRDleERIkSmmhLlrg/3FBrxagRKEVzzBfhrABvRuPx1W6X7bu
	0maNN1cky4uNkWAH2hfaYRS3ngxLMPFHBZkYuG
X-Gm-Gg: ASbGncvvT4KDS8lEN0bzbvsXQ0piPYvd41p4kiozHvZ9rapiE2KSTYQ1i/Y5jSirgk/
	Pba0QEjN6GSY84Pkbj+LSM9OXGCLc3n8B1F14JKBGpfTOIfky377xMpe0A1dXJJ/ES/xcIT00k+
	eUaG5zPsFAR5e/ZXLgi+MjzXIkU68Eo57zvx3RfiwIm4u8oJJ4e3z/B1asOKjpWxCwZjQ3jmlNM
	RnIv5Eg6RaHkKHgqz6EQ+skuWPgDhP/25a8QT+SF4f+VMFenCk2Pyg+BdYWKfSK0VGY4/Y=
X-Received: by 2002:a05:6000:230f:b0:42b:4223:e62a with SMTP id ffacd0b85a97d-42cc1cbe219mr18172775f8f.23.1764147029984;
        Wed, 26 Nov 2025 00:50:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFurxDQZ0CxLGo8M2DvIniPxDaqLSuBzBfxppy2uB9BWvsVQ7uAkgRVClf1tjLQeVdIe3w3EVD0L2d3vYbqULM=
X-Received: by 2002:a05:6000:230f:b0:42b:4223:e62a with SMTP id
 ffacd0b85a97d-42cc1cbe219mr18172751f8f.23.1764147029629; Wed, 26 Nov 2025
 00:50:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-5-seanjc@google.com>
In-Reply-To: <20251126014455.788131-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Nov 2025 09:50:18 +0100
X-Gm-Features: AWmQ_blNVSG4lF-RsTlepATswSEFwST7tJUdl5I_nbclew4YC0pjKbXWfn5IvqM
Message-ID: <CABgObfZynxYyvBmA5uP9+E5nqNEak8rjPt5SEuRzQtzLPoe6qw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.19
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> An optimization for enable_mmio_caching=3D0 and a minor cleanup.
>
> The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df567=
87:
>
>   Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.19
>
> for you to fetch changes up to 6422060aa9c7bb2039b23948db5d4e8194036657:
>
>   KVM: x86/mmu: Move the misplaced export of kvm_zap_gfn_range() (2025-11=
-04 09:51:06 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 MMU changes for 6.19:
>
>  - Skip the costly "zap all SPTEs" on an MMIO generation wrap if MMIO SPT=
E
>    caching is disabled, as there can't be any relevant SPTEs to zap.
>
>  - Relocate a misplace export.
>
> ----------------------------------------------------------------
> Dmytro Maluka (1):
>       KVM: x86/mmu: Skip MMIO SPTE invalidation if enable_mmio_caching=3D=
0
>
> Kai Huang (1):
>       KVM: x86/mmu: Move the misplaced export of kvm_zap_gfn_range()
>
>  arch/x86/kvm/mmu/mmu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>


