Return-Path: <kvm+bounces-16899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB678BEAB2
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 19:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 704D4284EBC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A5516C85B;
	Tue,  7 May 2024 17:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2BJ9+/RY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC4E16C841
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715103541; cv=none; b=mbk7QgvAteLK8tU1qFtuc6ilMeqmRJBuMkEj9Yo4+B2SBM1j6TbYNkhgI593fiV18RiYFMoIyn4boSi+dDSaJyaaDu0/fE+ZMvNVQOYKZl1xi2Rvy/8rezasXxGpGe7S8K5ixsnjxWYSpBkwoKg0U9PdqNlZKs7uy9FkJE89uEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715103541; c=relaxed/simple;
	bh=WTjXTy7wqZqLJ2IOdQbN/WBzFAVFvlAg4Ue04sW4qjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H+SmNDHFW73IC8jCDsQWCY2gcqicfLyKpWL+jqtAkgL9YtyDkqztZ6pVfE9AnA0in2rPcU881y8bXkY/O7k2MPSk5gptf8OFhFUEeEi57+6D8Yle2IKuwzVId5PUfxZJbJPkEZKg+ykrQUDfZZ0qVypWhiHA7SXcV4wVrJLvCXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2BJ9+/RY; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5af03aa8814so2387550eaf.2
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 10:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715103539; x=1715708339; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fAE0qBIGceUphb1OEYQYrxoiW/szPAeOPJX2oKsvSeo=;
        b=2BJ9+/RYjV5WLX7N5O5L/WUDGZ6O7alaQM6NQkAyuebvIqgGQDvB1WbyqDKbCZGx0y
         YmU6imR8AvmCa9XFCkTCZHi2FFJMGuU3m8q2fu8yeBgi+LCWaXefFHJ8qsg6q2IOX+Wc
         LyAXg3cSJfObYAZwnQpRlszsYK2kapS7Dlb14wHMuFY3RsrQZnirNt+9ewODQa+Z0fvf
         JyqcltRsetu+4y9wbdBudndSELAq1d/BZ5AxIQqa5fEdWud6mUDIHiwEXQcEjjm9pfW4
         ksi/c2pYXuAaEDIvWHEqqtl6VgTMRUn4STf+qzaQfgiXn6ndwv/leyTPMDKCnhhu67Vl
         ZMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715103539; x=1715708339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fAE0qBIGceUphb1OEYQYrxoiW/szPAeOPJX2oKsvSeo=;
        b=aPzOvz6CTeJiRzYRCjDskMdpUofQO660BcNg0xhv+3I7rgP9hsbqGqJm0UBhA/3Zys
         D893fPs9JX80zTlnjvlOnKM3GwoUhiSDWipZX08WSDGMzDBn9uVBF4fwRCGe0pHs1/Xk
         pGQBn56KDGpccU+j8wpr3LF7fiCVxVuxbRmLWLwVQkwla5OCz6mZ+uiVjLJGLUZDK9LD
         4WCzUro6SFGV3gpSTiaXMV5hO/ETGKyzukg8Z0fP68a9ouiHqld0L1Ev2dar/QxIVbus
         IMV85Joim1IwA1X5zjOo2ILpjIoXfu3YKVtcVKo4W/tHArBAzKVtnlvDebPdRG3UC1MU
         IVFA==
X-Gm-Message-State: AOJu0YxIc35osyDjoRoUMg79ScMcLRIGgbgXPN5MQUw7t3s08Q7Ij7UX
	9fjqS1N6xCbH1BerOmu6BT2xzcq92jHuzPrpx3HNlLFt9sWoFWysaQrZVkDa2UAy6EdRd287CQ5
	p2gYNoOUqQJuJVUbNZG1oBwX11ZekQimgST1eAZeHxLBLY/4IlA==
X-Google-Smtp-Source: AGHT+IGOlj4f7H0eIZnf/AAGA9xhg2BLPoln8xEDIp7mRv/sk45u89q1Eyh+xEgyT8jUF0RWxzhDYUEy7gHdOcN46XA=
X-Received: by 2002:a4a:9893:0:b0:5b2:1095:a58b with SMTP id
 006d021491bc7-5b24d738d30mr139010eaf.8.1715103538716; Tue, 07 May 2024
 10:38:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <171270376781.1586271.10159724514702496320.b4-ty@google.com>
In-Reply-To: <171270376781.1586271.10159724514702496320.b4-ty@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 7 May 2024 10:38:23 -0700
Message-ID: <CAF7b7mqg5J54CjO6bDsRKvLQ49rk2xcerf8GYATXyd8pHanY9w@mail.gmail.com>
Subject: Re: [PATCH v7 00/14] Improve KVM + userfaultfd performance via
 KVM_EXIT_MEMORY_FAULTs on stage-2 faults
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 5:21=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> I skipped all KVM_CAP_EXIT_ON_MISSING as per our decision to hold off unt=
il we
> see the KVM userfault stuff.  I skipped the docs patch because it would r=
equire
> more massaging than I wanted to do when applying.  And lastly, I skipped =
the
> "Add memslot_flags parameter to memstress_create_vm()" patch because it w=
ould be
> dead code without the exit-on-missing usage.
>
> Please take a look at the selftests commits in particular, as I did a dec=
ent
> amount of massaging when applying.

Thanks for cleaning the commits, and for all the help along the way. I
just got around to checking the selftest commits, and they look good
to me

