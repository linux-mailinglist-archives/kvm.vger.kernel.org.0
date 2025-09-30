Return-Path: <kvm+bounces-59075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EFADBAB4E4
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C26C516324B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8294E24677D;
	Tue, 30 Sep 2025 04:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IjU+pWJH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C961DE89A
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205738; cv=none; b=C5rl5rSGjWlbNFCdvtBgdax3+00CeecTn1ggK+TPq6acqd4q+VLfmf/U4Q6jmixSVX+xEFxNsAnIOdE1C4yY57ye0iGNLQXvh7adoou6q4Bu2VHskKgCVk5Uvr3KLGvOoAOpufmfL10jX9e3EGCqfiKftDkSO2MWKUVA+5PYhxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205738; c=relaxed/simple;
	bh=LuY/fuI25ix/jLxeQc6Vujowfpy2w6BNYH45SLPtOac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HuTMQl+nwMW9oi7o+PmZYZSJCpoYjZUbfCUA6dn6TWBj/7p2p+aLIi+H2nOX/ev8ZnriyerZ37692y7584OhtQiFZ4aiKMCpAsDIZEriEWpjFXiLOiUiew5nm9Kk1y5a8U3iYmr26qnvnwUdWcfjBGx/Vl6GdgLrpSItyc3KLXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IjU+pWJH; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42421b1514fso232587f8f.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205734; x=1759810534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+gM01wdk2UseDL4pB4Fgwz3uSs5dQf4zrjZtOq7eYBI=;
        b=IjU+pWJHS7CcLdr7VLu6f1K6lGg+B+AmBpMfmPvqbj0l2P9qiWKLtZJnR2/kZ2mNYT
         rCiJpwtUvhHTCNEX66911Nqpce5R0vYanvx9o+Qcj4mdQJtKxAZ8PlR3HTGISP8xd72U
         AMdbDTxHHjd2oMx4KAnprwYJKmdAXO2fOXuCm79LFfpHpg/BCC7tfMYCp5X+7oqSITLI
         1txqwzsIXFhJWsUr6JhGPHL4NKMptellB+Rw+98pz6prsSVrXXn0J0cisBvlVoQK7XCD
         KkkYddsbacnfytRz/uPRNyI3dSmQejUtnUh9/26jt/PIbZWiGEBsYGcee8/vwAV5uMcm
         vEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205734; x=1759810534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+gM01wdk2UseDL4pB4Fgwz3uSs5dQf4zrjZtOq7eYBI=;
        b=A6htheMS+Aq9KXBKhRDezxXqWpyDbgyqxmnAzksqp7AQ1SuZq498kK9S9arnAAAywy
         zmV2zf0/U7uh9KcOq+t+0ufJcicS6PuI8Do9iMr14Um/CpKnExG7wVjVILZn1F2UP+u5
         omqfJKRvkrkwkf/4TgycbpEl4DyHsHAsCTIKfapjT2Hh3Oqk9THKFC8/+5Q+OqfzY9r8
         I6ii9W9DGIoJBpervY2Itysl2UgflvO+3+WOhSGgnz4uWw8hlY7F9oqmcEN+zjWCNHpx
         zRQmf/GpsmnLGKYf6oQ7f02t+H7Mcfetphc5qAym+P5SeSfYx0CQ5+9i/K2dCeMG9NBm
         WHGw==
X-Forwarded-Encrypted: i=1; AJvYcCWj1gaUZMjw+EsY46rIs3o4z6LfEaA+tfoYOZMuz3qH1jVsfA6gpnZDg12QeZNwlnqcpUI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZdyPtk1IKqGUdSRDfmtt1hFTjIpZJG/+9eRpVCIUzxX2o9WSj
	dDhe6AMTI9tywbpAH3JW6FtSvNbqkSTX1+2vOP5t3Ec85AxyndwzWKUURGzREpejNG0=
X-Gm-Gg: ASbGncslpsArnqa5BQLA+Vfjm3Q82mmjQaKX1mHWtDscNYIZYnD0JHVd3nbGMmO65Sj
	1d2mQJu5K7BkB0TzijjSEKuSq6DuGZj3ud41AQHI0fv5qVXB2IqKQW4PpC+B5Y6Jt4i9lkP2JiE
	2Vm4o2Hs7Lww0tdbtRlz4JmUDSTT+faZByFdHnWGS9VHKF3oazxs+XzI6HRaz91mu/8riDkJzzv
	mwlAH+fuHFCbTpIMYot8iyeK/FuAWwXjP1OOoWrmlPBkdGKKIyjee46c9SiNmGgSPPGfJiIocjA
	xx0d/XWayhmg128FfuIKYmA+pii5S2mR2YMxztaIYZqG7o1y5A5d7T5nuQI9c7JFuAraPIMNfRX
	sIRTNTdI0LxoDtwaR6AZqTfFukYVDxBnLTTnrixRmfd/Jb+ybRV5vl+WgVXnF/3kb4KlfFvsseB
	Au5Pt8o1IIRtbk4gzjAIgq8VfN
X-Google-Smtp-Source: AGHT+IG3+NO8caXmgDpmIXUT4U2a38OsXEUMyu+A/7GxYYPazyV8IqumGfAwZ8JxEPW+ODAlASvvgw==
X-Received: by 2002:a5d:5888:0:b0:3ec:dd16:fc16 with SMTP id ffacd0b85a97d-40e4bd186aamr16627860f8f.43.1759205734391;
        Mon, 29 Sep 2025 21:15:34 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb89fb2fcsm22030581f8f.22.2025.09.29.21.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 21:15:33 -0700 (PDT)
Message-ID: <95145136-7d86-4fb0-a93e-f23af9622ea6@linaro.org>
Date: Tue, 30 Sep 2025 06:15:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/17] system/physmem: Pass address space argument to
 cpu_flush_icache_range()
Content-Language: en-US
To: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc: Jason Herne <jjherne@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>, xen-devel@lists.xenproject.org,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 Eric Farman <farman@linux.ibm.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Zhao Liu <zhao1.liu@intel.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>,
 Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Hildenbrand <david@redhat.com>
References: <20250930041326.6448-1-philmd@linaro.org>
 <20250930041326.6448-8-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250930041326.6448-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/9/25 06:13, Philippe Mathieu-Daudé wrote:
> Rename cpu_flush_icache_range() as address_space_flush_icache_range(),
> passing an address space by argument. The single caller, rom_reset(),
> already operates on an address space. Use it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

> ---
>   include/exec/cpu-common.h | 2 --
>   include/system/memory.h   | 2 ++
>   hw/core/loader.c          | 2 +-
>   system/physmem.c          | 5 ++---
>   4 files changed, 5 insertions(+), 6 deletions(-)


