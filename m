Return-Path: <kvm+bounces-45119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47230AA60A8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4A1C4A2C0F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8D81F4E59;
	Thu,  1 May 2025 15:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X2wqOuiZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F381F1931
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112973; cv=none; b=LXKeBPfO8kU7TX/8pl3f6raMAolnpzR7f+gnQyYeEUqfFAj00CEqkG2QBfwcSiq9UhCAGSu5TQfALsEBNVNqrdf7dpfMrU8RnaP94FXFMIEu9GcLfy+eLRsdLiRE8MLQG8VSxLgKmCzvfbKrPRqgFIaxLa1JFiXS0kKJdLGiomY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112973; c=relaxed/simple;
	bh=4W8b9CyFBMT6p8aApfH5MHo4UoDls57aeihj35ASKRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=riV1EX4vY5WEOUVMh4KBnE+eDu4Chc9TJz24eU6Xgqb5NMFxBCKQWfODMMfahKWYqgqIMB7XCz9imhl3btoND0okihYYHjgeSZ64qO7IRCTUlZFr4ZLCMt4f2RNvBu5N6Q+pT+OWIPcOppML0Np2VijmHTN6MyxKF7GWpRcB7/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X2wqOuiZ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-73bf1cef6ceso1193845b3a.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112971; x=1746717771; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VNk59ZUe6VB2+qVVwcJX9X+M3hgSClHFSRBg0Eem0Gs=;
        b=X2wqOuiZyGpOkFwSEsb0ZhdTIUubKLpOOv7+x/0PORtGLhoH9XFivleotOr6242saV
         0g3CeLWJ5OuOcgW9N1wtHTvkuRBncKadFQnpJtZXSlk3CJzHs8MM2UC/mnS/wvtC0Nnr
         N8iTnuBSzYh6uOtQvJQaRbLv7Dzrw4vosg9eEgCXK5R9Hcj9UB7n1Ta8xdKQThbXGmY6
         nMyaNz9yw6D3D2mMGF9/DGJpL7mt46vPBo6HY1Z6vWi8JgBeFAIROGtbxB99RZ9CMnek
         8nyhfterVDfW9Np1e5bYd69QyRW2+WXal8BwFNNrRtUYkuGyz2FYeip/TxZYj3wxzQIm
         5oZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112971; x=1746717771;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VNk59ZUe6VB2+qVVwcJX9X+M3hgSClHFSRBg0Eem0Gs=;
        b=TdYmFoQ55TY3yyxFKZmpQjpS6zDUnBptTA5d/VM7eeUhKVG5qiNmk2iZHFzqdQ1xFu
         6hy/SLw5yntiJbcZG3E/lYfaMPFARRGAFnSbCelH7x6P3XtIJtQdGRBMNhzHmWNPhBBi
         PeiJ48a4XY6avN/19d1bGYZ1KiSWfjdR/4wK0b+zDleNmzlUGXyqJii/FxmyEoKHIuZ6
         XTaA/Nt0L+NRGn1wnZpJMpmkl5A08pM3ZPrlxfngR4ZmNSd189hu/4LTQYWdksOHM7v5
         pE9FXYMLF9BQua6msze6YgmTzc3G5zxCkcMia8nx40AjZwoIUaex110u7bCc46PHw8Ys
         UT1A==
X-Forwarded-Encrypted: i=1; AJvYcCVSKePV+94TladM/MwMzJnlEZZs9qxujliB/Pm18sE0koE4SQRGEQdTT9eR4Yt6wJCURRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhpqZgldCq6iN57nSs9FYsnDdBR9g9QZpUkBTdhpgr46fLSOUG
	/1DdApdyiIe78euA+ciEpqEGoIQpZ3P9qJkWs9NlZKUztzBMfDdxcmZn35jRkp0=
X-Gm-Gg: ASbGnct4yRvYlvc2l8nrl+ufq5wLaAAhr2kF+b0/113y3K6u2w1ggX4dqIfPWSQPnU4
	CTW1Q4c08FkPF77zuzaoN0Lvku+RZYTbdmotM/nZL1CJkHW5IOcb76d7ZuibI/hFpP++x4D+MOR
	sZK8lJckZojLQabN6+s1ZZSb2fIU/TJetpTG5jLspxHpu6W9GqTtV53OQV+WDhtLLT7wD2VQKD5
	27IBJBQEKXUZtV2mDfPLZajQllyP0n4558PZCaQboOzTeYG2pzNAEYdU4/QAvkppMK2RLDCagLY
	8Oe1ZlPZhnlOPtzwIeuZZuAp5LrLrPtL9JIIWXfACwPG60QaGMj9jxPea4Cc932SkjOTpBHTMZP
	z1yhibH0=
X-Google-Smtp-Source: AGHT+IHEkKsYHijqlvDmsJkdkB7qRhJgVhFklXe714vjVtUTqiyTUvUoNgHymuMuN/rnrtL7UgPMCQ==
X-Received: by 2002:a05:6a00:124a:b0:736:57cb:f2b6 with SMTP id d2e1a72fcca58-740477a8d24mr4786306b3a.12.1746112971170;
        Thu, 01 May 2025 08:22:51 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404eeb194dsm928712b3a.21.2025.05.01.08.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:22:50 -0700 (PDT)
Message-ID: <aa169d85-c34b-48a7-98c3-cb44a31c878b@linaro.org>
Date: Thu, 1 May 2025 08:22:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 24/33] target/arm/vfp_fpscr: compile file twice (user,
 system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-25-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-25-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~


