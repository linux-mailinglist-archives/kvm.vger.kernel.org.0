Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EE95F330A
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 18:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJCQAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 12:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJCQAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 12:00:13 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C16A2DDE
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 09:00:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 8-20020a17090a0b8800b00205d8564b11so10313403pjr.5
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 09:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ZLMcgYC7rygcV6R0B6hLuvo9N4knyl0KJVCK0k0kuiI=;
        b=J4ESGKCpLmBi2tKKTKZepwOcl+XFDg1auxJyNqzUNGrcjMlJiOywbkd5qiM6WsFj0i
         IvTIKpWSmbwWFPU14sG0tf3PpOBmJAv9L7LnPQPdon7XJ8XqyB0MNhYjKlGVyky+ijd7
         gcV8njp72m4sDkKmh2r9byT8K2BvRM3CDdGTfVo5jrttdasZ78vdEGsHqZg4jwIv7j9X
         jvy+Bjp1Ihg6D9+POerK5brEv23mneVg4Y2AZmSmugz4XagqKSrg3PjsvwK/eRcJnxsT
         f1cn/eRyVh5LcxU8JeWFzVbO1VsAORqhpL2luQx09bU/ZP/uCMYnDeIcwYKaS9tgfJZr
         Naeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZLMcgYC7rygcV6R0B6hLuvo9N4knyl0KJVCK0k0kuiI=;
        b=I6bkkIQD+yJX291iMmW6fesC0JPWagxc1Gefi07r0KUusHcfM3791P40eELdO+34IA
         zT+Ka84cOG1NDroZNiKb4GlDSVFktYN9dizdK4T6L6PhxkodI7tQ0GuRjVo7dUpLnhEp
         ag71ua9el91tuXlhHsMEupZ70aEvd0sUdJ0I0EAa33QLLnktMOhZvS0ghlsbGvwWw+b3
         DZa5R4kFSzyAKZj3MZPxuNxSX/ntv/z3KSxLByUGnzQbmj10MhajhhnDotrFbz+NK232
         kQnflRY7N8PX32B3cH1QSmw/sZrtiVrwXBxFwsoQCZF3yCu9iMZ9K2PA9sZiILJnJ63A
         lUXQ==
X-Gm-Message-State: ACrzQf2PF0WDEV2d+UeK3TUlBe08sXzYBOgSkBxv3Kn/q2tE5NlTVjG5
        O06xXdHh8IXKhlgsAfqOBrF+2w==
X-Google-Smtp-Source: AMsMyM7QO0YQlEOfIsZGz92i0d+/FqsxvlUMBCRGKMESntojW+CLrS1gLmDE17S6HdKkalDEJRBaDg==
X-Received: by 2002:a17:902:cf12:b0:179:fafd:8a1c with SMTP id i18-20020a170902cf1200b00179fafd8a1cmr23411258plg.102.1664812809618;
        Mon, 03 Oct 2022 09:00:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a14-20020a1709027e4e00b00177ff4019d9sm7307901pln.274.2022.10.03.09.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 09:00:08 -0700 (PDT)
Date:   Mon, 3 Oct 2022 16:00:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 30/39] KVM: selftests: Hyper-V PV TLB flush selftest
Message-ID: <YzsHBOALtx7IRRk4@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-31-vkuznets@redhat.com>
 <YyuVtrpQwZGHs4ez@google.com>
 <87wn9h9i3w.fsf@redhat.com>
 <YzsEDt3f/+a0FuBS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzsEDt3f/+a0FuBS@google.com>
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

On Mon, Oct 03, 2022, Sean Christopherson wrote:
> On Mon, Oct 03, 2022, Vitaly Kuznetsov wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > > And if you really need a udelay() and not a
> > > usleep(), IMO it's worth adding exactly that instead of throwing NOPs at the CPU.
> > > E.g. aarch64 KVM selftests already implements udelay(), so adding an x86 variant
> > > would move us one step closer to being able to use it in common tests.
> > 
> > ... so yes, I think we need a delay. The problem with implementing
> > udelay() is that TSC frequency is unknown. We can get it from kvmclock
> > but setting up kvmclock pages for all selftests looks like an
> > overkill. Hyper-V emulation gives us HV_X64_MSR_TSC_FREQUENCY but that's
> > not generic enough. Alternatively, we can use KVM_GET_TSC_KHZ when
> > creating a vCPU but we'll need to pass the value to guest code somehow.
> > AFAIR, we can use CPUID.0x15 and/or MSR_PLATFORM_INFO (0xce) or even
> > introduce a PV MSR for our purposes -- or am I missing an obvious "easy"
> > solution?
> 
> I don't think you're missing anything.  Getting the value into the guest is the
> biggest issue.
> 
> Vishal is solving a similar problem where the guest needs to know the "native"
> hypercall.  We can piggyback that hook to do KVM_GET_TSC_KHZ there during VM
> creation, and then simply define udelay()'s behavior to always operate on the
> "default" frequency.  I.e. if a test wants to change the frequency _and_ use
> udelay() _and_ cares about the precision of udelay(), then that test can go write
> its own code.

Forgot to connect the dots: https://lore.kernel.org/all/YzsC4ibDqGh5qaP9@google.com
