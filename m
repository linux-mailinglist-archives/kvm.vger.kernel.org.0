Return-Path: <kvm+bounces-60177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD7ABE4CD6
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1450B35A1B6
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22D843AA4;
	Thu, 16 Oct 2025 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BPpLMzxg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFF8334693
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634865; cv=none; b=oMVZOGcbsyYNL+GyBYbkcMN089dxFsrkKiu0WpRA1h3EJhx+spqrH/YtJmMYYNISroovuNRRV1dFHK4BxFd3/ESGkQ1GlZ/sciGGt68CdBHHn5ZKZ0/Z9T9e/Rw5Xecj45UQr7xEW3IvOYiiWBwxwCyW+UD6XG/6VJHeWKAFTZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634865; c=relaxed/simple;
	bh=k4ylIO/smI64lTOcrgb+Q/qepne8otEaYUixXOse9yw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XquhkW3kYtCttX7AZvDUMO8+0TwkBJX9ILZuGHaBFcs0B80sUXvRqnTQFVB+VGEM7CYrCLBUkeIBO9ifpOfYhJCrQ1qYGT+Sgcsd9EEnIPhdvDjzKcQ4FMlIcz7nwAcci9yyrGQUV3PEvxa+pd/oxz+DjW9Q0uBHOOdXwk2zNws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BPpLMzxg; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-28a5b8b12a1so10414765ad.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634863; x=1761239663; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xbf8AuRX9mwiNpLkN8rUpE4f3cRZY7K2AwrEPz3vr+0=;
        b=BPpLMzxg93vGA/dYidJx/YKG5pkUb+8APiPCTnpqW0kpNrX7XlKlwbwdrrtnBAN3++
         8T+/ur7NOXo25vZoIaZeMcmydDFOk0qpTmNYJnVz5dmymMUHlqGMHsh97QVmEfkrGOCn
         ED0tZ6gaoNARl8RBtOeNcNv64GyyuIHPXO9BS6lkXUlUX/CvlEbm8c91R/aba06T4nCx
         1MhJhMDrXW/kzVKbkAGweyQ79DlEcaZIWK3BHD9h5pySFSeopqEgD79lguyBGpZTJpdT
         Lfg4zLgvJB3fbkbDZB/5USNRt0L1Z4dovSLgvCOuf2aw7M6yaKnzN1+CMkDaWJLHsyw9
         /2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634863; x=1761239663;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xbf8AuRX9mwiNpLkN8rUpE4f3cRZY7K2AwrEPz3vr+0=;
        b=YZ8PpOuKVvqxSXyYZH6WyRSOca22Pi+7fZZrCgNAoXEBoe5ERzIkkYdQDfUJ1wSYXR
         QPzweYEp0cKawT8KsLPqsYo0WLrTef5sJk6h8u96gJaSuBZWWdd+bbqinps4b+N+6rf/
         XIzRlVLTA10NKIdya9rQ7dsW3myCSgAm1WdZ0cn108W1zbC6d0rkmG9NL8Ua+a/huDNF
         gPTGT1Y1795in+xgr1/ViFrrIRqOBAbwCHOuMOAYfX4XZ6zjWhYdVSaJQ7sfbbouYoxx
         8cM9KuHRSXmBHz43xtuNQoocDfjQxBlJRYrHjV9X7E7/0hZnA0s+Hv2YA9mDwmd/7vP/
         XbTg==
X-Forwarded-Encrypted: i=1; AJvYcCVINm5T7vQJWeaJOwTBTnX/BZUsMDz9d+Qb8Oy/RFV9CGV2qDAkHx08chWLwW8y/3oW5dM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy74GkowDZO2QmIoQIqxooYv6dsvePChPWTlomeEfnQhZee2evi
	gsAcDpwPgdKK8DA/tySgmppIKevbd4sO8asv/F/I2JTfVFJ8PbHBi4BHVnwGOutRxjw=
X-Gm-Gg: ASbGncsJvOzdmYF2Y5hgb/24k9BaTpf980ITEM94thphNrNE4KNaKRcloYRc7X4Cp3l
	mLs3nSsLRawT75z/EM67no7LqmxRQfdPvQDLfLk8/CEuV4tVAVHTzCX5/Ga4m+GZaopwuQzOtOe
	eoHOj9l+JU+t2iH54ImFUPfW1f/k9p0Uxf6YVEDJ2o2Q30KX6TzWLW5YHaDxsA/cTpXak/2fjTa
	cEGHpixdcOn2M6t6KSwN225biZdXEhigl56k93uWYawl6ocndeN6O3dsUqPTWXJtb1JToHV/68p
	GM0BujSkehxh+PQVxrahWtpwHZop0sxUfv9t1Ua/tJYZUv0w3eRZegGjBTnz5zhZDbjlotwdsPq
	qQpITHDcVcQBTA5mGXo7a3w3m/1hwZfz992GZfaHT8N4+Q8ohfR/l1xewXxFGpmXpc6++HFT+Sx
	j/43L6GpPQIOPvz6ILDZB5Y+U=
X-Google-Smtp-Source: AGHT+IF182F4lmL6LvxLkrYofl7mXVzTygfR3b9k9De4jgcnqkzNqlvOwYury9mzQ7IWDkZNzFWKJQ==
X-Received: by 2002:a17:902:db11:b0:240:48f4:40f7 with SMTP id d9443c01a7336-290cba4efc9mr8442235ad.39.1760634862800;
        Thu, 16 Oct 2025 10:14:22 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099aba062sm35990345ad.98.2025.10.16.10.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:14:22 -0700 (PDT)
Message-ID: <e760f90e-497a-4e8c-9e2c-87195f2b98de@linaro.org>
Date: Thu, 16 Oct 2025 10:14:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 21/24] whpx: arm64: gicv3: add migration blocker
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-22-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-22-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
> GICv3 state save-restore is currently not implemented yet.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   hw/intc/arm_gicv3_whpx.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


