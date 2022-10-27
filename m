Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442EC61029F
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 22:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbiJ0UXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 16:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbiJ0UXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 16:23:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E963B8E998
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:23:46 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9so2776997pll.7
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2PguZ/p37xxoxY3AXOqFn39YQDoXuFPbF7sofI4ByE=;
        b=WUqpvqsZed2ikWOgFzfHLWzSz+jOpwUfcNa+ozuxaQZR9iL2ewne2Kd8NG+KXVYUfS
         p3XpB4nuS/X4qyPXH2TSlbeXSCMtRwZhPBqqduo8GoWxWDpDNax2ljjeBvKQuuBwHmu9
         Ns4xyKb3rGTkmS8iE6eWa9Y0WelxnO+RaueR3A6znMCk+RJYWQ/vsaxmE04PpxfHSEqU
         wsFs/dcq6BYPFIrSgEPYvFJFKpMWhx5iTotRVPzlFseyAxxp1R64OkwegkH1MLNCGZ/w
         aSXnBy5YeT/fmxnAifJAamSOndfMAVl7OBT/qD05QBVStQ6x7unZeX968UvJui0u9jDT
         i/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2PguZ/p37xxoxY3AXOqFn39YQDoXuFPbF7sofI4ByE=;
        b=Dg4ogvQWDdWAU54PlGktLyMbtypEP/unvba2mGh3BCe3eRs2Cok/LZEG+nC/gLF++R
         EXNNVe5XnfskAS4mMc7DvkTt6r5L6ZM5I6XkUcFp0BuPviOHFPGMsQdGWh2Y1N1q8B5+
         XlvQYLmFlZ6CWfmII+y5VQK/FRWaNcyDrnvYdDDdXs0XHaH+jEz0v2qYK4ccb6aES1lr
         m+kvLcoaVGzy7ncASATk0Y7ieOt+lt7e+Ixa5fqHx6g1nf+op5+7Hb0p+7nI8kedUaQZ
         rIxt8haxXrjwDuIcbRx0JnSb0YoEEGKXjHl5V3jQwoo6iSgsgMx2YTD0ke6ndj28j6hF
         VeVw==
X-Gm-Message-State: ACrzQf1xJfOxlb5gEgdkfK7WPn+D/RFbsF/G8NMWr+YDNYlzTfrvx216
        FdPUkxPVt/MD8yU0sfMKIg+LKQ==
X-Google-Smtp-Source: AMsMyM6w/7KoGPpkUCb79wNJ9G8zD8NIMsW0VRCRNawwTo8X94yVJEmA/dCGZ971HREmkflRI4acdg==
X-Received: by 2002:a17:902:e9c2:b0:186:79dc:7d87 with SMTP id 2-20020a170902e9c200b0018679dc7d87mr34676516plk.59.1666902226365;
        Thu, 27 Oct 2022 13:23:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d48400b001782a0d3eeasm1608788plg.115.2022.10.27.13.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:23:46 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:23:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
Message-ID: <Y1roztLsZtYQ6hzI@google.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-6-vipinsh@google.com>
 <DS0PR11MB637351B52E5F8752E7DA16A4DC309@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1lV0l4uDjXdKpkL@google.com>
 <DS0PR11MB6373E6CA4DDFFD47B64CB719DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1qqIgVdZi7qSUD0@google.com>
 <CAHVum0edLWu0fGMgs7n2v2Fu-XW5mXtAsJ2dtkWD=ZadbRi+hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0edLWu0fGMgs7n2v2Fu-XW5mXtAsJ2dtkWD=ZadbRi+hw@mail.gmail.com>
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

On Thu, Oct 27, 2022, Vipin Sharma wrote:
> On Thu, Oct 27, 2022 at 8:56 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Oct 27, 2022, Wang, Wei W wrote:
> > > On Wednesday, October 26, 2022 11:44 PM, Sean Christopherson wrote:
> > > > If we go this route in the future, we'd need to add a worker trampoline as the
> > > > pinning needs to happen in the worker task itself to guarantee that the pinning
> > > > takes effect before the worker does anything useful.  That should be very
> > > > doable.
> > >
> > > The alternative way is the one I shared before, using this:
> > >
> > > /* Thread created with attribute ATTR will be limited to run only on
> > >    the processors represented in CPUSET.  */
> > > extern int pthread_attr_setaffinity_np (pthread_attr_t *__attr,
> > >                                  size_t __cpusetsize,
> > >                                  const cpu_set_t *__cpuset)
> > >
> > > Basically, the thread is created on the pCPU as user specified.
> > > I think this is better than "creating the thread on an arbitrary pCPU
> > > and then pinning it to the user specified pCPU in the thread's start routine".
> >
> > Ah, yeah, that's better.
> >
> 
> pthread_create() will internally call sched_setaffinity() syscall
> after creation of a thread on a random CPU. So, from the performance
> side there is not much difference between the two approaches.
> 
> However, we will still need pin_this_task_to_pcpu()/sched_affinity()
> to move the main thread to a specific pCPU, therefore, 

Heh, that's a good point too.

> I am thinking of keeping the current approach unless there is a strong objection
> to it.

No objection here, I don't see an obvious way to make that helper going away.
