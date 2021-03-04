Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815F232CC7D
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 07:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbhCDGNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 01:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbhCDGNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 01:13:19 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21BAC06175F
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 22:12:38 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id u12so6131776pjr.2
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 22:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wrRdPDPB3VCRpfnlU4rkj1XLWJk4+xODxpIbuwpHG+Y=;
        b=Mym+BpeRKl4ppls7nPY+P84Wq2Ud/GZk6tA0DczxIwInISgM7CE1f2mF7YJfODiqK4
         XH3AcCKqc8EP1qDxSnxZfc3OaZgrLZjYhMxoQGdzAX9eRqIwn5TrLUe3aVvj1+95nlc4
         t+mWhOGTQervTzGSIfWDK0WpFFPiX1V/GhAgaMZQciXUpe3mRBZ2L2WcSt9gj0fbV+Nn
         ADWTRRnbMc4R+ee4X2l6udt04Tmxxf/PoypVtrzbHnC99T6/ZF3jFsQeGHxoRLFcd6su
         kjOdjT8wTHO84LDxBLDEo2trTu7feZ3mQESF3hDu+dWyyHlkU3nAlu8jZB26xsWoMJwP
         Iv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wrRdPDPB3VCRpfnlU4rkj1XLWJk4+xODxpIbuwpHG+Y=;
        b=pukbbS5+iAskI30vJav1zlPmkNGn9yA5zPV1MGd3qOO5EXGLjXPevwmt8/WwhcZcdU
         E/n46F7kJOcQrhBkHB9i5PT6A0ByvCPfQc+8NZLtD8XWSt+DdwgpQ2/EJSYfONOiIV6n
         yHr4ZcZ5mnEXPiOSC1hrBpEaX/IWx53GKpyrLLVhjDDBQRis5tNfptkuMV6zJ+/tUZOp
         emRAlexkddtt1Zqac+OSUX0WVEQgF2qisJkyGZuwqtmUiYFe6Xxcq2Y9jtIk4MJglYn7
         KuzMKYkcrkaifUwEUKtpWxUc1zklcCrG97V+hkg8WVlBg8TOQ5BfSwKZVa36xxqWTwFH
         lECw==
X-Gm-Message-State: AOAM5301SksBG5ymNfThyhpx2sg1olyuPh4f9ac8DA3Hwnzj3FYRKyVZ
        CRnqfx/t8qimZzrZ0+atLFALWw==
X-Google-Smtp-Source: ABdhPJxoQ4XeAYEroSjRKIe3ajdC9MLdtC450rboK3p9g++hxKRkIyYCXNH35Jr8sb3SlgtDgBGI+w==
X-Received: by 2002:a17:90a:31cf:: with SMTP id j15mr2749433pjf.41.1614838358171;
        Wed, 03 Mar 2021 22:12:38 -0800 (PST)
Received: from google.com ([2620:0:1008:10:5ddf:a7e:5239:ef47])
        by smtp.gmail.com with ESMTPSA id e1sm8477557pjt.10.2021.03.03.22.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 22:12:37 -0800 (PST)
Date:   Wed, 3 Mar 2021 22:12:32 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <YEB6ULUgbf+s8ydd@google.com>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-2-vipinsh@google.com>
 <YD+ubbB4Tz0ZlVvp@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD+ubbB4Tz0ZlVvp@slm.duckdns.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021 at 10:42:37AM -0500, Tejun Heo wrote:
> > +	atomic_t usage;
> > +};
> 
> Can we do 64bits so that something which counts memory can use this too?
> 
Sure.

> > +
> > +		if (usage > capacity)
> > +			return -EBUSY;
> 
> I'd rather go with allowing bringing down capacity below usage so that the
> users can set it to a lower value to drain existing usages while denying new
> ones. It's not like it's difficult to check the current total usage from the
> caller side, so I'm not sure it's very useful to shift the condition check
> here.
> 

Okay, I will change the code to set new capacity unconditionally.

Right now there is no API for the caller to know total usage, unless they
keep their own tally, I was thinking it will be useful to add one more API

unsigned long misc_cg_res_total_usage(enum misc_res_type type)

It will return root_cg usage for "type" resource.
Will it be fine?

> > +			pr_info("cgroup: charge rejected by misc controller for %s resource in ",
> > +				misc_res_name[type]);
> > +			pr_cont_cgroup_path(i->css.cgroup);
> > +			pr_cont("\n");
> 
> Should have commented on this in the priv thread but don't print something
> on every rejection. This often becomes a nuisance and can make an easy DoS
> vector at worst. If you wanna do it, print it once per cgroup or sth like
> that.

I didn't think in that way. Thanks, I will print it once per cgroup.

Thanks
Vipin
