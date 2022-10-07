Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698BE5F7232
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 02:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiJGAOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 20:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiJGAOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 20:14:52 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3FF29800
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 17:14:51 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 67so3474832pfz.12
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 17:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YlSGVPUnY6d1n8UTyeUqDM5iX2NWmBYJxNJyxEQ5ux8=;
        b=DPTeHPHoTtt7e0Ss4avxqgDywS1bh/s6xAf4+WXzyMuQYLwEBq50Q+nMF1atCNXDju
         x502TuNljjQm6JjAMx0kg1sCuWKrFqtu1Im2crMyFsYI5U62h1I1AfcYUUf2T8iyO/p5
         iZD2E2jhQ10ezwDgF7VIX6uYYWmpwi5WTsSiOUT+5Ux+CtFGpGen0I8Nx/P2dCyovVbC
         hc+q8AAag61uXBY3G1+Y4T79V6xiEEyYj6WVLJ3gey8OlGMBqn7BckrvWxJlsBGr0Jfq
         V7gysLWdC1OT6wyA+VJAEsbh7ymMb4RzLiM8n6GCsEX2oMV9g8a2mWDFsQgxKHmESZZx
         Hj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YlSGVPUnY6d1n8UTyeUqDM5iX2NWmBYJxNJyxEQ5ux8=;
        b=FgBw9KQWe86cysIJ6nezPZzMZe4ZyN5zYtd3WbXRLXOmeH6eGhy0UhSPVOT6wos+Je
         HyZax5Oj8yU6zWA7W/xFu6Jzcyeu1St9mXM8Q6bf2I3NBklsiw/X8dBdXi1RtMZqNKAp
         9tmGROlZpcWEkG4jdrOEzPH4m6Z/Eu9By7CgKjNmauotXaWPFZCPvvA/LwiINthNzBXM
         6mUIm1WcpsglWTUWaadcJWkmgNUvSzGGcGtlaBVoDZ7wvF7HTK5StB12QTdb+kv/dxJ2
         JANWH2NfZN9Hbj5Y5Ib1U5l6VTJbXKV88SVLeJ3c2onAyNI6gpoiWgOVcLpICwZJsshc
         eVww==
X-Gm-Message-State: ACrzQf1UGV9048z2WSnaYi8cl0kwQr6BrjW3+wl2YX4CBglN4Fah0XjQ
        HaoF7EoIP/JHdAGz82nBe2RHNw==
X-Google-Smtp-Source: AMsMyM5IEOTCa4m2XogDacUjoFeH5VvX/jmOxB+rDjI2ZgGERKlGz0vJi00aUTRIdnykWfqAAjtFgA==
X-Received: by 2002:a62:4c2:0:b0:52e:bd4d:50e1 with SMTP id 185-20020a6204c2000000b0052ebd4d50e1mr2555581pfe.8.1665101690719;
        Thu, 06 Oct 2022 17:14:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x14-20020aa7940e000000b00562677968aesm213468pfo.72.2022.10.06.17.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 17:14:50 -0700 (PDT)
Date:   Fri, 7 Oct 2022 00:14:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] KVM: selftests: Run dirty_log_perf_test on
 specific CPUs
Message-ID: <Yz9vdoiq+0TyaGqo@google.com>
References: <20221006171133.372359-1-vipinsh@google.com>
 <20221006171133.372359-5-vipinsh@google.com>
 <Yz8xdJEMjcfdrcWC@google.com>
 <CAHVum0e4fiaB7hGSA6z1SaiZ1632f9Md2p0Nw6G=5wqhHYvdJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0e4fiaB7hGSA6z1SaiZ1632f9Md2p0Nw6G=5wqhHYvdJg@mail.gmail.com>
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

On Thu, Oct 06, 2022, Vipin Sharma wrote:
> On Thu, Oct 6, 2022 at 12:50 PM Sean Christopherson <seanjc@google.com> wrote:
> > > +{
> > > +     cpu_set_t cpuset;
> > > +     int err;
> > > +
> > > +     CPU_ZERO(&cpuset);
> > > +     CPU_SET(pcpu, &cpuset);
> >
> > To save user pain:
> >
> >         r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
> >         TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)", errno,
> >                     strerror(errno));
> >
> >         TEST_ASSERT(CPU_ISSET(pcpu, &allowed_mask),
> >                     "Task '%d' not allowed to run on pCPU '%d'\n");
> >
> >         CPU_ZERO(&allowed_mask);
> >         CPU_SET(cpu, &allowed_mask);
> >
> > that way the user will get an explicit error message if they try to pin a vCPU/task
> > that has already been affined by something else.  And then, in theory,
> > sched_setaffinity() should never fail.
> >
> > Or you could have two cpu_set_t objects and use CPU_AND(), but that seems
> > unnecessarily complex.
> >
> 
> sched_setaffinity() doesn't fail when we assign more than one task to
> the pCPU, it allows multiple tasks to be on the same pCPU. One of the
> reasons it fails is if it is provided a cpu number which is bigger
> than what is actually available on the host.
> 
> I am not convinced that pinning vCPUs to the same pCPU should throw an
> error. We should allow if someone wants to try and compare performance
> by over subscribing or any valid combination they want to test.

Oh, I'm not talking about the user pinning multiple vCPUs to the same pCPU via
the test, I'm talking about the user, or more likely something in the users's
environment, restricting what pCPUs the user's tasks are allowed on.  E.g. if
the test is run in shell that has been restricted to CPU8 via cgroups, then
sched_setaffinity() will fail if the user tries to pin vCPUs to any other CPU.
