Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C28673D50
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 16:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjASPT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 10:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjASPTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 10:19:25 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B0B82D41
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 07:19:24 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r18so1744813pgr.12
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 07:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=COC0cQf3RM+28HjrZuFfI8U9iEnmOUqpakV5+y8hXro=;
        b=iYhnq31FqaCsdLQsRmrrrSLPknKuzg5EDi5FnG0XJsMCKleZzOOmIahMB3jDftuROY
         H59Ix3pMjUGC32cz0psGxHXSEcTHd8pi8Qrq+kL8J6jfZ8xhUtDMh+Tzue4FsbiOkW3y
         URS8YujQKNW9cPaYrDJPmzT15CUqXfqdqGhoCrQgkaPR9Ed8OGrN+9NyH3H7m/5QBEWV
         hIkBu9SKzujHSZQFK9WfBMq0uvlOQq4I2fvhIczyLYxMGFewOAWWJfkfA27Q1PUGyPZi
         3iQ2BSwglss6M0QPQ5mSnVR3fNPSvjfiFE54E9yOscLqQ2KH5BZGDbWYFbMsy5huTIVf
         XMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=COC0cQf3RM+28HjrZuFfI8U9iEnmOUqpakV5+y8hXro=;
        b=oFafH28nTod7u9rTkf2JJhwqDauEHErFAcRVneRZYtGHwJwFqsSmiCw8nWQchFYe7D
         jj7SbN1MSElNXJsn+1cb34xJFtD5aoYj1vaVAO1WQFmzdSMAuwnj/Nmn+DwFXntYAz+B
         zT67eSN6nWscnWjs+bQNAJdAgjBJaPYpYBhSlcXFb5655xsdwQOVF1Uco4PLOwgICxaJ
         Wz24y4OlpsugfS804oaZhx1phDXtGYprVxK6st6Ox4ot+hHTDAMlSOjs4yxWaNztYHrW
         V1ejOBIdpYAr9puzBYvLj6KHtH6jVVsZJMwbUrcBZ3uIkTxxI4rOp7ioTb1S6LoQuHIq
         ohWA==
X-Gm-Message-State: AFqh2kpyboL6oV93hQgYIg+fdhMB2sYJxloNLKP4rsdFpUej9o0QQfM0
        xcDgcvgwJRfy2u/8MjOEDY0qXg==
X-Google-Smtp-Source: AMrXdXsUJCiHv+x8er4RQjqeSGm7p768nE4Z3fEvWZooodpyJRG2iLwFsWL/7iAU6pOKxpq0PgMGhQ==
X-Received: by 2002:aa7:9041:0:b0:58b:cb1b:978f with SMTP id n1-20020aa79041000000b0058bcb1b978fmr1888929pfo.1.1674141562945;
        Thu, 19 Jan 2023 07:19:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x2-20020aa79a42000000b0058d9730ede0sm8638923pfj.210.2023.01.19.07.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 07:19:22 -0800 (PST)
Date:   Thu, 19 Jan 2023 15:19:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, corbet@lwn.net,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        ardb@kernel.org, peterx@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH 4/4] KVM: Improve warning report in
 mark_page_dirty_in_slot()
Message-ID: <Y8lfdgcjLvtgII2a@google.com>
References: <20230116040405.260935-1-gshan@redhat.com>
 <20230116040405.260935-5-gshan@redhat.com>
 <Y8bBzKF17IdZP9eF@google.com>
 <d8e63ad9-e0e3-dbb1-b646-a1b5771d4c4b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8e63ad9-e0e3-dbb1-b646-a1b5771d4c4b@redhat.com>
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

On Thu, Jan 19, 2023, Gavin Shan wrote:
> Hi Sean,
> 
> On 1/18/23 2:42 AM, Sean Christopherson wrote:
> > On Mon, Jan 16, 2023, Gavin Shan wrote:
> > > There are two warning reports about the dirty ring in the function.
> > > We have the wrong assumption that the dirty ring is always enabled when
> > > CONFIG_HAVE_KVM_DIRTY_RING is selected.
> > 
> > No, it's not a wrong assumption, becuase it's not an assumption.  The intent is
> > to warn irrespective of dirty ring/log enabling.  The orignal code actually warned
> > irrespective of dirty ring support[1], again intentionally.  The
> > CONFIG_HAVE_KVM_DIRTY_RING check was added because s390 can mark pages dirty from
> > an worker thread[2] and s390 has no plans to support the dirty ring.
> > 
> > The reason for warning even if dirty ring isn't enabled is so that bots can catch
> > potential KVM bugs without having to set up a dirty ring or enable dirty logging.
> > 
> > [1] 2efd61a608b0 ("KVM: Warn if mark_page_dirty() is called without an active vCPU")
> > [2] e09fccb5435d ("KVM: avoid warning on s390 in mark_page_dirty")
> > 
> 
> Thanks for the linker. I was confused when looking at the code, but now it's clear to
> me. Thanks for your explanation. How about to add a comment there?
> 
>   /*
>    * The warning is expected when the dirty ring is configured,
>    * but not enabled.
>    */

That's not correct either.  By design, the warning can also fire if the dirty ring
is enabled.  KVM's rule is that writes to guest memory always need to be done in
the context of a running vCPU, with the recently added exception of
kvm_arch_allow_write_without_running_vcpu().  That intent of the warning is to
enforce that rule regardless of the state of the VM.

Concretely, I think you can just drop patches 3 and 4, and just fix the arm64 issues.
