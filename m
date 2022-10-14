Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9D85FF2A9
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiJNQ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 12:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiJNQz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 12:55:57 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A3B159D5C
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 09:55:54 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3608b5e634aso51617907b3.6
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 09:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=621BLDO+wewUpZczBZfn8RJnMCft7GwJ94oh2KaIzRg=;
        b=IHN8W0HKAbuSfaHJWrQYdabbCio4EQjxKxBZ44SyZ/jgJhNUKCkLm4heZAaly2FvIU
         OzuiTIyOSK0aHTI4s3PrlaTwBmG7Ew3l0+Jg6+f6VmLOCYp6CnxyNBvZcjWIEuAJC44W
         0aDjQvSyRupLaPDcLnMDGI74NdNlXR9fUMR/DksP63rh9HdVqLZdx1IPQDk7Wz3T3v06
         l1P/6wJa8kwdq6K5bfhTPijRS6tFRSY4W9Kct3bPc3tscDqYMzzztx7kH8XCQ2zDL6QF
         IZjvJtKu3rMOpvsRsR5KyM6A+PFQE5O+hJ5MxAqapBFCVmGs7+FYZvk8bfYWDsEIJ6AF
         lhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=621BLDO+wewUpZczBZfn8RJnMCft7GwJ94oh2KaIzRg=;
        b=MspOVlPyGoC81DaTc8ngoY7ruoPqrbGiXlxzKiQPyEdLds9wFOoZb5ajQmZTeptDGI
         ulc9wYRRIe35IPDIS+bgWstnmRUOadT2SgnPq5NdLTZOMEI+7qw8UREeWhxEDKb4B3Cr
         d+vd5mqaV4YsYSG5jCAyAmrrIpA+bU17YgIUwRW5AgM+YITIwiuCzBSfVPQQCFyKP/MU
         dSNyTqCQOQrEa+XiaKNjsJkWaUijtfjhlNItVD+DL7WZ/COKcgXbsqjUc9Sh+OeemiMY
         46Ina1e6BXz44K3TOVQroBRgbRQSOts6RQcHoPSh5Yw0b/CmYeACDkSYCDSx9NvSqh3c
         sxmA==
X-Gm-Message-State: ACrzQf3Z8hUS+xueIpzF84J9OnYwSgReY4IzL/1BBI5SWNG/JOdMJFxW
        PH2giz6+GdAv/DkLmEPYN87GZzPcywlP0S+Qj7LZ4Q==
X-Google-Smtp-Source: AMsMyM4m6UumVYMO7hIc/3TJmtlg47mePGvcXwykIysFeyQHWxkEw4EyGr3Yzw08OS7O3Y4EFA5pyqoGLU/IQruhCxI=
X-Received: by 2002:a0d:f545:0:b0:350:8a38:7edf with SMTP id
 e66-20020a0df545000000b003508a387edfmr5389860ywf.209.1665766553213; Fri, 14
 Oct 2022 09:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221010220538.1154054-1-vipinsh@google.com> <DS0PR11MB63735576A8FBF80738FF9B76DC249@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y0mPqNRSgpArgyS8@google.com>
In-Reply-To: <Y0mPqNRSgpArgyS8@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 14 Oct 2022 09:55:27 -0700
Message-ID: <CALzav=dU2-3avKGT2-AxO8d_uVH9bmYaO=ym8pPFM8esuSWP=A@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Vipin Sharma <vipinsh@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Oct 14, 2022 at 9:34 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 14, 2022, Wang, Wei W wrote:
> > On Tuesday, October 11, 2022 6:06 AM, Vipin Sharma wrote:
> > > Pin vCPUs to a host physical CPUs (pCPUs) in dirty_log_perf_test and optionally
> > > pin the main application thread to a physical cpu if provided. All tests based on
> > > perf_test_util framework can take advantage of it if needed.
> > >
> > > While at it, I changed atoi() to atoi_paranoid(), atoi_positive,
> > > atoi_non_negative() in other tests, sorted command line options alphabetically
> > > in dirty_log_perf_test, and added break between -e and -g which was missed in
> > > original commit when -e was introduced.
> >
> > Just curious why not re-using the existing tools (e.g. taskset) to do the pinning?
>
> IIUC, you're suggesting the test give tasks meaningful names so that the user can
> do taskset on the appropriate tasks?  The goal is to ensure vCPUs are pinned before
> they do any meaningful work.  I don't see how that can be accomplished with taskset
> without some form of hook in the test to effectively pause the test until the user
> (or some run script) is ready to continue.

A taskset approach would also be more difficult to incorporate into
automated runs of dirty_log_perf_test.

>
> Pinning aside, naming the threads is a great idea!  That would definitely help
> debug, e.g. if one vCPU gets stuck or is lagging behind.

+1

>
> >
> > For example, with below changes:
> > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/se                                                                                                             lftests/kvm/lib/perf_test_util.c
> > index 9618b37c66f7..aac58d1acb3c 100644
> > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > @@ -264,6 +264,7 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
> >                                   void (*vcpu_fn)(struct perf_test_vcpu_args *))
> >  {
> >         int i;
> > +       char vcpu_name[5];
> >
> >         vcpu_thread_fn = vcpu_fn;
> >         WRITE_ONCE(all_vcpu_threads_running, false);
> > @@ -275,6 +276,8 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
> >                 WRITE_ONCE(vcpu->running, false);
> >
> >                 pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
> > +               sprintf(vcpu_name, "%s%d", "vcpu", i);
> > +               pthread_setname_np(vcpu->thread, vcpu_name);
> >         }
> >
> > and with top we can get
> >     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
> >    4464 root      20   0 4248684   4.0g   1628 R  99.9  26.2   0:50.97 dirty_log_perf_
> >    4467 root      20   0 4248684   4.0g   1628 R  99.9  26.2   0:50.93 vcpu0
> >    4469 root      20   0 4248684   4.0g   1628 R  99.9  26.2   0:50.93 vcpu2
> >    4470 root      20   0 4248684   4.0g   1628 R  99.9  26.2   0:50.94 vcpu3
> >    4468 root      20   0 4248684   4.0g   1628 R  99.7  26.2   0:50.93 vcpu1
