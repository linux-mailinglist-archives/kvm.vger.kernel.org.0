Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C69C65920E
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 22:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbiL2VP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 16:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbiL2VPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 16:15:51 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67046167
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 13:15:49 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id b12so13082171pgj.6
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 13:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2exndYn8ViQnRuRb/vQYpk0y1+W47ptf9X30oZyzwJQ=;
        b=NmLVWwMDclIYbgxF/2FNy14GbEYvcXrqSVMhKJ16cM0I+HAjCPp9U2zIb4vxwOVtLS
         Nb0EQidgaW/HJ4a2t1boQfRr0vRdweoq5TPQhnU9yZA7uFMUHS3N5fm2qyvrhldTjA9J
         H1fe5LNgB741eKmcEpY65yfRPpY4mm5flK9RHXF1C+PZjaQX4ihKdhOz7Wn6e+2E3spj
         4i4X+HvtqLv0g+YVajyZJxIEjkEN8mnNynYqnhQ/5N5evN9w1Z9PQLszWeayWF2YotFn
         7gs3q4wAf02OzslqAu8KhgMzgR1M0tQIQUkyAx3UW6HofrBar+XnG+sAWSNg3C35G8fZ
         j5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2exndYn8ViQnRuRb/vQYpk0y1+W47ptf9X30oZyzwJQ=;
        b=fjuAK36XnHn9qC5xY8oXB8YCMStLfvy71qHWNxAcAwY3qSVHzoLItRVclP3m/8TW7y
         ULHYP3j0Pe2w/SuMtoQQOA4MyAIh6CQUrBVXchqbDZPJJeQtFZ/sF5YqTJJ41wt0rp6O
         EiXMBy7h16AQ2sBH3Ih6S4z45eFNKtEuf2tuYVVcS6ztfo9DyCr2OjOCjwwL9KbWeskY
         Lzi5Y1E0Yafu+K4zLS2WcV7PzBQezOdJJdjNQESgyYv9FQWdKu8K8vdU+XzORWgPvJPD
         3goTo9pnIhzrcvAn4a2dHNow1O1xflnoWGfyI0suz75lznkKbiR9oTjda8TAtCHtw1+z
         jtsw==
X-Gm-Message-State: AFqh2krbl6gExYK36p3kM4BA8G5TuX7tHx4UdMS1pU6zVCrqtDtoHGO+
        30Cm6w87/GcHCflxqKQkLyVukg==
X-Google-Smtp-Source: AMrXdXsBNtOBFVlLhlUgKy4V0Jj1uTsNu/gFOMh9lLGOfUK8mdK39jHoW6tTHWSj4tcE8WUTK+lFdQ==
X-Received: by 2002:a05:6a00:1485:b0:575:b783:b6b3 with SMTP id v5-20020a056a00148500b00575b783b6b3mr42576266pfu.28.1672348549094;
        Thu, 29 Dec 2022 13:15:49 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id h1-20020a056a00000100b0058124f92399sm7517540pfk.219.2022.12.29.13.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 13:15:48 -0800 (PST)
Date:   Thu, 29 Dec 2022 13:15:44 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Ben Gardon <bgardon@google.com>, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 1/9] KVM: x86/mmu: Repurpose KVM MMU shrinker to purge
 shadow page caches
Message-ID: <Y64DgHuPd8oTPSm5@google.com>
References: <20221222023457.1764-1-vipinsh@google.com>
 <20221222023457.1764-2-vipinsh@google.com>
 <CANgfPd9fr0KfRRg9LMD=3DTLJ9CKGLe0HaY512BeK16sgFX4kQ@mail.gmail.com>
 <CAHVum0efHuRmER-whXnwHYMsBLBcb-mgDu+uogCJbMhz2e0_MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0efHuRmER-whXnwHYMsBLBcb-mgDu+uogCJbMhz2e0_MA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 28, 2022 at 02:07:49PM -0800, Vipin Sharma wrote:
> On Tue, Dec 27, 2022 at 10:37 AM Ben Gardon <bgardon@google.com> wrote:
> > On Wed, Dec 21, 2022 at 6:35 PM Vipin Sharma <vipinsh@google.com> wrote:
> > >
> > > Tested this change by running dirty_log_perf_test while dropping cache
> > > via "echo 2 > /proc/sys/vm/drop_caches" at 1 second interval
> > > continuously. There were WARN_ON(!mc->nobjs) messages printed in kernel
> > > logs from kvm_mmu_memory_cache_alloc(), which is expected.
> >
> > Oh, that's not a good thing. I don't think we want to be hitting those
> > warnings. For one, kernel warnings should not be expected behavior,
> > probably for many reasons, but at least because Syzbot will find it.
> > In this particular case, we don't want to hit that because in that
> > case we'll try to do a GFP_ATOMIC, which can fail, and if it fails,
> > we'll BUG:
> >
> > void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> > {
> >         void *p;
> >
> >         if (WARN_ON(!mc->nobjs))
> >                 p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> >         else
> >                 p = mc->objects[--mc->nobjs];
> >         BUG_ON(!p);
> >         return p;
> > }
> >
> > Perhaps the risk of actually panicking is small, but it probably
> > indicates that we need better error handling around failed allocations
> > from the cache.
> > Or, the slightly less elegant approach might be to just hold the cache
> > lock around the cache topup and use of pages from the cache, but
> > adding better error handling would probably be cleaner.
> 
> I was counting on the fact that shrinker will ideally run only in
> extreme cases, i.e. host is running on low memory. So, this WARN_ON
> will only be rarely used. I was not aware of Syzbot, it seems like it
> will be a concern if it does this kind of testing.

In an extreme low-memory situation, forcing vCPUS to do GFP_ATOMIC
allocations to handle page faults is risky. Plus it's a waste of time to
free that memory since it's just going to get immediately reallocated.

> 
> I thought about keeping a mutex, taking it during topup and releasing
> it after the whole operation is done but I stopped it as the duration
> of holding mutex will be long and might block the memory shrinker
> longer. I am not sure though, if this is a valid concern.

Use mutex_trylock() to skip any vCPUs that are currently handling page
faults.
