Return-Path: <kvm+bounces-13745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9BA89A387
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 19:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0F3228399B
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 17:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC6B17166E;
	Fri,  5 Apr 2024 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vAEYWKwU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036FB171E51
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 17:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712338438; cv=none; b=dhtGIoO7msgCm4MEfv7LrYFmmYFGTkhL7N1BS1muDsvdxkYvZZxcAclIdxFUTU7A+7toQekMd3IwyJfVTvbbBbfFFRKF12M7xNG9aHxgBVMdO5EBYJ+Gd9n8mCPYcedwpHFt9utSPDfbB6LiJM0I6+p7aLZ5t2FJ4+UBh+bW0WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712338438; c=relaxed/simple;
	bh=K3vmfqpd94g8+suqMPyLrxBzyLzdFpbPlGZ8DqHjkxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gnp+5zXIfzRlnpFwU2LviDcFvieFa3vs+BhYYcmiON9/SLS9nd7EZN5tQ72xnHDIhD/BLHnuHu0Gor9bMA7B0gcHAKnvv5oC8+bW8fWW0hoI7+p3PU565zaO2J2CRdn4ATROU/sH9gLWcC01vMDwVBVECTVAPrFXIzxk+315l1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vAEYWKwU; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-dcc7cdb3a98so2423103276.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 10:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712338436; x=1712943236; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K3vmfqpd94g8+suqMPyLrxBzyLzdFpbPlGZ8DqHjkxQ=;
        b=vAEYWKwUqG7okVe/Y2WxNAE6BtAubziz2DaI+6cg0ypRpQFh0sUq+A8pLxpcE3q6Iv
         zp/+vYVCDCGk7RPvcV9WbNxZOE2sf/I4XEIQEmlqoUwdZJv6E4xigynEcg65YSIlC6Uc
         YsoOap7uogahgAnFiaqMGJzZ6ClIXWbEV2Wvs2yXo+5z+WDtCSN6953gW8m+ZWEoQrGG
         QvfXaav98xkcE55RpG9ZN0wj9snPMFeu7ZwlETp1upIeBsuB9yJjUuiW0A6Ei8Yu14aQ
         QjFZH9OLFvk4tkxh4bdJcpfmkYeW8LNxnMFHO3EtTzqs9jzr7KCxZYm5qmHgmbODEY0O
         RYEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712338436; x=1712943236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K3vmfqpd94g8+suqMPyLrxBzyLzdFpbPlGZ8DqHjkxQ=;
        b=O+rKY+Igt6LM2L/AMfEC/Xfj/xX6sZckjgHPnDfUoLjtb4LECze1/S96M2cjQFAU0r
         R9m9/8VAFIRG+B7y/AkDO+pAVICa1Ql53x3zictKBoMr3LmnGPqKGI2quustAJoYF06v
         ZUiMsrs1JNO9/9hh0J2pcL8N5xxwjRgzjyDjNm2Bw9icKg6ezOTxFqZZJx2xmZb2R3Eu
         s1PxORR4haEhAesSQDqBWxn0D3x+D9X/7lT3ww7XQBGKMmhhyKX9Y9AkliSpfK6BHtaF
         6m/u32snvUT59Ck37200oUMD95eRy2ZcPRw4TWiqxt4XdQkjU5L6gnm/KQd/2KB8ESWo
         nZSw==
X-Forwarded-Encrypted: i=1; AJvYcCWOiquJ3qH6lAwzFxcTCHBeAm9brbxmd4oWoD/sBgwnWG5kvGS70B5Wj25mgZKo07F9K7ro8JLXQvSZB2ML2Mzt/iJw
X-Gm-Message-State: AOJu0YxvGa9i+Ezf7wWwK5qt4oVcI7f78t2rYxQcn/qE05lJe86Ffm3r
	DbmxDsSWHPDIzFGiihfFyNK4YU+NdeEh96o3EW6mdoN2P+lO4uHyFGtz6jE6DqhDqz60CchSJez
	ncsf6ghJkF70ZTJHTMnzafHOTeOQWElq3qIObcg==
X-Google-Smtp-Source: AGHT+IHnKrc4PwDyhWJPdfeFqqNSHEu/4FbT6H+bcXEG7hzOD320BvkD3M+wSU/pjaJrd/w5bdcvFXKhZ2+tWNjNqrs=
X-Received: by 2002:a25:f50b:0:b0:dda:a608:54bf with SMTP id
 a11-20020a25f50b000000b00ddaa60854bfmr1849823ybe.56.1712338435998; Fri, 05
 Apr 2024 10:33:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404103254.1752834-1-cleger@rivosinc.com> <20240405-091c6c174f023d74b434059d@orel>
In-Reply-To: <20240405-091c6c174f023d74b434059d@orel>
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 5 Apr 2024 10:33:48 -0700
Message-ID: <CAKC1njQ3qQ8mTMoYkhhoGQfRSVtp2Tfd2LjDhAmut7UcW9-bGw@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add parsing for Zimop ISA extension
To: Andrew Jones <ajones@ventanamicro.com>
Cc: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Jonathan Corbet <corbet@lwn.net>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Anup Patel <anup@brainfault.org>, 
	Shuah Khan <shuah@kernel.org>, Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 5, 2024 at 8:26=E2=80=AFAM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Thu, Apr 04, 2024 at 12:32:46PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > The Zimop ISA extension was ratified recently. This series adds support
> > for parsing it from riscv,isa, hwprobe export and kvm support for
> > Guest/VM.
>
> I'm not sure we need this. Zimop by itself isn't useful, so I don't know
> if we need to advertise it at all. When an extension comes along that
> redefines some MOPs, then we'll advertise that extension, but the fact
> Zimop is used for that extension is really just an implementation detail.

Only situation I see this can be useful is this:--

An implementer, implemented Zimops in CPU solely for the purpose that they =
can
run mainline distro & packages on their hardware and don't want to leverage=
 any
feature which are built on top of Zimop.

As an example zicfilp and zicfiss are dependent on zimops. glibc can
do following

1) check elf header if binary was compiled with zicfiss and zicfilp,
if yes goto step 2, else goto step 6.
2) check if zicfiss/zicfilp is available in hw via hwprobe, if yes
goto step 5. else goto step 3
3) check if zimop is available via hwprobe, if yes goto step 6, else goto s=
tep 4
4) This binary won't be able to run successfully on this platform,
issue exit syscall. <-- termination
5) issue prctl to enable shadow stack and landing pad for current task
<-- enable feature
6) let the binary run <-- let the binary run because no harm can be done

