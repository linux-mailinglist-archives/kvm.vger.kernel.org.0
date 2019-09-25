Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE62BD958
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437526AbfIYHum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:50:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437219AbfIYHum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:50:42 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF6D22D6A04
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 07:50:41 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id m6so1502524wmf.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 00:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HYW+7OIc+oWfT/yx6/DrRQ9OVDX/Tk7EiyaM2Cojmhs=;
        b=QAgDIJ/nn1p9u6lJdhEDaCtzS3kceWEBcVzlFunxOayo9q1Ra4unJQjcmxSYg3Bs5s
         8eixUYUA65bmp2cS/iAbzoQIcEjuxfqJervPapvuqkYgRA8OtexDzp3HR5wKM2yetnJg
         XtDYtMN6D47x38oYa4f0nuO7ErMsr2g7Hs4vSadbriWFOj2AvxnEN/z6kDadOTRLwwwO
         S0C4mc7phbZoOg+ge465r+GvoG83NraNejMfzEGZIRngaquzJIFEUkf4cHbfqg42JkvL
         1eYKbH9Q/znS1ofpH8g4nJjtjO3ucIDuR+fq8NzapIdf1uUpbTgdUdQvWvYCL7uqNzz7
         6w5g==
X-Gm-Message-State: APjAAAXUN0aZY4UHRwlsgQHGCg/ip78z7FbPI9LdzqNhHlgrrGRgefi2
        qB35vuP9LJts5kFsNyQ+6yBMZQ1iJtvVGeqL5hngBbTP85oehdGM07g77WXfUr/vBoiqwldkFmE
        EjTchDooPBbpa
X-Received: by 2002:a7b:c258:: with SMTP id b24mr5872501wmj.21.1569397840502;
        Wed, 25 Sep 2019 00:50:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxtvZMsWmeH3/rg+4pkIrLnbZniZnoLTRybC7fHAMsikPSeeBEnuwwdmtqFzu/RZt1IlIru4Q==
X-Received: by 2002:a7b:c258:: with SMTP id b24mr5872474wmj.21.1569397840246;
        Wed, 25 Sep 2019 00:50:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id b15sm3904376wmb.28.2019.09.25.00.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 00:50:39 -0700 (PDT)
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com> <20190924214657.GE4658@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5e047696-c641-da4b-1215-ebecbb492417@redhat.com>
Date:   Wed, 25 Sep 2019 09:50:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924214657.GE4658@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 23:46, Andrea Arcangeli wrote:
>>>
>>> I would keep only EXIT_REASON_MSR_WRITE, EXIT_REASON_PREEMPTION_TIMER,
>>> EXIT_REASON_EPT_MISCONFIG and add EXIT_REASON_IO_INSTRUCTION.
>> Intuition doesn't work great when it comes to CPU speculative
>> execution runtime. I can however run additional benchmarks to verify
>> your theory that keeping around frequent retpolines will still perform
>> ok.
> On one most recent CPU model there's no measurable difference with
> your list or my list with a hrtimer workload (no cpuid). It's
> challenging to measure any difference below 0.5%.

Let's keep the short list then.

Paolo
