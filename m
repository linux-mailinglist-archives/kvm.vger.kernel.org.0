Return-Path: <kvm+bounces-60685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1F7BF78F5
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3E1E335678C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31629340A6C;
	Tue, 21 Oct 2025 16:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TGbGfDuA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792CC336ECD
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761062476; cv=none; b=QgPw+e2d4YmSojswZ17dEpbG7wlRnTa/xbv0TjHBtJrGAzrjoj2vSjNMyKWbI0G+n2o7fgGqfQm1WafzE50ISzhteM5H7qeFE80ZS7aBIuMwXrE5qQz6sRP5Uy04q1V0GdPFgwJME5jr7+XhyHThES6JP5nQ58uuU5KHOpb8kdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761062476; c=relaxed/simple;
	bh=n7w+aXvQhLpFgaQ1YNLtJrIQL7OJwLYXcP+NKrqEy34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VVeHRvdcXfxpWQdnNnIJ2k2xoilrmVw9g36I/RK0mBuTZopB7t2ni8AutdvqjOtp9Gju0TQziJCutN7dZcyf4rNqAuSi8nm5KXQ7apvMmIecSNHVaC6uSjnfwI0SPs8gigfgrmHn6gmuI9qJ3t+RO19biBae/lzJzpC4HgT8yes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TGbGfDuA; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47114a40161so15135825e9.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 09:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761062473; x=1761667273; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wi4jMzpi3nbawrsaPcGe1LeGK6a/mFs1A8RcgbTOttA=;
        b=TGbGfDuAXPP6SgPCWr8gWIPebDRqCX+QWFZbpbf82+5HV0cG/sjUrBJWBu2UqKjw7Q
         8qK/bzt0kXVOFhx8tyHx2ollCh9WVefOnffF9ijSKDz5BAWuTf5w+tRWsXyZMXKzHQaK
         S9x6kjH4XBw6Sr787I75xtvVEX7jiYDeVERH9ts7q8eQGuwmd15DxGqs3auAsPVpLTV/
         0BQBRAslEmO/1imPuy4FOp2GJ1WI9pe0ItdUz+QGta85/t2PXARmJ4vCb8u9GwlF4lyu
         m6QRgKrZod9Hq4jHQK2mKNfGvTNwZOywzZ9hjdTc7032U3NvBrK4CY390z9a3YPlFY8M
         vjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761062473; x=1761667273;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wi4jMzpi3nbawrsaPcGe1LeGK6a/mFs1A8RcgbTOttA=;
        b=GI5Dmo3lgReVZMNdsjM3vfXC4IeATmsqbQoEG7fqa1puk8UERvtcotr/0dOIogV68k
         dwEkPcfRCXxBcd4XwCMkFktNbEX+wo2Ap93/J9chCdW7b0b22+xq9iiFjCFT7mT3Weiy
         ZGKGTmiBXIUhx9xrLenEEe2xNK65KMxdttEvfQnPLz6vrJPDQ9T7QsdmlS78Uty4CfyI
         PBkEm94Kah/jczFserb0tHZZ5MaBRcoJYf/yT3sbNh1hEE93nYU+ZkBfO2eD5wMWFmWp
         Xz+yv5abm/CPvbGDE25/YnzL2y/zhgqkjxGi27RKd+9KusFN+qQxgEPBPKexhwjG59v4
         dGZg==
X-Forwarded-Encrypted: i=1; AJvYcCUY3t6Hp74IPR1KW+dtxtadr3VZwYSjJQlgQJCWscnn82w0s9BaEPQCAr5EbqMpWQS/UJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YweCBRvY3m8juS5yxGgxlldi8KYU/Ji9vsUbqtXbOj1hwxqCZSL
	Sp2aNZsOZsJ9Sq3f7yJrOY2D+vvKMC3De4enXHBDXBsVKQZesbLGX4A3KPTrjL134nk=
X-Gm-Gg: ASbGncsw77/NMLIjH8tyZvK2OyzZp2orwxdBUOy2uqQFtNf9R/bTGjJT0saVVsFvBeO
	AS6Gxk2ga1UPUjlXuPArv/002qstwMRR5vecZ4lzCpmGMebn/ptj66NNdCCtbPPMsL1fnUGsBFQ
	nqW9VknLuE5hpuoDI311CovlNOUpvrSSfFAWbYhhJ/eKlEfowNfRJgqUKz3+r9L4OVV7FteG8Mu
	QQUPjhlMwCM2y3U5LOvvt2kvtRpcF3FIqhhgBM6iAEUBHaxhWZkgOxGQAijwUQLMfvGpQWhHnTv
	MITcPwflzeEm7KVmYGMgUNhP1hKebNRGYozQucwVDAsEDMtdyOY62ntjzLBbtE+R/eJbIAAZi4/
	r5C3y9kSEZMvjuhUidEgOl9KtjISW0QWf7SV1IyO9PGIN1y3YmljfbEFSTY8aKE18RxPPpiVqKi
	/A1X/TVFJdQIPx4ztowo04x0xA8ED4Hqjfbt+1dALNvEpjgRHwd6lk1Q==
X-Google-Smtp-Source: AGHT+IHrko61yHL+EkLhNGwx9wqvLp8HifeGykLYFnZoo841oLOivvfKWYEyiB4PmnxGj+jpat6DHA==
X-Received: by 2002:a05:600c:45ca:b0:46e:59dd:1b4d with SMTP id 5b1f17b1804b1-471178a4bb0mr128739695e9.16.1761062472496;
        Tue, 21 Oct 2025 09:01:12 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144c82b8sm287502825e9.15.2025.10.21.09.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 09:01:12 -0700 (PDT)
Message-ID: <f1e8c675-d7fb-407c-adba-d30ed0e771b8@linaro.org>
Date: Tue, 21 Oct 2025 18:01:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] hw/intc/apic: Pass APICCommonState to
 apic_register_{read, write}
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
 <20251019210303.104718-10-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-10-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:03, Bernhard Beschow wrote:
> As per the previous patch, the APIC instance is already available in
> apic_msr_{read,write}, so it can be passed along. It turns out that
> the call to cpu_get_current_apic() is only required in
> apic_mem_{read,write}, so it has been moved there. Longer term,
> cpu_get_current_apic() could be removed entirely if
> apic_mem_{read,write} is tied to a CPU's local address space.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   hw/intc/apic.c | 35 ++++++++++++++++-------------------
>   1 file changed, 16 insertions(+), 19 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


