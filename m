Return-Path: <kvm+bounces-40418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E39A571DD
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 833DD3AED99
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9722459D6;
	Fri,  7 Mar 2025 19:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bg2i7hKN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB4D1A314D
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375996; cv=none; b=oQCYs6aNqgWitedFMjdve0pPv29Iq1vLU1Fda74DF0zBnV40vD9yE3+NR1Nbw9uCBTehj6Su3r998GidHbRN9VZ5xISxNS92eErzphyAWwFhTokfJf2K78bGaBORMpycm/x8e5y2tMheAEa4r4HSBfNZnKzd7DbYUk3sq24DePU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375996; c=relaxed/simple;
	bh=NJess9IdYE/PYzwoQkwOQt5KK8lcepL4fvn19cHTE2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xd7GE+W1wxcinzrxIQ7CD78gn8xmM43d07lJAerFCSG5PR7JrJd/TYg+g3/A9l3G3v8DaWv8XUhBFhNLuJUUoNG+aZqyDMwXDCyvnMNZrx6NexizAJiNIUmwy0EV/ns4y7i+6jW82LZBQd0jc+gcrGCVGPz62lWSdgTQmAHk7Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Bg2i7hKN; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-224019ad9edso56105065ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375994; x=1741980794; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3kjokVzIaezggl6X9BH2jkPw8k9xqIqx0wCQNs0kXA=;
        b=Bg2i7hKNGoY0I1cjbI89eFKC4rFTk14hjuzdm99+Aa+xQAstlejmG8tDs/zB13tjMk
         e7A+/D/3G7bmM9KhOHY9GCOT8ylHOeGEE00O2SFc+/oxUFKgX+qUeboFEleSSepUvA+x
         ItiJ2CA+Y4JU8iCW7Bm9jrLurac3BJVJsgXJ/+bphIRMntEy4zVXztUPT119v0TRXPsS
         mca13dix22+YBqyw44Id1IwPhvPPGm6qsbXqAwtUZ9J5zx+ODXKiQomirpCqGJLz0neV
         RUkokdp8oc2wrAWtMriAC3wT3r/irCzQic8r/aizzSfQpP8vLPsSCDs1KkazEEgH07DM
         cdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375994; x=1741980794;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3kjokVzIaezggl6X9BH2jkPw8k9xqIqx0wCQNs0kXA=;
        b=Po6eNBjM6akeJEQs7eAoDSZaGU6HIQy0VgLvP5+Ksw0nGesegdZCzeUGCR2BI391EC
         47cmkscZLXT21w1WvqiIVqwx0zFpjJpLXRNdzcJWDQ1hGiHEkIiu3kiySBtMUDlG/RWH
         jtGSEpl6cmcYnVpjiNYszuzZSrGLTi0FllOWda9RoEzmoS601QVkkbOv4X/ShDBBV5ec
         2mDwwwYTgFBCsOkCIc5HhilnxA754k3Pw21Jv6UOPOAGVntGsZBKvICJKMjGf9xYfHr4
         7AAJgZfMaCROOVYFLrLjImchPMvnsCdrXZiK+OJjL2RsPsc1kj7QYRn6mu5txidChZVp
         zeog==
X-Forwarded-Encrypted: i=1; AJvYcCWLfN3LEYtHBgBNttdHg4UBsO/E4KpC4jTeHwK+zOUoX/N28Q3ZorrOOUerVrrYlTvFDmM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3JFKaBGdeIh8HL91a5TKa9/PwmYgChD2jSdmiqB4ZSqXILhyQ
	utxBRNBaMvHr4R1SPdsKPm0+vO3GShVML1tSNBVdxkCk7EtFZY9LrlaEtl2HOhY=
X-Gm-Gg: ASbGncv9gNWXaEIraxJzVW11g1yEwImQWKwIUfAViNV3huPPshQHf9HjGTPhEmyjOa/
	SNGPEmnasuKW6yY8cV7+EN7NSCxq22QUxWUq/k3Ojpo5H13h3v0cEFnxRRiq6B9cQ2XxQuum08u
	j6QLj3O+HZ4YGy/ICi3zheR25wprLJ8oE+5P90qh7QkIf+HO0ALDBU5StqsnFW6orl5z5D2VXt+
	hBDndYqT0cMY/yliL5Q9EZtH589XXF9oQEWWA1u8oFzK7YB/gSeR45Rats+W67AmttNdPslwVk1
	kZ5OafCoLlU/a7ZJJWnPWxY5eWBBNN0ZZub1fo4vbwq0mUAUSkpLeW89GAx0wx2/QVFnoC6/8Et
	1hy6nB7/5
X-Google-Smtp-Source: AGHT+IEQOLI770TWa27yduqe67P21zhBtRAIhboQgxBkp3Oh+eooU56f4qRJxrvGavqUpSRVsMkxOQ==
X-Received: by 2002:a17:903:40cb:b0:223:6744:bfb9 with SMTP id d9443c01a7336-22428ab7691mr82163675ad.41.1741375994492;
        Fri, 07 Mar 2025 11:33:14 -0800 (PST)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a7f8c2sm33992215ad.116.2025.03.07.11.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:33:14 -0800 (PST)
Message-ID: <b294d3cb-e8a8-4811-ae23-f82f6cbb784c@linaro.org>
Date: Fri, 7 Mar 2025 11:33:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] hw/hyperv/balloon: common balloon compilation
 units
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: philmd@linaro.org, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 manos.pitsidianakis@linaro.org
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
 <20250307191003.248950-7-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250307191003.248950-7-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 11:10, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   hw/hyperv/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

