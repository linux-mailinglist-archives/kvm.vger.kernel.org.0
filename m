Return-Path: <kvm+bounces-64461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCC7C83705
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 728614E12A2
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4897A280309;
	Tue, 25 Nov 2025 06:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i6PpPXou"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5EAEAF9
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051424; cv=none; b=W2mPgxy2KaK6k8YgT/+acLeZYEQN/Z8sM0WIPeLewj0JLK/54j4U0GhaCgBLfVYobHEn8R5P9weUi4mbtU/dYYzwAg8O1B8ecpiPsLC85hrXnGcJuwrOUCV/B0YG0c4TePWQUGS6t5Le10RWHq18T/QG009xI/uzZe1ajAzJj4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051424; c=relaxed/simple;
	bh=dLLW3UPPybX3mMSgc0S8cK70EA3CQTu0T1uNY5gjeq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RZdSzEVAKmeNuIJTL7HnJQKFSmia54BkhrkIzsPeo8Qt6l2C442hKZD6OUBjvIS/OwQAoKZY2LtK8h9W7PF8FramdfCZzvJvuEa93U+HyhSIdWq7qlf736a9CeyQ00OR+YNXgRLCvBjyVmSq4RbEjc/G2pJYhWbPdjGBRdF/oYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i6PpPXou; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so53517635e9.2
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051421; x=1764656221; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PPPfFfN/KUZJSdg4GVyykKSiNQuZspsjOUrb6Yk6o8M=;
        b=i6PpPXouQq3TTbXL9cZEWwpK+eafSTKD+EWu/8E5EAOwjOVYd9/8f7T4NB01Suvdlm
         yb2yfN/RY03mGoyIGcEsIsu5Y/xWANJKoQ/+8pweXjp0r6AHOk+hr9ym5VQuUFRhA2DD
         hubRtspIeiGEim4f1OksT0+0gE6jdXAr1nzywGV04FhKqljFUDB1ZgYjs6M85kwN2WiW
         2tBrrodFJSRyqvRH1Xj6UdcQinLkTDwmUwRGf3EvWVGx/CushvsPjOYzp/Nv7iuiC/sS
         EDGTFM2juF9eAcpDs7r5290AVDI+qqbpXIyZJwPbaQd9FVURYBfuhY2LwEPOTUufWH6j
         8svw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051421; x=1764656221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PPPfFfN/KUZJSdg4GVyykKSiNQuZspsjOUrb6Yk6o8M=;
        b=XJhqMYCoUXW8dc43hbQ0BWDk8JSl/jTMyZc7+Wkd2zrwOpgLioYBKih80WbfsJJBNI
         Pi8rKdtz+HT6TT34LoD/iT4B3pftGuUHFl8zWyytLiyc00EHUeruhcHQI1s/v0EuFrw8
         2mh5QuE0X/bgkHeqc9852ogOnnOeygksNcqpUOcQQW3c9mRQGY6WGbTVfoU9Gx4zLG++
         wNkyPX75X6TDvPCI7uqGmLbI1zOejroIW604Ayw290Xt5MxVMvsuPpf/tMz/+6OCRFsK
         B78f+1qg2aV4sHknwh/XcPKMQTxc9/sdzRXjXhc1dZjI+SUi2PuOU3EtPrbaOy5N/eaT
         ALSA==
X-Forwarded-Encrypted: i=1; AJvYcCUGUuSclYNodiY4V1yty/BF7ctoSsuMCgXTgW/OIxQwtmvVuFuKIi1ioPyWGRijxrGWQHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvwCeIeH92nUEMFlHa/pMnnWMArS8I4MIHqyX9lyD1RocWu/tE
	zjTFLGCfS67GcAvZ8TJvxvOk3lI9/tWJAiR8sbKgyEfGxS7SyOoy625sGYsJMq1Aj2c=
X-Gm-Gg: ASbGnctTCRAsyblTH6feGB4kWEC3xXeH9Zo7DHDaLu626X/PTSX53RnVHgrDVzj+lrV
	P61B+KMMQnLVuqpiHlchBYSiBS7LJCIoXO+gKp1pVJUn6AOziWBUaeb6eQJkJ5DrunuW1tjSLDd
	IiLYDi017rU0O4hA1UMvGiON6HRIaCNkXuoq1tAQKDPUaTOG0FIo5hqJI3WhJ88ThPpJgerpHWv
	ze58wjO10pXCfu8Y44jzbmBuAmnHwVbmXd1ImEyLE7ZRKt+PXaABQpk0EWvyzv8w7G0oalDL3V3
	dILmvuhtMF9uWdHd1pY0NWPsHnGjTFayak/0joIGwukKyJArhatFfzeiqdC4DgdHSWA1kxLMfcm
	bQTa7CZJ1eTSaBmFcUA0kYyvngVT64/pqXlDO9M7CQ3KQxbc73d0wrQhZX+uFFxP+hmoIvnExm2
	4wB0e02ITuKHi0k+/azwgZstBJ3kU8bes4Rp+k4ocQJTPWW6I4V7u+LQ==
X-Google-Smtp-Source: AGHT+IEZ8yeE/n/51O0eDQmUGk/RzXgmUxX0n0wP7TPhPNjZtJBLXLV0NRiL/n6XCwlWTPrAzRjq6A==
X-Received: by 2002:a05:600c:8b37:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-47904b1ab30mr12560125e9.16.1764051420782;
        Mon, 24 Nov 2025 22:17:00 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf3aef57sm221641805e9.11.2025.11.24.22.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:17:00 -0800 (PST)
Message-ID: <fed0991f-0ad8-4da4-a182-1bd0c7ec6b9f@linaro.org>
Date: Tue, 25 Nov 2025 07:16:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/15] tap-solaris: Use error_setg_file_open() for
 better error messages
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com, zhenwei.pi@linux.dev, alistair.francis@wdc.com,
 stefanb@linux.vnet.ibm.com, kwolf@redhat.com, hreitz@redhat.com,
 sw@weilnetz.de, qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
 imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
 shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
 sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
 edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com, jag.raman@oracle.com,
 sgarzare@redhat.com, pbonzini@redhat.com, fam@euphon.net, alex@shazbot.org,
 clg@redhat.com, peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
 dave@treblig.org, jasowang@redhat.com, samuel.thibault@ens-lyon.org,
 michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
 mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
 liwei1518@gmail.com, dbarboza@ventanamicro.com,
 zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
 qemu-block@nongnu.org, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org
References: <20251121121438.1249498-1-armbru@redhat.com>
 <20251121121438.1249498-5-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-5-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> Error messages change from
> 
>      Can't open /dev/ip (actually /dev/udp)
>      Can't open /dev/tap
>      Can't open /dev/tap (2)
> 
> to
> 
>      Could not open '/dev/udp': REASON
>      Could not open '/dev/tap': REASON
> 
> where REASON is the value of strerror(errno).
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>
> ---
>   net/tap-solaris.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


