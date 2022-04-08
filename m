Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D684F8CAE
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 05:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiDHCum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 22:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiDHCuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 22:50:40 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A462518D989
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 19:48:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m16so6744637plx.3
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 19:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QVNKTxFKY91K7asyHX1+VGSBEgPLZQjVKlq+phltzL0=;
        b=YpOoxAMLGX57lTIEkrpR49LaYy67ZZSpVD/D0qWUqDh/eQONr+JJlk/Nz2PXHyzWL3
         5jGVWqxDLXydMmBRQ7WRmqsewGUspXwjMnjjrJs+YUmSO6qa6YULSfKkam9JiHn0ee8J
         rbUakLi3SDudT5lFJNqvj8GAmJSuYLp8F9V0MmXFHIiaTPQRcrG49kjapSBHkwfKvgHw
         /7Y/QB5wxxahvVEjCm2nbufMMoErvQM6z9ZsUMBZfSzDt++ufsqmjVedoBBdDJ6ZP7tR
         TtvP+pnzGgFVqlithGdIqBHyRYEXRaRpu2DiYtjQC1p3JzIONHokIG1X0OiPP1D1Zo+K
         q8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QVNKTxFKY91K7asyHX1+VGSBEgPLZQjVKlq+phltzL0=;
        b=bhX4K55iXlpdb+THq3Y8MANlq1zNB+qs55UbtJjZbEeg0GFnnDc3kMZPIzjsP/nBQn
         ppVYjzlwm20vhzekuPCg9d7sw+gom+XnjF1qpn6ATgNBsq5aHT9KhzN40wRju/QgKilW
         cDkbX9Uy0EsjItvisj3CSP/ssYaC9DE4lIZsjfLJT+7M0+dF0sxAd+7o1TvEs29GYsv0
         cUD1htmB5kwCxakJu8x6la51fNteHVzTjOezyrlK/ry74m9agJqTDxWpO3JSi0PYHj4S
         COiGQSVeVT/WDEYvuzDzvj7Piihf6bN4Oz6Y3+UZlCehMDCeTkhu8BjpTJFOruPKyiB9
         NDJg==
X-Gm-Message-State: AOAM532K1/4+2/NfC1ysa8EYtZQsassijd9vIkJ8PSmcTCfqSYr5IgEA
        wZjj4PdM4Lf9ZhC6MGEeCOtOrA==
X-Google-Smtp-Source: ABdhPJwHY1aYhKixZA6ZvysTmQQKx0OE/HP884G4bon4Jied82Q/05cMoEKUbBKdzAvMRWf0AMj+1Q==
X-Received: by 2002:a17:90b:3652:b0:1ca:b7d1:16b3 with SMTP id nh18-20020a17090b365200b001cab7d116b3mr19454016pjb.34.1649386117972;
        Thu, 07 Apr 2022 19:48:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l13-20020a056a00140d00b004e13da93eaasm24009269pfu.62.2022.04.07.19.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 19:48:37 -0700 (PDT)
Date:   Fri, 8 Apr 2022 02:48:33 +0000
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
Message-ID: <Yk+igefI2Mt/UTuh@google.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-2-chenyi.qiang@intel.com>
 <YkzRSHHDMaVBQrxd@google.com>
 <YkzUceG4rhw15U3i@google.com>
 <Yk4C8gA2xVCrzgrG@google.com>
 <8347e6e3-5b22-c9c9-5e6b-9ea33c614d5a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8347e6e3-5b22-c9c9-5e6b-9ea33c614d5a@intel.com>
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

On Thu, Apr 07, 2022, Chenyi Qiang wrote:
> 
> 
> On 4/7/2022 5:15 AM, Sean Christopherson wrote:
> > On Tue, Apr 05, 2022, Sean Christopherson wrote:
> > > On Tue, Apr 05, 2022, Sean Christopherson wrote:
> > > > On Fri, Mar 18, 2022, Chenyi Qiang wrote:
> > > > > @@ -4976,6 +4980,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> > > > >   		}
> > > > >   	}
> > > > > +	if (events->flags & KVM_VCPUEVENT_TRIPLE_FAULT)
> > > > > +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > > > > +
> > > > >   	kvm_make_request(KVM_REQ_EVENT, vcpu);
> > > > 
> > > > Looks correct, but this really needs a selftest, at least for the SET path since
> > > > the intent is to use that for the NOTIFY handling.  Doesn't need to be super fancy,
> > > > e.g. do port I/O from L2, inject a triple fault, and verify L1 sees the appropriate
> > > > exit.
> > > > 
> > > > Aha!  And for the GET path, abuse KVM_X86_SET_MCE with CR4.MCE=0 to coerce KVM into
> > > > making a KVM_REQ_TRIPLE_FAULT, that way there's no need to try and hit a timing
> > > > window to intercept the request.
> > > 
> > > Drat, I bet that MCE path means the WARN in nested_vmx_vmexit() can be triggered
> > > by userspace.  If so, this patch makes it really, really easy to hit, e.g. queue the
> > > request while L2 is active, then do KVM_SET_NESTED_STATE to force an "exit" without
> > > bouncing through kvm_check_nested_events().
> > > 
> > >    WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu))
> > > 
> > > I don't think SVM has a user-triggerable WARN, but the request should still be
> > > dropped on forced exit from L2, e.g. I believe this is the correct fix:
> > 
> > Confirmed the WARN can be triggered by abusing this patch, I'll get a patch out
> > once I figure out why kvm/queue is broken.
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
> > index 2e0a92da8ff5..b7faeae3dcc4 100644
> > --- a/tools/testing/selftests/kvm/x86_64/state_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/state_test.c
> > @@ -210,6 +210,12 @@ int main(int argc, char *argv[])
> >                  memset(&regs1, 0, sizeof(regs1));
> >                  vcpu_regs_get(vm, VCPU_ID, &regs1);
> > 
> > +               if (stage == 6) {
> > +                       state->events.flags |= 0x20;
> > +                       vcpu_events_set(vm, VCPU_ID, &state->events);
> > +                       vcpu_nested_state_set(vm, VCPU_ID, &state->nested, false);
> > +               }
> > +
> >                  kvm_vm_release(vm);
> > 
> >                  /* Restore state in a new VM.  */
> 
> Also verified the WARN with this. Then, is it still necessary to add an
> individual selftest about the working flow of save/restore triple fault
> event?

Yeah, the above hack fails the test even on a good kernel.  It's not an actual test
of the feature, just a hack to confirm the bug.
