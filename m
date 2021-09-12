Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C2D407CDD
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 12:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhILKfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 06:35:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48551 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232555AbhILKfF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 06:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631442831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvMzth+IF5FLsBCqQ5vuYZZ9lz8yM7mDVyzxWe/Vzhg=;
        b=UQRVcR2jFwkShBqIE61vEkmW+kxGSdhQM4EwqUn4El/j/Wgw+okuMyAy6K+ITg/Q5J4dg4
        Ed+gpCH7sBkSBGFdhmAUdEd1wG+ZNXXMCWzzmUefyV8qboinrHSTry0Wyle2I6e9MsCR8+
        7yvpA0frHWAcAm2x/I9d6rXNKgcOBWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-JC6lQXnvOCWa28R-2FyZkQ-1; Sun, 12 Sep 2021 06:33:50 -0400
X-MC-Unique: JC6lQXnvOCWa28R-2FyZkQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D93E980196C;
        Sun, 12 Sep 2021 10:33:48 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A70406A8FC;
        Sun, 12 Sep 2021 10:33:44 +0000 (UTC)
Message-ID: <b8b28cec40a4d5b314a1af645f2eb3fa0be7b394.camel@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: force PDPTRs reload on SMM exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Sun, 12 Sep 2021 13:33:43 +0300
In-Reply-To: <YTlbeylHFkr9/8ES@google.com>
References: <20210823114618.1184209-1-mlevitsk@redhat.com>
         <20210823114618.1184209-3-mlevitsk@redhat.com>
         <YTlbeylHFkr9/8ES@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-09-09 at 00:55 +0000, Sean Christopherson wrote:
> On Mon, Aug 23, 2021, Maxim Levitsky wrote:
> > KVM_REQ_GET_NESTED_STATE_PAGES is also used with VM entries that happen
> > on exit from SMM mode, and in this case PDPTRS must be always reloaded.
> > 
> > Thanks to Sean Christopherson for pointing this out.
> > 
> > Fixes: 0f85722341b0 ("KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES")
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index fada1055f325..4194fbf5e5d6 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7504,6 +7504,13 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> >  	}
> >  
> >  	if (vmx->nested.smm.guest_mode) {
> > +
> > +		/* Exit from the SMM to the non root mode also uses
> 
> Just "Exit from SMM to non-root mode", i.e. drop the "the".
> 
> Multi-line comments should look like:
> 
> 		/*
> 		 * Exit from SMM ...
> 
> though oddly checkpatch doesn't complain about that.
> 
> That said, for the comment, it'd be more helpful to explain why the PDPTRs should
> not come from userspace.  Something like:
> 
> 		/*
> 		 * Always reload the guest's version of the PDPTRs when exiting
> 		 * from SMM to non-root.  If KVM_SET_SREGS2 stuffs PDPTRs while
> 		 * SMM is active, that state is specifically for SMM context.
> 		 * On RSM, all guest state is pulled from its architectural
> 		 * location, whatever that may be.
> 		 */
> 
> Though typing that makes me wonder if this is fixing the wrong thing.  It seems
> like pdptrs_from_userspace shouldn't be set when SMM is active, though I suppose
> there's a potential ordering issue between KVM_SET_SREGS2 and KVM_SET_VCPU_EVENTS.
> Bummer.
> 
> > +		 * the KVM_REQ_GET_NESTED_STATE_PAGES request,
> > +		 * but in this case the pdptrs must be always reloaded
> > +		 */
> > +		vcpu->arch.pdptrs_from_userspace = false;
> > +
> >  		ret = nested_vmx_enter_non_root_mode(vcpu, false);
> >  		if (ret)
> >  			return ret;
> > -- 
> > 2.26.3
> > 

I went with your suggestion in the patch 3, and dropped this patch.

Thanks!
Best regards,
	Maxim Levitsky

