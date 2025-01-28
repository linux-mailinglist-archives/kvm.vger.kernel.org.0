Return-Path: <kvm+bounces-36799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC8EA212E2
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44D2A165638
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 255481DE4E0;
	Tue, 28 Jan 2025 20:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l1cfFVET"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDC6158A09
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738094890; cv=none; b=SsA1kfDngi+v+mwhQ3e308q7s/l4hzLrVtdifVhflk3MuwchEAX6zb4oSOJBRlG6mvfhaaUa7Ayg3niNnLRMB/g90gg9yr2u7YFBajsHUKtPH8SBw/wUtv252ITXsB/emCUGFkn77FaaRUnw4sKJpvrzHxXQqwsBHoZbcifI6uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738094890; c=relaxed/simple;
	bh=8EFv8N5+VSVCoZioIjpFZGH3myaDtFIBMuKUdFwCUKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qFgbVytLQJHXtEfsxmNFu0YfeWe1id/bQJd2F+X+qyHkjPtdYOQbdtuHsoqyJGi1YRUkaghrbUloOdlIRS6KYJfV/zXcgRAXEV+l8HJYnO806mPQNPUn4DWakvBN5EdmsrVJ2pnHO7b54OQBwAe3Xdi39JKiEu++3YQqa370yqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l1cfFVET; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-216281bc30fso35928725ad.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 12:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738094888; x=1738699688; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C8vGqtwH427Yn7WVK0Iub56+XP5B5P3sodKxFPk8lOs=;
        b=l1cfFVETsFBXIKy5XpMDUn89TY852IMTNymQXiRmZA3r8r2pb0/nHgkaU1d1WkLFsp
         XhY3kiRz1b5rOBbRkcnFopUPcEaypr4nzq9YMJBbRKfPRUT7OA9KnSnTaHYv3awR5E3o
         9xgRSAtHn7pebWp+48FP7DJEemKH2wK6sWGFkvirlN0WtaIAAtsHwM1DzhqRzWbntT0A
         XrJWpz8BbjyqYwqbWgabnNlPeg16K4PQCUa2lhPNbS020eY+Mi1VQS65aHl4kSIVshYF
         oRPFDrteMbnMCZpudkQmV5EDGiLmjusxJo4QneJOiTapBYWVasT5JnDRx4oafh0vEElF
         YbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738094888; x=1738699688;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C8vGqtwH427Yn7WVK0Iub56+XP5B5P3sodKxFPk8lOs=;
        b=StnzgyFpE9UFcAby5nPuI0klpCuJes4O+9IusZB8TR1ONr6y/S+939WstTHyjprbqm
         9iw+z3j2Z7dKY+OCzZH1mnJHEtpPbAljo8Ssyfl0dQYJjpg0J1T9UeiV2qYNcrTsS94h
         qO1B6pF/FPruT3g3GrA00yY2OLgKkagrGRsFmGxz/5fzN4v/acc2P3s/4peqWTb0+WZe
         CvcE3kQtAqaP/Bz/eURp4fjeK/izOTCYolLis8wrsSOckry/1B+VWC31pckBBXFLSrfG
         B3PmW2T2YySAGrQfB4lfSztjhykF9ySspESO56hpHygRAecLxeozicMfbLURlff47w/r
         I9Cg==
X-Forwarded-Encrypted: i=1; AJvYcCXoeFM2w/7Hh0JZdH3pRtFGnfQlkhPuCu8ybRjK9l/HLHEnaoF+dQFkdt6bAv/uufkpeOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgRsqSqkZaFEbhpXqh7IjMysNLfmYHqHVK7OQ8eLOFUsw0qu4V
	G5WFnKhRTRyUuC2nxaF4p5vUQhfcHORmV1ICVjymiTnPSuZpcYJo/7mWZI/i6Qc=
X-Gm-Gg: ASbGncuKKLQiHoZFvUFlUW9jMKAi8iYlfyrK7wq1vZ5UKznRdYWiENSEa2XQXstJwRt
	cUoGuv2lkIrOyUUQpSgI32lfFxmSdovt5ptmste6izSVNRheJQ4G7Gm+Nl5qYnBfGGHmKxZEPGu
	+EQqoymfODO5lc+RvOgtab48LGdidOHJJqjaxyQKRc7sEnX792rUCnsU+Zygk5aeM+sIdq5Ck18
	ob89eYYqm/IZOwd6EBjREn1PKKj4plMe/F84DlUZvA8eE7rS7VQVJ47FmvrOg5LwcNDmQ30Tg1x
	kXS3YJBU9DAxxBRFqqkVJMYmDHbJRkpCHp4K3HfxjJlS8SC6n+x7W0ECbQ==
X-Google-Smtp-Source: AGHT+IGMvh23YHN9jSB1IcuWrcXCloNh/Nr5McHWBP563Xec/Hb97vfJ5XMCLdrcZfwy9/Eok1nQUQ==
X-Received: by 2002:a17:903:11d0:b0:216:644f:bc0e with SMTP id d9443c01a7336-21dd7d7887dmr5588555ad.24.1738094887954;
        Tue, 28 Jan 2025 12:08:07 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3ea3b45sm87002455ad.97.2025.01.28.12.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 12:08:07 -0800 (PST)
Message-ID: <61b6b085-cc5e-4439-8af0-e51f45207a03@linaro.org>
Date: Tue, 28 Jan 2025 12:08:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/9] cpus: Remove cpu from global queue after
 UNREALIZE completed
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
 <20250128142152.9889-4-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250128142152.9889-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/28/25 06:21, Philippe Mathieu-Daudé wrote:
> Previous commit removed the restriction on completing the full QDev
> UNREALIZE step before removing vCPUs from global queue, it is now
> safe to call cpu_list_remove() after accel_cpu_common_unrealize().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   cpu-target.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/cpu-target.c b/cpu-target.c
> index 667688332c9..11592e2583f 100644
> --- a/cpu-target.c
> +++ b/cpu-target.c
> @@ -172,12 +172,9 @@ void cpu_exec_unrealizefn(CPUState *cpu)
>       }
>   #endif
>   
> -    cpu_list_remove(cpu);
> -    /*
> -     * Now that the vCPU has been removed from the RCU list, we can call
> -     * accel_cpu_common_unrealize, which may free fields using call_rcu.
> -     */
>       accel_cpu_common_unrealize(cpu);
> +
> +    cpu_list_remove(cpu);
>   }

I don't believe this is correct.  Why would we have an unrealized cpu on the list?  What's 
wrong with removing the cpu from the list before unrealize?


r~

