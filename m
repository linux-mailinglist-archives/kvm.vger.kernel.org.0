Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE56471242
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 07:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhLKG4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 01:56:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhLKG4j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 11 Dec 2021 01:56:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639205798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tqlq6AmDWNzPiJUWu/M8hOZ4wSsTPUgjGqMIHLFfx8w=;
        b=U8RwHq2neKznLHMhZfZJGwDWO0ek+uAkrop+TgcfXiEZx9pJdvPhgRS7nSoaR6DUInhb6s
        eikZwXc9hGQd5zM9p5+nQoaAls/TPntXRtE3ztPnFXXN88s1V8SIS6+S0BBYzg/k/Cs0Oj
        f9qe2q44cQ1kICIqkKO2NPA/xNot0bU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-CjjodwTEPH66bHLZpw0JCg-1; Sat, 11 Dec 2021 01:56:35 -0500
X-MC-Unique: CjjodwTEPH66bHLZpw0JCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5029F801AAB;
        Sat, 11 Dec 2021 06:56:32 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A38568D94;
        Sat, 11 Dec 2021 06:56:24 +0000 (UTC)
Message-ID: <42701fedbe10acf164ec56818b941061be6ffd4e.camel@redhat.com>
Subject: Re: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for
 shadow paging if the guest PDPTEs is changed
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
Date:   Sat, 11 Dec 2021 08:56:23 +0200
In-Reply-To: <YbPBjdAz1GQGr8DT@google.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
         <20211111144634.88972-1-jiangshanlai@gmail.com>
         <Ya/5MOYef4L4UUAb@google.com>
         <11219bdb-669c-cf6f-2a70-f4e5f909a2ad@redhat.com>
         <YbPBjdAz1GQGr8DT@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-12-10 at 21:07 +0000, Sean Christopherson wrote:
> On Thu, Dec 09, 2021, Paolo Bonzini wrote:
> > On 12/8/21 01:15, Sean Christopherson wrote:
> > > > @@ -832,8 +832,14 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
> > > >   	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
> > > >   		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
> > > >   		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> > > > -		/* Ensure the dirty PDPTEs to be loaded. */
> > > > -		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> > > > +		/*
> > > > +		 * Ensure the dirty PDPTEs to be loaded for VMX with EPT
> > > > +		 * enabled or pae_root to be reconstructed for shadow paging.
> > > > +		 */
> > > > +		if (tdp_enabled)
> > > > +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> > > > +		else
> > > > +			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
> > > Shouldn't matter since it's legacy shadow paging, but @mmu should be used instead
> > > of vcpu->arch.mmuvcpu->arch.mmu.
> > 
> > In kvm/next actually there's no mmu parameter to load_pdptrs, so it's okay
> > to keep vcpu->arch.mmu.
> > 
> > > To avoid a dependency on the previous patch, I think it makes sense to have this be:
> > > 
> > > 	if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
> > > 		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
> > > 
> > > before the memcpy().
> > > 
> > > Then we can decide independently if skipping the KVM_REQ_LOAD_MMU_PGD if the
> > > PDPTRs are unchanged with respect to the MMU is safe.
> > 
> > Do you disagree that there's already an invariant that the PDPTRs can only
> > be dirty if KVM_REQ_LOAD_MMU_PGD---and therefore a previous change to the
> > PDPTRs would have triggered KVM_REQ_LOAD_MMU_PGD?
> 
> What I think is moot, because commit 24cd19a28cb7 ("KVM: X86: Update mmu->pdptrs
> only when it is changed") breaks nested VMs with EPT in L0 and PAE shadow paging
> in L2.  Reproducing is trivial, just disable EPT in L1 and run a VM.  I haven't
> investigating how it breaks things, because why it's broken is secondary for me.
> 
> My primary concern is that we would even consider optimizing the PDPTR logic without
> a mountain of evidence that any patch is correct for all scenarios.  We had to add
> an entire ioctl() just to get PDPTRs functional.  This apparently wasn't validated
> against a simple use case, let alone against things like migration with nested VMs,
> multliple L2s, etc...

I did validate the *SREGS2* against all the cases I could (like migration, EPT/NPT disabled/etc.
I even started testing SMM to see how it affects PDPTRs, and patched seabios to use PAE paging.
I still could have missed something.

But note that qemu still doesn't use that ioctl (patch stuck in review).

Best regards,
	Maxim Levitsky


> 


