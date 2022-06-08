Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC830542B90
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 11:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbiFHJ2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 05:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbiFHJ1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 05:27:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA0BB15530F
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 01:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654678339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6m6xNh8Q82oEhHsQPq6xw9Gmg1qww/dTywKXwX/FcEg=;
        b=NW8fzPO/4xccXMNh4mXr1FlhANR3UgGddFb5kWB4Fe1mS4R3mSDuFAog2JjvRxm3g0ok8b
        2lAEHhU4h74ooaciBwQ1gUxndLC2XF5AdZgO+fBP6cRanNLkHys4lut4tpbOoulygjxJof
        kYO465OJUs9KbLRLjmV+WbNBUeHifV8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-D_BrJ3YHMtu3dwReptRX_w-1; Wed, 08 Jun 2022 04:52:14 -0400
X-MC-Unique: D_BrJ3YHMtu3dwReptRX_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B91A800971;
        Wed,  8 Jun 2022 08:52:13 +0000 (UTC)
Received: from starship (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D269B40D2853;
        Wed,  8 Jun 2022 08:52:09 +0000 (UTC)
Message-ID: <06751481c463907f0eeced62d3f11419368823ce.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: preserve interrupt shadow across SMM entries
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Wed, 08 Jun 2022 11:52:08 +0300
In-Reply-To: <Yp+lZahfgYYlA9U9@google.com>
References: <20220607151647.307157-1-mlevitsk@redhat.com>
         <2c561959-2382-f668-7cb8-01d17d627dd6@redhat.com>
         <Yp+lZahfgYYlA9U9@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-07 at 19:22 +0000, Sean Christopherson wrote:
> On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> > On 6/7/22 17:16, Maxim Levitsky wrote:
> > > If the #SMI happens while the vCPU is in the interrupt shadow,
> > > (after STI or MOV SS),
> > > we must both clear it to avoid VM entry failure on VMX,
> > > due to consistency check vs EFLAGS.IF which is cleared on SMM entries,
> > > and restore it on RSM so that #SMI is transparent to the non SMM code.
> > > 
> > > To support migration, reuse upper 4 bits of
> > > 'kvm_vcpu_events.interrupt.shadow' to store the smm interrupt shadow.
> > > 
> > > This was lightly tested with a linux guest and smm load script,
> > > and a unit test will be soon developed to test this better.
> > > 
> > > For discussion: there are other ways to fix this issue:
> > > 
> > > 1. The SMM shadow can be stored in SMRAM at some unused
> > > offset, this will allow to avoid changes to kvm_vcpu_ioctl_x86_set_vcpu_events
> > 
> > Yes, that would be better (and would not require a new cap).
> 
> At one point do we chalk up SMM emulation as a failed experiment and deprecate
> support?  There are most definitely more bugs lurking in KVM's handling of
> save/restore across SMI+RSM.

I also kind of agree that SMM was kind of a mistake but these days VMs with secure
boot use it, so we can't stop supporting this.

So do you also agree that I write the interrupt shadow to smram?

Best regards,
	Maxim Levitsky

> 
> > > 2. #SMI can instead be blocked while the interrupt shadow is active,
> > > which might even be what the real CPU does, however since neither VMX
> > > nor SVM support SMM window handling, this will involve single stepping
> > > the guest like it is currently done on SVM for the NMI window in some cases.
> 
> FWIW, blocking SMI in STI/MOVSS shadows is explicitly allowed by the Intel SDM.
> IIRC, modern Intel CPUs block SMIs in MOVSS shadows but not STI shadows.
> 

