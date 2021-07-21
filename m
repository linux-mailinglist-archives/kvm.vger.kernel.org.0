Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A83B3D13EA
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhGUPiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234351AbhGUPiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:38:19 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0F6C061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 09:18:54 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id u14so2345874pga.11
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 09:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jlmR2FOonmL/63pitZehwQRYMbA6yhFj8rYQ3kGrZEU=;
        b=eERMJWoVCwQq7vzCp2h2L4u/l2Dbh92XhsPYNxRqSp+TANc2GKl/AT6hkZ7ojAEPkT
         tawMnFE6vYyiQ/KJJHuCBiwK4gubkcZmtjwEIx1oUjyEk2dakeOR7ObH0ozBjK4usQBH
         /zFi2nzhqH4JSAAIUyWeFSwR/y7RPZXwQvW7NwMvhuPEkRczlP2zsxB4ivRpxe+davpW
         mzmDUVAVuhL+8735q+I8RQ4KIkyW0wOZg5ZpwQxrhtUSVkHmXr6nwG37bwtGUjDWbsvY
         xiIPWi4rHBryhy97/DNZXGiS62bVpZLbz3nICb5/dtMnPB5kRGkpJ02WG02K8bnyIILL
         i9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jlmR2FOonmL/63pitZehwQRYMbA6yhFj8rYQ3kGrZEU=;
        b=aBzIX2CsOxf1Fa7HqPlSkFp7/Iim9DWnSIXzUIz2VQlRbvgNXcGHip1z1Z2zAjtvGx
         uy0bUQYPCtaitnanOqID9f2nh2NKKK0GEhUhwc/vPj8phbEAKyiIDF/srxCB955vh+gg
         7OrzE74lX2i7QQ6AXjFs6Fh1O1qivTQ8jTG2iUmVRX106dPstFjTf+LTGw66Qd8+A9Fl
         jJ47oMHJG9Ku3Bek02JzF/8CAIHLmnc2x/MsnnataXHpBU9EIedD3R3LRDTm2s5HHETU
         b5Q0m1/jPJwSf04Cxhekto4eZJpEJK/OrDg/flOxSlD7X9kyS+9Xa3ht3CmAOyJoItfs
         +VUQ==
X-Gm-Message-State: AOAM5335bC8JXrMtgldCeSoe2tQbvZboCTky5eu3HG2nGj6eUmueQcPQ
        2GNdLe4yIqwhLj6k95Vs4n1i7w==
X-Google-Smtp-Source: ABdhPJwu8EMHORLpQ830hmtLewIMD4KzJnBIqmBF2yvCCsegIA/zYboFShntBB7PCCxumgWRDD4QNQ==
X-Received: by 2002:a65:5186:: with SMTP id h6mr36710306pgq.62.1626884333648;
        Wed, 21 Jul 2021 09:18:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z12sm22075927pjd.39.2021.07.21.09.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 09:18:53 -0700 (PDT)
Date:   Wed, 21 Jul 2021 16:18:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Hu, Robert" <robert.hu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
Message-ID: <YPhI6en2031rLpVT@google.com>
References: <20210618214658.2700765-1-seanjc@google.com>
 <c847e00a-e422-cdc9-3317-fbbd82b6e418@redhat.com>
 <YNDHfX0cntj72sk6@google.com>
 <DM4PR11MB5453A57DAAC025417C22BCA4E0E39@DM4PR11MB5453.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR11MB5453A57DAAC025417C22BCA4E0E39@DM4PR11MB5453.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21, 2021, Hu, Robert wrote:
> > > Queued, thanks.  Without having checked the kvm-unit-tests sources
> > > very thoroughly, this might be a configuration issue in
> > > kvm-unit-tests; in theory "-cpu host" (unlike "-cpu
> > > host,migratable=no") should not enable TSC scaling.
> > 
> > As noted in the code comments, KVM allows VMREAD/VMWRITE to all defined
> > fields, whether or not the field should actually exist for the vCPU model doesn't
> > enter into the equation.  That's technically wrong as there are a number of
> > fields that the SDM explicitly states exist iff a certain feature is supported.  
>
> It's right that a number of fields' existence depends on some certain feature.
> Meanwhile, "IA32_VMX_VMCS_ENUM indicates to software the highest index
> value used in the encoding of any field *supported* by the processor", rather than
> *existed*.

Yes.

> So my understanding is no matter what VMCS exec control field's value is set,
> value of IA32_VMX_VMCS_ENUM shall not be affected, as it reports the physical
> CPU's capability rather than runtime VMCS configuration.

Yes.

> Back to nested case, L1's VMCS configuration lays the "physical" capability
> for L2, right?

Yes. 

> nested_vmx_msrs or at least nested_vmx_msrs.vmcs_enum shall be put to vcpu
> scope, rather than current kvm global.
>
> Current nested_vmx_calc_vmcs_enum_msr() is invoked at early stage, before
> vcpu features are settled. I think should be moved to later stage as well.

Just moving the helper (or adding another call) wouldn't fix the underlying
problem that KVM doesn't correctly model the interplay between VMX features and
VMCS fields.  It's arguably less wrong than letting userspace stuff an incorrect
value, but it's not 100% correct and ignoring/overriding userspace is sketchy at
best.  As suggested below, the full fix is to fail VMREAD/VMWRITE to fields that
shouldn't exist given the vCPU model.

> > To fix that we'd need to add a "feature flag" to vmcs_field_to_offset_table
> > that is checked against the vCPU model, though updating the MSR would
> > probably fall onto userspace's shoulders?
> > 
> > And FWIW, this is the QEMU code:
> > 
> >   #define VMCS12_MAX_FIELD_INDEX (0x17)
> > 
> >   static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
> >   {
> >       ...
> > 
> >       /*
> >        * Just to be safe, write these with constant values.  The CRn_FIXED1
> >        * MSRs are generated by KVM based on the vCPU's CPUID.
> >        */
> >       kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR0_FIXED0,
> >                         CR0_PE_MASK | CR0_PG_MASK | CR0_NE_MASK);
> >       kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR4_FIXED0,
> >                         CR4_VMXE_MASK);
> >       kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM,
> >                         VMCS12_MAX_FIELD_INDEX << 1);
> >   }
> 
