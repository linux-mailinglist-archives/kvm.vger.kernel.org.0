Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF7E508D96
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 18:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380733AbiDTQrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 12:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380675AbiDTQrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 12:47:19 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF7346661
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 09:44:32 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d15so2281579pll.10
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 09:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mmUDe7z0b0FTLJ9wvVbnLdVpkfi8vNaqEQvU41wotf8=;
        b=EhmOxAP7NMWiC0dM6+rCeAa0PCDqYByqawACSsIs2E6eanZPg9Bq+ts26QVKu2bQcz
         LHRfk1U7f9I/0FTB+S5j0KxaT6zN4Ks9h4GvCS5SIEIr6w34WuDlv3swX6ZMgDOXhOCK
         pCUdbPAvqlvW4JD0jACrMXV64cMxsww9zxB1cso7wqZX7ji5IQ/cNiy4/gmmO7WSTiz8
         sqmlEsqoJ40YJJgGsxHMG1NzSx5pl1QE9x8rlnULNt96G/fAs/kLYq5TkC/lWCeaI/y+
         sigjzPOV5Nu/duAKbA2bjfxMY60SYlQ+JmVoIqCpVIjs5neEljK9Wh0Kr6fEUOskUi9/
         ORgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mmUDe7z0b0FTLJ9wvVbnLdVpkfi8vNaqEQvU41wotf8=;
        b=6KbPTbkfZbQLEohTQRij1mqag8fhhWm7ux1M3ule/S70A1JLUwzR3gtxiBJ3RCjv01
         6eeKmHUHdHM1JgiEDXKAlqx9hWA/2apiD+JJ+1klqLP7NzHyuvGqh6BTaPmZLAcV++BJ
         I9L68f2AvtKnfmAE/jAzlShcWX9hqapyhZOuxXJFX0M1REErjSrDQeUa77vD5FK5YwYH
         EKmuHVEd5lG9Kd7u1+zUPe4ZGPX8NyVAz7Ik4upcXC2zZAxWzO3HXpYDJfVqrH6y7A1y
         h93n7/ltZiN0CDdVQ7aq1TPx7EglBZt2bVJ083vOqOSdDuTkJ477uO+znd2nYFNGpKHi
         VEzQ==
X-Gm-Message-State: AOAM531DEzYMYzkx8IxVkjlP3vckMUFDtTdKtW0O3+jpptOBvOxtVIMk
        4VPaV9UKbpuxa6BSh5XBDi3Dog==
X-Google-Smtp-Source: ABdhPJyDyGoYOudnVdumER/MV2n/NsBRU/3RKfNR1fONov5Rh0TSOA0eXyIZ64x4VIQ+ZRyavxZKCQ==
X-Received: by 2002:a17:902:ab4c:b0:158:e896:7939 with SMTP id ij12-20020a170902ab4c00b00158e8967939mr20392237plb.154.1650473071757;
        Wed, 20 Apr 2022 09:44:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a00115000b004f6ff260c9esm20844971pfm.207.2022.04.20.09.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 09:44:31 -0700 (PDT)
Date:   Wed, 20 Apr 2022 16:44:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
Message-ID: <YmA4a8jwcL0PzkIr@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-2-seanjc@google.com>
 <112c2108-7548-f5bd-493d-19b944701f1b@maciej.szmigiero.name>
 <YkspIjFMwpMYWV05@google.com>
 <4505b43d-5c33-4199-1259-6d4e8ebac1ec@redhat.com>
 <98fca5c8-ca8e-be1f-857d-3d04041b66d7@maciej.szmigiero.name>
 <YmAxqrbMRx76Ye5a@google.com>
 <41d956ab-3d25-2c2f-8b1a-2c49e03b4df4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41d956ab-3d25-2c2f-8b1a-2c49e03b4df4@redhat.com>
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

On Wed, Apr 20, 2022, Paolo Bonzini wrote:
> On 4/20/22 18:15, Sean Christopherson wrote:
> > > > Let's just require X86_FEATURE_NRIPS, either in general or just to
> > > > enable nested virtualiazation
> > > 👍
> > Hmm, so requiring NRIPS for nested doesn't actually buy us anything.  KVM still
> > has to deal with userspace hiding NRIPS from L1, so unless I'm overlooking something,
> > the only change would be:
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index bdf8375a718b..7bed4e05aaea 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -686,7 +686,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> >           */
> >          if (svm->nrips_enabled)
> >                  vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> > -       else if (boot_cpu_has(X86_FEATURE_NRIPS))
> > +       else
> >                  vmcb02->control.next_rip    = vmcb12_rip;
> > 
> >          if (is_evtinj_soft(vmcb02->control.event_inj)) {
> > 
> > And sadly, because SVM doesn't provide the instruction length if an exit occurs
> > while vectoring a software interrupt/exception, making NRIPS mandatory doesn't buy
> > us much either.
> > 
> > I believe the below diff is the total savings (plus the above nested thing) against
> > this series if NRIPS is mandatory (ignoring the setup code, which is a wash).  It
> > does eliminate the rewind in svm_complete_soft_interrupt() and the funky logic in
> > svm_update_soft_interrupt_rip(), but that's it AFAICT.  The most obnoxious code of
> > having to unwind EMULTYPE_SKIP when retrieving the next RIP for software int/except
> > injection doesn't go away:-(
> > 
> > I'm not totally opposed to requiring NRIPS, but I'm not in favor of it either.
> 
> Yeah, you're right.  However:
> 
> * the rewind might already be worth it;

FWIW, I don't actually care about supporting nrips=false, it's the ability to test
EMULTYPE_SKIP that I find valuable.  I also find the extra perspective of how RIP
interacts with software interrupts/exceptions to be very helpful/educational, though
that's of debatable value going forward.

> * if we require NRIPS for nested, we can also assume that the SVM save state
> data has a valid next_rip; even if !svm->nrips_enabled.  There's the pesky
> issue of restoring from an old system that did not have NRIPS, but let's
> assume for now that NRIPS was set on the source as well.

How about I throw a Not-signed-off-by patch on the end of the series to make NRIPS
mandatory, that way we (in theory) have a fully functional snapshot for nrips=false
if we want to go back in time.  And we probably need to give a deprecation grace
period, i.e. wait a release or two before disappearing nrips?
