Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6B99CE35
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 13:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731478AbfHZLet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 07:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbfHZLes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 07:34:48 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22C0889AC7
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 11:34:48 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id k10so9549219wru.23
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 04:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5a3vSStb7ftKwA4utZbsdS+A5/09h8anZ9iE0vcfgVg=;
        b=q7tpUJD1pTP4R5M1TbqKdrca4fPGLQcZsx/YhGrdWmZTykyII3/AjgN61CbCmEiZdG
         zUu2qTKrn+gwIi1mxMupe9FOHwY1Bd6PFWizZACYTgZrsha9B+GeKs4qK4BDs4yWIkc+
         WSJsESejmN+Wvp5SR+j5r2iHs9OeKnX8wZYKM0zASXl8fHWQnOaRBLzWfLZ2+yPkyzcj
         fG/G6Sx22LyZUrt2tux+HIgi8qasaHpXRu329yJIpcmJGeo7z3UTKTard7Yg6noU4La1
         eSza31oYIdoXEA1Gr6vJaxV9j253vESmCeGCLBpBAgViuJkeAa/rY+xJ0qHGPUw2J/fC
         pAEw==
X-Gm-Message-State: APjAAAWygmg0+jnKC87OydBp52yJ6hQ6yJBCyI4+RfbJnhDW3/ojAExv
        ozHhwDK+xwqot5hiFuFnCx8MK8+KOapF9skyK3/Q2lGCFiuxA+I6eso6t5zg5aFMlPZuruR8Ex4
        UOGFNr1NphLqB
X-Received: by 2002:a7b:c753:: with SMTP id w19mr20762653wmk.91.1566819286071;
        Mon, 26 Aug 2019 04:34:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzC1LCPXBt8nuvA/86wEzBtpk/eUBu9wiT4maZQHMDpgfojfdfHRxz+0uH2fRwkODsIUHpa/Q==
X-Received: by 2002:a7b:c753:: with SMTP id w19mr20762626wmk.91.1566819285841;
        Mon, 26 Aug 2019 04:34:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t14sm11572383wrv.12.2019.08.26.04.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 04:34:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Detect max PA width from cpuid
In-Reply-To: <20190826104757.GD1785@xz-x1>
References: <20190826075728.21646-1-peterx@redhat.com> <874l24nxik.fsf@vitty.brq.redhat.com> <20190826104757.GD1785@xz-x1>
Date:   Mon, 26 Aug 2019 13:34:44 +0200
Message-ID: <87tva4ma7f.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> On Mon, Aug 26, 2019 at 10:25:55AM +0200, Vitaly Kuznetsov wrote:
>> Peter Xu <peterx@redhat.com> writes:
>> 
>> > The dirty_log_test is failing on some old machines like Xeon E3-1220
>> > with tripple faults when writting to the tracked memory region:
>> 
>> s,writting,writing,
>> 
>> >
>> >   Test iterations: 32, interval: 10 (ms)
>> >   Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
>> >   guest physical test memory offset: 0x7fbffef000
>> >   ==== Test Assertion Failure ====
>> >   dirty_log_test.c:138: false
>> >   pid=6137 tid=6139 - Success
>> >      1  0x0000000000401ca1: vcpu_worker at dirty_log_test.c:138
>> >      2  0x00007f3dd9e392dd: ?? ??:0
>> >      3  0x00007f3dd9b6a132: ?? ??:0
>> >   Invalid guest sync status: exit_reason=SHUTDOWN
>> >
>> 
>> This patch breaks on my AMD machine with
>> 
>> # cpuid -1 -l 0x80000008
>> CPU:
>>    Physical Address and Linear Address Size (0x80000008/eax):
>>       maximum physical address bits         = 0x30 (48)
>>       maximum linear (virtual) address bits = 0x30 (48)
>>       maximum guest physical address bits   = 0x0 (0)
>> 
>> 
>> Pre-patch:
>> 
>> # ./dirty_log_test 
>> Test iterations: 32, interval: 10 (ms)
>> Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
>> guest physical test memory offset: 0x7fbffef000
>> Dirtied 139264 pages
>> Total bits checked: dirty (135251), clear (7991709), track_next (29789)
>> 
>> Post-patch:
>> 
>> # ./dirty_log_test 
>> Test iterations: 32, interval: 10 (ms)
>> Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
>> Supported guest physical address width: 48
>> guest physical test memory offset: 0xffffbffef000
>> ==== Test Assertion Failure ====
>>   dirty_log_test.c:141: false
>>   pid=77983 tid=77985 - Success
>>      1	0x0000000000401d12: vcpu_worker at dirty_log_test.c:138
>>      2	0x00007f636374358d: ?? ??:0
>>      3	0x00007f63636726a2: ?? ??:0
>>   Invalid guest sync status: exit_reason=SHUTDOWN
>
> Vitaly,
>
> Are you using shadow paging?  If so, could you try NPT=off?
>

Yep,

test passes with shadow paging, fails when NPT is enabled.


> I finally found a AMD host and I also found that it's passing with
> shadow MMU mode which is strange.  If so I would suspect it's a real
> bug in AMD NTP path but I'd like to see whether it's also happening on
> your side.

Sounds like a bug indeed.

-- 
Vitaly
