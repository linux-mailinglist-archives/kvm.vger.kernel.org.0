Return-Path: <kvm+bounces-32967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D68F99E3000
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 00:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71EBFB234C1
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 23:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3035B20A5F7;
	Tue,  3 Dec 2024 23:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D6GHsOy8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E51205AD5
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 23:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733269387; cv=none; b=rIlOifmIjqjLcGhNIC9IX48TBBuwW5TyobgZN7HG3eL89QDySRQurvDIvgdOm7/yiGqX73kPKd8pUFdfz7SIfiB+/Fmg8CengDGwSBNw5P1GhirY8jhYtzRYJrNqCqLVJNp4zjT6D+r9Ek5pcqYE6DfURC045NWekSJy324dyfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733269387; c=relaxed/simple;
	bh=/CZ2yNFlNF/WOHHJXMK+Nyg+piMw6SzQPGnPsKv0u+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S+xo1ja9ipPD83XB1SJZ3s3h5uwVoL9C9V5Wrn6KlRMB3lSl9Wt5vb4OCqrOYIjuzL8pkenWwNRiFOH0SeMfT9va0yG81hMcHMfB5LGnAfB6k9vxjeh7RXa5KYwTsEVvE/fpoXHGqwMMj6ijH4N/rWDeDHa2FMu1GG5TWsVXCHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D6GHsOy8; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-85ba22d390fso744091241.0
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 15:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733269385; x=1733874185; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=efxAKMGIsYtsJH1TfFadrRu53b/jP4XGduoqdQKfUDs=;
        b=D6GHsOy8YGm1W+pxxz9XTuNI24U+7ECkrmNetaIqMTpybghBkKEp9eLPz6u7fqBR5H
         Cc+YL05qQjSDB4MAGxv6f+Ozz6rFg71zhsTbmSFO6tRsrfVJEYHEovmc0cKncu62xByO
         eJpXVMjtLYw0/MxeFSqFOkgft5DyY3Bd+jCFieNcRnScMoI93VAYORD3abwqUYaUBsEZ
         kMQ8DbLKNmHsvrP+H1/NQ5PfOYUH/3SJEYn35g+JGBYhq1joOfUc+KO7T1UfieTb4ABz
         9EeslIU+YiGq5nZq3n9JKu3bTXqdwSnU5IPdk8WpzeYxM8UyLtRJ/W6pZr4UXX21ygXM
         IKCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733269385; x=1733874185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=efxAKMGIsYtsJH1TfFadrRu53b/jP4XGduoqdQKfUDs=;
        b=i/dZvyoByaOEXy9Ovmt6+NTXxE0W3LAi7Pds0Fqrdz76kaN3kjTNIgsa84LD67sKIe
         ULIvkJGFdV9ELNGO+Y8r9zRQObztIurOzKFKgqCHnhl8fl3oeKNJ+kojoNwEQsRtaevK
         p6NKNIzc2L5ZaHNcbiPVylYj1/X6iLZZ7Liq6G+u5aahYyL55BHYPxqAf0HiFoFXm3XI
         t1/xjgRvt6mw3DXHDX7hrpoj0xcgpsmms79eEF6Eok0CmmEEV94+FtkPUqtZT5OV0mz1
         FMaVZVh+DFSo6xPoJ3tJXqmxof/bT2QqMn9+H72gc0mbTSKm1PBtqrGkCjg5xpUiEtdO
         /Qkg==
X-Forwarded-Encrypted: i=1; AJvYcCWWr3rjJqmnQbBKQB1N8FS3sV7gLY919PpMyT4DNKWSesCl3EoQHp0COP1MPDezmmOACdE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyShGs6jiFnwglXuq0jcgSl8WlIOeSJ1Tvit7i1UCHBLdLyF0KF
	LE6QW/Q+NcIChWxHC0f8q7sqMZzA2rEs3B3VI+wdRe6+sHh28danySW3pjbLUrv8csJnShob+W9
	VmYUruTc8WFseyLautHjTw5tn8n2llL8LJcEA
X-Gm-Gg: ASbGncvKAjFjkznmdh+fyeIKQzEjGxxFjpn3nlBgJxOL1rQbrvrnk5ogZfEFIxy553D
	n8TYIDm2zdGAlpm/EHOiJpFVloBFXjNVbs4NGkhie7j43p997VAzULwaJRHBz
X-Google-Smtp-Source: AGHT+IFnoxNObCnxOJ19RTHQOfy3IS0mP97qq1D+ZXM9Cr4w6i9KeiYqycIxeXsC6V041VYgYczgtjNRhEyAzhN1RZQ=
X-Received: by 2002:a05:6102:548e:b0:4af:ab78:f383 with SMTP id
 ada2fe7eead31-4afab78f4b5mr933855137.24.1733269384628; Tue, 03 Dec 2024
 15:43:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203005921.1119116-1-kevinloughlin@google.com>
 <20241203005921.1119116-2-kevinloughlin@google.com> <a9560e97-478d-4e03-b936-cf6f663279a4@citrix.com>
 <CAGdbjmLRA5g+Rgiq-fRbWaNqXK51+naNBi0b3goKxsN-79wpaw@mail.gmail.com>
 <bc4a4095-d8bd-4d97-a623-be35ef81aad0@zytor.com> <24b80006-dcea-4a76-b5c8-e147d9191ed2@suse.com>
 <25fa8746-3b36-4d43-86cd-37aadaacdf2e@zytor.com>
In-Reply-To: <25fa8746-3b36-4d43-86cd-37aadaacdf2e@zytor.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Tue, 3 Dec 2024 15:42:53 -0800
Message-ID: <CAGdbjmKwMrioAq1b1v_UhhOxU6R2xPztZ9Q3ZizC9iMA84s+ag@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] x86, lib, xenpv: Add WBNOINVD helper functions
To: Xin Li <xin@zytor.com>
Cc: Juergen Gross <jgross@suse.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	linux-kernel@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, thomas.lendacky@amd.com, pgonda@google.com, 
	sidtelang@google.com, mizhang@google.com, virtualization@lists.linux.dev, 
	xen-devel@lists.xenproject.org, bcm-kernel-feedback-list@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 12:11=E2=80=AFAM Xin Li <xin@zytor.com> wrote:
>
> On 12/2/2024 10:47 PM, Juergen Gross wrote:
> > P.S.: As the paravirt maintainer I would have preferred to be Cc-ed in =
the
> >        initial patch mail.
>
> Looks that Kevin didn't run './scripts/get_maintainer.pl'?

Woops, my bad. I somehow ended up with the full maintainer list for
patch 2/2 from the script but not this one (1/2). Apologies and thanks
for the heads up.

I saw Juergen's patch [0] ("x86/paravirt: remove the wbinvd hook") to
remove the WBINVD hook, so I'll do the same for WBNOINVD in the next
version (meaning I shouldn't need to update xenpv code anymore).

[0] https://lore.kernel.org/lkml/20241203071550.26487-1-jgross@suse.com/

Thanks!

Kevin

