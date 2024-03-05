Return-Path: <kvm+bounces-10855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDB58713A8
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:35:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70E1D1F21DA5
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 761E3282EE;
	Tue,  5 Mar 2024 02:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FseWVgwr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568BA23CE
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 02:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709606139; cv=none; b=m/ON+aGLX8UWtycupk2h/vurH/tvJmktG6UfqB22N/zmJ6MUdzmVH6y4KRVxYFd9nT8ClvBquzJLWvLaTWw0UklP6AQr2JIVxa8K4ZgbEFVi3TNnWejJYH96p3vPacNefejVSWf1lhM5n/9UrxJvSBYLLYzqjdXNe305DPOxZEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709606139; c=relaxed/simple;
	bh=N+xrQxFkgiT2zXyroYi8UiH205d3grUsaMt27oLZHPg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=RxsgbGE59oHQ4hRKpWs0SMVMhmWzuZ+ZjtEPYnVH6jgjBST+36KEORcThILAOGIieK1D/bQ7EnDnSfsfQ6U0qUASfMv4mWqXMvENPaWOtmPECDGrkyMvpq+tcaByezgHsaejVN3o5EaCxBthG1AQ9lWgUSiFQfsZH1JnK8CAw70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FseWVgwr; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e617b39877so1574902b3a.3
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 18:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709606137; x=1710210937; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+xrQxFkgiT2zXyroYi8UiH205d3grUsaMt27oLZHPg=;
        b=FseWVgwrKqHsrj2HXSCbDzL+isQjgeX+DwHSQHHFXxrE2tVRoT0hm6yeF2ddN0/ACw
         X85EwaiLJJe1tZcNl58mhAliyglP6prCub0T4LxCKGdC84hY5HkH9ILZxZ/riM5SpCZC
         H2oxXIaP6KB1nfoFATlqo13JwkK/v+a2yWXu8mYPttqQGn07GStrE+APjsOYDG8tsP3K
         OnXHtcWKPVIisSKPuEruW+YSRpgMPjHq4xOZ4cDZPxIh+3F3Oofnl7oiLWdTaK8mGYeW
         QVV2gzeGEJqDlhZo1HDsGYS/xNU2vDjXn9IrYhiwE4IegBIg1dXu75up3vQTrgfpV2Kt
         xAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709606137; x=1710210937;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N+xrQxFkgiT2zXyroYi8UiH205d3grUsaMt27oLZHPg=;
        b=OiYF4J4KNe01GeiQT6/1vGkFQ7EKEMjuI6CLD1JlmmAdKg1Egs3G7jOC14TcLebK99
         5Ei2F+HjBhP9Mp2dkp6hngRdt3gHShgrQjRjVDQKtH2vS87DmZsRFQmjvbPECBNqniFJ
         G8/md97d2fQJKLeWi1SWbOd4B32ga0O+uL9RZYHNd2F1lmHn3hZBK51mANUdKpt64EFp
         sQR6CTfsZbajsaod2ad+0NyNa4sbzJsnQ2rVjPUxrvQc7NzErPjL9d9QzR9DXEIFkjyZ
         SWk+0GRsHm+D/tWVQZaFlLZskc766gz0rQj8R3AxauGObAdjt5YVR7WDZs8DD2WRup3N
         nMcA==
X-Forwarded-Encrypted: i=1; AJvYcCVQi1/02I3SSjfRMPyjmYOymKBfd8tCKwPJaNUNGZDtHvbWp5cKJPqf9G+ns7Xwn9mxKlb/w0z6fAGvKzYHO5YiCpwQ
X-Gm-Message-State: AOJu0YzwPjko8EbIWV2XH5CTlpS02AbSBubGxinOgzHfMZx7GlLZ5Yyu
	q9HNDQXBoCYgxdtItJZJUH68wPIjYo4DKdQJxVQ4RP+ClNPm3fyu
X-Google-Smtp-Source: AGHT+IFWHPaDxpd9bOxuV1992+XKIgj0weLG7m7eGnp6z6kVYI8q6dzZSPJZ7bnSE7aWZLXV8NJXjA==
X-Received: by 2002:a05:6a20:7f96:b0:19e:c3a1:238d with SMTP id d22-20020a056a207f9600b0019ec3a1238dmr539679pzj.52.1709606137537;
        Mon, 04 Mar 2024 18:35:37 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id lp3-20020a056a003d4300b006e553f2b880sm7839075pfb.211.2024.03.04.18.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:35:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:35:31 +1000
Message-Id: <CZLGSMOBJAR4.1Q6P8X2V9X969@wheely>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>, "Joel
 Stanley" <joel@jms.id.au>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 14/32] powerpc: general interrupt tests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <ajones@ventanamicro.com>, "Thomas Huth"
 <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-15-npiggin@gmail.com>
 <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>
 <20240301-65a02dd1ea0bc25377fb248f@orel>
 <b4a1b995-e5cd-40e9-afc1-445a9e5f6fa5@redhat.com>
 <20240301-0483593c146ffd3bbded2f69@orel>
In-Reply-To: <20240301-0483593c146ffd3bbded2f69@orel>

On Sat Mar 2, 2024 at 12:14 AM AEST, Andrew Jones wrote:
> On Fri, Mar 01, 2024 at 02:57:04PM +0100, Thomas Huth wrote:
> > On 01/03/2024 14.45, Andrew Jones wrote:
> > > On Fri, Mar 01, 2024 at 01:41:22PM +0100, Thomas Huth wrote:
> > > > On 26/02/2024 11.12, Nicholas Piggin wrote:
> > > > > Add basic testing of various kinds of interrupts, machine check,
> > > > > page fault, illegal, decrementer, trace, syscall, etc.
> > > > >=20
> > > > > This has a known failure on QEMU TCG pseries machines where MSR[M=
E]
> > > > > can be incorrectly set to 0.
> > > >=20
> > > > Two questions out of curiosity:
> > > >=20
> > > > Any chance that this could be fixed easily in QEMU?
> > > >=20
> > > > Or is there a way to detect TCG from within the test? (for example,=
 we have
> > > > a host_is_tcg() function for s390x so we can e.g. use report_xfail(=
) for
> > > > tests that are known to fail on TCG there)
> > >=20
> > > If there's nothing better, then it should be possible to check the
> > > QEMU_ACCEL environment variable which will be there with the default
> > > environ.
> >=20
> > Well, but that's only available from the host side, not within the test
> > (i.e. the guest). So that does not help much with report_xfail...
>
> powerpc has had environment variables in guests since commit f266c3e8ef15
> ("powerpc: enable environ"). QEMU_ACCEL is one of the environment
> variables given to unit tests by default when ENVIRON_DEFAULT is 'yes', a=
s
> is the default set in configure. But...
>
> > I was rather thinking of something like checking the device tree, e.g. =
for
> > the compatible property in /hypervisor to see whether it's KVM or TCG..=
.?
>
> ...while QEMU_ACCEL will work when the environ is present, DT will always
> be present, so checking the hypervisor node sounds better to me.

Yeah I got that.

One issue with xfail I noted when looking at this earlier, is that it
*always* expects a fail, and fails if it succeeds. So if you fix a QEMU
bug then you introduce a fail to kvm-unit-tests. So we really want a
report_known_bug(cond, "SPRs look sane", "QEMU TCG before v9.0 and
POWER9 DD2.0 is known to fail..."); and that could report a maybe-fail
that doesn't make the test group fail.

Thanks,
Nick

