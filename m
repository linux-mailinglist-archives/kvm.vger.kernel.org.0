Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA45128029
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 16:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTP4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 10:56:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:27924 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbfLTP4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 10:56:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 07:56:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,336,1571727600"; 
   d="scan'208";a="241535997"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Dec 2019 07:56:07 -0800
Date:   Fri, 20 Dec 2019 07:56:07 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 35/45] KVM: s390: Manually invoke vcpu setup during
 kvm_arch_vcpu_create()
Message-ID: <20191220155607.GB20453@linux.intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-36-sean.j.christopherson@intel.com>
 <20191220110445.3a42041a.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220110445.3a42041a.cohuck@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 11:04:45AM +0100, Cornelia Huck wrote:
> On Wed, 18 Dec 2019 13:55:20 -0800
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> > Rename kvm_arch_vcpu_setup() to kvm_s390_vcpu_setup() and manually call
> > the new function during kvm_arch_vcpu_create().  Define an empty
> > kvm_arch_vcpu_setup() as it's still required for compilation.  This
> > is effectively a nop as kvm_arch_vcpu_create() and kvm_arch_vcpu_setup()
> > are called back-to-back by common KVM code.  Obsoleting
> > kvm_arch_vcpu_setup() paves the way for its removal.
> > 
> > Note, gmap_remove() is now called if setup fails, as s390 was previously
> > freeing it via kvm_arch_vcpu_destroy(), which is called by common KVM
> > code if kvm_arch_vcpu_setup() fails.
> 
> Yes, this looks like the only thing that needs to be undone
> (sca_add_vcpu() is done later in the process.)
> 
> Maybe mention that gmap_remove() is for ucontrol only? I was confused
> for a moment :)

Will do.

Would it also make sense to open code __kvm_ucontrol_vcpu_init() in a
separate patch immediately preceding this change?  That'd make it a little
more obvious why gmap_remove() is called, and it would eliminate the
"uninit" verbiage in the label, e.g.:

        if (kvm_is_ucontrol(vcpu->kvm)) {
                vcpu->arch.gmap = gmap_create(current->mm, -1UL);
                if (!vcpu->arch.gmap) {
                        rc = -ENOMEM;
                        goto out_free_sie_block;
                }
                vcpu->arch.gmap->private = vcpu->kvm;
        }

        VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
                 vcpu->arch.sie_block);
        trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);

        rc = kvm_s390_vcpu_setup(vcpu);
        if (rc)
                goto out_free_ucontrol_gmap;
        return 0;

out_free_ucontrol_gmap:
        if (kvm_is_ucontrol(vcpu->kvm))
                gmap_remove(vcpu->arch.gmap);
out_free_sie_block:
        free_page((unsigned long)(vcpu->arch.sie_block));
        return rc;
}

