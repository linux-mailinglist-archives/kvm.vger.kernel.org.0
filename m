Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD811401C
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 12:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbfLEL31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 06:29:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729260AbfLEL31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 06:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575545365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lbaSGfutZwhZA116gvr95IAUlIVoaJxPvvW+eFCW8zI=;
        b=IzY4lWJ02IVaJJJGslndTf8BDY46nd7Yux36O755xN8sRn5RPtHbLIOS/Pi3dXGLpeBN5s
        sH+frMP5Ldc39L3WgjKVWhvD6Id3IrhErLPzJ6ECww7ujcZmsV1KTeBAWvCpBkRhFOA5HJ
        2bcRa9KEPa1qQSzatlezDGJZWqcVr5s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-hpcJYH5PPdeF0_jJC2E-wg-1; Thu, 05 Dec 2019 06:29:24 -0500
Received: by mail-wm1-f72.google.com with SMTP id n4so751902wmd.7
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 03:29:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lbaSGfutZwhZA116gvr95IAUlIVoaJxPvvW+eFCW8zI=;
        b=pMBnS+50vdAJVlgTPGXLjGIqlgQSqRRMYiOCGfl01MokdhBuOnObd+rV6JN8BAw4rf
         SLp/0QwmVhryt/6Bsycbjzg11ZH3Rl4xSC97hVXtzJhmh+tl02q7xl9Q21SMLdGhoeVy
         y7QgAmbNuby1vs9sgkVG6bd75l7PR8DmWwc8TW9f6hKZHbf/jgz8gTRHEsfe8GzOZSP5
         wdw0cuWEF/uwC1op3D906KZq68xSh28riwI2IjMNkK6Z9ic0KduENrU4thXjOtVfXInR
         dAcNMkZQ1DS8Nkl15cmLfLsKwfQ2Eyv0PISISvEnaLyKXbRhaRo0LzOC6v9MvsL5bMDU
         Vz4w==
X-Gm-Message-State: APjAAAW/2Ti/qPj4/Mffvz78Wfa069bbLR5JjHz2MqF7T08pdcpW1tbq
        IdYSCTXfCu5JPA11WnWiiW71Ik4mlZx7R3JWRZScTw4TZCY6swzUa6iKxYoW9zsmGIEL9Dk6Ywv
        GdwJ30p6Oe06w
X-Received: by 2002:a1c:1dc4:: with SMTP id d187mr4900396wmd.46.1575545363049;
        Thu, 05 Dec 2019 03:29:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqx9Xt8ZW3hE0/KfrEcZYT8qrPPraxHN0nr72IWYS5MoUhQN15mYYzXu7Q6Ai0EaHlN2GKcQ5w==
X-Received: by 2002:a1c:1dc4:: with SMTP id d187mr4900356wmd.46.1575545362806;
        Thu, 05 Dec 2019 03:29:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:541f:a977:4b60:6802? ([2001:b07:6468:f312:541f:a977:4b60:6802])
        by smtp.gmail.com with ESMTPSA id e18sm11632611wrr.95.2019.12.05.03.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 03:29:22 -0800 (PST)
Subject: Re: KASAN: slab-out-of-bounds Read in fbcon_get_font
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+4455ca3b3291de891abc@syzkaller.appspotmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI <dri-devel@lists.freedesktop.org>, ghalat@redhat.com,
        Gleb Natapov <gleb@kernel.org>, gwshan@linux.vnet.ibm.com,
        "H. Peter Anvin" <hpa@zytor.com>, James Morris <jmorris@namei.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        KVM list <kvm@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Russell Currey <ruscur@russell.cc>,
        Sam Ravnborg <sam@ravnborg.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, stewart@linux.vnet.ibm.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
References: <0000000000003e640e0598e7abc3@google.com>
 <41c082f5-5d22-d398-3bdd-3f4bf69d7ea3@redhat.com>
 <CACT4Y+bCHOCLYF+TW062n8+tqfK9vizaRvyjUXNPdneciq0Ahg@mail.gmail.com>
 <f4db22f2-53a3-68ed-0f85-9f4541530f5d@redhat.com>
 <CACT4Y+ZHCmTu4tdfP+iCswU3r6+_NBM9M-pAZEypVSZ9DEq3TQ@mail.gmail.com>
 <e03140c6-8ff5-9abb-1af6-17a5f68d1829@redhat.com>
 <CACT4Y+YopHoCFDRHCE6brnWfHb5YUsTJS1Mc+58GgO8CDEcgHQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bf93410c-7e59-a679-c00d-5333a9879128@redhat.com>
Date:   Thu, 5 Dec 2019 12:29:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CACT4Y+YopHoCFDRHCE6brnWfHb5YUsTJS1Mc+58GgO8CDEcgHQ@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: hpcJYH5PPdeF0_jJC2E-wg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/19 12:27, Dmitry Vyukov wrote:
> Oh, you mean the final bisection crash. Indeed it contains a kvm frame
> and it turns out to be a bug in syzkaller code that indeed
> misattributed it to kvm instead of netfilter.
> Should be fixed now, you may read the commit message for details:
> https://github.com/google/syzkaller/commit/4fb74474cf0af2126be3a8989d770c3947ae9478
> 
> Overall this "making sense out of kernel output" task is the ultimate
> insanity, you may skim through this file to get a taste of amount of
> hardcoding and special corner cases that need to be handled:
> https://github.com/google/syzkaller/blob/master/pkg/report/linux.go
> And this is never done, such "exception from exception corner case"
> things pop up every week. There is always something to shuffle and
> tune. It only keeps functioning due to 500+ test cases for all
> possible insane kernel outputs:
> https://github.com/google/syzkaller/tree/master/pkg/report/testdata/linux/report
> https://github.com/google/syzkaller/tree/master/pkg/report/testdata/linux/guilty
> 
> So thanks for persisting and questioning! We are getting better with
> each new test.

Thanks to you!  I "complain" because I know you're so responsive. :)

Paolo

