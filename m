Return-Path: <kvm+bounces-36456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02994A1AD7B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9967A7A1994
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB87A1D63E7;
	Thu, 23 Jan 2025 23:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l/+cHmNz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114211D54FA
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675958; cv=none; b=tVATfBR2KCzDplpOpmJOLsUduFAgQtZbgMnqGk9ZfUFGSZx++iLP6D+vNHg+G83IpEVsV6DiwwrX7VWQDSx86hESCOd006et78nHmOblmoZgVVcA6jr8nEhxGOKENqYH1njjDqEvtBq7a1VknEl4LSyNYS/g3ucE4WjV9pwe5fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675958; c=relaxed/simple;
	bh=n2jObU0rjwZXuB007hzzup4Gd+ZM7LbEZ0NKU72xKu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ifpKAiSI+I0HsBvkM3GLAwQKZhz7Wxrgfk9LADbVl7R1unFfDZsDLcRYk/KEQ0jNiAj8sW8CHw/bttCnzaM3t6W5KS9jWSyjhztbXmACkLWaFt8IlrtTUxkFccQW9JVJmxM+E644eDDZ85YUENsXx3SnfDPp6wUXIk4y7Ufb+8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l/+cHmNz; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4363ae65100so16278045e9.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675955; x=1738280755; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sIImxUuZ28chVlLL+vN1mb6UQluYe71i/J3SLXui4EM=;
        b=l/+cHmNzJk6quUHPijfAG7+cV95sVkVJYSh1uku6wO+iO4nYK/Cz7mJzf688idUS/n
         Drkic+PogA/ZtQrX/cS9PnUNfJPlYQTvyrqAp6CqWMcBVYAKSl7jdgtVRf/xy0Y9Y6/z
         4v8khokV5W5gV2OnYFEtcR5nURNFLSg98h+5SFs1su8b0BWaG3Q73CbkzPhYv02MPXRq
         JX9GwaIVFCpspPWB83wyOsmyoJ6XxawkqrCQhGs05XaYEOfcLbMbeatctTrFmNXGnnd+
         Micv/Eo8LdiPeBZRqDlVM6BNTm5c7ryxLM/8bD9hn91c2iTflpqYvpq1PnEAzoSuiO3c
         iYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675955; x=1738280755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sIImxUuZ28chVlLL+vN1mb6UQluYe71i/J3SLXui4EM=;
        b=FLTqQNJdnCZw7VTXh9RX2MdbVH7oNmJwNzihonH1MHD8Hx9/LXsuF6ti+sqOgmJITe
         TNMj3K07x8XajpOeLj4x7IwFulJ1Xtq3yjFxlQeIa5yp8uvduxDODQRROewGKJ3mNPW7
         B1wthnZ39YvV2hV18xe2DWpUJZQrJz3vcsOCPSfLgD9igjqIFV+x54LM45Lgs6nddumY
         H83LPwBNZBaCtq+Axb9f/aE1L+1aZ0akU+UBRZ/a+5J+w2oiO/WHAj8AhG6NyUUfA10L
         tD0oBOme/sCvNbQRVHlNbrn3atjdPFAkfELqqgewiDDeEZnypf+4JDmFQma2yu7Tbyml
         EHrA==
X-Forwarded-Encrypted: i=1; AJvYcCVi3VirqsJrsBcsVVJkHNubj9A2rP2Gx+42qQig2Bx3oIXzNYQAmaKFN9co6UOvoUsU93g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw43sOu7DSB5jpqzj2uyjKyqJFNyNvhta2RKPtEH+fUSrA7CQyU
	8H3AcRqF0XC6jtDu5iv9sFE69jjxU+S5Sx3SRfTFaWvTXvnmuX6miU62w17PBSk=
X-Gm-Gg: ASbGncsxyb1KEBdGYrJOExsPLgpMKsjSoqcsKxmWVP0av0kPGcaEKDUJXnS0J6l4FBt
	saGVHUdkI1Z8b+gqpP+8WbYS79CNv4KE+dFGbljpzn8gisjLXpSAbwWS8M8fOv3l9ulAxSK9l2o
	E/IiNljO2spKbIEc+gSK/CSVj1LH+LsO7jWwYXhncM5CmKGhhqC6svkKOd2zL0h4APriW0exmpd
	7KXYqaCGuN7B0RSMQS7Pq5Q7Csch1dCH9pVUBKQLY+fczfA33pB+hKJhMtjsZeLxPSg0Ksk1b8m
	MX8EUJFoWYkfcKKg3ALvnuZrKqtyXa/K1tk26snMgcTKF0z1Yk+y051LvOg=
X-Google-Smtp-Source: AGHT+IGfBJfULhniARVxaeHND22dVQGvVM8jm6sNf2yido1MC4lasaduEx+qwJvir1julFx+bnHZjg==
X-Received: by 2002:a05:600c:35c3:b0:434:f131:1e71 with SMTP id 5b1f17b1804b1-438913cf2e0mr264387845e9.8.1737675955349;
        Thu, 23 Jan 2025 15:45:55 -0800 (PST)
Received: from [192.168.69.181] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd47f355sm7140915e9.4.2025.01.23.15.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 15:45:53 -0800 (PST)
Message-ID: <3ef3ad0c-0f53-4588-aaf2-f6fd712ebd41@linaro.org>
Date: Fri, 24 Jan 2025 00:45:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/20] user: Extract common MMAP API to 'user/mmap.h'
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-3-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250123234415.59850-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24/1/25 00:43, Philippe Mathieu-Daudé wrote:
> Keep common MMAP-related declarations in a single place.
> 
> Note, this disable ThreadSafetyAnalysis on Linux for:
> - mmap_fork_start()
> - mmap_fork_end().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

I forgot to include:
Reviewed-by: Warner Losh <imp@bsdimp.com>

> ---
>   bsd-user/qemu.h        | 12 +-----------
>   include/user/mmap.h    | 32 ++++++++++++++++++++++++++++++++
>   linux-user/user-mmap.h | 19 ++-----------------
>   3 files changed, 35 insertions(+), 28 deletions(-)
>   create mode 100644 include/user/mmap.h


