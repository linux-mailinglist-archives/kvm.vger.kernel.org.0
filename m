Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F21218A4A
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 16:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgGHOjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 10:39:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23796 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729468AbgGHOjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 10:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594219159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5kAbKh4gT6sckOUOu13UxFIyniT4oyc+Q75JU+xCpvM=;
        b=HhmNaXGCFaDdmokVYcfOpaBgqfdBEtiZUaYmNRx6r4/FoiaL1PNVu3Gf5qXve7LgCRlkcT
        PSN4xGiDG+IAutGxpXSgpeQ/J+xZEzkzoOszCq0L1H3897Mbots5se2AUkK4oJKn8w7je4
        l0CkfAhY62SijesEStQJoDPZoY3dTCY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-oD2AWhj8Mi-L0xilBKVIKQ-1; Wed, 08 Jul 2020 10:39:17 -0400
X-MC-Unique: oD2AWhj8Mi-L0xilBKVIKQ-1
Received: by mail-ej1-f72.google.com with SMTP id yh3so37302359ejb.16
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 07:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5kAbKh4gT6sckOUOu13UxFIyniT4oyc+Q75JU+xCpvM=;
        b=UuiiuG9519M1EIgrCIKJaGyWmng8NO5Vbc7eUX8R2z/ZJSM0hJetHmq6B8kS0YxY2P
         ajC/WEc82YICtni6sbgEZbIfLo09yi5Nop85OlF42YHmL+gJP+0gXcM/cOauGiWcQpOl
         aCGMfoPtlT0s62wlLtBaQax2u1x5FGoqdYvMBTGBUQ+zUaH/8GE3U4KAbu1l9K4LX8fm
         MF1FoQ/sWGjUaVv3710CE8PcEp0wpBvnnNZOhRlFaLcuLGR2Trvp2qk4WB1aoQIAuU7O
         HX4B98QSNCMsJBCa0jLls1CPadbvDzIbp/+Nj58MOxuEnq3qJO2C40unDr5oaz3clV8+
         l3eQ==
X-Gm-Message-State: AOAM530jmZAoP3V4YcVYUXVWviHgLWjNJDBHUw4uXXsY0c14VHboKVeg
        0Th3BwQbna7A2ZEFA7t7LeHZFK9u/M3jzDVTz+UNrECZo3EpiJ0vWPAICIJ8yOkdoywVs/z2cej
        rOqUaJh9B/laV
X-Received: by 2002:a17:906:dbe5:: with SMTP id yd5mr52676073ejb.328.1594219156577;
        Wed, 08 Jul 2020 07:39:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIx3r6gC9MR8WQxYaKP1dcyHPBhsGUyPQRqWiSjReS9r0fzHOSnBWVo07r5QzzbcLhV1fN6w==
X-Received: by 2002:a17:906:dbe5:: with SMTP id yd5mr52676047ejb.328.1594219156284;
        Wed, 08 Jul 2020 07:39:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t25sm2077440ejc.34.2020.07.08.07.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 07:39:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: nSVM: properly call kvm_mmu_new_pgd() upon switching to guest
In-Reply-To: <b7989497-562e-c9a1-3f62-dd5afb9fd3d5@redhat.com>
References: <20200708093611.1453618-1-vkuznets@redhat.com> <20200708093611.1453618-3-vkuznets@redhat.com> <b7989497-562e-c9a1-3f62-dd5afb9fd3d5@redhat.com>
Date:   Wed, 08 Jul 2020 16:39:14 +0200
Message-ID: <87eepmul4d.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 08/07/20 11:36, Vitaly Kuznetsov wrote:
>> Undesired triple fault gets injected to L1 guest on SVM when L2 is
>> launched with certain CR3 values. #TF is raised by mmu_check_root()
>> check in fast_pgd_switch() and the root cause is that when
>> kvm_set_cr3() is called from nested_prepare_vmcb_save() with NPT
>> enabled CR3 points to a nGPA so we can't check it with
>> kvm_is_visible_gfn().
>> 
>> Calling kvm_mmu_new_pgd() with L2's CR3 idea when NPT is in use
>> seems to be wrong, an acceptable place for it seems to be
>> kvm_init_shadow_npt_mmu(). This also matches nVMX code.
>> 
>> Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 7 ++++++-
>>  arch/x86/kvm/mmu/mmu.c          | 2 ++
>>  arch/x86/kvm/svm/nested.c       | 2 +-
>>  arch/x86/kvm/x86.c              | 8 +++++---
>>  4 files changed, 14 insertions(+), 5 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index be5363b21540..49b62f024f51 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1459,7 +1459,12 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>>  		    int reason, bool has_error_code, u32 error_code);
>>  
>>  int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
>> -int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
>> +int __kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool cr3_is_nested);
>> +static inline int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>> +{
>> +	return __kvm_set_cr3(vcpu, cr3, false);
>> +}
>> +
>>  int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
>>  int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
>>  int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 167d12ab957a..ebf0cb3f1ce0 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4987,6 +4987,8 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
>>  	union kvm_mmu_role new_role =
>>  		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
>>  
>> +	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, true, true);
>> +
>>  	if (new_role.as_u64 != context->mmu_role.as_u64)
>>  		shadow_mmu_init_context(vcpu, cr0, cr4, efer, new_role);
>>  }
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index e424bce13e6c..b467917a9784 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -324,7 +324,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
>>  	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
>>  	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
>>  	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
>> -	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
>> +	(void)__kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3, npt_enabled);
>>  
>>  	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
>>  	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3b92db412335..3761135eb052 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1004,7 +1004,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_set_cr4);
>>  
>> -int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>> +int __kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool cr3_is_nested)
>>  {
>>  	bool skip_tlb_flush = false;
>>  #ifdef CONFIG_X86_64
>> @@ -1031,13 +1031,15 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>>  		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
>>  		return 1;
>>  
>> -	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
>> +	if (!cr3_is_nested)
>> +		kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
>> +
>>  	vcpu->arch.cr3 = cr3;
>>  	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
>>  
>>  	return 0;
>>  }
>> -EXPORT_SYMBOL_GPL(kvm_set_cr3);
>> +EXPORT_SYMBOL_GPL(__kvm_set_cr3);
>>  
>>  int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
>>  {
>> 
>
> Instead of the new argument (which is not really named right since it's
> never true for !NPT) you could perhaps check vcpu->arch.mmu.  But also,
> for NPT=1 the kvm_mmu_new_pgd is also unnecessary on vmexit, because the
> old roots are still valid (or has been invalidated otherwise) while L2
> was running.
>
> I'm also not sure if skip_tlb_flush can use X86_CR3_PCID_NOFLUSH the way
> kvm_set_cr3 does, so I wouldn't mind duplicating the code completely as
> is already the case for nested_vmx_load_cr3.  It would introduce some
> code duplication, but overall the code would be better.  For now, there
> need not be an equivalent to nested_vmx_transition_mmu_sync, ASID
> handling can be left for later.

Sounds reasonable,

let's introduce nested_svm_load_cr3() to not mix these two concepts
together. I'll be back with v3 shortly, thanks!

-- 
Vitaly

