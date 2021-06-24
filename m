Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7E43B2A29
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 10:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhFXISa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 04:18:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231825AbhFXISa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 04:18:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624522571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DKQaOPGFJZZQ5vgX+LfD77sztyavfZnG8AS/L9awIW4=;
        b=HxYD4twa4ABQYoUPdKKCrdOIxV2gT0A3FVJKWUmpWc8U2Hgll2Op9W5pEIPVaV6RD2vHgN
        XKuL6k0BVKq/FT2ggMYgvAm7MiNhrWO3z73k2LMVzub8crzxmuwBePjnOLRMaq1NzpP4Si
        RV4QwEyCMzP81cWd7El2NoO9K1DpY2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-c72DeYBoNoeA8_C0maJpNw-1; Thu, 24 Jun 2021 04:16:07 -0400
X-MC-Unique: c72DeYBoNoeA8_C0maJpNw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B637A40C0;
        Thu, 24 Jun 2021 08:16:05 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 013835D705;
        Thu, 24 Jun 2021 08:16:01 +0000 (UTC)
Message-ID: <d77c4792681bfc8cb7f13793b651b355ef6684de.camel@redhat.com>
Subject: Re: [PATCH 07/10] KVM: SVM: use vmcb01 in
 svm_refresh_apicv_exec_ctrl
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 24 Jun 2021 11:16:00 +0300
In-Reply-To: <bd20da0f-eb20-48f7-3258-cd5949f12227@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
         <20210623113002.111448-8-mlevitsk@redhat.com>
         <bd20da0f-eb20-48f7-3258-cd5949f12227@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-06-23 at 23:54 +0200, Paolo Bonzini wrote:
> On 23/06/21 13:29, Maxim Levitsky wrote:
> > AVIC is not supported for nesting but in some corner
> > cases it is possible to have it still be enabled,
> > after we entered nesting, and use vmcb02.
> > 
> > Fix this by always using vmcb01 in svm_refresh_apicv_exec_ctrl
> 
> Please be more verbose about the corner case (and then the second 
> paragraph should not be necessary anymore).

I will do it.
The issue can happen only after patch 8 is applied, because then AVIC disable on
the current vCPU is always deferred.
 
I think that currently the problem in this patch can't happen because 
kvm_request_apicv_update(..., APICV_INHIBIT_REASON_NESTED) is called on each vCPU
from svm_vcpu_after_set_cpuid, and since it disables it on current vCPU, the
AVIC is fully disabled on all vCPUs when we get to the first guest entry, even if nested
(after a migration the first guest entry can be already nested)
 
After patch 8, the AVIC disable is done at guest entry where we already are in
L2, thus we should toggle it in vmcb01, while vmcb02 shouldn't have AVIC enabled
in the first place.

Best regards,
	Maxim Levitsky


> 
> Paolo
> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/avic.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 1d01da64c333..a8ad78a2faa1 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -646,7 +646,7 @@ static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
> >   void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> >   {
> >   	struct vcpu_svm *svm = to_svm(vcpu);
> > -	struct vmcb *vmcb = svm->vmcb;
> > +	struct vmcb *vmcb = svm->vmcb01.ptr;
> >   	bool activated = kvm_vcpu_apicv_active(vcpu);
> >   
> >   	if (!enable_apicv)
> > 


