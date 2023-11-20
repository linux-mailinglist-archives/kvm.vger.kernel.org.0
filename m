Return-Path: <kvm+bounces-2064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B16E7F12B4
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:06:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACA621F23EE2
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A4E18E2F;
	Mon, 20 Nov 2023 12:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="HnO/ppiz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FDCB8
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:06:25 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cc9b626a96so30843675ad.2
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1700481985; x=1701086785; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xVcC8hR/V0NYT0+DB0uWFXv4sVGxkELPBpe0/v11m1o=;
        b=HnO/ppizM8cfSWaDgEGbMcPd5eBa6UOHmyWL7vaiT0FimNmOQS+KH/RwTiQQcMrcjb
         zfW42PV534nwcpjPD254kGcioPcFz+CGzh56ywJ1SMT9tXEARKtKrEJBjWzzqolJpS0j
         UMqXmD3v/LwBsp/hueOrfYFBXSAC5yHr2/Do6hcc/GgWTLzUFq68ERCpAkRiWpnkxVPF
         OSplZVF+Lg1nqgqByLBnijiv5SmMEMe2NafCH66ay20UT18bM8KAZzgzofbSshuJ13do
         kZOwDOUuew7681N/rnIuBkFME11xa/N01B/ttdl81/hnNDiFVgyjZyEILEMBR1Y2IwEx
         J6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700481985; x=1701086785;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xVcC8hR/V0NYT0+DB0uWFXv4sVGxkELPBpe0/v11m1o=;
        b=m68u1jJ3cDb+T78YGq7KvNgb8WcOvnO3pGRzBmCrKEk3AH23YjfHxfLGbdngJ9IvRp
         Q86dDX5uC495I1jPGM7Q2awl3Pk1NmnWx4+DKpeGx8GhXm+gdp+ozxKFcPcMrb9hKS+3
         m+fODOElvvseQBuyKnLpbJRf0PH+RMYYYgK82gdCgIxIabBSRFjbYOKM9+YCvi8kvocC
         tWNkQIGLzf6I1rg7IbKRVAes94EUxGR5Swev+bo0e+MVCH+vAlbaLvwJ/lAnYKYqYVrF
         OayDXmpGp992diO10qVaQLE2vK+bn/gfWKkFCKmKzhwqWRDbdJCRrXktW7aJtaCp0YFf
         hpDA==
X-Gm-Message-State: AOJu0YxlHda6espugnVb0x0pLSBeSeklgw9fw20Z1KsVRE18cxUpFnUq
	KkO+J4RE746P2SjNWKdCw+33Fg==
X-Google-Smtp-Source: AGHT+IGM1XuWCU5poSeUzc7w4cvTyjbzDfnxMsuQyhs+1L/NEmEH7PI3Hq6+FgbcpyTkz6qgnpHy0A==
X-Received: by 2002:a17:902:c18b:b0:1cf:5673:3630 with SMTP id d11-20020a170902c18b00b001cf56733630mr3480320pld.6.1700481985103;
        Mon, 20 Nov 2023 04:06:25 -0800 (PST)
Received: from [10.4.27.171] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id t1-20020a170902bc4100b001c60a2b5c61sm2170268plz.134.2023.11.20.04.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 04:06:20 -0800 (PST)
Message-ID: <06613204-b279-4f66-a786-e5e26bccd42e@bytedance.com>
Date: Mon, 20 Nov 2023 20:06:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tobias Huschle <huschle@linux.ibm.com>,
 Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org, mst@redhat.com,
 jasowang@redhat.com
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
 <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
 <2c7509e3-6db0-461e-991b-026553157dbe@bytedance.com>
 <20231120105606.GQ8262@noisy.programming.kicks-ass.net>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <20231120105606.GQ8262@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/23 6:56 PM, Peter Zijlstra Wrote:
> On Sat, Nov 18, 2023 at 01:14:32PM +0800, Abel Wu wrote:
> 
>> Hi Peter, I'm a little confused here. As we adopt placement strategy #1
>> when PLACE_LAG is enabled, the lag of that entity needs to be preserved.
>> Given that the weight doesn't change, we have:
>>
>> 	vl' = vl
>>
>> But in fact it is scaled on placement:
>>
>> 	vl' = vl * W/(W + w)
> 
> (W+w)/W

Ah, right. I misunderstood (again) the comment which says:

	vl_i = (W + w_i)*vl'_i / W

So the current implementation is:

	v' = V - vl'

and what I was proposing is:

	v' = V' - vl

and they are equal in fact.

> 
>>
>> Does this intended?
> 
> The scaling, yes that's intended and the comment explains why. So now
> you have me confused too :-)
> 
> Specifically, I want the lag after placement to be equal to the lag we
> come in with. Since placement will affect avg_vruntime (adding one
> element to the average changes the average etc..) the placement also
> affects the lag as measured after placement.

Yes. You did the math in an iterative fashion and mine is facing the
final state:

	v' = V' - vlag
	V' = (WV + wv') / (W + w)

which gives:

	V' = V - w * vlag / W

> 
> Or rather, if you enqueue and dequeue, I want the lag to be preserved.
> If you do not take placement into consideration, lag will dissipate real
> quick.
> 
>> And to illustrate my understanding of strategy #1:
> 
>> @@ -5162,41 +5165,17 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>>   		 * vl_i is given by:
>>   		 *
>>   		 *   V' = (\Sum w_j*v_j + w_i*v_i) / (W + w_i)
>> -		 *      = (W*V + w_i*(V - vl_i)) / (W + w_i)
>> -		 *      = (W*V + w_i*V - w_i*vl_i) / (W + w_i)
>> -		 *      = (V*(W + w_i) - w_i*l) / (W + w_i)
>> -		 *      = V - w_i*vl_i / (W + w_i)
>> -		 *
>> -		 * And the actual lag after adding an entity with vl_i is:
>> -		 *
>> -		 *   vl'_i = V' - v_i
>> -		 *         = V - w_i*vl_i / (W + w_i) - (V - vl_i)
>> -		 *         = vl_i - w_i*vl_i / (W + w_i)
>> -		 *
>> -		 * Which is strictly less than vl_i. So in order to preserve lag
>> -		 * we should inflate the lag before placement such that the
>> -		 * effective lag after placement comes out right.
>> -		 *
>> -		 * As such, invert the above relation for vl'_i to get the vl_i
>> -		 * we need to use such that the lag after placement is the lag
>> -		 * we computed before dequeue.
>> +		 *      = (W*V + w_i*(V' - vl_i)) / (W + w_i)
>> +		 *      = V - w_i*vl_i / W
>>   		 *
>> -		 *   vl'_i = vl_i - w_i*vl_i / (W + w_i)
>> -		 *         = ((W + w_i)*vl_i - w_i*vl_i) / (W + w_i)
>> -		 *
>> -		 *   (W + w_i)*vl'_i = (W + w_i)*vl_i - w_i*vl_i
>> -		 *                   = W*vl_i
>> -		 *
>> -		 *   vl_i = (W + w_i)*vl'_i / W
>>   		 */
>>   		load = cfs_rq->avg_load;
>>   		if (curr && curr->on_rq)
>>   			load += scale_load_down(curr->load.weight);
>> -
>> -		lag *= load + scale_load_down(se->load.weight);
>>   		if (WARN_ON_ONCE(!load))
>>   			load = 1;
>> -		lag = div_s64(lag, load);
>> +
>> +		vruntime -= div_s64(lag * scale_load_down(se->load.weight), load);
>>   	}
>>   	se->vruntime = vruntime - lag;
> 
> 
> So you're proposing we do:
> 
> 	v = V - (lag * w) / (W + w) - lag

What I 'm proposing is:

	V' = V - w * vlag / W

so we have:

	v' = V' - vlag
	   = V - vlag * w/W - vlag
	   = V - vlag * (W + w)/W

which is exactly the same as current implementation.

> 
> ?
> 
> That can be written like:
> 
> 	v = V - (lag * w) / (W+w) - (lag * (W+w)) / (W+w)
> 	  = V - (lag * (W+w) + lag * w) / (W+w)
> 	  = V - (lag * (W+2w)) / (W+w)
> 
> And that turns into a mess AFAICT.
> 
> 
> Let me repeat my earlier argument. Suppose v,w,l are the new element.
> V,W are the old avg_vruntime and sum-weight.
> 
> Then: V = V*W / W, and by extention: V' = (V*W + v*w) / (W + w).
> 
> The new lag, after placement:
> 
> l' = V' - v = (V*W + v*w) / (W+w) - v
>              = (V*W + v*w) / (W+w) - v * (W+w) / (W+v)
> 	    = (V*W + v*w -v*W - v*w) / (W+w)
> 	    = (V*W - v*W) / (W+w)
> 	    = W*(V-v) / (W+w)
> 	    = W/(W+w) * (V-v)
> 
> Substitute: v = V - (W+w)/W * l, my scaling thing, to obtain:
> 
> l' = W/(W+w) * (V - (V - (W+w)/W * l))
>     = W/(W+w) * (V - V + (W+w)/W * l)
>     = W/(W+w) * (W+w)/W * l
>     = l
> 
> So by scaling, we've preserved lag across placement.
> 
> That make sense?

Yes, I think I won't misunderstand again for the 3rd time :)

Thanks!
	Abel

