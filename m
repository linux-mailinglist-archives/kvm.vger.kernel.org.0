Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7640040AAEE
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 11:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhINJgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 05:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230508AbhINJgO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 05:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631612097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51BjhGNRsIASk6oWqLFKhAN0ok8SXVqby17Dax7DoqY=;
        b=YS3/xW/wRaCkaMQvo6kIHcvffgq5JnhyGsVJlTzqWP+CJUXLbQRdA5DVhsqbm1BSkQ9+eL
        OWkpiDxl2cQQjUusmnsG4wJFyRKxHCwa6pmce3MvwilGsXFTS81M49Xp5CyfIPujXFXZCW
        GbrcGLrE0VYrwWtlVkoUt+oWUux/eKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-WOQz7cXmMwm8XUlpCfwUrA-1; Tue, 14 Sep 2021 05:34:54 -0400
X-MC-Unique: WOQz7cXmMwm8XUlpCfwUrA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E4E5802923;
        Tue, 14 Sep 2021 09:34:52 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5CE877F3C;
        Tue, 14 Sep 2021 09:34:48 +0000 (UTC)
Message-ID: <fb828c752fac255c6a1d997ff27dfc5264a5c658.camel@redhat.com>
Subject: Re: [RFC PATCH 3/3] nSVM: use svm->nested.save to load vmcb12
 registers and avoid TOC/TOU races
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date:   Tue, 14 Sep 2021 12:34:47 +0300
In-Reply-To: <ee207b0c-eab3-13ba-44be-999f849008d2@redhat.com>
References: <20210903102039.55422-1-eesposit@redhat.com>
         <20210903102039.55422-4-eesposit@redhat.com>
         <21d2bf8c4e3eb3fc5d297fd13300557ec686b625.camel@redhat.com>
         <73b5a5bb-48f2-3a08-c76b-a82b5b69c406@redhat.com>
         <9585f1387b2581d30b74cd163a9aac2adbd37a93.camel@redhat.com>
         <2b1e17416cef1e37f42e9bc8b2283b03d2651cb2.camel@redhat.com>
         <ee207b0c-eab3-13ba-44be-999f849008d2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-09-14 at 11:24 +0200, Emanuele Giuseppe Esposito wrote:
> 
> On 14/09/2021 11:12, Maxim Levitsky wrote:
> > On Tue, 2021-09-14 at 12:02 +0300, Maxim Levitsky wrote:
> > > On Tue, 2021-09-14 at 10:20 +0200, Emanuele Giuseppe Esposito wrote:
> > > > On 12/09/2021 12:42, Maxim Levitsky wrote:
> > > > > >    
> > > > > > -	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
> > > > > > +	if (!nested_vmcb_valid_sregs(vcpu, &svm->nested.save) ||
> > > > > >    	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
> > > > > If you use a different struct for the copied fields, then it makes
> > > > > sense IMHO to drop the 'control' parameter from nested_vmcb_check_controls,
> > > > > and just use the svm->nested.save there directly.
> > > > > 
> > > > 
> > > > Ok, what you say in patch 2 makes sense to me. I can create a new struct
> > > > vmcb_save_area_cached, but I need to keep nested.ctl because 1) it is
> > > > used also elsewhere, and different fields from the one checked here are
> > > > read/set and 2) using another structure (or the same
> > > 
> > > Yes, keep nested.ctl, since vast majority of the fields are copied I think.
> > 
> > But actually that you mention it, I'll say why not to create vmcb_control_area_cached
> > as well indeed and change the type of svm->nested.save to it. (in a separate patch)
> > 
> > I see what you mean that we modify it a bit (but we shoudn't to be honest) and such, but
> > all of this can be fixed.
> 
> So basically you are proposing:
> 
> struct svm_nested_state {
> 	...
> 	struct vmcb_control_area ctl; // we need this because it is used 
> everywhere, I think
> 	struct vmcb_control_area_cached ctl_cached;
> 	struct vmcb_save_area_cached save_cached;
> 	...
> }
> 
> and then
> 
> if (!nested_vmcb_valid_sregs(vcpu, &svm->nested.save_cached) ||
>      !nested_vmcb_check_controls(vcpu, &svm->nested.ctl_cached)) {
> 
> like that?
> 
> Or do you want to delete nested.ctl completely and just keep the fields 
> actually used in ctl_cached?


I would do it this way:

struct svm_nested_state {
        ...
	/* cached fields from the vmcb12 */
	struct  vmcb_control_area_cached ctl;
	struct  vmcb_save_area_cached save;
        ...
};


Best regards,
     Maxim Levitsky

> 
> 
> Also, note that as I am trying to use vmcb_save_area_cached, it is worth 
> noticing that nested_vmcb_valid_sregs() is also used in 
> svm_set_nested_state(), so it requires some additional little changes.
> 
> Thank you,
> Emanuele
> 
> > The advantage of having vmcb_control_area_cached is that it becomes impossible to use
> > by mistake a non copied field from the guest.
> > 
> > It would also emphasize that this stuff came from the guest and should be treated as
> > a toxic waste.
> > 
> > Note again that this should be done if we agree as a separate patch.
> > 
> > > Best regards,
> > > 	Maxim Levitsky
> > > 
> > > 
> > > > vmcb_save_area_cached) in its place would just duplicate the same fields
> > > > of nested.ctl, creating even more confusion and possible inconsistency.
> > > > 
> > > > Let me know if you disagree.
> > > > 
> > > > Thank you,
> > > > Emanuele
> > > > 


