Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C865890DE
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 19:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbiHCRAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 13:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiHCRAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 13:00:33 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80182AEF
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 10:00:31 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q16so15646559pgq.6
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 10:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=fhbd9DQJ5D6KXAxH6rPNWphudRMxo7FuUfGNTHo4u9E=;
        b=rPbZqOsAXcAEpup8KYY+VxUphb2xjMzZFqapiuN5pUFkOvsoVd/Igmcm7tOt63U5JB
         shrZP2YQLPYg08a4TP4F+X9e3iI7BRvnxouDtn1zFpx6QXFtyGrUNnBdPakYRtbIIxpo
         SnLjCWBja2N3vnnvbdE75nsb+7N9l+0b310thhZS6aCKYq1hPB3sXHEUEEi2snNIWHO7
         FgQm+Tk6eCgPnmlEncrBrk0fhUuApKKWWpDFxxexQmhqZSqIHsBIEM9M91kxqNiIbTEP
         tq+AgqlJjA9291+qEe+RDzdhOYtcJGGhShKmCxLkdgfU6KL+9MwsI8dpCdFdbIBolW+k
         ctkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fhbd9DQJ5D6KXAxH6rPNWphudRMxo7FuUfGNTHo4u9E=;
        b=Wfbmk+fdLTHMxf+xtl36Ic5gWuCQVrzzhr/0PmjGJ4Z2fmdnriCi3+6oArlQkpdxPl
         ZpEh6yGCQOm/CHIEDjWGKHd56T8tdIkslk/p5ln0BWOKJrZOxoqtQkBtoWvw6mUn6uCd
         uUKhQRs3vkq81U6wuI+RHHAW3Nvy/Q68I1H9YpRExNC4u/bvTT+LCJtJ7G13hReyhAqz
         18ppIWsABt/HBBWWErdyVwfWcJk/HAFIgZTCjEddUGh63ybDqw+ddifaDvgQHJYHu280
         GfNOOHzgUFnR7VtqAPsSF7TQ0gUdMtg44kxr8kmT7CRQE31jM4KrtI6BBfQatjYM0AlD
         gsfw==
X-Gm-Message-State: AJIora9EKtFfpLfGRRF8njV3JaTZo5xlgDPictkKiIxOYpwCdO2edV18
        LkarKM3mwvoGe2Hx82DqzCSMUw==
X-Google-Smtp-Source: AGRyM1smChntT6s3YdLIZiLzo4pEZXGS87emXegzZ85GtPVH6Ycah2LcWBmPta599eYePi0F1rU5Uw==
X-Received: by 2002:a65:42c8:0:b0:41a:8138:f47f with SMTP id l8-20020a6542c8000000b0041a8138f47fmr21839456pgp.476.1659546030504;
        Wed, 03 Aug 2022 10:00:30 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id q25-20020aa79839000000b0052deda6e3d2sm3901576pfl.98.2022.08.03.10.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 10:00:30 -0700 (PDT)
Date:   Wed, 3 Aug 2022 17:00:26 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending
 interrupts
Message-ID: <Yuqpqr/aE6KN5MLv@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-2-mizhang@google.com>
 <060419e118445978549f0c7d800f96a9728c157c.camel@redhat.com>
 <YuqmKkxEsDwBvayo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuqmKkxEsDwBvayo@google.com>
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

On Wed, Aug 03, 2022, Mingwei Zhang wrote:
> On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-08-02 at 23:07 +0000, Mingwei Zhang wrote:
> > > From: Oliver Upton <oupton@google.com>
> > > 
> > > vmx_guest_apic_has_interrupts implicitly depends on the virtual APIC
> > > page being present + mapped into the kernel address space. However, with
> > > demand paging we break this dependency, as the KVM_REQ_GET_VMCS12_PAGES
> > > event isn't assessed before entering vcpu_block.
> > > 
> > > Fix this by getting vmcs12 pages before inspecting the guest's APIC
> > > page. Note that upstream does not have this issue, as they will directly
> > > get the vmcs12 pages on vmlaunch/vmresume instead of relying on the
> > > event request mechanism. However, the upstream approach is problematic,
> > > as the vmcs12 pages will not be present if a live migration occurred
> > > before checking the virtual APIC page.
> > 
> > Since this patch is intended for upstream, I don't fully understand
> > the meaning of the above paragraph.
> 
> My apology. Some of the statement needs to be updated, which I should do
> before sending. But I think the point here is that there is a missing
> get_nested_state_pages() call here within vcpu_block() when there is the
> request of KVM_REQ_GET_NESTED_STATE_PAGES.
> 
> > 
> > 
> > > 
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 5366f884e9a7..1d3d8127aaea 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -10599,6 +10599,23 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
> > >  {
> > >  	bool hv_timer;
> > >  
> > > +	/*
> > > +	 * We must first get the vmcs12 pages before checking for interrupts
> > > +	 * that might unblock the guest if L1 is using virtual-interrupt
> > > +	 * delivery.
> > > +	 */
> > > +	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> > > +		/*
> > > +		 * If we have to ask user-space to post-copy a page,
> > > +		 * then we have to keep trying to get all of the
> > > +		 * VMCS12 pages until we succeed.
> > > +		 */
> > > +		if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> > > +			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > > +			return 0;
> > > +		}
> > > +	}
> > > +
> > >  	if (!kvm_arch_vcpu_runnable(vcpu)) {
> > >  		/*
> > >  		 * Switch to the software timer before halt-polling/blocking as
> > 
> > 
> > If I understand correctly, you are saying that if apic backing page is migrated in post copy
> > then 'get_nested_state_pages' will return false and thus fail?
> 
> What I mean is that when the vCPU was halted and then migrated in this
> case, KVM did not call get_nested_state_pages() before getting into
> kvm_arch_vcpu_runnable(). This function checks the apic backing page and
> fails on that check and triggered the warning.
> > 
> > AFAIK both SVM and VMX versions of 'get_nested_state_pages' assume that this is not the case
> > for many things like MSR bitmaps and such - they always uses non atomic versions
> > of guest memory access like 'kvm_vcpu_read_guest' and 'kvm_vcpu_map' which
> > supposed to block if they attempt to access HVA which is not present, and then
> > userfaultd should take over and wake them up.
> 
> You are right here.
> > 
> > If that still fails, nested VM entry is usually failed, and/or the whole VM
> > is crashed with 'KVM_EXIT_INTERNAL_ERROR'.
> > 

Ah, I think I understand what you are saying. hmm, so basically the
patch here is to continuously request vmcs12 pages if failed. But what
you are saying is that we just need to call 'get_nested_state_pages'
once. If it fails, then the VM fails to work. Let me double check and
get back.

> > Anything I missed? 
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
