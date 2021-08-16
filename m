Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD03ED45A
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 14:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhHPMyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 08:54:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230001AbhHPMyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 08:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629118459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1aBCNid+FsdWIG1NcQ8JIRQpqhBxYRIfZblS5BKJD0E=;
        b=INI7PYzvV+919lvlCooffj7jfAnQrxk6XlJpdGXJj1vs7tE119vxRPXplVKZy3ow+6D2hK
        h/dSPusG22E1hSsM4WAefCgKHumpAYzCkHQqnG7RQ+/j8raSKYLnPQOVzvhVoEYn+Fn+im
        zXk2wiIAeaQ+5WceCO8CG3ZqqJip7zw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-5qcRPz2ZPB66KLVz0s1irA-1; Mon, 16 Aug 2021 08:54:16 -0400
X-MC-Unique: 5qcRPz2ZPB66KLVz0s1irA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B20E1190A7A3;
        Mon, 16 Aug 2021 12:54:15 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5732C5D9D3;
        Mon, 16 Aug 2021 12:54:14 +0000 (UTC)
Message-ID: <332b6896f595282ea3d261095612fd31ce4cf14f.camel@redhat.com>
Subject: RFC: Proposal to create a new version of the SVM nested state
 migration blob
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Date:   Mon, 16 Aug 2021 15:54:13 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

Today I was studying again the differences between the SVM and VMX handling of the nested migration,
and I reached the conclusion that it might be worth it to create a new format of the SVM nested
state.
 
Especially since nested SVM mostly isn't yet in production, it might be a good time now
to fix this and reduce the overall complexity and difference in implementation vs VMX.
 
These are the issues with the current SVM nested state format:


1.


On VMX the nested state is very simple and straightforward. It is the VMCS12.
 
This works because while nested, the VMCS01 doesn't need to have a valid guest state at all,
since on nested VM exit, L1 guest state will be overwritten from VMCB12 constant 'host state'.
 
Thus on VMX, while nested, the VMCS01 is almost fully (sans things like TSC multiplier),
created by KVM, and can be recreated fully on the target machine, without a need to have (parts of it)
in the migration stream.
 
When loading the nested state on VMX, we work in a very similar manner as for the regular nested entry.
Even the same function that is used for regular entry, is used for loading of the nested state.
(nested_vmx_enter_non_root_mode).
 
We load both the control and save state from VMCS12 thus overwriting whatever L2 state exists currently
in the CPU registers.
 
 
On SVM on the other hand, the VMCB01 contains the L1 ‘host’ state
(after we ‘adjusted’ it, as I explain later), and it has to be migrated as well.
 
The straightforward nested state for the SVM, thus would be this ‘host’ state
*and* the VMCB12.
 
However due to whatever reasons, we didn’t implement the nested state in this way.
 
Instead, we don’t store the save area of the vmcb12 in the migration stream,
because in theory the register state of the L2 is restored prior/after setting of
the nested state using standard KVM_SET_{S|}REGS, and such.

We could have done the same for VMX as well.
 
And in this save area we store the *L1* save area (aka L1 ‘host state’) 
there, which we have to preserve unlike on VMX.
 
Thus in the end the nested state of SVM is also a VMCB but it is ‘stitched’
as explained above.
 
This forces us to have quite different code for loading the nested state and
for regular nested entry and can be prone to errors, and various issues.
It is also quite confusing.
 
One issue that is related to this, had to be worked around with another slight hack,
was that Vitaly recently found is that it is possible to enter L1 via a 'SMM detour':
If SMI happens while L2 is running, and L1 is not intercepting the SMI, 
we need to enter L1, but we (more similar to VMX) have to load fixed SMM host state, 
and don't touch the L1 'host' state stored in VMCB01.
 
Another issue which I am trying to fix related to the fact that on VMX it uses
the KVM_REQ_GET_NESTED_STATE_PAGES for VM entries that happen on exit from SMM
while SVM doesn’t, which is also a result of differences between the implementations.



2.

 
On SVM, the host state is transparently saved 'somewhere'.
'somewhere' is defined as either per cpu HSAVE area, or the cpu internal cache.
 
For nesting we opt for ‘cpu internal cache’ and keep the L1 'host' state in VMCB01 since it is already naturally saved
there, however we slightly modify this state which is also somewhat a hack, which also increases complexity and in this
case even should decrease the performance a little bit: 
 
We replace CPU visible values of CR0/CR3/CR4/EFER, 
with guest visible values (vcpu->arch.cr*/efer) to avoid losing them.
 
And then on nested VM exit we load the guest visible values again from VMCB01, and pass them to kvm_set_cr* 
functions, which add/remove bits as needed to get back the CPU visible values, and 
store them back to VMCB01, and store back the guest visible values into (vcpu->arch.cr*/efer)
 
That in theory should restore both the guest visible and cpu visible values of these registers,
but can be prone to errors.
 
It would be much cleaner if we kept vmcb01 as is, and stored the guest visible cr* values
somewhere else, which would allow us to avoid updating the vmcb01 twice.
 
Then on nested VM exit, 
we would only restore the kvm's guest visible values (vcpu->arch.cr*/efer) 
from that 'somewhere else', and could do this without any checks/etc, since these already passed all checks.
 
This needs to save these values in the migration stream as well of course.
 
Note that on VMX, this issue doesn’t exist since host state isn’t preserved, but rather
force loaded from the VMCS on each VM exit.
 
 
Finally I propose that SVM nested state would be:
 
* L1 save area.
* L1 guest visible CR*/EFER/etc values (vcpu->arch.cr* values)
* Full VMCB12 (save and control area)
 
 
What do you think?
 
 
For backward compatibility we can have a function that will 'convert' 
the old state to new state by guessing the L2 save area from current CPU state and treating the L1 save area
in the old state as area that was 'adjusted' with guest visible CR* values, thus keeping this complexity
In this conversion function which can even go away in the future.
 
 
I did most of this research today trying to fix a few bugs I introduced when I added my SREG2 ioctl,
in regard to exit back from SMM mode, which is also done differently on SVM than on VMX.
 
 
Best regards,
	Maxim Levitsky

