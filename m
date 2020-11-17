Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6663F2B5DE1
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 12:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgKQLDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 06:03:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727778AbgKQLDT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 06:03:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605610997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h5lmX7LExkzM+QM3a2cocE9/WZPLYRxF3to83Xkns2o=;
        b=dtoD41TI1HKT2P8ADcaX/MlftH/jTBmq1Ghd+ctT+fg0ES4fefV+CL+Oj5HvIAZvrc03Zc
        6wLvarHAhKpnPiO9chyCaxdTOPQv6cPSFvY71qIcHjBQbnBBnHC8xaINtBTQ89AdkWfyvj
        qWBPJoTFgWfVZSRRdq0mqezkY6z4MyU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-8oUkDJ97M7agj81CGdP3Jg-1; Tue, 17 Nov 2020 06:03:15 -0500
X-MC-Unique: 8oUkDJ97M7agj81CGdP3Jg-1
Received: by mail-wr1-f72.google.com with SMTP id r15so12910729wrn.15
        for <kvm@vger.kernel.org>; Tue, 17 Nov 2020 03:03:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h5lmX7LExkzM+QM3a2cocE9/WZPLYRxF3to83Xkns2o=;
        b=awG4vSUjQjehckTBr0jdh9fI8lUVdYxhC67Tm/s6qsZqi52yeQba2w3rjEU7zgJXAH
         hg86tJUyExDkumj3FrVCUtJTtRNM9Ya0p/D63HOUDDJn9AuP5XCI54jrJaeAp7+72Axb
         TzPh4D9RBxbTlPyz1VWcNxb+TPJXW5heGFBAPK7oC0adTo78K7ktE+gHbrGpcnXCCtqT
         byXW9h7cGU6F+CseQBGzaqMUnLoJ90e4Y2DjFQ1lmPmS3HjCxuqEVVX0Hz2ErsjeYDB8
         0FjKwUgWG3QlgTmBzbW6X6EUxdnxzDebTGHW4zIigXuE9TLDjtPxYCU1XPSY90Vr7JxO
         5HWw==
X-Gm-Message-State: AOAM531wqcv5L3+UReqOk/tIjR3skbBkgT3SEfT6pPHVfnjPoFTiQ/vv
        XqdD2pNBJ2uALOqth4V2TxgsChSracdiExEsmSiRpKnCELP4TTZG23qxX+ET9EmVoNH06MOdm8K
        q3POmAZqkcnSN
X-Received: by 2002:adf:a2c2:: with SMTP id t2mr25295038wra.54.1605610994148;
        Tue, 17 Nov 2020 03:03:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxhzCHrbfSX6RQjbbtqNxHHoDd2RnJkMXxmQCe8E3wqAYWOCJAnCPyC2ZlHe6lR3BY1URbqVg==
X-Received: by 2002:adf:a2c2:: with SMTP id t2mr25295004wra.54.1605610993917;
        Tue, 17 Nov 2020 03:03:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h128sm3216045wme.38.2020.11.17.03.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 03:03:13 -0800 (PST)
Subject: Re: [PATCH v2 0/2] KVM: SVM: Create separate vmcbs for L1 and L2
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201011184818.3609-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a450000-dd0c-6c38-191b-8ad869c21807@redhat.com>
Date:   Tue, 17 Nov 2020 12:03:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201011184818.3609-1-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Cathy,

I found an issue with the second patch: the svm->asid_generation and 
svm->vcpu.cpu fields must become per-VMCB.  Once again we are 
rediscovering what VMX already does (for different reasons) with its 
struct loaded_vmcs.

The good thing is that it can be worked around easily: for the ASID 
generation, it simply be cleared after changing svm->vmcb.  For the CPU 
field, it's not an issue yet because the VMCB is marked all-dirty after 
each switch.  With these workarounds, everything works nicely.

However, removing the calls to vmcb_mark_all_dirty is the main 
optimization that is enabled by the VMCB01/VMCB02 split, so it should be 
fixed too.  And also, the code duplication every time svm->vmcb is 
assigned starts to be ugly, proving Sean to be right. :)

My suggestion is that you do something like this:

1) create a struct for all per-VMCB data:

	struct kvm_vmcb_info {
		void *ptr;
		u64 pa;
	}

and use it in structs vcpu_svm and svm_nested_state:

	struct vcpu_svm {
		...
		struct kvm_vmcb_info vmcb01;
		struct kvm_vmcb_info *current_vmcb;
		void *vmcb;
		u64 vmcb_pa;
		...
	}

	struct svm_nested_state {
		struct kvm_vmcb_info vmcb02;
		...
	}

The struct can be passed to a vmcb_switch function like this one:

	void vmcb_switch(struct vcpu_svm *svm,
			 struct kvm_vmcb_info *target_vmcb)
	{
		svm->current_vmcb = target_vmcb;
		svm->vmcb = target_vmcb->ptr;
		svm->vmcb_pa = target_vmcb->pa;

		/*
		 * Workaround: we don't yet track the ASID generation
		 * that was active the last time target_vmcb was run.
		 */
		svm->asid_generation = 0;

		/*
		 * Workaround: we don't yet track the physical CPU that
		 * target_vmcb has run on.
		 */
		vmcb_mark_all_dirty(svm->vmcb);
	}

You can use this function every time the current code is assigning to 
svm->vmcb.  Once the struct and function is in place, we can proceed to 
removing the last two (inefficient) lines of vmcb_switch by augmenting 
struct kvm_vmcb_info.

2) First, add an "int cpu" field.  Move the vcpu->cpu check from 
svm_vcpu_load to pre_svm_run, using svm->current_vmcb->cpu instead of 
vcpu->cpu, and you will be able to remove the vmcb_mark_all_dirty call 
from vmcb_switch.

3) Then do the same with asid_generation.  All uses of 
svm->asid_generation become uses of svm->current_vmcb->asid_generation, 
and you can remove the clearing of svm->asid_generation.

These can be three separate patches on top of the changes you have sent 
(or rather the rebased version, see below).  Writing good commit 
messages for them will be a good exercise too. :)

I have pushed the current nested SVM queue to kvm.git on a "nested-svm" 
branch.  You can discard the top commits and work on top of commit 
a33b86f151a0 from that branch ("KVM: SVM: Use a separate vmcb for the 
nested L2 guest", 2020-11-17).

Once this is done, we can start reaping the advantages of the 
VMCB01/VMCB02 split.  Some patches for that are already in the 
nested-svm branch, but there's more fun to be had.  First of all, 
Maxim's ill-fated attempt at using VMCB12 clean bits will now work. 
Second, we can try doing VMLOAD/VMSAVE always from VMCB01 (while VMRUN 
switches between VMCB01 and VMCB02) and therefore remove the 
nested_svm_vmloadsave calls from nested_vmrun and nested_vmexit.  But, 
one thing at a time.

Thanks,

Paolo

