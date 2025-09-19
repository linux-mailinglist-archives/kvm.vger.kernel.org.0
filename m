Return-Path: <kvm+bounces-58161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61865B8A8C0
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E03C1CC21A6
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2455321279;
	Fri, 19 Sep 2025 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1aS3p2K7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358D0261B95
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 16:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298938; cv=none; b=Ox/cMdvwRSdHPG/nq3GoopjxCxBJl8jYgN1JChiOwPT0ERoU60Q4PMf/s1DOwh7S/DLK7Jj5wL/DTLttBcTZhjr/+kUs8Xbes3hKF11DRMooymWLgvb2sVu9SZyb7rNUHWHWZtj0PNb1Ig4UG2ABh+1tE90pL+LB5+hkiQWAkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298938; c=relaxed/simple;
	bh=SR5J7VhzCc3FdwtjoGH5nZbj/8qB/RWMHAcPVUSZcAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hx/eF5itBHRNxfajE7skvJVq9hCx5nB/6tqLMdLaqYngyCbcaa9v1YaoXFFp0AxJYkuvpOkl5NQ2+oE7EgXMUG2jUsNhMrJEaJkRM0cb1Z/lkrkxn77dbv0AVPmPrYiiDpiCqfHR81lG2M2PYjRst396MZKk56NrnFdx/PUYf6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1aS3p2K7; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62fa84c6916so16658a12.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 09:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758298935; x=1758903735; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9l6sqe5LvkU2B8zsnh6dYkNJqPSUF1OCEWK4jmvgrA=;
        b=1aS3p2K7BLy4KvWLbudhmLZlSPoiSBYh9oPrvfEX35hrnXzAB8HDkkCVvuSIy4Z9KH
         dJ723jgcZen00OZo7NRgWK2paYsp3iHobvvyw+MnpE0NnyBu608JFpUT/KV7nnFKL4b9
         fXNqvm0G2/lo5WR6OSuzMTU0RYwoF0w3YpVmsHRxCBIiEaccJpLcfLeisqKKfncWSfH3
         yD4x2ZW5dSDP65pxQ2iO5htYpFXgoQpGk4i0IAO/Ttco2+lH7VcWoRo1QJmR7/nN4ocJ
         TDDEKhqyXHeKxx7lzI7bk5IowZGKXwxvceei4HPY1P5RUwsi3sVk+8A5tPW4UZxsPDYD
         MA0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758298935; x=1758903735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9l6sqe5LvkU2B8zsnh6dYkNJqPSUF1OCEWK4jmvgrA=;
        b=DRjKeBNiRyRq1LG/Wx0FEh7r0cn0gO7ERk82S5nQ1aLrr37eu7gF11zOldmf4kn0wx
         ZXnkX7IDLs6raXRd/Q6Z57xAR4Cu/NlFxwT5Yd4ko3QdQJmUKTsrRmR6LdGfa2zb2BrB
         bTmTtBalIMqykHcL4rKt9YvW90mAhml2/Wf1wV+/CdBICGuu2mqMxfw19veIHDYo71fl
         wYUHJAVTqCMF88GmlaVkS/3XTCU+EaDLieDLltm5S5+mC8nKe9w1g7ZV+KkXQzNCFyKg
         XDANaXxDLm+eqTk2FaDQJedhfM87cz5dIt6x5mwPHgxVoSFK/d+H+hZQ0voNpqVDYrUt
         4rpw==
X-Forwarded-Encrypted: i=1; AJvYcCXlaLxYjwyOZ0GVyS4rqUM8Kkwpuup9/2FW0BESzPejbyhdnQjWOzyQZ93iKpo802XREhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ4TbS2IJ19vYAsBZ99ghgB4H+ZGw9Xk87hEXlk3v/F2MCso3X
	D0DuYQ20B6qsEumB3fpX6DtfyDEkru1vDXNFWBy6kPZwjIln+tmIdCc+nEnB73vhAE5LOBMPlKN
	ngXsHccVV3yMXQ4+EjckZFYQaTiXXP0Y1ZNuMEDkV
X-Gm-Gg: ASbGncvigwbqlQC48qabBv6HY7y+UihOGSUChhRXzyeAr9Wt0HKbBrqPwGZ78qy7hya
	EVtcBbTWP86CKn+xmbZybaFxBK2xSS6TTOpeXDGRJVR3RWCWCaOr45yzTAOgug4QPphnBPI2MYo
	wfMzGrjZM2b7N0ANTWDGWFDSga4xXkAc6+wjMfY9cb2qlaMDGEqz9LGlzcDKrEcwSpeJ0zl/9WI
	9bzTYw=
X-Google-Smtp-Source: AGHT+IEki6kFaYkdwz4WSdg/isMNBNiUn6MQVMt6kgGcAwbfnheSmWubbtiKX1h1K4NJX5zmFQcb2TfvOT+CGTZoQsA=
X-Received: by 2002:a05:6402:28a9:b0:62f:c78f:d0d4 with SMTP id
 4fb4d7f45d1cf-62fc78fd2b5mr51497a12.6.1758298935262; Fri, 19 Sep 2025
 09:22:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919004639.1360453-1-seanjc@google.com>
In-Reply-To: <20250919004639.1360453-1-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 19 Sep 2025 09:22:03 -0700
X-Gm-Features: AS18NWD3n-txkVWiqPHOd01wYLhU4hOVNE5_TggBK0XwCNJa9yyEjXsAoqyqlIw
Message-ID: <CALMp9eRAqb0HSt_kpWefUuYmcdvqohBzdx9EsurRcA9o3SfqpA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Don't treat ENTER and LEAVE as branches,
 because they aren't
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 5:46=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Remove the IsBranch flag from ENTER and LEAVE in KVM's emulator, as ENTER
> and LEAVE are stack operations, not branches.  Add forced emulation of
> said instructions to the PMU counters test to prove that KVM diverges fro=
m
> hardware, and to guard against regressions.
>
> Fixes: 018d70ffcfec ("KVM: x86: Update vPMCs when retiring branch instruc=
tions")
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Jim Mattson <jmattson@google.com>

