Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061051A9F71
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 14:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368615AbgDOMMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 08:12:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43149 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S368582AbgDOMLm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 08:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586952701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3g8pOUWTOZg7Xu60Mt7A1x/Ov3i7r+YKQXs6UW5HczM=;
        b=RGQ9ReOxUD6zJxpTpcJyovIWYbtUkeED3xFLICuYpGDlGl/rd+rqnNoCERJwPU+rJtxclB
        kzwoRxnLECElXSIlg1wGMaDqEmFbNwD+NqUGlqpurC/cuS6hFxs7UIIZr1SOGDyLOJPkzc
        fwwsB7SR1oicULgzTA8mT74GS8uEOPk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-ytUYPQlgNeeyFU0MXnF5pg-1; Wed, 15 Apr 2020 08:11:39 -0400
X-MC-Unique: ytUYPQlgNeeyFU0MXnF5pg-1
Received: by mail-wm1-f71.google.com with SMTP id h22so4161423wml.1
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 05:11:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3g8pOUWTOZg7Xu60Mt7A1x/Ov3i7r+YKQXs6UW5HczM=;
        b=HBMw+Ud72lQ+W8tIF7/pcQE5nLNLs07z5STg/DwPBpl3CE7sPmiKgJ8c1dQc2Mdp2w
         cxZccJWuO/stJb/9k6SA4KSC7zbMjUhQwq0q+QXL0j999mBjXliFBDuE0rkJ5DsuX3ln
         wv74idKYq3Q4TybYesAqoeecrzPSD8YT+exakmQzNPCs1jHC9bIFDa/Q/KB1J8Cjv3dk
         d6gGkM/OdlUmpFWazs6C2OybByCRXxmHMZLaRNnC/gCqC623i0sjp0fwQXxkv4r8tOTI
         GhkZfkEsintAXN2wEJ9IwIX7oCcut6+Tzc9o9ptOby1jJ916fEaaHGk9R68MAwlhzeAP
         XJVw==
X-Gm-Message-State: AGi0PuaaHqknoywe0dYwoi4F/srZfk842gz6q3JqS4L/gVrcF/zq4JPa
        0dDQKmTkRqzp7eCznSQhqPrYPOnIL7AApHq1Eedy6aEYWf78/FRTv/J9lyFPj5OwYoHAf1Niy9C
        eZhDRJiIGw7CG
X-Received: by 2002:a5d:688f:: with SMTP id h15mr29234452wru.352.1586952698402;
        Wed, 15 Apr 2020 05:11:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypKdWpo7ENEPbDqHP93vSXvdpZwuSMQZ1BbP1xfwyNZcod/63Icpez1n6CuR5oR+nIQbYmcMPw==
X-Received: by 2002:a5d:688f:: with SMTP id h15mr29234435wru.352.1586952698180;
        Wed, 15 Apr 2020 05:11:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id q8sm22064722wmg.22.2020.04.15.05.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 05:11:37 -0700 (PDT)
Subject: Re: [PATCH 3/4] kvm: Replace vcpu->swait with rcuwait
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     tglx@linutronix.de, bigeasy@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        will@kernel.org, joel@joelfernandes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <a6b23828-aa50-bea0-1d2d-03e2871239d4@redhat.com>
 <20200414211243.7vehybdrvbzmbduu@linux-p48b>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2f87633-8eef-4f84-5e65-a80523ca34f8@redhat.com>
Date:   Wed, 15 Apr 2020 14:11:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200414211243.7vehybdrvbzmbduu@linux-p48b>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/20 23:12, Davidlohr Bueso wrote:
> On Wed, 25 Mar 2020, Paolo Bonzini wrote:
> 
>> On 24/03/20 05:44, Davidlohr Bueso wrote:
>>> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
>>> index 71244bf87c3a..e049fcb3dffb 100644
>>> --- a/arch/mips/kvm/mips.c
>>> +++ b/arch/mips/kvm/mips.c
>>> @@ -290,8 +290,7 @@ static enum hrtimer_restart
>>> kvm_mips_comparecount_wakeup(struct hrtimer *timer)
>>>     kvm_mips_callbacks->queue_timer_int(vcpu);
>>>
>>>     vcpu->arch.wait = 0;
>>> -    if (swq_has_sleeper(&vcpu->wq))
>>> -        swake_up_one(&vcpu->wq);
>>> +    rcuwait_wake_up(&vcpu->wait)
>>
>> This is missing a semicolon.  (KVM MIPS is known not to compile and will
>> be changed to "depends on BROKEN" in 5.7).
> 
> Do you want me to send another version with this fix or do you prefer
> fixing it when/if picked up?

It's up to the TIP tree people, but sending a fixed version is probably
the best way to get their attention. :)

I can also queue it myself (for 5.7 even) if I get an Acked-by from
Peter though.

Paolo

