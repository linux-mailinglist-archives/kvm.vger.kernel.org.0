Return-Path: <kvm+bounces-36806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1557CA2135F
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:58:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 777A91647A2
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69481E3DE3;
	Tue, 28 Jan 2025 20:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jd2iBJUA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26081E3DF8
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097909; cv=none; b=qiSrfp7DDFDlAj59/loRou5nFuB9H1yqB2mJqZw8i1ebfw7cTEHSaDZLXBv5VUPqaCWows2EU+vXvxf6bLbaY8VpPrXjBBm6jb2MquoyK5I3+kq9aZmaLxLa0qSDIJ8lioAhvTqL8scYXzCC4hv2ecGCAnjMUK5UwpCm+qm4O/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097909; c=relaxed/simple;
	bh=KtQzbud5SCbb9UXKGMwBMldDYJvV5B7j9aNCWrrwrWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ENoyZTbdy5NOZCi4LfzybxtQXH4NiVqGw7J7e3X5dWog5jbdXSoImdzJqYlqsCMnec04OTSlGQ2q15C1SsHJ9tj3kV1Iffw/bGqc004QKZPW84dzXtkT0QMkQL1rKfWYktXMQJ0/WBYGQAvjXsSa3hPA92Pkzzt11mJB2IKHXYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jd2iBJUA; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2ef6c56032eso8291138a91.2
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 12:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738097907; x=1738702707; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8h5iWUGhVBBC/lkigmFD/STUslnMP70f4HvPeKAd450=;
        b=Jd2iBJUADG5FQ+CxRYfpbea8WzQROWJI4zW8dpCDSGzgHAfUk6jOHa8roVylpc4LkV
         B3WzR17jfb6LQ7pnmD4Msz5ypgtPqPTdLwwHRHKWL2Ig5rAfkB4iOc3hcgub2LAwVc5c
         idU1ICsWzMvBmkvibaVv/lVsZwFpOVH3SuuakQUiZeRricEc0nKncEFdyQ3A4zYYqXem
         pVa+m2ddkWxnLMU6q+dCovOlEUPdWfjIl/BvYJI1wwkWLADVHLjAzvAKRw5OuUSa8LPe
         AXkQvJ3K04H4Y3LTn0+C6c7aa0GYw9dSedGdGnPJWvN3Wk4gQjElqH950LDSjFm/ySgz
         54rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097907; x=1738702707;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8h5iWUGhVBBC/lkigmFD/STUslnMP70f4HvPeKAd450=;
        b=bv5Yi4u9eC8nc2K9TYlxWlsFCPt03W04nQrQ1goWiVcDAbi2dJOm7adAAzspRHKp5X
         Ce6YpK+ytQ8eFKR4faaTQQBD76Nn+ThOzKK9auNWnjn9EXpnPFN7Lwjg+UpF8wDjF5n9
         OeHmaaX7jy5ZriV7QjRG536SSjnwDkbUV720rT8qO5ZBXvHZUdS2hV+nCrqAbFU/guAp
         fruTiTQJGtFgNAdkPDIPsWOQfuDV9NAeexGypbZJRDEiV+jo9XTAnH+1p98jsltwAXOB
         tHhLm+T0z5EeVgDN7/Jlxajd3Fw+3G5kXKkYApx8Pyf4zv4gn2p9fgpT6SvHglrd93pN
         9ZjA==
X-Forwarded-Encrypted: i=1; AJvYcCXOq37BCtZtAHIfRpnVCOfNVrbx2f2cH062cDs1PnDC55pbtpTunYKpylhzfSAeCaLYcbA=@vger.kernel.org
X-Gm-Message-State: AOJu0YymVLgyt8T1rR6hF1dyYTQSkjxMPzPUg0aK4ANf/z52ric3umSc
	hHF0689lPLi6hcpnFcIU1e7Ezwfjnat9hvPm/jQT5/vUO0ydNahchzxORFLnIxg=
X-Gm-Gg: ASbGncvlkxBpnADPEKCic3FgE7/DrRCbWvFYwIAfSBNaX9IlCAi91/jFN2FwGUpdt0f
	uhPq0tWWvdLMzn3xW/4H9J10cjxjtgeRG5J57+QjRXqriwF9qND7wyw0PvYTmdOjpbU9RtidHAa
	4GWTAKkqQdhhGf3qYMDWLzDsp9tC4NUyKzvtR4npuWfWUPb4QgTE0vR1ooMfUR8H+0/tyrafYWV
	W50x1bGRyPqc2mTDgJG1D4vAwExeOfwnqtoTMqBbeJF5NghPYOx3ixsjb1usyGjy3nt9wv6Ob5z
	n7wGuBGd5/VKufUhB+I1RiRb0Vxi+Emu9wlLzGEEUC2jmisY/h71hCnpkg==
X-Google-Smtp-Source: AGHT+IE9sMcT2h+DOoOPi7bOSe3nzGIbc4vcCjybrIenk7Rc2O+QQp6BUUSuE+Uu0HIw08zA2OmGlw==
X-Received: by 2002:a05:6a00:35c5:b0:728:e745:23cd with SMTP id d2e1a72fcca58-72fd0bce22bmr1064373b3a.3.1738097906741;
        Tue, 28 Jan 2025 12:58:26 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6d2cb1sm9841865b3a.84.2025.01.28.12.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 12:58:26 -0800 (PST)
Message-ID: <7ac5eedf-8bad-4f0a-b78e-325543ade29d@linaro.org>
Date: Tue, 28 Jan 2025 12:58:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] accel/kvm: Remove unreachable assertion in
 kvm_dirty_ring_reap*()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250128142152.9889-1-philmd@linaro.org>
 <20250128142152.9889-10-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250128142152.9889-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/28/25 06:21, Philippe Mathieu-Daudé wrote:
> Previous commit passed all our CI tests, this assertion being
> never triggered. Remove it as dead code.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/kvm/kvm-all.c | 7 -------
>   1 file changed, 7 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index cb56d120a91..814b1a53eb8 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -830,13 +830,6 @@ static uint32_t kvm_dirty_ring_reap_one(KVMState *s, CPUState *cpu)
>       uint32_t ring_size = s->kvm_dirty_ring_size;
>       uint32_t count = 0, fetch = cpu->kvm_fetch_index;
>   
> -    /*
> -     * It's not possible that we race with vcpu creation code where the vcpu is
> -     * put onto the vcpus list but not yet initialized the dirty ring
> -     * structures.
> -     */
> -    assert(cpu->created);
> -
>       assert(dirty_gfns && ring_size);
>       trace_kvm_dirty_ring_reap_vcpu(cpu->cpu_index);
>   

I'd be ok squashing this, but also ok with retaining the patch separate for the CI comment.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

