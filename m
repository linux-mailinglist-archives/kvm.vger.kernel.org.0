Return-Path: <kvm+bounces-47149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A7BABDF61
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:43:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93D5718966F9
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4514925F98A;
	Tue, 20 May 2025 15:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Zm9fFzDU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B87246769
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 15:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747755818; cv=none; b=PFUP7x3eNcBEOrTztoqhoONspyhAD0o9GRF8jepa1QuqXvHS1Vk0GDLzFvOof8V0mkvGnuaMhmqoncinXPwUkraVP95TmCSGI1xcH33qCl4APJx4QToBoQql+QuG7UdOWkEuENi+D1ieeUCcg0j7oMa+b2ASwNVJFFkXvltJvQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747755818; c=relaxed/simple;
	bh=a3pH7ZiIwbTGKChJw4K0D5EhESOzWIYHz3GR6ZLllJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LwviaU0wvjlGHhVa1tzuyNGrxngwJqCc2UDTrNNJiN+Sd6cO/w3QgZukDB0eqM7t2BoKq3bF86FeudxXQZifcqxrJ8p+bmKi+lYAadX55U+isuB1I5cb+inJia63SPVjTx3gBOYU3xwEHuZLlxWU0sCorvGzMXxbdezpbaF+QOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Zm9fFzDU; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d948ce7d9dso18455555ab.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 08:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1747755816; x=1748360616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2VRa/jUrsGCKDxS5Z6TMKwtooPNwiNaoz1os+RUkm4=;
        b=Zm9fFzDUZQiaZ4NwQr47ZI5jmc4k1BVpF8Nb7POTZJoKNLAF7gjMCGM13ZGJp7YF8G
         yoPsbGNaUos95FbF1cvLKjMHtR/UcczCcAivFLWU3z4Vgx0S7W3xU7UynYxChNu0S8cC
         dgnT4pl7f9RDepsM+fiPXnvCqqfvgNnzVhSjpso1bS/QIQPjNAPvxEk/BtkxAWjC+R5D
         hCmj+8aVmFlmp3vnSKJusV7N9s0F1ioA2AdoeO1za3zyrOcKfxsAN6rlj1r1qDr/uh3+
         E0PRB2miFAPo870F/4b+TyAMiUmaAMARgAW3k9lVVR0JxTvYKrUqKzMgp6djVIq58wev
         LVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747755816; x=1748360616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f2VRa/jUrsGCKDxS5Z6TMKwtooPNwiNaoz1os+RUkm4=;
        b=OdEtWNh4KzN05zmiQ2/Z3j386xe1NIFdNJ2O/PV65wHqbUL2aXjjuMkfqWEDwIww3X
         kvFKM+miATT3AK/g9bwwFMkVEoon9Cx6ORzfYYMLNGwCzkXAs/YnYWkwTUtCBjI2YyaR
         OR0VC1IULMv0Q8e+nnGUemIOjoeR2Mivems0OSiFNHWdJ2HtcXb5Si2rJJaztCBRkicg
         EmizkYGBkDztJHqrc3XXa9ArX1xws3WgncmAmG4Mgp1G2xuE2UhRNiGHwzZ2mciKDfEp
         zYQLsCmO2rGVQ2T9g+sGabk1nfrgZZJwPq/FVJQZWSxSwf/Ky5C/TkS/yZK1Oa0kxuew
         nvYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOXOl9ml5lC2xDJeifR78Jr0h5hwREf2MGSFTi8huTq5eAtnw/ifYkxWy82nKzOFW640c=@vger.kernel.org
X-Gm-Message-State: AOJu0YygFs00+OjgS8fDk1DpOnZtm/dtvn0B8Pf6GVNSqjxv07jfoX4n
	X6s6diB9c2ajzoR/F927Rl6QMJVcibH/2e/pjUdxRzyseLYds4xroR5Du7moGzVjrVKK2Ic/TGF
	KdtR+qfawiMcYA6GydVy+Qv0052/OrVc/SPVDB1UUSw==
X-Gm-Gg: ASbGnct32NN+717zBF/dPhi2sdE0qD4PW4ytpmRW4CeLTdsTxgmMEejy4Qb4/ZG/h8Z
	dOPUxjgmzgegR/vCbQTT0urZUvK0T+GiEoOvWMkqvp8QC1G10Y/U/L++rZ8K4eBapqPD3XXr//4
	6uEbPz+KDtNDbJHdeRwKG8QrTlt2FOmcZcKQ==
X-Google-Smtp-Source: AGHT+IF3svIngYATXdacDmgtwqS4kspeKGV9kirg85JkxovKAXbQkjkXEoyYlC+whI2UvtEsLa8NT9F24c12+s1HAI0=
X-Received: by 2002:a05:6e02:308b:b0:3db:74b3:3875 with SMTP id
 e9e14a558f8ab-3db8435664amr168934525ab.22.1747755815659; Tue, 20 May 2025
 08:43:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
 <20250515143723.2450630-5-rkrcmar@ventanamicro.com> <CAAhSdy1Z43xRC7tGS21-5rcX7uMeuWCHhABSuqNzELbp26aj0Q@mail.gmail.com>
 <DA04W4PO99EJ.1XWOAUMZV4BXG@ventanamicro.com>
In-Reply-To: <DA04W4PO99EJ.1XWOAUMZV4BXG@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 20 May 2025 21:13:24 +0530
X-Gm-Features: AX0GCFudAM8hKKKbM9JFa9_NSe9H8wPOJAH-Y_DVCC6e_pSoJwQHL9S3iyHiauo
Message-ID: <CAAhSdy1uKpp=WKXmbnH5BQvTSrK9o-Jd6+nCrQEi3A3efLX52g@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025 at 5:55=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-05-16T17:55:05+05:30, Anup Patel <anup@brainfault.org>:
> > On Thu, May 15, 2025 at 8:22=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rk=
rcmar@ventanamicro.com> wrote:
> >>
> >> Add a toggleable VM capability to reset the VCPU from userspace by
> >> setting MP_STATE_INIT_RECEIVED through IOCTL.
> >>
> >> Reset through a mp_state to avoid adding a new IOCTL.
> >> Do not reset on a transition from STOPPED to RUNNABLE, because it's
> >> better to avoid side effects that would complicate userspace adoption.
> >> The MP_STATE_INIT_RECEIVED is not a permanent mp_state -- IOCTL resets
> >> the VCPU while preserving the original mp_state -- because we wouldn't
> >> gain much from having a new state it in the rest of KVM, but it's a ve=
ry
> >> non-standard use of the IOCTL.
> >>
> >> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> >> ---
> >> If we want a permanent mp_state, I think that MP_STATE_UNINITIALIZED
> >> would be reasonable.  KVM could reset on transition to any other state=
.
> >
> > Yes, MP_STATE_UNINITIALIZED looks better. I also suggest
> > that VCPU should be reset when set_mpstate() is called with
> > MP_STATE_UNINITIALIZED and the current state is
> > MP_STATE_STOPPED.
>
> That would result in two resets (stopped -> uninitialized -> *), unless
> we changed the logic.
>
> Would you prefer to reset on transition to the new permanent mp_state?
> MP_STATE_INIT_RECEIVED seems a more fitting name for the state, then.
>

Let's not introduce unnecessary state transitions and go ahead with
MP_STATE_INIT_RECEIVED

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.16

Thanks,
Anup

