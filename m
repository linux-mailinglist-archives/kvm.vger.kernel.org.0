Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57BC6192EED
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 18:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgCYRKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 13:10:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:36267 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727539AbgCYRKA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 13:10:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585156199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vevCBANHYn2Lnc4NylQjd/uYKWuxOb7yWJMgri8X8CA=;
        b=ASVxzbOLz5fxrVVal2rz1GC4mVPygtM3hT42PS3M8d0fJigej6hFmatNnoyxFl05t1WvUd
        whgJLid3UAS7Rg7zPkW5wtSIHsvXyjrQh3CfppbUURyrxP/Ui2gwcMA/8W/N8TJLVXxgvo
        CzMMB5l7zf+PLj/M2Tnbn7Jxx2b6Bs8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-0G3VgEvbPhiwBirQz-6JIg-1; Wed, 25 Mar 2020 13:09:57 -0400
X-MC-Unique: 0G3VgEvbPhiwBirQz-6JIg-1
Received: by mail-wr1-f69.google.com with SMTP id h14so1439095wrr.12
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 10:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vevCBANHYn2Lnc4NylQjd/uYKWuxOb7yWJMgri8X8CA=;
        b=Txy9D9PCb9mPYl6Bfxh8KSjsB+HTaIJDflVzfzoyb4aKmbpkbQkX50qWruNGAes7fX
         iqQnGycloFt9Djca9ObbXcUHFQNL8LlpwPooeH9VMS72OWcKfxWQ9ojTsJD1Fuq2wOwk
         HPx66TZyQoNFdjhkSw225kxrw6UJsCfQ3bZljBfkgnPrmAyq8jRCpK5A0o6izu7mOLWS
         krLCkyxQEkdZkpmnv3XjG10D30EbzblC8a+Aqr7qy3edZ+0w8Kj7RN8End+aoDgzbEdh
         HfuXYwjgzhy6SZ9tN2dxvN3jDtxNckxDHuKrsZnQ6X0I5I/ZeMWTVn9XHPd+CAX1fIUV
         qUpQ==
X-Gm-Message-State: ANhLgQ2/MuA24rUniJD8I8xZZO7JvJMAeNIV03N8vT7N1b4lEgSDzpJu
        qa1aFHs6k+wAMepcouP0dLnQU/YrlCVlu2EoQxpIO7mlix1ri32Iw6t0dHdBweXPWmsuEPhrP77
        P9dfWqwAvEP5X
X-Received: by 2002:a1c:ab54:: with SMTP id u81mr4174235wme.166.1585156195991;
        Wed, 25 Mar 2020 10:09:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsDeuPAf6z2VeRFRt7ZJYFWF9FC4OwqXVMD3tFXVyspIst/9JsJ8aRkJ29STSyG+27J7ShG6g==
X-Received: by 2002:a1c:ab54:: with SMTP id u81mr4174213wme.166.1585156195636;
        Wed, 25 Mar 2020 10:09:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e4f4:3c00:2b79:d6dc? ([2001:b07:6468:f312:e4f4:3c00:2b79:d6dc])
        by smtp.gmail.com with ESMTPSA id q8sm35205395wrc.8.2020.03.25.10.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 10:09:54 -0700 (PDT)
Subject: Re: [PATCH 3/4] kvm: Replace vcpu->swait with rcuwait
To:     Davidlohr Bueso <dave@stgolabs.net>, tglx@linutronix.de
Cc:     bigeasy@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a6b23828-aa50-bea0-1d2d-03e2871239d4@redhat.com>
Date:   Wed, 25 Mar 2020 18:09:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324044453.15733-4-dave@stgolabs.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/20 05:44, Davidlohr Bueso wrote:
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 71244bf87c3a..e049fcb3dffb 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -290,8 +290,7 @@ static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
>  	kvm_mips_callbacks->queue_timer_int(vcpu);
>  
>  	vcpu->arch.wait = 0;
> -	if (swq_has_sleeper(&vcpu->wq))
> -		swake_up_one(&vcpu->wq);
> +	rcuwait_wake_up(&vcpu->wait)

This is missing a semicolon.  (KVM MIPS is known not to compile and will
be changed to "depends on BROKEN" in 5.7).

Paolo

>  	return kvm_mips_count_timeout(vcpu);

