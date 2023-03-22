Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDA26C518A
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 18:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCVRCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 13:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCVRCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 13:02:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9E062B47
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:01:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e129-20020a251e87000000b00b56598237f5so20135384ybe.16
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679504511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s9gzetiVSIK/b5GBetbQBksIHa7p5BijP3hFfPNKXms=;
        b=g4HOsD30u/lkpIs1AR8yy27Bs5zSWM+LVq27z6F8K7ZyttcDBS3DvD1mq51/h9tsD4
         U3K+xWPDGYs7q5RT1Ltu6souvC/CCXfj06dp7uFfGcL4otyT39JemJrs+0JZoMkNixAX
         yccceXYSoiqaItu4LOtdhZGyjiZwOGgbJq36NmoXAaPADyvMZ3ej9rIdgDc2EG/3Xfsq
         ky5WGO0pUgvxNSVoMjdRM6w4GSVS28IdQFkXKGlB96I9s7irLP/GMOCFrSHqlUSnK51R
         rBdf0/r3OQkziQUVRVPJjYgm75TwSXyAdFYEXT1acLYUjzY59YisfTHZd/iLoorYwnHl
         Iq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679504511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s9gzetiVSIK/b5GBetbQBksIHa7p5BijP3hFfPNKXms=;
        b=mtQlvcdln7Nv5nndxU85haHF0PXkexFcUseXFLseN6LMTvV8dTFwLGVlMTKjdSv1OV
         SWZo3vDsklaV1ABT4mpwmTVCk16JUvVXJ1gGTU969dPfBfJBokY1CihM3jHitrayM2yj
         ZmtG2iQGdIQY3FK9hkcCydnepgYAQRxxs5uJJo+Hrd0Grch1ge8mTjj53NHNK7Z3uusA
         1VTXVPhyL35Dw31C1JpTPWkZUljTvqbzg0GOGi1PzeiD8xaq6/EJGzpqrI21bDexx5ne
         UVkEHzDHr4c2M20DKNWH5ELDHzTS4+wvvKbTMhie1vvNk0Byg9ljtETkndBnnrcb66Bs
         +veQ==
X-Gm-Message-State: AAQBX9dBwqgcyVRLkJciCRyjwSTD3RlhbyRMSoPOxMqlBIXoEG7Rtpuz
        J6savqg0ixTWJV68mxRKPYgdYsWBpnY=
X-Google-Smtp-Source: AKy350YMdTmQIMIKIDHL/AKlkLAf5Ddcwl0S0FaVZ8c/QVo4F35ev6mCmFRqlvQMGAiLU+VSBkNUbTAAFgY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b342:0:b0:52b:fd10:4809 with SMTP id
 r63-20020a81b342000000b0052bfd104809mr360572ywh.0.1679504510754; Wed, 22 Mar
 2023 10:01:50 -0700 (PDT)
Date:   Wed, 22 Mar 2023 10:01:49 -0700
In-Reply-To: <87355wralt.fsf@redhat.com>
Mime-Version: 1.0
References: <20230320185110.1346829-1-jpiotrowski@linux.microsoft.com>
 <ZBsqxeRDh+iV8qmm@google.com> <87355wralt.fsf@redhat.com>
Message-ID: <ZBs0fTo72LjnR22r@google.com>
Subject: Re: [PATCH] KVM: SVM: Flush Hyper-V TLB when required
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> > index cff838f15db5..d91e019fb7da 100644
> > --- a/arch/x86/kvm/svm/svm_onhyperv.h
> > +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> > @@ -15,6 +15,13 @@ static struct kvm_x86_ops svm_x86_ops;
> >  
> >  int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
> >  
> > +static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
> > +{
> > +	struct hv_vmcb_enlightenments *hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
> > +
> > +	return !!hve->hv_enlightenments_control.enlightened_npt_tlb;
> 
> In theory, we should not look at Hyper-V enlightenments in VMCB control
> just because our kernel has CONFIG_HYPERV enabled.

Oooh, right, because hv_enlightenments uses software reserved bits, and in theory
KVM could be running on a different hypervisor that uses those bits for something
completely different.

> I'd suggest we add a
> real check that we're running on Hyper-V and we can do it the same way
> it is done in svm_hv_hardware_setup()/svm_hv_init_vmcb():
> 
> 	return (ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
> 		&& !!hve->hv_enlightenments_control.enlightened_npt_tlb;

Jeremi, if you grab this, can you put the && on the previous line?  I.e.

	return (ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) &&
	       !!hve->hv_enlightenments_control.enlightened_npt_tlb;
