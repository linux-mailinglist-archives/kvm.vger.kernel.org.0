Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAD529F73
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 21:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391802AbfEXT4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 15:56:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53739 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391181AbfEXT4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 15:56:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id 198so10507079wme.3
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 12:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0GEOz5AbCK75BUSbgRcvRqBVy9AZ5+iXTj72Y9RfMlA=;
        b=ly3g8Cd14u8RoYaX6Nu7/jPSUzob8fBNkWqNki+vQxBaqk78NVadxo9UZox9Ni4ODb
         9VPCmgec41WWpa/B50ZuCxu0InoKtuQFD8s01v+EL/bTbRS1s9K1yHvK4iZ/KGEZwK1f
         dWzEF8qvjh7ZOmcEiSf1svkngZtUr+Hpdd2u4DBh1ktQWXrbHFXe13uE9KelkLQOlTKQ
         Or5OsKeRtoxwW0RVw0vZjCUOqqA1RJjAdrkxCRaz3YhXf09OzljGknoKxi0m+rYd+b0j
         F/Ng+g2CxhQLFxqOW3vwBnR86Jzi+wKAIICUVbchp8m+Gd0AStrOvA3hnt6AYOmZ73c+
         upqg==
X-Gm-Message-State: APjAAAVPiX3QoCVFN15D4zw8CEbnP3kZzFsvrV4vpqeE0hxak4ilcasz
        11nAyvHBdObkwNes8OaKiSH3wA==
X-Google-Smtp-Source: APXvYqxgi6dIDb+oYqkiOUpuLaxFRX75R+mVqegTHw/M3edO1w3QJ9KzaXUqr5BWvWGo2K92e3/R7A==
X-Received: by 2002:a1c:9e92:: with SMTP id h140mr1065764wme.82.1558727776217;
        Fri, 24 May 2019 12:56:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4d53:18d:3ffd:370? ([2001:b07:6468:f312:4d53:18d:3ffd:370])
        by smtp.gmail.com with ESMTPSA id l18sm3646158wrv.38.2019.05.24.12.56.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:56:15 -0700 (PDT)
Subject: Re: [PATCH] kvm: fix compilation on s390
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mkubecek@suse.cz
References: <1558725957-22998-1-git-send-email-pbonzini@redhat.com>
 <d34269ea-054f-4dee-4485-3121cb3255c1@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3d1b18d4-4d8d-3738-aa49-34ea28c02c84@redhat.com>
Date:   Fri, 24 May 2019 21:56:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d34269ea-054f-4dee-4485-3121cb3255c1@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/19 21:54, Christian Borntraeger wrote:
> On which kernel tree is this broken? kvm/queue has 
> 
> #ifdef CONFIG_ZONE_DEVICE
> around that.

It's a better version of that patch in kvm/queue, which I had committed
just to temporarily unbreak you guys.

Paolo

> On 24.05.19 21:25, Paolo Bonzini wrote:
>> s390 does not have memremap, even though in this particular case it
>> would be useful.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  virt/kvm/kvm_main.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 1fadfb9cf36e..134ec0283a8a 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1761,8 +1761,10 @@ static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
>>  	if (pfn_valid(pfn)) {
>>  		page = pfn_to_page(pfn);
>>  		hva = kmap(page);
>> +#ifdef CONFIG_HAS_IOMEM
>>  	} else {
>>  		hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
>> +#endif
>>  	}
>>
>>  	if (!hva)
>>
> 

