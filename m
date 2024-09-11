Return-Path: <kvm+bounces-26459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7DE1974A28
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68E2B1F25593
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C714080604;
	Wed, 11 Sep 2024 06:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sUvPoeFr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B837E7D3F4
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726035153; cv=none; b=DeBxCJav0aL1118MJNUqF1GX6wsgjOKbnsdeUx3WJEzqSo3RuPPOeiGsjRwAp/xRWM8zgbA0HO1O6CosyC5hHd8H0pnqpSsgXeS62hyFZ24f8jcwuZmMF/CjVrhKJAXAdOq7chItDa+bycVT/4Ewj1iuMQL0aY8/opHYDTpJTGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726035153; c=relaxed/simple;
	bh=sLIGbvNkBoK4d5t0s9ufvY9P92EWraSNlwwz2tzueXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kcwMenvURYMjjMdjpUToGUc80C/ChRsdFvsAYMI8KYetPJZKhKvU46Edlpna7sdl8hsXUPthFZlrrQ6unVrG+r6otECQMq/ASCgcSk8WMb+VKY2QXepwnLICmoente/CR/uOfMKdN5z0htCGxfDSweTfgIDAN38kgGdduZHqzXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sUvPoeFr; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8d2b24b7a8so101620266b.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726035149; x=1726639949; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kAumJrG5geLdw61qf3VpDc77f3fS/zuFfk+876iJiTA=;
        b=sUvPoeFryhMIkghDtP8d+cA9mWA6mvlZN9elurYNCq6Kub5kgnFJH76pbU38liquIs
         uOyZTeBgqyuwoSpWeu2bBWD8if2j5pDn7hdAK19xr/HkAYWfBXB0x06+SUqYTjRN4IBx
         mfDxScF816VVSFWmq59WTow2cMy3ESon2QNMc4W+OsXdvNl2Pj8J7bjBsdUJT1UlwVGE
         x20ASUjxN9ahXZPGEcADJjT8X1rGTcKwOWKISIGRhd8NvoHFdr983Tcbl1igza/2FM3l
         IXhxCsxjg68AVaGyrACd+lS7F4iZyb6uPhzxBEvGT4VJscb3om1dc5pWtd+PDzpAmcPE
         5SGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726035149; x=1726639949;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kAumJrG5geLdw61qf3VpDc77f3fS/zuFfk+876iJiTA=;
        b=AYQW+Ej5PZnBBcGB4INhorOnsqrtG4z8OnG5Ol/pDmo9g/yI5FDRTulTfFsoQRaiKG
         2FZnbOxQGHc/Lp3Pmm64ltdliZUZoY2oXsK/DA9/0elQ6Xmr2C3RSxJsKFrhK/PIIu4L
         YrCqCoJAXaax6BG7sZojxWJ6519HxMi5oPjQuEEBO1tZLFcXFwwHIiURx3jRKHsjsLiN
         NT/Fk3Gge3Ufl4rEJ+oC2IGz8cHHKMFgGwQ/OycLa4dTkFxZ0iKMmbVSoOXs7PdegSZn
         CAfrNDLrSaFz2KslXgeaDhPa8GXbjgoouZERmynAjq5zyAmq7xLnMFsPNo9b/oiLlxPk
         BhSg==
X-Forwarded-Encrypted: i=1; AJvYcCVODWnVsnJboNeOd7/SQb0Jt/gbC/Ug2FD4i3mNxX2L9hlrHyW3p8nic7KpoFVRNQHSoFg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybuve7I0K0wlhjCz12VviKAjXh4gHxvpxdl9sx5emsYbd+o124
	/ISYJ/Q+GG49yq1AMQY8/89r64oZKvx7cHByQiDPKObjasR33tRGCr1grvnL+Io=
X-Google-Smtp-Source: AGHT+IGRY8ki3wghoo/m+frsHDdqzA0RIY8ueJyoMKlmKYbuDtkVoyqaJyXYcUASHJC9DbnG5ihtFg==
X-Received: by 2002:a17:907:9625:b0:a6f:996f:23ea with SMTP id a640c23a62f3a-a8ffb238307mr283396366b.15.1726035149030;
        Tue, 10 Sep 2024 23:12:29 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d5dc8csm571366066b.206.2024.09.10.23.12.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 23:12:28 -0700 (PDT)
Message-ID: <841905bb-105c-4c42-88a9-ecbeefc2ad0f@linaro.org>
Date: Wed, 11 Sep 2024 08:12:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/39] hw/watchdog: replace assert(0) with
 g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
 WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
 Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>,
 Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov
 <imammedo@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, Fam Zheng
 <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Jason Wang <jasowang@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-8-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-8-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/24 00:15, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/watchdog/watchdog.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


