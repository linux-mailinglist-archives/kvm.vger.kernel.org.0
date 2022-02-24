Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8064C386D
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 23:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiBXWIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 17:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiBXWIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 17:08:50 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00E01A12B4
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 14:08:19 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id t11so4451208ioi.7
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 14:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q6lHX0lCrP+S4449NnzhhP32cPDoqkypHl+1JWHx810=;
        b=Oyx27mKGM0cLDdS6uKQeF76YYj23pbjWxjtjOaICcu2Lj2OhJbxIOs/0I9OzyZJV0W
         t1RLB02NRfU3tPCwCBFVXfw+vkQ/qY/ggCyFpmi7HFJG1EBhgk7qyyw3AGhedTghgREd
         zeIcS1TplAPupP8LeVvdUi3QyaTqyCffpOy9/45C4u3DzHjNlex4beQxwnSuHViqnemg
         2k8tA5CQT8XrGXstm+4g46lZbz65kxZCwCaHEPP3n6aRG1B4YJTs4D4ZE5y2Bvd82yOT
         WKPp18D9wFYpZfHyjr7gCbNbpZhVBcnz8lT9cyAOOLstTeeBJ0S/8tT0q0++vehjVS/n
         0/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q6lHX0lCrP+S4449NnzhhP32cPDoqkypHl+1JWHx810=;
        b=QXbRBN1o5EJOI/BtLglLaFaw+zq63Xy4S1VES/u/mCCncihGYztmJ6rP5WQaqWLYHT
         I6fmV24/rn5sw0EIZ0QTBEHk5+6dknu9IaY8Tcnv0+MBqDqTIxk2A5eBhpKKi/M+R9Kh
         IRH6RSibUY9BWgFxtD/aBHm5dCAfITRYnB/2YRsa3xMLQI0vT+JZAqHmOaXdnFnjVS5v
         bWAX1YmmhXCbiR/YhfZjqVLmPx8ylJmXyTtKkUiLtl6kY7t+91efMszQNImOxYov+YCw
         R34EjweXXI+gSJ7Qtm2Aq8/vvFp+A5jFuYKwkV1ITs1ufe5NRotbf/S/Ph8XApt5TGew
         4rAg==
X-Gm-Message-State: AOAM530/O3oCA2DCr+g4BBThS10TSzel5Kt+NPNILUJLfUum+X0W+znI
        gk91rDy382fcLD+Up8dWHhPnXA==
X-Google-Smtp-Source: ABdhPJwu5tYazKcXYm4627JinNrrsf79YktfSdYDIKLZNIrO/xikidBHRgbS8ggDs+TColwm0EsOnQ==
X-Received: by 2002:a05:6638:22c3:b0:30f:88b:e546 with SMTP id j3-20020a05663822c300b0030f088be546mr3649914jat.247.1645740498998;
        Thu, 24 Feb 2022 14:08:18 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id c8-20020a056e020cc800b002bf717f64e3sm533782ilj.28.2022.02.24.14.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 14:08:18 -0800 (PST)
Date:   Thu, 24 Feb 2022 22:08:15 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v3 06/19] KVM: arm64: Track vCPU power state using MP
 state values
Message-ID: <YhgBz1/cgpoS3HuD@google.com>
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-7-oupton@google.com>
 <87y2202y8f.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2202y8f.wl-maz@kernel.org>
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

Hi Marc,

On Thu, Feb 24, 2022 at 01:25:04PM +0000, Marc Zyngier wrote:

[...]

> > @@ -190,7 +190,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
> >  	 * re-initialized.
> >  	 */
> >  	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> > -		tmp->arch.power_off = true;
> > +		tmp->arch.mp_state = KVM_MP_STATE_STOPPED;
> >  	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> >  
> >  	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> 
> You also may want to initialise the mp_state to RUNNABLE by default in
> kvm_arch_vcpu_create(). We are currently relying on power_off to be
> false thanks to the vcpu struct being zeroed, but we may as well make
> it clearer (RUNNABLE is also 0, so there is no actual bug here).

We unconditionally initialize power_off in
kvm_arch_vcpu_ioctl_vcpu_init(), and do the same in this patch for mp_state,
depending on if KVM_ARM_VCPU_POWER_OFF is set.

Any objections to leaving that as-is? I can move the RUNNABLE case into
kvm_arch_vcpu_create() as you've suggested, too.

--
Thanks,
Oliver
