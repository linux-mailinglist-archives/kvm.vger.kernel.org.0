Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116EE332CCA
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 18:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCIRFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 12:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhCIRFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 12:05:08 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2654C06174A
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 09:05:08 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id n17so3342410plc.7
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 09:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tQCrZGAl0b60/4Ggr0xLToEhk1KYEANewuulT6STebg=;
        b=B8PvmorMpqrWVpxlNrzzWceE/e3T4Q2YCqZ8sVuCFzH46o80eZ81cDA5moe5lAaNzp
         P918sQFhr+LkMw3+2ZHLxO5f084u1jcdJUg3VTMSsWxcn//w8zMEvR/7AIZoGA62exnO
         hvcJ3ahs5+mNk+p2SAUSMgcloq84rVlaGSQRNJF52IkKc+0hfiLSV/Yv/qHM2/URlV3C
         pJutN/rEKfAjfNFxZcgtFTvJ3YJ+vos6W1OGWu8tbRyj7Wgi4Zuvu91Sv4g2lLs3i0it
         LGFuvqx+uINrsfGh6egqCmVeoI+UQEzxgbxwA5IhYqENUko/OT0fMcGQBHAA4AemfDDY
         OycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tQCrZGAl0b60/4Ggr0xLToEhk1KYEANewuulT6STebg=;
        b=puUfICeUbWaJ9BvuQCHfm8TQZ4gd+sikGUigQan7nlmiJu9ZedoFytK6uIL9MerpG8
         WJJJ9YjJOGSGKdT1G092UBRqgFnv1w1tTrXDGZlwywebwco2HB4T8z1LDk9NNnBy/G3N
         O5jy6gyFiqLFVQkLdUdziy92o3WYFn+IApebktgvt4bUZNtls3Yg6yMTlNuVESB4zTGB
         epKy9wpVOAocQj5hYrICLGvIdV11GMlPNk0+vc5L1p36BPNPMv9RfOj+xVmmRBHXg4sf
         +RrSJqlpieRRHnTgHR4a94l3dkae3xRpCOGBUYm3KztGXN1vVQAHErX1JtyBnuYaoyvD
         fSYg==
X-Gm-Message-State: AOAM533kawbfIUfqTgpHswsjo63ccz/sWI+YtDpyaHR1+bfLxuyFnbcd
        xl0+/+wugA1Z3tfXxBB4C7H8pQ==
X-Google-Smtp-Source: ABdhPJwW0J3xWZ6EcBpG5tri8DTiYIZJan3TWKiHbWHKoPqfXeewUF1+YEDKwm9IrNm/jBQ7uQYpmA==
X-Received: by 2002:a17:90a:f190:: with SMTP id bv16mr5526843pjb.187.1615309507956;
        Tue, 09 Mar 2021 09:05:07 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id v16sm13253080pfu.76.2021.03.09.09.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 09:05:06 -0800 (PST)
Date:   Tue, 9 Mar 2021 09:05:00 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Xu, Like" <like.xu@intel.com>, Dmitry Vyukov <dvyukov@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        "Thomas Gleixner
        (x86/pti/timer/core/smp/irq/perf/efi/locking/ras/objtool)
        (x86@kernel.org)" <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86/perf: Fix guest_get_msrs static call if there is no
 PMU
Message-ID: <YEeqvC4QmJcj+pkC@google.com>
References: <20210305223331.4173565-1-seanjc@google.com>
 <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
 <YEXmILSHDNDuMk/N@hirez.programming.kicks-ass.net>
 <YEaLzKWd0wAmdqvs@google.com>
 <YEcn6bGYxdgrp0Ik@hirez.programming.kicks-ass.net>
 <YEc1mFkaILfF37At@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEc1mFkaILfF37At@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021, Peter Zijlstra wrote:
> On Tue, Mar 09, 2021 at 08:46:49AM +0100, Peter Zijlstra wrote:
> > On Mon, Mar 08, 2021 at 12:40:44PM -0800, Sean Christopherson wrote:
> > > On Mon, Mar 08, 2021, Peter Zijlstra wrote:
> > 
> > > > Given the one user in atomic_switch_perf_msrs() that should work because
> > > > it doesn't seem to care about nr_msrs when !msrs.
> > > 
> > > Uh, that commit quite cleary says:
> > 
> > D0h! I got static_call_cond() and __static_call_return0 mixed up.
> > Anyway, let me see if I can make something work here.
> 
> Does this work? I can never seem to start a VM, and if I do accidentally
> manage, then it never contains the things I need :/

Yep, once I found the dependencies in tip/sched/core (thank tip-bot!).  I'll
send v2 your way.
