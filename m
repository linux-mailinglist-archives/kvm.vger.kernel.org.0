Return-Path: <kvm+bounces-41463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D62CA67FED
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FD3D423B90
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C8320765F;
	Tue, 18 Mar 2025 22:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F1GaKgwz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DCE7E9
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742337846; cv=none; b=ogjOPQrvB+IQztlK+zJ4gLj0giQicZsKFB3aZ4NMWmhvLQbTJU89bog0sbR+8TF7rXmyzt4plKY2+U8sJ+6j6dnyRvEiLi0fJukYnlzb7bQ+jTSVRIiIORzTiRaRkAg6eY3y+GTHUl09a4gDVL/dblstOgKhFZ3M9BByv1ZR1Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742337846; c=relaxed/simple;
	bh=A3OP6rV0SFZRpR1JtzoS4/chOsn57vR6r5KU1TEMBjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rXDiftCQgtWvtximBZ1mcrEv+33SPvUl82ubRoVqdv8CEOe4VdFOkNSyLnUhfcisaK+WZeAwVdItagj2JxMpVsp9LeG3oantEt4qGjLgmJCi3dnqkwk0b5bbH7Dx3OjYPfWKiZntoEOpv+sPlY5zMpjdvvSJ1wTm3YLeHuvMQOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F1GaKgwz; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30155bbbed9so5003234a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742337844; x=1742942644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yOVNEjfmFvFaGr73ny22aVzhc1cEgsoNeJFbAEdgGWE=;
        b=F1GaKgwzWLJprhCMnH3Q1YKzU9AeRdclFb4B5LTQEpmSmuBKtLGL3OzccOQRnASOlI
         8rsMD1BRcYB079mi/erbAPkfc2CHG64RRo+xIOwzInYILTtSBc82PboPQh8yr57lZ4zW
         pRoWUXbZQpHEvItNhzbpyQM4F3yDJW3TeyxEQJXg9rW0XPgYA6/rSbB67Igw62MLSLHS
         +zI0xwtpMiDQ9RLB3sFCmqXPxQFSXtrIWpgcbnywdHX1dUFR3GIkZZQPXCHAa8DeuFcg
         MmHbIwVfgOZrfFqEqenmJZ06pWztB0kBMO82QV2CEiS2WqYE9+7DtLsIFccAVtdqUV31
         NqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742337844; x=1742942644;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yOVNEjfmFvFaGr73ny22aVzhc1cEgsoNeJFbAEdgGWE=;
        b=Zr4XuXRdelmulc924dDYXRfF2mdUYBLcqUNMZukJJvogp17Jwi2QcpyY/NqsHHzGR6
         D0cyM7IMOX0mB2bX3Ip9pGf7f4oHY5cXPLaNdFUf+MMnE2hohETxM+9NRv0asTw/8I8g
         Lzym57JbP+NOLxX5qtl5CHYs08kKAnSkkBnSLeF1w8f4NAhY8SupUvj/ijKS/RgqrTnL
         XIsZDpMVXsUUkctOUXEQ9InQAeEMGRPa0keHkhOpw9O7Q1qjXmDCvaAVlZCQaKfrKNpR
         IJjqNypVmSOtRhXYIzzzCZwxw2kAwev/aiUXZMxVWn+axtnhs7jqy3o7Bgkx27wAz9b0
         C/7w==
X-Forwarded-Encrypted: i=1; AJvYcCWhUtbtFsWV+sekzEIZWzatUk6gbVb4+emN2Acgb6y50vEV+4o9svi1VT3qBxHKwP16LRs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJgYHpBLsCkzr5x93NdyVLWOTmpRV19m8oQvJx+7gbjb+Jfh6E
	0UW+lkRhmv69WGTx6pgfjYCHA3NY4FAB/u6UnIWiAwLGTJ+BwU/Dcj0wR1lRYfo=
X-Gm-Gg: ASbGncv2K/EFb4CtkKC6zRTObBAXqCaSx552/hpZWL2hQ1VbI8XiN20a849CXhpZY0n
	lMC+Q129cJwxFkkrcp60eXSlt4Jgg/mTg5Mdb6OSWW5RfSm9oLEvptKGXzTnsH1SZM+vdH1mcvo
	/1CQ+HQH7yACGDsOsKFRQ5mFWjD5t9hROceqMiPS5ldC6PZJQRW8Udx4n5CR4whgy71P7lAbov3
	XhIKANtcTQ5KndkSpZvO7BZ/Yh9lJa4lTjoUq7E4cNRMc098rfW1F9Kb7p9PX3ROb9miKgQEBiP
	5WExKDCLmCimojoHm/NDZRC+/zHHUPaEA7+k+KYJxijQDAAShYt383Fn7xR8uRjyZngaOvyL1Hw
	3tXju/IFi
X-Google-Smtp-Source: AGHT+IFyxI6FD/xN+KIxUzJPTwzCWqBluNiU/Pz5vcaoPz3M5Hxd1qYrSVE4IjPJNZKkULxY2fHDBA==
X-Received: by 2002:a17:90b:2dd2:b0:2ff:5e4e:861 with SMTP id 98e67ed59e1d1-301be1e72dcmr768418a91.24.1742337844092;
        Tue, 18 Mar 2025 15:44:04 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf61b525sm37172a91.35.2025.03.18.15.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:44:03 -0700 (PDT)
Message-ID: <e8881e57-abfb-46e7-bf2f-e9cad988d547@linaro.org>
Date: Tue, 18 Mar 2025 15:44:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] target/arm/cpu: define ARM_MAX_VQ once for aarch32
 and aarch64
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-10-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250318045125.759259-10-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 21:51, Pierrick Bouvier wrote:
> This will affect zregs field for aarch32.
> This field is used for MVE and SVE implementations. MVE implementation
> is clipping index value to 0 or 1 for zregs[*].d[],
> so we should not touch the rest of data in this case anyway.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.h | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

