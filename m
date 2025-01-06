Return-Path: <kvm+bounces-34628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6541A03052
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AA981883DEC
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 19:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B441DFD80;
	Mon,  6 Jan 2025 19:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GTK5aPRC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451CC1B4F17
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736190902; cv=none; b=Dczaw+OroBmQQHLfcgH9g+CC+FjmT4cMthT8X4LO59Dt+vpewKCGUw+f9Uo8CmmgMJZAoo8vmQPTkr02ol0bJws6rqGsXFSbItf7bNkuf1f/FHHALVwCWl/rGmmrIeUW1DL9ns7QPw+VQLFvbJ+Q5fwgeYuYfS+H/h/VcYNhUiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736190902; c=relaxed/simple;
	bh=pWFPI8QJJNsIr4V6BgsoBxzzDcG87tMmwTYxt6RmSrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDU4TFm1IT6tinaEpkvtCF43yrXSHEa/2om7TO5JQJhKfegCtpxSjqhY1CN48v6b/8vLT4iFSDQOAbydCnElg9V9Tz0tTJmQPmwsgIEkTsfqW9tBxshxyWzv0keSsrD7n5gDHXWyoK0nSaKS/9gngbiMyzTJSHhZWxA5lOMx0h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GTK5aPRC; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso1686452966b.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 11:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736190897; x=1736795697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWFPI8QJJNsIr4V6BgsoBxzzDcG87tMmwTYxt6RmSrU=;
        b=GTK5aPRC7/cKa7+d33MjPm9byv/K5iGH9IVp24QrrWVsu1X2HTgeaUUya1ubVBDeqN
         JYVZR+T+xWLjMVbzRTLWczvGUd2N0DT0rSimEJ7JzT/CxVFMz3roXDXLWRsyiCtFDu0j
         isLHXZphsdxfEMP7o7WABVPz7wPoe7Ar+Bt+Jyl5CHt62Ke6PEcwg9lRNkxMzl0XGWla
         qboaovGoZ2GpLzTHIPA6Wdq7TyractE7DNIvF+k1BNQnyj6LF5oivuLWILBBXiswwQmp
         bhbru+tBSFDcBIeoN1WvSdj9jjmu1L69XBY0XZahwwDHnrmjMnOvlxOJAcenNy5KL6DG
         gCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736190897; x=1736795697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pWFPI8QJJNsIr4V6BgsoBxzzDcG87tMmwTYxt6RmSrU=;
        b=k4AxYIUPN7o+RNGb1y08GjhPb0Irxn3eB0TxI00yRrrPaPDXMHFTeN2YJVuzoejJBU
         nasBhvUtsU8P8bGOl8+rr0b5fcldeRqvFQEBVd8RGAqEOBhbgK7rsdOUZMbwyAViaxyn
         MM7nWml9TTsJsNEBXp0Pu101ESnMxUamxPFjCoJbNMK4VSlrYTqMtBlFPpJax6HeMWGA
         tu4EA+yhey5eQ8TT7f7od5di/QmSuCy/G3mj7mcK9MYzI8U8AoslVoqImADQlIVTbjY7
         Mpd9gWF3W2mjP3MRHOLFR5Hh9EA9Gk03j23Uu582Kn7epVzZsrip6UoUXncRC3hibQtp
         kpoA==
X-Forwarded-Encrypted: i=1; AJvYcCWdd1h327BjKsPLw5fv9ZPtUU707FqUuGi1YaiHDzLCsmrcggVtJgvFu7NcDd0VEGbmMJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGe5BjnaJ7xRs4g++TWXOrKUX17ko5vrC27n3ZKZDw6d6qNJir
	qxYqzJMSRry157CL5bS6yH0AkL0Mz3MG7DAvfd45O1HfitUyXRJp1UZ8BNfwaxtxDfDt5mf04kl
	PCvNLW1y1khCed0vBlFlJ/lYctMUpsaPlXG9b
X-Gm-Gg: ASbGncvF6qz4xgEzliFe7jK4kWuieIWPuT9fYPC23Ln99r/80Fl9jz+HBkLX9/AaRjf
	uUrmtZKkf2ZigagW3w74grbqb5cijkVDayt8rhNY=
X-Google-Smtp-Source: AGHT+IFQF+5hodEi32H1hrqQbRqo4lGqqJT4JUu9venDeqnG5Z/fmBuRxtxtizB6jozSHAAECXR5Acsg+MTVa4cBYlM=
X-Received: by 2002:a17:907:8dce:b0:aae:df74:acd1 with SMTP id
 a640c23a62f3a-aaedf74c300mr4344217066b.11.1736190897042; Mon, 06 Jan 2025
 11:14:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <da32918b84ad6d248a0e24def7955c0912c9cce3.1735931639.git.ashish.kalra@amd.com>
In-Reply-To: <da32918b84ad6d248a0e24def7955c0912c9cce3.1735931639.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 6 Jan 2025 11:14:45 -0800
X-Gm-Features: AbW1kvYLvnLWYWHAYDSxy7Fc949x5JRieReC9MaIJohfifoZer-rKc9QHEboxOU
Message-ID: <CAAH4kHYsK8Uc2WePxfpPm=hwCybrABTjJ5Cw8rRGJ8UyAyE3Vw@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] crypto: ccp: Add new SEV/SNP platform shutdown API
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 3, 2025 at 12:01=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com>=
 wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Add new API interface to do SEV/SNP platform shutdown when KVM module
> is unloaded.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Dionna Glaze <dionnaglaze@google.com>

--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

