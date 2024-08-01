Return-Path: <kvm+bounces-22946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8155F944DF0
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 16:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A45101C23BC8
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 14:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD341A4F35;
	Thu,  1 Aug 2024 14:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tDRdBnCG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D84416DECD
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 14:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722522368; cv=none; b=NjqClHxk4mUmyw25O3KO48x3xxJQ4FN5vZ6/7V0zjhP/AwXrtlQAsA+p1ABmZ30DtYshFJsR+lOuE/2T0nXPH89bYr89WNbBDTPWWDknEMOL1GgV98/ZGPCnerY4tE6aoJ+hdK/Gxcs5zz2J1mMbIRaGo0i2piCq23zvGpIMVPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722522368; c=relaxed/simple;
	bh=YBkM2j0NcezYrn6YO324onq9oz5rzqnzoHsPNTbVU3M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=U5PQd4N8EwLDoLJ9zfBI4A6G52Xw2o8EK4buJ51OuCi76zB+UcS64dqyHyXaoiJAgNRgdpp3zWkQ7Ga159KcrnrHPjIn4540Y9PMZJFkOIJf2fvcDvmkgSDYZ3TE3jz5Ht0IDI9H2AKg+mNfI1wIPkP8K7QCkvcS5ucLil4fJ9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tDRdBnCG; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52efd08e6d9so10340065e87.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 07:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722522364; x=1723127164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YBkM2j0NcezYrn6YO324onq9oz5rzqnzoHsPNTbVU3M=;
        b=tDRdBnCGLpt4OumkPrUoBSZi9NPtaAyZKVENFWOa5H1AEMQal+dmZhfNerPeHz+yqu
         ForlYak2rHxO7npTiVJoP6SuBT8W3n7d+0d4Zp9TZoqyUkaPG1P/FPk/vkiFt3YsgUSj
         Fv08W4ib0izCRX314ux5zQY72+cgHoc0HHgeokaAfdNx9SoiC6DlDiGYs2d2cM1DzerI
         MlriiyVfKyUtOMCQBi3mo6Dw/ic5Oz2ewcpTv9NFK57SE5RChyqxdwFEI2NrZFETxAq9
         3sQQdKSi7TzLovpvP41Okmf5fWvWC6U/KR2kzLZ+0XUflDduEaVrfgk3cGjvOfUcxGJo
         0FbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722522364; x=1723127164;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBkM2j0NcezYrn6YO324onq9oz5rzqnzoHsPNTbVU3M=;
        b=NiykpjboRiSemTk5Ly8WIrRRR7OMvwrDnqXljMtuoFqG0/1f/DXNfs7UXg3nAurCb4
         uHmfkfGBJqhBe4fa4HqltrEiUsh+lBxSTN+TP/vNTKqSfLZEg8gVSDVEK7wpPhZ96Zoj
         yu5zczzmZrQgUkMC1MUFftC1fynwlTVmrzBSiw5bwMlpYWmmd+Lwy2UXJageMeYDcnAn
         AdBaDlOzYB3Cmhj1xDMNJqpUM9Xu/0wGlauiuk4oPvGy2UGI6kF024EPlVsajVuMd8NN
         CWlmkIgX4KShdEOlPLrKlTeAtlbv+Je9eV4Ri25c/GhirzwlzVfEA09ghcldZKcDw5mF
         9QQA==
X-Forwarded-Encrypted: i=1; AJvYcCWcd55KmhLA0cjK+jWn23+X8CBYNyGJAKOHuLiC4xS86hZYfc+bisCVhID113LBaU0FMjh+6O3eAO8RaMISfvWM7F4J
X-Gm-Message-State: AOJu0Yzn1juy8X24zV3mWcuom2xO82eBNv2RUxEsP6dEXkJimG8J1aiK
	GVCzvBln4J9USNA7/lh1O5DYgUofpeC2Cp9gymNRpTsTF3IbmhhLnBS1bujcpzc=
X-Google-Smtp-Source: AGHT+IEjrlTiyBUYaINP9uK712VXKR5kixtvXc4di6YloeiU5uT5+Bl4vrpU/jHF166KdbS64KlpIw==
X-Received: by 2002:a05:6512:3a95:b0:52c:e084:bb1e with SMTP id 2adb3069b0e04-530bb397748mr31883e87.13.1722522363952;
        Thu, 01 Aug 2024 07:26:03 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac63d4720dsm10348802a12.58.2024.08.01.07.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 07:26:03 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 6CEA45F80C;
	Thu,  1 Aug 2024 15:26:02 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Daniel P." =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Cleber
 Rosa
 <crosa@redhat.com>,  qemu-devel@nongnu.org,  Peter Maydell
 <peter.maydell@linaro.org>,  Thomas Huth <thuth@redhat.com>,  Beraldo Leal
 <bleal@redhat.com>,  Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Leif
 Lindholm
 <quic_llindhol@quicinc.com>,  Jiaxun Yang <jiaxun.yang@flygoat.com>,
  kvm@vger.kernel.org,  Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
  Wainer dos Santos Moschetta <wainersm@redhat.com>,  qemu-arm@nongnu.org,
  Radoslaw Biernacki <rad@semihalf.com>,  Paul Durrant <paul@xen.org>,
  Paolo Bonzini <pbonzini@redhat.com>,  Akihiko Odaki
 <akihiko.odaki@daynix.com>
Subject: Re: [PATCH 07/13] tests/avocado/kvm_xen_guest.py: cope with asset
 RW requirements
In-Reply-To: <63ef2c5b9ab213f544173df027abf5b056d59e8a.camel@infradead.org>
	(David Woodhouse's message of "Mon, 29 Jul 2024 13:03:46 +0100")
References: <20240726134438.14720-1-crosa@redhat.com>
	<20240726134438.14720-8-crosa@redhat.com>
	<Zqd10nIix4gXKtDw@redhat.com>
	<63ef2c5b9ab213f544173df027abf5b056d59e8a.camel@infradead.org>
Date: Thu, 01 Aug 2024 15:26:02 +0100
Message-ID: <87wml0coat.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

David Woodhouse <dwmw2@infradead.org> writes:

> On Mon, 2024-07-29 at 11:58 +0100, Daniel P. Berrang=C3=A9 wrote:
>> On Fri, Jul 26, 2024 at 09:44:32AM -0400, Cleber Rosa wrote:
>> > Some of these tests actually require the root filesystem image,
>> > obtained through Avocado's asset feature and kept in a common cache
>> > location, to be writable.
>
> Hm, I'm not sure *why* they require a writable image. Mostly they're
> just testing the interrupt routing. What's the failure mode for a read-
> only image?

There are no real failures with readonly=3Don although you do see init
complain a bit about not being able to mount /dev and open log files.
snapshot allows that to happen but doesn't change the underlying
storage.

>
>> > @@ -56,11 +57,19 @@ def common_vm_setup(self):
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "367962983d0d32109998a70b45dcee4672d0b045=
")
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.rootfs =3D self.=
get_asset("rootfs.ext4",
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 "f1478401ea4b3fa2ea196396be44315bab2bb5e4")
>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if readwrite:
>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
st =3D os.path.join(self.workdir, os.path.basename(self.rootfs))
>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sh=
util.copy(self.rootfs, dest)
>> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 se=
lf.rootfs =3D dest
>>=20
>> This is a very expensive way of creating a writable disk. Better to
>> avoid adding this 'readwrite' parameter at all, and instead create
>> a throwaway qcow2 overlay for the image for all tests. That ensures
>> writability for everything in a cheap manner.
>
> Or just use -snapshot?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

