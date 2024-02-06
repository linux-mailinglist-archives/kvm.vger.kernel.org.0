Return-Path: <kvm+bounces-8072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3072684ACDE
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 04:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91744B23DC9
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 03:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D078745D1;
	Tue,  6 Feb 2024 03:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1bMRl3A+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F6373197
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 03:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707190230; cv=none; b=VvpRsANY37s1qDLFatkyh6u75JhIjFa9Cpr8/niX1HALjUz2oyRXlZR2jITUdKvjvLTFdCf/yh5kGZ0KBxggiqClXgqot4CXce/RD5aP0GyfJCZ7JSWI4L9Z2XoArs+mCfo60C7YMzgLViZtOojPynEPvs5bKV09XE1NHtWEzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707190230; c=relaxed/simple;
	bh=zv7vCVQbBPrW0B2XI5TnrFl6LvNX0JR099oQYFk0hEA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cxro9IhaA6sp6TIcpjPtsyLHHIveBrlcKkfd1XL6qxZSYYQkeqRgyTbX/bP+jupXAYhTgefstEYkp9Zxysy0Dqpl/2Y/NxYLSAAU43nPU/jdwP4dN1VsdoJwq96JYP2iiEg41m8bLWGVEqacVV0gCCUkb6OGTpqgk6ixXKvc2Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1bMRl3A+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6047a047f58so4403047b3.3
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 19:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707190228; x=1707795028; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pt+xfWv8IugBoB7mNNPsK7vEotzvYzw0zzpWY98i+wQ=;
        b=1bMRl3A+JhvPPE1B1I6UGXaxwKoug/3wZUUJuEv/GCRtox1xI6gUDQ/HGmmB27D3GF
         V4vGNXRAyDOJYp8iq9uRoJtoKm+WKw5LE18N/xZEyjPu/06MuyqaXtzprQxLAvw1bfgX
         7S6n4gUK0LV50PcPykbQyAcSLSvl1650VBq4elHUnFS6QtLXZhLPTNFryr1v5/QP1KM+
         gk3oJF+9UB4lSDpzM2HgSvmfl1YOgNFjgWRPUwGejIcODDpUJHZ7dKSWJOzEomxfiL9k
         AYTMoTcDnX9ZJtPMAw5Op0d1G4FPH2+7W0I2IzcH5fmZATLNkSPWc3YpcoZQUeirYW/P
         EMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707190228; x=1707795028;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pt+xfWv8IugBoB7mNNPsK7vEotzvYzw0zzpWY98i+wQ=;
        b=uPOPYxLUmhXPeT4JwxGqn5anf6O1ulI5owXMA9Ixg4ITCQcKmh87qemHMyWIOewrTH
         60300aciMt7t+XVfhFKfd2BnBrurHpQCklZiKAnxc822hF6EghdwBi9MLvhOvOsnQY/N
         H4OVd3EOnqWKRRGkJfCbKQwTLVag0oNPAmdB9iYvFPV6Ji/H71kkzFC0vkIeiAEPkcJc
         7bU6RJImM4CQokg4/U5bG3okaVDqGRa9qPVD9Ss/v9EMiY6MussSXN+h3v/vQtXTPogZ
         NG7VlZzyg6KH8E9egUkJkQYAt88wKE8CzhCTfMhUP2wpQiFTW3go62GylXuWhWjKNo9T
         JWOA==
X-Gm-Message-State: AOJu0YxC3bB5uhSpGZF3c5ByVlCBJT1RzQ/bJJJFAK7S8T7Gximveyy+
	sbzMZixZ50zODFCI9QDEvDXdvd/F7LA+PZsEHWK07rTUC6Ej65pxkC96W/L1Ox+xEgVxDqVddJG
	INA==
X-Google-Smtp-Source: AGHT+IGeICVQ02NeiSaxOWeov64L9LFkyRd2MjpVPnbBri2C/x18Z/L8boGFRDBdYT34E3OXOPhqdcQCE8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4cca:0:b0:5ff:dac0:6524 with SMTP id
 z193-20020a814cca000000b005ffdac06524mr91662ywa.3.1707190228139; Mon, 05 Feb
 2024 19:30:28 -0800 (PST)
Date: Mon, 5 Feb 2024 19:30:26 -0800
In-Reply-To: <ZYJFPoFYkp4xajRO@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
 <ZUEPn_nIoE-gLspp@google.com> <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
 <ZYJFPoFYkp4xajRO@google.com>
Message-ID: <ZcGn0t3l8OCL5mv6@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023, Sean Christopherson wrote:
> On Tue, Dec 12, 2023, David Stevens wrote:
> > On Tue, Oct 31, 2023 at 11:30=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Tue, Oct 31, 2023, David Stevens wrote:
> > > > Sean, have you been waiting for a new patch series with responses t=
o
> > > > Maxim's comments? I'm not really familiar with kernel contribution
> > > > etiquette, but I was hoping to get your feedback before spending th=
e
> > > > time to put together another patch series.
> > >
> > > No, I'm working my way back toward it.  The guest_memfd series took p=
recedence
> > > over everything that I wasn't confident would land in 6.7, i.e. large=
r series
> > > effectively got put on the back burner.  Sorry :-(
> >=20
> > Is this series something that may be able to make it into 6.8 or 6.9?
>=20
> 6.8 isn't realistic.  Between LPC, vacation, and non-upstream stuff, I've=
 done
> frustratingly little code review since early November.  Sorry :-(
>=20
> I haven't paged this series back into memory, so take this with a grain o=
f salt,
> but IIRC there was nothing that would block this from landing in 6.9.  Ti=
ming will
> likely be tight though, especially for getting testing on all architectur=
es.

I did a quick-ish pass today.  If you can hold off on v10 until later this =
week,
I'll try to take a more in-depth look by EOD Thursday.

