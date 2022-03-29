Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22B44EB0E0
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 17:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238921AbiC2Pp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 11:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiC2PpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 11:45:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AE2DEBA
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 08:43:42 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c23so18020770plo.0
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 08:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J43aAyOGGZvT9Vv7ZNK3e57N5DvirFPv9LjFAAhW5Zw=;
        b=tYdePrtADvRN9CmYHQ03NsvQLWogzm8wjMyWdodChxhW1IykOuUE1gJwaCdC6W3MHh
         lLtx4ihtUi1U9HbMvQDO1efd8SCacOechf5gNFQBdTEjk+XT1bnqmnCgrEDus4N2t3XN
         6XcrAgOEGpaf8FxSc+SzL5DAF4lanwEaSbuvB85apTSLqTAijLtvtGUDWU3hTEvrU/LN
         n5lHUbtHrVYsg5XuTea8vAchjE7Uq33xajpmV44dMAnYogHf3RgfIL/XE6QP9TW/ZHdk
         dBEdsV/qI/73/NiGYwAZUZF+8jjabw1G5+1J/afFA84KZGHOJMXV5wQlthw5pEW+3s2B
         KlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J43aAyOGGZvT9Vv7ZNK3e57N5DvirFPv9LjFAAhW5Zw=;
        b=PonivwUFvvy7uJUBvu+88P387cmxbkNd0ygufaWbMSPOTxm1XNFVsprq24/34hH33W
         et/oviRW+ydkiCH4WFaRxVQAMZ5r+XhGjEAAQvbidnmn/c/q1k3Smc/wHVk74rwoCxZD
         ejFqWow7rEIr1GRjyMeCyyKDQ3dFo0HXde5x8VHi9og1nAlMfYsci4DKqySNh5hq+BYD
         1VmYAUnJMaMAQknGQE6YV/LmX9CSCYEydZj/wFmBN3unryvZDoAfbBn+mvJurAhNaGSf
         3Rl8doPzmvOMPhgu+lWzGl3Z/5+pB3YPti17kW/1YAYAsSAgm/qk2hLoYPNk/rawSxZn
         jJjg==
X-Gm-Message-State: AOAM5309sKwJdfETXeo9gLRPkicwRs8wZ5DMUpMR0oYKmux4cwHywwHw
        jsJgoaFl2UmsJ7CB8tMJT30cfA==
X-Google-Smtp-Source: ABdhPJybbvBSjC9DpXP4o2mJeIG39RYennDekGneoAXKCYru5qu7tgPCDdG4qbQF2mA7ZNC2wOfM3g==
X-Received: by 2002:a17:90b:1d82:b0:1c6:d549:7b94 with SMTP id pf2-20020a17090b1d8200b001c6d5497b94mr195381pjb.49.1648568621304;
        Tue, 29 Mar 2022 08:43:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gt14-20020a17090af2ce00b001c701e0a129sm3456661pjb.38.2022.03.29.08.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 08:43:40 -0700 (PDT)
Date:   Tue, 29 Mar 2022 15:43:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
Message-ID: <YkMpKZtwB0n7Ta5C@google.com>
References: <20220311032801.3467418-1-seanjc@google.com>
 <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
 <YjzjIhyw6aqsSI7Q@google.com>
 <e605082ac8361c1932bfddfe2055660c7cea5f2b.camel@redhat.com>
 <YkH1e2kyFlQN3Hl9@google.com>
 <05378896d9179b1b8652c8d838c764d22aeca2fe.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05378896d9179b1b8652c8d838c764d22aeca2fe.camel@redhat.com>
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

On Tue, Mar 29, 2022, Maxim Levitsky wrote:
> On Mon, 2022-03-28 at 17:50 +0000, Sean Christopherson wrote:
> > I wouldn't call that abuse, the ioctl() isn't just for migration.  Not checking for
> > a pending exception is firmly a userspace bug and not something KVM should try to
> > fix.
> 
> yes, but to make the right decision, the userspace has to know if there is a pending
> exception, and if there is, then merge it (which might even involve triple fault),

There's no need for userspace to ever merge exceptions unless KVM supports either
exiting to userspace on an exception that can occur during exception delivery, or
userspace itself is emulating exception delivery.  Outside of debug scenarios, #PF
is likely the only exception that might ever be forwarded to userspace.  But in
those scenarios, userspace is almost always going to fix the #PF and resume the
guest.  If userspace doesn't fix the #PF, the guest is completely hosed because
its IDT will trigger #PF, i.e. it's headed to shutdown regardless of KVM's ABI.

VM introspection is the only use case I can think of that might possibly want to
emulate exception delivery in userspace, and VMI is a completely new set of APIs,
in no small part because supporting something like this in KVM would require far
more hooks than KVM provides.

> On top of that it is possible that pending excpetion is not intercepted by L1,
> but merged result is, so injecting the exception will cause nested VMexit,
> which is something that is hard for userspace to model.
> 
> I think that the cleanest way to do this is to add new ioctl, KVM_INJECT_EXCEPTION,
> which can do the right thing in the kernel, but I am not sure that it is worth it,
> knowing that thankfully userspace doesn't inject exceptions much.
> 
> > 
> > For #DB, I suspect it's a non-issue.  The exit is synchronous, so unless userspace
> > is deferring the reflection, which would be architecturally wrong in and of itself,
> > there can never be another pending exception. 
> Could very be, but still there could be corner cases. Like what if you set data fetch
> breakpoint on a IDT entry of some exception? I guess during delivery of that exception
> there might be #DB, but I am not 100% expert on when and how #DB is generated, so
> I can't be sure.

Data #DBs are trap-like.  The #DB will arrive after exception delivery completes,
i.e. will occur "on" the first instruction in the exception handler.
