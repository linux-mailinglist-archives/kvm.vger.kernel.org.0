Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4831BD97A
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgD2KVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 06:21:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32114 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726886AbgD2KVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 06:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588155689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hz9HME15vkT56qMj5LmOqA+tedqqwOFQ+Q8WjdDrPz0=;
        b=I71aYNgv0YXq1BFxTBbkTRFBPbeu8VithDOBhcQxc+/nT6ATOCxUAnwgnrgzxe4jAhUYa8
        kMVeKoKwnUf2eq/my1BTVZVhDx04OEfVTtmZ1fMV+ohh26Upt0Ig7RwoaYFBtzOOnSmKFW
        nxyQg2IqD014Nud/Z+HAor3rVzTwH50=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-MouzkVP7PlGAnXRCdEC8Fg-1; Wed, 29 Apr 2020 06:21:28 -0400
X-MC-Unique: MouzkVP7PlGAnXRCdEC8Fg-1
Received: by mail-wr1-f71.google.com with SMTP id q10so1488325wrv.10
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 03:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hz9HME15vkT56qMj5LmOqA+tedqqwOFQ+Q8WjdDrPz0=;
        b=dWrkfdHTWoxTK2HR8bRBScGScGjum0O4eI23SxdBifKzX7S8+3JawpbiG8nb/Gnd4J
         jXqhRi8f+tGZO0Fq3RDQCqB0bX/Lt6IwuPdVn0iRyTxN0IOxqBF+x3SdPplP0L6ix5zT
         gXvPS/VFsDSmVjw2F4VdSGg9kq/hnyu2tmvENCh/xDU3QZMv8IR2HL3+UTzgWICvoK3F
         P3t1xgJFm9c9Lka6P5dITxmiqhDVCnu0B4qbAoHI4jEZYuLYmxEZV1FEaEg93uo1kOUj
         g75Dqcty7iFpeCAOhfePN4KdkLXqvjrgHBtzB6olrbIMW1nw18rEsSbk1jd4Vmh9irZ4
         CPPg==
X-Gm-Message-State: AGi0Pubj9BLqZdt7ng8s+RO/ChBqldjWI1leVO2OegAcGyEf3HQCR1ye
        Y/mrUNPypeYKpdmdDoGtU7SWepErm9WUcZpj6I3BcRBsX/Am2UTzAehcrTfjfGzdNoXhoB3FkZA
        3Fqo1sd4Q4sHu
X-Received: by 2002:a1c:2457:: with SMTP id k84mr2313342wmk.96.1588155687036;
        Wed, 29 Apr 2020 03:21:27 -0700 (PDT)
X-Google-Smtp-Source: APiQypKKMMdeorh+RY8Ed8FPGANq5KrsjW/4VRsW6587QQ+69w47F8p9jVy1kPAJs3+G3UIspNlEEg==
X-Received: by 2002:a1c:2457:: with SMTP id k84mr2313325wmk.96.1588155686804;
        Wed, 29 Apr 2020 03:21:26 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id 36sm30729577wrc.35.2020.04.29.03.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 03:21:26 -0700 (PDT)
Subject: Re: [PATCH][v2] kvm: x86: emulate APERF/MPERF registers
To:     Peter Zijlstra <peterz@infradead.org>,
        Li RongQing <lirongqing@baidu.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        joro@8bytes.org, jmattson@google.com, wanpengli@tencent.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com
References: <1588139196-23802-1-git-send-email-lirongqing@baidu.com>
 <20200429085440.GG13592@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <201824a4-6b0f-9061-ec21-26d71fa11bc4@redhat.com>
Date:   Wed, 29 Apr 2020 12:21:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200429085440.GG13592@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 10:54, Peter Zijlstra wrote:
> On Wed, Apr 29, 2020 at 01:46:36PM +0800, Li RongQing wrote:
>> Guest kernel reports a fixed cpu frequency in /proc/cpuinfo,
>> this is confused to user when turbo is enable, and aperf/mperf
>> can be used to show current cpu frequency after 7d5905dc14a
>> "(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
>> so we should emulate aperf mperf to achieve it
>>
>> the period of aperf/mperf in guest mode are accumulated as
>> emulated value, and add per-VM knod to enable emulate mperfaperf
>>
>> diff v1:
>> 1. support AMD
>> 2. support per-vm capability to enable
> Would it make sense to provide a pass-through APERF/MPERF for
> KVM_HINTS_REALTIME ? Because that hint guarantees we have a 1:1 vCPU:CPU
> binding and guaranteed no over-commit.
> 

Yes but that's up to userspace.

Paolo

