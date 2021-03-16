Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1677033DAEC
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhCPR1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhCPR0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:26:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60BFC06174A
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 10:26:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d23so14066228plq.2
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 10:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j2TcsItQe9mXM2OmXCX8WBXwODoYV6ptAcT0XjuWaxM=;
        b=BlLOKdjSYi530fvJUVRZor11SX8QYxGIJTizXqSLZqbaiDPNo/hd93yLlWm54Ieck5
         pbhiVeyo3X2+CmWY0rtJ77+WatqV/iiFURp6biPWmZAEuey8ore8I9zeQReMjVwV4w/N
         +Wq3MhOa8aIiiB6HksiIJlcHOLDcW3gqWVLP0eQPsVxXfgHA1Xsq4QfnrSFabMz5/N4K
         JtesF5lr6As5uETTk+4V5L7NNZjbqGtPhnIGmLIvStzTWzL5RwWyjAYW/4kus8GOG+85
         1G6r3r3m5aI5lZ4vod10ujaWdM1LHQaSEJUt7JQeEYyQhfVt2g0BsG7i0JWGZQ20mfkV
         cktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j2TcsItQe9mXM2OmXCX8WBXwODoYV6ptAcT0XjuWaxM=;
        b=AImn8u6VRUJWPKFPEy9fFYscy8M9kjGKYHIVmf/SmpQwLIC8Dejw6jG5SJWlGLetZ2
         D6vby8tEQMo5Ikh+0tLAti+QsgzgIwe9RLoUaYoXkhJVqw4ItycqkUeDp7fAL2D7eeub
         fvAdMZun0oRjmxOo+qbjNpx3hxyjubj8EjipO4C7ephYwZWEWZHRpGyzPb9wEPx3AT9H
         dwj1zBQf3QOMyN2C00fH7XZ0YmOwpij8EsS8pxOt5/9/6fIvY6XrK2tyjSmDDXGvgGT4
         iWlKT2NYh/1Amgf7VrrIjfHftMVIV9R4pr9HgJ/ZThYM32bPIRHK4qbzHCKdKQPzCGX4
         ZaAQ==
X-Gm-Message-State: AOAM531xaukVC9P4H8cmyyeKd1hCk4jWKgA22ZsBQ7tTRoEe/UnjX/YO
        XsYk4ZU4EXxH54lUSX4jfQ38jCiziKpCIA==
X-Google-Smtp-Source: ABdhPJxNZcjAFFJsfZ7IAiaY+ADgAHYgbHJvlqfBYXAVaBV7g/B2afo1aLMwBdBB9KW8U/DxDiyCQg==
X-Received: by 2002:a17:902:edc2:b029:e4:3738:9b23 with SMTP id q2-20020a170902edc2b02900e437389b23mr554373plk.37.1615915602144;
        Tue, 16 Mar 2021 10:26:42 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
        by smtp.gmail.com with ESMTPSA id g26sm17464964pge.67.2021.03.16.10.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:26:41 -0700 (PDT)
Date:   Tue, 16 Mar 2021 10:26:34 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: guest debug: don't inject interrupts while
 single stepping
Message-ID: <YFDqSisnoWD5wVdP@google.com>
References: <1259724f-1bdb-6229-2772-3192f6d17a4a@siemens.com>
 <bede3450413a7c5e7e55b19a47c8f079edaa55a2.camel@redhat.com>
 <ca41fe98-0e5d-3b4c-8ed8-bdd7cd5bc60f@siemens.com>
 <71ae8b75c30fd0f87e760216ad310ddf72d31c7b.camel@redhat.com>
 <2a44c302-744e-2794-59f6-c921b895726d@siemens.com>
 <1d27b215a488f8b8fc175e97c5ab973cc811922d.camel@redhat.com>
 <727e5ef1-f771-1301-88d6-d76f05540b01@siemens.com>
 <e2cd978e357155dbab21a523bb8981973bd10da7.camel@redhat.com>
 <CAMS+r+XFLsFRFLGLaAH3_EnBcxOmyN-XiZqcmKEx2utjNErYsQ@mail.gmail.com>
 <31c0bba9-0399-1f15-a59b-a8f035e366e8@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31c0bba9-0399-1f15-a59b-a8f035e366e8@siemens.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021, Jan Kiszka wrote:
> On 16.03.21 17:50, Sean Christopherson wrote:
> > Rather than block all events in KVM, what about having QEMU "pause" the timer?
> > E.g. save MSR_TSC_DEADLINE and APIC_TMICT (or inspect the guest to find out
> > which flavor it's using), clear them to zero, then restore both when
> > single-stepping is disabled.  I think that will work?
> > 
> 
> No one can stop the clock, and timers are only one source of interrupts.
> Plus they do not all come from QEMU, some also from KVM or in-kernel
> sources directly.

But are any other sources of interrupts a chronic problem?  I 100% agree that
this would not be a robust solution, but neither is blocking events in KVM.  At
least with this approach, the blast radius is somewhat contained.

> Would quickly become a mess.

Maybe, but it'd be Qemu's mess ;-)
