Return-Path: <kvm+bounces-51508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D63AFAF7EB4
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:23:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2E2D58459B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 056C42F0058;
	Thu,  3 Jul 2025 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wuFDuR0m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAAE28A3EF
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751563267; cv=none; b=s6Zma5QIiU8TetFwqIyiRz0Si0KdZpQDwov1I0bJnDZ9xHbgTHsouPjIvo4FBZw/Dj/Osqx5M92UyDNqW/RSn7rpLOcKAcxYLfr690ytfq/os2kk9AgpHpTgZ1eRie5EzLB1Po5jnTGNUEllQTfWX28pbz+MhYNhoKItDifqce8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751563267; c=relaxed/simple;
	bh=26K0GDka84uNkeBWXraXTjYZZGjw6IS7KvWDbU+PJTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O7DDfkoyQ6AkEVv6ph5DOKUp51Ab6Qs7B6JlkJzqBSFykhI/kg1DLI759h4ISo85ol8YLo1SVzl9PICYzGrrGTwaKeNmx5MBYfNwT+yCWDhOUhzheyV6byPz4E683pI6nQw4aar+zAjijKT/cziPoITyEqVUNum5KeZIt36ZJdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wuFDuR0m; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2eb5cbe41e1so142145fac.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751563265; x=1752168065; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7h8WlJzQAwJeaGJwL4lYtEAga+6iWiErbvvG27Y2RRs=;
        b=wuFDuR0mmriLXdDDez5Em82soD9CypsHi5Gib9QtGxsQ5xlFzEbUwAZrUcXCYdzGAg
         zA26AaSK8uJQd1xv520524djL0Q5c++08mb31V9yrUMmS2AniFjYn8RERJGoq8G29prN
         1Y58qrghg7qfgI9tXb7UlZmWMadxbo7pbgwMZEYieENcKsKut4qyh5nXPrHT8uuKrtZe
         zjE7I5A635T6WFsMWIeR78/iMK95LczhLHypbARth/b658nAyDLAX11SBaFGX5KGJwIO
         7yyUAGLe+sv0miZAK5pI5zHUaChOaB1ImBbxTB7qWqypj7+J3OKxrmfo5koeAJEy8nQ9
         QnfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751563265; x=1752168065;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7h8WlJzQAwJeaGJwL4lYtEAga+6iWiErbvvG27Y2RRs=;
        b=hjLznlCyV/MdQbVGGSsAWzlrYv0swvnx1fM8Vp05TRbBUSQXo+oykXY0oKujkSmXM9
         XoyNHqquyCwtMYp/owPX+DqGgH5KF4cAc5vbNJz9ZWocoE6b9p4ZfcGTsFIXFZOR09IX
         4lZnbcTDZrOx4B9Wu36bldjVg7e72kCLIZFsMgN/bkbQCbCFwoh8SGS5m9eBRsRS1u6f
         L611Y3YwtDurlT2+UESvhTUPXocRxWE4CZRLyCmUhrfxSJtJ66P8gIv5dBbPoUG54KYh
         Z5zA6nCJop8f9SPqaJsbdptY5yDkzgdcADcteW46Pk8sYQXPJKrS1aD7a5NBqD66DY3T
         gY7g==
X-Forwarded-Encrypted: i=1; AJvYcCVNGhx08GqLZHTn8YtFC03vUz3J6EESccaP3fM0s6b7Es3JOYwseaxe3NoGAJ2ZSWkJ/kg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpxNPz+u+0sZP/2QK0ZdVhdPSXcFjyeL3XOkVQdoD5GowCsrTE
	wyYL4dmex8acC8oBHoOvNr8QePAKgGKjbrVjXAUM3qJLEEspvI7cRwtercOv4EX9Heg=
X-Gm-Gg: ASbGncv547wiDOrDvX7qik/IqeHRifaVwer5aCXdlKYlPfy40XOcG2SBM14fDClxfux
	zllPd6JEPkIZXUFI8c4rFuTZEhXpCsj/rH6lZ7Ln5kRIosEMce8rkB8trUS9wY65AOikiICovOV
	NgghQi1Y+u3EssYLToiZawx+SX386s7Cmow+MxweKZgxWAzCCc6qUzKJgTzjiFdFeGK7yRLKoBq
	wb0R8UjlSIIN0D/ZMBMjKYDLHkmHm6f3GX1keeLWe0/lUF2pFgTveYs0x3B287MbGCVOMwOYa50
	lq+vq7RZ/A9AU3CJikySKiCwwovW3SHJO3HjQFoIttt+WuHm/f8zl6xCxumrxIql1w1r9vj4UQc
	4
X-Google-Smtp-Source: AGHT+IFfHE4yB5fAUuSO5Mj6VTOUKhtk72Q+0rBdtIJQhhxI/8C12HLIZmvZANidb4VCxRuHI6DjpA==
X-Received: by 2002:a05:6871:650e:b0:2ef:eddd:690d with SMTP id 586e51a60fabf-2f5a8ab9053mr5536944fac.24.1751563264745;
        Thu, 03 Jul 2025 10:21:04 -0700 (PDT)
Received: from [10.25.6.71] ([187.210.107.185])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2f790209b9fsm4002fac.37.2025.07.03.10.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 10:21:04 -0700 (PDT)
Message-ID: <22775328-96b9-46ac-b374-40ec73111ff9@linaro.org>
Date: Thu, 3 Jul 2025 11:19:11 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 49/69] accel/dummy: Factor dummy_thread_precreate() out
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-50-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250703105540.67664-50-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 04:55, Philippe Mathieu-Daudé wrote:
> +void dummy_thread_precreate(CPUState *cpu)
> +{
> +#ifdef _WIN32
> +    qemu_sem_init(&cpu->sem, 0);
> +#endif
> +}

Incidentally, why is this not in cpu_common_initfn, the instance_init for CPUState?  Given 
the placement of CPUState.sem, that would seem to be the logical place.



r~

