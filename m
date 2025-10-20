Return-Path: <kvm+bounces-60488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 471E3BEFF76
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEDE93BA363
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3486D2E973F;
	Mon, 20 Oct 2025 08:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eRW2oMNl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8190054763
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760948973; cv=none; b=g2r6YJ6vPl2fyds94jHViphMw5EmwznTfI8Etzsj6kQEFs/1JX3eFuzfn5HDKUVzUktxDpggtUMTgKHKPgF5XHNFQvSSaFUydC3E2JcckT3daFuMrJ1mXJyRO92zZyeG80PaSY2R7p/9K2pZuk1GBiTmcKHcLA55RxZpM7t3EXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760948973; c=relaxed/simple;
	bh=kbhT9yMCDmmQaas1CDBx5fu2XJ1F6uG42+MncrMz090=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oo9j1G73nMan4tPky8AGb1YVNk6nVNk+hDrS346Wnmc6I35jlxUInTldwCCqEhs55Rix3ZFwj7sEMiVzr8DFmVLGTHdON85YgAOdeJPHL9d17RyD13H/NLy59kQJ/UynL9SuyHzuQJpoichjGfNgxIimj9naWo4ylHlWj2GbAZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eRW2oMNl; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47100eae3e5so37816795e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 01:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760948970; x=1761553770; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=upLQabNrkLN9xzP5rlMjYwim4MepxAdcp1g39Wi3qvw=;
        b=eRW2oMNlLcmPuZPMwnjREHrX/1t0atekczUgoEVBlIu1cdfgaOjyM9CvwUgMOGw/Gl
         RB2CuTD3fhM1PhtI0CkUpwYa9jK0VepknqcNHiA1Ogu+c2GNF8I+HqtFUz8HXy7GcluB
         I78iuM4WNWXzCZzQWIXLWBckSTBb5XG3DqtpjepSrkZ8rXuWI0/n4HHyyDupjl5ZjCBf
         qiJZQ7JHOgaBNbf3VB/Fp9pzGbqj5e0Tafz1vg3/EvryETxT3IeB2YA4BcQccqZjAycU
         2vw/9AJ0BSwunhwZC6pWm4ykFyp7ZxUXgcZ19sTp3uHOtJMY7V9Q7I4tBnB+Q7og63a1
         5ESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760948970; x=1761553770;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=upLQabNrkLN9xzP5rlMjYwim4MepxAdcp1g39Wi3qvw=;
        b=VrnzhTe3VncPB+VBGKySkMO7YZvjJHir2PZvuSgrezpUab3w0LzWMEXPn9fwCZl13G
         JbBHr7c9dmaz+euadsOWLHGibgf9iKgEptubFVxyVDCUfkl+60EJhBh/g0iDb04ezkhQ
         uCDzAap3KI31EW6scOaerj5ZK/d+z8sNMDVAJDsR/hF7wfGgR7GvRtnh0ylBnDchS6Bj
         8kU1lQGtHqMXwbdBJDETUwasO4muY8/+EBHHWfOgd9oyapFRpBBtMzhWzEv9DZCAzTnt
         Pf26D192VFsXMxVsJC3MWoYmXL+rh8Qef6DdCN6vESA33sz0dTftI5AYhR6DmxdyYZOS
         SJLg==
X-Forwarded-Encrypted: i=1; AJvYcCUV+jBa48qupGW8o0R0yUpmF69y+cZHya+hJuD1w/FTxTJnWItwNj6nVgJTMTjPhy1XBFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLH3+nP8p5CPg9mK1oRTOiQdksslNFv/diYYvBYnYzG+QMt2Os
	WRgGUHeJmWsPdFTdnryQpGhh7KkVz7bI6tI9Vv1eltqQivbGU6qwD0ExYrRaI5vJUcc=
X-Gm-Gg: ASbGncuo1NIbbQQ47GlQeOLogzqBT0OiWDyerfiiaKAVNWZ66jvdRNUPf1TBzmSC5um
	1UDrs16wbmrsTRG5X0WhjwDKQlVx1GawUTDC4Hnm9eUpvdG7Elc3J/SohF+zGZydIY7K6K+OTeg
	48n/59kBLhZ7rlIoUF3cZg5CkuCajHAaiUinnP7uDDdkVKuBvRo1n2MQlGD4z51VCa2lQ7GKSs7
	u6vx98EfFhrww+L59HQBY0KZYfpIgkKUZ/MdLXOOjVJeqhlGlRpxn/OXTofNNzX2aadGBxPMe7K
	aFgYUpD6CJ/B6ib4ZfSAJoampi2IxNyk2q5yePRZo+WNuwjjthpAfUuflPG6etcOg5Kd+28gsXc
	BQmBntSCsXbcHL4lESFrQIkQ5mn5jA2qFoQjZlm4dqhcla/Bjpm9RXqLNyTU7/3UeMlwpQOXJEf
	V+zBsb5AK9Ru5EXM/wmtvCzVQqXTc3dteUUPtoaG44+QDNFvFNzpOHLIZO+Wq7Vyy+
X-Google-Smtp-Source: AGHT+IEzE1bsNkCQUwgrRUB+00ZejTXpM1jHhePaWJboCKPtO+YsgVt7DQis+/s5Igcc0ShXfXMXog==
X-Received: by 2002:a05:600c:3e8f:b0:46e:4b89:13d9 with SMTP id 5b1f17b1804b1-471177ad526mr90113505e9.0.1760948969780;
        Mon, 20 Oct 2025 01:29:29 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710e7050c6sm114773395e9.1.2025.10.20.01.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 01:29:29 -0700 (PDT)
Message-ID: <5cee31c8-57d6-4245-a49b-bf317677e211@linaro.org>
Date: Mon, 20 Oct 2025 10:29:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] hw/audio/pcspk: Add I/O trace events
Content-Language: en-US
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Laurent Vivier <laurent@vivier.eu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
 Cameron Esfahani <dirty@apple.com>, qemu-block@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20251019210303.104718-1-shentey@gmail.com>
 <20251019210303.104718-3-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-3-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:02, Bernhard Beschow wrote:
> Allows to see how the guest interacts with the device.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   hw/audio/pcspk.c      | 10 +++++++++-
>   hw/audio/trace-events |  4 ++++
>   2 files changed, 13 insertions(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


