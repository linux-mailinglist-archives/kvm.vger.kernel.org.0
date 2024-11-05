Return-Path: <kvm+bounces-30785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 894DF9BD54E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07C8FB2323B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4EC1EC01A;
	Tue,  5 Nov 2024 18:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oKKl5MnG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1552B1EBFF3
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832426; cv=none; b=cosw7fNzrESrI24GU16XpBdyR7pl/hsJMufcvHGDDgMq/KFtNyZfQYeeXW/vrKVh8h0bLxKxXoEN/v+ytLd6a1ePC3f8pltV5IQ0/9Hwmdh/vR1e/tQh694ID3g+wlO0HxF/88RKfJcfyA7RR37hmRxLDKMQkgTKDo+Tm/7DI7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832426; c=relaxed/simple;
	bh=1Z9EfTcjCfWMv62LcDK6R/g7LO2Qr95lhNak5fs4/7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K2p6dnOhFmxuAE9sMkrxaEZRiFJVdvImw6YlF04aRuevgEJuY5bdtuUQR4bIZk+R9+RKPkesX+v3FbZx96ynJtdCoK0cHH2fURunYU53DanLKlDf0fHSBjlitI65qPVhwZIVOJq0wBsUfv9iyHvPVGDIXnJNLv/235ZBHnuSUnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oKKl5MnG; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-84fd50f2117so2024082241.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832424; x=1731437224; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Z9EfTcjCfWMv62LcDK6R/g7LO2Qr95lhNak5fs4/7g=;
        b=oKKl5MnGmbHCrYv3otvR8dX/GHq2Dda1hgJFhhUMqdizeUx1d7NhRbAAPWR6IvZbv8
         1lCFyYxqCks533Gj0bBT7+y7ovz0n1dsVYuOC/pF5tUldPFP8tT2TcTAqzOplLErybWH
         cx1FmiQ6oKScmhsNEBBEe93xCAmNtT8gHTjQtfK5HZzhqXzq9iOo0viK6PF4NizYm5R5
         nwZO61jh5vDstDXZlcCNR5lL0B63QIOXSo5Grz2BFnuu19gtS8mQ2KNvN3qqs6VIeiIO
         m1EJQYbfVlsQjTPOsmvsplVULCmeBaPVxUbLQSD03lwhcRV+gDKI0NIwGFVJ5SYc8pqI
         1o9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832424; x=1731437224;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Z9EfTcjCfWMv62LcDK6R/g7LO2Qr95lhNak5fs4/7g=;
        b=nkftHg2eEKpI4iMQcergOq9zH4hsdsRXZwpEwG0wnUpbo9ddYDdQI6C2QZNoJnWpPC
         oMPUtkKYaHfvAVUDqSssI5wBekszNRHmn4iiFxUPI6NeY4g2jkLkTwdHBctog1RfCayj
         7eitbX/eyJmxxYumDFRcVsshJioPLjkPiO64bSvkH+wWK2MYVFuR2OwPLIiTEB72A7UW
         Hr5DIeBoD+8shg8cfT2rLAbzCKitNtLo/ucePtfZlGwHxCNITCEfNPxJTet2/awmiFb4
         BQA/4cA/632FhFGyXPgzOupEVHp3c7jZXjNhaSjobrhsahrFsOh/HIRhPNbtVtCNJUHn
         73+w==
X-Forwarded-Encrypted: i=1; AJvYcCWXdmPFmVRgww+mIPA0XjO3Hr3MJiJL7xo1C6xNU4iNhWgJA3ILRvFBnw7waDyYOk/Xwvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpOV2sxc6qFiPsdONi1gwTHx1caHY2xxq62GnSlYffDtR8rI+B
	up20/aqCvn1+CGv8uK/7umZrMB9tr1yQuuW2kfR0ceBiUen50EDSfKn7dWpixNOBFN0wIybV4qb
	1ZmN6Pr7d5c6DUIkh0pdEHnhhoqfr7t5ddImn
X-Google-Smtp-Source: AGHT+IEY5tibKcFrB8ToC/jSQHEFvwYVcsqLc1FFicyOsbkwk/AWQht7QBcG826QDeUtW2YoJNXGx2q4B51hQDGJhdE=
X-Received: by 2002:a05:6102:2b86:b0:4a9:588c:6492 with SMTP id
 ada2fe7eead31-4a9588c64damr19015409137.6.1730832422383; Tue, 05 Nov 2024
 10:47:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-6-jthoughton@google.com>
In-Reply-To: <20241105184333.2305744-6-jthoughton@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 5 Nov 2024 11:46:25 -0700
Message-ID: <CAOUHufaKCN0SWk-QVmLG18m-3HH73Z4i-cogDxuXYsS_Tcva6Q@mail.gmail.com>
Subject: Re: [PATCH v8 05/11] KVM: x86/mmu: Rearrange kvm_{test_,}age_gfn
To: James Houghton <jthoughton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 11:43=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
> Reorder the TDP MMU check to be first for both kvm_test_age_gfn and
> kvm_age_gfn. For kvm_test_age_gfn, this allows us to completely avoid
> needing to grab the MMU lock when the TDP MMU reports that the page is
> young. Do the same for kvm_age_gfn merely for consistency.
>
> Signed-off-by: James Houghton <jthoughton@google.com>

Acked-by: Yu Zhao <yuzhao@google.com>

