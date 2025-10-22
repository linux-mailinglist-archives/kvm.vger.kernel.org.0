Return-Path: <kvm+bounces-60851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 661EEBFDF0E
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 20:55:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 11342354EEB
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 18:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7018534D4EA;
	Wed, 22 Oct 2025 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gBFdmIdG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93B35B15B
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 18:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761159318; cv=none; b=VO9KO05ZR1xriqRk68prtnwjfCDdozwWui9mT/Yt9mfgNb9kPirYEOcvpHxtVtIbrFY8ZO3aQTK6Rjg+MpRX6mbTxF74Yme6UB0Q/ohn5SY9HZxkdutyi7W/FosqHZF4GVWk9ZNHWF+BGTTFe7mJXbkal8erk5tATenRRrzqD0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761159318; c=relaxed/simple;
	bh=w2IUP7zthxmC3j/xuIQys6Xs9RvLTnMO4cQ3TsvCTE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KmnxXXmOZaILaHAhMTtOm3qdgbCA1AujArGS5Xyw5b8TyXQb7wnO7I2vpn43jNyYVCPAPmxRUtxM+jF++eIfSS8Ym8pyjNrQ0vSh3pdEznPeVrmbYTVhqNE1BBaiW4b6d68cnvrRPoNcF4X6T59YKujw+TKC4brZUCwvaj+ZAoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gBFdmIdG; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ece1102998so5892479f8f.2
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761159315; x=1761764115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QGkHgFHWO0U4DFQBXgyqF0iZP7bVTfnDWioQ3Y6m0Ac=;
        b=gBFdmIdGIfoYiOyqkCU1uoofDhFVZN9t6gY+UhmZiZKzcDFxh/0MTIHQuxEV8sg1UW
         cyPNgmXVn17O1CM5va4AbZCTVh/t+5qrfzdSZo92tzrVOB7cbljy1HhIpoSC4iiaQXat
         iRrXLaaEK5Cxgk1Ot37kIHiF8kBgFOyT9pP5+xOG/JZgoeuKeDJG61cBSjqpGIdC7iS6
         szWUBfegyfRrQdmfgodPLLGEoncbHha00ubdSAnip/fREuk2jeDWcaxZfOqbhoXjMhxI
         9CSXWDzyKAWxPR91drjL0JPlf16xriysHKIn9LEWZlqXc3hKTUGIYzmZ85wnADHGf8AV
         Rv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761159315; x=1761764115;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QGkHgFHWO0U4DFQBXgyqF0iZP7bVTfnDWioQ3Y6m0Ac=;
        b=ttl0hPASuSZyQgBKGafFLUmilXE68+BJfCJip9JT211UKyLh69LSH0dybxW8Ecvy/q
         Uvso+8Q6/Hf5bapEeW/OegQXd34UqPt5nc0tP9t5Zgbf2WiWuU5hAfUTZijRIWJX1z6c
         xpZCWcV33lCTiYNzHwKtRriqYsNpCf5f0NPQjOaNPNbx2tPZiu2oodQfWmYzfVSjv/lc
         XAZ+JRRwgjmRFZTRim5mNtuqkNNkQTTru9KmL9CQWR/OXSyFuP4KTRu7hlAOF7/LFC6m
         FyTheilv7DB/iOYhZmbBv98rgfZfh/ESLoGJiFMTkVV162SzdSe6VBGCUjASLsGctHh0
         vx9g==
X-Forwarded-Encrypted: i=1; AJvYcCUOSyHOKpXhd5jQwG3L+J+SfxUm2RH/0U7MGasBdMju4kV+LzL7PpZPeel9yM0erFryXD0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXG2iweIbeekVj3dpYvK3Rn456f79gdIYMwpbL/sdKJburWpBt
	vGx5vN/bGjxagqKrMwq0SxA+wF2eQYZoUUG0ZVDahblXp1blaI/YNBQvfkOpr6MzRLk=
X-Gm-Gg: ASbGncvFn8Ulk1y3E9MSmMoiKmOZeJdkZayQrde0p1Zr+xR0RqxZABI/d6rlS3Cs3CB
	gR17DEarNYad18sWfxLpV3ZJfa6kfTnEePlyPUa+1mK7lohs1XKK6C1tXWJXPfIN31N+dxc3OGu
	tA/h4cLqi4e9+z584EFUX0QS+XHyBPU8Klw+JWey25gqWobOrr7j2DnRTlYZThHlnwVEVBd+CS+
	Telj5uo57klpXDWTKeWigvBtXFF2lF/2Mb4hEz2gvOgGpKOILyKCuPuS5HQNcey6pJc2N/YtYJX
	Rfm96vgff/Ctlh2sWmiy5o1dFD50jLjFCDYR7O5VXD7kojekViBwMcml5gqcjdZuxJv/2c6Yys6
	cupcsLXAnY4zwQWj9ooKPa4YNH2Z0iRrPzKlKb+usFYy5MLR7qv0zww6foZZpWeNKuUO2qk2N1f
	FBgMqhkWzc6basE6Ggru7lFJFmA00AQu+MDSIGDu2g1Kc=
X-Google-Smtp-Source: AGHT+IFYXDlLQ7YP0z8og7q6VrFv/s7meAZcL3aZjFzVSsJLj81XC/yv3vsS1AASm9CKvPhjtxR4XQ==
X-Received: by 2002:a05:6000:1a8e:b0:427:60d:c505 with SMTP id ffacd0b85a97d-427060dc6eamr14277953f8f.15.1761159314792;
        Wed, 22 Oct 2025 11:55:14 -0700 (PDT)
Received: from [192.168.69.201] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0f88sm25419514f8f.7.2025.10.22.11.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 11:55:14 -0700 (PDT)
Message-ID: <5930e266-cd3a-4ce9-94dc-2849d5c7c18d@linaro.org>
Date: Wed, 22 Oct 2025 20:55:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 13/24] whpx: copy over memory management logic from hvf
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, Ani Sinha <anisinha@redhat.com>,
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
 Roman Bolshakov <rbolshakov@ddn.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-14-mohamed@unpredictable.fr>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251016165520.62532-14-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/25 18:55, Mohamed Mediouni wrote:
> This allows edk2 to work, although u-boot is still not functional.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> 
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   accel/whpx/whpx-common.c | 201 ++++++++++++++++++++++++++++-----------
>   1 file changed, 147 insertions(+), 54 deletions(-)

Is migration working with this code? AFAICT it isn't with HVF.

