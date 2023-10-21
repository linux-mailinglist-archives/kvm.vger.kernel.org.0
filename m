Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C597D19F1
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 02:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjJUAfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 20:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjJUAfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 20:35:08 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866E3D45
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:35:06 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9da175faaso10949925ad.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697848506; x=1698453306; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xC885SoeiNwR+AKqHcjryBCVRMgXondnUUnIzcJC0Gg=;
        b=m8O9JJ7/ZJ1GeI/PcTcTQvrBGw/CQn8nNfm+odbQk6KHqZwZ+RzJjEb0b6IYr33Ghz
         m5LyLg3hm5kis7ip3UMC1H/verOcYIGXvwKa9SkGt876Tw94EQjVsFEO9w8cY2pZms9v
         /3elZGS/yRUgf9pvZfCmJXNImEYXz//5GD5C00S5LzxeDc2x0lT0DyTX9oy9Nyr0bCu5
         FQ1Bd1msZL2kT4gAHMNaPuTh6zkWv5jBwZBZkvytNWNH2lZGmI74TES4fluNVlDEq8i9
         YzSVHBttregVy2s7u6ZiKvvzaDHnguNI/cZdmq49vKT1SiuIrEOG22oQKZICRm+oouEi
         MxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697848506; x=1698453306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xC885SoeiNwR+AKqHcjryBCVRMgXondnUUnIzcJC0Gg=;
        b=Wil5mz7Hp4QQmqzwDOZhRrXJFCKyEzVbMcOnW338YMNOfquVTzFZIXuOfV+FBWvR/g
         1E1QpXKCJ5dJheDqC1goixwsZXB2stbsj7wAYcvUVBaP/1Us4DIwQ47ck260yQahxFHA
         5t/PzJ5Y6ZvORPJxN2mq0k+ZhOWnCwgHwhhpWtQsutzmewbM6nBUJlSsMb9rGkJQYfya
         4crlj9zVB2m1On0ut5GvMvbJJxvRly5VJ/Jp31WYGq6YXkNjkK5o8LRCrTmwHoVkfRIH
         zafOV2qQH4UrXQefw06dN9ALQLHKlwzsJ8EoTKghtokLkEf/P1tWvNmAhdy0nzV/PN7d
         0LdQ==
X-Gm-Message-State: AOJu0YzaIqAZxts3Kh71G5fVyYx5kUiC25Ph8VN+2baIpfffwPtw62E+
        DtuRBWoMn/v5Ol+NqK0ZqeGZu54musE=
X-Google-Smtp-Source: AGHT+IGGrBEb9V2uMA12fHmcb+KC6UXoSTI3a6QAZEQm/IX1XUsrTT3KEyC+fsZRA3Fm8yd/LFWFpSjCOHs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d346:b0:1c6:d25:8730 with SMTP id
 l6-20020a170902d34600b001c60d258730mr83686plk.0.1697848505982; Fri, 20 Oct
 2023 17:35:05 -0700 (PDT)
Date:   Sat, 21 Oct 2023 00:35:04 +0000
In-Reply-To: <ZTMbfUhyOkmA9czp@google.com>
Mime-Version: 1.0
References: <20230914032334.75212-1-weijiang.yang@intel.com>
 <20230914032334.75212-3-weijiang.yang@intel.com> <ZTMbfUhyOkmA9czp@google.com>
Message-ID: <ZTMcuOutjGOnjVIY@google.com>
Subject: Re: [RFC PATCH 2/8] x86/fpu/xstate: Fix guest fpstate allocation size calculation
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
        pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, yang.zhong@intel.com, jing2.liu@intel.com,
        chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023, Sean Christopherson wrote:
> On Wed, Sep 13, 2023, Yang Weijiang wrote:
> > Fix guest xsave area allocation size from fpu_user_cfg.default_size to
> > fpu_kernel_cfg.default_size so that the xsave area size is consistent
> > with fpstate->size set in __fpstate_reset().
> > 
> > With the fix, guest fpstate size is sufficient for KVM supported guest
> > xfeatures.
> > 
> > Fixes: 69f6ed1d14c6 ("x86/fpu: Provide infrastructure for KVM FPU cleanup");
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kernel/fpu/core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> > index a86d37052a64..a42d8ad26ce6 100644
> > --- a/arch/x86/kernel/fpu/core.c
> > +++ b/arch/x86/kernel/fpu/core.c
> > @@ -220,7 +220,9 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
> >  	struct fpstate *fpstate;
> >  	unsigned int size;
> >  
> > -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
> > +	size = fpu_kernel_cfg.default_size +
> > +	       ALIGN(offsetof(struct fpstate, regs), 64);
> 
> This looks sketchy and incomplete.  I haven't looked at the gory details of
> fpu_user_cfg vs. fpu_kernel_cfg, but the rest of this function uses fpu_user_cfg,
> including a check on fpu_user_cfg.default_size.  That makes me think that changing
> just the allocation size isn't quite right.

Shoot, I didn't realize the CET virtualization series included this a day later.
I'll respond there.
