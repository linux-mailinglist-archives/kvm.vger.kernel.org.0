Return-Path: <kvm+bounces-41112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C08A9A619A4
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 19:39:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10AF3460ABF
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2048F204845;
	Fri, 14 Mar 2025 18:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H5fdUTqP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49F41E5B9E
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741977577; cv=none; b=QKnY31WnNFN/ZdUW/wkXstNCnjvaBplpazCATbx0cJOqXaJGlsK8VlhjJqZDuIFf2pYj8rtXRw+SfBSMmdLwylt/LuusxzGAKch7etKE6Q3XcZcb5T66eMpisa/lBthb0L/8I8Fqpov79SBCyNchTUcEWLaynskArV6bTQ8A67c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741977577; c=relaxed/simple;
	bh=DyyJGHkxJ1e0jJgzN0bsvEcm5LGwn20cHFWh60M8oR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p9br+2m27VEejtq4ZKVcjLGBTZa0hZIGb07cYL6V8kY1caBho+TsJDom/GfhkVTs2e9jnQVCQa28/rVM6a9GjzWTBwszSthdrAadz+OI9/6ajQc0dLIz1goFD0Slte2NlXLZUF8c5hf680i/iExSRzNpkNT6oCF4Q0EikobwBI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H5fdUTqP; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-223a7065ff8so67374735ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741977575; x=1742582375; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fOozeBnii/eu0U/Pc7KwHCWiz8f0qLLsCP/hc4MPynk=;
        b=H5fdUTqP7OPHwHyB0+YmTx4JbX8wx3scZcGy1pJIwhXedUsp1dG5+kOkWLxmYztTdQ
         Y8iX1s0Th2ia4BkH+kK5Qon5COuyGp6s2VwpNoPVutRbEqJBOeyGhNTGjHlCUer76sAj
         MG3roa0Q3+vA+kbSJfusT9J31e3dnBzq3pGcyGehqEKi0A8HQx5l3JmokBE0h8bk34gj
         QuVXlP7qAUpuvyCdL2Kds0JvrdYNMYmfBCkXZYoqXpJZWOWva4r07GO/FYm3RB/DpSdm
         eQkoF6Kr09AjL5ctFg4o4WnKCrN722byOkJpoQQMlumcjEAzjxFTc5p3fc0rGYDL0PDp
         2Tgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741977575; x=1742582375;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fOozeBnii/eu0U/Pc7KwHCWiz8f0qLLsCP/hc4MPynk=;
        b=IoAik6D+MRtNNf5BpwAoj802ouZCEAEjM05NWYBy71ieP2CoTljYd6mTWrHiorOOpt
         54NzfMrQ0089EtI+JLvytTQqzVjskyBUiM4ZTH0Iq/9J/yxZYb6VZP2qwQd5ToYctVEc
         udLwjntd5+eXhPWkw/SUJG/a11FyE/cCIg0QOZZz4JOrCOsqtBL5e/MppLo4rx598k1C
         NqprlB2aExbMINU+/qNi1TKz60s5pgjZMem2c9wE5TnnpkkX/EcdHSSMTREGhRoobips
         hG4dasZOMFL3xaeUXkEN9fj0ePztCDlSOaVc1v/HuO0aFbG9s778kD0NLpwym5Jg46ML
         jmtA==
X-Forwarded-Encrypted: i=1; AJvYcCU5Yt7y/v3Qanm54m+CSNdMUzPQy6qVMPxw3Hzu99tFVt+xzm2FUddNxfrFX2NOkP6BRUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YygV3UIEQ15rZCDl8T6PNzuoSrhLVHnFp/D9jkCdQpmeBoOBpMz
	IkbTximuRdqDwU0J0vH2D65yzqS6ZLIBcoTNDp5jGcZOSttCoAM3wLUJJecE5AG8qsiDXP9vWkh
	tz50=
X-Gm-Gg: ASbGnctPwDKwzRhdCM1mXH5nAgXx7AbVp4Y+5RmaeW7cww4xCCb8J2mYpS4jbbJ3gdp
	S3NdWjoAuZN0OzobBj+HVDVTBlKG2z+QO7DpwkvzscBlappaDo07CAMKMw/TmfzVEOW5hNNJFSJ
	ZT9+ooAjU9/GMklsFa21dlFzEIedG9lcCwLOvqYL9+zcG4UBHFe2ccMFTuISz+1EkMOylr69WXr
	yvROwMENrkc0q7iyKoVRTShwgqFmdLbBR/WEEVgc67OvY1nTbBwzJYSDe1krXiATnqUpXETxy2j
	CF3xMZ+t5N/5DkXM1K/uE+bVcjm662amIHpBa4zTie/LrY/Ug8KLSTpGHQ==
X-Google-Smtp-Source: AGHT+IHy4R1pysrhxzZHf8PsIff+cJIi5Kt3lbwGj1TI7jFN2ZmDtBraZqUWWgeIc5QjfTBBwo1w6Q==
X-Received: by 2002:a05:6a21:6d82:b0:1f5:8eec:e50a with SMTP id adf61e73a8af0-1f5c12c7864mr4910034637.31.1741977574981;
        Fri, 14 Mar 2025 11:39:34 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56ea7bd0csm3027381a12.47.2025.03.14.11.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 11:39:34 -0700 (PDT)
Message-ID: <ee814e2f-c461-4cc2-889d-16bb2df44fdf@linaro.org>
Date: Fri, 14 Mar 2025 11:39:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/17] make system memory API available for common code
Content-Language: en-US
To: Anthony PERARD <anthony.perard@vates.tech>
Cc: qemu-devel@nongnu.org, qemu-ppc@nongnu.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Paul Durrant <paul@xen.org>,
 Peter Xu <peterx@redhat.com>, alex.bennee@linaro.org,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-riscv@nongnu.org,
 manos.pitsidianakis@linaro.org, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
 Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Weiwei Li <liwei1518@gmail.com>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
 <5951f731-b936-42eb-b3ff-bc66ef9c9414@linaro.org> <Z9R2mjfaNcsSuQWq@l14>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <Z9R2mjfaNcsSuQWq@l14>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/25 11:34, Anthony PERARD wrote:
> On Fri, Mar 14, 2025 at 10:33:08AM -0700, Pierrick Bouvier wrote:
>> Hi,
>>
>> one patch is missing review:
>> [PATCH v5 12/17] hw/xen: add stubs for various functions.
> 
> My "Acked-by" wasn't enough? Feel free try change it to "Reviewed-by"
> instead.
> 

Those are differents. From what I understand, Reviewed implies Acked, 
but the opposite is not true. If it was, they would be equivalent.
Thanks.

> Cheers,
> 


