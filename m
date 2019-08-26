Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0209CD92
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 12:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbfHZKsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 06:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbfHZKsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 06:48:09 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC391C057F88
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 10:48:09 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id 191so11914900pfy.20
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 03:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0dLSzyN/rqUp1HY2dWLbKR3HKdVZWjjqhT8wBvMX/lY=;
        b=PCzvWVjvEKETcRt/5c2NuuC4An65/fMG61FxLLS4g7VoTsPFXzGpscNkAiWAOfYYRC
         E42Qf/ykOJ6sVAD/OP3VfmatO5KvUwNYWyZhZ7N0i8Erbe1hbh683+XqhaK1YQSgh6d9
         dtVZ8Mw0UoynUG/Lz3hSKHHdMJ2J1JWWwVER8IodojZe9YNyRMRANCDcGyXz6BNlgcF1
         o5HZxaJbzevadMd5C23BhB0yd5e8IaUAV/h8B99qpSX8425ENbQhIft1bsAhUhFgLXiw
         nZeekFE8tGWICpoo22DPQWn6AjdtyhwVmy17m55G3uUbkcoByh+0lioRe7gQs+SPSEZf
         xoOA==
X-Gm-Message-State: APjAAAUlp3xyAiA1P4T//Z4VHNYAeIGEF77qqWmNbbTy3McuN8WhIWYO
        v0MPK6/wuBGQm6M/jFFSKt2MdNbUmGC8NUBrMde7FEM3J5z8f82f8US3iYqzcKMfSp8xAj4iWIx
        JP0f6P2nCg2KF
X-Received: by 2002:a17:902:bb96:: with SMTP id m22mr6110812pls.158.1566816488019;
        Mon, 26 Aug 2019 03:48:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx9v5IQAhWjTcE8c7v1y0W7cdjmyinoF6TfA1qB+qM4O/NEWXL8MtQPYXNVLiYIXRqW1tJDXA==
X-Received: by 2002:a17:902:bb96:: with SMTP id m22mr6110798pls.158.1566816487856;
        Mon, 26 Aug 2019 03:48:07 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t189sm12062303pfd.58.2019.08.26.03.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 03:48:07 -0700 (PDT)
Date:   Mon, 26 Aug 2019 18:47:57 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Detect max PA width from cpuid
Message-ID: <20190826104757.GD1785@xz-x1>
References: <20190826075728.21646-1-peterx@redhat.com>
 <874l24nxik.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <874l24nxik.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 10:25:55AM +0200, Vitaly Kuznetsov wrote:
> Peter Xu <peterx@redhat.com> writes:
> 
> > The dirty_log_test is failing on some old machines like Xeon E3-1220
> > with tripple faults when writting to the tracked memory region:
> 
> s,writting,writing,
> 
> >
> >   Test iterations: 32, interval: 10 (ms)
> >   Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
> >   guest physical test memory offset: 0x7fbffef000
> >   ==== Test Assertion Failure ====
> >   dirty_log_test.c:138: false
> >   pid=6137 tid=6139 - Success
> >      1  0x0000000000401ca1: vcpu_worker at dirty_log_test.c:138
> >      2  0x00007f3dd9e392dd: ?? ??:0
> >      3  0x00007f3dd9b6a132: ?? ??:0
> >   Invalid guest sync status: exit_reason=SHUTDOWN
> >
> 
> This patch breaks on my AMD machine with
> 
> # cpuid -1 -l 0x80000008
> CPU:
>    Physical Address and Linear Address Size (0x80000008/eax):
>       maximum physical address bits         = 0x30 (48)
>       maximum linear (virtual) address bits = 0x30 (48)
>       maximum guest physical address bits   = 0x0 (0)
> 
> 
> Pre-patch:
> 
> # ./dirty_log_test 
> Test iterations: 32, interval: 10 (ms)
> Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
> guest physical test memory offset: 0x7fbffef000
> Dirtied 139264 pages
> Total bits checked: dirty (135251), clear (7991709), track_next (29789)
> 
> Post-patch:
> 
> # ./dirty_log_test 
> Test iterations: 32, interval: 10 (ms)
> Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
> Supported guest physical address width: 48
> guest physical test memory offset: 0xffffbffef000
> ==== Test Assertion Failure ====
>   dirty_log_test.c:141: false
>   pid=77983 tid=77985 - Success
>      1	0x0000000000401d12: vcpu_worker at dirty_log_test.c:138
>      2	0x00007f636374358d: ?? ??:0
>      3	0x00007f63636726a2: ?? ??:0
>   Invalid guest sync status: exit_reason=SHUTDOWN

Vitaly,

Are you using shadow paging?  If so, could you try NPT=off?

I finally found a AMD host and I also found that it's passing with
shadow MMU mode which is strange.  If so I would suspect it's a real
bug in AMD NTP path but I'd like to see whether it's also happening on
your side.

Thanks,

-- 
Peter Xu
