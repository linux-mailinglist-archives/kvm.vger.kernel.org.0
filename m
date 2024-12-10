Return-Path: <kvm+bounces-33430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED0199EB568
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 16:51:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0285D2824C9
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A3D22FE0F;
	Tue, 10 Dec 2024 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fN/9fqdO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9174D22FDFB
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733845894; cv=none; b=VbtKv70iKkrz7d0yE2yYDMHDnqaqsPvksCODXK2AFJjVL+yGA4Zu9snwsWcSs2NSSv/P5CJLPhc64Tkfc4HXhNHLR+OwUIBAif4Pnz/OJMCtI7t6vwYRvBpNJuanR2Wu9a4TtVHnx5piDucKd6mshFqriAciSwkUELteqpdGbco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733845894; c=relaxed/simple;
	bh=6OaTMfkTA/OmgikKXTbbHwl/a5xyjcE8zGh1IgbdmZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ge3Kvhg8a4qrde9po3MhFH5at8kq//gl9ZjqNKG2+vQ4q1wC3wJihQa1Itn2FHpHiZAYq7w0lqdCdfwAUETg7PN6nS/FIGoQDpkdKK+sa5ANhAUyxjj3brKxHczG9MGXlLRw85reqUUwiIQvC1fqjvjZpo7DQ4jzQ9Uw1qvKr88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fN/9fqdO; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d3f65844deso3899867a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 07:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733845891; x=1734450691; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zGEWpmLWCQTndHxT5IXaD/UcEthKFp24ucI3TjyxNCE=;
        b=fN/9fqdOx11sFOJvCKTNttW74qrYlrwD/gvzbQx3wFhncOcoiUNgeytvIqGsHbiIlK
         ossHvH4lZhZkXQUoStndPpuX93lfl/d6IbiymJ2NwtLnlDRRCCnCdICpLG3TJaeSJ1JV
         VTHC0KtAYjDIU62VMUed8nXRhqBgjeeUBrhb4d9bDY9BWaHtidhL8mSidXE4eg7QkWW5
         SOg0bo71U7PgzFGdCeWacVKo+qx6GZvOJ8H06I2KpyQojFXC9V/lJKPzpyXo3UYsf189
         oTZNG/960+N4NWDoXvkp38rfuzQAjt+T+0gBIdZ9FNXV9W7eB2XAXSSN7TFUCwFjIdZP
         u5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733845891; x=1734450691;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGEWpmLWCQTndHxT5IXaD/UcEthKFp24ucI3TjyxNCE=;
        b=CqpHS5ok9pOvAt4U0SNXVyiJ6BsMMC8Qol12otPqpS9UzU7KU29RxogU/kWkByrNtn
         jCLM0nPNNTz0SEVi7GoRIzGc/ItBcb7vVbnN1veoNC1zTWHmZreVQZZEzqaS9/PVEg+9
         okmHYwvItYgDpHOwk10DWifxGTHP1m8rq8/EA7S+Nzfpa3v5GvHx24aEy69JOrsv0gt2
         gBQykW1Cq7cKjJD6XXaWMOIdvzzcy/Au0p5ByICFJRrOOu9icAN5Tci4pyHspnA0USSU
         dRS21k0oDPklYNAqGZVRfJETJn0gYbYtNR5gG9O/40s9i4yboboUtvA4WLit/sa9ZM25
         fwxw==
X-Forwarded-Encrypted: i=1; AJvYcCUVRIUX0xMo1ZzaGQjX4bsLBiO5hVVqg5f+jPS5Vzf0yuvpEB0Z+VlKQvJF0Tr49ocrR74=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqUbmFVCtACGlj6I5TwSu9RtqJDF72Y8sRTXWxQ44vkmXScMxA
	9Tr1XXseYtJBH3FnmkyodINfSJw488GgrL4Ja4QAOQrY/FgExMmq5DsolxwtL3GuQsCC8vYnfpm
	izs48/t0kRQ5/KLDhCBhrBgBI9l5c+M/HYe7k
X-Gm-Gg: ASbGnctBlMvhs3yUdLc5CVUhLSbY43ETLybQjvqlXeHSrd99ESVeGAExNQVRNHzW4nE
	LNrWVgUHclGrNt/8cED7Ih90BL43wO6tftbk=
X-Google-Smtp-Source: AGHT+IFF1pHN9/6GA3MG/iAI7uuToN+v40kN7CYPXNMCf19FEEnJNP06BgAyjhrlHXP7Ud+BFaLU9/3DxddZc+NTX3w=
X-Received: by 2002:a17:906:3118:b0:aa6:6e41:ea55 with SMTP id
 a640c23a62f3a-aa66e41ede5mr1256721466b.7.1733845890857; Tue, 10 Dec 2024
 07:51:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1733785468.git.ashish.kalra@amd.com> <d1658358fa8c55dca2f1869ef8a8475fc303e9c8.1733785468.git.ashish.kalra@amd.com>
In-Reply-To: <d1658358fa8c55dca2f1869ef8a8475fc303e9c8.1733785468.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 10 Dec 2024 07:51:19 -0800
X-Gm-Features: AZHOrDm8zaFskRC34t7dTi25zxHQFgRiXcLbUT8F8VLJriuZ2gw6c8XA36wtfvo
Message-ID: <CAAH4kHZCowU0FV4568P5C+pyv6T-9kL92qnMd2RTq+Sf-9j7Bg@mail.gmail.com>
Subject: Re: [PATCH 1/7] crypto: ccp: Move dev_info/err messages for SEV/SNP initialization
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

>
>  static int _sev_platform_init_locked(struct sev_platform_init_args *args)
> @@ -1329,8 +1342,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>                  * Don't abort the probe if SNP INIT failed,
>                  * continue to initialize the legacy SEV firmware.
>                  */
> -               dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
> -                       rc, args->error);
> +               dev_info(sev->dev, "SEV-SNP: failed, continue to INIT SEV firmware\n");

You don't necessarily continue to INIT SEV if args->probe &&
!psp_init_on_probe, so this may be misleading.

>         }
>
>         /* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
> --
> 2.34.1
>


-- 
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

