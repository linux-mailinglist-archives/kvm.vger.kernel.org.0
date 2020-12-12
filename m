Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC672D837B
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 01:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437756AbgLLAfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 19:35:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437750AbgLLAfi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 19:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607733251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gQsW0gT4i8Rm6M91gLAH+2ngIYx6KO/ArOXFJ64fzOA=;
        b=YLKc7XAPC8kGcPSqUPTYl/QpPaOVubl2Li+1xMsOOMHF4nBl6kB5Ml6Pfx4xMfCUvjx45F
        ikZe+QjjPU6O2aaGF+NlQ4+DUtJKYkH9XNtwlxq+eJtfGMQ1JtVUwRoOLpfB66SlYV5i/4
        kNoAhSlWW8Z/UxAz4LaJ9qu1hwBybnc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-R8wR4XVgOHeTbxy_-Wz_TA-1; Fri, 11 Dec 2020 19:34:09 -0500
X-MC-Unique: R8wR4XVgOHeTbxy_-Wz_TA-1
Received: by mail-ej1-f69.google.com with SMTP id a8so3334087ejc.19
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 16:34:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gQsW0gT4i8Rm6M91gLAH+2ngIYx6KO/ArOXFJ64fzOA=;
        b=HPyCiYqQnv9Ra9GDENRMUBz8TzK/Iahg/zeC8WYYBQxlE2sIht+ubT6Y9zh87kx8tz
         9wCBhXLqfu+jQ1BIQ0tEtNY69dmIuGKmnEKjbFawg6PAdCFLmnNl6itbiwHyGbkL1xeH
         gvVcPMvrZQ5Y5HXaE4lrkT7++QXS4zn6VpAKLhEy+L5jrUdJhfkJ+Uqusu4R/upJDJPS
         8WwI6XT0qU599mf13oTcBe0t4Q0RobSb+toizeq/BFL0i1NpIdHw9oV85nhzQ2kRBy2v
         dbwjoqBhzkUM+Avk27Nj3i/+TiTMoK7gbh8Ze8HsUBDkciKxJ074rWDveELwvUrYOFyg
         hhiA==
X-Gm-Message-State: AOAM5321bHtWtefCsnJ693jfetCTWiI3SDXefW2Rh5MRShxtcdUmgVGm
        /TaUZhC2Y1YOMrEOsKGRYNnBquNtlXCbzLYyIP55Vk9LLe5o4tCzfYRsLQmP13KUgm8d4qwrKvW
        Mf7sklqSSIwfOlrpbcwG6RKxqm4rGhI8pRSZAqCh9vR0tEXSu3Bf8i1Rq+W++Ko+X
X-Received: by 2002:a17:906:6606:: with SMTP id b6mr13084283ejp.151.1607733248280;
        Fri, 11 Dec 2020 16:34:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcfjmNmLg9O9FHLxCb+hK4CyftMQSxhe84aXMvXsKCiH0yQmVa/2J3qZEuauyUinXwtzJXXw==
X-Received: by 2002:a17:906:6606:: with SMTP id b6mr13084265ejp.151.1607733248001;
        Fri, 11 Dec 2020 16:34:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o33sm9035101edd.50.2020.12.11.16.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 16:34:06 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: add regression test for posted
 interrupts
To:     Oliver Upton <oupton@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>
References: <20201006212556.882066-1-oupton@google.com>
 <18085741-6370-bde6-0f28-fa788d5b68e5@redhat.com>
 <CAOQ_QsjABDVuaKJYSxZOMga4JbJkzQFnZPQJkx2F-XVEahtDqQ@mail.gmail.com>
 <ec7287a9-70e0-3e00-eab9-8288669b6e2e@redhat.com>
 <CAOQ_Qsij7LH8XK28XqgbNTJqct6Q7LZsniSB3xAvtbPm1uYL_Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7ef38711-946b-5847-fcee-d5e1c343d3ed@redhat.com>
Date:   Sat, 12 Dec 2020 01:34:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_Qsij7LH8XK28XqgbNTJqct6Q7LZsniSB3xAvtbPm1uYL_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/20 01:24, Oliver Upton wrote:
>     Ok, thanks.  However, the patch currently fails like this:
> 
>              Test suite: vmx_posted_interrupt_test
>              VM-Fail on vmlaunch: error number is 7. See Intel 30.4.
> 
>     I haven't debugged it, so for now I suggest that you just move it to a
>     separate suite.
> 
> 
> 
> What commit are you on? Not reproducing for me.

kvm-unit-tests master + this patch

Linux kvm/queue

It works if I just invoke the test, but not with "./run_tests.sh vmx" 
or, equivalently

./x86/run x86/vmx.flat -smp 1 -cpu host,+vmx -append 
"-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test 
-atomic_switch_overflow_msrs_test -vmx_init_signal_test 
-vmx_apic_passthrough_tpr_threshold_test

Paolo

