Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA9D494048
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 20:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiASTFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 14:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiASTFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 14:05:08 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EC4C061574;
        Wed, 19 Jan 2022 11:05:08 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso7478120pjh.0;
        Wed, 19 Jan 2022 11:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rRh+idUwbOdly6bknpYwWmsx3IX/EG0YgmQNjU2Me8w=;
        b=Mn1dOVIkJPRudD5S+4bqqB0SgTsXe1/SRjq9+d/3NLil2nKYd+51WR0mfQqxIdIL7E
         XLuCWZ2RrMpIX3Fa7EPtb1nlgr4P/0Ou8R337jSark5p0P3MQ6uhZ/Io+yVBbaCIvzsL
         DhOJOPXtM51TFNfHTsGDj+j9QN00tHs3tuok0UvznETQqi3kBhSXC0XRQjFYeRWmO/6K
         4eeU7XvljzQPZHNjmj2YBxate/YP9hN4RqJUr723tPynsxtaG7/8j6EdlmYjIhCQuNkr
         hqt1+MXZHZsqBpwMQsX0bZm1+GGPIxZnJwViaI1E4KRSLP7zLsBzptqB3dhZ/nazKlHy
         raPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rRh+idUwbOdly6bknpYwWmsx3IX/EG0YgmQNjU2Me8w=;
        b=Z2A/vK+REFOwf5mVLpqSYvULEk+WrjIJV/vIBH7cjWFcYY4sYLiZPqn8G4S9gQdLAW
         3JHpJKllBiAxXJ5X22kOXfQL66b1s0L3xsJmFd3YGGGz44PpZr0gT7zEvtZS8wtNHA0B
         69HrGLQDeaQgvBTsJIAhq/VY2vhjiH+ENG5UxTFRqc2hbjRytl+45kj/wolS7FkAQ1lM
         7tyS03wLMOUc2k3K8ecxRiW296eOVc6JYflMOKCRuZmfj71WDp/oFKFZMJ94c1Rgc12c
         Kyl8/e6/FAG24pOqzcWRzAQKHBINkbTRGMH1fNgWuZWrkgsTvf7goEIzVsen4hSOq78R
         gpSw==
X-Gm-Message-State: AOAM531hGRNRGij4pMBxYPr7nyGgUx0d/gRQ4VGPItyVxGYywqM7IECY
        fgk4EfaEyWVYmEdxdrEZWJA=
X-Google-Smtp-Source: ABdhPJwoS0m/QykotRUJH3Qi7VVx/2n8pQ/rcYLz3C51+SNORi/AogJ1gvg8zwSw+v2Ein5dC5jn+g==
X-Received: by 2002:a17:90a:474d:: with SMTP id y13mr6030824pjg.4.1642619107410;
        Wed, 19 Jan 2022 11:05:07 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id j8sm411341pfc.127.2022.01.19.11.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 11:05:07 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 19 Jan 2022 09:05:05 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        seanjc@google.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Message-ID: <Yehg4doAwoUTBHLX@slm.duckdns.org>
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org>
 <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
 <YehY0z2vHYVZk52J@slm.duckdns.org>
 <CAHVum0fqhMQd2uFic5_7RN=Ah6TTH2G2qLNZuxnQXSazR57m6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0fqhMQd2uFic5_7RN=Ah6TTH2G2qLNZuxnQXSazR57m6g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 10:49:57AM -0800, Vipin Sharma wrote:
> Sean suggested that we can use the real_parent of the kthread task
> which will always be kthreadd_task, this will also not require any
> changes in the cgroup API. I like that approach, I will give it a try.
> This will avoid changes in cgroup APIs completely.

Yeah, that's better than the original but still not great in that it's still
a workaround and just pushes up the problem. You can get the same race if
the cgroups are nested. e.g. if you have a kvm instance under a/b and when
kvm exits, the management software removes b and then realizes that a is
empty too and then tries to delete that too.

It'd be great if we can make kthread_stop actually wait for what most others
consider thread exit but if we're just gonna work around them, just doing it
in userspace might be better - e.g. after kvm exits, wait for !populated
event (this is a pollable event) on the cgroup and then clean up.

Thanks.

-- 
tejun
