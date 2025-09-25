Return-Path: <kvm+bounces-58783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CEEBA0878
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 18:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 243D63B473E
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527913019C1;
	Thu, 25 Sep 2025 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UpMzZCIs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF69A21D3C5
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758816168; cv=none; b=THJ+rhovUgG8VqDOcte/poWreUmYl+Xkcet6icQK5RkpUUhTHAPBf4kyv1vJMCUAmM9MqzeGZZRLQ5sLTAt6zO3XwqUNR1kSXc3iJcMnPUE0u+0vejni/vdSiCnoPsPfq7jRw4JpnuKjULcEH+iEX/q3o5CdUAUycs3G2Bi447o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758816168; c=relaxed/simple;
	bh=dOjNLOzyGz2Zs3ICuCVbMwGKdrsKTghL6Naj4i8pGjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bVr9zNW2xNuonWmiA942OugaLG8+zJRklszl+8iWJ3UJ9A9Ddu0R6JntZ2F+6RzAL/1IQmtq8rNqag9nKJCS4e0aaBu1duIHctai3dWAo8eYJgvdLLgPa/HP/ODOgtBNnB1PZLYE690zrNQnNW/4RXhtSNIdgdTufrX/nVL6pjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UpMzZCIs; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-62bbc95b4dfso821320d50.2
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 09:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758816166; x=1759420966; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iLlFuJ+iX5wyifqNxIn6t6XU4TT5qvqEgzhS+Kbw400=;
        b=UpMzZCIscab/rGiJSGsHdAUSwPIbixiFKNO/yJFhBLNNedPjAGIGu6PO8gfu+DJpTG
         1TyQvT4/J7bdu/9trH+6UCThJ2CwF0d4jsmuV/krZs8HJwxev5BjoXyQOY+63oIyScLU
         p3nfF3vlCzZ/VdO70J5Skcmu+dYZsbgbhM9soahKpKOIVWFSG0MxJ89cwpFCyWadhRPl
         oCGiiQPUbOQQ1YxyDp66TkPoGz/FjcTc3GmCY8WNJ9CnFsd1YBv/eT13YMF8gPH4EFKS
         Hz1Afe99peF5OOqPFw48UR3WYUJ38lpKF0l6CEhCocsCGb2ZPI1MEEqs1ILwwMoy8L7f
         zNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758816166; x=1759420966;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iLlFuJ+iX5wyifqNxIn6t6XU4TT5qvqEgzhS+Kbw400=;
        b=ulBPFqz45PQihyQCBklAGDbtNOoizmMLDibgQ8a6xKNG+GOvmSO5oKIxu46aqfeiZS
         F4kzXH1ShcYwCeSIzw+LNoeYaN27ELUTR8BLJNbNN5YQlikZKn0xEvmXZCU+ROh2EZj4
         0dVsvOHRlJoEVYDDgLp/rgJTZ4xbm7NeAYxvlJkCAPZR8CMki834AhAKwN1Yt5NAixVR
         Yd2CANRYMLMSmSQRnktoKKks/Ibd/L2y4e+XSJ//tCELF5+NpcDUTv7yZOTNf/q3tQdn
         9t/lgrY9eg+nQtNGCey92pZGfSoeprvNDtD8MkwrESaB8ug318vm//Mf7eGybLue8oEk
         pnLA==
X-Forwarded-Encrypted: i=1; AJvYcCVhm4/2l/RkFcbnvCLN5ByRiyAj/9eDPOjvpAb7W8IDf9JDgBwjDCdZMzjmqS8cEtJoqYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrhZjTOwDh3Zk6JQbthy97FQtbIQdwoplN7QSFmPW2xLkD0tCM
	KipTiS/O2X1HgZX/UNJEmDitPZ4x1iwTM2mz0PTpnGajOSiNH8yJp2OcMYfqr8+GyjWZy1fIoP3
	pAfUaPZCOHnlr1olTAwRGeu7n5ywlabCB1TMlSQqVog==
X-Gm-Gg: ASbGncsOzrySYlcssRXyP/a5APDg3vtv11yGOlH5xWNzSxubuOFkT7339MDWQWhCGug
	A2xRSIYQLJff8EpZ3qrh1DIpfEBUF7xIbxZYwQyyDfyxXn6Xxn9iErjk5LyZOEE6BHDmqZNwS3J
	fQl+v7TMPlE+sV5FQ2kH8qjTxVm/gUrHkCrwplynsqX6CzX2/6WJNZkcfFm56CGEM9dO4x0rL97
	mnIU7Pq
X-Google-Smtp-Source: AGHT+IGCpms8i93eV3XeMlurKIEORFFdZpoyUexyQ+ZgkMKXHoaliP079vOHYsZIwueY2s4NAmmS6fRd8IBm2j3Rsts=
X-Received: by 2002:a05:6902:100e:b0:eb3:8155:73d7 with SMTP id
 3f1490d57ef6-eb3815575f9mr3351111276.43.1758816165198; Thu, 25 Sep 2025
 09:02:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250920140124.63046-1-mohamed@unpredictable.fr> <20250920140124.63046-23-mohamed@unpredictable.fr>
In-Reply-To: <20250920140124.63046-23-mohamed@unpredictable.fr>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 25 Sep 2025 17:02:33 +0100
X-Gm-Features: AS18NWD0ExaVsx4-sz2VajpoCZeR2gAFsGP1JUT_ZNYO9R7ArS7Np5PQco5dlVo
Message-ID: <CAFEAcA-45aHae+frQkq1JAHPYJH-Uu9HUOLU5VjVtEEW1sNO4g@mail.gmail.com>
Subject: Re: [PATCH v6 22/23] docs: arm: update virt machine model description
To: Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: qemu-devel@nongnu.org, Shannon Zhao <shannon.zhaosl@gmail.com>, 
	Yanan Wang <wangyanan55@huawei.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Mads Ynddal <mads@ynddal.dk>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, Igor Mammedov <imammedo@redhat.com>, 
	qemu-arm@nongnu.org, Richard Henderson <richard.henderson@linaro.org>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Pedro Barbuda <pbarbuda@microsoft.com>, 
	Alexander Graf <agraf@csgraf.de>, Sunil Muthuswamy <sunilmut@microsoft.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Ani Sinha <anisinha@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Sept 2025 at 15:03, Mohamed Mediouni
<mohamed@unpredictable.fr> wrote:
>
> Update the documentation to match current QEMU.
>
> Remove the mention of pre-2.7 machine models as those aren't provided
> anymore.
>
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>  docs/system/arm/virt.rst | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/docs/system/arm/virt.rst b/docs/system/arm/virt.rst
> index 10cbffc8a7..fe95be991e 100644
> --- a/docs/system/arm/virt.rst
> +++ b/docs/system/arm/virt.rst
> @@ -40,9 +40,10 @@ The virt board supports:
>  - An optional SMMUv3 IOMMU
>  - hotpluggable DIMMs
>  - hotpluggable NVDIMMs
> -- An MSI controller (GICv2M or ITS). GICv2M is selected by default along
> -  with GICv2. ITS is selected by default with GICv3 (>= virt-2.7). Note
> -  that ITS is not modeled in TCG mode.
> +- An MSI controller (GICv2m or ITS).
> +  - When using a GICv3, ITS is selected by default when available on the platform.
> +  - If using a GICv2 or when ITS is not available, a GICv2m is provided by default instead.
> +  - Before virt-10.2, a GICv2m is not provided when the ITS is disabled.
>  - 32 virtio-mmio transport devices
>  - running guests using the KVM accelerator on aarch64 hardware
>  - large amounts of RAM (at least 255GB, and more if using highmem)
> @@ -167,8 +168,7 @@ gic-version
>      ``4`` if ``virtualization`` is ``on``, but this may change in future)
>
>  its
> -  Set ``on``/``off`` to enable/disable ITS instantiation. The default is ``on``
> -  for machine types later than ``virt-2.7``.
> +  Set ``on``/``off``/``auto`` to control ITS instantiation. The default is ``auto``.

Could you fold the docs updates into whichever patches make the
corresponding changes to the virt board, please? I think
that's patch 3 for the "gicv2m when no ITS available" and
I'm not sure which patch the "add auto for the its property" is.

thanks
-- PMM

