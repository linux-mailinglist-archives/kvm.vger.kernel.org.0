Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C56379C493
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 06:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjILEOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 00:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjILEOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 00:14:51 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0E0BA
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 21:14:47 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-68fb71ded6dso1471721b3a.0
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 21:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1694492086; x=1695096886; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drM0H8ao22RI12hMMB2VfXYxqiSVys99eLtTMdg41bs=;
        b=hMaLayQwMUApTj1jeESz0wO6Xz+TrhdZgpcwCADtTpaPHuMQzhDpTiN8O++zjRmO61
         aSefxpIIbGpOWfncFc7hYsTQaAI4oD2Ba+pbMOIs40YTYdxEJrE2ka7v+Hv4vH1juU0p
         Ri33MH6F5OfiM9lYMp14aAeF6zUMjEoAxYISSLNVKtDJQDmnxha7Tduv7JGq37BMnGJk
         nD1NC8NIIpLk2EV1WlAq+h/QQg36W0e2rsMyeJ8kzo0yje8CMBkqTQDNVuj/612iX8RZ
         LEOzYe2xP9KN2D4+In7VWxcGAHbBgfOrrGDC2qL1JxnNs6SYWD901oQZD5dJI/60IxW6
         K18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694492086; x=1695096886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=drM0H8ao22RI12hMMB2VfXYxqiSVys99eLtTMdg41bs=;
        b=LeOaPIRPkZyV559RvOnZOjLr8xPgbHlcp08SgAsGTH6T+qfDZLqWbrSpdzat4pfOXx
         Rs/rhFao/JDJtB29zJW0fXHaJ6PV1nqbI0hDBErIE2tRXOd/iFdCggL0GNdiH7zM/T1D
         2EV1fO8oyqrNyVH70HXwc/bUNSuzI3cQi9V5tFWWOOF3zrEXm2pjtL19JPY1H3uoyNo2
         cex0ZOYYQ60XBvXvRBpqQNuqkZ/X06AHvBwlSPp6emFYa9HWjYHGY80cdt+ftz7DEhzT
         M/tPcslhN2rUP/LXLume9UqcQPLRghUaMiVci5ispXz1IOS6vJYLYpTZFcYNpU59+KwA
         7ghQ==
X-Gm-Message-State: AOJu0YxCzzkZ4CWHyH2Tc2f6MiNlrF/DxWatVxRx5ay5qtEVnjtPsMK4
        6vC1h/zYoM1zHBsvMrtr3rdv0g==
X-Google-Smtp-Source: AGHT+IGstt/vwuSpm6rFlRDM4PATk6FF/oRYMNvZG9bcxVP4oaJfy6XkFEJSUJYu9JC4by/XrcLx3A==
X-Received: by 2002:a05:6a00:15ca:b0:68a:4dfa:ea63 with SMTP id o10-20020a056a0015ca00b0068a4dfaea63mr11064158pfu.19.1694492085788;
        Mon, 11 Sep 2023 21:14:45 -0700 (PDT)
Received: from [10.3.221.67] ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id bk15-20020aa7830f000000b00689f5940061sm3510656pfb.17.2023.09.11.21.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 21:14:45 -0700 (PDT)
Message-ID: <28610076-6ac7-4004-8479-e0005ff96c63@bytedance.com>
Date:   Tue, 12 Sep 2023 12:13:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2] KVM: arm/arm64: optimize vSGI injection performance
To:     Marc Zyngier <maz@kernel.org>
Cc:     oliver.upton@linux.dev, james.morse@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        zhouyibo@bytedance.com, zhouliang.001@bytedance.com
References: <20230825015811.5292-1-zhaoxu.35@bytedance.com>
 <86o7iidzwb.wl-maz@kernel.org>
From:   zhaoxu <zhaoxu.35@bytedance.com>
In-Reply-To: <86o7iidzwb.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023/9/4 17:57, Marc Zyngier wrote:
> On Fri, 25 Aug 2023 02:58:11 +0100,
> Xu Zhao <zhaoxu.35@bytedance.com> wrote:
[...]
>> -	unsigned long affinity;
>> -	int level0;
>> +	u64 aff;
>>   
>> -	/*
>> -	 * Split the current VCPU's MPIDR into affinity level 0 and the
>> -	 * rest as this is what we have to compare against.
>> -	 */
>> -	affinity = kvm_vcpu_get_mpidr_aff(vcpu);
>> -	level0 = MPIDR_AFFINITY_LEVEL(affinity, 0);
>> -	affinity &= ~MPIDR_LEVEL_MASK;
>> +	/* aff3 - aff1 */
>> +	aff = (((reg) & ICC_SGI1R_AFFINITY_3_MASK) >> ICC_SGI1R_AFFINITY_3_SHIFT) << 16 |
>> +		(((reg) & ICC_SGI1R_AFFINITY_2_MASK) >> ICC_SGI1R_AFFINITY_2_SHIFT) << 8 |
>> +		(((reg) & ICC_SGI1R_AFFINITY_1_MASK) >> ICC_SGI1R_AFFINITY_1_SHIFT);
> 
> Here, you assume that you can directly map a vcpu index to an
> affinity. It would be awesome if that was the case. However, this is
> only valid at reset time, and userspace is perfectly allowed to change
> this mapping by writing to the vcpu's MPIDR_EL1.
> 
> So this won't work at all if userspace wants to set its own specific
> CPU numbering.
> 
> 	M.
> 
Hi Marc,

Yes, i don't think too much about userspace can change MPIDR value, I 
checked the source code of qemu, qemu create vcpu sequentially, so in 
this case, vcpu_id is equivalent to vcpu_idx which means vcpu_id 
represents the position in vcpu array.

These days, I'm still thinking about whether it is because of the 
content related to future vcpu hot-plug feature that vcpu_id can be 
modified, but now it seems that's not entirely the case.

I have read your latest patch and have been deeply inspired, and Thanks 
for agreeing with this issue.

With Regards
	Xu.
