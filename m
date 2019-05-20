Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADE12398B
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389246AbfETOMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:12:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33878 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388999AbfETOMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:12:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id f8so8403004wrt.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LtpyLZhqnLdDthat07ZKj/UAvjXfB45eug5Fb4BluaQ=;
        b=fq0UPW9uWPJ/LBpwuP26uzjCwfDp70MAJU1jEakeU1MMCZtITIPctypV6qDLy2ER2n
         KjjpIfXCx3c+gT5qWntVk3G2MyVjFJmDyqx15PM0jVAWoiPXHK5VXbRwCRydL+cJWVmR
         NmIO1Esw5Dts/Jo4e+aFYPiFqExiHHQLnCGuX6e3Cl3ttX3pcdixwgPTxzNUP2TD7Vfs
         agvX+FrK/6rDFJjYnjOzBfrOhY0chHohHWHnqK1PVt1F2sCZiVjWPMpIpwQTy4JYLhBn
         8Q9Sr59UqHJD7s6pngrQ/TCK1YT/8eLG02bdRhGf+Y8YtcTv8j4e/AL+2jq3hswJsEfU
         e2Lw==
X-Gm-Message-State: APjAAAWw1ByTj5XcMgzUlAWNMweTgc+nOFjB1J/+aLuzj4hY8xyheYpv
        ceaMTV11vuGmo5nu7TxmltnYYB1rURUKBg==
X-Google-Smtp-Source: APXvYqwH9MnrZSrI2F3ZlxS02xyrazOiIXm4P+HpY9QmqliSHWFkS0eBWk1xfdJJ8q886Ps/DLLgJA==
X-Received: by 2002:adf:cd11:: with SMTP id w17mr12826039wrm.83.1558361555619;
        Mon, 20 May 2019 07:12:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id f10sm24667077wrg.24.2019.05.20.07.12.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:12:35 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Unmask LVTPC on interrupt
To:     "nadav.amit@gmail.com" <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190502174125.8706-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32982c4b-c54e-24aa-ccea-7c793cdac8d2@redhat.com>
Date:   Mon, 20 May 2019 16:12:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502174125.8706-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/19 19:41, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> According to the SDM: "When a performance monitoring counters interrupt
> is generated, the mask bit for its associated LVT entry is set."
> 
> Unmask LVTPC on each interrupt by reprogramming it. As the old value is
> known, no need for read-modify-write is needed.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/pmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index f7b3010..6658fe9 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -184,6 +184,7 @@ static void start_event(pmu_counter_t *evt)
>  	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
>      }
>      global_enable(evt);
> +    apic_write(APIC_LVTPC, PC_VECTOR);
>  }
>  
>  static void stop_event(pmu_counter_t *evt)
> 

Queued, thanks.

Paolo
