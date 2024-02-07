Return-Path: <kvm+bounces-8208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A49584C491
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 06:59:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E05091F24D0D
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 05:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6631CAA5;
	Wed,  7 Feb 2024 05:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B/iu8H+R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C5917991
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 05:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707285568; cv=none; b=MlmFkvLYu3LEdil+3WV3JUzZKWI+7lh4gIghxJpz+WDIqSs/9KqFTZFriY6z9tIgtNrU21CY7yuVcBIeGXosUCUWBRqJScwAtxXyPsP7aPpqoZajmdjo6M9XhAqjYadnDbZe7BRP6wGcCewhrrLkqG1AbwGxqg/RJ9jZeE7FavQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707285568; c=relaxed/simple;
	bh=D8WUpmgsNjMI4p0FKXh4SIQ1XTEPueY+ErIOgeHkUl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FCh3vY+/5fsDs1KUkYcdqbVCKyjmxQANb6ceb4CPja9/ccxVHxT3R0ddTQYhPvU9cWs/SdJZSeZ2ikufQrYbLUOWzuG3v9DfggOHKmbVWbEJBPM/dYOg6NBv2jVgPW7zdPPEbp8cRjKLDPsuTF1ke3ZRJfbXn1Ez83W6cZi+1J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B/iu8H+R; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-556c3f0d6c5so244251a12.2
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 21:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707285564; x=1707890364; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5zFoQFTwEmwNFyWuTMDXQFaAIEDUHHBcrKekJ9KyuLA=;
        b=B/iu8H+RpVflKhXHPeemiGF5b2TtOCb13W+o/+juyG1FFxl07/fVp8pEfhStex9+73
         lRwYt8RLf9S+twqbW5egPp77IsqAakQsB714Fd9MABXQH1V4015Sz8gvSDDe1cXQilUV
         93rhJ6fx8kFqkBpRNcH+dfspTJ4hd7fdzLPT4P1e2JjbYq6z7YFKwhuJp2WxJQNRdSV4
         nZ+JbmFOj54SuPXHwfNHnDF5krHsxD42Oz+mtOhMxMn11nzkcwJYQvG002tSOpdrfZok
         n8jev7UWRt5Iki30kuuUktM55bgq56xHrqM5XtyRlD4aw+GjXE2TBrj45vu5LUGuSBZe
         XpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707285564; x=1707890364;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5zFoQFTwEmwNFyWuTMDXQFaAIEDUHHBcrKekJ9KyuLA=;
        b=ZYJiswcTVy2ajzQFuIfvzcfeyOtgt5cjnMpMxAfacSPfIbkk4XGBX/yMsE/jCyS+Nv
         i10JsnkmjSXnQaZdg3gEgdbYXA7Ajao7wDa4pDzIVn+cDGGeFGSHvxn32wkpS/c8ptmI
         Z8fvCv40WR2W9O4OpppvDDHCwPTQRP55e94oGC+V95rPluWWE6jG4aCf3k/VOinpqcZj
         LVSaXfb9iFMaJjfj/0XHQBqlbimityXSVcv6KhHWG9bQel7FvnLdlMe6BI/gbg6rdmrA
         lu05r7XPRlXDO1ILaQbzwwgS+R3S6sPebyGDGPMRTq/TpHVVrF6UoQXZfrZD1BvlUA5N
         qrcw==
X-Gm-Message-State: AOJu0YzwGUrjm6zQwKn4YlJSVJZGq9hhNVN41kTXiI6KHk6eh/pYR+FA
	GGDdXJ5HQP3xKHwRn+dGNn1J7SHIOhpldQryZ2Nuh+Jm5u72t30yvzsinSiQ7IE=
X-Google-Smtp-Source: AGHT+IFGmHRig14xmfWcdgiq2ux6S31f9kgE1l3S6m/Av9FGSE0WEHcyBsXJ7uVbud+zuXPMCT6F7Q==
X-Received: by 2002:a17:906:895:b0:a37:9bae:ee09 with SMTP id n21-20020a170906089500b00a379baeee09mr3353688eje.11.1707285564629;
        Tue, 06 Feb 2024 21:59:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX3Ar+vYdUAh4mCXRTlN5Inyq7IxPDaThhmkiKjIuLdUvHeOIIrgsZY2Ei+GVV7gHq+xIVk0fkFwFl0nFIFYQHoCAhP/5O7PGhbW2EybcQBn3RLN4ARk+RHwyH29jIJmxsvg+n7pV+7njoT24nyVJiR5NKDCQjyWXQmFrw2K+Umbn4eFdkNy9NLA75bPzqto2XTxV7lr+5ZmgAf1pQ3/bruiu1kduHFoTVAz2+CeWJCKJKS8g8vfUboWatRHmt0vgoSaC6UlwoBPUrI3uCwEjOCCfmh02CwbXR9f3fXrBDu7t2E01KlvBnMyZrIp0vcxX80bXzFvTzPCelyS+lvuZsEaRun1GA6aeV8jd+tdw1ZdJ7D0/FqIvnrAx/kQew6KIQfCS7JRulw+6gwT4S4RLDLfk2jFldCJZ5uQwx1l7O/3fLbHPupnoIORXki5CUoLvXdATRXFELtDVb2fjjq2m3rne0dYGe/U0Lcolj8b53wa9e3/WyPUZ2uDusqTucRPtC/ebtyelpjjgYeNIuJ20yO0b15kylwlHKbkF9l6nDCbvQMlnLwXFEzclFl/LA=
Received: from [192.168.69.100] ([176.176.170.22])
        by smtp.gmail.com with ESMTPSA id i17-20020a170906265100b00a38576aefabsm353945ejc.161.2024.02.06.21.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 21:59:24 -0800 (PST)
Message-ID: <9b6555f7-65ce-4efd-a45d-10aacf71446e@linaro.org>
Date: Wed, 7 Feb 2024 06:59:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/21] i386/cpu: Consolidate the use of topo_info in
 cpu_x86_cpuid()
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Babu Moger <babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Yongwei Ma
 <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Robert Hoo <robert.hu@linux.intel.com>
References: <20240131101350.109512-1-zhao1.liu@linux.intel.com>
 <20240131101350.109512-9-zhao1.liu@linux.intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240131101350.109512-9-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 31/1/24 11:13, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> In cpu_x86_cpuid(), there are many variables in representing the cpu
> topology, e.g., topo_info, cs->nr_cores and cs->nr_threads.
> 
> Since the names of cs->nr_cores/cs->nr_threads does not accurately
> represent its meaning, the use of cs->nr_cores/cs->nr_threads is prone
> to confusion and mistakes.
> 
> And the structure X86CPUTopoInfo names its members clearly, thus the
> variable "topo_info" should be preferred.
> 
> In addition, in cpu_x86_cpuid(), to uniformly use the topology variable,
> replace env->dies with topo_info.dies_per_pkg as well.
> 
> Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes since v7:
>   * Renamed cpus_per_pkg to threads_per_pkg. (Xiaoyao)
>   * Dropped Michael/Babu's Acked/Tested tags since the code change.
>   * Re-added Yongwei's Tested tag For his re-testing.
>   * Added Xiaoyao's Reviewed tag.
> 
> Changes since v3:
>   * Fixed typo. (Babu)
> 
> Changes since v1:
>   * Extracted cores_per_socket from the code block and use it as a local
>     variable for cpu_x86_cpuid(). (Yanan)
>   * Removed vcpus_per_socket variable and use cpus_per_pkg directly.
>     (Yanan)
>   * Replaced env->dies with topo_info.dies_per_pkg in cpu_x86_cpuid().
> ---
>   target/i386/cpu.c | 31 ++++++++++++++++++-------------
>   1 file changed, 18 insertions(+), 13 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


