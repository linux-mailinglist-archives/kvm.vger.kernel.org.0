Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47E66442FD
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 13:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbiLFMOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 07:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiLFMOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 07:14:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB15717897
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 04:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670328819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rx3yhRSNQLXKIbD5wZaN6jZW0LIMtSAtWlXbIFkz/ZU=;
        b=R30AXUVwhLTCQQa1sSI35juZAvg9qPfhJqde1DHP68lNXxMdPuAuBRSQaURrpCXU4p4I/T
        OHog/6rDH7NpeZVQQ41z3oINsCv37THrh19qlmMWg1Tla8XYR2E4iodiyGC6b3epSepAAT
        Rm9BEW9Pf4AhQXhju18tFJc5JYep+OI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-85G02iPANG6YVtn8B3hdrw-1; Tue, 06 Dec 2022 07:13:32 -0500
X-MC-Unique: 85G02iPANG6YVtn8B3hdrw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1572101A528;
        Tue,  6 Dec 2022 12:13:31 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D85DD4A9279;
        Tue,  6 Dec 2022 12:13:27 +0000 (UTC)
Message-ID: <439f0b8b52dd019c60974ab105dee75fa15eaf3e.camel@redhat.com>
Subject: Re: [PATCH v2 01/11] KVM: nSVM: don't sync back tlb_ctl on nested
 VM exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Santosh Shukla <santosh.shukla@amd.com>, kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Tue, 06 Dec 2022 14:13:26 +0200
In-Reply-To: <946d0a77-eecb-5e30-716b-1d6cffd7f12c@amd.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
         <20221129193717.513824-2-mlevitsk@redhat.com>
         <946d0a77-eecb-5e30-716b-1d6cffd7f12c@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-12-05 at 19:35 +0530, Santosh Shukla wrote:
> Hi Maxim,
> 
> On 11/30/2022 1:07 AM, Maxim Levitsky wrote:
> > The CPU doesn't change TLB_CTL value as stated in the PRM (15.16.2):
> > 
> nits:
> s / PRM (15.16.2) / APM (15.16.1 - TLB Flush)

True for both changes, thanks!

Best regards,
	Maxim Levitsky

> 
> >   "The VMRUN instruction reads, but does not change, the
> >   value of the TLB_CONTROL field"
> > 
> > Therefore the KVM shouldn't do that either.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index bc9cd7086fa972..37af0338da7c32 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1010,7 +1010,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >  		vmcb12->control.next_rip  = vmcb02->control.next_rip;
> >  
> >  	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
> > -	vmcb12->control.tlb_ctl           = svm->nested.ctl.tlb_ctl;
> >  	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
> >  	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
> >  


