Return-Path: <kvm+bounces-45007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 687ABAA5917
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 02:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A39D1BA2463
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 00:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C164419DF66;
	Thu,  1 May 2025 00:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ogtmtYqE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518831096F
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 00:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746059713; cv=none; b=GYFuHvm/ueFgbtOnZUnh0lt5VkvHSv8+OenrXHln4eK1DDTJj5AA2MCewp94TIW1UJZEypbbMBf/QFtSFRKbfBDZJhB3dJQRqgao39M3o9hRiQ4QAUjB/O4jQ1H/8I3D7sFqhOP1p5l3FJaw61xOEJJ86nghRB+R2fSQUGKgnKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746059713; c=relaxed/simple;
	bh=eW3y031a8bCMDfWfhst9H5EolfBgWcvOCZGufuzidSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CpHSBfUYKjECaG07V/kDkgQoljstKweehF3Lvun2mhfgCzicvMEKPgd6jVBZT7I1Lt36uV7KckFAjYVcRZXGSNC2q24XBBJxbP6vb2MH8k/zB6Qnl/2dJPfPtY66DvuE6P/QbbgEYi6D38mFwGGTad2GWaJXWp58jWIRk4qD720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ogtmtYqE; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-30ddad694c1so3826011fa.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 17:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746059709; x=1746664509; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eW3y031a8bCMDfWfhst9H5EolfBgWcvOCZGufuzidSM=;
        b=ogtmtYqEqm69D+n0d79A8gfAcVwCUugJVUsMsJo8dj3C444EHbS1yrgSKey9Au+6sr
         KJZL3HhgGIwG6/0tVEG9QUDCsXQpxyDVpY4cP0QOxe25U7Xh/FQipVRUBzbWNQtkoayH
         p/XKlnALcFBvDb0MFtrcvTOUNcPZ+c4Thy93DjnUbKyLvSs0RG07psf0kiH3Nl7TCDgm
         90+WTpKgLU8aMP/gszUmnsQdm0owq+SdEEBnQLPIjjCgKW1pDQYeyC5rarXjBf/QQZrw
         H2j0cgig7y6r7CtR2774KFmaVGPZSOUq6yCuZPiGdYos9P47ihIC+WFzasrO5UM512SZ
         x7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746059709; x=1746664509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eW3y031a8bCMDfWfhst9H5EolfBgWcvOCZGufuzidSM=;
        b=EuAa8wN/G1ORdvAiayyDKtfaorkvtJ7Em9hTjMQYb/oBOVDrdOoOtzgmdsugdbAvdu
         IrttA1dK29nJwS+YgRVlzO0IOp0HDJJTi1yOv3ci9k4LPaurDBO9vWF+b9+SYaLwYRZ+
         kJiVjrvJuo969WpmYEX46xk503dQ4pNjIqHw05QJt4hNPTHy1VHXAh8kCvBbKcbhS4Xw
         qPJZBqjtJndceLVJ4wyMaB9hw0i2Rwt7a8SWWomJ7NRt2dda4koE26P1nmcW+MXfKvTn
         hD+KxegSug7nAJSfBzgGS3FyRSc7S0OgEa3S0d0qPv11YpKpsHNbKJRVHtAvbjZAF1VY
         2zVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBt+Jf9djtrVk+V1FZROeX0KjMnfeQ55TUbVtl3nQCwRrSdQRwigyKOBoiNaZ/MAr+2Hk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcc1RyKyUlzH6tvIiv4MtMVyuyYCJKREJXiWFSyoErmCt9CtNc
	GihGgxjnJcyVlhmVijE54YID7xuiHZW+yKs/PlMeCOmwahqNrJS8dVjowNn6JDU/3lbxGute9Yq
	yXx9nrv+0hATktKBWnTal1kpdm88cAjeHUE2R
X-Gm-Gg: ASbGncvYIc8eaQ9MVPiEaQRLVgU2slxlgj3cCI8uBpC+TQDXVzK49gqQKHjycBe8Kxd
	BloavRjN+TfykGoY3Gp4Qr69JK+ma8vi+SnA0EpOiYq1hKTb8x3SUcqi//EAT4zhgh+RcYQIEDV
	6ZzsifTebwXpmGpRaxKmFlGw==
X-Google-Smtp-Source: AGHT+IHwYZFEr3gcu16mdyqVUV8yH6eQN4AFZYotMXTeFCa5T2asw+fZ7/8xnzcqUzcozqKfbUDo0SALzDbsQBurO+E=
X-Received: by 2002:a05:651c:b22:b0:30d:e104:9ad4 with SMTP id
 38308e7fff4ca-31fc40d31c0mr836551fa.41.1746059709173; Wed, 30 Apr 2025
 17:35:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430224720.1882145-1-dmatlack@google.com>
In-Reply-To: <20250430224720.1882145-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 30 Apr 2025 17:34:40 -0700
X-Gm-Features: ATxdqUFlsY-tCRXcGAt6vRsZIh9vEnM8vLXxYXsTvpXUC8BZ9_at6EiPaiKmPqk
Message-ID: <CALzav=dDcqoPa1wAdv53vyAx=HD+5bS15jUE8OV6GfKvRWeNpQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Use $(SRCARCH) instead of $(ARCH)
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Sean Christopherson <seanjc@google.com>, Muhammad Usama Anjum <usama.anjum@collabora.com>, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 3:47=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> Use $(SRCARCH) in Makefile.kvm instead of $(ARCH). The former may have
> been set on the command line and thus make will ignore the variable
> assignment to convert x86_64 to x86.

Blegh I meant to say "The latter ...".

