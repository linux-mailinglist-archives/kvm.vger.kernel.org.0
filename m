Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77A1C9BEC
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 12:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfJCKOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 06:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbfJCKOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 06:14:36 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 877EEC05E740
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 10:14:36 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id q8so900007wrp.8
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 03:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ia+gGf8D4RKqD3mYHNJW4KBxV39P1F98Z1sPmxgCPUE=;
        b=m7wra4ydmjvZhzyUR6YrktxvpIjtPrNPMAjiYvqB6X8wvzkAO8qqBslMYvhJThgBte
         pBLr9BhgSNQiOQ2qCoK8KZyS4OPuiyc5cAyMjCM0VuptWwJn/NxUqB+LmaDkvSYeAjeh
         +YfPIvgoS/JEcr2aiSvgyZhzS8vujsrh0bQUmw4pWbScjbtlUzgSUOjPpryJtnMAAtgF
         rxSsLHPHEUYVrUx3rAQnwwMGbxV6IuAs8VU0ENKsO4yx1FbqjcJJ5K6EiApYbswwY4Wk
         ToevOV7Nldv/tFIQoWyWlVkcAdZ39onjR+sJHnlG0Pie+hZGLxBNvgEQHNkt41RWqfdf
         Krxw==
X-Gm-Message-State: APjAAAWkvVN4chTwbHpl+sJYcs09PRkWuC5PO8qFtI72MOFzufDplJHs
        uN8JdkDdtr2KItMhPhXYRcn7e7D4NaQe4oloLGTkmKmORi61lBwLPJqYsxGaL2ug39Hp8kiO1lg
        bder304a4klIM
X-Received: by 2002:adf:fa86:: with SMTP id h6mr6381161wrr.152.1570097674773;
        Thu, 03 Oct 2019 03:14:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxiL1KyYf7AH8ZuOpHEBO+Sv2DSfWFZnG8bjX9o9BKUHcZpAC6YIg7sjWK9r+jlV/CkD8mV7w==
X-Received: by 2002:adf:fa86:: with SMTP id h6mr6381135wrr.152.1570097674523;
        Thu, 03 Oct 2019 03:14:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id n8sm2851784wma.7.2019.10.03.03.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 03:14:33 -0700 (PDT)
Subject: Re: [PATCH tip/core/rcu 2/9] x86/kvm/pmu: Replace
 rcu_swap_protected() with rcu_replace()
To:     paulmck@kernel.org, rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
 <20191003014310.13262-2-paulmck@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dd735e5f-c326-4b53-1126-98c5e38961d3@redhat.com>
Date:   Thu, 3 Oct 2019 12:14:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003014310.13262-2-paulmck@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 03:43, paulmck@kernel.org wrote:
> From: "Paul E. McKenney" <paulmck@kernel.org>
> 
> This commit replaces the use of rcu_swap_protected() with the more
> intuitively appealing rcu_replace() as a step towards removing
> rcu_swap_protected().
> 
> Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: <x86@kernel.org>
> Cc: <kvm@vger.kernel.org>
> ---
>  arch/x86/kvm/pmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 46875bb..4c37266 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -416,8 +416,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  	*filter = tmp;
>  
>  	mutex_lock(&kvm->lock);
> -	rcu_swap_protected(kvm->arch.pmu_event_filter, filter,
> -			   mutex_is_locked(&kvm->lock));
> +	filter = rcu_replace(kvm->arch.pmu_event_filter, filter,
> +			     mutex_is_locked(&kvm->lock));
>  	mutex_unlock(&kvm->lock);
>  
>  	synchronize_srcu_expedited(&kvm->srcu);
> 

Should go without saying, but

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
