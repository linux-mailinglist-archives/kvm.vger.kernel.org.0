Return-Path: <kvm+bounces-37762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88132A2FE81
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 00:38:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A97916547E
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 23:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B9926136A;
	Mon, 10 Feb 2025 23:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="or3y8s6v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF32249F9
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 23:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739230691; cv=none; b=iOOJBBoNQdKlx9PATiDPvNuRvINNNX0k+0L197Mex85lrts2J/vMKk240QKZO0nI0wHtuQ386CXPIQWW5dxzOYBL9NO8DQAINBCZj6b7sw/yYr4IkO/fD9v/J1TNLPGZ4oTQPfQlShxtLPErz/Fxft/idAf1BU9ZqfaOttNQnJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739230691; c=relaxed/simple;
	bh=6rA2RJebmmS56yThpsX30MeO798pLkrpy6M2n5E4+eQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R1KC+ODlORklMv35hSktp/8IditH5oZj060l321TQXdpNveXPJEkMp44xWonoiNPe6b4lU3JwDus97rfb1hDResZfNyXjeaWQIRTlR0MjurERWP7Cw81BWL67B3j74C+tdTvGhvaOgECNhfs+hSKokeQfU2SRpDAmPaIhpw6LXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=or3y8s6v; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa3fd30d61so6121286a91.0
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 15:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739230689; x=1739835489; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=digYp0roly/qtxRaMpIxtGCqdozvlT+rV7YancidvG8=;
        b=or3y8s6vCkDQcrtV7HVxv+o5CW6CQi7dWWyqkciDj8jJTAyfMtuSixdNX2C+hY7eLk
         3+3A/9NU7q/x+0r6szBm/szHDIfNxyTyb0PndW5qH2MAMQC1xmHkawp47iWDrt6TNSbW
         YWMTX+05A1VntzbuBPlz6AL0wvNwGh2jqtSjPMrG2Yb9vpYf2rd5yD4SffwiSi1Cnroe
         +xlTNCROEQM3yqay4UnnZgw4SSfUi5wR5phhbGZ2Bqm6DXg1EO0/jgedNtK8PwXv7IjR
         pDypmQ9wpO+4PMqo1u2rAB7k5zI3CiwFjLJTHwZ8AJX8ylID/JEVVr0XtLtaeEjZjTAO
         IUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739230689; x=1739835489;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=digYp0roly/qtxRaMpIxtGCqdozvlT+rV7YancidvG8=;
        b=hYIb0/p9JJna6HjLNmvzA2m/LWc4wQshx6/UVGXX4d3ikZLuRjqRg6wq6uIiGUFyHW
         Wi3bhKr48Sr8ZbLaJKG6xpfOfBaois5RjZ4Q1utuIebZi+RO/sgWGca/ksVGv0uT8O0h
         gR9aBhwW+i8tq+eDWWKEeOIS8ksAICXeMlBWEIORk4A/OLFY/QZjChZIrR+j8wznTyoF
         YR8x64w0sP2JSKCg+USJtjSqQKjFLHt5lXnbr5Hot7NQtNJn6Lzd3bnLyqyMDDdMBpZB
         w9qARptnju/5rNrdu4zkHwS8MxlolPyZkeZI+uiIberoBwxWFtNj0vDzZvpiWdRmK9hW
         sGNA==
X-Gm-Message-State: AOJu0YxsY5gjOu+HcwDTqBrqn8z2NTyWXJvfGDAhJ2LWVvDR2aZH0lKx
	CVYNifd3yTk8AD/ccA4vza1ODw7L/e/1FvJb6SecDcuy8jAnl9wUqEKuAYI1HTlQqMppQt1BRSB
	RLA==
X-Google-Smtp-Source: AGHT+IEPbNu6OdGD0IOBQONhbzjscwi7LgXZpYrVU0rsWT1IOVB2kHvNiyG8Gpc2UjDyPi6R2Q/s0Wy+rGw=
X-Received: from pjyp8.prod.google.com ([2002:a17:90a:e708:b0:2f8:4024:b59a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5186:b0:2fa:b84:b320
 with SMTP id 98e67ed59e1d1-2fa9ee19296mr2112658a91.24.1739230689462; Mon, 10
 Feb 2025 15:38:09 -0800 (PST)
Date: Mon, 10 Feb 2025 15:38:07 -0800
In-Reply-To: <CABgObfYuSn225d+Voc=T9am8zUK63v+s3GamohPU2+k0KwERkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com> <CABgObfYuSn225d+Voc=T9am8zUK63v+s3GamohPU2+k0KwERkw@mail.gmail.com>
Message-ID: <Z6qN3wPXH4cbRzLP@google.com>
Subject: Re: [PATCH 0/5] KVM: selftests: Fix PMC checks in PMU counters test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025, Paolo Bonzini wrote:
> On Sat, Jan 18, 2025 at 12:42=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > Fix a flaw in the Intel PMU counters test where it asserts that an even=
t is
> > counting correctly without actually knowing what the event counts given=
 the
> > underlying hardware.
> >
> > The bug manifests as failures with the Top-Down Slots architectural eve=
nt
> > when running CPUs that doesn't actually support that arch event (pre-IC=
X).
> > The arch event encoding still counts _something_, just not Top-Down Slo=
ts
> > (I haven't bothered to look up what it was counting).  The passed by sh=
eer
> > dumb luck until an unrelated change caused the count of the unknown eve=
nt
> > to drop.
>=20
> Queued for 6.14-rc1, thanks.

Lies :-)

Neither this nor the main selftests pull request[*] landed in 6.14.  None o=
f this
is urgent, so if it's easier on your end I can carry them forward and send =
them
for 6.15.

[*] https://lore.kernel.org/all/20250117010718.2328467-5-seanjc@google.com

