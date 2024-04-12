Return-Path: <kvm+bounces-14370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC7828A233B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 03:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E53C11C215AA
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 01:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66325522A;
	Fri, 12 Apr 2024 01:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Em2k30HR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A93533E1
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 01:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712885551; cv=none; b=KyvnyIyaZGXGXTS1r92mO3SkuW6uzh77PAuW1RzsFtc4Y/IeEZeHrletXJoYudlB+8qXocGd4qTFHoaFI+J/g16Ckqloo2b+vsp+nu9R5z7U3frBF83x2VeNVZwKxuD2SYThZZl6AXokSHKzcCU4/FzM8mkXpjKAHs9lsYri7VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712885551; c=relaxed/simple;
	bh=6GILgMgNmF9xkB/tk1pFR2RP37of367PtZfTsHSyuSA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tl9heGJrtu876b7/6xYoNQ5VazyLeESg6mH8w4JO+eUhinZqIFIH9mt5rZOQIYsZQjwVTJK+uwy+r5kDR/1TIqrAugEUaHbcnaCXeXBT62QJ2gu9PhSy4iykUig7QJ9A3CX/lyPbCcErLuPzNROUpGQ/EIqKyiJ+kQQOUNz7J6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Em2k30HR; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5d4a1e66750so270773a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 18:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712885549; x=1713490349; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GILgMgNmF9xkB/tk1pFR2RP37of367PtZfTsHSyuSA=;
        b=Em2k30HRa/3nYoOs2W8FNtA+gjlvmUjiCY1aEF7HLgOQWYBCXF+Vrh5Skp0xnUjF3k
         rI128TtURr0meEd2ADAIprZMnS3ivSrG689nX7hF+JtkBdCWOkayrhc3nyalPbPXiiHu
         Y8Ce24R+DVxVlt3QjzH/wUOF750DPtBOIAoqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712885549; x=1713490349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6GILgMgNmF9xkB/tk1pFR2RP37of367PtZfTsHSyuSA=;
        b=e2Wa76znsHEzl8bRHtU6Fo3KR78YfwouBpcYMwEopAHJqT9wHZSvydfvQPM2ZWD0R0
         J465LYEee7E57PfRMXtansfBNf29otNMVx3sijDHka8ptSn7em2gmjcbfXQiNBkH+5t5
         AXs5I6sInPiwnigElgP9b9wH2yvUC78xQ9exBZm9y2qFgIbseZJbYZQqqah0HvW4VLH7
         +/S8WqqZI0rPuCC3eSdMFIhuOfoQ4wBHM6Xn3GfvthXQk40ga3dUry95aAOOIrTyQJ9h
         nIalZeKzcl52sbaWq96ohVfuLlEiuX/UDLl9FYcG36refcq0s/ci5Jft9C9VCnFznxjK
         HE/A==
X-Gm-Message-State: AOJu0YzvihaG3Nattu73oHaBuwKDgdqgfTd7LOvBp8Uuv9b6xGwRIHnA
	o0X+31Qku4kcZOBqeheupwbmCXwRyiPoWOdbSXSVB7JIAqciyk36USiBzTotk+2Dr1KE5lys7TZ
	VU3GvzXg4jm50dIF3TzZhRnxF3SY7H1/gqEKq
X-Google-Smtp-Source: AGHT+IFS2+dY9ZSRz3TXq1yLhDRz0P6ap/tVzb5ISpOitb7BUfnV5r6u0RsIqJ/fcfeRHgVGkE0YoUBRC0jFt4EPuig=
X-Received: by 2002:a17:90a:ee4a:b0:2a2:bc8c:d677 with SMTP id
 bu10-20020a17090aee4a00b002a2bc8cd677mr1472258pjb.26.1712885549526; Thu, 11
 Apr 2024 18:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411205911.1684763-1-jmattson@google.com>
In-Reply-To: <20240411205911.1684763-1-jmattson@google.com>
From: Venkatesh Srinivas <venkateshs@chromium.org>
Date: Thu, 11 Apr 2024 18:32:17 -0700
Message-ID: <CAA0tLEor+Sqn6YjYdJWEs5+b9uPdaqQwDPChh1YEGWBi2NAAAw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 1:59=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> From Intel's documention [1], "CPUID.(EAX=3D07H,ECX=3D0):EDX[26]
> enumerates support for indirect branch restricted speculation (IBRS)
> and the indirect branch predictor barrier (IBPB)." Further, from [2],
> "Software that executed before the IBPB command cannot control the
> predicted targets of indirect branches (4) executed after the command
> on the same logical processor," where footnote 4 reads, "Note that
> indirect branches include near call indirect, near jump indirect and
> near return instructions. Because it includes near returns, it follows
> that **RSB entries created before an IBPB command cannot control the
> predicted targets of returns executed after the command on the same
> logical processor.**" [emphasis mine]
>
> On the other hand, AMD's "IBPB may not prevent return branch
> predictions from being specified by pre-IBPB branch targets" [3].
>
> Since Linux sets the synthetic feature bit, X86_FEATURE_IBPB, on AMD
> CPUs that implement the weaker version of IBPB, it is incorrect to
> infer from this and X86_FEATURE_IBRS that the CPU supports the
> stronger version of IBPB indicated by CPUID.(EAX=3D07H,ECX=3D0):EDX[26].

AMD's IBPB does apply to RET predictions if Fn8000_0008_EBX[IBPB_RET] =3D 1=
.
Spot checking, Zen4 sets that bit; and the bulletin doesn't apply there.

(Also checking - IA32_SPEC_CTRL and IA32_PRED_CMD are both still
available; is there anything in KVM that keys off just X86_FEATURE_SPEC_CTR=
L?
I'm not seeing it...)

-- vs;

