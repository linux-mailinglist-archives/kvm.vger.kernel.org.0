Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D668473B4F
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 04:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhLNDMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 22:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhLNDMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 22:12:38 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C025C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 19:12:38 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id z6so16666819pfe.7
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 19:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DaUpjQsRXzDlNok3onB0tnTkJffX5UHYJGcB3WC+79I=;
        b=n/GrE6WqmC75O6tMABEgMi0icLtjq1J/sVwOqg0xtjO22NaCgBcN5l4O1X30LDcOWL
         tgRIRyjgwcjGqMWJ4+fhXiupYbO79FF6zhbtlLLEalFGUFe1SXdKengeNBji3XDUJD+q
         3K465B4EC5w7R2ro5iynpzXLn6VdQHus524cczmRzZm5UW67WsVQ+HOMLcntdn9f90P7
         gAJoy+vA2Vp3bZFfPmBO5TOWgYuCU1Fh6fmqSH81uPBw9fLeveOG14khDDCRIHZcRZ+R
         9Y2DnSnd/PkioGxmHLt/8RJuRZg/tomtoZP0YaW277jW7ZK5DbEKbO+672gEP61Mmd91
         1xoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DaUpjQsRXzDlNok3onB0tnTkJffX5UHYJGcB3WC+79I=;
        b=J6x9WU8TNVYtfySF/48xtajrM735f8lDtGpx4rL/ctvbeVF6g8Wl3uqNVbNPxVz+mA
         V7GRb8/kt+BWOjVdpWT/pm2n0+yy8gOn11M4m3WlnZt7BrEc8SWXgsDSqCh/Uee6vsKo
         a5j+r3/mdy/+TWuEO5FkXjAZtnNWg9A7iKveRK0j6IlRDstyPXGaDa9roXAy6KCp4LNc
         MbkJninZ72TxuA3RR1hy4vBPNhJrLRmO78KnjTt7Lz9OL6Owpx6dnaPkzGPBGKp1Kpdq
         BmyLt1z2GNIIO0OsdnbP+R7iI8KK2O74CCr3WjrcXeKXoTwOFz2ZIGNHpaHd4XWQbgat
         1d/w==
X-Gm-Message-State: AOAM532U4BmT6EMo3TOKRYmyrNDjMNQfK8NXIcJCn5RpReMUMa/e5rG0
        krpfUVw8lf/8YzSGgK7va5ui4w==
X-Google-Smtp-Source: ABdhPJxHgZ7+unda1WxLgv6UMe8FB2suboBfBniZ7oOLB/b+GY1BhQC1gNcfoKtYxYoLRDxeG1OxkQ==
X-Received: by 2002:a05:6a00:1c56:b0:4a4:f8cb:2604 with SMTP id s22-20020a056a001c5600b004a4f8cb2604mr1910174pfw.34.1639451557474;
        Mon, 13 Dec 2021 19:12:37 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u22sm14990479pfk.148.2021.12.13.19.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 19:12:36 -0800 (PST)
Date:   Tue, 14 Dec 2021 03:12:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        bgardon@google.com, dmatlack@google.com, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix dangling page reference in TDP MMU
Message-ID: <YbgLoZjy1zuhIgK7@google.com>
References: <20211213112514.78552-1-pbonzini@redhat.com>
 <CALrw=nEM6LEAD8LA1Bd15=8BK=TFwwwAMKy_DWRrDkD=r+1Tqg@mail.gmail.com>
 <Ybd5JJ/IZvcW/b2Y@google.com>
 <YbeiiT9b350lYBiR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbeiiT9b350lYBiR@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Sean Christopherson wrote:
> > On Mon, Dec 13, 2021, Ignat Korchagin wrote:
> > > Unfortunately, this patchset does not fix the original issue reported in [1].
> > 
> > Can you provide your kernel config?  And any other version/config info that might
> > be relevant, e.g. anything in gvisor or runsc?
> 
> Scratch that, I've reproduced this, with luck I'll have a root cause by end of day.

Ok, the root cause is comically simple compared to all the theories we came up with.
If tdp_mmu_iter_cond_resched() drops mmu_lock and restarts the iterator, the
"continue" in the caller triggers tdp_iter_next().  tdp_iter_next() does what it's
told and advances the iterator.  Because all users call tdp_mmu_iter_cond_resched()
at the very beginning of the loop, this has the effect of skipping the current SPTE.

E.g. in the "zap all" case, where iter->level == iter->min_level == iter->root_level,
we effectively end up with code like this, which is obviously wrong once the
complexity of traversing a tree is simplified down to walking an array of SPTEs.

	gfn_t end = tdp_mmu_max_gfn_host();
        gfn_t start = 0;
        gfn_t last;

        for (i = last = start; i < end; i += 8, last = i) {
                if (cond_resched()) {
                        i = last;
                        continue;
                }

                sp = &root->spt[i];
                zap(sp);
        }

Patch incoming...
