Return-Path: <kvm+bounces-67383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49442D039C1
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 15:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8645332870B4
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F12648692A;
	Thu,  8 Jan 2026 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rsWPBEQz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08C748033B
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881414; cv=pass; b=m68jon+mfrt+C5RWGudWJZT3WpJouUKh5v3yJnp5fHQB/qeBBPl+vMiCJvTFSrufV/mPcNw086FzHlaF9HV6owleJfgztRJTc/ovlG8qP/1oi1Y6m+9cui2erV3sq/kIOn+Svb6lzZpTtKbaWU0DABfSn70zKj8txv96fPEiYuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881414; c=relaxed/simple;
	bh=YkKdPv86ApMrpTeTFnhz+IcSUQLsILOLPvJQz1PDFUE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j1tVOtfMy/apC0Qm+iuCeXOGyG7G9KeeJ7DZnxEXe5QBZCQ77HxaWxd1pn+EfCLoFdICiSzd/hPuh2s9I5r2SnTZ6d+Erxrs4LWmHfFI0C7sz39CN2+qVKic+R8L2uh/CY3Iq53+iYIEqKuUZGK1CECn6BEVMg8uBf45t9NIN8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rsWPBEQz; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee243b98caso845811cf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:10:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767881412; cv=none;
        d=google.com; s=arc-20240605;
        b=YhMxRkBiZGQAV6Gzf8Qeb6clG6OZOK86SuHw61TINWT6KNDVxva95HPR4MVYiBTDSj
         akSfhbq65qh2sx/DhJjs6E3DzHP9qzxsPk5rbcD/dBxLv5VPk0Rfc9vRJKVSMe3kDC9M
         vIAo6BSa9u6UVxWGka+xWcnu24pO4MymIUpknVhkBKH/oaKW3LVhBwx7WFnAL46cid0s
         UUfvr/N+TWqILeFriOt63DOffj5mnf+EnnsAhZGyxwtV2/EZ/jeOAMxBBJuqY1UNQyQn
         KlPETTxGeiBvrr0MJDzqkMCs/c+5F5kOh5f31NraldfDM6vCXxIzwDlpsrVxTnCFC3K6
         AwYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TGOhyPqsKhZPttb5gff3fg7ZFzXcVrSNwuwgJbbCpXM=;
        fh=GA/TRTl726z7Vf1j0kqHDBV7Xy1oeVKFTOV8a/SOcL0=;
        b=dnnYqBprr6ZGr3O79OXjhL6Fued1EWrEw0rZISZdpDXJ9EP8JZdQ6Im1/ooIR7lkwQ
         lrH1vFm4seo8gpSFU2K24X4svobcak57SrpDjTS2wG8JWILPTrNGfeRaJOOqzdDDS9TB
         AvGhGg+xQN1c4TnGRNMytScLXGXDB8VX64Bo9t+xgCk53roGRaab1Z2hYLPCLynFESOm
         kDvZmAJrlbOB/YFN8tUzaqqATPsxlBRQb+6fnnnw0hCXojqr+/bRJX3Jk2+WtGaBr9sH
         Kwf4WnK5CHMrVw5NMll/eVAuZhF70+hPX9rc/gKTCOfh9yl2/6K3OGftCjocgbX8J4I/
         9z2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767881412; x=1768486212; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TGOhyPqsKhZPttb5gff3fg7ZFzXcVrSNwuwgJbbCpXM=;
        b=rsWPBEQzuQJbgZEbw2nJsvobXYIHLtcO4RUGusmhN6ZDpRkLIPqahbk/bTpyP+Jho1
         lpbfoA3x/ncOtqH27SXwPpc0kK4z4IHdNaFMsiqEYSS6hBgmPH8y/oTM4VOJYDUzDGkH
         rEHzHscGp36krQPVFgVJTEUAjHx1WcYrXwXa22ySvBikC7e1jVBz54NZxeIxLPGqQBJw
         j8m/1OSxudnIeDUbRmFoK+3q13mBujuB4Z0gxWF8knE9krMKgfj1RZd/ZEJJ9qEXwPtW
         Hqz0jJxk/IZsklTICh5+9jCcUjHKPyb/wsqCsXSbxaWaUMephbw40SgwK2//b4ynCOgf
         65wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881412; x=1768486212;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGOhyPqsKhZPttb5gff3fg7ZFzXcVrSNwuwgJbbCpXM=;
        b=VK1kd/YfyOaeFfaqr4MSmXHn8nm8pNkXE/sp28wYWdTfsII7KCty+aSXGDse1vP0nj
         vyoNQJ1LNtLQKs/7vWCcJFC5SB0Bfm3w+NZBvGOUdHV7sGGR052Ml1Mm1VJDJ1JOntAM
         x6HpCLsNg6q3GRlp+pM8sfSkrbTyUQGrL7V41cyZ3Ga90P+uglOBHnRiZ6OWHiw3q2DL
         hQdcLjMtBLuwf22Uk/s+vBA468CTfi2krNVXgFKcYMQhQBki2lGWfZAElQQ8XhjUha/e
         UNPLlBHvqf69RmejIjZ8ZoKXBLGREKmZDceF6rstDm812VB8IC9ud0r4eyca952qllu3
         T2aA==
X-Forwarded-Encrypted: i=1; AJvYcCV/LTWOI0uh09R2ObtRw1v5hG1FTcyl4oqOJArKpsmW2DMmy7qn0H75dQnri9rkerqLASQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbkNkSJwWVTxo7uew2l4Au2TR8PYPpAFquedGBLooHnKReqEPy
	iHLzJn8f9K9w4c9akS+JGS8jA/HLrHhsx+ddZAt+iZt1hlSVbdA88i5Nc1udMh6LGKm7mu/oj0E
	SMK9k9wLXclhKzDcjEiOqCq3C2eQC2xrrZUA7gQSv
X-Gm-Gg: AY/fxX6T3ec6uwh++P+CORfM1Us30Je0KIp4gSFEMxfZl0hW51U2VuwHThrEfai9/Sm
	JNFL3LxBzlXcbR+xzUl9D+4VHWEhs6b1UWrOkFySV+HJXfTzqnHgE+/ODfiFu0Nf4Bm/I7PsAWP
	/w2+1CzL1JaYRAacrWY/ZUOXNhtjPPC/G+RBOOTvii0MMXKlbivMNOg/Vxa9svxeFKMM6mBKkVL
	Kz4HuOzMtTSeAZ2/5oi4KyTdj6/TigkgMnOGo23KDMJS+k8NkdJBL26e0OKRluoue5hlgUL
X-Received: by 2002:ac8:7d45:0:b0:4f3:7b37:81b with SMTP id
 d75a77b69052e-4ffc0a80347mr7952831cf.18.1767881411175; Thu, 08 Jan 2026
 06:10:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-2-8be3867cb883@kernel.org> <CA+EHjTxdSnpFHkm6o85EtjQjAWemBfcv9Oq6omWyrrMdkOuuVA@mail.gmail.com>
 <3c8b4a5e-89f4-47e0-9a5d-24399407db0c@sirena.org.uk>
In-Reply-To: <3c8b4a5e-89f4-47e0-9a5d-24399407db0c@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 14:09:34 +0000
X-Gm-Features: AQt7F2rujxIGY5_NcyYbFMLNUJyJwV68zqszeu4LHx3dTWaBmmJ-A6j-sa3_670
Message-ID: <CA+EHjTxLkLjPj=1vwDqROXOUXi2LhOQb90WP6dFaTiYG1nWovA@mail.gmail.com>
Subject: Re: [PATCH v9 02/30] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Jan 2026 at 11:54, Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Jan 07, 2026 at 07:25:04PM +0000, Fuad Tabba wrote:
> > On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> > > +#define sme_cond_update_smcr(vl, fa64, zt0, reg)               \
> > > +       do {                                                    \
> > > +               u64 __old = read_sysreg_s((reg));               \
> > > +               u64 __new = vl;                                 \
> > > +               if (fa64)                       \
> > > +                       __new |= SMCR_ELx_FA64;                 \
> > > +               if (zt0)                                        \
> > > +                       __new |= SMCR_ELx_EZT0;                 \
> > > +               if (__old != __new)                             \
> > > +                       write_sysreg_s(__new, (reg));           \
> > > +       } while (0)
> > > +
>
> > Should we cap the VL based on SMCR_ELx_LEN_MASK (as we do in
> > sve_cond_update_zcr_vq())?
>
> Yes, although I fear if we've got to the point where we've ever got a
> bigger value going in we're going to have bigger problems.

Yeah, but I think that we should be consistent with the SVE case, at
the very least, not to confuse the next person (e.g., future me) who
might look at the two and wonder why they are different.

> > Should we also preserve the remaining old bits from SMCR_EL1, i.e.,
> > copy over the bits that aren't
> > SMCR_ELx_LEN_MASK|SMCR_ELx_FA64|SMCR_ELx_EZT0? For now they are RES0,
> > but that could change.
>
> My thinking here is that any new bits are almost certainly going to need
> explicit support (like with the addition of ZT0) and that copying them
> forward without understanding is more likely to lead to a bug like
> exposing state we didn't mean to than clearing them will.

I understand the 'secure by default' intent for enable bits, but I'm
concerned that this implementation changes the current behavior of the
host kernel, which isn't mentioned in the commit message. Previously,
both the feature enablement code (cpu_enable_fa64) and the vector
length setting code (sme_set_vq/write_vl) performed a RMW, preserving
existing bits in SMCR_EL1. This new macro zeroes out any bits not
explicitly tracked here.

In terms of copying them over, if they were set from the beginning,
doesn't that mean that that explicit support was already added?

Cheers,
/fuad

