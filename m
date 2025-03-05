Return-Path: <kvm+bounces-40116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A95A4F4F0
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6782C188F35D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0B2155300;
	Wed,  5 Mar 2025 02:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5RZuCQW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E700015350B
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 02:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741143301; cv=none; b=maLP4D9J6vdMoevT9PvoNi+2WXplTwtI9MjHxl7nxrEmzQr2JxYFOTW6ls3rI5cZPrpT1eKqzRFafTI24bpRyDXpNcAsnPxUbnErJrMIO4pOvqk6q0xSAj7j/4AZve7gu4LP92T+3S2Z7W4ujVhwyQ5/IKCwmAm2cS6QmuDNdf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741143301; c=relaxed/simple;
	bh=dY98b+A377+8lsbKOLqdLIFwY+nQhwzISrJ5IcPYpnU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MhDSlO/KzYx+byjgEwFUzX+fnduO7NZ83gfl5ZIIag5Bc9uaogCysGk5KgAgWU3DyRyhcoMXB5cHrF8dx4itTHB3uhSOOioYcyzsyPjPoAf8BQVugtySWtvyfUsLuh/NaMUuLogGG23eKGmp8rRtC+TeJ+Jq6g+O62bDjV3t/zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5RZuCQW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741143298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KodJeN8JpIyPec2i6bfA+7AA+Kc+r/6tiAa2r4SqwME=;
	b=G5RZuCQWEjZM8emQAVqOAGwnUfiGBKikKdWYjs8Emtdd+3Of40OjyBHi7pJm+zuDBlZwOy
	3Orkf88J2Q7ryBxiLSvEF/TRWEcAuwx5kA2nDsh41dAmXE6wNHlxUNaj62YJ4GJ1r4NYRV
	Y00CNtUlgCpdqM6kWqS/0I399MAUtlw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-81tsD65fPduwFxz3Zg4mTg-1; Tue, 04 Mar 2025 21:54:57 -0500
X-MC-Unique: 81tsD65fPduwFxz3Zg4mTg-1
X-Mimecast-MFC-AGG-ID: 81tsD65fPduwFxz3Zg4mTg_1741143297
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c3b8a208bfso343656685a.2
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 18:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741143297; x=1741748097;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KodJeN8JpIyPec2i6bfA+7AA+Kc+r/6tiAa2r4SqwME=;
        b=b2D+vJDVyqBM5A16YDjCV9yWsKCz800Jalw7yOAHqcEel04iNghLjoTvmUE6UWLE/n
         mqD0dnxmTnWSgUk7wNbNx9VPmGhf351j3/AHXpbIyM3KxaXKZuZlCoH/QOW4s/rwBc/h
         Y3Z5O7Jwdttr1DRYYnpbv4m7AxvuTVX/1KTm+0TzHVTrv+z4poDsR+zNXAzYugxX8Xpy
         PODBlXLgHCDGfPl+Lpz92BrUAabWJ+BmeKBYRCWoNoIkbJbGqapCrhJ8fWjogvvoyMF9
         CBNnz19d1UMxQoM8xW8uq0nCEKUAP5CyNlK+BJo1Yy4P2ihGyNx9dbGiAVqSgCLhTHep
         Ymeg==
X-Forwarded-Encrypted: i=1; AJvYcCWjB9CfNEyNA1KGQC16hLVgHwyDar/pAzrhmKxAFGS+Gtw40vk92OpFvaDb0bJrBzKF8e0=@vger.kernel.org
X-Gm-Message-State: AOJu0YziThUtwvnhBRd+UXDC1ZyZVd0Ci70jRs2lrs2hvlyEMUBSpxLQ
	Kg7kFTalsI4ClWScoM7AJCgrp/2nVU6UlZC+InSsunJ6of/BalmSyi/fGQ8D03anX7vxdAjTfAq
	WIXi0kE/9YeAxkDO9d2Q6M4PUf3RDtIlxTa8gcMCTGy4zcUgHIA==
X-Gm-Gg: ASbGncvg9EziqdiE71NRQD80QAnTGEq+42aOf1zJScjOlelHfxbBMonJuOG4DUBQxO0
	+xJCjBCP9PlE0uiHjwXCfnYiBVYRGj8ZPyFeqQ46PnDfdPsoMXPs1EXPPJ81w78BOUD4YdMGIla
	KwGkj8gZkCYRNFbKtehQpKTBUbiqrUlQbslJ7NAL9MKBiEp+LnJlHk25OsB8Mr5ZWn/E2PD4qa7
	3A+GydZMFs/ydF3YZdtvpsD6xUhbtykT7rWIv4hH3qS3vGujplmXHs5JOayPx5Bg2tI4pQ1MFxd
	jiIra+MMS7q3FiQ=
X-Received: by 2002:a05:620a:2625:b0:7c3:d63d:7bcd with SMTP id af79cd13be357-7c3d8e46660mr247163085a.41.1741143297161;
        Tue, 04 Mar 2025 18:54:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFvz1+gJ0iMbpbQMRyWNUjg3QfvU/XXE38aN+scmgNB9MiYeNTM5Gib23Hs7J+qxa4wCy4h+A==
X-Received: by 2002:a05:620a:2625:b0:7c3:d63d:7bcd with SMTP id af79cd13be357-7c3d8e46660mr247158285a.41.1741143296316;
        Tue, 04 Mar 2025 18:54:56 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c3b2fb20f0sm419274585a.107.2025.03.04.18.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 18:54:56 -0800 (PST)
Message-ID: <f34c5ab727d2e0b6f064ddd11d596fb1841b75b3.camel@redhat.com>
Subject: Re: [RFC PATCH 07/13] KVM: nSVM: Handle INVLPGA interception
 correctly
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2025 21:54:54 -0500
In-Reply-To: <Z8YnjhfwHM_0HBNx@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-8-yosry.ahmed@linux.dev>
	 <330b0214680efacf15cf18d70788b9feab2b68b0.camel@redhat.com>
	 <Z8YnjhfwHM_0HBNx@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-03-03 at 22:05 +0000, Yosry Ahmed wrote:
> On Fri, Feb 28, 2025 at 08:55:18PM -0500, Maxim Levitsky wrote:
> > On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> > > Currently, INVPLGA interception handles it like INVLPG, which flushes
> > > L1's TLB translations for the address. It was implemented in this way
> > > because L1 and L2 shared an ASID. Now, L1 and L2 have separate ASIDs. It
> > > is still harmless to flush L1's translations, but it's only correct
> > > because all translations are flushed on nested transitions anyway.
> > > 
> > > In preparation for stopping unconditional flushes on nested transitions,
> > > handle INVPLGA interception properly. If L1 specified zero as the ASID,
> > > this is equivalent to INVLPG, so handle it as such. Otherwise, use
> > > INVPLGA to flush the translations of the appropriate ASID tracked by
> > > KVM, if any. Sync the shadow MMU as well, as L1 invalidated L2's
> > > mappings.
> > > 
> > > Opportunistically update svm_flush_tlb_gva() to use
> > > svm->current_vmcb->asid instead of svm->vmcb->control.asid for
> > > consistency. The two should always be in sync except when KVM allocates
> > > a new ASID in pre_svm_run(), and they are shortly brought back in sync
> > > in svm_vcpu_run(). However, if future changes add more code paths where
> > > KVM allocates a new ASID, flushing the potentially old ASID in
> > > svm->vmcb->control.asid would be unnecessary overhead (although probably
> > > not much different from flushing the newly allocated ASID).
> > > 
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h |  2 ++
> > >  arch/x86/kvm/mmu/mmu.c          |  5 +++--
> > >  arch/x86/kvm/svm/svm.c          | 40 ++++++++++++++++++++++++++++++---
> > >  3 files changed, 42 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 5193c3dfbce15..1e147bb2e560f 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -2213,6 +2213,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
> > >  		       void *insn, int insn_len);
> > >  void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
> > >  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
> > > +void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > > +			       u64 addr, unsigned long roots, bool gva_flush);
> > >  void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > >  			     u64 addr, unsigned long roots);
> > >  void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index ac133abc9c173..f5e0d2c8f4bbe 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -6158,8 +6158,8 @@ static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
> > >  	write_unlock(&vcpu->kvm->mmu_lock);
> > >  }
> > >  
> > > -static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > > -				      u64 addr, unsigned long roots, bool gva_flush)
> > > +void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > > +			       u64 addr, unsigned long roots, bool gva_flush)
> > >  {
> > >  	int i;
> > >  
> > > @@ -6185,6 +6185,7 @@ static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu
> > >  			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
> > >  	}
> > >  }
> > > +EXPORT_SYMBOL_GPL(__kvm_mmu_invalidate_addr);
> > >  
> > >  void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > >  			     u64 addr, unsigned long roots)
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index a2d601cd4c283..9e29f87d3bd93 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -2483,6 +2483,7 @@ static int clgi_interception(struct kvm_vcpu *vcpu)
> > >  
> > >  static int invlpga_interception(struct kvm_vcpu *vcpu)
> > >  {
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > >  	gva_t gva = kvm_rax_read(vcpu);
> > >  	u32 asid = kvm_rcx_read(vcpu);
> > >  
> > > @@ -2492,8 +2493,41 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
> > >  
> > >  	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, asid, gva);
> > >  
> > > -	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
> > > -	kvm_mmu_invlpg(vcpu, gva);
> > > +	/*
> > > +	 * APM is silent about using INVLPGA to flush the host ASID (i.e. 0).
> > > +	 * Do the logical thing and handle it like INVLPG.
> > > +	 */
> > > +	if (asid == 0) {
> > > +		kvm_mmu_invlpg(vcpu, gva);
> > > +		return kvm_skip_emulated_instruction(vcpu);
> > > +	}
> > > +
> > > +	/*
> > > +	 * Check if L1 specified the L2 ASID we are currently tracking. If it
> > > +	 * isn't, do nothing as we have to handle the TLB flush when switching
> > > +	 * to the new ASID anyway. APM mentions that INVLPGA is typically only
> > > +	 * meaningful with shadow paging, so also do nothing if L1 is using
> > > +	 * nested NPT.
> > > +	 */
> > > +	if (!nested_npt_enabled(svm) && asid == svm->nested.last_asid)
> > > +		invlpga(gva, svm->nested.vmcb02.asid);
> > 
> > Hi, 
> > 
> > IMHO we can't just NOP the INVLPGA because it is not useful in nested NPT case.
> > 
> > If I understand the APM correctly, the CPU will honor the INVLPGA
> > request, even when NPT is enabled, and so KVM must do this as well.
> > 
> > It is not useful for the hypervisor because it needs GVA, which in case of NPT,
> > the hypervisor won't usually track, but we can't completely rule out that some
> > hypervisor uses this in some cases.
> 
> Yeah I knew this was going to be a contention point, was mainly waiting
> to see what others think here.
> 
> I guess we can just map the ASID passed by L1 to the actual ASID we use
> for L2 and execute the INVLPGA as-is with the gva passed by L1.


If I understand correctly, we in essence support only 2 nested ASIDs: 0 and the one that
L1 used last time. Anything else will get flushed on next VM entry.
 
So, if I understand this correctly all we need to do is to drop the 
'nested_npt_enabled(svm)' check above, and it should work.


Best regards,
	Maxim Levitsky

> 
> > 
> > Also, there is out of order patch here: last_asid isn't yet declared.
> > It is added in patch 10.
> 
> Good catch, I will fix that, thanks!
> 



