Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2383E5B0924
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiIGPs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiIGPs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:48:26 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E1ABB002
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 08:48:23 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id s14so5406426plr.4
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 08:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=/kPSWel6mobLfUIPD82aMK7TVuiyZeYuc3xqvzKcSuE=;
        b=qmCNpHSx7oMT5E8bHSuoHnFgMqmTqMzbeDgsLX9BkR1z+KMoW5hzZIHMaBfZJsaOxJ
         Yl0l9/C9Jcn9iWO7FfYmZ+ANS+1i0aT5v2LKHY24Mr4s/W/ut3YHwIcn6Osg4NwrRv6b
         UNEYvl0Q0f80fy8D5hzdNQ5KHLjUTFB0a46NTc3/TKXHcQV6CuZAiDZ4DPbHpQwiJuYH
         5zYYPdU9lpAx9qb4krs1P+LMZxujdCMMNGYiZnsen11pdaHZm1PkN4m96QrxEzGUWBxy
         pR884dXngnJjjQdlfXxIjIvx90AUO08BWUpuHP77sLHfLk236EFxqC+xBDeKssn2xTJH
         AKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/kPSWel6mobLfUIPD82aMK7TVuiyZeYuc3xqvzKcSuE=;
        b=Jx4Yr0h8yS+hgvnatUoO42gbK47qstP3IeVWEerAaXkkuLDkGTyLLMu00BYaOfa7M8
         m4Q83Tub9YtkXWrSGkw56K8niVj2XAKSIukzc24icJzsVupwwU8wb1SvdZP4I/pbnFOE
         hkgi6r0WXb8SWZFS8KMq33iFVRBZdeCU7ySUy17wbptIbhyG63KG46azvXtOA38EWPwd
         NxL6P9plQg6EMU6yC/eNrjTTMe3VQW7/+jTBJ/gu0jGzk36dzyyYHWUPK7l/UT+wtmuA
         1Oq5EWmQTFQUVpBMX2Er6sHN4BHPT9hkY0o4jZtR1DmUo6B/uU+n/dhp+Y4Tqb30O6C3
         Kmzg==
X-Gm-Message-State: ACgBeo1YUOSwwKMFPTZwHd7p5gLvhYi6FQ1VTnAEQu/NmGLkSFG1abcc
        wHXztLcSuoP5I/tBsUO03vge/UfY45Lxyg==
X-Google-Smtp-Source: AA6agR5eOWOiHyn0TqvZYrl0cXhsJg64L8mJ6VV4UNfFTV1WWSN+P6AoiStBDmSZ1E28ipnZV8eUBw==
X-Received: by 2002:a17:90b:4a8e:b0:1fe:1df3:bb11 with SMTP id lp14-20020a17090b4a8e00b001fe1df3bb11mr4599947pjb.22.1662565702390;
        Wed, 07 Sep 2022 08:48:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090264c100b00172b87d97cbsm4487356pli.67.2022.09.07.08.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:48:21 -0700 (PDT)
Date:   Wed, 7 Sep 2022 15:48:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: move the event handling of
 KVM_REQ_GET_VMCS12_PAGES into a common function
Message-ID: <Yxi9QRziGl2YhNuB@google.com>
References: <20220828222544.1964917-1-mizhang@google.com>
 <20220828222544.1964917-2-mizhang@google.com>
 <YwzkvfT0AiwaojTx@google.com>
 <20220907025042.hvfww56wskwhsjwk@yy-desk-7060>
 <CAL715WJK1WwXFfbUiMjngV8Z-0jyu_9JeZaK4qvvdJfYvtQEYg@mail.gmail.com>
 <20220907053523.qb7qsbqfgcg2d2vx@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907053523.qb7qsbqfgcg2d2vx@yy-desk-7060>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022, Yuan Yao wrote:
> On Tue, Sep 06, 2022 at 09:26:33PM -0700, Mingwei Zhang wrote:
> > > > @@ -10700,6 +10706,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
> > > >               if (kvm_cpu_has_pending_timer(vcpu))
> > > >                       kvm_inject_pending_timer_irqs(vcpu);
> > > >
> > > > +             if (vcpu->arch.nested_get_pages_pending) {
> > > > +                     r = kvm_get_nested_state_pages(vcpu);
> > > > +                     if (r <= 0)
> > > > +                             break;
> > > > +             }
> > > > +
> > >
> > > Will this leads to skip the get_nested_state_pages for L2 first time
> > > vmentry in every L2 running iteration ? Because with above changes
> > > KVM_REQ_GET_NESTED_STATE_PAGES is not set in
> > > nested_vmx_enter_non_root_mode() and
> > > vcpu->arch.nested_get_pages_pending is not checked in
> > > vcpu_enter_guest().
> > >
> > Good catch. I think the diff won't work when vcpu is runnable.

It works, but it's inefficient if the request comes from KVM_SET_NESTED_STATE.
The pending KVM_REQ_UNBLOCK that comes with the flag will prevent actually running
the guest.  Specifically, this chunk of code will detect the pending request and
bail out of vcpu_enter_guest().

	if (kvm_vcpu_exit_request(vcpu)) {
		vcpu->mode = OUTSIDE_GUEST_MODE;
		smp_wmb();
		local_irq_enable();
		preempt_enable();
		kvm_vcpu_srcu_read_lock(vcpu);
		r = 1;
		goto cancel_injection;
	}

But the inefficiency is a non-issue since "true" emulation of VM-Enter will flow
through this path (the VMRESUME/VMLAUNCH/VMRUN exit handler runs at the end of
vcpu_enter_guest().

> > It only tries to catch the vcpu block case. Even for the vcpu block case,
> > the check of KVM_REQ_UNBLOCK is way too late. Ah, kvm_vcpu_check_block() is
> > called by kvm_vcpu_block() which is called by vcpu_block(). The warning is
> > triggered at the very beginning of vcpu_block(), i.e., within
> > kvm_arch_vcpu_runnable(). So, please ignore the trace in my previous email.
> >
> > In addition, my minor push back for that is
> > vcpu->arch.nested_get_pages_pending seems to be another
> > KVM_REQ_GET_NESTED_STATE_PAGES.
> 
> Yeah, but in concept level it's not a REQ mask lives in the
> vcpu->requests which can be cached by e.g. kvm_request_pending().
> It's necessary to check vcpu->arch.nested_get_pages_pending in
> vcpu_enter_guest() if Sean's idea is to replace
> KVM_REQ_GET_NESTED_STATE_PAGES with nested_get_pages_pending.

Yes, they key is that it's not a request.  Requests have implicit properties:
e.g. as above, effectively prevent running the vCPU until the request goes away,
they can be pended from other vCPUs, etc...  And the property that is most relevant
to this bug: except for special cases, requests only need to be serviced before
running vCPU.

And the number of requests is limited due to them being stored in a bitmap.  x86
still has plenty of room due to kvm_vcpu.requests being a u64, but it's still
preferable to avoid using a request unless absolutely necessary.

For this case, since using a request isn't strictly needed and using a request
would require special casing that request, my strong preference is to not use a
request.

So yes, my idea is to "just" replace the request with a flag, but there are subtly
quite a few impliciations in not using a request.
