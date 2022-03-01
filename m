Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2514C9121
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbiCARKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiCARKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:10:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BF5633EBF
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646154575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VzKIP2kdsOPqcqB2Ssg12nuFLvqq+uMkeF/uwda33II=;
        b=bu923cD8O17g+xMNqFK38DLAO11dtz4v0yu8QaaPpQf37WkiZIQdbCriZ9EPBbmmIGajVi
        JLx02jZ8+H+P7ObqMrqU1weM366fhy5H0F3FcmVrNR7KjG+qV4P1BUST5I6CZLtSfKBfM3
        Bh/xgg2dVTUKOu84FiRtZwXMwvnDgQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-qkhtoZdVNEOYfrt8wZnPWQ-1; Tue, 01 Mar 2022 12:09:31 -0500
X-MC-Unique: qkhtoZdVNEOYfrt8wZnPWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B085FC81;
        Tue,  1 Mar 2022 17:09:29 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F2507DE43;
        Tue,  1 Mar 2022 17:09:24 +0000 (UTC)
Message-ID: <6f4819b4169bd4e2ca9ab710388ebd44b7918eed.camel@redhat.com>
Subject: Re: [PATCH 4/4] KVM: x86: lapic: don't allow to set non default
 apic id when not using x2apic api
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Date:   Tue, 01 Mar 2022 19:09:23 +0200
In-Reply-To: <Yh5QJ4dJm63fC42n@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
         <20220301135526.136554-5-mlevitsk@redhat.com> <Yh5QJ4dJm63fC42n@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-01 at 16:56 +0000, Sean Christopherson wrote:
> Please, please post standalone patches/fixes as standalone patches/fixes.  And in
> general, keep series to one topic.  There is very real value in following the
> established and documented process, e.g. avoids creating artificial dependencies
> where a changes works only because of an "unrelated" patch earlier in the series.
> And for us reviewers, it helps tremendously as it means I can scan just the cover
> letter for a series to prioritize review accordingly.  Bundling things together
> means I have to scan through every patch to triage the series..

I know, this series is just set of small fixes - this patch belongs to the series
of my nested avic, but as was requested, I posted it seperately as part of
'fixes only' series, since it is stanadlone. All patches in this series
are standalone.

> 
> On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> > Fix a loop hole in setting the apic state that didn't check if
> 
> Heh, "loophole", took me a second to figure out there was no literal loop. :-)
> 
> > apic id == vcpu_id when x2apic is enabled but userspace is using
> > a older variant of the ioctl which didn't had 32 bit apic ids.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/lapic.c | 17 ++++++++---------
> >  1 file changed, 8 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 80a2020c4db40..8d35f56c64020 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2618,15 +2618,14 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
> >  		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
> >  		u64 icr;
> >  
> > -		if (vcpu->kvm->arch.x2apic_format) {
> > -			if (*id != vcpu->vcpu_id)
> > -				return -EINVAL;
> > -		} else {
> > -			if (set)
> > -				*id >>= 24;
> > -			else
> > -				*id <<= 24;
> > -		}
> > +		if (!vcpu->kvm->arch.x2apic_format && set)
> > +			*id >>= 24;
> > +
> > +		if (*id != vcpu->vcpu_id)
> > +			return -EINVAL;
> 
> This breaks backwards compability, userspace will start failing where it previously
> succeeded.  It doesn't even require a malicious userspace, e.g. if userspace creates
> a vCPU with a vcpu_id > 255 vCPUs, the shift will truncate and cause failure.  It'll
> obviously do weird things, but this code is 5.5 years old, I don't think it's worth
> trying to close a loophole that doesn't harm KVM.
> 
> If we provide a way for userspace to opt into disallowiong APICID != vcpu_id, we
> can address this further upstream, e.g. reject vcpu_id > 255 without x2apic_format.

This check is only when CPU is in x2apic mode. In this mode the X86 specs demands that
apic_id == vcpu_id.

When old API is used, APIC IDs are encoded in xapic format, even when vCPU is in x2apic
mode, meaning that apic id can't be more  that 255 even in x2apic mode.
That is why new API 'x2apic_format' was added in first place.

Thus I don't see how this is breaking userspace.

Best regards,
	Maxim Levitsky



> 
> > +
> > +		if (!vcpu->kvm->arch.x2apic_format && !set)
> > +			*id <<= 24;
> >  
> >  		/*
> >  		 * In x2APIC mode, the LDR is fixed and based on the id.  And
> > -- 
> > 2.26.3
> > 


