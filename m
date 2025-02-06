Return-Path: <kvm+bounces-37465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA273A2A4DC
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ACEC3A4BCF
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9EC22653B;
	Thu,  6 Feb 2025 09:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q6GvyQiA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7F226531
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 09:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738834976; cv=none; b=KAXWlNqFV4Z/fHSzC7M9PN7qqaMezoQeIonhMZFQXTdeUextE2XPiqUNtAvpCoMALqDjiRly9wOFUOmna1bsYD+FmgumNRZmnJCkm1lFX4SVXyYYZtlYmmEgRZhZidak6v8YA5FEIE9SD6VPrAWNyG0zEzaLIJZNYvdhZO3DeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738834976; c=relaxed/simple;
	bh=VFkyW/9o9OsKAhlIZLLpdKnw0SuMGs51V6RzceBT4pQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9sH4rRsfpEKlRfivB4ZtI8KIOaLlpTluqE/5lqcB2Rzm+7ZFWvrG4y5uGvJ5gY853S5gD3OfbcuzsEBJAHeWlAvi+533Z7fsGBERxT8GuzLctapZeXoh70U/t/ebmIExItF8XKkW0JFl4WHvWYkxniFkERpT85NjCwf4o2p90Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q6GvyQiA; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38da6dde4c0so270944f8f.1
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 01:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738834973; x=1739439773; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CCnPKoirm1TSgXa3aRLOwDR65B06aXsySVkxKtLtNgI=;
        b=Q6GvyQiAQT8t9/3cclgGvIfNuKY2UsS+hHf47vA+SCfza+ad7X4lostPG2dJjh6eAc
         LSPzl426/Mt8gLRTu/2j3iNCGbiUWvk+M3ub0H82h0flkXlbU+WIjKd+IF0XIKp3jKRJ
         FmLEK39AiKeTTY2BTijgew7Hre64GMoV9LpvREoVNqoFdthXehCOVEO37vuWdenBBI0k
         rA1WRBcXjyaK5YiZXSuh4qPiq+Ym3ncwaQ9JwVvRb9FQZvobA4oeMl+nME3Eq8c4Pr0a
         eiRFzD7qNTbrpYenuw6PBYm8F0+QJwxdR649ovJ6XPht2Jm6doKh+/3+8YoO3but+Btb
         lq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738834973; x=1739439773;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCnPKoirm1TSgXa3aRLOwDR65B06aXsySVkxKtLtNgI=;
        b=XwyIyy05VAH2Ey9ujj7WQn5/w+qBGlAKwuLvdV40L7HqWqrYqGAAWJUxu0/qaZ2ALj
         iu5lp/DtBjwQWKNhPst3dLsktChr7zIwwI/cBH8dxvozQrhk2mrcLP4wTj54ywQS7YDo
         Qq2g5l2EvMCHzutmdUhSXPhYUtl55oHDzJsE6PVSy4b/Snhtq7rqnsZRRfO7UGwg75jF
         b2jMi2/cNm0Vcdpuy4t73soDoue+5MgqTFUPcMGqc4Ti/XxkkoTAdzcUCwpI2nVYlHHP
         tkDJa8abP7ulHWxlDHN30mDT0BMi88zvGsF9/91hZ5AnQz6FREE1CLsDQNf0q5VrTzCp
         8Yxw==
X-Forwarded-Encrypted: i=1; AJvYcCUVTKtyi4jO6A8WPdZSF8fl1sE4o61PdaoseAMZhWZh08OYn53AjtDnQpOICbzhutJMTfg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8oFYfIzuTja2O6uWJSA3QmYLF2ckmAV/ZM4iIdifHe0GDbenu
	lHGHwLOHRlVEzm9LOUkp+3wlnSqyT5pEB+sbsJaDsC4UkSqCScTDyHo/Uois7Gs=
X-Gm-Gg: ASbGnctu3aUO75pIrgBzqjRmWoiAvkMAcOKk/HBQ5oOefStIPN58WILFzsWEaVlIP0X
	laGgyc3Xc4biI5EeEgHGbqd8OCy1oerfVaW+B98FgBQMMjHtZrJWolbWQKIkV9KemgMYxVA6NVm
	Cxt2s03awe49tuMTWZNrGxd+G3m1kUbjVQdR8K7+CcNEc0FNAxOvvYIkqXCFKquNNeLcXE77zGe
	VR/NUB56ctpI7c7xFE7LxwwW4QhrGKXPSzy00cdPXmRZshyXXAMD3J/LtZWCE2clnRSFtISZ7g2
	RQLgagmXnvOYQT+28vPESO0+0AQkEdzDPTFPSybjP0QxSuQjVUFGgaWZnl8=
X-Google-Smtp-Source: AGHT+IGtFmjOQMG8Z2at6sipDcZ2CAydar5VWnIhNv1yp3/esDkSfwJNJfkhZjutC0AyHcluoSHTwg==
X-Received: by 2002:a5d:47c1:0:b0:38d:b325:471f with SMTP id ffacd0b85a97d-38db48bcaccmr4357212f8f.15.1738834972558;
        Thu, 06 Feb 2025 01:42:52 -0800 (PST)
Received: from [192.168.69.198] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dbde1dc1dsm1220023f8f.87.2025.02.06.01.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 01:42:52 -0800 (PST)
Message-ID: <adfe1b26-7e5a-4ced-92c4-9d396953f197@linaro.org>
Date: Thu, 6 Feb 2025 10:42:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 RESEND 1/5] hw/core/machine: Reject thread level cache
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Alireza Sanaee <alireza.sanaee@huawei.com>,
 Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250110145115.1574345-1-zhao1.liu@intel.com>
 <20250110145115.1574345-2-zhao1.liu@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250110145115.1574345-2-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/1/25 15:51, Zhao Liu wrote:
> Currently, neither i386 nor ARM have real hardware support for per-
> thread cache, and there is no clear demand for this specific cache
> topology.
> 
> Additionally, since ARM even can't support this special cache topology
> in device tree, it is unnecessary to support it at this moment, even
> though per-thread cache might have potential scheduling benefits for
> VMs without CPU affinity.
> 
> Therefore, disable thread-level cache topology in the general machine
> part. At present, i386 has not enabled SMP cache, so disabling the
> thread parameter does not pose compatibility issues.
> 
> In the future, if there is a clear demand for this feature, the correct
> approach would be to add a new control field in MachineClass.smp_props
> and enable it only for the machines that require it.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since Patch v6:
>   * New commit to reject "thread" parameter when parse smp-cache.
> ---
>   hw/core/machine-smp.c | 7 +++++++
>   1 file changed, 7 insertions(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


