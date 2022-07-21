Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5645C57C9F8
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiGULwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbiGULwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:52:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06EF683226
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658404351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhYcFqg4POmgYZtKg0Qy1tuoDHvTQ3pNdsPVHcHr1zQ=;
        b=atZAL9o2/RBx1uhGl/oYsoq9fOCo+Zlgb5N9Wgemh6EbWZ/9zqfCiFhKCRDyi/5tDfZw2k
        pf606pGOTQWFSngEDkYqk8witmTtFEUyGQqqJijdhGx8aX8f5TuT0WwT0CLUm7Pvg9jDt+
        +cPiwrBlIIJrpUUqtXQflmd9LsZxQ90=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-sRlEx3f_P_Wo3J8ItZ04NQ-1; Thu, 21 Jul 2022 07:52:27 -0400
X-MC-Unique: sRlEx3f_P_Wo3J8ItZ04NQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51A981029F78;
        Thu, 21 Jul 2022 11:52:26 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93BEC40CFD0A;
        Thu, 21 Jul 2022 11:52:22 +0000 (UTC)
Message-ID: <4c6deb603ba5b9fbc7e7c30d429190ed5517e97b.camel@redhat.com>
Subject: Re: [PATCH v2 02/11] KVM: x86: emulator: introduce
 update_emulation_mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Jul 2022 14:52:21 +0300
In-Reply-To: <YtiTeZQ/n0LPTV/W@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-3-mlevitsk@redhat.com> <YtiTeZQ/n0LPTV/W@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-20 at 23:44 +0000, Sean Christopherson wrote:
> On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > +static inline int update_emulation_mode(struct x86_emulate_ctxt *ctxt)
> 
> Maybe emulator_recalc_and_set_mode()?  It took me a second to understand that
> "update" also involves determining the "new" mode, e.g. I was trying to figure
> out where @mode was :-)

I don't mind at all, will update in v3.

> 
> > +{
> > +	u64 efer;
> > +	struct desc_struct cs;
> > +	u16 selector;
> > +	u32 base3;
> > +
> > +	ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
> > +
> > +	if (!ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE) {
> > +		/* Real mode. cpu must not have long mode active */
> > +		if (efer & EFER_LMA)
> > +			return X86EMUL_UNHANDLEABLE;
> 
> If we hit this, is there any hope of X86EMUL_UNHANDLEABLE doing the right thing?
> Ah, SMM and the ability to swizzle SMRAM state.  Bummer.  I was hoping we could
> just bug the VM.

I just tried to be a good citizen here, it is probably impossible to hit this case.
(RSM ignores LMA bit in the EFER in the SMRAM).

Best regards,
	Maxim Levitsky



> 
> > +		ctxt->mode = X86EMUL_MODE_REAL;
> > +		return X86EMUL_CONTINUE;
> > +	}


