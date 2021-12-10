Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7873470C3F
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 22:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbhLJVLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 16:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhLJVLG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 16:11:06 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B6BC061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 13:07:30 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r5so9062866pgi.6
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 13:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1id2dwp2UGNFo7TxwGmxT4tvaojsrPJsLZ5gLoZYjqw=;
        b=C+7Th8AsMFmn3FKfJFpaLFJ031vb60eh9MBKAUnwjoiasDEDJUVkmEiEqQt4WI2AYe
         RofC6IVMcM7Y9ffgcHw3kITAx8GPNZ4GTQvuCD38mEbWFi+1knvfDK0IFVbMfa9ywJlg
         btmvvIds8ISbKcBeg3Eywh5ghJgX9uP6BJ5WAg99XNpl2bNdGzEIq1L88FDUipe3WIBs
         VpKxeOcXUjIt9+UP9zynUghSblYrl9pgHjgpMKJJo8+VMpXaNB+AzHqRt3+Qg/r/SjEU
         2UTgXYJVOR/YzqnVi/1pDIApEwSL1KCn3V6DaiBksnDYACnLCxnpZkUb4nqDYXjDaU5e
         Z2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1id2dwp2UGNFo7TxwGmxT4tvaojsrPJsLZ5gLoZYjqw=;
        b=fqYDR/zVJQjx2DxSak2LETmVluwHxEqt8XKIXebyVoDX94MhjnX++dYqRcEwik9q6G
         g2goAEkK2lw8sZ5CJm6qDjdO2WlmvdPqDcc/8GfQBMxKd53ktkHa8U54xYCprRoqcFKo
         qo+SrbrVAMytr8saT82B6HQMO4XT2x1Yjq2NPHjotDHhVDPCP6Iyts4NbKYHiiZbPht8
         ISfzIYaajg/Iq2Ln+17W5+EmVyk1luvQM+KVifM46eszKZKj6cvWJE/7lcfjd71i0XiX
         +Zo/ad2DKGQb6pWLsEldmW1+hnTH/kasgp0lUHTl2Zy0sLKiN47JfkO8EeQJkyl+yP/4
         2gIg==
X-Gm-Message-State: AOAM5303pzWWo0vtla6tRaIypPEKnkQhQYerEsYK1GCQAttVLg2IQYXF
        M6Gb2t2Cod4ufnU0hJ1yVnlHpg==
X-Google-Smtp-Source: ABdhPJzyAuEscIXhSTZc4Pgw0eQTzwWTV+8SFuYgHZgJ3niz0e3h11m8TG8z53s9Xc4xeKU8dhcEpw==
X-Received: by 2002:a05:6a00:10d3:b0:4a4:e516:826f with SMTP id d19-20020a056a0010d300b004a4e516826fmr20293737pfu.70.1639170450089;
        Fri, 10 Dec 2021 13:07:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o62sm3617404pfb.211.2021.12.10.13.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 13:07:29 -0800 (PST)
Date:   Fri, 10 Dec 2021 21:07:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
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
Subject: Re: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for
 shadow paging if the guest PDPTEs is changed
Message-ID: <YbPBjdAz1GQGr8DT@google.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144634.88972-1-jiangshanlai@gmail.com>
 <Ya/5MOYef4L4UUAb@google.com>
 <11219bdb-669c-cf6f-2a70-f4e5f909a2ad@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11219bdb-669c-cf6f-2a70-f4e5f909a2ad@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021, Paolo Bonzini wrote:
> On 12/8/21 01:15, Sean Christopherson wrote:
> > > @@ -832,8 +832,14 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
> > >   	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
> > >   		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
> > >   		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> > > -		/* Ensure the dirty PDPTEs to be loaded. */
> > > -		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> > > +		/*
> > > +		 * Ensure the dirty PDPTEs to be loaded for VMX with EPT
> > > +		 * enabled or pae_root to be reconstructed for shadow paging.
> > > +		 */
> > > +		if (tdp_enabled)
> > > +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> > > +		else
> > > +			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
> > Shouldn't matter since it's legacy shadow paging, but @mmu should be used instead
> > of vcpu->arch.mmuvcpu->arch.mmu.
> 
> In kvm/next actually there's no mmu parameter to load_pdptrs, so it's okay
> to keep vcpu->arch.mmu.
> 
> > To avoid a dependency on the previous patch, I think it makes sense to have this be:
> > 
> > 	if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
> > 		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
> > 
> > before the memcpy().
> > 
> > Then we can decide independently if skipping the KVM_REQ_LOAD_MMU_PGD if the
> > PDPTRs are unchanged with respect to the MMU is safe.
> 
> Do you disagree that there's already an invariant that the PDPTRs can only
> be dirty if KVM_REQ_LOAD_MMU_PGD---and therefore a previous change to the
> PDPTRs would have triggered KVM_REQ_LOAD_MMU_PGD?

What I think is moot, because commit 24cd19a28cb7 ("KVM: X86: Update mmu->pdptrs
only when it is changed") breaks nested VMs with EPT in L0 and PAE shadow paging
in L2.  Reproducing is trivial, just disable EPT in L1 and run a VM.  I haven't
investigating how it breaks things, because why it's broken is secondary for me.

My primary concern is that we would even consider optimizing the PDPTR logic without
a mountain of evidence that any patch is correct for all scenarios.  We had to add
an entire ioctl() just to get PDPTRs functional.  This apparently wasn't validated
against a simple use case, let alone against things like migration with nested VMs,
multliple L2s, etc...
