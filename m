Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D06615099
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 18:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiKAR0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiKAR0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 13:26:33 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7B1178B6
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 10:26:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gw22so923904pjb.3
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A4QtUNj00AFef6/SLaxc9/EwfiEMk/XY7VysTIRCNPk=;
        b=GsJToAMuJ29wa7MEmx4mYyei/7wv80A0LVzK56seJd3rF4Iza7U3ZPb2voZV21TLTN
         RxpDgA2RSMWks/aF2G1p1yac9G/1umJFalIjnM0nXDpvs8UOdNk7V54bFdBfr34nX38e
         IQXZHEYQL81ulw6Uymt/PPeYXF0F3z62tB5HDbR5bjJHaCzZOtdxavohIZJCCqGp8dq3
         lWca2/vOzct4CEreWPEW2kTLPa1KAz6yPdkGtc+Nyc71IcwQcGBbEb8l8yakRNIBUKEn
         9YvwySYx/6EYUSNoFfcEHRtZd7HxydbrpvsFNsDcM6LomZIXAmeUXQpZo3bOdnz84whe
         TtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4QtUNj00AFef6/SLaxc9/EwfiEMk/XY7VysTIRCNPk=;
        b=YqkRcVGpM7O5x8Fgl7XnpkLPS8muNyULPQx5Dx+g00MAev450KGuqDjZWyGgTkrKxP
         UAFAFplsqChSXsqUYE59mdgq3wncLxob94uPfh3l7hpkqOTOMyNBGIA9orB7iTn8lgYl
         fzQPUJhyyZKusdmvdOFPZ2uvKaeEUoprbjKOdY5CB34y3RQKFdcAhwzCKCVbobWSZqKn
         zvWDOWkwwnAIoTCCm0cYmi2L0A1P9Ho2SpNLReqEgm5uu7idFHQQtCd2W2o6D5s1HKsY
         2PMRE1qLg8QmRGTVpcvAW19giOkoXKAtU4gEkKbyOSAS7HJ/Cy0ZIlIbFORNkipMHXbm
         FboA==
X-Gm-Message-State: ACrzQf1tIGAyJUUP+Y/b6htZiLNPp1OH9jrNxRKICWCrOhwMBa3oZXd6
        aBfyNfNA4a2r0hQNFkFa0G3g3Q==
X-Google-Smtp-Source: AMsMyM5Vb6UFf34QgXTQptO3wBNpsNlppGWrjixPl4a14JL9LAnJyPI67XMAeJtoT1oJDK1obuG8+g==
X-Received: by 2002:a17:902:d54a:b0:186:a43b:8e with SMTP id z10-20020a170902d54a00b00186a43b008emr21216723plf.36.1667323590558;
        Tue, 01 Nov 2022 10:26:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r7-20020aa79ec7000000b0056da63c8515sm2984440pfq.91.2022.11.01.10.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 10:26:30 -0700 (PDT)
Date:   Tue, 1 Nov 2022 17:26:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 45/48] KVM: selftests: Introduce rdmsr_from_l2() and
 use it for MSR-Bitmap tests
Message-ID: <Y2FWwkq1kv9uXLwt@google.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
 <20221101145426.251680-46-vkuznets@redhat.com>
 <Y2FFNO3Bu9Z3LtCW@google.com>
 <87bkpqskr2.fsf@ovpn-194-149.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkpqskr2.fsf@ovpn-194-149.brq.redhat.com>
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

On Tue, Nov 01, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Nov 01, 2022, Vitaly Kuznetsov wrote:
> >> Hyper-V MSR-Bitmap tests do RDMSR from L2 to exit to L1. While 'evmcs_test'
> >> correctly clobbers all GPRs (which are not preserved), 'hyperv_svm_test'
> >> does not. Introduce and use common rdmsr_from_l2() to avoid code
> >> duplication and remove hardcoding of MSRs.
> >> 
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >>  .../selftests/kvm/include/x86_64/processor.h  |  9 +++++++
> >>  .../testing/selftests/kvm/x86_64/evmcs_test.c | 24 ++++---------------
> >>  .../selftests/kvm/x86_64/hyperv_svm_test.c    |  8 +++----
> >>  3 files changed, 17 insertions(+), 24 deletions(-)
> >> 
> >> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> >> index fbaf0b6cec4b..a14b7e4ea7c4 100644
> >> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> >> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> >> @@ -520,6 +520,15 @@ static inline void cpu_relax(void)
> >>  		"hlt\n"	\
> >>  		)
> >>  
> >> +/* Exit to L1 from L2 with RDMSR instruction */
> >> +static inline void rdmsr_from_l2(uint32_t msr)
> >
> > I would prefer keeping this helper out of common x86-64 code, even if it means
> > duplicating code across multiple Hyper-V tests until the L1 VM-Enter/VM-Exit
> > sequences get cleaned up.  The name is misleading, e.g. it doesn't really read
> > the MSR since there are no outputs
> 
> It's somewhat similar to vmcall()/vmmcall() which are only used to exit
> from L2 to L1 (and thus nobody complained that all the register values
> are random) and not issue a hypercall and return some value.

Sort of.  VMCALL/VMMCALL are unique in that they have no meaning (ignoring VMX's
STM) other than what is given to them by the hypervisor/software on VM-Exit.  RDMSR
on the other hand (and literally every other instruction), has architecturally
defined behavior and thus expectations beyond generating a VM-Exit.

I do think we should clean up the VMCALL/VMMCALL code to remove the clobbers
if/when the VM-Enter/VM-Exit sequences are fixed, and maybe make them more generic,
e.g. to allow reusing helpers for L1 and L2.  But, because the meaning of VMCALL/VMMCALL
is software-defined, we'll always need a selftests specific L2=>L1 hypercall,
e.g. to ensure L0 forwards the hypercall to L1.
