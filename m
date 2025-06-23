Return-Path: <kvm+bounces-50306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ACBD9AE3EA5
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F073718984C1
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 11:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B9C2472B0;
	Mon, 23 Jun 2025 11:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SP9GppjH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE388242D9A
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 11:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750679622; cv=none; b=cPiMahxi7Q3tW/En5vGNCh2Q8cADuhaXAXXF/NfgYCuNSEcTNdGVYDq0dvqz2OT774ZgYWRMl9vrtuPOcUBpTmbNs/MdRkAJJN4LEHkKHnYMKOum78yTFO95o1sG873lWLrC0WEPOii0opzhiL4KTFVsBLhyJVx2XSLy2gZTRdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750679622; c=relaxed/simple;
	bh=i/DOrb3rjgYMhGcsnE7939urm8Hq13EkIv5qzaTSR8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/WCgcFq0WaO/24CqpRnkhy2W4MCfh9ILURqMDEEZywxUyH4rvvmivkVE/H+Pj7Q4KLNTJ23jDBC2cqI3heiPm9JRX7zUE+syzvZDAoI0KC/N1J0CmXs2oAwjWRB7jb6vL52bGOjVDYGJ+d698rIRPp2C1OIqwPXUzNdNNILO/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SP9GppjH; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4530921461aso30242195e9.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 04:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750679619; x=1751284419; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4UkoQNG73kAls5FXW8j8XArdkpFVe7XI2g2lDPVsTBA=;
        b=SP9GppjHAm6/hGlutk28JMYwji3NoaaIeSnRuFlKgE57au1eThgq132UtHEScd3fvv
         w9O0i2Df4ztaqqm3dZZ4HbUMJOdn+x3Yqeu6oTo03l+gL3ezEu0W9UwKj3Ie4c2QUr3E
         aUYLw4JSeWDoGf6RyxOl4J/8nw5iu3QwMxEIs7MnLQjgZ88uo4TBdF/PtHd04BfgLhjj
         EVHA891yBJgEt6MYZEjNIfaV60+ayfVvtIs4pPhCDLggMggFCkgyG9iPDWq3rVYYv2L5
         eYejnDvDo0hyA1yekN06+aQtCdGY/6/HoGgZxnjWVfHobG2dH7qMiHYEOu4TwUs2bR8I
         J9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750679619; x=1751284419;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4UkoQNG73kAls5FXW8j8XArdkpFVe7XI2g2lDPVsTBA=;
        b=fjDP5JIxU+ViTG3jTb0mFyqXYfcNBS2OqHAMcF/O8E9uN3eIm6jmcyFTkVO5+HlEja
         yJhD6PkkYF/Rq0Lv4wydUG+UH1fdOItOLM92B0zQnJLFy9ql3gNQyjrLqSB3qyrWwKJk
         UqAF8Px4Y0wH3LSoZxHFe/NKu5Y5Y/E6BM2HI385qYmoCb4nyFar0j0b0u6rV2XtfAgg
         Lups7bY4COwyHYDyGES3ZhkMDKPJo4BS9T0BioguFZfe9cAa1tJ7Vbou8RndfXB5Gnmr
         fbgUQqdxNx3kXgblydlHN4BY3wi14rNM1EzBOpBX8TsFPUL4C/fP9m1IkV3Bxxu2QsCO
         FdwA==
X-Forwarded-Encrypted: i=1; AJvYcCWoLYfwZsFwvq7L6tw+ZzFGFtc/ktUc2vj9OQ+X4FL0xTCKmc6VR4Q04EYVO3HbbqTpA/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgTyj05jDfxeOOW6PNzrVCLRf1/rPyDb81Bq+09KxixuUbuYYM
	43JildAQoiEYwfnNLBVHN6u0guNnTGgqWfIA5gitDN00IWKCua+dOraNvLSzubECLBQ=
X-Gm-Gg: ASbGncvRuZnWlN6m1q2FlW6Z+n6LpvmJcwizMrxo8zT+Jp+L01Yuxhq0Y5MI++QQPea
	ni82P+5bFXq8sRjPylnbDI5V4HPz1OPS1T0SraDAyl924Gz5NqPIf8qTHKBEpfulCjYUut0FvQ7
	Ie2gFIydDu37sJsu//7gve+M3s+RI5iUdEoYdJFdSxDlTl+FGvtX86iCIvdUBuK1GP9EtdYcTTm
	pb/VgKW8RCHUnERtAjr4sCaX+wTbfCS2A3murJdcs/4RZNvsk7P+BV5sWfAInan14OL02vjIynC
	JkrZ+Aaj6NIzHDmsfElYk42Ej0QiJGnzVR6bqNm3jdsGAQiko9yt+6R4UK6bS4clRFTu20d4B7N
	TfNNR0rhDX8LGwQoKtCIq5eAA5xuJzQ==
X-Google-Smtp-Source: AGHT+IGRCN6iUoyXqRv7gWL3CyrqT7BwgRkI/KO/oALd94G+AMGsRYNNsEs1oFkM62KVQ+Wcsduwjw==
X-Received: by 2002:a05:6000:230e:b0:3a4:ef48:23db with SMTP id ffacd0b85a97d-3a6d12f9af7mr10786713f8f.59.1750679618956;
        Mon, 23 Jun 2025 04:53:38 -0700 (PDT)
Received: from [192.168.69.167] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4536466596asm112628545e9.0.2025.06.23.04.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 04:53:38 -0700 (PDT)
Message-ID: <94d6e871-fcf1-448a-8a6a-f6a7f7720882@linaro.org>
Date: Mon, 23 Jun 2025 13:53:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/26] tests/functional: Expand Aarch64 SMMU tests to
 run on HVF accelerator
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Radoslaw Biernacki <rad@semihalf.com>, Alexander Graf <agraf@csgraf.de>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Bernhard Beschow <shentey@gmail.com>,
 Cleber Rosa <crosa@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, kvm@vger.kernel.org,
 qemu-arm@nongnu.org, Eric Auger <eric.auger@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, John Snow <jsnow@redhat.com>
References: <20250620130709.31073-1-philmd@linaro.org>
 <20250620130709.31073-27-philmd@linaro.org>
 <c8d2da2b-f44b-46ab-baca-de8b9a4c25e5@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <c8d2da2b-f44b-46ab-baca-de8b9a4c25e5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 23/6/25 10:23, Thomas Huth wrote:
> On 20/06/2025 15.07, Philippe Mathieu-Daudé wrote:
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   tests/functional/test_aarch64_smmu.py | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/tests/functional/test_aarch64_smmu.py b/tests/functional/ 
>> test_aarch64_smmu.py
>> index c65d0f28178..59b62a55a9e 100755
>> --- a/tests/functional/test_aarch64_smmu.py
>> +++ b/tests/functional/test_aarch64_smmu.py
>> @@ -22,6 +22,7 @@
>>   class SMMU(LinuxKernelTest):
>> +    accel = 'kvm'
>>       default_kernel_params = ('earlyprintk=pl011,0x9000000 
>> no_timer_check '
>>                                'printk.time=1 rd_NO_PLYMOUTH 
>> net.ifnames=0 '
>>                                'console=ttyAMA0 rd.rescue')
>> @@ -45,11 +46,11 @@ def set_up_boot(self, path):
>>           self.vm.add_args('-device', 'virtio-net,netdev=n1' + 
>> self.IOMMU_ADDON)
>>       def common_vm_setup(self, kernel, initrd, disk):
> 
> Wouldn't it be more straight-forward to do something like this here:
> 
>      if hvf_available():
>          accel = "hvf"
>      else:
>          accel = "kvm"
> 
> ... IMHO that's nicer than duplicating the test classes below.

Good idea, thank you :)


