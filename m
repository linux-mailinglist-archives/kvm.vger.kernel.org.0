Return-Path: <kvm+bounces-22509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7497693F85F
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 16:39:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02DE21F226E1
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 14:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13F0153836;
	Mon, 29 Jul 2024 14:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xbzq0U26"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AE11E892
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 14:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722263958; cv=none; b=Tjqev2kerytsZjFqf+B8eoHkwDnhOmGvgIG9W1GXVwwtmaWLSWEJ2lpl5xvIk9tkK0L/DyF6KF1HAzGGyuVYDDrb8KHDNdm1deXkpIyFganQpP9yfo/auhD4qXrwvNeROMctxuoKhMXWutIj8YEu3iOxhkHrRaLQR1zc0btQT/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722263958; c=relaxed/simple;
	bh=lskGcXwNRHgIXeJGKefgED+jOEFP8EiMmkGbzTFqjS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AkgmV2aQT5zrYq1Zy3Wv7jwVBOdZ6rg+IqEb6BoKquioQsgJ0qulx3GFyYtl33F2F8atJYpSJrYBiLTDkit3rhLK6YEx5zLK6UvpCCFY02+dewM0wNOpxNLG7MGINxiC33EZrwMu6i+0xsZLClKHZ/Yangdm8UBe+lrw0wTAFx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xbzq0U26; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-368313809a4so1190967f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 07:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722263954; x=1722868754; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qEnyOvA1X8TKi0lsodpQGCil95YO2hb3XDAGCjbudWY=;
        b=Xbzq0U26hv1bDT49YOZW3iW4yInXAgB8Gr1lKuag+oPZ7A6zB06mYgCWRa6yY6s9Cy
         rkNj3NFBW+GzS0n5U+aj34RnyJYmlhhUTx0m7yKq0d+Mle4O+t0F0tUUxf7Zxp4yYC3+
         neA5MHt5ghYQRh01H4Ufe40fDf6EBjlFnMwLxnZ9ojbeu4SEypYHTT+yRM3RlQ5VBI39
         4+yguME3H9VWbC64InfRONC/oqAEo/ujedXTwbhPK+c78M//I+Z9NBl+pm3o1mAASPmF
         TCHtdvVGpE9nsQqB4jfTKkThxwi5TFDJcvjZHvLEnX1Xsbdkrskq2l8n4XdN3Lv+VHOe
         Lzcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722263954; x=1722868754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qEnyOvA1X8TKi0lsodpQGCil95YO2hb3XDAGCjbudWY=;
        b=nI7yMeC5fozPkygkKQ/2FEFN71tGFlg2Db573x4wp4oPPl/KKCkpuTP3YsjS6ZNA+G
         MuvWdDCMZ54eSWoC18C6KJ2Tj1uhtQr9Oktyp+TXUUXVdyH9ndg0yxgmIIX1wSpfWKsf
         bMtFUtFzfBtshZX4Ix15FLWywyYuZm+jlUyxHCUanApZNOnRASRZt2hVp8cqciWe7d96
         js/hJyzn019XYN2XDMONZqnA9Jgcc6bMhpEtBEraiUCdS9qsPpVi/Rue6ylpsKcka/iY
         TvTGW9qr4x8spLVEj8Da7ZXeEVfa+4BLYtFDPoI9wk4Tnoy99fOf4pska+cxO0lRsQ0N
         +Taw==
X-Forwarded-Encrypted: i=1; AJvYcCWawt6fLPkt0Qvc60SpcyP5ZKoQJ20J4t8Uz+KRDQELVxAbJ3ESTfj00GsTPIbFN1e9aDlcG2HcCTP8pNjZdOIyHYZN
X-Gm-Message-State: AOJu0YzoSTQMDlaNTsvE5vH2TXkAlixQZvCy2IWMXF6dvly7SjXGoGFz
	52gSMutwZCDXtJQhERTE6ht5WizSIniDrhHPD0RONlcbycJMC3t4nuYdt3NjdaI=
X-Google-Smtp-Source: AGHT+IGhrXmQOvCwdmc/mrVWsNfUM8NWLaSEVksL1o/NLVYFClufq9VU4ziPQrR4Ung5I6UYQQ0o4Q==
X-Received: by 2002:a5d:55d1:0:b0:363:ac4d:c44f with SMTP id ffacd0b85a97d-36b5d7cf02bmr4471297f8f.17.1722263954418;
        Mon, 29 Jul 2024 07:39:14 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.173.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b36857eb7sm12396324f8f.66.2024.07.29.07.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 07:39:13 -0700 (PDT)
Message-ID: <a7f2d78a-4de6-4bc6-9d54-ee646a9001fe@linaro.org>
Date: Mon, 29 Jul 2024 16:39:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/13] tests/avocado/tuxrun_baselines.py: use Avocado's
 zstd support
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Beraldo Leal <bleal@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-11-crosa@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240726134438.14720-11-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/7/24 15:44, Cleber Rosa wrote:
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/tuxrun_baselines.py | 16 ++++++----------
>   1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/tests/avocado/tuxrun_baselines.py b/tests/avocado/tuxrun_baselines.py
> index 736e4aa289..bd02e88ed6 100644
> --- a/tests/avocado/tuxrun_baselines.py
> +++ b/tests/avocado/tuxrun_baselines.py
> @@ -17,6 +17,7 @@
>   from avocado_qemu import QemuSystemTest
>   from avocado_qemu import exec_command, exec_command_and_wait_for_pattern
>   from avocado_qemu import wait_for_console_pattern
> +from avocado.utils import archive
>   from avocado.utils import process
>   from avocado.utils.path import find_command
>   
> @@ -40,17 +41,12 @@ def get_tag(self, tagname, default=None):
>   
>           return default
>   
> +    @skipUnless(archive._probe_zstd_cmd(),

_probe_zstd_cmd() isn't public AFAICT, but more importantly
this doesn't work because this method has been added in v101.0.

> +                'Could not find "zstd", or it is not able to properly '
> +                'decompress decompress the rootfs')
>       def setUp(self):
>           super().setUp()
>   
> -        # We need zstd for all the tuxrun tests
> -        # See https://github.com/avocado-framework/avocado/issues/5609
> -        zstd = find_command('zstd', False)
> -        if zstd is False:
> -            self.cancel('Could not find "zstd", which is required to '
> -                        'decompress rootfs')
> -        self.zstd = zstd
> -
>           # Process the TuxRun specific tags, most machines work with
>           # reasonable defaults but we sometimes need to tweak the
>           # config. To avoid open coding everything we store all these
> @@ -99,8 +95,8 @@ def fetch_tuxrun_assets(self, csums=None, dt=None):
>                                            asset_hash = isum,
>                                            algorithm = "sha256")
>   
> -        cmd = f"{self.zstd} -d {disk_image_zst} -o {self.workdir}/rootfs.ext4"
> -        process.run(cmd)
> +        archive.extract(disk_image_zst, os.path.join(self.workdir,
> +                                                     "rootfs.ext4"))
>   
>           if dt:
>               dsum = csums.get(dt, None)


