Return-Path: <kvm+bounces-8278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6C784D1DD
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 19:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E83031F25219
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 18:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A4E84FB2;
	Wed,  7 Feb 2024 18:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KY29nX3v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BD083CBE
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 18:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707332281; cv=none; b=gUTggEZ/jPVhPDhpnPl8TNIrE2G+FvTf9iTz1dlkDGzek0WjlN7G9de7/xa8PtXbx29aNw2se5jraA8TYdW7MtTg0zNbsft2smdOmaiY1P3mAAa+MX6gITYH4FDeQWpoECa1sFVtdR7wuyV5AzbM7F+YXVko9ox+qWU1asEx1QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707332281; c=relaxed/simple;
	bh=8s1FE+YRVuHP4SdIzI41sDhkZil2SiMwsOgXkAW8/qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CsKZbtcxDzzr0ca28XO90snzBtL6Tjq4gZdIfCZlLaQNLHjMZYQAl6aIWJWTl5Gb0mcFNrP74E214zINdpwOp8iIxVlADxmXgPYHR7OF+SDBMRhNsxonulefKoRY2LiLyKpq2TRxjZlUDGCn2FWMLJXg7AY22JScPoZkflKznSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KY29nX3v; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-59cf4872e1dso396822eaf.1
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 10:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707332278; x=1707937078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8s1FE+YRVuHP4SdIzI41sDhkZil2SiMwsOgXkAW8/qA=;
        b=KY29nX3vgtEcxYzAMlxbkupYgm+U5Hgx2c3csuvqwCAOzuf1Fqc4ojTMZKZ7KsFQg9
         aDlNcVvwNKVGyVl2hSUl8ePSyaKjeb/1DqxZVqRKDk/CiPbBBgiSlc8qM405fAcASO5W
         ovJCDCAOZu/17ca0mmeM6PHndb716XtN1K9j9oKAxMd71mJF0it3/t7/RVYiaKXoVIxg
         OqA9bVg5rGrSv35PXPPPjvfdNFf/HwTNxU2+3w68ZJtL32c0LOQFg9SWYKFJVlPKI0Jt
         Zomoi1/INK+3DVyI66oid5sgl7dhg5Svz0dFdtFZ2k/StGIhdqzfR0f3rs3IgjvyIJJ7
         qPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707332278; x=1707937078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8s1FE+YRVuHP4SdIzI41sDhkZil2SiMwsOgXkAW8/qA=;
        b=WnEfyug2N7oXXUs9APeJRLUgd1BHqQlCwauTrZr+yqXUu5eP+y/LhsStSg2dqzxFmU
         vHehwQmn4s3SvpAGitzoVuEU1hYY6W6fGizrwg7HD0SJUBgrvjgxIL6mI1Tqm1ySPg1x
         0o3GTPoRzxr7pR0fAH5/3AS8/iDAnESf8ntpt1HsoNTMp5IBMpUqdEZ9iKKsLXpd6TGI
         JtpwbCMYW3D1TqjiXk9U+81sCrSYHRBLAzBfxDrLUNk6KIJCEyFtRhsgwt/eXkjDvd/D
         mS8zllxIGdBDfwmqDUy5WPlCvAj1xMs9DiILuteUjWHAE3ziPj4KOB+APBk583552dVX
         QGVw==
X-Gm-Message-State: AOJu0Yzlw7pTTwtyikxP2tH9hRBEOgZYKqMa47e0i7UOGmjKd7k4Sl8h
	43d7/pj0xmhEH+m0nJ4c9jvfV5THSMkg4pQkJbt+aMSNYsTNIO6oLqI0i7ksjgxGvLxSUvSMD+7
	lSYzH1odrOLK0lolKtwv0xg+xd3TstKsFPJQu
X-Google-Smtp-Source: AGHT+IGD8YicdIIBCsyotLNK1A8/ICVi2B7RYMeG0O1LhRdYK2atxybYtkqqFxC0AJniSwuMzi9wVspy9PjeOVVqiug=
X-Received: by 2002:a4a:2d09:0:b0:59a:2817:1533 with SMTP id
 y9-20020a4a2d09000000b0059a28171533mr6012945ooy.5.1707332278646; Wed, 07 Feb
 2024 10:57:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-5-amoorthy@google.com>
 <ZcOiM4O-oPcZpeac@google.com>
In-Reply-To: <ZcOiM4O-oPcZpeac@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 7 Feb 2024 10:57:21 -0800
Message-ID: <CAF7b7mopsU7zGy2RbRMVNvmF+fwsa2BL0kXvwHjC1niHbDb4CA@mail.gmail.com>
Subject: Re: [PATCH v6 04/14] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT
 RWX flags to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 7:31=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Needs a changelog.

Urgh, that's embarrassing: I'll use the following absent any objections

> kvm_prepare_memory_fault_exit() already takes parameters describing the R=
/W/X
> nature of the relevant access but doesn't actually do anything with them.=
 Define
> and utilize the flags necessary to pass this information on to userspace.

