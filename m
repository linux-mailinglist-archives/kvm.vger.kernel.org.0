Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99B533466E
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 19:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhCJSQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 13:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbhCJSQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 13:16:09 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661EBC061761
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 10:16:09 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso5432269pjb.4
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 10:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hFGuoSs/aMUt+vuoT2J/eAJ6b5vWIpYR5D/n9ZHOWqc=;
        b=aNqu7VKy1TPjC3z/C75Zor9tecXd+bxXydROVEzPp1x66A0tlh89Rc/hakMzTZ7xGi
         W9QM1IsyQ3KcUoQktz6dSBl7MExGda2KHVRk6DGFqv0wP3iOPu4DUwnUxy0l+0fwCiaY
         CvfUg73/YcOhhYE4CxanRdJbVZe9ywxOlBSubR46nJfVS2aHbfEdgNZIOSr382nxM2qi
         R7VkIjKwiFP9L4PFJY5/FJq8ln5voZmsX9hY/c36f5fUt23IwRwty76Riz9df2BYrOmM
         AytY5zwrgdgWDpulLIHFVHVQIXLWer1CRk5pSgCb4G+s2EqPGqrY88/DLjvUg/D/OHdy
         S9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hFGuoSs/aMUt+vuoT2J/eAJ6b5vWIpYR5D/n9ZHOWqc=;
        b=NSUj23n7hfnyeZzruc3bSvu92Kspi4t43sdbGo600X5pyumdQKtOLnHZvQTbsmB4At
         qaT3onKC2LNE0sXvK0wM8lccAsEzfWcmfOWFBDvrt+Ol8trYAP+pJ5KrTeNBicoSKhjb
         QW/5knVclGgG3BTEIR7H80gAmuIczopdKrY1Uo8/eaz2W6DZU9hLAsKlV4WgOTf7Q7bW
         JvQ78GOzf8GtS/rsYWTN6HDN+816xjatGKDENYB3lKfAtgLsn9hXrjXGOSr2NB7NdQDc
         pH3JxVPvlwpG48ia9T46RL9kdV45SC01VDqIgmc2umJhWf7A+85riSc6xm9kEkSPVMbp
         vWxA==
X-Gm-Message-State: AOAM531DRxbu4jEcSn2bN+Sn4pjtYXvX2/PDV5ETfd5xRYgG6CORYk6+
        bnpr0fVU7E0yD0fVEQCrQa3gEA==
X-Google-Smtp-Source: ABdhPJy3NKbaRwumU2/U9+KQHmV8ce7wBDcCVlJqxs7ogrpgwj28bGTCsOi1FLFxIfBdj/JOLxI3Cg==
X-Received: by 2002:a17:902:ec84:b029:e5:bd05:4a98 with SMTP id x4-20020a170902ec84b02900e5bd054a98mr4158188plg.76.1615400168553;
        Wed, 10 Mar 2021 10:16:08 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
        by smtp.gmail.com with ESMTPSA id mp19sm7390612pjb.2.2021.03.10.10.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 10:16:07 -0800 (PST)
Date:   Wed, 10 Mar 2021 10:16:00 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] x86/perf: Use RET0 as default for guest_get_msrs to
 handle "no PMU" case
Message-ID: <YEkM4HWqjMdPoXvR@google.com>
References: <20210309171019.1125243-1-seanjc@google.com>
 <YEiA3hoCTMJbhKXO@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEiA3hoCTMJbhKXO@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021, Peter Zijlstra wrote:
> On Tue, Mar 09, 2021 at 09:10:19AM -0800, Sean Christopherson wrote:
> 
> > @@ -2024,9 +2021,6 @@ static int __init init_hw_perf_events(void)
> >  	if (!x86_pmu.read)
> >  		x86_pmu.read = _x86_pmu_read;
> >  
> > -	if (!x86_pmu.guest_get_msrs)
> > -		x86_pmu.guest_get_msrs = perf_guest_get_msrs_nop;
> 
> I suspect I might've been over eager here and we're now in trouble when
> *_pmu_init() clears x86_pmu.guest_get_msrs (like for instance on AMD).
> 
> When that happens we need to restore __static_call_return0, otherwise
> the following static_call_update() will patch in a NOP and RAX will be
> garbage again.
> 
> So I've taken the liberty to update the patch as below.

Doh, I managed to forget about that between v1 and v2, too.  Thanks much!
