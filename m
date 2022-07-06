Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E355692FB
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 22:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiGFUDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 16:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiGFUDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 16:03:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B27C19C2B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 13:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657137796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QCu6837a/sy7u4lzaiqiFjYTgUMl7+kkVhKwaEZCn8I=;
        b=Ocd68nRFk3itkb31D45NJ7RHT8ZwpL9K9iNuOT+dRVwAMYAB+PQZNalnekuU0JmL1mAZuT
        nfW38Q0ftAgy1CoddOSf+1FuKF4PbN++WuQR+QC8Pzdep/aU+RQgPPWs6Abykfe5fjFE8+
        FiJ14kaokM4+oyD8jqTWvDrZxfqa4zU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-dii7UTZnO5iLRemf68F3bg-1; Wed, 06 Jul 2022 16:03:13 -0400
X-MC-Unique: dii7UTZnO5iLRemf68F3bg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B83C3833961;
        Wed,  6 Jul 2022 20:03:12 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66FC5140EBE3;
        Wed,  6 Jul 2022 20:03:10 +0000 (UTC)
Message-ID: <4069fcb7e559b0732681ecc9234f9910b59df411.camel@redhat.com>
Subject: Re: [PATCH v2 09/21] KVM: nVMX: Unconditionally clear mtf_pending
 on nested VM-Exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 23:03:09 +0300
In-Reply-To: <YsW8He/1b1xBWLwz@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-10-seanjc@google.com>
         <599b352e16c970885d3f6bfaf7d1a254627ef5dd.camel@redhat.com>
         <YsW8He/1b1xBWLwz@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-06 at 16:45 +0000, Sean Christopherson wrote:
> On Wed, Jul 06, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> > > Clear mtf_pending on nested VM-Exit instead of handling the clear on a
> > > case-by-case basis in vmx_check_nested_events().  The pending MTF should
> > > rever survive nested VM-Exit, as it is a property of KVM's run of the
> > ^^ typo: never
> > 
> > Also it is not clear what the 'case by case' means.
> > 
> > I see that the vmx_check_nested_events always clears it unless nested run is pending
> > or we re-inject an event.
> 
> Those two "unless ..." are the "cases".  The point I'm trying to make in the changelog
> is that there's no need for any conditional logic whatsoever.
> 
> > > @@ -3927,6 +3919,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> > >  		clear_bit(KVM_APIC_INIT, &apic->pending_events);
> > >  		if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
> > >  			nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
> > > +
> > > +		/* MTF is discarded if the vCPU is in WFS. */
> > > +		vmx->nested.mtf_pending = false;
> > >  		return 0;
> > 
> > I guess MTF should also be discarded if we enter SMM, and I see that
> > VMX also enter SMM with a pseudo VM exit (in vmx_enter_smm) which
> > will clear the MTF. Good.
> 
> No, a pending MTF should be preserved across SMI. 

Indeed, now I see it:

"If an MTF VM exit was pending at the time of the previous SMI, an MTF VM exit is pending on the instruction
boundary following execution of RSM. The following items detail the treatment of MTF VM exits that may be
pending following RSM:"

You might also want to add it as some comment in the source.



>  It's not a regression because
> KVM incorrectly prioritizes MTF (and trap-like #DBs) over SMI (and because if KVM
> did prioritize SMI, the existing code would also drop the pending MTF).  Note, this
> isn't the only flaw that needs to be addressed in order to correctly prioritize SMIs,
> e.g. KVM_{G,S}ET_NESTED_STATE would need to save/restore a pending MTF if the vCPU is
> in SMM after an SMI that arrived while L2 was active.

When we fix this, should we store it to SMRAM, or to some KVM internal state?
Or VMCS12, as noted in the other mail.


> 
> Tangentially related, KVM's pseudo VM-Exit on SMI emulation is completely wrong[*].
> 
> [*] https://lore.kernel.org/all/Yobt1XwOfb5M6Dfa@google.com
> 


I have seen a patch on the KVM mailing list recently exactly about preserving CET
state in the SMRAM, I'll need to take a look.



Best regards,
	Maxim Levitsky

