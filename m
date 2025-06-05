Return-Path: <kvm+bounces-48608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB40DACF8E9
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 22:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CF043AFE99
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 20:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E67E27F4D4;
	Thu,  5 Jun 2025 20:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uto0J2cr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1A14B086
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 20:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749156358; cv=none; b=XG3crwrB2ae7hdu9OUMBPfWqa2oqUbtUIGwIPiJ+Ann4MhRwtcrKNqQoALi5Hec7rlRzS9NMTqYDx1GN2cIG1on7BoGmnN8+POEqtvuRvuIlRk9ZNQ4XQIYalerTi8a87VqQOlYkP8BR+rx++L8NzqMRNW52gJv0z+zYjpkjkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749156358; c=relaxed/simple;
	bh=41UcQNF0NYZ5vOdfYZCJxGjidjDGnId0EGj2effOi6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UOBxpPGkL7nfYlXumiJ/wTQFLcNrliqTnIzMYgweD1KKKKb9f5BwNFHJA9xJQpEki6qqObfo4SEY4IpnFPGBuQRGLsLvyt5koka89OCik4DDXUbBgXw8/Jw4jMblWIPL/8W9sP4OAcv7nAadisQ0h5wqBqgO+k21h5aPjbY5UXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uto0J2cr; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31223a4cddeso1103297a91.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 13:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749156356; x=1749761156; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=41UcQNF0NYZ5vOdfYZCJxGjidjDGnId0EGj2effOi6I=;
        b=Uto0J2crCljqqfmD0qaUjZU2LNhnL6XiHZpL+RugKPP0fjsCuF0KsergQyKvfVRaj+
         FapgbQ5ZN2oAOI6XCmrsRvjFYl+zajtr+6wTp/hpxOBy/MDbDOMQm3I7sVCSG8cqJ/Ht
         es9hMeqA1V0sjFeyowy/5/pKNs3TQHtSpfx6Ety6lD7xsvudMNRtYp/0yrpiRy4m7yCN
         +ujpfkNUZouivGsfVxbVfp7XhnqY8Tm5P1u/FWuW/4r631UkIDDouNzRm5TarsHLq37o
         +meyQggTLgqF4XMmA08u3PoOWe2xQD4aV9ym+a2247nV07/VAVtoHrtABTmMbsLRYdZh
         JK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749156356; x=1749761156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41UcQNF0NYZ5vOdfYZCJxGjidjDGnId0EGj2effOi6I=;
        b=ppf65kFrBD9V28AUx94QZCuEthat7pohP+bszsr1ABKy8P6D04hAc1gbsulS4a9QRD
         IX7E6ImCJfv7LKVyn5HxUPbKUZd0M2v4VpCgV/V0WKQXXb+yjGDq+kMyJKjTjd4CjDn1
         VutbkiZyRef1yd4T7Kb7QnyO7EfRxLPiLnpVgyGfz60ZTZJHS/oh177jG+OGN9N3sR7F
         OcjGkgXsHumeYsCslAD6fLyK8HKYM2gfVtvR5OWEr1SM1RI6j0xaxqyFMQYePWTL6YRu
         ZcwqINuWNscEjrMqYWJAwpKp56xf51jGsIyl89KBy/Gsz7x65lnVZbefadETFdhS8jRc
         8CvQ==
X-Gm-Message-State: AOJu0YyCmwpteZx/qGSAF9EiJRNIrCk0tw3UUU07DTd4C5E4lpDNsT9k
	Ykp1YzUbNBEcLfbpIBzcTi3DiBYHJFnpf+7FLer5dSgVp0Ta0GLUkAPNrrlScp8BC2pCDvZPbfZ
	8nXdBiYlDpuYHxaLCNhMGA+udvg77Lq5Exrs4qnbY
X-Gm-Gg: ASbGncsUj829y7MEzIn71FnlCnNBbZx1Ud+0d/J9699wVXzAT/rFrmEIM926OwhldG9
	f5BJuN0USslQNTbOodKshbJLb3PlL+36nOI9kmvdENSIKYBbhSn0G+zeEgqti7kXqZqBFjCUKc5
	H1WY0T6npkhKAIfpkZ2XrjbaWPbJ7Lg4HnEJa59YYAjh8jVmQZzZDwAH6HVmcPOY/p8xWLk6Kii
	g==
X-Google-Smtp-Source: AGHT+IGQEyQ7xC/2gN7AR6mQJWZcHfKlTjNOFZ0aNJuMVhtq7C8GdNK06ZCyXnyWEhtqlam63k1Qx8RM6OmlrSSS9Dg=
X-Received: by 2002:a17:90b:4b4f:b0:311:c939:c848 with SMTP id
 98e67ed59e1d1-31346b44fafmr1785689a91.0.1749156355425; Thu, 05 Jun 2025
 13:45:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605150236.3775954-1-dionnaglaze@google.com>
 <20250605150236.3775954-3-dionnaglaze@google.com> <b6b9b935-c5fa-dec6-ec82-56015b5dc733@amd.com>
In-Reply-To: <b6b9b935-c5fa-dec6-ec82-56015b5dc733@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 5 Jun 2025 13:45:42 -0700
X-Gm-Features: AX0GCFvw6StWYSjYMIhscpi25Cgn32D8l5h6WrL5Hb03D2NIE4-XGuR2mkZV11Q
Message-ID: <CAAH4kHaeMgzdNP6Y7zdkdODransNkP4UiQ8ROpCVgenpiveJ_Q@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] kvm: sev: If ccp is busy, report busy to guest
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 12:15=E2=80=AFPM Tom Lendacky <thomas.lendacky@amd.c=
om> wrote:
>
> On 6/5/25 10:02, Dionna Glaze wrote:
> > The ccp driver can be overloaded even with guest request rate limits.
> > The return value of -EBUSY means that there is no firmware error to
> > report back to user space, so the guest VM would see this as
> > exitinfo2 =3D 0. The false success can trick the guest to update its
> > message sequence number when it shouldn't have.
>
> -EBUSY from the CCP driver is an error, not a throttling condition. Eithe=
r

Ah, okay thanks Tom. I'll drop it for v6. I'll see how the first patch
is received before cutting a new email.

--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

