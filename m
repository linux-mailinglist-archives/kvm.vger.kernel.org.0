Return-Path: <kvm+bounces-10853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A17D78713A0
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:31:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 581861F23A25
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B358629429;
	Tue,  5 Mar 2024 02:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i6EEM071"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCE12940C
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 02:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709605865; cv=none; b=RAYSKuxfPjiSY8vKMk7qBYQwjF6eEIKRMPAHxJc1xYG+mXKulnl/plSVp+WeDx6Fn+UdUNeVgZTdsFc1QTMhTpkDT1aORonX/ujUtrW2WpbvNT2LJpSjOFon0ioVZZK/FKiG7ZI9pQu/xfiDiBof1/56TIVIWsD8JhCrDd3fjzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709605865; c=relaxed/simple;
	bh=zcBFJjHmVyjxJY256SmdudDut0j5ZrNSRHrci0UWjL8=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=bwwH7zrjQospFJFwTLpKrJeG2TXIotWnCFr3HIFFKo/GJHPHZWZrcA1BrDiSdT7pEEOnCsPX3ectCXrSS+TUtAz1aqXMCekQvEyawGVpVnIFIl/zusuOX80avVUq/g6IGeLzgS6DfxqRvivfOOB+KiFinHu8ahDpgnL9o2KtiZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i6EEM071; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-29a7951c6faso3359932a91.1
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 18:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709605863; x=1710210663; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zcBFJjHmVyjxJY256SmdudDut0j5ZrNSRHrci0UWjL8=;
        b=i6EEM071Ia209vtfkYTC4aaX0TTIbcmYQrPhcEn7WQNO95k+40ZiIuPILdMXsF7rXB
         kn7izwQzRd8D2QQAMr/cQQdlTRqxTvV5ofPSHZ+lIcuIrkvtVV/is++akusKm8oavhxw
         D3ZQS6ollx9V61Gw6H4Y0kG2ngI+CC1t6VLs1E0A/RYGpYcAiqSY2mYUom1NbnE589dp
         KooHQHd70VWG8NsvIpzSdbVcvR0JK+ZcLD5JGdm2OD8WPY6stJdVuWGsAPc+ijGdXJIM
         pkqCxFVmciSTfNfGBZhlErQZaLKiP+91kX81UCM1XMz7SZoEQrR59cdyskPu9ahVCy7s
         f1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709605863; x=1710210663;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zcBFJjHmVyjxJY256SmdudDut0j5ZrNSRHrci0UWjL8=;
        b=EFb5wOGcQmfyIroRW+CW6c+yJHyE9tKjRL7M55vmrjZSSIH2kx0UAkacKUf/JKvJel
         XvyrSOGlqORMMQPqhzujLKAhcTu7NoVFwqwiGyoW/dJ7XjeDEQ4LSLlnirUKHtrATuTN
         xy38QIvso80XRmLEc0Jw1L+cVAD5s6DI+gcQOrTYHXqXAoGWCkIOfH8Yhw+3yJwo+EXc
         rxis27V16OEX5V39BcvLbOJMFLNckyeDFhj9vDQM8qFNL00ajYfZNfLupP/vtEPgplMz
         Q530CatI/09VuygCAb28GrllYO+FVPavI5EFQJGzkPgFWxZRxoG7WLA5Jk/MHYNvFrDM
         qeng==
X-Forwarded-Encrypted: i=1; AJvYcCWOnRWVtFO8TNCaz7XAgwCtNJapCyQQVl1wlEvtRR1+wkTQurHlVWd+2LYgOqm+RCqkr01LZiSeGT05amPQ0lpGpsex
X-Gm-Message-State: AOJu0Yx4RnO6OACi50KpYAIpdR2zkI89gDFoo78D9hcgt1zO2BRaRLyG
	I97xGssQMSM5ogfdDgIBMjnrFoduCgWAg5DgAvQ0EMMhYaNikoDQ
X-Google-Smtp-Source: AGHT+IFVGXsr5tOFvMPOLx67KzPiI5rdKFM47a+cY5+eENxJa8h38L3eQnfiU1tEHSjkg4RwT2UdMg==
X-Received: by 2002:a17:90b:4ece:b0:29b:34fc:e94c with SMTP id ta14-20020a17090b4ece00b0029b34fce94cmr4639082pjb.27.1709605862860;
        Mon, 04 Mar 2024 18:31:02 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id cz13-20020a17090ad44d00b0029ad44cc063sm10510067pjb.35.2024.03.04.18.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:30:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:30:47 +1000
Message-Id: <CZLGOZZBFIS3.1ZVPJ6AKUMP3A@wheely>
To: "Andrew Jones" <ajones@ventanamicro.com>, "Thomas Huth"
 <thuth@redhat.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>, "Joel
 Stanley" <joel@jms.id.au>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 14/32] powerpc: general interrupt tests
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-15-npiggin@gmail.com>
 <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>
 <20240301-65a02dd1ea0bc25377fb248f@orel>
In-Reply-To: <20240301-65a02dd1ea0bc25377fb248f@orel>

On Fri Mar 1, 2024 at 11:45 PM AEST, Andrew Jones wrote:
> On Fri, Mar 01, 2024 at 01:41:22PM +0100, Thomas Huth wrote:
> > On 26/02/2024 11.12, Nicholas Piggin wrote:
> > > Add basic testing of various kinds of interrupts, machine check,
> > > page fault, illegal, decrementer, trace, syscall, etc.
> > >=20
> > > This has a known failure on QEMU TCG pseries machines where MSR[ME]
> > > can be incorrectly set to 0.
> >=20
> > Two questions out of curiosity:
> >=20
> > Any chance that this could be fixed easily in QEMU?
> >=20
> > Or is there a way to detect TCG from within the test? (for example, we =
have
> > a host_is_tcg() function for s390x so we can e.g. use report_xfail() fo=
r
> > tests that are known to fail on TCG there)
>
> If there's nothing better, then it should be possible to check the
> QEMU_ACCEL environment variable which will be there with the default
> environ.
>
> >=20
> > > @@ -0,0 +1,415 @@
> > > +/*
> > > + * Test interrupts
> > > + *
> > > + * Copyright 2024 Nicholas Piggin, IBM Corp.
> > > + *
> > > + * This work is licensed under the terms of the GNU LGPL, version 2.
> >=20
> > I know, we're using this line in a lot of source files ... but maybe we
> > should do better for new files at least: "LGPL, version 2" is a little =
bit
> > ambiguous: Does it mean the "Library GPL version 2.0" or the "Lesser GP=
L
> > version 2.1"? Maybe you could clarify by additionally providing a SPDX
> > identifier here, or by explicitly writing 2.0 or 2.1.
>
> Let's only add SPDX identifiers to new files.

+1

Speaking of which, a bunch of these just got inherited from the file
that was copied to begin with (I tried not to remove copyright
notices unless there was really nothing of the original remaining).
So for new code/files, is there any particular preference for the
license to use? I don't much mind between the *GPL*. Looks like almost
all the SPDX code use GPL 2.0 only, but that could be just from
coming from Linux. I might just go with that.

Thanks,
Nick

