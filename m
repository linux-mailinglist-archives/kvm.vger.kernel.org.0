Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02163B0EEF
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 14:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbfILMhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 08:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730454AbfILMhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 08:37:48 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 41C1FC010925
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 12:37:48 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id x1so11925019wrn.11
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 05:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pTZv96VgCJM8wv+X/QLpv4XlW1A0G4Xstp3NDxBDKyo=;
        b=nzAIc2MREbSFKbM5eXtmLGlBk0/dsJeWrUcbB0L7XlN8hcmVWL7SNQX45dwWd/+pHL
         lj3LWudyCgnyveiMpoYGXW9Prtsk5pqJSIV4enymCeXy5IJa9BT/YEn7GeDvSsMZQatD
         wDb4oJwtnv1u2w+QpWJhDFbA0ig271ugXmD0j1mI7aLIO0on4Y641bDK+q8tLQtcR5s3
         pRndm70lzGnLP0bn9g8VqmpBwVpYBuvkf6O23Xz4bfxR5dsHZ0gk7xPO3xfP8b4IBr6R
         //A3P2+GlVHUNg/4YM8rnWGzgm97d2PHZoA4NTGJMmNyEMbicvsEs1UFAzvlxpoLV31Z
         Ku2g==
X-Gm-Message-State: APjAAAUimdqAs61MHmVSvjSNBIDP8bIdtZONWDgdjeGstiKkIHcfnnK9
        dqv9Taaqbui3BkZ/k38O+XrQ6lnddDbpnlN7ESvEyx7GSoh2Vzi2Cbe6z8sYD23yPI/VYtuxTvV
        une9nAGUWmhHO
X-Received: by 2002:adf:d4c5:: with SMTP id w5mr34308604wrk.280.1568291866878;
        Thu, 12 Sep 2019 05:37:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw1mhu4LnobJt1OA0eB+e58fTNMsmy0X4vUrwR5SrILpKjnRo959U2YZY9ItQtIR8LbFYrB3Q==
X-Received: by 2002:adf:d4c5:: with SMTP id w5mr34308589wrk.280.1568291866654;
        Thu, 12 Sep 2019 05:37:46 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id m18sm33245834wrg.97.2019.09.12.05.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2019 05:37:46 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
To:     Wanpeng Li <wanpeng.li@hotmail.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1566980342-22045-1-git-send-email-wanpengli@tencent.com>
 <a1c6c974-a6f2-aa71-aa2e-4c987447f419@redhat.com>
 <TY2PR02MB4160421A8C88D96C8BCB971180B00@TY2PR02MB4160.apcprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8054e73d-1e09-0f98-4beb-3caa501f2ac7@redhat.com>
Date:   Thu, 12 Sep 2019 14:37:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <TY2PR02MB4160421A8C88D96C8BCB971180B00@TY2PR02MB4160.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/09/19 02:34, Wanpeng Li wrote:
>>> -        timer_advance_ns -= min((u32)ns,
>>> -            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
>>> +        timer_advance_ns -= ns;

Looking more closely, this assignment...

>>>    } else {
>>>    /* too late */
>>>        ns = advance_expire_delta * 1000000ULL;
>>>        do_div(ns, vcpu->arch.virtual_tsc_khz);
>>> -        timer_advance_ns += min((u32)ns,
>>> -            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
>>> +        timer_advance_ns += ns;

... and this one are dead code now.  However...

>>>    }
>>>
>>> +    timer_advance_ns = (apic->lapic_timer.timer_advance_ns *
>>> +        (LAPIC_TIMER_ADVANCE_ADJUST_STEP - 1) + advance_expire_delta) /
>>> +        LAPIC_TIMER_ADVANCE_ADJUST_STEP;

... you should instead remove this new assignment and just make the
assignments above just

	timer_advance -= ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP;

and

	timer_advance -= ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP;

In fact this whole last assignment is buggy, since advance_expire_delta
is in TSC units rather than nanoseconds.

>>>    if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
>>>        apic->lapic_timer.timer_advance_adjust_done = true;
>>>    if (unlikely(timer_advance_ns > 5000)) {
>> This looks great.  But instead of patch 2, why not remove
>> timer_advance_adjust_done altogether?
> It can fluctuate w/o stop.

Possibly because of the wrong calculation of timer_advance_ns?

Paolo
