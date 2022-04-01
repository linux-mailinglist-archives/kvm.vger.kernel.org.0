Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BC14EFC5E
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 23:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350356AbiDAVx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 17:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbiDAVxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 17:53:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E4D200342
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 14:51:33 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so3748291pjm.0
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 14:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tGJBlLkmgZTxVHoFIKbZU2QoQ1f35loIsBzJHpfAMdY=;
        b=IRuzE1kOG1hxaxxmTzAYMb3FDbCSi+yGguqeIEEkb6PgEkoj8OJw0Wbp1eIB/2Me3p
         xuGdoi2lhxv9CVVqjbuzF613Zeln3iPfWQbpeqsqnIjocqNg67KqieyA7dgqBsr6SPWw
         6wrS6Bcn1dzQKZfr8jGNVSlBrpiQex5k5ZZVGbSMbGIQL9BBIVc8t4DjWPryYQMsaDT7
         sBa+1gGJFgMAJ67j3nixa//B/dzXUciEMBXRawWskMuQq0oEDW6nhlEHbFTTT2BDgxot
         fiB+GkBX8L5o3ipdqqKD5S9ccxL7FPl6wgCEKzdtwvCa6iUBtuWv0DJ6dsXGF6WD5sFu
         Jqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tGJBlLkmgZTxVHoFIKbZU2QoQ1f35loIsBzJHpfAMdY=;
        b=OdUiMVrXHCpEyv7TXb4YtZh64pXqh0+wtg5V3BzZj1j9lTdfptSIh0zW8sBvJMLrbZ
         +VrGEVdtfX1KoA8NVWjAaM4D65ufh11jQ60cAialgrcih+Z1gvkNmGK1Qn1oQPypqWOO
         F8uk2yMbjHEAulGFp8AaGMJaEwLLQ9x6sjk/9UZGL6BdYErjXhdjRcJTmlBbZJUECH9E
         +OWE2B8sa+zUbarrmQVN/LwaJSLWPOHEJIwfoACWhGdILNYA/0TAfdvGQNbquSAcHtgd
         ZFXiZNIN3DGXqMIJyWOcPaMcDJM2BB5rARK3AwqbLJGrZPskqYHdBvlEYf3kPFffTcfZ
         vhBQ==
X-Gm-Message-State: AOAM530q149uQsQRgrQ2ZM/0/abFFcH+Wgas2la3xsawz1Ndi89phZf+
        6npKIgVKvJ7KR6Htyo1F1+FFlg==
X-Google-Smtp-Source: ABdhPJyqYTrcktF2dqvzUqC+PSXKCwUngmQC02h4W4A2CK4ObfO87QOMayd/x3RhS8ZivUZH3XpGcQ==
X-Received: by 2002:a17:90a:4981:b0:1c6:b6dd:d7a9 with SMTP id d1-20020a17090a498100b001c6b6ddd7a9mr13855937pjh.22.1648849892251;
        Fri, 01 Apr 2022 14:51:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e10-20020a17090a630a00b001c685cfd9d1sm3392861pjj.20.2022.04.01.14.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 14:51:31 -0700 (PDT)
Date:   Fri, 1 Apr 2022 21:51:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
Message-ID: <Ykdz4GVF4C+S/LGg@google.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
 <19c757487eeeff5344ff3684fe9c090235b07d05.1646944472.git.maciej.szmigiero@oracle.com>
 <YkdFSuezZ1XNTTfx@google.com>
 <ff29e77c-f16d-d9ef-9089-0a929d3c2fbf@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff29e77c-f16d-d9ef-9089-0a929d3c2fbf@maciej.szmigiero.name>
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

On Fri, Apr 01, 2022, Maciej S. Szmigiero wrote:
> On 1.04.2022 20:32, Sean Christopherson wrote:
> > On Thu, Mar 10, 2022, Maciej S. Szmigiero wrote:
> > > +	/* The return address pushed on stack by the CPU for some injected events */
> > > +	svm->vmcb->control.next_rip            = svm->nested.ctl.next_rip;
> > 
> > This needs to be gated by nrips being enabled _and_ exposed to L1, i.e.
> > 
> > 	if (svm->nrips_enabled)
> > 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> 
> It can be done, however what if we run on a nrips-capable CPU,
> but don't expose this capability to the L1?

Oh, right, because the field will be populated by the CPU on VM-Exit.  Ah, the
correct behavior is to grab RIP from vmcb12 to emulate nrips=0 hardware simply
not updating RIP.  E.g. zeroing it out would send L2 into the weeds on IRET due
the CPU pushing '0' on the stack when vectoring the injected event.

	if (svm->nrips_enabled)
		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
	else if (boot_cpu_has(X86_FEATURE_NRIPS))
		vmcb02->control.next_rip    = vmcb12_rip;

> The CPU will then push whatever value was left in this field as
> the return address for some L1 injected events.
> 
> Although without nrips feature the L1 shouldn't even attempt event
> injection, copying this field anyway will make it work if L1 just
> expects this capability based on the current CPU model rather than
> by checking specific CPUID feature bits.

L1 may still inject the exception, it just advances the RIP manually.  As above,
the really messy thing is that, because there's no flag to say "don't use NextRIP!",
the CPU will still consume NextRIP and push '0' on the stack for the return RIP
from the INTn/INT3/INTO.  Yay.

I found that out the hard way (patch in-progress).  The way to handle event
injection if KVM is loaded with nrips=0 but nrips is supported in hardware is to
stuff NextRIP on event injection even if nrips=0, otherwise the guest is hosed.

> > > +	u64 next_rip;
> > >   	u64 nested_cr3;
> > >   	u64 virt_ext;
> > >   	u32 clean;
> > 
> > I don't know why this struct has
> > 
> > 	u8 reserved_sw[32];
> > 
> > but presumably it's for padding, i.e. probably should be reduced to 24 bytes.
> 
> Apparently the "reserved_sw" field stores Hyper-V enlightenments state -
> see commit 66c03a926f18 ("KVM: nSVM: Implement Enlightened MSR-Bitmap feature")
> and nested_svm_vmrun_msrpm() in nested.c.

Argh, that's a terrible name.  Thanks for doing the homework, I was being lazy.
