Return-Path: <kvm+bounces-50286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AB26AE384B
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A58C716C999
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 08:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35201214801;
	Mon, 23 Jun 2025 08:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JU6TYrnt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FE54409
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750666991; cv=none; b=pgsUga/rcdzsNMMUzk4EjcYi1kbck5hKsc2kHDCEUxIgRnSB85k0KjfvOkNblGKfWymJOUqCbpxKFIGEGyw3p06cXjduo098AtOZGy+sI9KxFXqaX8CRaCn649zf8AuaF3bgvw+5JnYkdVzFv2T80KqTu14QscBdrXIAnhVmi4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750666991; c=relaxed/simple;
	bh=jT7EZ3gDEKm3ENw0dG2OzNexLEilhwcyMf/7tzRn1/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XN+a4Rm/63yf4LknVldoPUigGNBA4PtZxpS1/XKiMQ65wcDTyECNrX6qmfaBaaEcE5jE4zL75ZjQvRFNnaO200bXCo9bgrgaky3K+Pv/enJxDMBbQbX2kiHmOkoFvPjNz3s81GCnThedaQbodVOrUhSuj5IApcRnulzX9Z8O2LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JU6TYrnt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750666988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hdcp9RwtfZi8FMSc5dPMRPQIL7xDdgS875H69vG9FfM=;
	b=JU6TYrntJXHFy2qNwuuUhSEYcaL1y6Oak6QTSh/UzNyjGj6jXr24WjG9MzKJkdnCcEh6J7
	y3g/hhKTyzcEWWb8x7YxIPHTo+5nUopkk/S3/QJ6sYnkTpqZPbX27hmowSCFBKv5jFqAyX
	bVO89nOSIvtVMRUXs66ccbaOBfyBdH8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-_fgTCg7lNCKC6E9m9M07MA-1; Mon, 23 Jun 2025 04:23:06 -0400
X-MC-Unique: _fgTCg7lNCKC6E9m9M07MA-1
X-Mimecast-MFC-AGG-ID: _fgTCg7lNCKC6E9m9M07MA_1750666985
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a6d1394b07so1496641f8f.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 01:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750666985; x=1751271785;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hdcp9RwtfZi8FMSc5dPMRPQIL7xDdgS875H69vG9FfM=;
        b=IlCjXWIB/XoLibZNZkuELlKdHFpV5+FVztSq55bLlJ5TEiMXOSWIZgedsO0VrlGrNV
         9/1Xq8mrdDAVqF0gnB1CrKgB/TlDhYxY+o7cABLVvOuku4Kxk7CU0dmSPoGgywVareZT
         jVtcAtdMatN5l5gucDwFy+4WiXzurw5fEP8yAhYRQQgl2UJNIBsi20NSAPP6qnnV/LRs
         sydvN+kKBD2RvG/x4BvDSDngueDA/izQ4YHoGQ3PyxTT2p2oJDoztNgaufROpQWxIp8I
         R/6LOe1+R01AJ2R7iKFo8T53P/Q5bCZ9bNeW+kZT+7cIY6hVlfV5tcq1+yz+l0qwSV9h
         YV8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWffYKlVtvolQubOnpZRfY17oLhVea/DlDN4/E+dnOhpStmJNHDoHSvHoiPeMeONvwkaDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMjuIvbf/tibTuy2LvKsd3hXUdO63FZ0Vs5ayvNw3+BI72387C
	JC/WqrsEWYAnlN7oGz5ejVQzPDmJt1zVNh69yrsFr5Usx40stMiQDdBEmsZEiI1xlAevIO7wzjD
	D2RnwUeJEOhWad8bwdwbJSVLWYBJhZiOAzY9ajfHJR0dNpgUWyQepLQ==
X-Gm-Gg: ASbGncsa7dUGCeHjR690E2+jGqW1esCWiM340TCOmrGUIuuWPEgZtulk7VdDu0ytTx7
	iAreEO19JNWbPiEEIDveg0zKMoKhzncVSRBqGfsP71C+eawnLBy7Xx40n/bkhZhtPMG3sr6OP/1
	5L42Et34TTNZJ2v9kggP6Wt6oOL2snTN+5JMgfjF58pRWELQNNAMLYkviIsIvdqLOu5DBAj/IQU
	2ZUq4ztogo6B/x98cvvy8qSWzqEm8eEJ3BP0kOadVh27J6ipkgbdRkR9v+8CBTFlyCBZvjLc7Rq
	TsHc68hZZaO9+0jOCBJKtyj1zKOG56wxFO2EBPP/aQUrs314lDDeODVVaqGGmN4=
X-Received: by 2002:a05:6000:2111:b0:3a4:f6d6:2d68 with SMTP id ffacd0b85a97d-3a6d1314667mr7319754f8f.56.1750666985456;
        Mon, 23 Jun 2025 01:23:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHuFdh/3OHmpcX1gjUBEaKfgix1OYvNvXrCo2m+GurC+ynCyYQRv3aqbi+XZ8/v4Jo85Eu9bA==
X-Received: by 2002:a05:6000:2111:b0:3a4:f6d6:2d68 with SMTP id ffacd0b85a97d-3a6d1314667mr7319723f8f.56.1750666984983;
        Mon, 23 Jun 2025 01:23:04 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-166.pools.arcor-ip.net. [47.64.114.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453770470b3sm17430525e9.30.2025.06.23.01.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 01:23:04 -0700 (PDT)
Message-ID: <c8d2da2b-f44b-46ab-baca-de8b9a4c25e5@redhat.com>
Date: Mon, 23 Jun 2025 10:23:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/26] tests/functional: Expand Aarch64 SMMU tests to
 run on HVF accelerator
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
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
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250620130709.31073-27-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/06/2025 15.07, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   tests/functional/test_aarch64_smmu.py | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/functional/test_aarch64_smmu.py b/tests/functional/test_aarch64_smmu.py
> index c65d0f28178..59b62a55a9e 100755
> --- a/tests/functional/test_aarch64_smmu.py
> +++ b/tests/functional/test_aarch64_smmu.py
> @@ -22,6 +22,7 @@
>   
>   class SMMU(LinuxKernelTest):
>   
> +    accel = 'kvm'
>       default_kernel_params = ('earlyprintk=pl011,0x9000000 no_timer_check '
>                                'printk.time=1 rd_NO_PLYMOUTH net.ifnames=0 '
>                                'console=ttyAMA0 rd.rescue')
> @@ -45,11 +46,11 @@ def set_up_boot(self, path):
>           self.vm.add_args('-device', 'virtio-net,netdev=n1' + self.IOMMU_ADDON)
>   
>       def common_vm_setup(self, kernel, initrd, disk):

Wouldn't it be more straight-forward to do something like this here:

	if hvf_available():
		accel = "hvf"
	else:
		accel = "kvm"

... IMHO that's nicer than duplicating the test classes below.

  Thomas


> -        self.require_accelerator("kvm")
> +        self.require_accelerator(self.accel)
>           self.require_netdev('user')
>           self.set_machine("virt")
>           self.vm.add_args('-m', '1G')
> -        self.vm.add_args("-accel", "kvm")
> +        self.vm.add_args("-accel", self.accel)
>           self.vm.add_args("-cpu", "host")
>           self.vm.add_args("-machine", "iommu=smmuv3")
>           self.vm.add_args("-d", "guest_errors")
> @@ -201,5 +202,9 @@ def test_smmu_ril_nostrict(self):
>           self.run_and_check(self.F33_FILENAME, self.F33_HSUM)
>   
>   
> +class SMMU_HVF(SMMU):
> +    accel = 'hvf'



