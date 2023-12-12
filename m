Return-Path: <kvm+bounces-4175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B591080E9A4
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 12:09:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E128281C3B
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 11:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BEB5CD22;
	Tue, 12 Dec 2023 11:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GaDh5b3Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C641AC
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 03:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702379358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iybzikHhi/RYwqbs7RLed4SqlcVfGLql6zLDAhTMe/Q=;
	b=GaDh5b3Q26Cqk1z7SRYfyq2LPI00qqIfMS+jJztMDRhy0v6nIZJHgXHl5lIzipTucGH0TB
	Y0CGeLIqyqSOwtRkIeVUGcyHnQbDrGeZjGSwihZVddJ4x8baTJqPiUehTso7aISVsLhojB
	EnNt660r3WZs2dTaQpBwXxSs01GPewo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-QeKaaVM6MNaJHpaPzvQvsQ-1; Tue, 12 Dec 2023 06:09:17 -0500
X-MC-Unique: QeKaaVM6MNaJHpaPzvQvsQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40c193fca81so42404785e9.3
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 03:09:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702379356; x=1702984156;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iybzikHhi/RYwqbs7RLed4SqlcVfGLql6zLDAhTMe/Q=;
        b=PwI7OX7Pk0t/PK7LVbtVnG+9fIh2EZpRWwDzWAMQMkhPEKUBvElUF0p9TTbtLsHsuL
         p03766nniN+hMTak1RQGI1ZW3+7UjFqVl0Q/tsXyVgBrPmEKes5CGWzYKdrsSCQCdFOF
         cpPkPhkzfRN8TP0b2ZH6oslLfXtQcomlG8VardCMfHvY+Vtr3qBRVRyAm/rl16Rm9iQ8
         yQD0tfra89/2CeVag9BlEi/tq9JIIRrSao73ABD34PK81mB2mO/xyKErHxWkyIj9LFx9
         DmRSI2BJZZM/CpSJZJUSrVdCSpf90+Sx4P9TGplrgKX2CvIKcpPrPFSmPHUTB9xhTxXD
         cI9g==
X-Gm-Message-State: AOJu0Yyp8crjAxi8TUbQvzzKDdGsWGf88pludA7jWpI2DJwkZdW9aDDZ
	8hxbG4RMEg4yRutadEKOyfiHabk0PHTNbCmytiZFWzhoIxJBlriHokDIylXgbOByoC6RIQTNiaQ
	Hti+cV0tvxyTl
X-Received: by 2002:a05:600c:45c9:b0:40b:5e1d:839d with SMTP id s9-20020a05600c45c900b0040b5e1d839dmr3570515wmo.49.1702379355910;
        Tue, 12 Dec 2023 03:09:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG25FdD4rFc1zXBA+TQnbK/iIYysEMkD7GOwGg2Jq8K/ylXFHbzbE1A1LtJUgqaTA+0U/CVqA==
X-Received: by 2002:a05:600c:45c9:b0:40b:5e1d:839d with SMTP id s9-20020a05600c45c900b0040b5e1d839dmr3570506wmo.49.1702379355488;
        Tue, 12 Dec 2023 03:09:15 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id iv19-20020a05600c549300b0040b397787d3sm12613756wmb.24.2023.12.12.03.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 03:09:14 -0800 (PST)
Message-ID: <7e8fdb9b30a9ffb405524c42ade277ba5dc81cb3.camel@redhat.com>
Subject: Re: [PATCH v7 26/26] KVM: nVMX: Enable CET support for nested guest
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 12 Dec 2023 13:09:12 +0200
In-Reply-To: <307dea63-ff53-4116-8752-f717d385cb9e@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-27-weijiang.yang@intel.com>
	 <2e280f545e8b15500fc4a2a77f6000a51f6f8bbd.camel@redhat.com>
	 <e7d399a2-a4ff-4e27-af09-a8611985648a@intel.com>
	 <8a2216b0c1a945e33a18a981cbce7737a07de52d.camel@redhat.com>
	 <73119078-7483-42e0-bb1f-b696932b6cd2@intel.com>
	 <53a25a11927f0c4b3f689d532af2a0ee67826fa8.camel@redhat.com>
	 <26313af3-3a75-4a3c-9935-526b07a6277d@intel.com>
	 <06298f6200aa0b6e9eaf1d908d8499bb50467fe0.camel@redhat.com>
	 <307dea63-ff53-4116-8752-f717d385cb9e@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2023-12-12 at 16:56 +0800, Yang, Weijiang wrote:
> 
> On 12/8/2023 11:22 PM, Maxim Levitsky wrote:
> > On Fri, 2023-12-08 at 23:15 +0800, Yang, Weijiang wrote:
> > > On 12/7/2023 1:24 AM, Maxim Levitsky wrote:
> > > > On Wed, 2023-12-06 at 17:22 +0800, Yang, Weijiang wrote:
> > > > > On 12/5/2023 6:12 PM, Maxim Levitsky wrote:
> > > > > > On Mon, 2023-12-04 at 16:50 +0800, Yang, Weijiang wrote:
> > > > > [...]
> > > > > 
> > > > > > > > >      	vmx->nested.force_msr_bitmap_recalc = false;
> > > > > > > > > @@ -2469,6 +2491,18 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> > > > > > > > >      		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
> > > > > > > > >      		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> > > > > > > > >      			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
> > > > > > > > > +
> > > > > > > > > +		if (vmx->nested.nested_run_pending &&
> > > > > > > > I don't think that nested.nested_run_pending check is needed.
> > > > > > > > prepare_vmcs02_rare is not going to be called unless the nested run is pending.
> > > > > > > But there're other paths along to call prepare_vmcs02_rare(), e.g., vmx_set_nested_state()-> nested_vmx_enter_non_root_mode()-> prepare_vmcs02_rare(), especially when L1 instead of L2 was running. In this case, nested.nested_run_pending == false,
> > > > > > > we don't need to update vmcs02's fields at the point until L2 is being resumed.
> > > > > > - If we restore VM from migration stream when L2 is *not running*, then prepare_vmcs02_rare won't be called,
> > > > > > because nested_vmx_enter_non_root_mode will not be called, because in turn there is no nested vmcs to load.
> > > > > > 
> > > > > > - If we restore VM from migration stream when L2 is *about to run* (KVM emulated the VMRESUME/VMLAUNCH,
> > > > > > but we didn't do the actual hardware VMLAUNCH/VMRESUME on vmcs02, then the 'nested_run_pending' will be true, it will be restored
> > > > > > from the migration stream.
> > > > > > 
> > > > > > - If we migrate while nested guest was run once but didn't VMEXIT to L1 yet, then yes, nested.nested_run_pending will be false indeed,
> > > > > > but we still need to setup vmcs02, otherwise it will be left with default zero values.
> > > > > Thanks a lot for recapping these cases! I overlooked some nested flags before. It makes sense to remove nested.nested_run_pending.
> > > > > > Remember that prior to setting nested state the VM wasn't running even once usually, unlike when the guest enters nested state normally.
> > > > > > 
> > > > > > > > > +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> > > > > > > > > +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
> > > > > > > > > +				vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
> > > > > > > > > +				vmcs_writel(GUEST_INTR_SSP_TABLE,
> > > > > > > > > +					    vmcs12->guest_ssp_tbl);
> > > > > > > > > +			}
> > > > > > > > > +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
> > > > > > > > > +			    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT))
> > > > > > > > > +				vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
> > > > > > > > > +		}
> > > > > > > > >      	}
> > > > > > > > >      
> > > > > > > > >      	if (nested_cpu_has_xsaves(vmcs12))
> > > > > > > > > @@ -4300,6 +4334,15 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
> > > > > > > > >      	vmcs12->guest_pending_dbg_exceptions =
> > > > > > > > >      		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
> > > > > > > > >      
> > > > > > > > > +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
> > > > > > > > > +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
> > > > > > > > > +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > > > > > > > > +	}
> > > > > > > > > +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
> > > > > > > > > +	    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT)) {
> > > > > > > > > +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
> > > > > > > > > +	}
> > > > > > > > The above code should be conditional on VM_ENTRY_LOAD_CET_STATE - if the guest (L2) state
> > > > > > > > was loaded, then it must be updated on exit - this is usually how VMX works.
> > > > > > > I think this is not for L2 VM_ENTRY_LOAD_CET_STATE, it happens in prepare_vmcs02_rare(). IIUC, the guest registers will be saved into VMCS fields unconditionally when vm-exit happens,
> > > > > > > so these fields for L2 guest should be synced to L1 unconditionally.
> > > > > > "the guest registers will be saved into VMCS fields unconditionally"
> > > > > > This is not true, unless there is a bug.
> > > > > I checked the latest SDM, there's no such kind of wording regarding CET entry/exit control bits. The wording comes from
> > > > > the individual CET spec.:
> > > > > "10.6 VM Exit
> > > > > On processors that support CET, the VM exit saves the state of IA32_S_CET, SSP and IA32_INTERRUPT_SSP_TABLE_ADDR MSR to the VMCS guest-state area unconditionally."
> > > > > But since it doesn't appear in SDM, I shouldn't take it for granted.
> > > > SDM spec from September 2023:
> > > > 
> > > > 28.3.1 Saving Control Registers, Debug Registers, and MSRs
> > > > 
> > > > "If the processor supports the 1-setting of the “load CET” VM-entry control, the contents of the IA32_S_CET and
> > > > IA32_INTERRUPT_SSP_TABLE_ADDR MSRs are saved into the corresponding fields. On processors that do not
> > > > support Intel 64 architecture, bits 63:32 of these MSRs are not saved."
> > > > 
> > > > Honestly it's not 100% clear if the “load CET” should be set to 1 to trigger the restore, or that this control just needs to be
> > > > supported on the CPU.
> > > > It does feel like you are right here, that CPU always saves the guest state, but allows to not load it on VM entry via
> > > > “load CET” VM entry control.
> > > > 
> > > > IMHO its best to check what the bare metal does by rigging a test by patching the host kernel to not set the 'load CET' control,
> > > > and see if the CPU still updates the guest CET fields on the VM exit.
> > > OK, I'll do some tests to see what's happening, thanks!
> > > > > > the vmcs12 VM_ENTRY_LOAD_CET_STATE should be passed through as is to vmcs02, so if the nested guest doesn't set this bit
> > > > > > the entry/exit using vmcs02 will not touch the CET state, which is unusual but allowed by the spec I think - a nested hypervisor can opt for example to save/load
> > > > > > this state manually or use msr load/store lists instead.
> > > > > Right although the use case should be rare, will modify the code to check VM_ENTRY_LOAD_CET_STATE. Thanks!
> > > > > > Regardless of this,
> > > > > > if the guest didn't set VM_ENTRY_LOAD_CET_STATE, then vmcs12 guest fields should neither be loaded on VM entry (copied to vmcs02) nor updated on VM exit,
> > > > > > (that is copied back to vmcs12) this is what is written in the VMX spec.
> > > > > What's the VMX spec. your're referring to here?
> > > > SDM.
> > > > 
> > > > In fact, now that I am thinking about this again, it should be OK to unconditionally copy the CET fields from vmcs12 to vmcs02, because as long as the
> > > > VM_ENTRY_LOAD_CET_STATE is not set, the CPU should care about their values in the vmcs02.
> > I noticed a typo. I meant that the CPU should't  care about their values in the vmcs02.
> > 
> > > > And about the other way around, assuming that I made a mistake as I said above, then the other way around is indeed unconditional.
> > > > 
> > > > 
> > > > Sorry for a bit of a confusion.
> > > NP, I also double check it with HW Arch and get it back.
> > > Thanks for raising these questions!
> 
> I got reply from HW Arch, the guest CET state is saved unconditionally:
> 
> "On the state save side, uCode doesn’t check for an exit control (or the load CET VM-entry control), but rather since it supports (as of TGL/SPR) CET,
>   it unconditionally saves the state to the VMCS guest-state area. "

Great!

Best regards,
	Maxim Levitsky

> 
> > Thanks to you too!
> > 
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > > > Best regards,
> > > > 	Maxim Levitsky
> > > > 
> > > > 



