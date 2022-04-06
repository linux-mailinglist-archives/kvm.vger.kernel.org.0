Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD7C4F6CE0
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 23:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiDFVjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 17:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbiDFVjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 17:39:07 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C955140BB
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 14:15:35 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y10so3618047pfa.7
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 14:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pBppaTksBxMSYQ8KEwF0hkGErNoqL29ELbfwE/o2LyQ=;
        b=s3oDFPukVfuhNj8ZfSNKbijug6xsWY5AXd9u8155hXTtguuSQrv2jG2K4JGWyU1+f4
         6McDLcEDtoZw/oo1OsN0rR11XyCTBjrM4yz7q/+Ek+cQEqYLIc/QMrGKINzNebUvLJ7j
         vmQnSg+YY4YTT+L9wT109V/ORxUZAEKwevt2AczcqeXftDnzuGTkO/x1o+jKSlXlkBcZ
         /dSeM54ERBRYxVG+UDC6WxrSKQs4/yZJ0Vd1bIN4skmGBsqf1LUZSTxYsJeDdnDhXy0I
         vnQE65kCN1SfRTMYCdmHQMGLVir3F8Mc7ves5b2n5wdfDvX8TRFOIx7pYNYHAgF6kQY/
         j+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pBppaTksBxMSYQ8KEwF0hkGErNoqL29ELbfwE/o2LyQ=;
        b=DJ3j+KGWfJZS1vCWheRjbCqO9g6ICbUMzkgaXC6GWhEAAdRX5ayHGr0/zLNMWM7fiw
         10g4TsRipEwcpcou2UM48oavD6bLT+fFS1xNR4G4OZE35SlPQvqhB/1QIwJ/Lw3MbdmV
         Lm8EGFLjCbauvP+py8uLHmEXqkiq18ACciJxe9qfjAB9o1TrCT33Qqd+Uhpss0E7Xcfl
         OG/5uMrbJPJyOzWpVE8fvA7s0XeQNH1P9zsaiauPAMjb2ekOS1yXmjtC1JwLZZI5eYOR
         2bOTfLv9JjNL7ax60n5DoQanRGsH3hXar8UvPrf+hvzdV2gGl8Fy8UoYa4AV3usWnv/h
         eYDw==
X-Gm-Message-State: AOAM5311ToXqwxtigkrpnQlH/jCVUnT33tRmv+j6YhkwvrA0x6Wh6h/B
        KlU02+mC5u26TUboDmcBDNWmig==
X-Google-Smtp-Source: ABdhPJz34FDyktVxt3U52IjSJ+sWap5q0lea2zQvyKD/pTpOEF9bIjwLB1bdquXs2h9QefNRXroxhA==
X-Received: by 2002:a63:7f1c:0:b0:382:1fb5:58b8 with SMTP id a28-20020a637f1c000000b003821fb558b8mr8454585pgd.507.1649279734739;
        Wed, 06 Apr 2022 14:15:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090ac40200b001bd0e552d27sm6217879pjt.11.2022.04.06.14.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 14:15:34 -0700 (PDT)
Date:   Wed, 6 Apr 2022 21:15:30 +0000
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
Message-ID: <Yk4C8gA2xVCrzgrG@google.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-2-chenyi.qiang@intel.com>
 <YkzRSHHDMaVBQrxd@google.com>
 <YkzUceG4rhw15U3i@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkzUceG4rhw15U3i@google.com>
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
> On Tue, Apr 05, 2022, Sean Christopherson wrote:
> > On Fri, Mar 18, 2022, Chenyi Qiang wrote:
> > > @@ -4976,6 +4980,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> > >  		}
> > >  	}
> > >  
> > > +	if (events->flags & KVM_VCPUEVENT_TRIPLE_FAULT)
> > > +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > > +
> > >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> > 
> > Looks correct, but this really needs a selftest, at least for the SET path since
> > the intent is to use that for the NOTIFY handling.  Doesn't need to be super fancy,
> > e.g. do port I/O from L2, inject a triple fault, and verify L1 sees the appropriate
> > exit.
> > 
> > Aha!  And for the GET path, abuse KVM_X86_SET_MCE with CR4.MCE=0 to coerce KVM into
> > making a KVM_REQ_TRIPLE_FAULT, that way there's no need to try and hit a timing
> > window to intercept the request.
> 
> Drat, I bet that MCE path means the WARN in nested_vmx_vmexit() can be triggered
> by userspace.  If so, this patch makes it really, really easy to hit, e.g. queue the
> request while L2 is active, then do KVM_SET_NESTED_STATE to force an "exit" without
> bouncing through kvm_check_nested_events().
> 
>   WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu))
> 
> I don't think SVM has a user-triggerable WARN, but the request should still be
> dropped on forced exit from L2, e.g. I believe this is the correct fix:

Confirmed the WARN can be triggered by abusing this patch, I'll get a patch out
once I figure out why kvm/queue is broken.

diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 2e0a92da8ff5..b7faeae3dcc4 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -210,6 +210,12 @@ int main(int argc, char *argv[])
                memset(&regs1, 0, sizeof(regs1));
                vcpu_regs_get(vm, VCPU_ID, &regs1);

+               if (stage == 6) {
+                       state->events.flags |= 0x20;
+                       vcpu_events_set(vm, VCPU_ID, &state->events);
+                       vcpu_nested_state_set(vm, VCPU_ID, &state->nested, false);
+               }
+
                kvm_vm_release(vm);

                /* Restore state in a new VM.  */

