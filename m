Return-Path: <kvm+bounces-60210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11BD6BE4FE5
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:09:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 612C91A61B78
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DA922DFA4;
	Thu, 16 Oct 2025 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H+kSMksD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6446E226D0F
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760638119; cv=none; b=LodOL5nD1N5DUKtKZDEAuu8ZEd0IsMTfl4nOx9vSaIQaZHeyww67t2RjtQr6JLMpmInpKqOnuxrwChULtH0Ok5BjqdGzKv3Rf3gtlfwLcrJliNdWqF1T8V/TFUXkNearCAlI9vt7QCYJWpsJgDWzTaOcnWw3/fvUsf7KOzLG5OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760638119; c=relaxed/simple;
	bh=pvdI1tHJ0y9UyYUK8ggKpv8HiCk5nY9MZSyFsaBNsRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VvvtoNgO9b+bY1sBMVfllTzJnWlrXkqC7X/xbPiXdz0E3KomCno3ReWpnWpRvIUqlwz0KXbLV6kNvNDSwwaqgiUQn1fX9Xkq+Py7POS4829WyjmpED6kxxgBM4o1+ml7dxsAxeAAUDouVpLQbIHvsRUX+rQI7WL6SMc2sI1VOtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H+kSMksD; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-27ec3db6131so1625085ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 11:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760638117; x=1761242917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvdI1tHJ0y9UyYUK8ggKpv8HiCk5nY9MZSyFsaBNsRY=;
        b=H+kSMksDV6T3s5wcA+ctD5yFuJ3P2xIRjT8GofqOvekOwjggObbh1tjNFvvAbmbysQ
         drrQWQOeYsWB0QP4G84ElM5cb6IpCHTFsPZf/FmtyGFwboBVhk6K9LEYTYf36Aia+qfF
         KdfmUmlUy5HzI6alFFTkRL6+iz+SVYmWneHDGIHsoHj4q3dMgLHejT0a0RJC9kM7jGNk
         zDuqSWLOkMmQWmRUXD4XyjnmttRUw8/nua74fIdgS3dxmlDQinTMRFJIyOP7l0kRsVhv
         LjL9A/5NAVT42ncBZ1EPKGNt/BBQjy7xaOk89rA+x6V2AQRelOg+10GWOfGJAjniS6JM
         i4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760638117; x=1761242917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvdI1tHJ0y9UyYUK8ggKpv8HiCk5nY9MZSyFsaBNsRY=;
        b=SumOdcnj4XIKpIF7RNZ901poxSs2vGkObcSLrpAEsJsyztgXQwp2orLZmg7jAxAbCd
         qggz/kG5GtTxDSLlHhXR5djs1N8oGAjMjS7ODy5+jE+cGC7/su6ouR3RYAnz8BF8cBF8
         PnKgNLqu0K2OYXsjdZJVLhwre5kNehHQD7a34wyXzGNudiagz30p2SxyDuqvjpcLR+se
         rPj+CZjpA8l7CFOtMJgdKEQDeg4e0+B8QEBRy8+vVB/UiLkiCk5LEhlTEP1Yf5XyisAq
         UoS4x4p3iAHU+1MWh94Cnbpyn1wYmw8NG1sprxRuGLfNETXgzGyRMm2o+7hFOJuCWb+r
         gogQ==
X-Forwarded-Encrypted: i=1; AJvYcCWI6FjlP0PS4nBEM3hiMSwfRfiPFDEoceCYtuxqmmha9I+L5BdZVQ6E3Idp/i82AHJAfAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxVtrtrrG0kDT0iZJt0X7BcdXHjfBaN1qvXY7m68aKPsEdyted
	ZH//MgF7iwIbZRd2/UyrnHZZPbGI+gr44W4vbtUFkwUtF5HkHx8zhqSL//NArjjRTF0hmKaCDDN
	6TfD4qA/ErTKvAqO3dXEePvsOUqrTukE=
X-Gm-Gg: ASbGncvqM5LU2Gj0rEcpoLQPlUAGVVCpZ3UR5NuPDsrHdMq7AJBNs+BqN2Udc33eXTf
	M71jusvhu4ZMgDK1v+wPJAMuI5t9GS25d17usrXI05DGa8R2g3hVK373FcLavniEUpAwBUiz/N9
	xr0djYfxSQ2d9HYHDH68VcxorVc4nbWhYtSIOb2gTZnJ9uHaocQ7ZXJFiARQ2PXAuzx9z5tI9T8
	N3MzXXHSMEBMy2Ipu+tff4nHFBfh9bjmTF4KAhZf/5T6nDzg/IZ3XMOrx2VEwUCelxijZ37YLL9
	uM+oC4nefVcoG/zdIg67L52P/4JKql1lpzT/7ITXqEMsfZsVWNPG86JD9WEca3DRYdhWZoM1Cwz
	2tmjpDhXr/52a6A==
X-Google-Smtp-Source: AGHT+IEoB07YLtvOmgRhJpNg1dneDk3OqPXrwHl8ZjlPvoUL+f8vvKYxA5NW6SB6Z+zvhdKoNNyC5a3rT2Kl6EmYok0=
X-Received: by 2002:a17:902:e743:b0:264:cda8:7fd3 with SMTP id
 d9443c01a7336-290cb27ec63mr5305925ad.6.1760638117403; Thu, 16 Oct 2025
 11:08:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 16 Oct 2025 20:08:25 +0200
X-Gm-Features: AS18NWA8avJ7AT3gN1GiIIdaHzAYbZXDs9-XkxbnI3nrmWWVp79jjOsrQv3WW6I
Message-ID: <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
To: Sean Christopherson <seanjc@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 7:30=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Miguel, you got pulled in due to a one-line change to add a new iterator
> macros in .clang-format.

Thanks!

The macro is not in `include/`, right? That means that, currently,
when I rerun the command to update the list it will go away.

If that is correct, and you want to have it in the list, then we
should add e.g. `virt/` there or similar, or we could have a few
separate lines at the top that are independent of the ones generated
by the command.

Cheers,
Miguel

