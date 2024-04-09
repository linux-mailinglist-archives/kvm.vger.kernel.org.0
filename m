Return-Path: <kvm+bounces-13955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2B489D033
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B040281DBB
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C706553E36;
	Tue,  9 Apr 2024 02:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3xVc3XOO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903AE53E27
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 02:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712628201; cv=none; b=S3EWWnv4e1Wr9v2GSRojAn2mW3DjNzFdCiJlMofvYmIEMv3mukqSpq6A7ECfIrDBqoeNLHqa25q2xc45Jt+yZnsNRYQSGmcF6+XIp4ds6Eand8KeVx6VJdkUe1hg9ov6JkecQHJcSDZaF4TeYPyhrd0dRMy6vvRwwy/2jPzgSJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712628201; c=relaxed/simple;
	bh=+LLDCHLezs0EGedpkBLwh6u/Zz4T2kSvgMjOzJ7P5jE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pFTTOkAni2O7lZVFpLmh39z6j29TXYbt83ljJ8escqyJrpdRV3twESPY6LoiifrDj/kxUzhWyS7GsH6XOjw8sEOuukzHVxJHUOuWRIDnCVNx0Uvd/0N09WNsQlrgZ1ZgDMMlShmpO6Bj9dmm1Bk42eMNXV7vb9hTqYisIOF2H58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3xVc3XOO; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6167463c60cso57655657b3.1
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 19:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712628198; x=1713232998; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a8WLZynPbgXb25toZrvDhnaP2IALB+HAy9KN0cLvc1k=;
        b=3xVc3XOOdkavuhT2gsLiXm6H1YDbU2qOrlfJau6YVBbCsPYqrlBjlamrsgKK3fY5Xb
         FMHlpznK0MiyOjhy6FfsNMY31wcguc3gcnBGUokPTPz3R28+AefEfsrAz0ST6gDI/8JC
         EhbJiC3KMPx2r5Kra3wa2VcJtZ1bHR8m2f2cu8qTma0pRMobzSFH9jLQAkmlDkobbxvu
         /Tv7o+nS+KcV2h+zloo//bgS9cASwzDZTcdgMcfAfJC7RPMNE+CHSO8u3amTGVv+LFjT
         f9VWX8euPNcI3H3VS1FFAhSdfBNjK+oXOblFtx7R22uHV3QNLuswj4AwnZyG2A9EUVh2
         ndJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712628198; x=1713232998;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a8WLZynPbgXb25toZrvDhnaP2IALB+HAy9KN0cLvc1k=;
        b=ACKGvIPCTMZNPhpiwue7UGarT2boTthglRrW0js5CSYltj+Ts93zJ7BPYMctJ7216V
         QD6R4M2Uhtu892DRTb1DyE0I8nESBNSUnmmN+dBLCo54lPfYb/JOT+pRi5BtWpY7czpm
         izSVsbjAatD4G5ia3/V/IBOAlu0reWImxI+OW8JWJ3gwoTtQNl41eTK9CeeBuMz1sFFg
         E7Jk6KkFpGHeXKn6HwVss+zua1MuSG5tlqFBdGvrf2PI2wiJHyG4GkKW9rQ8kxmW5/K8
         AYx0nqlaYvia5G70ECOVXWXJ6Z+JsqgVznU1hbnYbsyQtMDitG8mYwZYBVsXMDQMsxCe
         WttA==
X-Forwarded-Encrypted: i=1; AJvYcCXjiUN6shRHP+vb1MJq8NR2Gy1TNz7KAdLJPXE/ihZ/0WiYojLXIG0gPLbIA5ucwstiKLBngZ0yYTqKuo9fuWP26m8Y
X-Gm-Message-State: AOJu0YzkFdZS8LtxNWcaNnf/uOBctDqVBS6q7piadvSJnpHmbjwwp39K
	5W+Pr5DCqeuSNRWuNBzG+YJHzdEH3ex6T/3yf4XRncn4Ao6CL+ue7bRfmNszRI76Wjwgfs5iEgb
	/BQ==
X-Google-Smtp-Source: AGHT+IGPXieYHtDAt2SqxM3Qfme8vl3b7YPnxUoyjt1tPcU4Pj4Ds3k4xlRa7DuHaFn0LHoEJ69yU+zC1gw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4f55:0:b0:617:f34f:758e with SMTP id
 d82-20020a814f55000000b00617f34f758emr292996ywb.2.1712628198620; Mon, 08 Apr
 2024 19:03:18 -0700 (PDT)
Date: Mon,  8 Apr 2024 19:01:39 -0700
In-Reply-To: <20240319031111.495006-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240319031111.495006-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171262722847.1420252.6246371182842943019.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Fix the condition of #PF interception caused by MKTME
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>
Cc: pbonzini@redhat.com, chao.gao@intel.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Mar 2024 11:11:11 +0800, Tao Su wrote:
> Intel MKTME repurposes several high bits of physical address as 'keyID',
> so boot_cpu_data.x86_phys_bits doesn't hold physical address bits reporte=
d
> by CPUID anymore.
>=20
> If guest.MAXPHYADDR < host.MAXPHYADDR, the bit field of =E2=80=98keyID=E2=
=80=99 belongs
> to reserved bits in guest=E2=80=99s view, so intercepting #PF to fix erro=
r code
> is necessary, just replace boot_cpu_data.x86_phys_bits with
> kvm_get_shadow_phys_bits() to fix.
>=20
> [...]

Applied to kvm-x86 fixes, with a massaged shortlog/changelog.

Note, I don't love using kvm_get_shadow_phys_bits(), but only because doing
CPUID every time is so pointlessly suboptimal.  I have a series to clean up=
 all
of the related code, which I'll hopefully post later this week.

But I didn't see any reason to hold up this fix, as I really hope no one is
using allow_smaller_maxphyaddr in a nested VM with EPT enabled, which is th=
e
only case where CPUID is likely to have a meaningful impact (due to causing=
 a
VM-Exit).

[1/1] KVM: x86: Fix the condition of #PF interception caused by MKTME
      https://github.com/kvm-x86/linux/commit/7f2817ef52a1

--
https://github.com/kvm-x86/linux/tree/next

