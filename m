Return-Path: <kvm+bounces-41687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8697BA6C030
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE80E7AAC1B
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD3122DF86;
	Fri, 21 Mar 2025 16:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qkzm4y9E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077B322D79A
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575121; cv=none; b=p6okQNs5Yi/HT0mmVPZU4W8JFB4nxDX9uAWNrAe9SCdn3xzxpgd8uURMWcLnW43UbGhy4yvukTaEC7Vez0I44r18AlINV2bNG83umkdBhMXIuA9Pvy3s/J2ZMzeL70GIJ4UCilJInNDrvves1hFtjWGrKykyFZnlOLE0rPhqHHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575121; c=relaxed/simple;
	bh=IwQKcMjy3UdwuxcXRkXyQuU4INC2QTPj2Eh2ITCDM4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZvqVLmb19OMGztAacqR8oscGSDNUoYNZOxY9sS9murawfFuFTapJvqGgalqWcJX8LXWJluI0FsDbbab0ZC2EQHM/KDpsc2ibm3J+fl1ZHqH7d+rAXs2TNVjmkXTuMpEwDIzkrnmTWTR3hE6icwV9mgw8l8rCoL4WxE9FN7fahpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qkzm4y9E; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ff6a98c638so4755962a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 09:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742575119; x=1743179919; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wd8JQPF6330iFbrfqEOHPqzvf3WyiSqrdPORWZKD/hg=;
        b=qkzm4y9EUtVfZn4iDDJWKnUoPpy/33Cl/butZBRHNUNkse6xNyLquxsRchiRc9OcX4
         nvEQfEettNtQNY4FAO7FCbZbqnKdmNjCUg0A0Y505bK72hdje7DxZ/MpW1cMk1LHZVv0
         bUBgZBAXeYnxAZCXp/jakOTABqOeuq9TbtvUtLBGGJlLIwhoeB4waOaVTt1FPziOvWd6
         PUq4TC7huxY24myxvLNjcm2f7PCrPAe2ZoLTSUBVJ8zDUR1PAfwQ0heHTghuTibNZab+
         q1UhB1VMXzgsyXVVK84+2J7xDKvSKnQvDt/Nft199NxE7hX6yujidFmuXUb6XMv2UztF
         HJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742575119; x=1743179919;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wd8JQPF6330iFbrfqEOHPqzvf3WyiSqrdPORWZKD/hg=;
        b=OqOXgqTBiA4FkRLsxuVK3zKOWQDc3gOn8ooY85mESmRsDmHIhLP5xyRzVkf8FoMxmu
         GalcydmamHDbccQhCB0riirVElZVSWK+Hh9OTxbdTfa7uUlKy0R0r+4wIF258STyKwgr
         1dSEdVxU2AW/3ZUEro+jKqrUfuCo2riBHs2QoE+sP6GLWZKWvVrt/k3VigCC9U97BgY3
         tqv3sYSfioT35JWvVYCv8m8FKcnvuw/lDf3OoTXeIhVr9DHNWiOD1N13jUrPZp/3ckI6
         gHEI0O+UOfMGuB8RE3wW5qpCn0vuffN5txDuWGyQKeyHyvk1gGjODnfP6rdbxlxbJe1W
         I57A==
X-Gm-Message-State: AOJu0YwiLZYCLp/1BOTlxfi1PPzGEGruj4Lp5cWZ1cRnZfK/E0jOJvQI
	Cp5eXUUiobjkPfbIKqc82tl4euHX3OgOfH1KlvcbSuGi4Ykv8dY9PRlcID1BS0g=
X-Gm-Gg: ASbGncsiAsv9l3Z2y95KR04OxRYm7VqM8gUoMHMoVYVtDoyvPtoGo57r+lsi6/IWYuc
	Q7O0PVTxQ6RPAFGGi7+1LG/V5HL0IS4auTIDWRZiNsekZ/mgJpOiK96kAqU5a/Xn2QeEuOTf9u4
	2zQJkRtu//9npKLmSqfrAPC2PqIwD44rqzEXyuAfhHHLf8+v27W3AC+3h/YTB1n+cvRvEefFNqt
	EQ7nyfZXV/w96nlErDXAbLQzCfaTsCDJtl7WxKmHT6G34Nace1KZdKfTn6leDEXugnxuHesmhsw
	VzJ+ZtQI9WzINPLIrtpEEk0Yj3RsC7tpXameb9Dhbrv54uUnrl8WskquYkwqoPjysSN21dsYJ+b
	H+bqgCW6r
X-Google-Smtp-Source: AGHT+IHBrfgKc4BXXVrreTwTXf7JYTWMk7AmN3VgpTI8o/PnAwoC0SnVFSBL0TAxFoQV6CIXyEl68g==
X-Received: by 2002:a17:90b:3886:b0:2ee:74a1:fba2 with SMTP id 98e67ed59e1d1-3030fea9334mr5800623a91.20.1742575119381;
        Fri, 21 Mar 2025 09:38:39 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf635fc2sm6300112a91.46.2025.03.21.09.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 09:38:39 -0700 (PDT)
Message-ID: <8eb1b40e-3d24-4b2d-9cd2-d5928d488e08@linaro.org>
Date: Fri, 21 Mar 2025 09:38:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/30] exec/cpu-all: remove exec/cpu-defs include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-10-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-10-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h | 1 -
>   1 file changed, 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

