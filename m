Return-Path: <kvm+bounces-38725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25FF2A3E185
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE8138609B8
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 16:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F05721506E;
	Thu, 20 Feb 2025 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hJiFJOz1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF2B215068
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740070069; cv=none; b=gYD1J26lFqHp+CNLta2ebyE8GbcIZLPvIZBAEvMb0etWnsS2z29q7p2TqxNDTyqNgdGJjIGxLTIF0UfBFCkrtLTv5ccnUvq2MfeGFrtxbKvRCRkgICa5TlzPGbwCnfIWsJL6yj1lrSt5gJ+t8XCvRgj+XlK/QNpDM8Wu9zMVXQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740070069; c=relaxed/simple;
	bh=07JJww02mJEeGAIuugM++K4ebk2f0Zd1D+gq+CAzgrw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G1vsizXBYfOVLCDON5NmzpTjL0J5tYacKzAu+7AtqqxwVQlLXFHOK6UMUs2LaAnlX6HG/HnDlblkeyhrg9nBy7hP+NJoV2UjgJ85Shgd3Qf1ceM9HVWXsKYZGUc+/Pc8dyQ2YjIuOcPohMnmkaDXKGgEAQ2b3pcbuJUx8NZko0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hJiFJOz1; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abbec6a0bfeso194295466b.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 08:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740070066; x=1740674866; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMCL0K+C4GnoACxiUHOKxAWwwUOoQfv8+sE0BWNTm14=;
        b=hJiFJOz1JShB+VnREeovIKatKyNjUVHontVUJWpZhTgRTkn/pB8jXLk5JHX9q4Hx+n
         U58F9Zldims2nzb8QnK7oFwn7WNDUMovmbUyyCxmCjDhQRokg0zk5PJUftXgatLNO0oV
         BV21I+W0vTzH2SUYSAi5t58Pwl3bVgZglaHxbAATfoDCKUwBSAYfQooV5J0JYWoHDvoy
         rAIm1VyZq/6iByBpWEcFiZXmoK3hCla/xOC3FCROhTtkQHb2v1X3WZxcB4V3xsPv04aI
         Fy/krOjREEjAs874YLRctcWG7va8YluWCm9hk1JNS6T2V5xUmXNb+OU2C7cBfkz8R9oL
         SHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740070066; x=1740674866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XMCL0K+C4GnoACxiUHOKxAWwwUOoQfv8+sE0BWNTm14=;
        b=iZP0Y5lUXGyCrq2UaTshaZ0jgb4337aE+asMavkxMP6olRtLIAH5LdX1ZzVWBa5KI2
         f7iYI0SlxdErRFE0uRRxQN44R5oHTybjUgggS0rnI612YFg5lLwj8R9NxAzglu7SBaRH
         EoYYjMTIHfngOGBqtJOwimMtexOWHBfpyMS8oFvhvEn0unyZFcZgGN97ABPZ1c8hLgIA
         aQXNdDZ0Ag5GA0H9KuqoLxvuL11IzSdWdVLjbQ9p4+0WCX4M7fA06u07Xi366X1uRH2h
         DJMSnPSH7uxQs5GhmAmbtk5lgCqWlRTadcIKo/5FIv+D21CuKPenltqx82bS3VhAOKOw
         6Keg==
X-Forwarded-Encrypted: i=1; AJvYcCVCWc/FF3/WzNx9dyFXNPWgr1QUv1yMMPhUoMbv4j2n+RM04xroubJWqLEmxtf4643Q6DA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkDzYdQ/pztwVVbTkEPTjr52i76XJFjtoOT/fgvhLiqiLzWq2B
	8qKlUJWvIkYwOD2IfW/ld9UV4EhGg0mg8H+XdjnajnN6cChKvmxC/5EN/4gPZ+c5GfTw+yX61PD
	QKuckLGL5P87yqxH5S869EF5s5v3CAP5BrX/f
X-Gm-Gg: ASbGncsBWbSbpUcWMcMV5JvHrlJkTaY3UvPxaRxUYQSZI3q7HpKVQYtSttFRyK6sHDR
	f60qJr8Rayt9hiHedM8/hRuZqQGenFsYjmlPtzp4VdkYpkmIfn3wDLQvOCUE2Xa2o3ene164P
X-Google-Smtp-Source: AGHT+IFUN190VqKAbunKFBAi3FWBdH/R347wkO7ytCt3scT9na49h+zVGgXkcRMQmFGqWpBuREc1IPIa560YC5Jlbbg=
X-Received: by 2002:a17:907:7ea0:b0:ab7:d361:11b4 with SMTP id
 a640c23a62f3a-abc099b7f3fmr3875566b.7.1740070061123; Thu, 20 Feb 2025
 08:47:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1739997129.git.ashish.kalra@amd.com> <e13263246be91e4e0073b4c81d4d9e2fc41a6e1d.1739997129.git.ashish.kalra@amd.com>
In-Reply-To: <e13263246be91e4e0073b4c81d4d9e2fc41a6e1d.1739997129.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 20 Feb 2025 08:47:28 -0800
X-Gm-Features: AWEUYZlhHlxBHBWrZcmEspkPqwgF6rKQ9OpK2K5xOYbvc-va1cUZOfhJoJDPwGc
Message-ID: <CAAH4kHZsC68+QPC+y-pycM+HfsLF-f_AuW8eZm-Dqqf5meFj+w@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] crypto: ccp: Reset TMR size at SNP Shutdown
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, michael.roth@amd.com, nikunj@amd.com, 
	ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, 
	aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2025 at 12:53=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com=
> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
> ensure that TMR size is reset back to default when SNP is shutdown as
> SNP initialization and shutdown as part of some SNP ioctls may leave
> TMR size modified and cause subsequent SEV only initialization to fail.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Acked-by: Dionna Glaze <dionnaglaze@google.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b06f43eb18f7..be8a84ce24c7 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1751,6 +1751,9 @@ static int __sev_snp_shutdown_locked(int *error, bo=
ol panic)
>         sev->snp_initialized =3D false;
>         dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>
> +       /* Reset TMR size back to default */
> +       sev_es_tmr_size =3D SEV_TMR_SIZE;
> +
>         return ret;
>  }
>
> --
> 2.34.1
>


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

