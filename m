Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD369604CA8
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiJSQCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiJSQB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:01:57 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A99017D854
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:01:24 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y1so17657276pfr.3
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8D7y8sryxzBe8GMsiKsKdeHo1vMX8nN/FyXPD9BMo4M=;
        b=k8IE4oqm/e+jog5PqwvIZ7TJnBPoLAxBJZ3TtfZykjEnQNzftyPzwQkP/h970xeCnw
         O33rorOpcNbeBoRXDhULLwypGHOHvcLugMfDQhlOUozmdpTqOqzW7GZRR7Z8GCwphhFh
         GJJ8UwrBT1tHc+PswgM+a/soZX4b2gnONRz7Aeb5wnlX9zOBmXvMmJgS3isWF8n34J0u
         DWj6kh012hkeZz77Jf0KA9oOgmklxK5rs0AON1zvHLG+QoN1YFTTHIX4z17OOlm8RE+L
         UWBC3gV0nbsm0g+s1IQTvNhlrR4/PY3TVCCpTSfh6KgXsqyA6uqCkdoRTly0XWN4W5Zc
         +4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8D7y8sryxzBe8GMsiKsKdeHo1vMX8nN/FyXPD9BMo4M=;
        b=CkVZ9gd00FuDh2gheWqP/QRF2oGII9a0xsBzAERMcraYePwZD4ahf7qAI5OL0UHT8n
         sEg5B6LtuYF4O+sMl5aaJOHU9TD8hMyh5PAcc86eXzWuOoVVg3WBq0IwudFlmzQGN+BL
         em6gMqCsQIvwFcp/iW+UzSkwKMmuee5i85FXFJEfocSIzsaQfCopfN3pd/F27Ib55jtd
         oGXDT1sKixmQ7O1o/HdI8d/3bVhZcswY4ykfgKFUtrwwXDII8X0DMQwaryE13tYScSY6
         TWzk/5yCAzzEWPUGjOZmiTNmrvhV6P1YKDxmF/CDOM3eAxgCMskPmYf+GrL88cWLQmxS
         G6iQ==
X-Gm-Message-State: ACrzQf1bktBv53MUimIoujti0QQZTK6XtkcMJj/J8OlHsxcdZGP9kABl
        rAraDWipe55WvaFkQMTILxGzyw==
X-Google-Smtp-Source: AMsMyM7INHws8jVt0G13sw3X4v9sCgXSOdrGdZd2KT8RefnRHQlZrZkH0vfq2lV80U3L0I3NbNEi5g==
X-Received: by 2002:a63:594b:0:b0:453:c041:7e with SMTP id j11-20020a63594b000000b00453c041007emr7825856pgm.87.1666195284054;
        Wed, 19 Oct 2022 09:01:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g135-20020a62528d000000b0056328e516f4sm11795668pfb.148.2022.10.19.09.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 09:01:23 -0700 (PDT)
Date:   Wed, 19 Oct 2022 16:01:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Y1AfT4GAtz79h7oV@google.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <21fce8d9-489f-0d7e-b1a6-5598f92453fe@nutanix.com>
 <1231809b-d214-ba10-784b-d2b015a69e09@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231809b-d214-ba10-784b-d2b015a69e09@nutanix.com>
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

On Mon, Oct 17, 2022, Shivam Kumar wrote:
> 
> On 10/10/22 11:11 am, Shivam Kumar wrote:
> > 
> > On 15/09/22 3:40 pm, Shivam Kumar wrote:
> > > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > > index 3ca3db020e0e..263a588f3cd3 100644
> > > --- a/include/linux/kvm_types.h
> > > +++ b/include/linux/kvm_types.h
> > > @@ -118,6 +118,7 @@ struct kvm_vcpu_stat_generic {
> > >       u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
> > >       u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
> > >       u64 blocking;
> > > +    u64 pages_dirtied;
> > I am reworking the QEMU patches and I am not sure how I can access the
> > pages_dirtied info from the userspace side when the migration starts, i.e.
> > without a dirty quota exit.
> > 
> > I need this info to initialise the dirty quota. This is what I am looking
> > to do on the userspace side at the start of dirty quota migration:
> >      dirty_quota = pages_dirtied + some initial quota
> > 
> > Hoping if you could help, Sean. Thanks in advance.
> I think I can set dirty_quota initially to 1 and let the vpcu exit with exit
> reason KVM_EXIT_DIRTY_QUOTA_EXHAUSTED. Then, I can set the quota.

The vCPU doesn't need to be paused to read stats, pages_dirtied can be read while
the vCPU is running via KVM_GET_STATS_FD.  Though at a glance, QEMU doesn't yet
utilize KVM_GETS_STATS_FD, i.e. QEMU would a need a decent chunk of infrastructure
improvements to avoid the unnecessary exit.
