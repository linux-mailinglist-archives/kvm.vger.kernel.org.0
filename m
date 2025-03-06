Return-Path: <kvm+bounces-40238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFEBBA54823
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 11:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE12F3AAF9C
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 10:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5770720468E;
	Thu,  6 Mar 2025 10:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qCN8zo2B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D032D1A2547
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 10:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741257764; cv=none; b=uAk4UXAzON4ee2Oh1jaHdoRV2fHp5DOObbjqlKbkw+x5L9YAAlv6KUPfPD1p84Lk1AtAAVZiAlLC+jZb356f0Ix9PGSIIBv/FNpARZMZem5IRy1AgmanXXM58Pz/5b8ch6qCJGdqgOvhO74eBAa+S5KddLOMolE3Zilp3W8pHnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741257764; c=relaxed/simple;
	bh=tOICRS/LJdYoAMcLqZM99wumY7lcCZFZCb31EokmGwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A7PDglKaiofeH/2HcY0U/axUBAI12UdGlcYPCpy8G3Xbbbd6C1rj5AeHeYRh95pBw0olatFBXje84YedsapRUBey+Qdvsoi7C/FDRsARiDmald99gwjZXbEXJjDt7YNgAjJ03A6zJg6XDHTzrlEugSVYXzTswT3wrcrHgAe8V+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qCN8zo2B; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-391211ea598so342064f8f.1
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 02:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741257761; x=1741862561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xaKViYZxdwLecpko1tt8xlUV8OQ9jjP7rcobJLc+Lcg=;
        b=qCN8zo2B6u0QvcuoHLa1IUQeYkPf92QenEnvSrxC2Sj3jtIS6G9a1hOmvidhrrPo6R
         2p/fYffnovJWfN1i8TCgqs22Mg1OgzSBKXRMwxUsUKYeDm2cgw8HA/p2VUM9NdsvBLt+
         baoCmlE4gteqUtx0A2iv15EUjY6ibVmvuTy0iDkSX8sgPHZSxmb8eDQ//o8c80FOOgV5
         C8KQNVTm0bzHRiHYzvgsip2GnswBjVmfjRxlyotMfrPP6Lv2KWiYtKwHYzKFQyZyF+y7
         /GAEgGAXLNWy7lCx22KHdQmTiLPwYtqX+0jhIPFC0KeHDKgVqZ58ssnZTDKC+nVQoYWx
         4LuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741257761; x=1741862561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xaKViYZxdwLecpko1tt8xlUV8OQ9jjP7rcobJLc+Lcg=;
        b=E/BV2n0MJqxPqLfXOaLW1aAGKgoksgvF0Z4bMFiGBoFGS90dNR0okYPicXctiAkaDJ
         9eNEXPPkFpmsX/xABEenY5V+1QQdcMGXChN3+BW4+uDF68UaSU311P+90t0Ngtp9vJoO
         zAYgSpGOXwGkztUENAmHrm/ySJ4qZn2YkV0MK2WO5mwUlM9R6LmS7qyRZarBRqgkAi85
         XpbbtPBf3BhoVsUfEtT0vRPWaWLi0wH7gV/qqdU4poAZUrvfsJ3UX0cMzOqO/fezG8Nj
         JE8+lHdwum3NPOtlb3Y3nQpswAeltQIhZICqPdmEWX4cXLPlU27eP++A+rp3xfBBdjx4
         wWdw==
X-Gm-Message-State: AOJu0Yxty3c/7o5+ix/Y6jcJgl3oGD8GHXXOn2dxJblvTzh/cbBXMXe1
	hPHf1JbP6HRzhaiY84AnnuAfiaQAqoPlgc95QGcYXLM8pcmv4fUVjj5n6GQwajs=
X-Gm-Gg: ASbGncseyCDzKkn+DbX9MfaIAwnai5JGZ3iuZk10VZ7lfIUDrZTfjoYuMwi7sbhHvO5
	HofTaUXTpZfs2lqyIl+nz2wsOytBkzPG+yS+9eQR3iTDSPOvqfIs9I+jxXMekMzyhetzA7+/SwU
	M/4YnmuVIZ3OZT4EfKaiiAMZtk1f418X8472/z3AAz0rbZLchfUtnt8MrC0C2Cs9Qocz/JkKzhP
	Aazm9H8NVQDHXpD72O7etXepM5fcIZN+axU2xlBvCpOyX8Oh+INor4Pl3oHrY54uW3yEkunHtrB
	hyn3AplSQW6hRCaqwmXg6OhC7QdAMNoTk3hswTET4wF++WHAkSvdhalbDTFkcWFgqNdn0W8Q+wV
	3GtD5n6VdTlX4
X-Google-Smtp-Source: AGHT+IHRj55Ay85fBiqAkp2KdssrUaWQXE1GtZ7kLXN9Uw703fDO7P+S26h2Z+7vanik5rKW5hlRCg==
X-Received: by 2002:adf:f0c2:0:b0:390:d6ab:6c49 with SMTP id ffacd0b85a97d-3911f7bda9amr5516886f8f.35.1741257761010;
        Thu, 06 Mar 2025 02:42:41 -0800 (PST)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0193bfsm1651353f8f.55.2025.03.06.02.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 02:42:40 -0800 (PST)
Message-ID: <71f7e071-4b60-4f74-aaa2-67796e35631a@linaro.org>
Date: Thu, 6 Mar 2025 11:42:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] hw/hyperv/hyperv-proto: move SYNDBG definition from
 target/i386
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 manos.pitsidianakis@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 richard.henderson@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-5-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250306064118.3879213-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/25 07:41, Pierrick Bouvier wrote:
> Allows them to be available for common compilation units.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/hw/hyperv/hyperv-proto.h | 12 ++++++++++++
>   target/i386/kvm/hyperv-proto.h   | 12 ------------
>   2 files changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


