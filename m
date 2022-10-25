Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7180160D10E
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 17:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiJYPzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 11:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiJYPzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 11:55:48 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1719A114DE5
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 08:55:47 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id g16so6783913pfr.12
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 08:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V0ERmtJH8Y8ohiV20nUYLWYgRYkI81zx7wLU2s7JOh8=;
        b=L903+97rjrcROLjG979Ms+HuOfnSZrQdCTDdbZl0Hi1jUoGMfLZPFvAAOKpj0xzsYH
         RejbrZr1bARGt7nRG7PDkRibySyxcOiQI6+E0KYfbTXo/3gZf/CMaYKJ8wrxG2ecJprm
         ZX2YMJXPgOVzyyDpUMGsk9NCIvx5g0iCLvQxOjVDZp0Mb2jn/djRVRpMRG/+2iZhbbw6
         Pthp5wAHHLpVz0WfZkrLT/tkX+l5tb8Sv+HnFa5ArzK3+3WRJph+IR/Oh50/VMfOYonp
         0+iF3HcjxWeHoIFK62f8nZ8T3g8ifmnLdUUgUt3XgVaXZBayr9dk1Fka9Ae3gQ7O5UWH
         6zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0ERmtJH8Y8ohiV20nUYLWYgRYkI81zx7wLU2s7JOh8=;
        b=oFIN6YNUBhnPujh04ea6BWK2aDZC9VIlYfMi3AKCaOXDnRTs8+tZGOvl5S/lZkiGP8
         jyJkj5QNFk8wlEsDB2Jmguoskd5atNiqYIedPBWOJHVlhi1rf6IwupnMcoamUqXzL+hs
         +nPEskKT62IuJs6QyuDuxUVhVmIeRqnB0mBrMm5tOgaDbu4ez3s44O9vj8esD0FID4y4
         +B4i6GY5+VnBGe7ebz7Ie5wKdXjL3gm0MCvqu15SVElpoSZkGNGAs+0L3CtTG2mukq28
         0NjkX3koHO0e/1LMAlp5wJQ7IgasXhViyTjKKsK7F5B3f6OEhNdl0xzyi6reztAx35Dc
         eBpw==
X-Gm-Message-State: ACrzQf004tvrl8sSZixmzRB+7toMDO2FIfjYbVoc20owHu4JIK4sv96D
        VL1r/gAcnlSZxalJltidGJG3mQ==
X-Google-Smtp-Source: AMsMyM4Sai6RhMhUGNWZVOaRyrMNrlOgH0M4FAHNS0khMEZ9FNFWv49Yl91SIz2JYKvdnH5Ky5e1cQ==
X-Received: by 2002:aa7:83cd:0:b0:563:5f54:d78c with SMTP id j13-20020aa783cd000000b005635f54d78cmr40623601pfn.66.1666713346386;
        Tue, 25 Oct 2022 08:55:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i20-20020aa796f4000000b0056c063dd4cfsm1545927pfq.66.2022.10.25.08.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 08:55:45 -0700 (PDT)
Date:   Tue, 25 Oct 2022 15:55:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: API to block and resume all running vcpus in a
 vm
Message-ID: <Y1gG/W/q/VIydpMu@google.com>
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <a2e16531-5522-a334-40a1-2b0e17663800@linux.ibm.com>
 <2701ce67-bfff-8c0c-4450-7c4a281419de@redhat.com>
 <384b2622-8d7f-ce02-1452-84a86e3a5697@linux.ibm.com>
 <Y1cVfECAAfmp5XqA@google.com>
 <5a26c107-9ab5-60ee-0e9c-a9955dfe313d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a26c107-9ab5-60ee-0e9c-a9955dfe313d@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 25, 2022, Paolo Bonzini wrote:
> On 10/25/22 00:45, Sean Christopherson wrote:
> > > Yes that helps and should be part of the cover letter for the next iterations.
> > But that doesn't explain why KVM needs to get involved, it only explains why QEMU
> > can't use its existing pause_all_vcpus().  I do not understand why this is a
> > problem QEMU needs KVM's help to solve.
> 
> I agree that it's not KVM's problem that QEMU cannot use pause_all_vcpus().
> Having a ioctl in KVM, rather than coding the same in QEMU, is *mostly* a
> matter of programmer and computer efficiency because the code is pretty
> simple.
> 
> That said, I believe the limited memslot API makes it more than just a QEMU
> problem.  Because KVM_GET_DIRTY_LOG cannot be combined atomically with
> KVM_SET_USER_MEMORY_REGION(MR_DELETE), any VMM that uses dirty-log regions
> while the VM is running is liable to losing the dirty status of some pages.

... and doesn't already do the sane thing and pause vCPUs _and anything else that
can touch guest memory_ before modifying memslots.  I honestly think QEMU is the
only VMM that would ever use this API.

> That's also a reason to provide this API in KVM.

It's frankly a terrible API though.  Providing a way to force vCPUs out of KVM_RUN
is at best half of the solution.  

Userspace still needs:

  - a refcounting scheme to track the number of "holds" put on the system
  - serialization to ensure KVM_RESUME_ALL_KICKED_VCPUS completes before a new
    KVM_KICK_ALL_RUNNING_VCPUS is initiated
  - to prevent _all_ ioctls() because it's not just KVM_RUN that consumes memslots
  - to stop anything else in the system that consumes KVM memslots, e.g. KVM GT
  - to signal vCPU tasks so that the system doesn't livelock if a vCPU is stuck
    outside of KVM, e.g. in get_user_pages_unlocked() (Peter Xu's series)

And because of the nature of KVM, to support this API on all architectures, KVM
needs to make change on all architectures, whereas userspace should be able to
implement a generic solution.
