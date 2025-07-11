Return-Path: <kvm+bounces-52099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F29B015EB
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C36BC7BBC4D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2BA214A93;
	Fri, 11 Jul 2025 08:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="KEfBDueQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F13212FB3
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 08:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752222362; cv=none; b=J3kVuG9Bp8sP7TANx9AzdTTEee1PPvnvzPXFJMtauUIeqF7RzPwbm/FCTnFNSiFPxOFs0o9ETT4INXEWFFhX0r/u8AUspMX6Tt9ZUlRbQ6Qq0znuF8osp8rlTWP4e8E5MhDpiYYKuUN1cfSvQYA1LI1VaKu8RC/m5sqm4oD1faw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752222362; c=relaxed/simple;
	bh=0bP+GByP/BRW1kn9Hg79IzJwx8Y/oExKL7f3IGwumNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hU8mz2a2rkI7RKRTjVTCYmHbUqqC57SnBJDrhHwefA28qSZk9/sFF3bDZPdLuk3LtBuvTwhjgJ0R3wxdFXP6/lHwgKem4f7I7AcID9kzvUb2X2zt8yLK7KN/8TNQ3eU5zOnU9XNGz1yGm4Ua2aPnlm/bNV4aH22g4wwreHoQwjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=KEfBDueQ; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-311bd8ce7e4so1668359a91.3
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 01:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752222359; x=1752827159; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/A2fAk/hY+VXgln3RIT8cl3wcMIkArGIQeZSyy9BGEA=;
        b=KEfBDueQbSoC4ezji2EHMb8tSOD/FxNAa8e8LZykAc84CM+6tSHfPtn07kh1z/kWLk
         SHSwrVDm10L2e5ZHLhfrq7ovQA1ZMvr9hx8vmBipmoVIivEAmJ3wcOrwiE05VEiLd2Of
         +3JakFla9Qwl6F0LrbX4Ayszwpzs69vTAWdd3NMU+NPZokpf2ahp18om+8fzHZ42kKA4
         7xLJbvDxtZ3WdOeRAEpDog3EeOOySsW+87B4vLddDM7dlnPTkL38diDRUiILvnp+2LYq
         hX+3EE9ElUawcgkHGW82QDCrCgbaBcEVTTQCdVi4JD5aBiHezv8ZUxHF2tIpFaSSHWc2
         BwiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752222359; x=1752827159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/A2fAk/hY+VXgln3RIT8cl3wcMIkArGIQeZSyy9BGEA=;
        b=rVhaWmiSb4/hTIzG7ZIC0kI5z+lspt/xUbcRKrPAswhKhVyFcDIXKhfFmQuVCwwzdd
         mg2pNUccq1JatGGEl2z81dWmLa4LLhVy/f6s9tWIQOPV/onncQZVq26SzrZPvHLNEfkd
         stsY4eGl4e3aofoP10Jhn/ohN2gxuPKmGlLLkd7Tz9l28O8lEIcO6RUyN5MWJ/MoJQ5X
         DJW8M+D4zSWVxOsoc6j8c5pwmdpBiTNnx++/XSfAqyKgIoyDtDPT4gdrlutO3mm+JsIP
         cIAtAPphYclTYHd0ilkr87kNj1NLcmP7Bd1iEOpYJdTtc0YoZN20BsGik1lZPkZZTs6T
         hD5A==
X-Forwarded-Encrypted: i=1; AJvYcCXvusJZjN3nDOs+9DVzfEoGM4Ml8hGhAxSOIJQ8NfTgPiQArYkPoKzF1cvLgnFcYKv4mUM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1mTMW+LhD9PgNsy9i8NQzQuI26NY2AEOHlDsGuNkMkM1t96/G
	KDDgciV90cT48GOfw/iH7gao9MFLLRklUFMsOxMHPlCmITcc9GsocF/MTcYIb9QRE0YWGlCt0fp
	D5QHiZjjqlUv+z+zhHaVK/Vz7ExIVWoZ+IU92Q0AzaA==
X-Gm-Gg: ASbGncvn1oGcSjtH061rqZF99mRFQqfrpJvexubh3PM9yk5oNUosVNgn9c/uQsGks5N
	x+0yzmcVFx1edgZnw4FReVslQjUQAGJP8ciJSUi6TMu70saYcfL+8kB5XNlIwiqD1KHgiuoeAPC
	7zhGQK+LJSw1A0pDNJHzsPkHuM/lmYgvnkIBiNNVe6Ph/EWPtTDYUR8XPXju2js/MH/kp8joO5Y
	9wPGhb3VMfTy+dApSjI
X-Google-Smtp-Source: AGHT+IFCp1pcD9GmdtCsf5iRMPFHSbp9FsiGavSusUMyRrFKZGE3x/NS3PMLeRJnScYqO8frgAwfK8U/bj7U7Muxpzw=
X-Received: by 2002:a17:90a:d88e:b0:312:959:dc4f with SMTP id
 98e67ed59e1d1-31c4cc9d4f4mr3742093a91.5.1752222359484; Fri, 11 Jul 2025
 01:25:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710133030.88940-1-luxu.kernel@bytedance.com> <DB908AUW6N76.3SYAGIFGCDJ27@ventanamicro.com>
In-Reply-To: <DB908AUW6N76.3SYAGIFGCDJ27@ventanamicro.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Fri, 11 Jul 2025 16:25:48 +0800
X-Gm-Features: Ac12FXyVj12e58tShQlG7C9K_6PvavwmURsMwnmPFZyguWbVaWs8xpiRLy86iqI
Message-ID: <CAPYmKFu2Ggu7_SFkrhfKX9rT7Pdas+jSjksGMFAhHf7Wa83Y8g@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2] RISC-V: KVM: Delegate kvm unhandled
 faults to VS mode
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: cleger@rivosinc.com, anup@brainfault.org, atish.patra@linux.dev, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 2:16=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-07-10T21:30:30+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> > Delegate faults which are not handled by kvm to VS mode to avoid
> > unnecessary traps to HS mode. These faults include illegal instruction
> > fault, instruction access fault, load access fault and store access
> > fault.
> >
> > The delegation of illegal instruction fault is particularly important
> > to guest applications that use vector instructions frequently. In such
> > cases, an illegal instruction fault will be raised when guest user thre=
ad
> > uses vector instruction the first time and then guest kernel will enabl=
e
> > user thread to execute following vector instructions.
>
> (This optimization will be even more significant when nesting, where it
>  would currently go -> HS0 -> HS1 -> HS0 -> VS1, instead of -> VS1.)

Nice supplement! Thanks.

>
> > The fw pmu event counters remain undeleted so that guest can still get
> > these events via sbi call. Guest will only see zero count on these
> > events and know 'firmware' has delegated these faults.
> >
> > Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> > ---
>
> Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

