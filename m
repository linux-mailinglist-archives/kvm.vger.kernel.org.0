Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719377207FC
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbjFBQ5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbjFBQ46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:56:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007A918D
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:56:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5692be06cb2so26813717b3.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685725014; x=1688317014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zOg4+l/DOJChc+nkZOWK9ss0MzzfNN2Nkg/r8MQpUK8=;
        b=laAI+NzOjPEt7adLhRNeGC5PTwPYDma4sqTfDHH2LuJZ8GYBZqqk0i5/AmrydXq6T7
         roWfE8qMGHFaFea9WTdR44rqoO7JEe6JBzhri7iO4G7BfeAAe3v1PAjj6j7WTL5/aeH/
         fTxuKmzOwxGfElUeL30wxSdyPJ5+BjBfbLdSr8jyE2T1rRfH76XWxINuVeCC2WEaJknU
         nGAmrWeCJMK3/LGD2xdF58gaDcsupHibI1JtxQE1piL+zYbjwc/gBtpUNWNSR69i0Wo+
         rbK83WGCNK3lPHtRX6m0hP4mFggfLywRf/sLb4IVj7xACylSg20nxJgOtRVPkFNa9RSG
         ch/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685725014; x=1688317014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zOg4+l/DOJChc+nkZOWK9ss0MzzfNN2Nkg/r8MQpUK8=;
        b=YRO1t56KGM1M0oVJW5JNGxh086nvYnihiGM9vDc8RhTX1ZHfvPNh5uXNd9BfwzlnUF
         0jZ8vTlFOu+wOtKSGZNEOhfyqXrWWvdXDV+EBZkVy77OV1rLmShyQ2epHylVZGsLo3Ce
         +4jvuod01SMzPAC2Qhh8fAAhDEl4JY1hsuOCoA3idLMban5CG5NeNiPCDOwod4vezEcR
         UE5Mv6XzsrsosW2GtMGsqsBQ+D9fiA5lMp4JKrHz6DzABGG8c+KCn7zwpT8K0z9RZbyB
         UBA3y4EyCSYzr0T/UWL5isyIIETxD38lAk0/H5m+lAOMphfZbcYm1Eomfx3SYvR8vDKK
         cA1A==
X-Gm-Message-State: AC+VfDyvicxvi25lBAlrPfmT10AwYLymqrSn9u+gMNMQv59oLkcxPI65
        vME9XcyAEsAMbrWbnzcguLZl0ryB1iI=
X-Google-Smtp-Source: ACHHUZ4ZXOip91E1lWsVMpNUj0KdBUUS7+scQ+ifNKdscSmerWX8Q/oVXM6rOmyp6dy9xV33ekhZ8wHADwM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:723:b0:bab:9391:470d with SMTP id
 l3-20020a056902072300b00bab9391470dmr1307718ybt.0.1685725014297; Fri, 02 Jun
 2023 09:56:54 -0700 (PDT)
Date:   Fri, 2 Jun 2023 09:56:52 -0700
In-Reply-To: <8f319a1e-a869-b666-b606-c0b4764ef7b1@rbox.co>
Mime-Version: 1.0
References: <20230307135233.54684-1-wei.w.wang@intel.com> <168565180722.660019.15543226381784798973.b4-ty@google.com>
 <8f319a1e-a869-b666-b606-c0b4764ef7b1@rbox.co>
Message-ID: <ZHofVKJxjaUxIDUN@google.com>
Subject: Re: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     dmatlack@google.com, mizhang@google.com, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, Wei Wang <wei.w.wang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023, Michal Luczaj wrote:
> On 6/2/23 03:20, Sean Christopherson wrote:
> > On Tue, 07 Mar 2023 21:52:33 +0800, Wei Wang wrote:
> >> Current KVM_BUG and KVM_BUG_ON assume that 'cond' passed from callers is
> >> 32-bit as it casts 'cond' to the type of int. This will be wrong if 'cond'
> >> provided by a caller is 64-bit, e.g. an error code of 0xc0000d0300000000
> >> will be converted to 0, which is not expected.
> >>
> >> Improves the implementation by using bool in KVM_BUG and KVM_BUG_ON.
> >> 'bool' is preferred to 'int' as __ret is essentially used as a boolean
> >> and coding-stytle.rst documents that use of bool is encouraged to improve
> >> readability and is often a better option than 'int' for storing boolean
> >> values.
> >>
> >> [...]
> > 
> > Applied to kvm-x86 generic, thanks!
> > 
> > [1/1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
> >       https://github.com/kvm-x86/linux/commit/c9d601548603
> 
> I guess this makes the !! in kvm_vm_ioctl_create_vcpu() unnecessary:
> 
> KVM_BUG_ON(!!xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0)...

Ya, I saw that, which in addition to Wei's ping, is what reminded me that the
KVM_BUG_ON() fix hadn't been merged.

> Is it worth a patch (perhaps along with chopping off !! in
> kvm_msr_allowed() and few other places)?

Yes, I think so.
