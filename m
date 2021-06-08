Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E646539EAFC
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhFHAvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:51:00 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:35655 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhFHAvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:51:00 -0400
Received: by mail-pf1-f172.google.com with SMTP id h12so11564114pfe.2
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 17:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=agGQB3i2wfCKPG1s7G2zOWZ6mUf8+TRhatsi66V+CBQ=;
        b=cXrHC+ShZrUlsuFPBylWLaI7HBuW6R8pOvn801TqKqpqtxAMgmjGCNylYbLODlXmQ4
         RwjLjk8qd8pOUX9NLXwTjfliWitEWcFc7Jj+JoUlHQqinMqVR7CgCtj6wljr9MlV/GGZ
         UIyX/2wHrPjNjmArcdL2QfZHRDGN3c7WWUSro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=agGQB3i2wfCKPG1s7G2zOWZ6mUf8+TRhatsi66V+CBQ=;
        b=sklvPPcOEtJYFdtateemw0VE6I7PThvun8pVjjyd99gwXta8b6mQwhyMLs10e6yAEF
         eWvQd0S7dSKMGRLjF386luLEfa57bbFNrme4GbppDuE9SVs6/iToR6cm1VQ9BVHmR9El
         rSwO+RQpCezQVAtAWDj/EZX0Tl/GDUDEoG81Pdjn0kVMpa/GeR1vwEt5xhWQo2njOxix
         OsZievhug0REzJ3ChXqgr2zW0kbXeeMXdR5OKHsGCzYodaqLJYMSVogMJa9YGo4rni4V
         swT+r8GSPF09pK50PJxYvrVm9pIp03qqY3fUAC/QhJ+jxoVZymqxWDAquAjol31cM264
         Pnrw==
X-Gm-Message-State: AOAM53149zu+eH1hpF645l3zY3VZCpHobmwescG9rnBEpJh+sKeERBqh
        uV4ejMd37kllRAKVh4WtXW0wBg==
X-Google-Smtp-Source: ABdhPJxmnqSrGpkO+1QtQfQcoGw7CTIUItcrqFBOC1yqrkZp0lVPxjzhWdIbY6e1faqu1jT4TucbkQ==
X-Received: by 2002:a63:1d42:: with SMTP id d2mr20037516pgm.21.1623113276817;
        Mon, 07 Jun 2021 17:47:56 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:1193:5ba8:74e4:8b6e])
        by smtp.gmail.com with ESMTPSA id v22sm9056416pff.105.2021.06.07.17.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 17:47:56 -0700 (PDT)
Date:   Tue, 8 Jun 2021 09:47:51 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/2] kvm: x86: implement KVM PM-notifier
Message-ID: <YL6+NysuqhORZEs1@google.com>
References: <20210606021045.14159-1-senozhatsky@chromium.org>
 <20210606021045.14159-2-senozhatsky@chromium.org>
 <fe13fe734a01bb54f47fea06624c617beb062fdd.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe13fe734a01bb54f47fea06624c617beb062fdd.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/06/07 15:54), Maxim Levitsky wrote:
[..]
> Also I would like to add my .02 cents on my observations on what happens when I suspend my system
> with guests running, which I do once in a while.
> I haven't dug deep into it yet as host suspend with VM running wasn't high on my priority list.
>  
> First of all after a host suspend/resume cycle (and that is true on all 3 machines I own),
> the host TSC is reset to 0 on all CPUs, thus while it is still synchronized, it jumps backward.
>  
> Host kernel has no issues coping with this.
>  
> Guests however complain about clocksource watchdog and mark the tsc clocksource as unstable,
> at least when invtsc is used (regardless of this patch, I wasn't able to notice a difference
> with and without it yet).
>  
>  
> [  287.515864] clocksource: timekeeping watchdog on CPU0: Marking clocksource 'tsc' as unstable because the skew is too large:
> [  287.516926] clocksource:                       'kvm-clock' wd_now: 4437767926 wd_last: 429c3c42f5 mask: ffffffffffffffff
> [  287.527100] clocksource:                       'tsc' cs_now: c33f6ce157 cs_last: c1be2ad19f mask: ffffffffffffffff
> [  287.528493] tsc: Marking TSC unstable due to clocksource watchdog
> [  287.556640] clocksource: Switched to clocksource kvm-clock
>  
>  
> This is from Intel system with stable TSC, but I have seen this on my AMD systems as well,
> but these have other issues which might affect this (see below).
>  
> AFAIK, we have code in kvm_arch_hardware_enable for this exact case but it might not work
> correctly or be not enough to deal with this.
>  
> Also I notice that this code sets kvm->arch.backwards_tsc_observed = true which 
> in turn disables the master clock which is not good as well.
>  
> I haven't yet allocated time to investigate this.
>  
>  
> Another bit of information which I didn't start a discussion (but I think I should), 
> which is relevant to AMD systems, is in 'unsynchronized_tsc' function.
> 
> On AMD guest it will mark the TSC as unstable in the guest as long as invtsc is not used.
> I patched that code out for myself, that is why I am mentioning it.

If you are going to fork this discussion the could you please Cc Suleiman
and me? I believe we are having a bunch of problems with the guest clocks
here on our side.
