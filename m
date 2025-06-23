Return-Path: <kvm+bounces-50340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95598AE4184
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B30C3A225B
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B00230BC2;
	Mon, 23 Jun 2025 13:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TwlqAR9s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5938D30E84D
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750683714; cv=none; b=mFJ6M1OKmizyPrHoN+i3a3X6xeBlGzn6ELvMXAXSIujDmqPBiYfgZHlxt2wiu+Mbv8+SUuZVES4j1gWLqTgDh1C/WI8FcbvKiFZq1jamNRVh7qLj2Y4xO/o1bv8PizkRZ2I6P326CQTv3F3mIUD6iRCl3TwEhbcJra3gAXLMkTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750683714; c=relaxed/simple;
	bh=GBJwZ2gncR37FxBpWiGDPUgB1p0hhBvAXpZwR1E3EAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QiP+rsfGxXX9kEHrK4GPogSsErwgKZeoycvCtmOyiSQVAoGgFBRB0/0dEXHHi6EKGdd9VGc/KdRbH+c9HhvyNOvkXNGwIQrllif7OP8Ta0JPLvnRH7LBkCBn0uZ6yOMk6orPeKORzWOmHw6TvhGaFclIsSEZo9e824bngCXYTGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TwlqAR9s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750683711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JH5umFS36US7IDsZT2yyveGcuseLmnIc9KBJy2RGDsk=;
	b=TwlqAR9som06MZDcdtOxrlnG/aLhzyaVMxpYVjJwPZKMJ+vqDUbbMc9eOn96MkcPJxFibb
	VbpNpUcPr+QQR8U4l5HtQpIpLQDfqhK6fboeurZ2dGaNKwtU+8FK+dA/6Ppzwr4MW8xObz
	E2ydmDZa4U38xeXCWv+CpuaQVA761yI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-r7z7kp5NNJ6_kSLYZxFDnQ-1; Mon, 23 Jun 2025 09:01:50 -0400
X-MC-Unique: r7z7kp5NNJ6_kSLYZxFDnQ-1
X-Mimecast-MFC-AGG-ID: r7z7kp5NNJ6_kSLYZxFDnQ_1750683709
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45311704cdbso28260155e9.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 06:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750683709; x=1751288509;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JH5umFS36US7IDsZT2yyveGcuseLmnIc9KBJy2RGDsk=;
        b=Oo23/kwZ1IQVC4mSjIbLjwL0MGXHpfIOADTKNQacRSLMIPgGIldBw7TXmDv9DdgHFc
         KEgE8WXr1nlHG9waawpZbU88qf7vt78irg+eRoWdliLrW+ZZXjyttRAB/B64kXO1vU9E
         O2UKTQ3urQyocQya4d3p1WpC4MjgC65V7g7Z9fdR1Op2TJob8uUHVOFdry3cVLl6EaFg
         zKXupus9Ah/BLzfEPjASM2D1ZABNQbVVaJ/bEU7oK297fbLg5R7/924AvTNDB3Dip5bf
         V55FJYiCpCCJS3CfdbNFRbK/Yerk6Tw6978KWLA4C+bh9TQPhRjopfYoVRJEL3BKSlph
         KWOQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0Li2neRuqOXpmG15yFuq2Q9oTPWZmIDqAOsah2MTt3TMXPVkkeWS/E8QLQoQWaCsH1Y0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpVZ8Ag3NWonTdHFVMWGtsbvmBF1aSLne/9oMNm79ucR/bHj1k
	wJ4MsDSQAn7bz5chT1pZXQmdwDbvRzq/cne9ak+QoJ1PL1Lb1ez01qsqqbodq42yekK+nMP4bBO
	FMHNMm9O1TnQHwzVg5+SSsbwEBFe9/phSSR0JUEP8fj2jMQJeF5S5hQ==
X-Gm-Gg: ASbGncv008IFGPb9Wz+fPTj6dmobEyotOe7XBF3KCAbSogXLO0RqMT25Us35ZtN2biD
	oTUdxhJkeV9/wZVgUxyiAsA7L+XERKj/MdazSl2YMCtBQvkCSmpdYX3vijkY1lPMELVmmyfBDf6
	fKVWRIpJApz09PYGsV+6Dnab3Dn2hK8Cr25oHJ1g6tL7nMSL3ca2aZv7EO9IS88yTEkTB/ovvrL
	iFN7gltZTUgE07JPxAlacbhCGyRfISlmttjFC0dL14ePhUvKaRoaFTJYmGGtLhGr7dGEbllcX01
	2ilyod26faxacXB9SNjMD7zPulzlHm5LmXr3T/Op4Ds6d0jSOTf5BiWLQQF+Y1A=
X-Received: by 2002:a05:600c:6994:b0:453:dda:a52e with SMTP id 5b1f17b1804b1-453659d762cmr95488495e9.33.1750683708552;
        Mon, 23 Jun 2025 06:01:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4LNS7iB5vBtQ6zs4YvFzVlcbYjrW33VP4WFNfO45dGrtWDPfaFa8IJ6jz55xc+W6h2c8R/Q==
X-Received: by 2002:a05:600c:6994:b0:453:dda:a52e with SMTP id 5b1f17b1804b1-453659d762cmr95487845e9.33.1750683708001;
        Mon, 23 Jun 2025 06:01:48 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-166.pools.arcor-ip.net. [47.64.114.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4536c77b980sm68667655e9.23.2025.06.23.06.01.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 06:01:43 -0700 (PDT)
Message-ID: <0107a85c-3335-478a-9414-55cfdd2f763b@redhat.com>
Date: Mon, 23 Jun 2025 15:01:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/26] tests/functional: Expand Aarch64 SMMU tests to
 run on HVF accelerator
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>, qemu-arm@nongnu.org,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexander Graf <agraf@csgraf.de>, Bernhard Beschow <shentey@gmail.com>,
 John Snow <jsnow@redhat.com>, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, kvm@vger.kernel.org,
 Eric Auger <eric.auger@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, Cameron Esfahani <dirty@apple.com>,
 Cleber Rosa <crosa@redhat.com>, Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
 <20250623121845.7214-27-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250623121845.7214-27-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 23/06/2025 14.18, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   tests/functional/test_aarch64_smmu.py | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/functional/test_aarch64_smmu.py b/tests/functional/test_aarch64_smmu.py
> index c65d0f28178..e0f4a922176 100755
> --- a/tests/functional/test_aarch64_smmu.py
> +++ b/tests/functional/test_aarch64_smmu.py
> @@ -17,7 +17,7 @@
>   
>   from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
>   from qemu_test import BUILD_DIR
> -from qemu.utils import kvm_available
> +from qemu.utils import kvm_available, hvf_available
>   
>   
>   class SMMU(LinuxKernelTest):
> @@ -45,11 +45,17 @@ def set_up_boot(self, path):
>           self.vm.add_args('-device', 'virtio-net,netdev=n1' + self.IOMMU_ADDON)
>   
>       def common_vm_setup(self, kernel, initrd, disk):
> -        self.require_accelerator("kvm")
> +        if hvf_available(self.qemu_bin):
> +            accel = "hvf"
> +        elif kvm_available(self.qemu_bin):
> +            accel = "kvm"
> +        else:
> +            self.skipTest("Neither HVF nor KVM accelerator is available")
> +        self.require_accelerator(accel)
>           self.require_netdev('user')
>           self.set_machine("virt")
>           self.vm.add_args('-m', '1G')
> -        self.vm.add_args("-accel", "kvm")
> +        self.vm.add_args("-accel", accel)
>           self.vm.add_args("-cpu", "host")
>           self.vm.add_args("-machine", "iommu=smmuv3")
>           self.vm.add_args("-d", "guest_errors")

Reviewed-by: Thomas Huth <thuth@redhat.com>


