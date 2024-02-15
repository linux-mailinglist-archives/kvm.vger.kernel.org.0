Return-Path: <kvm+bounces-8812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B79856C20
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:08:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F24A9B248B7
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B79DD1384B7;
	Thu, 15 Feb 2024 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BRnOkFZ3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0FE1369AD
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708020506; cv=none; b=aGEtblBDH9x/o/eOWkt/Yb/pe5ZYAbV4NrrOGR4dJIGFHI4pI85jhd13iYFMxhtIbS8Yqjq/NqP1IqGz/A5qVKj7R15hrFlCKrjNsQTiSr3IzsJZEkKow668/qhW7N28seBFGgTZauXfiKrSWSZKKAMfy+WiyISf6PQjmwJSYIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708020506; c=relaxed/simple;
	bh=lA8uWfKDTswhUYSt0szr4iG14O2IbQR7ZiKLS2FP2UY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TkL7eflOFIJkpTy04cL2EAwKAll8yjEJI5wdHvNA04Qpx/i3cQOjTttP/hA1mDP0xQeRniNae+wV2Rokh8giqeVeVXP/n5R77yaJulbS5TgLmM0Ydz6NJCsI6m238Sv9MCMNuD1Hop9ToKwu2gNOSjmY2mx+dEOWhIspYnp7r/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BRnOkFZ3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708020501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hnmBz4W0WlRvmkbmmS8uJZWQuvZ3cJwME84PlXfuzx0=;
	b=BRnOkFZ3w+KDP7YK9KoGpprmbFGqZsJcREA5U4nBSO18Wh8xwe29tSRxo9tRkjEHmtE46h
	fgMdLojJpgi8Z+2yerR2XswhjB+7sEHiH9z1k4EwkWXYc9M8wleYeZQ9WZs6UXBy/eZohz
	lv0XEbWEZvn3Q9envM2Mg9G4G9cgxGU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-dag_HxahNNS4x38qtMvH6g-1; Thu, 15 Feb 2024 13:08:20 -0500
X-MC-Unique: dag_HxahNNS4x38qtMvH6g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4120faa1dacso5444785e9.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 10:08:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708020499; x=1708625299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hnmBz4W0WlRvmkbmmS8uJZWQuvZ3cJwME84PlXfuzx0=;
        b=XwY38rZhjhRTDZ4s05VaP6T70lnXxzx9+ateMKwS4opk7XFviEJs/PzGYlakSswPqE
         aCHg9ob0YH9lm6XrUus+vf6+rvN4gwCVyrCunzMctndEQhEhvLK0QgydM4HiPXinl8us
         bgDwcf5JRbUqHEuBu6+m/j+/ECIoXVZq3X6K8gYrT8G0J4KpzQEOcgRO+kyCq1DioeqY
         EIegK66tDf4nYuZvGWNCxhYg++4ZENi6H04JwDt60ZC5ossHgHYtGKoZiE2qvbxSr+52
         DmwYXExulDmAK9xPgdhUEMkzhkQ6mrnz6AZSopLj+O2rtgkN9/tWHgzWGQ2kBDNo9Wvo
         nsiA==
X-Forwarded-Encrypted: i=1; AJvYcCW32+RxgJ1wgJWwG/HoZziEqqGcVHMEfieZTaVZF+Mi5tTUsW2b1afHirWwj86KsE/aiBzV/BWB9P8Q2CIzi3NtlJhY
X-Gm-Message-State: AOJu0Ywz3q3th6c+CnfyWHKn10iQ5HMNFYVdXxV2qAucjNY7JvdQ2rRA
	LN0G9dF40K1LnxW9yTWadACmiyjcsZfZfhmTPh2BSkwcUjiE2WTKkVGJXYq9qLmDASuLy4IkEgk
	xcBFnfbwlFZoy7u/8ByviBXtVfd/bttEi+Tc4JgQVNmkrhfCVf07ZA3mjFZq2ZzMLLvd0fP9gub
	aW91AiXSdyM/VWMrYX93YIkrZA
X-Received: by 2002:a05:6000:1ac6:b0:33b:1bcc:7ed9 with SMTP id i6-20020a0560001ac600b0033b1bcc7ed9mr2414646wry.44.1708020499271;
        Thu, 15 Feb 2024 10:08:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGyOBx2D7FF89GxYJanOXARZNUqXAQM8c3U4pdS7RlP/P/IdLC8GDGRKdBrw4p6ppAf6jA3EKkXQjbhgdYesJU=
X-Received: by 2002:a05:6000:1ac6:b0:33b:1bcc:7ed9 with SMTP id
 i6-20020a0560001ac600b0033b1bcc7ed9mr2414635wry.44.1708020498985; Thu, 15 Feb
 2024 10:08:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209183743.22030-1-pbonzini@redhat.com> <20240209183743.22030-10-pbonzini@redhat.com>
 <20240215013415.bmlsmt7tmebmgtkh@amd.com> <ddabdb1f-9b33-4576-a47f-f19fe5ca6b7e@redhat.com>
 <20240215144422.st2md65quv34d4tk@amd.com> <CABgObfb1YSa0KrxsFJmCoCSEDZ7OGgSyDuCpn1Bpo__My-ZxAg@mail.gmail.com>
 <20240215175456.yg3rck76t2k77ttg@amd.com>
In-Reply-To: <20240215175456.yg3rck76t2k77ttg@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 15 Feb 2024 19:08:06 +0100
Message-ID: <CABgObfa_ktGybPcai=OgBbYMMvm4jS_Hehc-cdLdFoev68z-GQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] KVM: SEV: introduce KVM_SEV_INIT2 operation
To: Michael Roth <michael.roth@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	aik@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2024 at 6:55=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> > The fallout was caused by old kernels not supporting debug-swap and
> > now by failing measurements. As far as I know there is no downside of
> > leaving it disabled by default, and it will fix booting old guest
> > kernels.
>
> Yah, agreed on older guest kernels, but it's the measurement side of thin=
gs
> where we'd expect some additional fallout. The guidance was essentially t=
hat
> if you run a newer host kernel with debug-swap support, you need either n=
eed
> to:
>
>   a) update your measurements to account for the additional VMSA feature
>   b) disable debug-swap param to maintain previous behavior/measurement

Out of curiosity, where was this documented? While debug-swap was a
pretty obvious culprit of the failed measurement, I didn't see any
mention to it anywhere (and also didn't see any mention that old
kernels would fail to boot in the KVM patches---which would have been
a pretty clear indication that something like these patches was
needed).

> So those who'd taken approach a) would see another unexpected measurement
> change when they eventually update to a newer kernel.

But they'd see it anyway if userspace starts disabling it by default.
In general, enabling _anything_ by default is a mistake in either KVM
or userspace if you care about guest ABI (which you obviously do in
the case of confidential computing).

Paolo


