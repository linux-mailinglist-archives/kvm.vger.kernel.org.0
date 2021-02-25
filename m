Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E43247C5
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 01:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234900AbhBYAHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 19:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhBYAHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 19:07:32 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD085C061574
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 16:06:51 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id l2so2628828pgb.1
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 16:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dwsRL0iFuNLsIwlduzLk8A4HpuT+349o+yzvI+GvJGg=;
        b=FNfLLnAZf2wdLfsTREG5f4CUE90hhdj+9efnR0CcEASFvTBlIxbq2WH8aD66ed0cWP
         u9dRyt1Oj6/lfDKABYmqQbAGmMmI/X9cRN3qMQgoex1+4N5PBvszos8ZfcL7YE+BQnHc
         Dh/Dnaa1VnZhDlc8qYhgJFZnCdUpC03FVrogZi77qKJApoq49AGkV+XAN8eOJPhW6uyf
         Df3zBYK1751kzdlFraymh+st+EgK1j7iViJWlOfxzrePopY3x+EOvXWqZvKzf6XfjChS
         CLcqOiLshfzlIREJlcF+0l01oRXxU2HSvPTaQejPlLR4yh+2oehsS7SPhi7bE20wq4ax
         IcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dwsRL0iFuNLsIwlduzLk8A4HpuT+349o+yzvI+GvJGg=;
        b=E0gIqeO8t7PZjHPKcAs5Ds9yGlyJM1zf2eJHRoc5qdjo2qnu1D+Hp5qrB6FWAI2Gy6
         z7I7JqNq/CVVgnwInZC5Hhz5F8Qp3b6VQ4ZA77GFbOasaWp06eRuZ50CviGxg9R6fDuD
         zK5KvOiNxwxsjTXuPI7rJMoe/riWP1tZEmHG/H4t+yGsU3eCCM9/u23vFdS74a1KFEqF
         SBov/UgaUSD2cGZkkpfQlSHABdOkOuwZf0ydXzkuWv9vnuqmnzY4l9JlYKbRuJ8wY4xb
         o2IguZYnPD6ib0gBM+sIo5GZFRm/onfINyBNY8nFa7hN30VepCa1jOJDAfunvW8LRZTh
         Jd0g==
X-Gm-Message-State: AOAM530hpai+hCAxZ2fWpCANX9iMwOmfcG6v5E7jejmZkJYB+sl/NCbF
        WiJhdo6W0+KbkBEr1HNLu9BUgQ==
X-Google-Smtp-Source: ABdhPJxABfBShq1Krl8qx+eI5WYhSRtbAKRM77ikODQYw8yEC7MAcrpJKJjlocmRf535KdMK+BW8OA==
X-Received: by 2002:a63:f202:: with SMTP id v2mr450469pgh.24.1614211610972;
        Wed, 24 Feb 2021 16:06:50 -0800 (PST)
Received: from google.com ([2620:0:1008:10:94bf:1b67:285c:b7ce])
        by smtp.gmail.com with ESMTPSA id i7sm3977728pjs.1.2021.02.24.16.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 16:06:50 -0800 (PST)
Date:   Wed, 24 Feb 2021 16:06:44 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     tj@kernel.org, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] cgroup: New misc cgroup controller
Message-ID: <YDbqFE21UsEaFDuU@google.com>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <YDVIYQhZ6ArGsr3n@blackbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YDVIYQhZ6ArGsr3n@blackbook>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 23, 2021 at 07:24:33PM +0100, Michal Koutný wrote:
> Hello.
> 
> On Thu, Feb 18, 2021 at 11:55:47AM -0800, Vipin Sharma <vipinsh@google.com> wrote:
> > This patch is creating a new misc cgroup controller for allocation and
> > tracking of resources which are not abstract like other cgroup
> > controllers.
> Please don't refer to this as "allocation" anywhere, that has a specific
> meaning (see Resource Distribution Models in
> Documentation/admin-gruide/cgroup-v2.rst).

Yeah, it should be "Limits". I will update the text.

> 
> > This controller was initially proposed as encryption_id but after
> > the feedbacks, it is now changed to misc cgroup.
> > https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh@google.com/
> Interesting generalization. I wonder what else could fit under this as
> well. (It resembles pids controller on the cover.)
> 
> > Please provide any feedback for this RFC or if it is good for
> > merging then I can send a patch for merging.
> A new controller is added exposed with v1 attributes. I'm not convinced
> it is desirable to change the frozen v1 controllers' API? (And therefore
> promote it as well.)

This is a very trivial controller. I believe once it becomes public it
can be helpful down the line to the v1 users, who cannot use v2 yet, for
some simple resource accounting, like us, we have the need for ASIDs
accounting in v1 until we move to v2. If the community has strong
objection then I can remove v1 support.

> 
> Beware, bikeshedding. The name is very non-descriptive, potentially
> suggesting catch-all semantics. It'd deserve a further thought. My idea
> would be limit(s) or counter controller.

Limit and counter are kind of suggesting the underlying technique for
accounting instead of a generic name to denote resource types managed by
this controller. One can argue that if top level names are similar to
Resource Destribution Model then may be it makes sense to combine
resources with similar accounting technique under one controller.

I am looking at misc as a controller which is for resources not having
proper home in other controllers or not big enough to deserve their own
controller.

I agree with you coming up with a name which check all boxes of
requirements won't be possible. We have discussed name sev cgroup,
kvm cgroup, encryption_id cgroup before reaching to an agreement on misc
cgroup. I am open to other names if they are better suited for this
controller and makes more sense.

Thanks
Vipin
