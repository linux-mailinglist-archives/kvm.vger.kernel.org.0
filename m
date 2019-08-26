Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842A19CE48
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 13:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbfHZLjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 07:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731160AbfHZLjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 07:39:19 -0400
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E151785540
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 11:39:18 +0000 (UTC)
Received: by mail-pg1-f198.google.com with SMTP id m17so9561882pgh.21
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 04:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xi5x79hFcxVshjNra8X/6yxiKOk5j429Zw+E71UlIRs=;
        b=GrWIQqN7XM6xOaumjhVRFhZtvtlUi0ehOsmcjFK0RR5eTfL90iMKVyp78pCphu8x9t
         P+1DvbkkTxkozbxMUdI6TXFd/2IBbjU02aDhc+dH5hGRzHn1qXvVup2rQ5k4UiTnPFu+
         0E6hkV6ryOa/gYyGXh7WRCs3FXMrw+D6fASNQMKxXA/miyBLaQQulS6vFq1VHTjnalXL
         x/LGo7f5a3hHMLGOFenLl2OP/jSpYjz0ZrdQUUEUUdGl55eHsXJLMi5ZQEHOqOHKs8Tb
         LDgMXU9rsz+iJ8tnM3FyRaqnl8P3QP6qFaE+4CLOjAZ4i4kDnSPMGLfqrYNgMzs6LgR0
         VHsA==
X-Gm-Message-State: APjAAAWbTI5mvzLgCJVF/cpq2KcsZ+zvjOvNrZd1cevQ1o8OT6MXfryL
        y23HMfcc7uFvKIQS3298GRRZPLRZgxnPXHE/AInnWWj/FVfNGE8OyQ9mKoqRluJrKn3shR6cZX3
        twVy2y0lmGdMw
X-Received: by 2002:a65:5003:: with SMTP id f3mr2180988pgo.335.1566819557537;
        Mon, 26 Aug 2019 04:39:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz8UUxwImp6F3psFCfM17KUyoCunFKDyrpd+862wZzI1oZZjpROWc+Oy4tLZiZXb9sjtb2Tzw==
X-Received: by 2002:a65:5003:: with SMTP id f3mr2180971pgo.335.1566819557254;
        Mon, 26 Aug 2019 04:39:17 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o4sm35214817pje.28.2019.08.26.04.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 04:39:16 -0700 (PDT)
Date:   Mon, 26 Aug 2019 19:39:06 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Detect max PA width from cpuid
Message-ID: <20190826113906.GF1785@xz-x1>
References: <20190826075728.21646-1-peterx@redhat.com>
 <874l24nxik.fsf@vitty.brq.redhat.com>
 <20190826104757.GD1785@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190826104757.GD1785@xz-x1>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 06:47:57PM +0800, Peter Xu wrote:
> On Mon, Aug 26, 2019 at 10:25:55AM +0200, Vitaly Kuznetsov wrote:
> > Peter Xu <peterx@redhat.com> writes:
> > 
> > > The dirty_log_test is failing on some old machines like Xeon E3-1220
> > > with tripple faults when writting to the tracked memory region:
> > 
> > s,writting,writing,
> > 
> > >
> > >   Test iterations: 32, interval: 10 (ms)
> > >   Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
> > >   guest physical test memory offset: 0x7fbffef000
> > >   ==== Test Assertion Failure ====
> > >   dirty_log_test.c:138: false
> > >   pid=6137 tid=6139 - Success
> > >      1  0x0000000000401ca1: vcpu_worker at dirty_log_test.c:138
> > >      2  0x00007f3dd9e392dd: ?? ??:0
> > >      3  0x00007f3dd9b6a132: ?? ??:0
> > >   Invalid guest sync status: exit_reason=SHUTDOWN
> > >
> > 
> > This patch breaks on my AMD machine with
> > 
> > # cpuid -1 -l 0x80000008
> > CPU:
> >    Physical Address and Linear Address Size (0x80000008/eax):
> >       maximum physical address bits         = 0x30 (48)
> >       maximum linear (virtual) address bits = 0x30 (48)
> >       maximum guest physical address bits   = 0x0 (0)
> > 
> > 
> > Pre-patch:
> > 
> > # ./dirty_log_test 
> > Test iterations: 32, interval: 10 (ms)
> > Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
> > guest physical test memory offset: 0x7fbffef000
> > Dirtied 139264 pages
> > Total bits checked: dirty (135251), clear (7991709), track_next (29789)
> > 
> > Post-patch:
> > 
> > # ./dirty_log_test 
> > Test iterations: 32, interval: 10 (ms)
> > Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
> > Supported guest physical address width: 48
> > guest physical test memory offset: 0xffffbffef000
> > ==== Test Assertion Failure ====
> >   dirty_log_test.c:141: false
> >   pid=77983 tid=77985 - Success
> >      1	0x0000000000401d12: vcpu_worker at dirty_log_test.c:138
> >      2	0x00007f636374358d: ?? ??:0
> >      3	0x00007f63636726a2: ?? ??:0
> >   Invalid guest sync status: exit_reason=SHUTDOWN
> 
> Vitaly,
> 
> Are you using shadow paging?  If so, could you try NPT=off?

Sorry, it should be s/shadow paging/NPT/...

[root@hp-dl385g10-10 peter]# ./dirty_log_test 
Test iterations: 32, interval: 10 (ms)
Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
Supported guest physical address width: 48
guest physical test memory offset: 0xffffbffef000
==== Test Assertion Failure ====
  dirty_log_test.c:138: false
  pid=5433 tid=5436 - Success
     1  0x0000000000401cc1: vcpu_worker at dirty_log_test.c:138
     2  0x00007f18977992dd: ?? ??:0
     3  0x00007f18974ca132: ?? ??:0
  Invalid guest sync status: exit_reason=SHUTDOWN

[root@hp-dl385g10-10 peter]# modprobe -r kvm_amd
[root@hp-dl385g10-10 peter]# modprobe kvm_amd npt=0
[root@hp-dl385g10-10 peter]# ./dirty_log_test 
Test iterations: 32, interval: 10 (ms)
Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
Supported guest physical address width: 48
guest physical test memory offset: 0xffffbffef000
Dirtied 102400 pages
Total bits checked: dirty (99021), clear (8027939), track_next (23425)

> 
> I finally found a AMD host and I also found that it's passing with
> shadow MMU mode which is strange.  If so I would suspect it's a real
> bug in AMD NTP path but I'd like to see whether it's also happening on
> your side.
> 
> Thanks,

-- 
Peter Xu
