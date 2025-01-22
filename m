Return-Path: <kvm+bounces-36207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02043A18969
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E80F23A5D65
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBADD4437C;
	Wed, 22 Jan 2025 01:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MXU4znUL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C591B95B
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 01:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737508471; cv=none; b=T3OQERn0ZYEmyvGr3x286QBelizE51JH1PAnboo7kz+rg7UA7CD+Yc/HRHzgCDDTn47ExIOogaAZQVpWvav8Zx31cfpHKL5jd1Ec4+CsUeuENynb5DrURuy24aXBjir8YqH/QL3H6TXDa8TdHvpbX++I2frsdxVXY10fvTic4Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737508471; c=relaxed/simple;
	bh=bN1EZT4rdVvh71PdWDuyGsuUV663TXZxDZNp0+vBT/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uDaEUP5RAeIoS9jjnAZkMrd1E+f0EElZrpnW1XHTD0t+/RCqiwTu7pNGb1AStoQ2HoYPR0uzpGWcZt8QF7oozr4qGL7gvIjxihK4F4lJ5himHc0OOBURX+wYYi//IBvDWfEiTMXe5MH7faWxsmPuUzu0SXQ9jm1yJD2xYgDX/Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MXU4znUL; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4b2c0a7ef74so3485145137.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737508468; x=1738113268; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGfa2LIRmIfjYY1cWfPZJ8Z/FOpPurpEyfnc2imUOpA=;
        b=MXU4znULvh574jzkmXhwR4UwspYJlv+CYn/IY6dDw9wtcb13xE1PNQh3sx0E1V2wS5
         Tyx5krpGONp7xjbRDFAT8KR7+74evcyJzDcdc+mQp4vDdpL1tW1p4SoKyfrOPPYK/C0Z
         OtERtjxYs6NXBlfwthWI8XdI/tAzDKUrpn+c/L00uDSEYjPjuSfA5IlQ18jcD8y17qtH
         zBjXyM33khqFEACn0uhy/ve5mmb2+bPvx4YQBMy1Sbp1IbU7J6BfxxeQKxwnYUW/S7sz
         Gup8H+DWA62BCMHN4zrEiVAymw9tlM3YblkBORHkuRyjIb33+b3XJQHEimor7TJYkoXw
         +W5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737508468; x=1738113268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGfa2LIRmIfjYY1cWfPZJ8Z/FOpPurpEyfnc2imUOpA=;
        b=CHJDqTrBfl2btxrms9Amc4Bx80DFtodG5ZDeHUDKgKDD1NHdWosJ6eAgukvX60KyYN
         5urfanh/NkDzefFIvtz4JsvJsAy587TqKVKYkUi9mIyU3aM7SKnso/FoTL92Qao7yUpH
         usDKMV6pX1O3sNr8a/KYjikoD/uXBqMJQkx+rM14UfYcR3u+OXskSNf1CPeuhOj5J8ns
         POnNiHMeFVb1Fxo/MTy2Q1u+6ZRfwX5pUy7eKSba9Qn57kA0kxApa00pKsaf1tjXWeZg
         h4OTWUTJTMBwRU+TV1MJlNFvckqyVtO35BIYxVEQsGAYB+ucYeCJS+Q0ji0O83IukdwB
         QvGg==
X-Forwarded-Encrypted: i=1; AJvYcCXb+bEFaX4mjx0Alt0menYgHCgRS2bkSnj8FG+a3ohwi59tF1RWcRZ3pSI6DOnSNDDPvA4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1aqDPOTqoEKetDCXHkC/2i3lDGXr0Z/iD92lDOq/hYXDROWJl
	jCcwzk5m2bpbSCnGlkcIw3k8nF4JNvdcm3Cn3O/p+OdeGH7+AS90IScaXmxRRYQEg3oyzDT+MAE
	Kp9qLuqkJniGy63WSdp4gWEl2wH1cFAhIgM0L
X-Gm-Gg: ASbGnctnMTd9BiAAuJHnPTu96boLj+EPY60yBcFBT+8kwBetlzZUcYP4QaQb9Nhy6MN
	H0doJw0xhtArp38ksWQF6jn6vF1bkXu3LL0CoHul3qLIrdnEJjAYoMeeMQxemzZY9FPy1Ng+c9+
	0r6HhLnz3i
X-Google-Smtp-Source: AGHT+IHbgkwoi0loinKTf7Q0srCzHTkK6YGGVdL6ZDKYn3zAYq4yGdouHs5/L28rvQobC+k4S1IUcQmDW/+b+bQKk9w=
X-Received: by 2002:a05:6102:38c8:b0:4b1:16f8:efcb with SMTP id
 ada2fe7eead31-4b690c76ec1mr16419435137.17.1737508468104; Tue, 21 Jan 2025
 17:14:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109225533.1841097-1-kevinloughlin@google.com>
 <20250122001329.647970-1-kevinloughlin@google.com> <20250122001329.647970-2-kevinloughlin@google.com>
 <3edafd5c-f830-4627-927f-bc9ee6367d17@intel.com>
In-Reply-To: <3edafd5c-f830-4627-927f-bc9ee6367d17@intel.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Tue, 21 Jan 2025 17:14:16 -0800
X-Gm-Features: AbW1kvaO7frsLlT9DnijYxYQBaqHRs7w0FOKjg9s_OllFUfsdgXcTeMvgVxOdno
Message-ID: <CAGdbjmL=+L-sQioucz6yh_1jrtDCOz1fPxXDU2eZ_HRQkbFugg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] x86, lib: Add WBNOINVD helper functions
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, ubizjak@gmail.com, jgross@suse.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, manalinandan@google.com, 
	szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025 at 4:32=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 1/21/25 16:13, Kevin Loughlin wrote:
> > +static __always_inline void wbnoinvd(void)
> > +{
> > +     alternative("wbinvd", "wbnoinvd", X86_FEATURE_WBNOINVD);
> >  }
>
> Could we please comment this a _bit_?
>
> /*
>  * Cheaper version of wbinvd(). Call when caches
>  * need to be written back but not invalidated.
>  */
> static __always_inline void wbnoinvd(void)
> {
>         /*
>          * Use the compatible but more destructuve "invalidate"
>          * variant when no-invalidate is unavailable:
>          */
>         alternative("wbinvd", "wbnoinvd", X86_FEATURE_WBNOINVD);
> }
>
> Sure, folks can read the instruction reference, but it doesn't give you
> much of the story of why you should use one over the other or why it's
> OK to call one when you ask for the other.

Yeah, good point. Incoming in v4; thanks!

