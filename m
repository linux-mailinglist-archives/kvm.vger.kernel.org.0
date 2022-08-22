Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928E959C464
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 18:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiHVQuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 12:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiHVQuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 12:50:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF46B167CA
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 09:50:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so14546840pjj.4
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 09:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=YCUb29U7ueKm8lDxo3bX5HZtnKqRa+bl+Jwo6C09d/w=;
        b=hmaYfkUYxxpsJikrrGUf5nV6qCZ+5zqAWPwh19taLTgqxNk/04bvHILaHLShsSrJeT
         vUA0ynppIa4yDX4K4PGXUUMxoE6yGC2YP5hR93eZ/gQanqR+Ihn1uetQthctFbIQ1BAn
         HT69+OI4PegU7GlVWkUHqlJoM+R9jF1xzW6cDfPmdgoKaLYOPIvvUY645eJ5m1pxIvPp
         TpBBxwr/zem44vy1Sg5q7aH6XnopsRoP7o5fQcsobkqKqBMYxdi+eHbYDbA80cbVfMgZ
         WNuLcOoXrbV//xDjcf1o387frXd2hntRIlZGALGCO99rJaPmgl/BqmY2Q3v5tnG03cVa
         awFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=YCUb29U7ueKm8lDxo3bX5HZtnKqRa+bl+Jwo6C09d/w=;
        b=ie3ixhhQDuIF5lKw6S+T/4PNNHxwt3FlHZAQFcXGL3av7/N+jdZF/rckT0x2eE5apH
         gXRvA8VLP9m6jCcSjxunD60A7kO0/BTuw0UtDMDO+lm/1UwOodjjMIOz+7rkAxh9eYvk
         6TmozTVMJhBNMiv1b3yyyh8/aTIjU9mQvtHzQQ9gXV374ijGEA6y7OyiFmKXOziTVF9v
         12Yng0RNaYs6ZrlB1Euth91LtwkcjqAuN9yNvHWGsh+VlEJNl8MQY9jxuFVpA9EbmO/9
         kEe4fOlYJ387ZQq+rsdu9Q5PCah2eEOYx+xggKJy0NqVo7VDBA2gSKSOJzEytO5i714s
         GCsg==
X-Gm-Message-State: ACgBeo0a+8r9S6Fe4MTCCBlmyf0a+KNQSZF7ay1l3g3SnrDqqMX1uqnJ
        eUSmkEoGd3VW0m0KPO7v8w4P3Wjbt4hL9g==
X-Google-Smtp-Source: AA6agR79nW5rPKOD9DWavuVdySV+shyFKjsmzqMC8PFtXIf5own2pA/eDZmGSL61O2X7Gsr0RqxMrQ==
X-Received: by 2002:a17:90b:281:b0:1fb:151b:b5cf with SMTP id az1-20020a17090b028100b001fb151bb5cfmr9905672pjb.166.1661187017335;
        Mon, 22 Aug 2022 09:50:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v2-20020a626102000000b005361708275fsm6510422pfb.217.2022.08.22.09.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 09:50:16 -0700 (PDT)
Date:   Mon, 22 Aug 2022 16:50:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/26] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
Message-ID: <YwOzxYLMeFuN23W+@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-10-vkuznets@redhat.com>
 <Yv5zn4qTl0aiaQvh@google.com>
 <87sflssllu.fsf@redhat.com>
 <Yv/CME8B1ueOMY5M@google.com>
 <87ilmkslzd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilmkslzd.fsf@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > But that also raises the question of whether or not KVM should honor hyperv_enabled
> > when filtering MSRs.  Same question for nested VM-Enter.  nested_enlightened_vmentry()
> > will "fail" without an assist page, and the guest can't set the assist page without
> > hyperv_enabled==true, but nothing prevents the host from stuffing the assist page.
> 
> The case sounds more like a misbehaving VMM to me. It would probably be
> better to fail nested_enlightened_vmentry() immediately on !hyperv_enabled.

Hmm, sort of.  If KVM fails explicitly fails nested VM-Enter, then allowing the
guest to read the VMX MSRs with the same buggy setup is odd, e.g. nested VMX is
effectively unsupported at that point since there is nothing the guest can do to
make nested VM-Enter succeed.  Extending the "fail VM-Enter" behavior would be to
inject #GP on RDMSR, and at that point KVM is well into "made up architecture"
behavior.

All in all, I don't think it's worth forcing the issue, even though I do agree that
the VMM is being weird if it's enabling KVM_CAP_HYPERV_ENLIGHTENED_VMCS but not
advertising Hyper-V.

> > If we fix the kvm_hv_set_cpuid() allocation failure, then we can also guarantee
> > that vcpu->arch.hyperv is non-NULL if vcpu->arch.hyperv_enabled==true.  And then
> > we can add gate guest eVMCS flow on hyperv_enabled, and evmcs_get_unsupported_ctls()
> > can then WARN if hv_vcpu is NULL.
> >
> 
> Alternatively, we can just KVM_BUG_ON() in kvm_hv_set_cpuid() when
> allocation fails, at least for the time being as the VM is likely
> useless anyway.

I'd prefer not to use KVM_BUG_ON() in this case.  A proper fix isn't that much
more code, and this isn't a KVM bug unless we conciously make it one :-)

> > Assuming I'm not overlooking something, I'll fold in yet more patches.
> >
> 
> Thanks for the thorough review here and don't hesitate to speak up when
> you think it's too much of a change to do upon queueing)

Heh, this definitely snowballed beyond "fixup on queue".  Let's sort out how to
address the filtering issue and then decide how to handle v6.
