Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AA15F0397
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 06:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiI3Edj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 00:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiI3Edh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 00:33:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DEB200B0C
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 21:33:36 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a80so3232259pfa.4
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 21:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=kqug0455jyBZ96e83RjWsm+59M12//sv9sYoDWvyZ44=;
        b=WJ4zti51BH7hOrvuguUgKA+S6zVDYbg2pys/9zrR64F12tJjBY+XAbN+jHQIhTnD4D
         rtJJ9EKmLMGC0yWiRnHHYQARq5D5KPVI/yG7yagD1oYyQDPY/6K+XhCHbWrAprHxdoCY
         SeHZXP+34rWgpBAm6GTbHMVRcxyZ6uJxF6giLl5x9IILnnbnpuzPD6YVFFmrl0YVXqLb
         TPsv92wMmidjgkKHVhS1byDLgkaGazJ4fH0pi3iCM7VD+mQjQZIvrl18eqoVioJTWEpc
         fmaoiFEl+dyRhV9KEU9oatfWlBwxHR8nYz5/HzvCiqfuXw5OTe4w2oHQNANyABTtrArk
         +ahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=kqug0455jyBZ96e83RjWsm+59M12//sv9sYoDWvyZ44=;
        b=A3ff96vmFx2jGoTxjnmL9YbxvUIv0Krol5NjNKmrLmPs3ypOE5nVpWWhBSdnr8jahf
         yMZ9wnEDqmTb7w4ZJDnFH9OGFoFt8EMfmumUMOOG6h55Zf6+31ZpZO8fih1NNh7DQUxT
         H1Dwz/awNHvdpi97fSWKpBhSmhpSVTkFwiSfGcqi/Jqyw00avJBoYddexiHr6OKuj+l7
         1HWauxviqG1D4WizCkcBE4q01CBbLwaq1tM4Qms+J2ZqECLoyhTPnmOTBtbMPicy7xq+
         BZdBu9CIqPCkGiP/9QgFBaczA9tzMJgGx2K14BtB/D0MLbA9/2J6A3fV/Z0inMlIz9Hr
         j2cQ==
X-Gm-Message-State: ACrzQf1KI9zxHnjmJmwyDGWfA4V+esZxOfpYikndzKkM2DmTh0O7mdoT
        5xgzzxxk2jAuk24IHIfp3CZjmw==
X-Google-Smtp-Source: AMsMyM4taUF3C4ntf7awgsW3jxC3ryEQJl6m45kOs4Mm9mhYb73iEteRxv1fcZ3DQovdhWwwuVIinA==
X-Received: by 2002:a05:6a00:198d:b0:548:bd77:69b1 with SMTP id d13-20020a056a00198d00b00548bd7769b1mr7025883pfl.20.1664512415987;
        Thu, 29 Sep 2022 21:33:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j12-20020a170903024c00b0017a04542a45sm765866plh.159.2022.09.29.21.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 21:33:35 -0700 (PDT)
Date:   Fri, 30 Sep 2022 04:33:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 1/9] KVM: x86/mmu: Bug the VM if KVM attempts to
 double count an NX huge page
Message-ID: <YzZxnJNj+/Xb+rRd@google.com>
References: <20220830235537.4004585-1-seanjc@google.com>
 <20220830235537.4004585-2-seanjc@google.com>
 <87tu50oohn.fsf@redhat.com>
 <YysjGNtYJbbPuxSN@google.com>
 <YyswlLykptcOciOS@google.com>
 <87leqcoglp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87leqcoglp.fsf@redhat.com>
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

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Sep 21, 2022, Sean Christopherson wrote:
> >> On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> >> > [  962.257992]  ept_fetch+0x504/0x5a0 [kvm]
> >> > [  962.261959]  ept_page_fault+0x2d7/0x300 [kvm]
> >> > [  962.287701]  kvm_mmu_page_fault+0x258/0x290 [kvm]
> >> > [  962.292451]  vmx_handle_exit+0xe/0x40 [kvm_intel]
> >> > [  962.297173]  vcpu_enter_guest+0x665/0xfc0 [kvm]
> >> > [  962.307580]  vcpu_run+0x33/0x250 [kvm]
> >> > [  962.311367]  kvm_arch_vcpu_ioctl_run+0xf7/0x460 [kvm]
> >> > [  962.316456]  kvm_vcpu_ioctl+0x271/0x670 [kvm]
> >> > [  962.320843]  __x64_sys_ioctl+0x87/0xc0
> >> > [  962.324602]  do_syscall_64+0x38/0x90
> >> > [  962.328192]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >> 
> >> Ugh, past me completely forgot the basics of shadow paging[*].  The shadow MMU
> >> can reuse existing shadow pages, whereas the TDP MMU always links in new pages.
> >> 
> >> I got turned around by the "doesn't exist" check, which only means "is there
> >> already a _SPTE_ here", not "is there an existing SP for the target gfn+role that
> >> can be used".
> >> 
> >> I'll drop the series from the queue, send a new pull request, and spin a v5
> >> targeting 6.2, which amusing will look a lot like v1...
> >
> > Huh.  I was expecting more churn, but dropping the offending patch and then
> > "reworking" the series yields a very trivial overall diff.  
> >
> > Vitaly, can you easily re-test with the below, i.e. simply delete the
> > KVM_BUG_ON()?
> 
> This seems to work! At least, I haven't noticed anything weird when
> booting my beloved Win11 + WSL2 guest.

I finally figured out why I didn't see this in testing.  It _should_ have fired
during kernel boot when testing legacy shadow paging, i.e. ept=0, as the bug requires
nothing more than executing from two GVAs pointing at the same huge 2mb GPA.

I did test ept=0, but all of my normal test systems aren't susceptible to L1TF
(KVM guest, all AMD, and ICX), i.e. don't enable the mitigation by default.  I
also tested those systems with the mitigation forced on and ept=0, but never
booted a VM with that combination, and neither KUT nor selftests does the requisite
aliasing with huge pages.

Death was instantaneous once I forced the mitigation on with ept=0 and booted a VM.

*sigh*
