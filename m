Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0E83B32B4
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 17:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhFXPip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 11:38:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhFXPio (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 11:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624548985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=azp4h4TZTphxfJKEmVT18/mgaFYuWEa72oXBCTaQmVU=;
        b=AUtSvoxM49XFoGqm5xbsoIrnIj08AGJkKqWyBoQ55nR/vXvTlKx57bVhujbzdMXrGh3iwr
        JZREZAHfGzSLYgmTaqwVsQ1AQrOB0Nzmmr80pE4nPa7gEEe/uOUZkpwNtWzUhXqtk4DBHw
        VSPrlj4urKKxlgjYHorapSf24J6ponU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-ZXuBCwOsOjGLcFyaSwH20A-1; Thu, 24 Jun 2021 11:36:21 -0400
X-MC-Unique: ZXuBCwOsOjGLcFyaSwH20A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 401DD1923765;
        Thu, 24 Jun 2021 15:36:20 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5BC25D6CF;
        Thu, 24 Jun 2021 15:36:13 +0000 (UTC)
Message-ID: <613c6a638bbb91d5841162747c700b164d994d88.camel@redhat.com>
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Jun 2021 18:36:12 +0300
In-Reply-To: <6fc7213f-9836-0245-39bb-a05554c85680@amd.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
         <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
         <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
         <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
         <87pmwc4sh4.fsf@vitty.brq.redhat.com>
         <5fc502b70a89e18034716166abc65caec192c19b.camel@redhat.com>
         <YNNc9lKIzM6wlDNf@google.com> <YNNfnLsc+3qMsdlN@google.com>
         <82327cd1-92ca-9f6b-3af0-8215e9d21eae@redhat.com>
         <83affeedb9a3d091bece8f5fdd5373342298dcd3.camel@redhat.com>
         <a8945898-9fcb-19f1-1ba1-c9be55e04580@redhat.com>
         <6fc7213f-9836-0245-39bb-a05554c85680@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-06-24 at 09:32 -0500, Tom Lendacky wrote:
> On 6/24/21 5:38 AM, Paolo Bonzini wrote:
> > On 24/06/21 10:20, Maxim Levitsky wrote:
> > > Something else to note, just for our information is that KVM
> > > these days does vmsave/vmload to VM_HSAVE_PA to store/restore
> > > the additional host state, something that is frowned upon in the spec,
> > > but there is some justification of doing this in the commit message,
> > > citing an old spec which allowed this.
> > 
> > True that.  And there is no mention in the specification for VMRUN that
> > the host state-save area is a subset of the VMCB format (i.e., that it
> > uses VMCB offsets for whatever subset of the state it saves in the VMCB),
> > so the spec reference in the commit message is incorrect.  It would be
> > nice if the spec guaranteed that.  Michael, Tom?
> 
> So that is (now) stated in APM volume 2, Appendix B in the paragraph after
> Table B-3, where it starts "The format of the host save area is identical
> to the guest save area described in the table below, except that ..."

This is a very good find! I wish it was written in the commit message
of commit that added that vmsave/vmload to VM_HSAVE_PA area.

Maybe we should add a comment to the code pointing to this location of the APM.

Thanks,
	Best regards,
		Maxim Levitsky

> 
> Thanks,
> Tom
> 
> > In fact, Vitaly's patch *will* overwrite the vmsave/vmload parts of
> > VM_HSAVE_PA, and it will store the L2 values rather than the L1 values,
> > because KVM always does its vmload/vmrun/vmsave sequence using
> > vmload(vmcs01) and vmsave(vmcs01)!  So that has to be changed to use code
> > similar to svm_set_nested_state (which can be moved to a separate function
> > and reused):
> > 
> >         dest->es = src->es;
> >         dest->cs = src->cs;
> >         dest->ss = src->ss;
> >         dest->ds = src->ds;
> >         dest->gdtr = src->gdtr;
> >         dest->idtr = src->idtr;
> >         dest->rflags = src->rflags | X86_EFLAGS_FIXED;
> >         dest->efer = src->efer;
> >         dest->cr0 = src->cr0;
> >         dest->cr3 = src->cr3;
> >         dest->cr4 = src->cr4;
> >         dest->rax = src->rax;
> >         dest->rsp = src->rsp;
> >         dest->rip = src->rip;
> >         dest->cpl = 0;
> > 
> > 
> > Paolo
> > 


