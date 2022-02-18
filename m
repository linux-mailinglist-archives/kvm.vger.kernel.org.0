Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CF94BBF6E
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 19:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbiBRS0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 13:26:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239285AbiBRS0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 13:26:01 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D8A4AE1D
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:25:44 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id x11so7794111pll.10
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/YY6gHmhRlidn/sY9OLwMpBqcTm3U79RSE+/6MPGrJA=;
        b=Yikg60aEeMXc80GolC4gFuR/bCOvdyO1+bgorzH57I67lv589wT3iZ9TqMt+rjvOh8
         H8KWOYa5PNS0FNo7DZ2Agm9k7fVGWhXapa6dpQ9huUdCNFN4rfqx28UCJlTIeU4nIZYw
         bzk/srr8FDPJtk1MHlC6HZGRCbYRKOKe+5eIpUECPeAD/ke9yHdvdmhmBxBkJ61ufoj8
         Dq1x3lJeVTVfUmOr+etb76YXjwuMyrl1bkN7YKNFoAcMdfZJh5YjI1HHRrQko5Udffol
         7rS+shfUUfDbvZqxep/a6EPgOH1S+Qcco6yiASWw57vXjlRQAO0hAPJC0O5G/afKME81
         0+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/YY6gHmhRlidn/sY9OLwMpBqcTm3U79RSE+/6MPGrJA=;
        b=1FrcHfW+2zg8KFB6RhMiImlMSYTML8dapz+k2HAbUs59XM61dNPJNruFtdjZjAYicZ
         FL0TTaTJXnfmiLuz363DUre3vP71lQeCgP8FbhQraCTl99YQaWE1A++o5LyENnmVOEBg
         PliDtH3yFoeKJ51JXtESXx+vLYSjt+M9MZ9BNeqZiGiwNRgvIQuaqZF6SIHglUR6diFP
         sF8f0rWdiKNHMvBFexvn9aa/nQ5nYvqNJ8NFhcFOgs/je12C12JuIIp9MPdRDBscRnow
         BPqPlH2s3z8T0ptPnW7A2HOlGeWLH27H3PdvEtZMXG3TvaI/oXyY3QmHxT3yE56ekReu
         fOTQ==
X-Gm-Message-State: AOAM5328icr0M29Hx5NfvacjEvWoT0F+wWzVlzYp15YfYn6Gy+ZNsXgW
        Tip9jS9WoDGK3nzMFvivJBcQMA==
X-Google-Smtp-Source: ABdhPJwggBWLIivAjldbUymbvPVfh/gDQqm0tN/nVKFq9v/jYAjSkDjVptJ8J0RWsg1nUGnzVBaXhw==
X-Received: by 2002:a17:90a:bb88:b0:1b9:eaf6:fe09 with SMTP id v8-20020a17090abb8800b001b9eaf6fe09mr9473590pjr.95.1645208744140;
        Fri, 18 Feb 2022 10:25:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z9sm11531437pgz.32.2022.02.18.10.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:25:43 -0800 (PST)
Date:   Fri, 18 Feb 2022 18:25:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Eric Hankland <ehankland@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86/pmu: Protect kvm->arch.pmu_event_filter
 with SRCU
Message-ID: <Yg/ko3ZE09/UvKL2@google.com>
References: <20220217083601.24829-1-likexu@tencent.com>
 <20220217083601.24829-2-likexu@tencent.com>
 <12b84d17-94cc-6ee7-bde4-340b609c16d2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12b84d17-94cc-6ee7-bde4-340b609c16d2@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 18, 2022, Paolo Bonzini wrote:
> On 2/17/22 09:36, Like Xu wrote:
> > From: Like Xu<likexu@tencent.com>
> > 
> > Fix the following positive warning:
> > 
> >   =============================
> >   WARNING: suspicious RCU usage
> >   arch/x86/kvm/pmu.c:190 suspicious rcu_dereference_check() usage!
> >   other info that might help us debug this:
> >   rcu_scheduler_active = 2, debug_locks = 1
> >   1 lock held by CPU 28/KVM/370841:
> >   #0: ff11004089f280b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x87/0x730 [kvm]
> >   Call Trace:
> >    <TASK>
> >    dump_stack_lvl+0x59/0x73
> >    reprogram_fixed_counter+0x15d/0x1a0 [kvm]
> >    kvm_pmu_trigger_event+0x1a3/0x260 [kvm]
> >    ? free_moved_vector+0x1b4/0x1e0
> >    complete_fast_pio_in+0x8a/0xd0 [kvm]
> >    [...]
> 
> I think the right fix is to add SRCU protection to complete_userspace_io in
> kvm_arch_vcpu_ioctl_run.  Most calls of complete_userspace_io can execute
> similar code to vmexits.

Agreed, I bet similar warnings can be triggered on SVM with nrips=false due to
svm_skip_emulated_instruction() dropping into the emulator, e.g. for HyperV and
Xen usage where next_rip doesn't appear to be filled in all paths.
