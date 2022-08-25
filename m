Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845B95A0DA4
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 12:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238964AbiHYKOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 06:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241053AbiHYKNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 06:13:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C87CABF11
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 03:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661422418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1On/L0KSwWBXLkoO7TYGZ7/I9PW/ScIQGzP4YPTC/Ns=;
        b=CX0Xyk0SlotDShN+xCbZzCJiIxfS2DQz3VA0x3LTGAA/leYe8FGRxr0KNtqgue+nGkUCC1
        wGO9gjyVwTFa5HW9O0KoVf7P4iW3t/PZs82/hsZfLmzymPNvfl19SRyJY9EiC3Grx+xDy9
        jyBkvOxZHVnyaAPQULOlr6IQWN+5txw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-U_S0TIP6NOyWMqYrGjLNfA-1; Thu, 25 Aug 2022 06:13:35 -0400
X-MC-Unique: U_S0TIP6NOyWMqYrGjLNfA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C82A101E989;
        Thu, 25 Aug 2022 10:13:34 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D208BC15BB3;
        Thu, 25 Aug 2022 10:13:29 +0000 (UTC)
Message-ID: <a3a4e22f3f2fd0b8582f233d0c34c8460f0dae6f.camel@redhat.com>
Subject: Re: [PATCH v3 13/13] KVM: x86: emulator/smm: preserve interrupt
 shadow in SMRAM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 25 Aug 2022 13:13:28 +0300
In-Reply-To: <Ywa5K3qVO0kDfTW9@google.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
         <20220803155011.43721-14-mlevitsk@redhat.com> <Ywa5K3qVO0kDfTW9@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-24 at 23:50 +0000, Sean Christopherson wrote:
> On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> > @@ -518,7 +519,8 @@ struct kvm_smram_state_32 {
> >  	u32 reserved1[62];
> >  	u32 smbase;
> >  	u32 smm_revision;
> > -	u32 reserved2[5];
> > +	u32 reserved2[4];
> > +	u32 int_shadow; /* KVM extension */
> 
> Looking at this with fresh(er) eyes, I agree with Jim: KVM shouldn't add its own
> fields in SMRAM.  There's no need to use vmcb/vmcs memory either, just add fields
> in kvm_vcpu_arch to save/restore the state across SMI/RSM, and then borrow VMX's
> approach of supporting migration by adding flags to do out-of-band migration,
> e.g. KVM_STATE_NESTED_SMM_STI_BLOCKING and KVM_STATE_NESTED_SMM_MOV_SS_BLOCKING.
> 
> 	/* SMM state that's not saved in SMRAM. */
> 	struct {
> 		struct {
> 			u8 interruptibility;
> 		} smm;
> 	} nested;
> 
> That'd finally give us an excuse to move nested_run_pending to common code too :-)
> 
Paolo told me that he wants it to be done this way (save the state in the smram).

My first version of this patch was actually saving the state in kvm internal state,
I personally don't mind that much if to do it this way or another.

But note that I can't use nested state - the int shadow thing has nothing to do with
nesting.

I think that 'struct kvm_vcpu_events' is the right place for this, and in fact it already
has interrupt.shadow (which btw Qemu doesn't migrate...)

My approach was to use upper 4 bits of 'interrupt.shadow' since it is hightly unlikely
that we will ever see more that 16 different interrupt shadows.

It would be a bit more clean to put it into the 'smi' substruct, but we already
have the 'triple_fault' afterwards 

(but I think that this was very recent addition - maybe it is not too late?)

A new 'KVM_VCPUEVENT_VALID_SMM_SHADOW' flag can be added to the struct to indicate the
extra bits if you want.

Best regards,
	Maxim Levitsky



