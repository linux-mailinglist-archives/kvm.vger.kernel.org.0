Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295064F54E8
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiDFFVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1849509AbiDFCig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 22:38:36 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF99289FA2
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 16:44:54 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s21so726470pgs.4
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 16:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qPGFyn3NlhtdM0CB2XMTbA0Uo1oxIfOYwzOJo7Agi4U=;
        b=LepKXMSWMmLTJMx/RVIVgA8Ej9I2cpV6nhMtHtbLF3ypiQIRCuglxwR1xPwT/OF2DU
         2m1eHvrUvwtxfhySbsR2o2XcXy1BvnPsplzp7tiYgRWCfmwGmZJz7n3CfaJhxpZNfUzS
         4eVAqxclqskG4diyD/E8CQCoPLcVWWMwsO3oKoLsPT8DiRnyUIZyREIun3Mm4wbi/QVq
         SeMU9ojc3ROCsGTdUyDwJgylaf9w/q0h1GWcLY1NKWAcAohNu3ZkyLxAudkN8Q4tHPNR
         tH32YHsuxImOHfKdewI6lY3cIWEhd74B5kAhfKdP/qD7rELab5GD7kpcHiW7lbsPp06t
         wrjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qPGFyn3NlhtdM0CB2XMTbA0Uo1oxIfOYwzOJo7Agi4U=;
        b=GPNRayQqTW6wjqnFDAkpzrJhLCHTl2Uk68s+7FPBTU/cAkBNGDGlpIivE10IJOTEHY
         hiNeWL+jmS5ZbF62c8t5yjewdz46E7MGb3cQHM/HpHQ8mli+lGsm/CVeD6n6WXziWpzE
         myy2zmQIHFS/yamd6kYDTPQtFE6WC5b0PtkomjsU0dsko/SDT5uY0Qh+n9f3ukvSz0KU
         ikkphreNsILcCcnUuyLsev4tjLtv6TIV8SZk4OjN8queSf0WcFMktkwtFBDqVaY1+hKA
         tbda6Lq8iLFWEopUm8Sb6Vc/mqpKSqd+jpu7UR/Y4MI5P2g4I+IxnWwoGhVtYfllN382
         Y1+A==
X-Gm-Message-State: AOAM5337lyDgqBRTAzXMe3Qk7mmgEOGntsTJnJfyzog4olfdmjNTpQBX
        CreeIu3TzIFj3icmYnn5D23jEj4llWHTHA==
X-Google-Smtp-Source: ABdhPJySJ035zgZ6xzFWLjkm7h6F+Ek4V/GT1gQlZSLw6ceUS6ENxczqOl6xJXsVR//c/6Lk2GK7YQ==
X-Received: by 2002:a05:6a00:b8e:b0:4fa:de88:9fc7 with SMTP id g14-20020a056a000b8e00b004fade889fc7mr5909203pfj.56.1649202293563;
        Tue, 05 Apr 2022 16:44:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm16741813pfu.56.2022.04.05.16.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 16:44:53 -0700 (PDT)
Date:   Tue, 5 Apr 2022 23:44:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] KVM: X86: Save&restore the triple fault request
Message-ID: <YkzUceG4rhw15U3i@google.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-2-chenyi.qiang@intel.com>
 <YkzRSHHDMaVBQrxd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkzRSHHDMaVBQrxd@google.com>
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

On Tue, Apr 05, 2022, Sean Christopherson wrote:
> On Fri, Mar 18, 2022, Chenyi Qiang wrote:
> > @@ -4976,6 +4980,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> >  		}
> >  	}
> >  
> > +	if (events->flags & KVM_VCPUEVENT_TRIPLE_FAULT)
> > +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > +
> >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> 
> Looks correct, but this really needs a selftest, at least for the SET path since
> the intent is to use that for the NOTIFY handling.  Doesn't need to be super fancy,
> e.g. do port I/O from L2, inject a triple fault, and verify L1 sees the appropriate
> exit.
> 
> Aha!  And for the GET path, abuse KVM_X86_SET_MCE with CR4.MCE=0 to coerce KVM into
> making a KVM_REQ_TRIPLE_FAULT, that way there's no need to try and hit a timing
> window to intercept the request.

Drat, I bet that MCE path means the WARN in nested_vmx_vmexit() can be triggered
by userspace.  If so, this patch makes it really, really easy to hit, e.g. queue the
request while L2 is active, then do KVM_SET_NESTED_STATE to force an "exit" without
bouncing through kvm_check_nested_events().

  WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu))

I don't think SVM has a user-triggerable WARN, but the request should still be
dropped on forced exit from L2, e.g. I believe this is the correct fix:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9a6dc2b38fcf..18c5e96b12a5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1128,6 +1128,7 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
        if (is_guest_mode(vcpu)) {
                svm->nested.nested_run_pending = 0;
                svm->nested.vmcb12_gpa = INVALID_GPA;
+               kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 
                leave_guest_mode(vcpu);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f18744f7ff82..0587ef647553 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6276,6 +6276,7 @@ void vmx_leave_nested(struct kvm_vcpu *vcpu)
 {
        if (is_guest_mode(vcpu)) {
                to_vmx(vcpu)->nested.nested_run_pending = 0;
+               kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
                nested_vmx_vmexit(vcpu, -1, 0, 0);
        }
        free_nested(vcpu);

