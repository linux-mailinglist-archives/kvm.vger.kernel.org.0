Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ABE49E6FC
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 17:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238330AbiA0QEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 11:04:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243305AbiA0QEH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 11:04:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643299446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=fIbRstT4/cTamd8SqTZI1RDSNWS11JxnOqrbWCUoUbc=;
        b=YhUPODeJ78/XRVIyF9A1hCY1Gwq9iPQBl45G+sKuAfcGTK23ILiH09R2/xi8tOjlehjRnU
        pC/nb9uZGMcCs9Jc5h2Lfgbf8/QdAzLpiJxqrl9fGlNF6QmH+x0KJo3XSJlcVJuLJ0RHQr
        GGeNxzq6f83h2g3VotuFxWccmJzx21E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-wezKMyx7Mv20zPjQM-Zogw-1; Thu, 27 Jan 2022 11:04:04 -0500
X-MC-Unique: wezKMyx7Mv20zPjQM-Zogw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A743D1091DA3;
        Thu, 27 Jan 2022 16:04:03 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CAD8708D7;
        Thu, 27 Jan 2022 16:03:55 +0000 (UTC)
Message-ID: <fc6bea3249f26e8dd973ce1bd1e3f6f42c142469.camel@redhat.com>
Subject: Why do we need KVM_REQ_GET_NESTED_STATE_PAGES after all
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gilbert <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, Peter Xu <peterx@redhat.com>
Date:   Thu, 27 Jan 2022 18:03:54 +0200
Content-Type: multipart/mixed; boundary="=-u5dK/6uiM8T5xug6fSqD"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-u5dK/6uiM8T5xug6fSqD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

I would like to raise a question about this elephant in the room which I wanted to understand for 
quite a long time.
 
For my nested AVIC work I once again need to change the KVM_REQ_GET_NESTED_STATE_PAGES code and once
again I am asking myself, maybe we can get rid of this code, after all?
  
And of course if we don't need it, getting rid of it would be a very happy day in my life 
(and likely in the life of all other KVM developers as well).
 
Needless to say that it already caused few CVE worthy issues which thankfully we patched before
it got to production, and on top of that, having different code flow for a very rare code path 
because nested migration only happens if you are lucky enough to have nested guest 
actually running during migration, which happens only once in a while, even when L1 is fully loaded. 
 
In my testing I always disable HLT exits to actually ensure that nested guest runs all the time,
sans vmexits.
 
====================================================================================================
 
So first of all what KVM_REQ_GET_NESTED_STATE_PAGES is:
 
KVM_REQ_GET_NESTED_STATE_PAGES exists to delay reading/writing/pinning of the guest memory, which is 
pointed by various fields of current vmcs/vmcb to next KVM_RUN, under an assumption that it is not 
safe to do in case when we do a non natural VM entry (which is either due to resume of nested
guest that was interrupted by SMM or when we set the nested state after migration.
 
The alleged reason for that is that either kvm's mmu is not in 'right state', or that userspace
VMM will do some modifications to the VM after the entry and before we actually enter the nested guest.
 
====================================================================================================
 
There are two cases where the KVM_REQ_GET_NESTED_STATE_PAGES is used:
 
1. Exit from SMM, back to an interrupted nested guest:
 
Note that on SVM we actually read the VMCB from the guest memory and HSAVE area,
already violating the rule of not reading guest memory.
On VMX at least we use the cached VMCS.
 
 
2. Loading the nested state.
 
In this case indeed both vmcb and vmcs come from the migration stream, thus we don't touch the 
guest memory when setting the nested state.
 
====================================================================================================
 
Now let see how the guest memory would be accessed on nested VM entry if we didn't use
KVM_REQ_GET_NESTED_STATE_PAGES:
 
First of all, AFAIK all SVM/VMX memory structures including the VMCB/VMCS itself are accessed 
by their physical address, thus we don't need to worry about guest's paging, and 
neither about nested NPT/EPT paging.
 
Shadow pages that MMU created are not relevant also because they are not used by KVM itself to
read guest's memory.
 
To access guest physical memory from KVM the following is done:
 
A. a set of memslots is chosen (calling __kvm_memslots())
 
   KVM keeps two sets of memory slots, one for 'Normal' address space and one for SMM address space.
 
   These memslots are setup by VMM, which usually updates it when the guest modifies
   virtual chipset's SMM related settings.
 
   Note that on standard Q35/i440fx chipsets which qemu emulates, those settings themselves are
   accessible through pci config space regardless of SMM, but have a lock bit which prevents non 
   SMM code to change them after VM's BIOS setup and locked them..
 
   Lots of places in the KVM hardcoded to use the 'Normal' memslots 
   (everyone who uses kvm_memslots for example).
   Others use the kvm_vcpu_memslots, which chooses memslots based on 'arch.hflags & HF_SMM_MASK'
 
   Thankfully we don't allow VMX/SVM in SMM (and I really hope that we never will), thus all the guest 
   memory structures including VMCB/VMCS would reside in the main guest memory and thus can be
   reached through 'Normal' memslots.
 
   From this we can deduce that loading of the nested state will never happen when the 
   VCPU is in SMM mode.
   KVM verifies this and denies setting the nested state if that is attempted.
 
   On returning from SMM to a nested guest, kvm_smm_changed is the first thing to be called,
   prior to calling vendor code which resumes the nested guest.
   kvm_smm_changed clears the HF_SMM_MASK flag, which selects Which memslots to take when doing 
   guest physical to host virtual translation.
 
   Based on this reasoning, we can say that nested guest entries we will never access the 
   SMM memslots, even if we attempt to access the guest memory during the setting of the nested state.
 
 
B. From the 'Normal' memslots, the host virtual address of the page containing the guest physical 
   memory is obtained.
   Page itself might be swapped out or not even present at all if post-copy migration is used.
 
   AFAIK, I don't see a reason why QEMU or any other KVM user would not upload the correct memory slot
   set, after a nested migration.
 
   In fact qemu rarely modifies the memory slots. It does have some memslots for devices which
   Have ram like memory but if the guest attempts to place there VM related structure, it is welcome
   to keep both pieces.
 
   Actual RAM memslots should only be modified during runtime when RAM hotplug happens or so,
   which even if happen after nested migration, would not be an issue as the fact that they 
   Happen after a migration means that guest VM structures couldn’t be in these memslots.
 
   Qemu resets and loads the state for all the devices, and they match the original devices on the 
   migration source, and seems to upload the nested state last.
   It might not migrate all ram, but rather register it with userfaultd, but that isn't an
   issue (see below)
 
   For returns from the SMM, the chances that this memslot map is not up to date are even lower.
   In fact, returning from smm usually won't even cause a userspace vmexit to let qemu mess with
   this map.
 
 
3. Once the host’s virtual address of the guest's page obtained, stock kernel paging 
   facilities are used to obtain the page (swap-in, userfaultd, etc) and
    then obtain its physical address.
 
   Once again on return from SMM, there should be no issues.
 
   After nested migration page might not be present but that will lead to either swapping it in,
   or asking qemu via userfaultd to bring it via userfaultd interface while doing post-copy migration.
   
   In regard to post-copy migration, other VMMs ought to work the same (use userfaultd).
   In theory a VMM could instead handle SIGSEGV, as an indication of a page fault but that would
   not really work due to many reasons.
   
   
So, having said all that, the only justification for KVM_REQ_GET_NESTED_STATE_PAGES
would be an VMM which first sets the CPU nested state and then setups the VMAs for guest memory
and uploads them to KVM via memslots.
 
Since nested migration is something relatively new, there is good chance that nobody does this,
and then requiring that guest memory is present before setting a nested state (or at least memory
which is pointed by the VMX/SVM structs) seems like a reasonable requirement.
 
On top of that, that simplifies the API usage by not delaying the error to the next VM run,
if truly there is an issue with this guest memory pointed by the nested state.
 
 
PS: Few technical notes:
 
====================================================================================================
A. Note on eVMCS usage of KVM_REQ_GET_NESTED_STATE_PAGES:
====================================================================================================
 
When eVMCS which is a guest memory page, representing a VM, similar to VMCB is used 
(this is HV specific PV feature), VMCS fields are loaded from it.
 
Thankfully after nested migration or return from SMM, we already have up to date vmcs12 either read
from the migration stream or saved in kernel memory.
 
We only need the guest physical address of this memory page, to map and pin it, so that later on,
after the nested entry/exit we could read/write it.
 
It address is (indirectly) obtained from msr HV_X64_MSR_VP_ASSIST_PAGE, which qemu restores after
it sets the nested state.
 
Currently to support this, setting nested state with eVMCS is allowed without this msr set,
and later KVM_REQ_GET_NESTED_STATE_PAGES actually maps the eVMCS page.
 
There is also a workaround that was relatively recently added to map eVMCS also when
KVM_REQ_GET_NESTED_STATE_PAGES haven’t got called after nested migration which can happen if we
have nested VM exit prior to entering the guest even once after setting the nested state.
Workaround was to also map eVMCS on nested VM exit.
 
IMHO the right way to fix this, assuming that we drop KVM_REQ_GET_NESTED_STATE_PAGES is to just
map the eVMCS when the HV_X64_MSR_VP_ASSIST_PAGE is set by qemu (host write) after nested state with
active eVMCS was set (that is we are nested but with vmptr == -1 )
 

====================================================================================================
B: Some digital archaeology for reference:
====================================================================================================

First of all we have those two commits:
 
commit a7d5c7ce41ac1e2537d78ddb57ef0ac4f737aa19
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue Sep 22 07:43:14 2020 -0400
 
	KVM: nSVM: delay MSR permission processing to first nested VM run
    
	Allow userspace to set up the memory map after KVM_SET_NESTED_STATE;
	to do so, move the call to nested_svm_vmrun_msrpm inside the
	KVM_REQ_GET_NESTED_STATE_PAGES handler (which is currently
	not used by nSVM).  This is similar to what VMX does already.
    
	Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
 
commit 729c15c20f1a7c9ad1d09a603ad1aa7fb60b1f88
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue Sep 22 06:53:57 2020 -0400
 
	KVM: x86: rename KVM_REQ_GET_VMCS12_PAGES
    
	We are going to use it for SVM too, so use a more generic name.
	Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
	

These two commits were added around the same time I  started fixing the SVM's nested migration
which was just implemented and didn't yet receive any real-world testing.

SVM's code used to not even read the nested msr bitmap which I fixed, and there is a good change
that the above commit was added just in case to make SVM's code do the same thing as VMX does.
	

If we go deeper, we get this commit, from which it all started:
 
 
commit 7f7f1ba33cf2c21d001821313088c231db42ff40
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed Jul 18 18:49:01 2018 +0200
 
	KVM: x86: do not load vmcs12 pages while still in SMM
    
	If the vCPU enters system management mode while running a nested guest,
	RSM starts processing the vmentry while still in SMM.  In that case,
	however, the pages pointed to by the vmcs12 might be incorrectly
	loaded from SMRAM.  To avoid this, delay the handling of the pages
	until just before the next vmentry.  This is done with a new request
	and a new entry in kvm_x86_ops, which we will be able to reuse for
	nested VMX state migration.
    
	Extracted from a patch by Jim Mattson and KarimAllah Ahmed.
    
	Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
 

That commit was part of initial patch series which implemented the nested migration,
and it could be very well that the above commit was just a precation.
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1740085.html


Looking back at the old code before this commit, I wonder if that was needed even back then:
 
In the original code just prior to the this commit we had this weird code:
 
                vcpu->arch.hflags &= ~HF_SMM_MASK;
                ret = enter_vmx_non_root_mode(vcpu, NULL);
                vcpu->arch.hflags |= HF_SMM_MASK; <- why do we set it back 
 
 
Yet, it did clear the HF_SMM_MASK just prior to nested entry,
thus correct memslots should be accessed even back then, and I don't think that MSR bitmap would
be loaded from SMM memory.


====================================================================================================
C: POC
====================================================================================================

I attached the patch which removes the KVM_REQ_GET_NESTED_STATE_PAGES which I lightly tested.
I didn't test the eVMCS side of things. Works for me on SVM and VMX.

I also added debug prints to qemu and used virtio-mem which was suspected to set memslots
after setting nested state. It seems that it really doesn't.



Best regards,
   Maxim Levitsky


--=-u5dK/6uiM8T5xug6fSqD
Content-Disposition: attachment;
	filename="0001-KVM-x86-get-rid-of-KVM_REQ_GET_NESTED_STATE_PAGES.patch"
Content-Type: text/x-patch;
	name="0001-KVM-x86-get-rid-of-KVM_REQ_GET_NESTED_STATE_PAGES.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAxMjkzMDJkY2ViNjU5YzlkNTYxNjc2ZmFhZjMzY2IzZWM2NGQwMmM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXhpbSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4K
RGF0ZTogV2VkLCAyNiBKYW4gMjAyMiAxNzoyMDoxOCArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIEtW
TTogeDg2OiBnZXQgcmlkIG9mIEtWTV9SRVFfR0VUX05FU1RFRF9TVEFURV9QQUdFUwoKVE9ETzog
YWRkIGNvbW1pdCBkZXNjcmlwdGlvbgoKU2lnbmVkLW9mZi1ieTogTWF4aW0gTGV2aXRza3kgPG1s
ZXZpdHNrQHJlZGhhdC5jb20+Ci0tLQogYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8
ICA1ICstCiBhcmNoL3g4Ni9rdm0vaHlwZXJ2LmMgICAgICAgICAgIHwgIDQgKysKIGFyY2gveDg2
L2t2bS9zdm0vbmVzdGVkLmMgICAgICAgfCA1MSArKysrLS0tLS0tLS0tLS0tLQogYXJjaC94ODYv
a3ZtL3N2bS9zdm0uYyAgICAgICAgICB8ICAyICstCiBhcmNoL3g4Ni9rdm0vc3ZtL3N2bS5oICAg
ICAgICAgIHwgIDMgKy0KIGFyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMgICAgICAgfCA5OSArKysr
KysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAg
ICAgICAgfCAgNiAtLQogNyBmaWxlcyBjaGFuZ2VkLCA0NiBpbnNlcnRpb25zKCspLCAxMjQgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKaW5kZXggODJiYzNlM2U5YjkzNS4uNWE1
ODgzNWI1YWYwZCAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAor
KysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCkBAIC05Miw3ICs5Miw2IEBACiAj
ZGVmaW5lIEtWTV9SRVFfSFZfRVhJVAkJCUtWTV9BUkNIX1JFUSgyMSkKICNkZWZpbmUgS1ZNX1JF
UV9IVl9TVElNRVIJCUtWTV9BUkNIX1JFUSgyMikKICNkZWZpbmUgS1ZNX1JFUV9MT0FEX0VPSV9F
WElUTUFQCUtWTV9BUkNIX1JFUSgyMykKLSNkZWZpbmUgS1ZNX1JFUV9HRVRfTkVTVEVEX1NUQVRF
X1BBR0VTCUtWTV9BUkNIX1JFUSgyNCkKICNkZWZpbmUgS1ZNX1JFUV9BUElDVl9VUERBVEUgXAog
CUtWTV9BUkNIX1JFUV9GTEFHUygyNSwgS1ZNX1JFUVVFU1RfV0FJVCB8IEtWTV9SRVFVRVNUX05P
X1dBS0VVUCkKICNkZWZpbmUgS1ZNX1JFUV9UTEJfRkxVU0hfQ1VSUkVOVAlLVk1fQVJDSF9SRVEo
MjYpCkBAIC0xNTAyLDEyICsxNTAxLDE0IEBAIHN0cnVjdCBrdm1feDg2X25lc3RlZF9vcHMgewog
CWludCAoKnNldF9zdGF0ZSkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAogCQkJIHN0cnVjdCBrdm1f
bmVzdGVkX3N0YXRlIF9fdXNlciAqdXNlcl9rdm1fbmVzdGVkX3N0YXRlLAogCQkJIHN0cnVjdCBr
dm1fbmVzdGVkX3N0YXRlICprdm1fc3RhdGUpOwotCWJvb2wgKCpnZXRfbmVzdGVkX3N0YXRlX3Bh
Z2VzKShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwogCWludCAoKndyaXRlX2xvZ19kaXJ0eSkoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LCBncGFfdCBsMl9ncGEpOwogCiAJaW50ICgqZW5hYmxlX2V2bWNz
KShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiAJCQkgICAgdWludDE2X3QgKnZtY3NfdmVyc2lvbik7
CiAJdWludDE2X3QgKCpnZXRfZXZtY3NfdmVyc2lvbikoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsK
KworCWJvb2wgKCpnZXRfZXZtY3NfcGFnZSkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKKwogfTsK
IAogc3RydWN0IGt2bV94ODZfaW5pdF9vcHMgewpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2h5
cGVydi5jIGIvYXJjaC94ODYva3ZtL2h5cGVydi5jCmluZGV4IDZlMzhhN2QyMmU5N2EuLmMxNTg4
NmVmYTlhNjYgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2bS9oeXBlcnYuYworKysgYi9hcmNoL3g4
Ni9rdm0vaHlwZXJ2LmMKQEAgLTE0OTQsNiArMTQ5NCwxMCBAQCBzdGF0aWMgaW50IGt2bV9odl9z
ZXRfbXNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIG1zciwgdTY0IGRhdGEsIGJvb2wgaG9z
dCkKIAkJCQkJICAgIGdmbl90b19ncGEoZ2ZuKSB8IEtWTV9NU1JfRU5BQkxFRCwKIAkJCQkJICAg
IHNpemVvZihzdHJ1Y3QgaHZfdnBfYXNzaXN0X3BhZ2UpKSkKIAkJCXJldHVybiAxOworCisJCWlm
IChob3N0ICYmIGt2bV94ODZfb3BzLm5lc3RlZF9vcHMtPmdldF9ldm1jc19wYWdlKQorCQkJaWYg
KGt2bV94ODZfb3BzLm5lc3RlZF9vcHMtPmdldF9ldm1jc19wYWdlKHZjcHUpKQorCQkJCXJldHVy
biAxOwogCQlicmVhazsKIAl9CiAJY2FzZSBIVl9YNjRfTVNSX0VPSToKZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2t2bS9zdm0vbmVzdGVkLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtL25lc3RlZC5jCmluZGV4
IGVkZDZjZjEzNDQxMTIuLjY2ZmEyNDc4ZDg5ZjYgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2bS9z
dm0vbmVzdGVkLmMKKysrIGIvYXJjaC94ODYva3ZtL3N2bS9uZXN0ZWQuYwpAQCAtNjc3LDcgKzY3
Nyw3IEBAIHN0YXRpYyB2b2lkIG5lc3RlZF9zdm1fY29weV9jb21tb25fc3RhdGUoc3RydWN0IHZt
Y2IgKmZyb21fdm1jYiwgc3RydWN0IHZtY2IgKnRvCiB9CiAKIGludCBlbnRlcl9zdm1fZ3Vlc3Rf
bW9kZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB2bWNiMTJfZ3BhLAotCQkJIHN0cnVjdCB2
bWNiICp2bWNiMTIsIGJvb2wgZnJvbV92bXJ1bikKKwkJCSBzdHJ1Y3Qgdm1jYiAqdm1jYjEyKQog
ewogCXN0cnVjdCB2Y3B1X3N2bSAqc3ZtID0gdG9fc3ZtKHZjcHUpOwogCWludCByZXQ7CkBAIC03
MDcsMTUgKzcwNywxMyBAQCBpbnQgZW50ZXJfc3ZtX2d1ZXN0X21vZGUoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LCB1NjQgdm1jYjEyX2dwYSwKIAluZXN0ZWRfdm1jYjAyX3ByZXBhcmVfc2F2ZShzdm0s
IHZtY2IxMik7CiAKIAlyZXQgPSBuZXN0ZWRfc3ZtX2xvYWRfY3IzKCZzdm0tPnZjcHUsIHN2bS0+
bmVzdGVkLnNhdmUuY3IzLAotCQkJCSAgbmVzdGVkX25wdF9lbmFibGVkKHN2bSksIGZyb21fdm1y
dW4pOworCQkJCSAgbmVzdGVkX25wdF9lbmFibGVkKHN2bSksIHRydWUpOwogCWlmIChyZXQpCiAJ
CXJldHVybiByZXQ7CiAKIAlpZiAoIW5wdF9lbmFibGVkKQogCQl2Y3B1LT5hcmNoLm1tdS0+aW5q
ZWN0X3BhZ2VfZmF1bHQgPSBzdm1faW5qZWN0X3BhZ2VfZmF1bHRfbmVzdGVkOwogCi0JaWYgKCFm
cm9tX3ZtcnVuKQotCQlrdm1fbWFrZV9yZXF1ZXN0KEtWTV9SRVFfR0VUX05FU1RFRF9TVEFURV9Q
QUdFUywgdmNwdSk7CiAKIAlzdm1fc2V0X2dpZihzdm0sIHRydWUpOwogCkBAIC03ODMsNyArNzgx
LDcgQEAgaW50IG5lc3RlZF9zdm1fdm1ydW4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCiAJc3Zt
LT5uZXN0ZWQubmVzdGVkX3J1bl9wZW5kaW5nID0gMTsKIAotCWlmIChlbnRlcl9zdm1fZ3Vlc3Rf
bW9kZSh2Y3B1LCB2bWNiMTJfZ3BhLCB2bWNiMTIsIHRydWUpKQorCWlmIChlbnRlcl9zdm1fZ3Vl
c3RfbW9kZSh2Y3B1LCB2bWNiMTJfZ3BhLCB2bWNiMTIpKQogCQlnb3RvIG91dF9leGl0X2VycjsK
IAogCWlmIChuZXN0ZWRfc3ZtX3ZtcnVuX21zcnBtKHN2bSkpCkBAIC04NjcsOCArODY1LDYgQEAg
aW50IG5lc3RlZF9zdm1fdm1leGl0KHN0cnVjdCB2Y3B1X3N2bSAqc3ZtKQogCXN2bS0+bmVzdGVk
LnZtY2IxMl9ncGEgPSAwOwogCVdBUk5fT05fT05DRShzdm0tPm5lc3RlZC5uZXN0ZWRfcnVuX3Bl
bmRpbmcpOwogCi0Ja3ZtX2NsZWFyX3JlcXVlc3QoS1ZNX1JFUV9HRVRfTkVTVEVEX1NUQVRFX1BB
R0VTLCB2Y3B1KTsKLQogCS8qIGluIGNhc2Ugd2UgaGFsdGVkIGluIEwyICovCiAJc3ZtLT52Y3B1
LmFyY2gubXBfc3RhdGUgPSBLVk1fTVBfU1RBVEVfUlVOTkFCTEU7CiAKQEAgLTEwNjYsOCArMTA2
Miw2IEBAIHZvaWQgc3ZtX2xlYXZlX25lc3RlZChzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkKIAkJbmVz
dGVkX3N2bV91bmluaXRfbW11X2NvbnRleHQodmNwdSk7CiAJCXZtY2JfbWFya19hbGxfZGlydHko
c3ZtLT52bWNiKTsKIAl9Ci0KLQlrdm1fY2xlYXJfcmVxdWVzdChLVk1fUkVRX0dFVF9ORVNURURf
U1RBVEVfUEFHRVMsIHZjcHUpOwogfQogCiBzdGF0aWMgaW50IG5lc3RlZF9zdm1fZXhpdF9oYW5k
bGVkX21zcihzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkKQEAgLTE1NDEsMTEgKzE1MzUsMTEgQEAgc3Rh
dGljIGludCBzdm1fc2V0X25lc3RlZF9zdGF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiAJICov
CiAKIAlyZXQgPSBuZXN0ZWRfc3ZtX2xvYWRfY3IzKCZzdm0tPnZjcHUsIHZjcHUtPmFyY2guY3Iz
LAotCQkJCSAgbmVzdGVkX25wdF9lbmFibGVkKHN2bSksIGZhbHNlKTsKKwkJCQkgIG5lc3RlZF9u
cHRfZW5hYmxlZChzdm0pLAorCQkJCSAgIXZjcHUtPmFyY2gucGRwdHJzX2Zyb21fdXNlcnNwYWNl
KTsKIAlpZiAoV0FSTl9PTl9PTkNFKHJldCkpCiAJCWdvdG8gb3V0X2ZyZWU7CiAKLQogCS8qCiAJ
ICogQWxsIGNoZWNrcyBkb25lLCB3ZSBjYW4gZW50ZXIgZ3Vlc3QgbW9kZS4gVXNlcnNwYWNlIHBy
b3ZpZGVzCiAJICogdm1jYjEyLmNvbnRyb2wsIHdoaWNoIHdpbGwgYmUgY29tYmluZWQgd2l0aCBM
MSBhbmQgc3RvcmVkIGludG8KQEAgLTE1NzAsMzIgKzE1NjQsNiBAQCBzdGF0aWMgaW50IHN2bV9z
ZXRfbmVzdGVkX3N0YXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKIAogCXN2bV9zd2l0Y2hfdm1j
Yihzdm0sICZzdm0tPm5lc3RlZC52bWNiMDIpOwogCW5lc3RlZF92bWNiMDJfcHJlcGFyZV9jb250
cm9sKHN2bSk7Ci0Ja3ZtX21ha2VfcmVxdWVzdChLVk1fUkVRX0dFVF9ORVNURURfU1RBVEVfUEFH
RVMsIHZjcHUpOwotCi0JcmV0ID0gMDsKLW91dF9mcmVlOgotCWtmcmVlKHNhdmUpOwotCWtmcmVl
KGN0bCk7Ci0KLQlyZXR1cm4gcmV0OwotfQotCi1zdGF0aWMgYm9vbCBzdm1fZ2V0X25lc3RlZF9z
dGF0ZV9wYWdlcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCi17Ci0Jc3RydWN0IHZjcHVfc3ZtICpz
dm0gPSB0b19zdm0odmNwdSk7Ci0KLQlpZiAoV0FSTl9PTighaXNfZ3Vlc3RfbW9kZSh2Y3B1KSkp
Ci0JCXJldHVybiB0cnVlOwotCi0JaWYgKCF2Y3B1LT5hcmNoLnBkcHRyc19mcm9tX3VzZXJzcGFj
ZSAmJgotCSAgICAhbmVzdGVkX25wdF9lbmFibGVkKHN2bSkgJiYgaXNfcGFlX3BhZ2luZyh2Y3B1
KSkKLQkJLyoKLQkJICogUmVsb2FkIHRoZSBndWVzdCdzIFBEUFRScyBzaW5jZSBhZnRlciBhIG1p
Z3JhdGlvbgotCQkgKiB0aGUgZ3Vlc3QgQ1IzIG1pZ2h0IGJlIHJlc3RvcmVkIHByaW9yIHRvIHNl
dHRpbmcgdGhlIG5lc3RlZAotCQkgKiBzdGF0ZSB3aGljaCBjYW4gbGVhZCB0byBhIGxvYWQgb2Yg
d3JvbmcgUERQVFJzLgotCQkgKi8KLQkJaWYgKENDKCFsb2FkX3BkcHRycyh2Y3B1LCB2Y3B1LT5h
cmNoLmNyMykpKQotCQkJcmV0dXJuIGZhbHNlOwogCiAJaWYgKCFuZXN0ZWRfc3ZtX3ZtcnVuX21z
cnBtKHN2bSkpIHsKIAkJdmNwdS0+cnVuLT5leGl0X3JlYXNvbiA9IEtWTV9FWElUX0lOVEVSTkFM
X0VSUk9SOwpAQCAtMTYwNSwxMyArMTU3MywxOCBAQCBzdGF0aWMgYm9vbCBzdm1fZ2V0X25lc3Rl
ZF9zdGF0ZV9wYWdlcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCiAJCXJldHVybiBmYWxzZTsKIAl9
CiAKLQlyZXR1cm4gdHJ1ZTsKKwlyZXQgPSAwOworb3V0X2ZyZWU6CisJa2ZyZWUoc2F2ZSk7CisJ
a2ZyZWUoY3RsKTsKKworCXJldHVybiByZXQ7CiB9CiAKKwogc3RydWN0IGt2bV94ODZfbmVzdGVk
X29wcyBzdm1fbmVzdGVkX29wcyA9IHsKIAkuY2hlY2tfZXZlbnRzID0gc3ZtX2NoZWNrX25lc3Rl
ZF9ldmVudHMsCiAJLnRyaXBsZV9mYXVsdCA9IG5lc3RlZF9zdm1fdHJpcGxlX2ZhdWx0LAotCS5n
ZXRfbmVzdGVkX3N0YXRlX3BhZ2VzID0gc3ZtX2dldF9uZXN0ZWRfc3RhdGVfcGFnZXMsCiAJLmdl
dF9zdGF0ZSA9IHN2bV9nZXRfbmVzdGVkX3N0YXRlLAogCS5zZXRfc3RhdGUgPSBzdm1fc2V0X25l
c3RlZF9zdGF0ZSwKIH07CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jIGIvYXJj
aC94ODYva3ZtL3N2bS9zdm0uYwppbmRleCAwZTZhZDE5ZDIwNWM5Li4wMGE5Mzk2ZjcyNmI5IDEw
MDY0NAotLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jCisrKyBiL2FyY2gveDg2L2t2bS9zdm0v
c3ZtLmMKQEAgLTQzMzQsNyArNDMzNCw3IEBAIHN0YXRpYyBpbnQgc3ZtX2xlYXZlX3NtbShzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsIGNvbnN0IGNoYXIgKnNtc3RhdGUpCiAJdm1jYjEyID0gbWFwLmh2
YTsKIAluZXN0ZWRfY29weV92bWNiX2NvbnRyb2xfdG9fY2FjaGUoc3ZtLCAmdm1jYjEyLT5jb250
cm9sKTsKIAluZXN0ZWRfY29weV92bWNiX3NhdmVfdG9fY2FjaGUoc3ZtLCAmdm1jYjEyLT5zYXZl
KTsKLQlyZXQgPSBlbnRlcl9zdm1fZ3Vlc3RfbW9kZSh2Y3B1LCB2bWNiMTJfZ3BhLCB2bWNiMTIs
IGZhbHNlKTsKKwlyZXQgPSBlbnRlcl9zdm1fZ3Vlc3RfbW9kZSh2Y3B1LCB2bWNiMTJfZ3BhLCB2
bWNiMTIpOwogCiAJaWYgKHJldCkKIAkJZ290byB1bm1hcF9zYXZlOwpkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva3ZtL3N2bS9zdm0uaCBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmgKaW5kZXggM2FjZWYw
ZGZjOWI5NC4uNTk3OWY0MTYzMjc1NiAxMDA2NDQKLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zdm0u
aAorKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5oCkBAIC01NTIsOCArNTUyLDcgQEAgc3RhdGlj
IGlubGluZSBib29sIG5lc3RlZF9leGl0X29uX25taShzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkKIAly
ZXR1cm4gdm1jYjEyX2lzX2ludGVyY2VwdCgmc3ZtLT5uZXN0ZWQuY3RsLCBJTlRFUkNFUFRfTk1J
KTsKIH0KIAotaW50IGVudGVyX3N2bV9ndWVzdF9tb2RlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwK
LQkJCSB1NjQgdm1jYl9ncGEsIHN0cnVjdCB2bWNiICp2bWNiMTIsIGJvb2wgZnJvbV92bXJ1bik7
CitpbnQgZW50ZXJfc3ZtX2d1ZXN0X21vZGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgdm1j
Yl9ncGEsIHN0cnVjdCB2bWNiICp2bWNiMTIpOwogdm9pZCBzdm1fbGVhdmVfbmVzdGVkKHN0cnVj
dCB2Y3B1X3N2bSAqc3ZtKTsKIHZvaWQgc3ZtX2ZyZWVfbmVzdGVkKHN0cnVjdCB2Y3B1X3N2bSAq
c3ZtKTsKIGludCBzdm1fYWxsb2NhdGVfbmVzdGVkKHN0cnVjdCB2Y3B1X3N2bSAqc3ZtKTsKZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMgYi9hcmNoL3g4Ni9rdm0vdm14L25l
c3RlZC5jCmluZGV4IDVhMjU5NWE2YmYwOGMuLmNiMjU5YjU4YTkxMTAgMTAwNjQ0Ci0tLSBhL2Fy
Y2gveDg2L2t2bS92bXgvbmVzdGVkLmMKKysrIGIvYXJjaC94ODYva3ZtL3ZteC9uZXN0ZWQuYwpA
QCAtMjkzLDggKzI5Myw2IEBAIHN0YXRpYyB2b2lkIGZyZWVfbmVzdGVkKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkKIAlpZiAoIXZteC0+bmVzdGVkLnZteG9uICYmICF2bXgtPm5lc3RlZC5zbW0udm14
b24pCiAJCXJldHVybjsKIAotCWt2bV9jbGVhcl9yZXF1ZXN0KEtWTV9SRVFfR0VUX05FU1RFRF9T
VEFURV9QQUdFUywgdmNwdSk7Ci0KIAl2bXgtPm5lc3RlZC52bXhvbiA9IGZhbHNlOwogCXZteC0+
bmVzdGVkLnNtbS52bXhvbiA9IGZhbHNlOwogCXZteC0+bmVzdGVkLnZteG9uX3B0ciA9IElOVkFM
SURfR1BBOwpAQCAtMjU5Miw3ICsyNTkwLDggQEAgc3RhdGljIGludCBwcmVwYXJlX3ZtY3MwMihz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCB2bWNzMTIgKnZtY3MxMiwKIAogCS8qIFNoYWRv
dyBwYWdlIHRhYmxlcyBvbiBlaXRoZXIgRVBUIG9yIHNoYWRvdyBwYWdlIHRhYmxlcy4gKi8KIAlp
ZiAobmVzdGVkX3ZteF9sb2FkX2NyMyh2Y3B1LCB2bWNzMTItPmd1ZXN0X2NyMywgbmVzdGVkX2Nw
dV9oYXNfZXB0KHZtY3MxMiksCi0JCQkJZnJvbV92bWVudHJ5LCBlbnRyeV9mYWlsdXJlX2NvZGUp
KQorCQkJCWZyb21fdm1lbnRyeSB8fCAhdmNwdS0+YXJjaC5wZHB0cnNfZnJvbV91c2Vyc3BhY2Us
CisJCQkJZW50cnlfZmFpbHVyZV9jb2RlKSkKIAkJcmV0dXJuIC1FSU5WQUw7CiAKIAkvKgpAQCAt
MzEyNCw3ICszMTIzLDcgQEAgc3RhdGljIGludCBuZXN0ZWRfdm14X2NoZWNrX3ZtZW50cnlfaHco
c3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCXJldHVybiAwOwogfQogCi1zdGF0aWMgYm9vbCBuZXN0
ZWRfZ2V0X2V2bWNzX3BhZ2Uoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQorYm9vbCBuZXN0ZWRfZ2V0
X2V2bWNzX3BhZ2Uoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogewogCXN0cnVjdCB2Y3B1X3ZteCAq
dm14ID0gdG9fdm14KHZjcHUpOwogCkBAIC0zMTYwLDE4ICszMTU5LDYgQEAgc3RhdGljIGJvb2wg
bmVzdGVkX2dldF92bWNzMTJfcGFnZXMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCXN0cnVjdCBw
YWdlICpwYWdlOwogCXU2NCBocGE7CiAKLQlpZiAoIXZjcHUtPmFyY2gucGRwdHJzX2Zyb21fdXNl
cnNwYWNlICYmCi0JICAgICFuZXN0ZWRfY3B1X2hhc19lcHQodm1jczEyKSAmJiBpc19wYWVfcGFn
aW5nKHZjcHUpKSB7Ci0JCS8qCi0JCSAqIFJlbG9hZCB0aGUgZ3Vlc3QncyBQRFBUUnMgc2luY2Ug
YWZ0ZXIgYSBtaWdyYXRpb24KLQkJICogdGhlIGd1ZXN0IENSMyBtaWdodCBiZSByZXN0b3JlZCBw
cmlvciB0byBzZXR0aW5nIHRoZSBuZXN0ZWQKLQkJICogc3RhdGUgd2hpY2ggY2FuIGxlYWQgdG8g
YSBsb2FkIG9mIHdyb25nIFBEUFRScy4KLQkJICovCi0JCWlmIChDQyghbG9hZF9wZHB0cnModmNw
dSwgdmNwdS0+YXJjaC5jcjMpKSkKLQkJCXJldHVybiBmYWxzZTsKLQl9Ci0KLQogCWlmIChuZXN0
ZWRfY3B1X2hhczIodm1jczEyLCBTRUNPTkRBUllfRVhFQ19WSVJUVUFMSVpFX0FQSUNfQUNDRVNT
RVMpKSB7CiAJCS8qCiAJCSAqIFRyYW5zbGF0ZSBMMSBwaHlzaWNhbCBhZGRyZXNzIHRvIGhvc3Qg
cGh5c2ljYWwKQEAgLTMyNTMsMjUgKzMyNDAsNiBAQCBzdGF0aWMgYm9vbCBuZXN0ZWRfZ2V0X3Zt
Y3MxMl9wYWdlcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCiAJcmV0dXJuIHRydWU7CiB9CiAKLXN0
YXRpYyBib29sIHZteF9nZXRfbmVzdGVkX3N0YXRlX3BhZ2VzKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkKLXsKLQlpZiAoIW5lc3RlZF9nZXRfZXZtY3NfcGFnZSh2Y3B1KSkgewotCQlwcl9kZWJ1Z19y
YXRlbGltaXRlZCgiJXM6IGVubGlnaHRlbmVkIHZtcHRybGQgZmFpbGVkXG4iLAotCQkJCSAgICAg
X19mdW5jX18pOwotCQl2Y3B1LT5ydW4tPmV4aXRfcmVhc29uID0gS1ZNX0VYSVRfSU5URVJOQUxf
RVJST1I7Ci0JCXZjcHUtPnJ1bi0+aW50ZXJuYWwuc3ViZXJyb3IgPQotCQkJS1ZNX0lOVEVSTkFM
X0VSUk9SX0VNVUxBVElPTjsKLQkJdmNwdS0+cnVuLT5pbnRlcm5hbC5uZGF0YSA9IDA7Ci0KLQkJ
cmV0dXJuIGZhbHNlOwotCX0KLQotCWlmIChpc19ndWVzdF9tb2RlKHZjcHUpICYmICFuZXN0ZWRf
Z2V0X3ZtY3MxMl9wYWdlcyh2Y3B1KSkKLQkJcmV0dXJuIGZhbHNlOwotCi0JcmV0dXJuIHRydWU7
Ci19Ci0KIHN0YXRpYyBpbnQgbmVzdGVkX3ZteF93cml0ZV9wbWxfYnVmZmVyKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwgZ3BhX3QgZ3BhKQogewogCXN0cnVjdCB2bWNzMTIgKnZtY3MxMjsKQEAgLTM0
MDEsMTIgKzMzNjksMTIgQEAgZW51bSBudm14X3ZtZW50cnlfc3RhdHVzIG5lc3RlZF92bXhfZW50
ZXJfbm9uX3Jvb3RfbW9kZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiAKIAlwcmVwYXJlX3ZtY3Mw
Ml9lYXJseSh2bXgsICZ2bXgtPnZtY3MwMSwgdm1jczEyKTsKIAotCWlmIChmcm9tX3ZtZW50cnkp
IHsKLQkJaWYgKHVubGlrZWx5KCFuZXN0ZWRfZ2V0X3ZtY3MxMl9wYWdlcyh2Y3B1KSkpIHsKLQkJ
CXZteF9zd2l0Y2hfdm1jcyh2Y3B1LCAmdm14LT52bWNzMDEpOwotCQkJcmV0dXJuIE5WTVhfVk1F
TlRSWV9LVk1fSU5URVJOQUxfRVJST1I7Ci0JCX0KKwlpZiAodW5saWtlbHkoIW5lc3RlZF9nZXRf
dm1jczEyX3BhZ2VzKHZjcHUpKSkgeworCQl2bXhfc3dpdGNoX3ZtY3ModmNwdSwgJnZteC0+dm1j
czAxKTsKKwkJcmV0dXJuIE5WTVhfVk1FTlRSWV9LVk1fSU5URVJOQUxfRVJST1I7CisJfQogCisJ
aWYgKGZyb21fdm1lbnRyeSkgewogCQlpZiAobmVzdGVkX3ZteF9jaGVja192bWVudHJ5X2h3KHZj
cHUpKSB7CiAJCQl2bXhfc3dpdGNoX3ZtY3ModmNwdSwgJnZteC0+dm1jczAxKTsKIAkJCXJldHVy
biBOVk1YX1ZNRU5UUllfVk1GQUlMOwpAQCAtMzQyOCwyNCArMzM5NiwxNCBAQCBlbnVtIG52bXhf
dm1lbnRyeV9zdGF0dXMgbmVzdGVkX3ZteF9lbnRlcl9ub25fcm9vdF9tb2RlKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwKIAkJZ290byB2bWVudHJ5X2ZhaWxfdm1leGl0X2d1ZXN0X21vZGU7CiAJfQog
Ci0JaWYgKGZyb21fdm1lbnRyeSkgewotCQlmYWlsZWRfaW5kZXggPSBuZXN0ZWRfdm14X2xvYWRf
bXNyKHZjcHUsCi0JCQkJCQkgICB2bWNzMTItPnZtX2VudHJ5X21zcl9sb2FkX2FkZHIsCi0JCQkJ
CQkgICB2bWNzMTItPnZtX2VudHJ5X21zcl9sb2FkX2NvdW50KTsKLQkJaWYgKGZhaWxlZF9pbmRl
eCkgewotCQkJZXhpdF9yZWFzb24uYmFzaWMgPSBFWElUX1JFQVNPTl9NU1JfTE9BRF9GQUlMOwot
CQkJdm1jczEyLT5leGl0X3F1YWxpZmljYXRpb24gPSBmYWlsZWRfaW5kZXg7Ci0JCQlnb3RvIHZt
ZW50cnlfZmFpbF92bWV4aXRfZ3Vlc3RfbW9kZTsKLQkJfQotCX0gZWxzZSB7Ci0JCS8qCi0JCSAq
IFRoZSBNTVUgaXMgbm90IGluaXRpYWxpemVkIHRvIHBvaW50IGF0IHRoZSByaWdodCBlbnRpdGll
cyB5ZXQgYW5kCi0JCSAqICJnZXQgcGFnZXMiIHdvdWxkIG5lZWQgdG8gcmVhZCBkYXRhIGZyb20g
dGhlIGd1ZXN0IChpLmUuIHdlIHdpbGwKLQkJICogbmVlZCB0byBwZXJmb3JtIGdwYSB0byBocGEg
dHJhbnNsYXRpb24pLiBSZXF1ZXN0IGEgY2FsbAotCQkgKiB0byBuZXN0ZWRfZ2V0X3ZtY3MxMl9w
YWdlcyBiZWZvcmUgdGhlIG5leHQgVk0tZW50cnkuICBUaGUgTVNScwotCQkgKiBoYXZlIGFscmVh
ZHkgYmVlbiBzZXQgYXQgdm1lbnRyeSB0aW1lIGFuZCBzaG91bGQgbm90IGJlIHJlc2V0LgotCQkg
Ki8KLQkJa3ZtX21ha2VfcmVxdWVzdChLVk1fUkVRX0dFVF9ORVNURURfU1RBVEVfUEFHRVMsIHZj
cHUpOworCisJZmFpbGVkX2luZGV4ID0gbmVzdGVkX3ZteF9sb2FkX21zcih2Y3B1LAorCQkJCQkg
ICB2bWNzMTItPnZtX2VudHJ5X21zcl9sb2FkX2FkZHIsCisJCQkJCSAgIHZtY3MxMi0+dm1fZW50
cnlfbXNyX2xvYWRfY291bnQpOworCWlmIChmYWlsZWRfaW5kZXgpIHsKKwkJZXhpdF9yZWFzb24u
YmFzaWMgPSBFWElUX1JFQVNPTl9NU1JfTE9BRF9GQUlMOworCQl2bWNzMTItPmV4aXRfcXVhbGlm
aWNhdGlvbiA9IGZhaWxlZF9pbmRleDsKKwkJZ290byB2bWVudHJ5X2ZhaWxfdm1leGl0X2d1ZXN0
X21vZGU7CiAJfQogCiAJLyoKQEAgLTQ1MTUsMTYgKzQ0NzMsNiBAQCB2b2lkIG5lc3RlZF92bXhf
dm1leGl0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIHZtX2V4aXRfcmVhc29uLAogCS8qIFNp
bWlsYXJseSwgdHJpcGxlIGZhdWx0cyBpbiBMMiBzaG91bGQgbmV2ZXIgZXNjYXBlLiAqLwogCVdB
Uk5fT05fT05DRShrdm1fY2hlY2tfcmVxdWVzdChLVk1fUkVRX1RSSVBMRV9GQVVMVCwgdmNwdSkp
OwogCi0JaWYgKGt2bV9jaGVja19yZXF1ZXN0KEtWTV9SRVFfR0VUX05FU1RFRF9TVEFURV9QQUdF
UywgdmNwdSkpIHsKLQkJLyoKLQkJICogS1ZNX1JFUV9HRVRfTkVTVEVEX1NUQVRFX1BBR0VTIGlz
IGFsc28gdXNlZCB0byBtYXAKLQkJICogRW5saWdodGVuZWQgVk1DUyBhZnRlciBtaWdyYXRpb24g
YW5kIHdlIHN0aWxsIG5lZWQgdG8KLQkJICogZG8gdGhhdCB3aGVuIHNvbWV0aGluZyBpcyBmb3Jj
aW5nIEwyLT5MMSBleGl0IHByaW9yIHRvCi0JCSAqIHRoZSBmaXJzdCBMMiBydW4uCi0JCSAqLwot
CQkodm9pZCluZXN0ZWRfZ2V0X2V2bWNzX3BhZ2UodmNwdSk7Ci0JfQotCiAJLyogU2VydmljZSBw
ZW5kaW5nIFRMQiBmbHVzaCByZXF1ZXN0cyBmb3IgTDIgYmVmb3JlIHN3aXRjaGluZyB0byBMMS4g
Ki8KIAlrdm1fc2VydmljZV9sb2NhbF90bGJfZmx1c2hfcmVxdWVzdHModmNwdSk7CiAKQEAgLTYz
NDgsMTQgKzYyOTYsMTcgQEAgc3RhdGljIGludCB2bXhfc2V0X25lc3RlZF9zdGF0ZShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsCiAKIAkJc2V0X2N1cnJlbnRfdm1wdHIodm14LCBrdm1fc3RhdGUtPmhk
ci52bXgudm1jczEyX3BhKTsKIAl9IGVsc2UgaWYgKGt2bV9zdGF0ZS0+ZmxhZ3MgJiBLVk1fU1RB
VEVfTkVTVEVEX0VWTUNTKSB7CisKKwkJdm14LT5uZXN0ZWQuaHZfZXZtY3Nfdm1wdHIgPSBFVk1Q
VFJfTUFQX1BFTkRJTkc7CisKIAkJLyoKIAkJICogbmVzdGVkX3ZteF9oYW5kbGVfZW5saWdodGVu
ZWRfdm1wdHJsZCgpIGNhbm5vdCBiZSBjYWxsZWQKLQkJICogZGlyZWN0bHkgZnJvbSBoZXJlIGFz
IEhWX1g2NF9NU1JfVlBfQVNTSVNUX1BBR0UgbWF5IG5vdCBiZQotCQkgKiByZXN0b3JlZCB5ZXQu
IEVWTUNTIHdpbGwgYmUgbWFwcGVkIGZyb20KLQkJICogbmVzdGVkX2dldF92bWNzMTJfcGFnZXMo
KS4KKwkJICogZGlyZWN0bHkgZnJvbSBoZXJlIGlmIEhWX1g2NF9NU1JfVlBfQVNTSVNUX1BBR0Ug
aXMgbm90CisJCSAqIHJlc3RvcmVkIHlldC4gRVZNQ1Mgd2lsbCBiZSBtYXBwZWQgd2hlbiBpdCBp
cy4KIAkJICovCi0JCXZteC0+bmVzdGVkLmh2X2V2bWNzX3ZtcHRyID0gRVZNUFRSX01BUF9QRU5E
SU5HOwotCQlrdm1fbWFrZV9yZXF1ZXN0KEtWTV9SRVFfR0VUX05FU1RFRF9TVEFURV9QQUdFUywg
dmNwdSk7CisJCWlmIChrdm1faHZfYXNzaXN0X3BhZ2VfZW5hYmxlZCh2Y3B1KSkKKwkJCW5lc3Rl
ZF9nZXRfZXZtY3NfcGFnZSh2Y3B1KTsKKwogCX0gZWxzZSB7CiAJCXJldHVybiAtRUlOVkFMOwog
CX0KQEAgLTY3NzgsOCArNjcyOSw4IEBAIHN0cnVjdCBrdm1feDg2X25lc3RlZF9vcHMgdm14X25l
c3RlZF9vcHMgPSB7CiAJLnRyaXBsZV9mYXVsdCA9IG5lc3RlZF92bXhfdHJpcGxlX2ZhdWx0LAog
CS5nZXRfc3RhdGUgPSB2bXhfZ2V0X25lc3RlZF9zdGF0ZSwKIAkuc2V0X3N0YXRlID0gdm14X3Nl
dF9uZXN0ZWRfc3RhdGUsCi0JLmdldF9uZXN0ZWRfc3RhdGVfcGFnZXMgPSB2bXhfZ2V0X25lc3Rl
ZF9zdGF0ZV9wYWdlcywKIAkud3JpdGVfbG9nX2RpcnR5ID0gbmVzdGVkX3ZteF93cml0ZV9wbWxf
YnVmZmVyLAogCS5lbmFibGVfZXZtY3MgPSBuZXN0ZWRfZW5hYmxlX2V2bWNzLAogCS5nZXRfZXZt
Y3NfdmVyc2lvbiA9IG5lc3RlZF9nZXRfZXZtY3NfdmVyc2lvbiwKKwkuZ2V0X2V2bWNzX3BhZ2Ug
PSBuZXN0ZWRfZ2V0X2V2bWNzX3BhZ2UsCiB9OwpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4
Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jCmluZGV4IDNhZTQwMTExM2E4MGIuLjI4M2EzZjUyYWEx
MzUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2bS94ODYuYworKysgYi9hcmNoL3g4Ni9rdm0veDg2
LmMKQEAgLTk3MjcsMTIgKzk3MjcsNiBAQCBzdGF0aWMgaW50IHZjcHVfZW50ZXJfZ3Vlc3Qoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KQogCQkJciA9IC1FSU87CiAJCQlnb3RvIG91dDsKIAkJfQotCQlp
ZiAoa3ZtX2NoZWNrX3JlcXVlc3QoS1ZNX1JFUV9HRVRfTkVTVEVEX1NUQVRFX1BBR0VTLCB2Y3B1
KSkgewotCQkJaWYgKHVubGlrZWx5KCFrdm1feDg2X29wcy5uZXN0ZWRfb3BzLT5nZXRfbmVzdGVk
X3N0YXRlX3BhZ2VzKHZjcHUpKSkgewotCQkJCXIgPSAwOwotCQkJCWdvdG8gb3V0OwotCQkJfQot
CQl9CiAJCWlmIChrdm1fY2hlY2tfcmVxdWVzdChLVk1fUkVRX01NVV9SRUxPQUQsIHZjcHUpKQog
CQkJa3ZtX21tdV91bmxvYWQodmNwdSk7CiAJCWlmIChrdm1fY2hlY2tfcmVxdWVzdChLVk1fUkVR
X01JR1JBVEVfVElNRVIsIHZjcHUpKQotLSAKMi4yNi4zCgo=


--=-u5dK/6uiM8T5xug6fSqD--

