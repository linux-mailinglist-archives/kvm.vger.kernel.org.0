Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC10C3EF04D
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhHQQlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 12:41:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230481AbhHQQlF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 12:41:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629218432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fNaGipvioJpgk3bBjmIgMjI5Rp5j+UaiKI4Cvr/WG2w=;
        b=M7+xHxBu7ibFaDy6l1xCzNCHYxoSAJcmFsMLYm2oRaT/XT32KYUop1cQClLBK/7JAulWTM
        FeYsVT/feUVo9zsbGVTa1R9M3Kub5pUjLf1pbE7ogK7tMqcMtJmNBAwr1Mm8iCeUSFXE/E
        3FK9zAA/3mV7F0kfI9QPuyv+ALI/wSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-1I0h7L5yOD6Ka5_57sWaxA-1; Tue, 17 Aug 2021 12:40:30 -0400
X-MC-Unique: 1I0h7L5yOD6Ka5_57sWaxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBABF1051470;
        Tue, 17 Aug 2021 16:40:29 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7685010013D6;
        Tue, 17 Aug 2021 16:40:28 +0000 (UTC)
Message-ID: <efd07fdb5646e6a983d234a0e0bed8db6da4a890.camel@redhat.com>
Subject: Re: RFC: Proposal to create a new version of the SVM nested state
 migration blob
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Date:   Tue, 17 Aug 2021 19:40:27 +0300
In-Reply-To: <1ff7a205-283d-d2b3-d130-e40066f59df0@redhat.com>
References: <332b6896f595282ea3d261095612fd31ce4cf14f.camel@redhat.com>
         <1ff7a205-283d-d2b3-d130-e40066f59df0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-08-16 at 18:50 +0200, Paolo Bonzini wrote:
> On 16/08/21 14:54, Maxim Levitsky wrote:
> > Then on nested VM exit,
> > we would only restore the kvm's guest visible values (vcpu->arch.cr*/efer)
> > from that 'somewhere else', and could do this without any checks/etc, since these already passed all checks.
> >   
> > This needs to save these values in the migration stream as well of course.
> 
> Note that there could be differences between the guest-visible values 
> and the processor values of CRx.  In particular, say you have a 
> hypervisor that uses PSE for its page tables.  The CR4 would have 
> CR4.PSE=1 on a machine that uses NPT and CR4.PAE=1 on a machine that 
> doesn't.

Exactly what I said in the mail, about a more minor problem
which kind of irritates me, but not something urgent:

I proposed that on nested entry we leave the processor values in vmcb01,
as is, and backup the guest visible values in say 'svm->nested.hsave.cr*'
or something like that.
Later on nested VM exit we restore vcpu.arch.cr* values from 'svm->nested.hsave.cr*'
and leave the vmcb01 values alone.
 
That isn't strictly related to nested migration state but it seemed
to me that it would be also nice to have both guest visible
and cpu visible values of L1 save state in migration state 
as well while we are at redefining it.

Maybe this is an overkill.



> 
> > Finally I propose that SVM nested state would be:
> >  
> > * L1 save area.
> > * L1 guest visible CR*/EFER/etc values (vcpu->arch.cr* values)
> > * Full VMCB12 (save and control area)
> 
> So your proposal would basically be to:
> 
> * do the equivalent of sync_vmcs02_to_vmcs12+sync_vmcs02_to_vmcs12_rare 
> on KVM_GET_NESTED_STATE



> 
> * discard the current state on KVM_SET_NESTED_STATE.
> 
> That does make sense.  It wasn't done this way just because the "else" 
> branch of
> 
>          if (is_guest_mode(vcpu)) {
>                  sync_vmcs02_to_vmcs12(vcpu, vmcs12);
>                  sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>          } else  {
>                  copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
>                  if (!vmx->nested.need_vmcs12_to_shadow_sync) {
>                          if (vmx->nested.hv_evmcs)
>                                  copy_enlightened_to_vmcs12(vmx);
>                          else if (enable_shadow_vmcs)
>                                  copy_shadow_to_vmcs12(vmx);
>                  }
>          }
> 
> isn't needed on SVM and thus it seemed "obvious" to remove the "then" 
> branch as well.  I just focused on enter_svm_guest_mode when refactoring 
> the common bits of vmentry and KVM_SET_NESTED_STATE, so there is not 
> even a function like sync_vmcb02_to_vmcb12 (instead it's just done in 
> nested_svm_vmexit).

Yes. The else branch is due to the fact that even while the L1 is running,
the vmcs12 is usually not up to date, which is hidden by vmread/vmwrite
intercepts. 

This isn't possible on SVM due to memory mapped nature of VMCB
which forces us to sync vmcb12 after each nested vm exit.

 
I did indeed overlook the fact that vmcb12 save area is not up to date,
in fact I probably won't even want to read it from the guest memory
at the KVM_GET_NESTED_STATE time.
 
But it can be constructed from the KVM's guest visible CR* values,
and values in the VMCB02, roughly like how sync_vmcs02_to_vmcs12,
or how nested_svm_vmexit does it.


> 
> It does have some extra complications, for example with SREGS2 and the 
> always more complicated ordering of KVM_SET_* ioctls.
> 
> On the other hand, issues like not migrating PDPTRs were not specific to 
> nested SVM, and merely exposed by it.  The ordering issues with 
> KVM_SET_VCPU_EVENTS and KVM_SET_MP_STATE's handling of INIT and SIPI are 
> also not specific to nested SVM.  I am not sure that including the full 
> VMCB12 in the SVM nested state would solve any of these.  Anything that 
> would be solved, probably would be just because migrating a large blob 
> is easier than juggling a dozen ioctls.


The core of my proposal is that while it indeed makes the retrieval of the
nested state a bit more complicated, but it makes restore of the nested state
much simpler, since it can be treated as if we are just doing a nested entry,
eliminating the various special cases we have to have in nested state load on SVM.
 
Security wise, a bug during retrieval, isn't as bad as a bug during loading of the
state, so it makes sense to make the load of the state share as much code
with normal nested entry.
 
That means that the whole VMCB12 image can be checked as a whole and loaded
replacing most of the existing cpu state, in the same manner to regular
nested entry.
 
This also makes nested state load less dependant on its ordering vs setting of
the other cpu state.
 
So what do you think? Is it worth it for me to write a RFC patch series for this?

Best regards,
	Maxim Levitsky



> 
> Thanks,
> 
> Paolo
> 


