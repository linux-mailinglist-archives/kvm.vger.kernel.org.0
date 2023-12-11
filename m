Return-Path: <kvm+bounces-4076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 141BA80D202
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A86DEB212A0
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC651EB5D;
	Mon, 11 Dec 2023 16:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VwxmJBTM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEC491
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:37:00 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-a1ef2f5ed02so501542866b.1
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702312619; x=1702917419; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rchDbv41LmtjjKEGa4Aos/UEX+s2aj5wfo2X55D4PBs=;
        b=VwxmJBTMAib8JHVLtw4EzHXlafnKMgYzkrpxwvdXlrDqa0SskGVEyEFshn3Z3h/T4k
         3DCU6xwXU/0gR+6ZslL9WE/GGlwuFDfd8SchZzWVX5ja0g+JIirgcu7BNn5JbOiM/Xqm
         ublrUd/w06nqwNuGQRkwluilqDca/kKpxiiXWEMvEkGY5W1/Axdz7IO7Hx1W3xEdOwvv
         n/frDvxl0O4h9KfogjQbA9vK4CnKBrEolPLLABMCaZfKTevlM5oo9Kq9MMPX3CzVwKRf
         Jw3K86uxcUaMIBFaZ1xPl1h31Yrjz6DGYwciNUFPogtC/zcPn3NaTZSiCh+l4i11/xIf
         xhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702312619; x=1702917419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rchDbv41LmtjjKEGa4Aos/UEX+s2aj5wfo2X55D4PBs=;
        b=tDTTpKRA+ckjkNSrFLihuHPpt/u9ltFS4kTxaVxpnMgRkQq21RLNMSGD7uzL7LdVLV
         BLujuTMe47zH3aQ9V2bjM4o6XuGfPPF0ZyeK99kzpNyJhLLKMJGkriSG/aPS8EvuDhqt
         HAum+6G88JeZDbe3QtW1QoRFLGUYDf49X/m4Oc2p/lZh2mg06e/GPMEiadF4LX6Hu4Om
         tKkBDk3yRwVsKyTnbu9MZ1Hc9OLy2V0/Jhg3j9Izz8JarJzBV4bBBJdFS7S7Z34DtO41
         ol7Ktmc4eeYkAVOpZroTYuAQT8X+dipeRZtqBA/kP1/mdODUSSkz8iwqZ028r7/BRokj
         jdtg==
X-Gm-Message-State: AOJu0Yz1wCn2wVleluS+J+CpciMqZGitlvpSgsDuaQFuezjuZ1aFj6P9
	9DkJME+CW0MbgtVKyf6m9R5rNg==
X-Google-Smtp-Source: AGHT+IGRSB4xvIcdsnqjQZqKP0M8XN4p5GuuQ1IOBXp8idoQn+ocFfXv4zbe60b/rATCpyHNiOS/1g==
X-Received: by 2002:a17:906:b0c9:b0:a1f:6433:798c with SMTP id bk9-20020a170906b0c900b00a1f6433798cmr2034910ejb.106.1702312618978;
        Mon, 11 Dec 2023 08:36:58 -0800 (PST)
Received: from [192.168.69.100] (cor91-h02-176-184-30-150.dsl.sta.abo.bbox.fr. [176.184.30.150])
        by smtp.gmail.com with ESMTPSA id rd12-20020a170907a28c00b00a097c5162b0sm4995159ejc.87.2023.12.11.08.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 08:36:58 -0800 (PST)
Message-ID: <5377419a-88dd-4e5c-8be4-1345f6c2115b@linaro.org>
Date: Mon, 11 Dec 2023 17:36:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] testa/avocado: test_arm_emcraft_sf2: handle RW
 requirements for asset
Content-Language: en-US
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-8-crosa@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231208190911.102879-8-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/23 20:09, Cleber Rosa wrote:
> The asset used in the mentioned test gets truncated before it's used
> in the test.  This means that the file gets modified, and thus the
> asset's expected hash doesn't match anymore.  This causes cache misses
> and re-downloads every time the test is re-run.
> 
> Let's make a copy of the asset so that the one in the cache is
> preserved and the cache sees a hit on re-runs.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/boot_linux_console.py | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/avocado/boot_linux_console.py b/tests/avocado/boot_linux_console.py
> index f5c5d647a4..e2e928e703 100644
> --- a/tests/avocado/boot_linux_console.py
> +++ b/tests/avocado/boot_linux_console.py
> @@ -414,14 +414,16 @@ def test_arm_emcraft_sf2(self):
>                      'fe371d32e50ca682391e1e70ab98c2942aeffb01/spi.bin')
>           spi_hash = '65523a1835949b6f4553be96dec1b6a38fb05501'
>           spi_path = self.fetch_asset(spi_url, asset_hash=spi_hash)
> +        spi_path_rw = os.path.join(self.workdir, os.path.basename(spi_path))
> +        shutil.copy(spi_path, spi_path_rw)

This is an implementation detail. By default fetch_asset() should return
a path to a read-only artifact. We should extend it to optionally return
a writable file path, with the possibility to provide a dir/path.

