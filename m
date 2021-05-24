Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857EA38F648
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhEXXgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhEXXgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:36:04 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A1DC061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:34:35 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b7so11253986plg.0
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/H0clhV4tOZoMp9KDqobL3szU5TzRLWM2orErripiI4=;
        b=L2WR+afjLirW2w8oDDtcx0rapxQwZHjQwTFk8XAEq6I0ZKtF+yVqeyh80hGq8oe7DP
         DyzyJQe6+x8/zvr8ZjrUQyOpVJzISWguhYvhbWQ8wWf2pTOGW58t+IfaKCLfwkByOk55
         6zjLChp4/bhTZsEvTKsWyKJkLJmja7OuvKr0sJ06g193Y/MhXWJpXzGEXe5BvzUopVBN
         t7Dvn2bcVuLcD5DYEayrF9tjSCnT9507g+bLPyF9EBdIq2vbHiom6Mp+IkTmRtNVwvnc
         V0KUkkwZsHQMX00zO4mIZqODb4befYMFfpcTkGF/L7L491l8o1nst6GEpov6rGRaqnnz
         lY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/H0clhV4tOZoMp9KDqobL3szU5TzRLWM2orErripiI4=;
        b=Tn5tnP9s8iaxnk9M8sspHk3stpQgPqQAwnRRShHdtS7qfSqOANBgjUh4gFMpS2Ofvb
         oIBbsfmFJYWroJ9x6V3zmNIpqbKHI8jfU8hmQMNrTsVrpmREg7iBoMPb2WvdcvBnrtSn
         gHlgbKLIqRi3QH51GtKVUrHSczZtHL+4xXeovaaUprEVTnufgbctanuSbt4kFG5Fdeku
         Rwjw1N0ev5DQe0+lcdrb+jjAEfSy6CuMsRZk4rzCuq/ImJsWjew7lmGP9yWtBAquDCSd
         jNmc08q18CdcZ7aU8bsZnVGgk8866HETEiBRvht2MKGD5xm98Kp/UwrGj8j10kEKSDTX
         U/JA==
X-Gm-Message-State: AOAM531xO9yk8demGHJeahuLN7x53E9dt8wu/yyVQGd2hseklnUst8P3
        Dg7lVclnwf1+F3Rw05087zisbA==
X-Google-Smtp-Source: ABdhPJzERL5PEhpOb++p/Tjti31MC4dIVro2TlGdgoMOuLEnDfJ3CTKMgp33jss9jniNM8U+kCvyWQ==
X-Received: by 2002:a17:902:d2ce:b029:f4:4a5:9a8b with SMTP id n14-20020a170902d2ceb02900f404a59a8bmr27552466plc.70.1621899275234;
        Mon, 24 May 2021 16:34:35 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id q23sm12568332pgt.42.2021.05.24.16.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:34:34 -0700 (PDT)
Date:   Mon, 24 May 2021 23:34:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 02/12] KVM: x86: Wake up a vCPU when
 kvm_check_nested_events fails
Message-ID: <YKw4B9ndWgMqQjaZ@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
 <20210520230339.267445-3-jmattson@google.com>
 <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com>
 <CALMp9eQ0LQoesyRYA+PN=nzjLDVXjpNw6OxgupmL8vOgWqjiMA@mail.gmail.com>
 <e2ed4a75-e7d2-e391-0a19-5977bf087cdf@redhat.com>
 <YKwydQlAXHeockLx@google.com>
 <CALMp9eRQXwpM8N6BzrY+gt0cPCCxYuf2UVgdgxjEN6=SrgTkjg@mail.gmail.com>
 <YKw1vEzfWG0dPhNM@google.com>
 <CALMp9eQL_VwYEz8YTg8kQWprmAZSyqDAyCTuXvtNzKMTEza3HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQL_VwYEz8YTg8kQWprmAZSyqDAyCTuXvtNzKMTEza3HA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Jim Mattson wrote:
> On Mon, May 24, 2021 at 4:24 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, May 24, 2021, Jim Mattson wrote:
> > > On Mon, May 24, 2021 at 4:10 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Mon, May 24, 2021, Paolo Bonzini wrote:
> > > > > On 24/05/21 18:39, Jim Mattson wrote:
> > > > > > Without this patch, the accompanying selftest never wakes up from HLT
> > > > > > in L2. If you can get the selftest to work without this patch, feel
> > > > > > free to drop it.
> > > > >
> > > > > Ok, that's a pretty good reason.  I'll try to debug it.
> > > >
> > > > I don't think there's any debug necessary, the hack of unconditionally calling
> > > > kvm_check_nested_events() in kvm_vcpu_running() ...
> > >
> > > We don't unconditionally call kvm_check_nested_events() in
> > > kvm_vcpu_running(). We still call kvm_check_nested_events() only when
> > > is_guest_mode(vcpu). The only change introduced in this patch is that
> > > we stop ignoring the result.
> >
> > Doh, sorry, bad use of "unconditionally".  I meant "unconditionally when in L2". :-)
> 
> Again, the conditions under which we call kvm_check_nested_events are
> unchanged. The only "hack" here is the hack of not ignoring the return
> value.

I don't disagree, all I'm saying is that the existing code is a hack, and this
doesn't fix/cleanse that hack.  I agree that this patch is a good intermediate
change.
