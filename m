Return-Path: <kvm+bounces-57664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 256FEB58AD3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 03:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B90273B34E7
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 01:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976501E3DCD;
	Tue, 16 Sep 2025 01:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pch4TApz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FC82A1AA
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 01:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757984934; cv=none; b=B5ftMmwULfHRauWRKrAr+UZr17q79sN7yY0XOfQek9+Fcd+zdYo0Z3eMSzyc2F+p7PoVftM1KAuOrMnuiTTjngJNnTAwbhdrq0rsYVh3kndepkLUeolUvUWl6a0/2MeJJ3aHzExZnfb2P8LiX8WgeE/MtC1notE8ADXrdoWbrf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757984934; c=relaxed/simple;
	bh=RLxHq+ieXY28lD11U/kgpTTtUvpefKc4mYLbzO1KbPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gZbL2GBVa+c2SXmzS6f3sdVWdwJJULiEY8cJ0BNLnOXs9h+QbvYxLV9UzRaDYuLqythpgs7Duyg/dyiiiXdSnLTAoaDvwTNFyWNjtPVhlLNBXcpyF+jPtXY+hBj0NuWh5B7unAeo1gMUhtfPMKQTYJzbmssFVUSc5WyHBuxxHV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pch4TApz; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-265f460ae7bso91875ad.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 18:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757984932; x=1758589732; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPfnnggT2ndL938eIChQLKvTB/FFnYYq61IMlRsGnh4=;
        b=Pch4TApzu1Zm/kTnaazdaLRFgUN4HlTabOTg/0Af/Ic9x8PfkdA7r/xYrg1FwxcTV8
         hc7E0ACMQxmmqrN7rW/HCZOMXKdjv89vd4pva7jTI//F1CwqT6hI9wZnqy6v0gx+Mjec
         KfM8F2xDRyU6uzWAeViww+ZUTuq3NHU0zG/A4c2y4Mo2WDHN2OtL2Qev8QRWCrKVIvFe
         TTewqrE6HuFP39IP+XsNRLJldz7ZXP4e3nFtsrNYhbryLWSVhW3iOOPhA1ALNyKTlEZl
         dcucesS6tOvjKSchZvEWxQedeakzWMCw1/VCtECYDidp3aXSbhZPJN3ir1A1QVWTt04N
         4WsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757984932; x=1758589732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPfnnggT2ndL938eIChQLKvTB/FFnYYq61IMlRsGnh4=;
        b=Pwlk7Yx+s6FUjvMZdQxxF319WS2gec39OZtD2pcXIQAnmRkpODlZiWuDw+5p09zaRX
         DR90FfEDxqcTzyAMEnkBvVsISxv1zG+Rse6IfT8OAR5bKrLIEI7NDTjWG1Q82ePFqFAy
         2ubW9y/s3opQM1BPbVLuajxr7dmatIleSqc6okkCtMUh3FT9/ZQ0fH7ZIhSuPYd23gKk
         Net3H8WYLmxN7YnT/o0v9J5r5MnAFjuxwmOA7at1lGhp4iPqfX2owGQvrBekoofH8KYK
         i4gKPq4dVcJg8AAO5EKmvas7ZtqlK+V7HdeKchSuyDYLzV7FGAKq5kLsc8SjFZ+9p/oZ
         8mmg==
X-Forwarded-Encrypted: i=1; AJvYcCX1SZj6NKcm/dBvEHWfJPFqae2u++fOpmSK4OuzVTqTkgMSvjt90LBskmLVjSEH2WdYsuo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVMhvio7dcQuzuYPdLzwox/noquIX1T5+SVUL2iVukr67+o4gv
	ZMBYp3wHPH7sNL9lbgsrgrViWRkSNU67BuXruLNXtGJ95cjkZXR9taLpGGxMsPKzpq/nlHJLiac
	5H162Qn0LhyZgeykLdqzKFuRzjNiFu8mTGxi5IMr0
X-Gm-Gg: ASbGncvLTaa84EctjkVTpl1l0n90j3E51KrWczESmwGNun5EHG5FkmvnbIXI0Fo/aP3
	jpdL9HTNZssl5YhM88t/E/UOQRIIKfK6bvdTPxCjVnSnMCR6ubalYKvtu71FUryFNIFyxtLwnkj
	tfZb7OLbZxQotE4pfdfBlazqKA265sAFgXHLKRfkpHoX7+gm5oPpSS6r9qtJ3g2sqyM9jrvh1RP
	QqfTyCaXItxeh63UciHg+3fUMZaRU9cMYobRoDN8ZwAYbg=
X-Google-Smtp-Source: AGHT+IFJAwHXee6Yr2rlSgFzR1W6KmuFM2AmQV7u+C+LW88ZIxPQ1NthTP/QNnO6EiXNfW/zo3fYwDpWfY06zM6keSU=
X-Received: by 2002:a17:902:ea0f:b0:24b:131c:48b4 with SMTP id
 d9443c01a7336-267ca0ea180mr1360815ad.5.1757984932255; Mon, 15 Sep 2025
 18:08:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902111951.58315-1-kalyazin@amazon.com> <20250902111951.58315-2-kalyazin@amazon.com>
 <CADrL8HV8+dh4xPv6Da5CR+CwGJwg5uHyNmiVmHhWFJSwy8ChRw@mail.gmail.com>
 <87d562a1-89fe-42a8-aa53-c052acf4c564@amazon.com> <CADrL8HUObfEd80sr783dB3dPWGSX7H5=0HCp9OjiL6D_Sp+2Ww@mail.gmail.com>
 <CAGtprH_LF+F9q=wLGCp9bXNWhoVXH36q2o2YM-VbF1OT64Qcpg@mail.gmail.com> <b325fb38-d34d-45e1-a5cb-eaf2b8c59549@amazon.com>
In-Reply-To: <b325fb38-d34d-45e1-a5cb-eaf2b8c59549@amazon.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Sep 2025 18:08:39 -0700
X-Gm-Features: Ac12FXzyKYuqCZZsxxrtjECaM8gnlnpPAkbnGEzt2I2OQ5pY2bh2gNnFAoMROiY
Message-ID: <CAGtprH8PJa-hV6DsfUKevZQs=73CUf8ow9i2-sdxbj555De9Aw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] KVM: guest_memfd: add generic population via write
To: kalyazin@amazon.com
Cc: James Houghton <jthoughton@google.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "michael.day@amd.com" <michael.day@amd.com>, 
	"david@redhat.com" <david@redhat.com>, "Roy, Patrick" <roypat@amazon.co.uk>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 4:01=E2=80=AFAM Nikita Kalyazin <kalyazin@amazon.co=
m> wrote:
>
> On 13/09/2025 01:32, Vishal Annapurve wrote:
> > On Fri, Sep 12, 2025 at 3:35=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> >>
> >>>>> +
> >>>>> +       if (folio_test_uptodate(folio)) {
> >>>>> +               folio_unlock(folio);
> >>>>> +               folio_put(folio);
> >>>>> +               return -ENOSPC;
> >>>>
> >>>> Does it actually matter for the folio not to be uptodate? It seems
> >>>> unnecessarily restrictive not to be able to overwrite data if we're
> >>>> saying that this is only usable for unencrypted memory anyway.
> >>>
> >>> In the context of direct map removal [1] it does actually because whe=
n
> >>> we mark a folio as prepared, we remove it from the direct map making =
it
> >>> inaccessible to the way write() performs the copy.  It does not matte=
r
> >>> if direct map removal isn't enabled though.  Do you think it should b=
e
> >>> conditional?
> >>
> >> Oh, good point. It's simpler (both to implement and to describe) to
> >> disallow a second write() call in all cases (no matter if the direct
> >> map for the page has been removed or if the contents have been
> >> encrypted), so I'm all for leaving it unconditional like you have now.
> >> Thanks!
> >
> > Are we deviating from the way read/write semantics work for the other
> > filesystems? I don't think other filesystems carry this restriction of
> > one-time-write only. Do we strictly need the differing semantics?
>
> Yes, I believe we are deviating from other "regular" filesystems, but I
> don't think what we propose is too uncommon as in "special" filesystems
> such as sysfs subsequent calls to attributes like "remove" will likely
> fail as well (not due to up-to-date flag though).
>
> > Maybe it would be simpler to not overload uptodate flag and just not
> > allow read/write if folio is not mapped in the direct map for non-conf
> > VMs (assuming there could be other ways to deduce that information).
>
> The only such interface I'm aware of is kernel_page_present() so the
> check may look like:
>
>         for (i =3D 0; i < folio_nr_pages(folio); i++) {
>                 struct page *page =3D folio_page(folio, i);
>                 if (!kernel_page_present(page)) {
>                         folio_unlock(folio);
>                         folio_put(folio);
>                         return -ENOSPC;
>                 }
>         }
>
> However, kernel_page_present() is not currently exported to modules.

I think it should be exposed if there is no cleaner way to deduce if a
folio is mapped in the direct map. That being said, we should probably
cleanly separate the series to add write population support and the
series for removal from direct map [1] and figure out the order in
which they need to be merged upstream.  I would still vote for not
overloading folio_test_uptodate() in either series.

Ackerley and Fuad are planning to post a series just for supporting
in-place conversion for 4K pages which is going to introduce a maple
tree for storing private/shared-ness of ranges. We could possibly
augment the support to track directmap removal there. RFC version [2]
is a good reference for now.

[1] https://lore.kernel.org/kvm/20250912091708.17502-1-roypat@amazon.co.uk/
[2] https://lore.kernel.org/kvm/d3832fd95a03aad562705872cbda5b3d248ca321.17=
47264138.git.ackerleytng@google.com/#t

