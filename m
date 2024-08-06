Return-Path: <kvm+bounces-23429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76FAE9497B8
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 20:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7460F1C221BC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825B277F10;
	Tue,  6 Aug 2024 18:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eqEr+0Kc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA7C24211
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 18:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722969917; cv=none; b=LsyWjT++jdODrq5rVICcx7ggUwiLiSrQURbqYECZYez8nIXjvYxxGp0f5hvrhaDXavwXmSEmk+2GVIIi59QYTz+eGs1UGFMHsemKXmVpVVcwgvLyXAcbqhABmDjrQuJIZObIa6i30ZlzS/HNzj7xn/cFGkkPB70zqAnE98FxxYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722969917; c=relaxed/simple;
	bh=jHsGt2Ecfc0zM2iKA6jysW31IutQSfrosXB8X1hXSNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p7r5WoaOydZOJvoLJZLfDipFXMmnf3o9oqP4LyWeAO8/LMiBO0evo5D5X8D4LyamE60h5N6Wb+KRJ0X06mXd/tXsXsqSKis2TOn+jf8tC/sDXmIwMOQbLI/qGw6hFm5KQpCf0tT4TSrmprq3VVbJ5Zi11kbdObb0+yG2IawIbLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eqEr+0Kc; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-2681941eae0so479614fac.0
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 11:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722969915; x=1723574715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ripeo5i8uUp5SgHoOewxiAzj2BIopxPTD9L1SwZcR+A=;
        b=eqEr+0Kclvju5EfWMLsrfOCQk9RJR64KJ79LYci2H4NDJmyxFwCRhBcfId1zQu3p9Z
         iPk14o01Zucq016c64V/D57jaWt8gt1SZgRY4UlDjNY2EvCWVhUvhzlBnFFy7lssFa7y
         RjQICyH2XLIfGrxWw0F2QKCU6wyTVCeI+iMsLRFKVaGIeiJsp+KB/CtnAD77a0ZgW3x0
         3r/E1nWenQj4Qnux5bgvvVr+M2bCfvQKywhXPPct5mQYVhZELIba16IPnAuHIgTuxW8m
         FNAJSxjt5HQw85147KChw6gG0rjLUC602cmx5W3sYV3V+Zc2HLFtkYCj74y6aj3LiFhp
         rsdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722969915; x=1723574715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ripeo5i8uUp5SgHoOewxiAzj2BIopxPTD9L1SwZcR+A=;
        b=dbUK2azTf4mT27BZ5CuhFyTeto7JG+gXRSTuArG9DaYI+gAqNzYg9GmY2FDOIsaIGu
         TgVtsXXn56hVTSGwxumChB7/Lsnz/3JreDT2WytbSuZILu6xr+y7XKVF7w6xTM8zdXWc
         vFxBtRZ+FT9BYvU9FEvJuDpQMU+h5LeMIQBGulSTlzPTnlkssin9K7U/dpUYJsD4M3VK
         rKjIYOJhTYUtqCYDm9AAxAESo2bbtMzI7uTAY+98tkzwLpj6o2FN6gMkZ5jDHLpiAhjA
         y4eSCycD52PVd3akkFJrKQZCOgT/kr6AqYl1Nl7x24fPCWBQrEetZXc9i6ubhiOh1CTE
         2gGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWJcobDySFuO7rb8mmX/OxoBHeRH7teDJI9DUvoYvmDH6xHYbVY0ZdkRNyAuTSmcOjHj2z+CxG50BbI748sVAezaLT
X-Gm-Message-State: AOJu0YzaNeiKetfLw6X6GtSoGGEFFqjFlU7pmcF/7QjaQXzBomaOD9fc
	m/P4QJXLXLxcstdS+GW029Re95pNFa83ul8odWsD9Kz+3ffYhu3g9nULhwqLsVvrJ6sCX9CQJvb
	1wlqckpHmkM38Bp9XwDSFp8FR57DvDi2hYo7+
X-Google-Smtp-Source: AGHT+IGC4aXwtfPl59UuB0qcraDI6lRBACElZ10exivMH0tQxNylIzGJybb+jLBgrGRQqnhyIwoOBZqIWA3F4WkOGMI=
X-Received: by 2002:a05:6870:9a1b:b0:261:16da:deca with SMTP id
 586e51a60fabf-26891d40b76mr17350382fac.27.1722969915146; Tue, 06 Aug 2024
 11:45:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com> <20240802224031.154064-4-amoorthy@google.com>
 <ZrFZ_ANIIbFdzmIn@linux.dev>
In-Reply-To: <ZrFZ_ANIIbFdzmIn@linux.dev>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 6 Aug 2024 11:44:39 -0700
Message-ID: <CAF7b7mps9-HdBv52BDbAMceGuT+FRiRtpdwpK=psfW1Msvip+Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Do a KVM_EXIT_MEMORY_FAULT when stage-2
 fault handler EFAULTs
To: Oliver Upton <oliver.upton@linux.dev>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 5, 2024 at 4:02=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Fri, Aug 02, 2024 at 10:40:31PM +0000, Anish Moorthy wrote:
> > Right now userspace just gets a bare EFAULT when the stage-2 fault
> > handler fails to fault in the relevant page. Set up a memory fault exit
> > when this happens, which at the very least eases debugging and might
> > also let userspace decide on/take some specific action other than
> > crashing the VM.
>
> There are several other 'bare' EFAULTs remaining (unexpected fault
> context, failed vma_lookup(), nested PTW), so the patch doesn't exactly
> match the shortlog.
>
> Is there a reason why those are unaddressed? In any case, it doesn't
> hurt to be unambiguous in the shortlog if we're only focused on this sing=
le
> error condition, e.g.
>
>   KVM: arm64: Do a memory fault exit if __gfn_to_pfn_memslot() fails

Ah, right- forgot to address this before I sent it out.

Basically: those cases you mention (besides MTE, where it seems simple
enough to add an annotation) happen before vma_pagesize is calculated,
and it doesn't look trivial to just move logic around to do that
calculation up at the top. Lmk if there's a good solution here, but in
the meantime I'll just take your suggested shortlog

[1] https://github.com/torvalds/linux/blob/master/arch/arm64/kvm/mmu.c#L147=
9-L1514

