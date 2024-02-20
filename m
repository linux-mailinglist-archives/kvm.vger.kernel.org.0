Return-Path: <kvm+bounces-9193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C5785BE06
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 15:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F018F286AFE
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 14:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D59E6A8A7;
	Tue, 20 Feb 2024 14:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p1PMzGAw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1815C5FC
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 14:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708437856; cv=none; b=UsmERZm10M8NlfqK6Yw7+UBnTZTicvPpcD16vlDwqOskGlNaXxUHf7+iBX6y25qbeNMINe4gb3uQT2Cd/nFBJ2xN0LNTzdjEtGdZjHiL+SJGKYOAyBl9BiPALtOgP+Ltb9LnA9j5Y1PnIVVbg55EdfVWcqKQ3etyOL17f3XD/6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708437856; c=relaxed/simple;
	bh=CWUrJw1VxhsUVSPMHIW4mX4BcBEeYqkrmm0fbo82ap0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bVafA06otxRTJNuDmho6Fqs3JoAEj8uEJAkMKKnsVk32zhcA2qUGABQ2GFImtNdmYs7cSCBtEe9SZG0N4IbRDftTWrXoL5Zvh3hmuZTpJIWwrGpFA01YAo7VIpH82Wr7YSeQDnPm3mIN6o8aVbrwNmAkDdepwq9ZXBs4YlU4S/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p1PMzGAw; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-564647bcdbfso2510636a12.2
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 06:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708437853; x=1709042653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7HcYmC+O/kaq/mMhRCiy/822wCYlWWBDeIseRTPuWak=;
        b=p1PMzGAwpmb0BFhKYyvKR0J8yJqgk+x9wWTQLs2GvfRWmZoZxjtG6T/zDWaH2/RF8H
         jpDXdNRiQg7pBMkjmr13fTk2UWPgKFaBkIFv4nd1AkdhfjIYBjOjTcXFGQ57VOVMeGUa
         XmZRcuNCS5yn/5Qu239Y9f7IqoKS/3FA77zIMmF1xRvHPay9JFCDebkAuswWd07fh4M+
         RMP92pry91rNx+E+xK+I4sSwOy1+fBxCbqJxdLrO5Hf9xRfbeWVxjb7lG1BC7cWKuFYY
         opLfOBqz8qbi4Mp9hFw1inCJKI1QLNxILtvvv6VtS0mu/oUeHvRQXrp3FO2h2GzS62rp
         YxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708437853; x=1709042653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HcYmC+O/kaq/mMhRCiy/822wCYlWWBDeIseRTPuWak=;
        b=MEOWsLm24hO98J+vgd1x0fXlF4JJuFJeqZecPWypg++/FL7hsIlKG8szPNLG7m4745
         lmtyJFMXF+WgwOUhx0XvzCCB/FoiUKo1N+hdEqTfp8qRDrCL+bhyBibr01Rgdg+lrLbV
         hm+dZlTjq4GYsIpVASeHZrngyXfC5M5AZw3gbxLRQcvDojK1FU+5QT7+PYaW7czV/Ccg
         DxWvrzXgRDbvZuMPtHifG2A3QPKb/0s25ugAwaV19wqTScNz3wY9zfT/NAv54jY7sLvO
         8+54QtHiHi/gzPVAQ9BGqXXMCgfgedMf/utHtfsS+9zbNhnhNP/wl19p+oCcfLigfQDn
         J4MA==
X-Forwarded-Encrypted: i=1; AJvYcCUYN6J+vMv401MikT3uUKKPLQNej8EtB2SEVzhm2vqlpsSPvJOxFUUFo11vILMefhZvTmV6yrdVXy2QvOJfx0/ZOKF8
X-Gm-Message-State: AOJu0YwjrEuJWX1gQMY2NuDUoiQcMUYOWD8gaBJAxWF8mkB9zCbRsRdT
	RdQD3kigE9+qyCT3Kgxs8ZNF6u1KTw0l85A2ZqgvqkIPqGRmfCgI5tUgDV9qRMBQ/Vyzn6nsF+d
	kpZEEkk0JDjpzl5UdvbhlM2GMa096V1LTjudZGQ==
X-Google-Smtp-Source: AGHT+IE3+Uo4bJoUcdMjVLgsrEPiRA1kRe4srUUoPb0q0r62EC6koPVaMf8zABaj4H18OjrZFBXRQVM4BsOHSwHfMTI=
X-Received: by 2002:a05:6402:1b1a:b0:55f:f94d:cf76 with SMTP id
 by26-20020a0564021b1a00b0055ff94dcf76mr10101954edb.27.1708437852739; Tue, 20
 Feb 2024 06:04:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240216150441.45681-1-philmd@linaro.org>
In-Reply-To: <20240216150441.45681-1-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 20 Feb 2024 14:04:01 +0000
Message-ID: <CAFEAcA-SYyXN94cH2mmVynW7LPB-YoSQTZ_E0WH18ra0UGB7-g@mail.gmail.com>
Subject: Re: [PATCH] hw/sysbus: Inline and remove sysbus_add_io()
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org, 
	"Michael S. Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Feb 2024 at 15:05, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> sysbus_add_io(...) is a simple wrapper to
> memory_region_add_subregion(get_system_io(), ...).
> It is used in 3 places; inline it directly.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  include/hw/sysbus.h | 2 --
>  hw/core/sysbus.c    | 6 ------
>  hw/i386/kvmvapic.c  | 2 +-
>  hw/mips/mipssim.c   | 2 +-
>  hw/nvram/fw_cfg.c   | 5 +++--
>  5 files changed, 5 insertions(+), 12 deletions(-)
>

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM

