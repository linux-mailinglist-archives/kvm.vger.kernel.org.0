Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0744794444
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 22:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbjIFUIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 16:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbjIFUIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 16:08:34 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2BB1997
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 13:08:29 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68a3b41fa66so314063b3a.2
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 13:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694030909; x=1694635709; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oBtIgZl1ms5fC0VvHcL+Q3mCBoxVdMVA1BmpLPYDsb8=;
        b=hs69AfxoOPjmdGbfLu887VoPV0tR5f716UiQ7Lr4c5elll96tp80CJE2vha9rrehOr
         oWDb3yKE7T092l9utTuyqtRlQQ/vFtySynDMyMLFwht2ATiE/LalWLrodNmFy229I2B2
         8KbAFGoPRvrhO7NBm9x17DAgms3DEw3xVxAzMlsS//of34T1N6ZhWf7NBh+XUkVVPoiE
         4K3gL+ZIIDlJvThJ+OMVGMaPbMWMyQFX5cOjNaUhmamtOQ3p1iHDsMuxtUwwgKXO6cHB
         X28cUuKCNq/xC5er+y2/mYZhEdvfW54dx+AVXSoWIeKa8Oc/oSvpfedl0n7XpC3joT06
         sfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694030909; x=1694635709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBtIgZl1ms5fC0VvHcL+Q3mCBoxVdMVA1BmpLPYDsb8=;
        b=Y/R3JpZmGsPHKxfFOT3qmRm7QRxz23gc0GUaxLLA6+LDCw9yNNWue3QjNquLpUQMMd
         CbN/A26odIHjq5Cq3AVK5wHbMR7KdHOpQbozwIAD7XyTjmqNh9SOMyDp8yfqle/ctEeW
         f+TAXuZwBlu+SvgjCBLiZJfMt1PFuMEbswbzEh4Frzb7Aj7UAQeyWtT5RlYquW/ew1eq
         UmNNwvGEvnvQLy3tLG1OOazyXz4m5E5Em2oRpkjxcU64QsoEupT9da3AYd4HfB0IfsWw
         zkHW81B7n6yR1w5O5Xwc80Mqz8t9bPJHQRUZTEVXzFhwfH0QDIO8RxJ6NyoCQXz2HOBy
         pbvg==
X-Gm-Message-State: AOJu0Yx3oZNwXC34zKkGRLcsRJ+hAWup5cNWJpWCov5p7lNkN0Xvys3b
        M4UKyGOvNiWx1A5pmBvx3ZT2IGkoR5g=
X-Google-Smtp-Source: AGHT+IFSk0M46Pz8MoaYiFpqpBPwiY5U6p475LaEet0bYsUgS14XKHdC+RnyK9LNko9huZyr4AB5W2XG1Lw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4186:b0:68e:37ea:4f16 with SMTP id
 ca6-20020a056a00418600b0068e37ea4f16mr404435pfb.0.1694030909345; Wed, 06 Sep
 2023 13:08:29 -0700 (PDT)
Date:   Wed, 6 Sep 2023 13:08:27 -0700
In-Reply-To: <10bdaf6d-1c5c-6502-c340-db3f84bf74a1@intel.com>
Mime-Version: 1.0
References: <CAPm50aLd5ZbAqd8O03fEm6UhHB_svfFLA19zBfgpDEQsQUhoGw@mail.gmail.com>
 <10bdaf6d-1c5c-6502-c340-db3f84bf74a1@intel.com>
Message-ID: <ZPjcO/N54pvhLjSz@google.com>
Subject: Re: [PATCH] KVM: X86: Reduce calls to vcpu_load
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Hao Peng <flyingpenghao@gmail.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, Xiaoyao Li wrote:
> On 9/6/2023 2:24 PM, Hao Peng wrote:
> > From: Peng Hao <flyingpeng@tencent.com>
> > 
> > The call of vcpu_load/put takes about 1-2us. Each
> > kvm_arch_vcpu_create will call vcpu_load/put
> > to initialize some fields of vmcs, which can be
> > delayed until the call of vcpu_ioctl to process
> > this part of the vmcs field, which can reduce calls
> > to vcpu_load.
> 
> what if no vcpu ioctl is called after vcpu creation?
> 
> And will the first (it was second before this patch) vcpu_load() becomes
> longer? have you measured it?

I don't think the first vcpu_load() becomes longer, this avoids an entire
load()+put() pair by doing the initialization in the first ioctl().

That said, the patch is obviously buggy, it hooks kvm_arch_vcpu_ioctl() instead
of kvm_vcpu_ioctl(), e.g. doing KVM_RUN, KVM_SET_SREGS, etc. will cause explosions.

It will also break the TSC synchronization logic in kvm_arch_vcpu_postcreate(),
which can "race" with ioctls() as the vCPU file descriptor is accessible by
userspace the instant it's installed into the fd tables, i.e. userspace doesn't
have to wait for KVM_CREATE_VCPU to complete.

And I gotta imagine there are other interactions I haven't thought of off the
top of my head, e.g. the vCPU is also reachable via kvm_for_each_vcpu().  All it
takes is one path that touches a lazily initialized field for this to fall apart.

> I don't think it worth the optimization unless a strong reason.

Yeah, this is a lot of subtle complexity to shave 1-2us.
