Return-Path: <kvm+bounces-20729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D11C591CE44
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 19:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79B641F21F61
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 17:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E85D12FF63;
	Sat, 29 Jun 2024 17:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i4+UXLmO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1761E4AF
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 17:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719682057; cv=none; b=gL5q/dPqj5SAaeiAgWOix58/DuWiuOjMDX+4dHo3aD37CqQY8/W4UpCaXlVx2erVXzjACsLrQPBPI4Hi0AzZhxNhLWLkxeNRIM6k+GMe0zKJMkIcF2aocVyE5yl0FJ93owuLJu2oyU9uTF8M3DUYiA/Wdgo+rzIfRZsYAHht/ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719682057; c=relaxed/simple;
	bh=K83w3UZCUTYy2ZBevIKtZUuw+TmIdke+/l52b7H2BRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iREuFXFHjMOEZPe5WjKM7MKuJO6dgwuHadMYQSFaApfNqWPW8QvWH46NpDGmfucoAPKBim2IbeVAsmJ1nWjNWZUxxyBJnHZHdq3+EnDAy+6IHGdY2diLXZTLHiY7S2V9oUZJBEjKMZ0kFaQ+xTqWVds6fD+6Ad/2z6OGXvQaPmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i4+UXLmO; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7276dff62b6so2039702a12.1
        for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 10:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719682055; x=1720286855; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3kWmdhjmCZKSz2j5dEsN40l/UWaacFCAkC7GnSoRnPc=;
        b=i4+UXLmOX+TTY0rTz47ebjfXczAbUNHyZVu2HmkXTUKm8v4MwUtGXtSKiTUfzPWzq1
         AUeI05o24upUhsMgIQC94Fj/DAO+JwlcjZ9Dz1iMSFxM8KjECssjLnJRrE7b2S0WZDj8
         r5wTg4O6/4XbcRbkYYwGngKrs9viUyEPcEwECdEikIQpZoL3i4T4XNLQo1Mhk84WT0V8
         ZvsFkrbIoXla7JFXiLJdGH9MvFwHlT5GGuTBG+fGcpbYe1XWG0VT9k96ybQ2EpM1AIhW
         sEsZgZocLrOt6QnRcTcN+t6KvXfryg1ngvSHk2VLKwIVHTBjxNPr7n2OWva99utobCan
         WICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719682055; x=1720286855;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3kWmdhjmCZKSz2j5dEsN40l/UWaacFCAkC7GnSoRnPc=;
        b=RnwFb4RgqyhgaMdU80zPSo7ieG0yQPyqg7hFh39GUIWkrNt8JffGw+75S/1qsqrHhT
         Pz73D4LsAyLLs+V6Mx2tilZHUM0J4/ueZb1Ki0S+AfOH+oYDhwBrJUAM7THMKLdFg/Df
         itcXb9P/KPIxf/bntdZpuzOCUtaVL9dngONHQ9B1dCUcyNjKgUY0EzYptaYFxw9v4df7
         teWBeGTZ5rroseXRrZAuW2neY+dSObbh+XKoxYOKnAhvMtQrDDob9jsVEqrzSpAG90c+
         9/euPqrf3tMdtt5aLqtn18k+A3CdmrlvhH0zBsXqnvygZDheTFkHbr1FB3UbhvPAOETi
         2xbg==
X-Forwarded-Encrypted: i=1; AJvYcCWmzj9dJQDGTfZz0ITk9KO1VQbIuYHqF/YFq6aTASlBo6Ihk3K1xfuOKDBDyhkXtTon+OB739Xg95uYymy/J/hcYs99
X-Gm-Message-State: AOJu0YzaljXcJubqcqnPmmm4jG5XLT54Npw0AYiofu41IZZbl7BmfYVa
	Gzou+a0qCaw7l6kEVahINGtwplWqbdJLSTXK35A1bt1OQDdnE4KewewKVi6jefw=
X-Google-Smtp-Source: AGHT+IGI5fJJSxK6v/RRVQHDcDvnhYC5HWfKBkxbBPQm9NPLA9ktgzdF+ZNmf39tUsGfV+xPiW3Bcw==
X-Received: by 2002:a17:90b:4a0f:b0:2c3:2f5a:17d4 with SMTP id 98e67ed59e1d1-2c93d185e2cmr2330333a91.4.1719682055007;
        Sat, 29 Jun 2024 10:27:35 -0700 (PDT)
Received: from [192.168.0.4] (174-21-76-141.tukw.qwest.net. [174.21.76.141])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c91ce433c0sm3643452a91.16.2024.06.29.10.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jun 2024 10:27:34 -0700 (PDT)
Message-ID: <c9fd8ce7-6c88-495f-8f43-917fc675743e@linaro.org>
Date: Sat, 29 Jun 2024 10:27:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] target/arm/kvm: Report PMU unavailability
To: Akihiko Odaki <akihiko.odaki@daynix.com>,
 Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/29/24 05:50, Akihiko Odaki wrote:
> Akihiko Odaki (3):
>        tests/arm-cpu-features: Do not assume PMU availability
>        target/arm: Always add pmu property
>        target/arm/kvm: Report PMU unavailability

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

