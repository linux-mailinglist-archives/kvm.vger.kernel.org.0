Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FF9B003A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 17:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfIKPhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 11:37:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbfIKPhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 11:37:45 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FED281127
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 15:37:45 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id k67so1399987wmf.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 08:37:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3XLJ7eZ1CQ0PWL5ZEqS5Y8lsWjbNW3IqaUi1I6ulBVI=;
        b=GTrgLe7/500/lvLP7UV04STreAFr4qyA+0KwN1kncSn6pKIb/4dnfNpLUs+2PGkTu0
         ORhcmbDKMjf5cT5PqOKhVP5osC7DFjzYswL5lw59+x05kWtDZAdEdXEYeAVC46P8EFvr
         SpZVACb2sZTFEJ74QrkzPjIuokMfOFxD1c0tlWTqgYGh3O4XmkpjqB2BAsBnkhZgk3wf
         P90XOr4CGAZ6Nh3bSVsB/JggmE3+g57ncjYRA3jCi/2pQ9H2nW+pFX64LbsBAaI8xOwx
         ZmC5qIlRkv8lRfTH6GWNPpjeITyvlfnhY5D5WoW1/ZO7NAH8/cGK0Is5ZkJ3unUNOCcA
         QvWw==
X-Gm-Message-State: APjAAAVMuPhVwqOqY5RZKxRKgQwS6XpFS7vidY0G5qVnRvxVwuynApLB
        7otU9pACTBURuG2f0EYm/DBiLJStni22b+k5DuVVTRWRROzAA/Kt4BP/7FUqz06fnlS1e8sj18L
        ktqI2jXBVz+/Y
X-Received: by 2002:adf:ef49:: with SMTP id c9mr12842164wrp.122.1568216263852;
        Wed, 11 Sep 2019 08:37:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzqCXK2KnvaIutrGXCWZzmXZzAIvSvCoAoo/FnD+ib++sl3jZhQPRUlbGb3479dw2aXXotChQ==
X-Received: by 2002:adf:ef49:: with SMTP id c9mr12842148wrp.122.1568216263598;
        Wed, 11 Sep 2019 08:37:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id m62sm4138179wmm.35.2019.09.11.08.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:37:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests RESEND PATCH] x86: Fix id_map buffer overflow and
 PT corruption
To:     Evgeny Yakovlev <wrfsh@yandex-team.ru>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, yc-core@yandex-team.ru
References: <1566979099-23628-1-git-send-email-wrfsh@yandex-team.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e121f8a3-32c3-5923-1cdc-f8d96de4b59c@redhat.com>
Date:   Wed, 11 Sep 2019 17:37:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566979099-23628-1-git-send-email-wrfsh@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/08/19 09:58, Evgeny Yakovlev wrote:
> Commit 18a34cce introduced init_apic_map. It iterates over
> sizeof(online_cpus) * 8 items and sets APIC ids in id_map.
> However, online_cpus is defined (in x86/cstart[64].S) as a 64-bit
> variable. After i >= 64, init_apic_map begins to read out of bounds of
> online_cpus. If it finds a non-zero value there enough times,
> it then proceeds to potentially overflow id_map in assignment.
> 
> In our test case id_map was linked close to pg_base. As a result page
> table was corrupted and we've seen sporadic failures of ioapic test.
> 
> Signed-off-by: Evgeny Yakovlev <wrfsh@yandex-team.ru>

Superseded by

[PATCH] x86: Fix out of bounds access when processing online_cpus
[PATCH] x86: Declare online_cpus based on MAX_TEST_CPUS
[PATCH] x86: Bump max number of test CPUs to 255


Thanks,

Paolo

> ---
>  lib/x86/apic.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> index 504299e..1ed8bab 100644
> --- a/lib/x86/apic.c
> +++ b/lib/x86/apic.c
> @@ -228,14 +228,17 @@ void mask_pic_interrupts(void)
>      outb(0xff, 0xa1);
>  }
>  
> -extern unsigned char online_cpus[256 / 8];
> +/* Should hold MAX_TEST_CPUS bits */
> +extern uint64_t online_cpus;
>  
>  void init_apic_map(void)
>  {
>  	unsigned int i, j = 0;
>  
> -	for (i = 0; i < sizeof(online_cpus) * 8; i++) {
> -		if ((1ul << (i % 8)) & (online_cpus[i / 8]))
> +	assert(MAX_TEST_CPUS <= sizeof(online_cpus) * 8);
> +
> +	for (i = 0; i < MAX_TEST_CPUS; i++) {
> +		if (online_cpus & ((uint64_t)1 << i))
>  			id_map[j++] = i;
>  	}
>  }
> 

