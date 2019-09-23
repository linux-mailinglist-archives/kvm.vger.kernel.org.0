Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9278DBB1D2
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 12:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407500AbfIWKBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 06:01:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407478AbfIWKBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 06:01:15 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E53AC010839
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 10:01:15 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id n3so6411255wmf.3
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 03:01:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zLUtLu/KnWnoHcEa1QOKwZwcnw55ztopnQ9cohxkH6o=;
        b=LY4/FzixMuj/jMwaS8j4+CDpqhRx5XOcrN8tyswJ6spU6dtOkjd9vCAWTQjtUs1yst
         Vh+eZJiROUSFZ/pney9DCB3e1EhkYPnapDZCihQ+08G8YFLiORv2ouQKWDyt622Hr7tB
         EjujKUVjKfukVcvTmv28MJGGD2FSbvtJo+tIZW7psGGmOgh2vSkqoOcvUOOFnmVONVfJ
         CS+UFVHs0xi9MafleoiMwmxg9S+OdjPs2I7ynXclAiB4K/HFmRgD9t4vK24lX+yBbm/C
         5sUMgjQUb0iLGbZJfH3j0dQsB2cwRS6JU6c4hw2wXfONIMmMzdXZkPZk0BMVLMBKYkp1
         x2+Q==
X-Gm-Message-State: APjAAAVC1P0Dpor4fenNZxnFlJyzzl5up9EZDp2ATJwg3n1TP36yZsb0
        OhgMl8KmLUm4CirsIWeqMQ7n6yzhfk5bjtNz7NL5G+AhPKd9sbrVyOw/9xygJgD7HZhlmzuPuEH
        AvFIHFYgUca4k
X-Received: by 2002:a05:600c:2108:: with SMTP id u8mr13679639wml.13.1569232873867;
        Mon, 23 Sep 2019 03:01:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzf6DaFBwbPJTjPYZbiX3JiRzzjw1+nWOqSyWiHD2a7XEhD9MUyWlT8nL2XJ6rB4p5x8F7MbA==
X-Received: by 2002:a05:600c:2108:: with SMTP id u8mr13679624wml.13.1569232873623;
        Mon, 23 Sep 2019 03:01:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id l6sm12303726wmg.2.2019.09.23.03.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 03:01:12 -0700 (PDT)
Subject: Re: [PATCH 16/17] KVM: retpolines: x86: eliminate retpoline from
 svm.c exit handlers
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-17-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b8ec371a-58ac-3c40-4825-e67c2768b37e@redhat.com>
Date:   Mon, 23 Sep 2019 12:01:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920212509.2578-17-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 23:25, Andrea Arcangeli wrote:
> +#ifdef CONFIG_RETPOLINE
> +	if (exit_code == SVM_EXIT_MSR)
> +		return msr_interception(svm);
> +	else if (exit_code == SVM_EXIT_VINTR)
> +		return interrupt_window_interception(svm);
> +	else if (exit_code == SVM_EXIT_INTR)
> +		return intr_interception(svm);
> +	else if (exit_code == SVM_EXIT_HLT)
> +		return halt_interception(svm);
> +	else if (exit_code == SVM_EXIT_NPF)
> +		return npf_interception(svm);
> +	else if (exit_code == SVM_EXIT_CPUID)
> +		return cpuid_interception(svm);
> +#endif

Same here; msr_interception and npf_interception are the main ones we
care about, plus io_interception which isn't listed probably because it
depends on the virtual hardware.

Paolo
