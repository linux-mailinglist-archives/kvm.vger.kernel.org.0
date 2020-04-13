Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D821A6E3B
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 23:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389033AbgDMV1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 17:27:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:40070 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388994AbgDMV1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 17:27:00 -0400
IronPort-SDR: tNOI4xhA1VF6iW4XLnh7bEQzYvq2Mf4FsSLDogheVyL7e2n6hp3rvF9X5ug+fDRGY78bqWOdLJ
 Uo9SD8WkDXnQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 14:26:59 -0700
IronPort-SDR: zUxMGEWh0rWRWpxXiFP85EcDCZiCPVAcwHH4tIFkxEFM8GWog7ANF4QPqUo2JM/MxjxZe8TOlG
 CqrkQ6O+ot4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,380,1580803200"; 
   d="scan'208";a="252999630"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 13 Apr 2020 14:26:59 -0700
Date:   Mon, 13 Apr 2020 14:26:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wainer dos Santos Moschetta <wainersm@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 01/10] KVM: selftests: Take vcpu pointer instead of id in
 vm_vcpu_rm()
Message-ID: <20200413212659.GB21204@linux.intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
 <20200410231707.7128-2-sean.j.christopherson@intel.com>
 <b696c5b9-2507-8849-e196-37c83806cfdf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b696c5b9-2507-8849-e196-37c83806cfdf@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 03:26:55PM -0300, Wainer dos Santos Moschetta wrote:
> 
> On 4/10/20 8:16 PM, Sean Christopherson wrote:
> >The sole caller of vm_vcpu_rm() already has the vcpu pointer, take it
> >directly instead of doing an extra lookup.
> 
> 
> Most of (if not all) vcpu related functions in kvm_util.c receives an id, so
> this change creates an inconsistency.

Ya, but taking the id is done out of "necessity", as everything is public
and for whatever reason the design of the selftest framework is to not
expose 'struct vcpu' outside of the utils.  vm_vcpu_rm() is internal only,
IMO pulling the id out of the vcpu just to lookup the same vcpu is a waste
of time.

FWIW, I think the whole vcpuid thing is a bad interface, almost all the
tests end up defining an arbitrary number for the sole VCPU_ID, i.e. the
vcpuid interface just adds a pointless layer of obfuscation.  I haven't
looked through all the tests, but returning the vcpu and making the struct
opaque, same as kvm_vm, seems like it would yield more readable code with
less overhead.

While I'm on a soapbox, hiding 'struct vcpu' and 'struct kvm_vm' also seems
rather silly, but at least that doesn't directly lead to funky code.

> Disregarding the above comment, the changes look good to me. So:
> 
> Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> 
> 
> >
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  tools/testing/selftests/kvm/lib/kvm_util.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> >diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> >index 8a3523d4434f..9a783c20dd26 100644
> >--- a/tools/testing/selftests/kvm/lib/kvm_util.c
> >+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> >@@ -393,7 +393,7 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
> >   *
> >   * Input Args:
> >   *   vm - Virtual Machine
> >- *   vcpuid - VCPU ID
> >+ *   vcpu - VCPU to remove
> >   *
> >   * Output Args: None
> >   *
> >@@ -401,9 +401,8 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
> >   *
> >   * Within the VM specified by vm, removes the VCPU given by vcpuid.
> >   */
> >-static void vm_vcpu_rm(struct kvm_vm *vm, uint32_t vcpuid)
> >+static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
> >  {
> >-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >  	int ret;
> >  	ret = munmap(vcpu->state, sizeof(*vcpu->state));
> >@@ -427,7 +426,7 @@ void kvm_vm_release(struct kvm_vm *vmp)
> >  	int ret;
> >  	while (vmp->vcpu_head)
> >-		vm_vcpu_rm(vmp, vmp->vcpu_head->id);
> >+		vm_vcpu_rm(vmp, vmp->vcpu_head);
> >  	ret = close(vmp->fd);
> >  	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"
> 
