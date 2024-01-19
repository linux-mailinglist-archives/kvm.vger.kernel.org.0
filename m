Return-Path: <kvm+bounces-6474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88EB4832EA3
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 19:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B03E51C247BA
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 18:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6534A5644C;
	Fri, 19 Jan 2024 18:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y4hAd+3s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E2756447
	for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705687775; cv=none; b=csfYEc7RUi1505JoLrd3YlGr7PeoPW2/1E8iAxj6coinhbzASTRMj2N/WvW25P+hP+tUJl3fqQG85ElO+eRnoqCG6Ox0coltLIlq/y/H45t+CSVaZOWwLC+t5YBKo/znhks8nilPnWg7UOuRVuQ+Oi2RMTW2bhSud+/6slu0hR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705687775; c=relaxed/simple;
	bh=ka+tZ98I4RebCKjSaYFNELphOPWKiUktZA8UV6N1nR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vny5VYtWEOUp6j7ZUsvdlARffQBRB4e6x+as4BjJDmfjRcNJEYA6Dj5ZZCrqMD6Cgwp2ZAGYzGYfaDjGX2GnRQ2rS/Dii7ZTEFcPNZO/5jDwP8LxztSWGvRtApuLMYKM32l1pgT7H8BcAmum4T4r8g2h+55OXn0Ce2+UmoSALnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y4hAd+3s; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-559cef15db5so4028026a12.0
        for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 10:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705687772; x=1706292572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ka+tZ98I4RebCKjSaYFNELphOPWKiUktZA8UV6N1nR4=;
        b=Y4hAd+3s236W+CRbXbaawhVl8xrFUXXnTkipUQuAdmxPGPxW+1pRV51eYF46R13ywZ
         Qk486Xk4E4S9LS+GYn5FdiW4ocRJS94624JZFK9ejOjuNuixv36vg6YgVbVu9Bh6/6gW
         /7gfjSrFdfQH/DWIvNd0ppO4Ixtawi/YgH5zqJVso9ewHR5LFSVNNpQHLt2cCfAq8/ni
         x/fAYr16YIDjx9cUe3KYoz4hQx3EsdIrjCp91JyBjJ+4ss+IaXwqRI87H3nvYBxHHI9o
         xG3ImQHCKQbnV2ai2jpO9E9FonTlFa/TSyfpUqxtcx+pLhe+Qe9mkPvXHasdSxYka8/o
         Bc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705687772; x=1706292572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ka+tZ98I4RebCKjSaYFNELphOPWKiUktZA8UV6N1nR4=;
        b=bJLCk4khhX0NRWJDlyaG8qGwOTqKOV4YmQTsePbKu9ysohbkP7CIQE/5ro9H1w6mBt
         li10vz87JWGY9C+2NJ2KUpTAOjS9YAqx9fQm8E5Bj6Mx83W09891zrcYSIol4foOxeH8
         +VIL0LJeOKCy5jggCNEHY/jqBY9+6ALjnPaxGA/axgck/UtfLLcbIrWznzdCbZyCX70Q
         x8uQaA2nF10xTXM6FybyJ5G1nIuwxHnUKuucM/4XZrhtHF/ExqqkgiZK87l4VmRDmi+l
         ez3QE9FZU6Ywjl4n2LPEL2K4Ah7eUmTVz4RnGD/Y+/WDoMm+7gmMjTFZtwX11iulBeW+
         ZZ7w==
X-Gm-Message-State: AOJu0YwuWkbWwEJHgrxqOzVi99twdCFy5x/8aGOB4fYOIDZGDiPEwOHA
	kefgwuhVJMXkdNa4m6jqlEKXbKFnoyMvUSdPvaJFBFK1aarSLTJjvJ6/xeaggUS00MprNfVJzF0
	OP8aIWIt3oITcCHg2GRbiiGo81eOsAHAaioGTnw==
X-Google-Smtp-Source: AGHT+IH6YCYWaUoOMDt7utojgTHGk9T2jLCxk9qdIrGqALHUenS/OCV61NvN4WF17TmlRNIUHK2XlkjcdCmhWASsuu0=
X-Received: by 2002:aa7:da43:0:b0:558:f2db:1ce7 with SMTP id
 w3-20020aa7da43000000b00558f2db1ce7mr1586459eds.12.1705687772017; Fri, 19 Jan
 2024 10:09:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240118200643.29037-1-philmd@linaro.org>
In-Reply-To: <20240118200643.29037-1-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 19 Jan 2024 18:09:20 +0000
Message-ID: <CAFEAcA93c0aq3wN8zXG9C8tb8JdDVOwxjQaFcs8MxPtGRDE=Rg@mail.gmail.com>
Subject: Re: [PATCH 00/20] arm: Rework target/ headers to build various hw/
 files once
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Igor Mitsyanko <i.mitsyanko@gmail.com>, qemu-arm@nongnu.org, 
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>, 
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>, Igor Mammedov <imammedo@redhat.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, 
	Eric Auger <eric.auger@redhat.com>, Niek Linnenbank <nieklinnenbank@gmail.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jan Kiszka <jan.kiszka@web.de>, 
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, Alistair Francis <alistair@alistair23.me>, 
	Radoslaw Biernacki <rad@semihalf.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Andrey Smirnov <andrew.smirnov@gmail.com>, Rob Herring <robh@kernel.org>, 
	Shannon Zhao <shannon.zhaosl@gmail.com>, Tyrone Ting <kfting@nuvoton.com>, 
	Beniamino Galvani <b.galvani@gmail.com>, Alexander Graf <agraf@csgraf.de>, 
	Leif Lindholm <quic_llindhol@quicinc.com>, Ani Sinha <anisinha@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jean-Christophe Dubois <jcd@tribudubois.net>, Joel Stanley <joel@jms.id.au>, 
	Hao Wu <wuhaotsh@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jan 2024 at 20:06, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> Hi,
>
> In order to fix a bug noticed [*] by C=C3=A9dric and Fabiano in my
> "Remove one use of qemu_get_cpu() in A7/A15 MPCore priv" series,
> I ended reusing commits from other branches and it grew quite
> a lot. This is the first "cleanup" part, unrelated on MPCorePriv.
>
> Please review,

Applied to target-arm.next, thanks.

-- PMM

