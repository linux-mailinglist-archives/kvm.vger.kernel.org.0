Return-Path: <kvm+bounces-49562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1773BAD9F62
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 21:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FF0F3B8BDB
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 19:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224682E6D14;
	Sat, 14 Jun 2025 19:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lgB+xHCi"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2191DE8A0
	for <kvm@vger.kernel.org>; Sat, 14 Jun 2025 19:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749928710; cv=none; b=LWqnIygnMrggu6Oq2UEh+dUWEK0CvE4PlDlm9u5bHSNb2Z1WS2jM6xVQzlYwMMLHd56Ya9C7YutS5TxZsrcIz1bPNlMJ/hw1/93S+C4zNRUMO10AiyCBBQeie0Powt42y/z2VEhJoPhkmztcf3QFUp8c5uvfAd8sezSEaQwnVmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749928710; c=relaxed/simple;
	bh=Wt4jn0VFhPeXkKDyGCnxiaWNBtXdtzEkZdetXNGqoNw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ayeldYEvYjXpUtacWTpPjNvf7WCnx9lUpKkTOZ6L/JfZj7LDWOXB1Itb988sjncjJdUgogET8UY966TfrNaS3+iYgEeRshzLGMBTZ1uG5bF5BWU+J3UDWl4C9WjHv+RXQywGOA4viZlUFsdUAwgqVUCjzxruwX9eZ/BgOK1uqzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lgB+xHCi; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <c10155a2-5886-42de-9517-9ee6390f6581@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749928695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UJUMTl/rId1TqAgB9DSjNENNuaaU4TAe0BQqxT+rUQo=;
	b=lgB+xHCif0Kzqmc9+A7AvEzfLAxT0/pOkTc0KazZ4n9zVNPZ+XszFScRFx8fl9yYReGD74
	c8kL8dzRELRcJdbgLC+y4oNi+QnuGXcPccm9E8mVsb1MPfRtwBlL61JtxGravR0T00C7ps
	WoXVQ0k3Bouw+j5x7TqvfLUnXe88V38=
Date: Sat, 14 Jun 2025 12:18:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 12/12] RISC-V: KVM: Pass VMID as parameter to
 kvm_riscv_hfence_xyz() APIs
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250613065743.737102-1-apatel@ventanamicro.com>
 <20250613065743.737102-13-apatel@ventanamicro.com>
 <63b76a34-7475-4a3c-b86d-c355ff928091@linux.dev>
Content-Language: en-US
In-Reply-To: <63b76a34-7475-4a3c-b86d-c355ff928091@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 6/14/25 12:12 PM, Atish Patra wrote:
> 
> On 6/12/25 11:57 PM, Anup Patel wrote:
>> Currently, all kvm_riscv_hfence_xyz() APIs assume VMID to be the
>> host VMID of the Guest/VM which resticts use of these APIs only
>> for host TLB maintenance. Let's allow passing VMID as a parameter
>> to all kvm_riscv_hfence_xyz() APIs so that they can be re-used
>> for nested virtualization related TLB maintenance.
>>
>> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
>> ---
>>   arch/riscv/include/asm/kvm_tlb.h  | 17 ++++++---
>>   arch/riscv/kvm/gstage.c           |  3 +-
>>   arch/riscv/kvm/tlb.c              | 61 ++++++++++++++++++++-----------
>>   arch/riscv/kvm/vcpu_sbi_replace.c | 17 +++++----
>>   arch/riscv/kvm/vcpu_sbi_v01.c     | 25 ++++++-------
>>   5 files changed, 73 insertions(+), 50 deletions(-)
>>
>> diff --git a/arch/riscv/include/asm/kvm_tlb.h b/arch/riscv/include/ 
>> asm/kvm_tlb.h
>> index f67e03edeaec..38a2f933ad3a 100644
>> --- a/arch/riscv/include/asm/kvm_tlb.h
>> +++ b/arch/riscv/include/asm/kvm_tlb.h
>> @@ -11,9 +11,11 @@
>>   enum kvm_riscv_hfence_type {
>>       KVM_RISCV_HFENCE_UNKNOWN = 0,
>>       KVM_RISCV_HFENCE_GVMA_VMID_GPA,
>> +    KVM_RISCV_HFENCE_GVMA_VMID_ALL,
>>       KVM_RISCV_HFENCE_VVMA_ASID_GVA,
>>       KVM_RISCV_HFENCE_VVMA_ASID_ALL,
>>       KVM_RISCV_HFENCE_VVMA_GVA,
>> +    KVM_RISCV_HFENCE_VVMA_ALL
>>   };
>>   struct kvm_riscv_hfence {
>> @@ -59,21 +61,24 @@ void kvm_riscv_fence_i(struct kvm *kvm,
>>   void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
>>                       unsigned long hbase, unsigned long hmask,
>>                       gpa_t gpa, gpa_t gpsz,
>> -                    unsigned long order);
>> +                    unsigned long order, unsigned long vmid);
>>   void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
>> -                    unsigned long hbase, unsigned long hmask);
>> +                    unsigned long hbase, unsigned long hmask,
>> +                    unsigned long vmid);
>>   void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
>>                       unsigned long hbase, unsigned long hmask,
>>                       unsigned long gva, unsigned long gvsz,
>> -                    unsigned long order, unsigned long asid);
>> +                    unsigned long order, unsigned long asid,
>> +                    unsigned long vmid);
>>   void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
>>                       unsigned long hbase, unsigned long hmask,
>> -                    unsigned long asid);
>> +                    unsigned long asid, unsigned long vmid);
>>   void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
>>                      unsigned long hbase, unsigned long hmask,
>>                      unsigned long gva, unsigned long gvsz,
>> -                   unsigned long order);
>> +                   unsigned long order, unsigned long vmid);
>>   void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
>> -                   unsigned long hbase, unsigned long hmask);
>> +                   unsigned long hbase, unsigned long hmask,
>> +                   unsigned long vmid);
>>   #endif
>> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
>> index 9c7c44f09b05..24c270d6d0e2 100644
>> --- a/arch/riscv/kvm/gstage.c
>> +++ b/arch/riscv/kvm/gstage.c
>> @@ -117,7 +117,8 @@ static void gstage_tlb_flush(struct kvm_gstage 
>> *gstage, u32 level, gpa_t addr)
>>       if (gstage->flags & KVM_GSTAGE_FLAGS_LOCAL)
>>           kvm_riscv_local_hfence_gvma_vmid_gpa(gstage->vmid, addr, 
>> BIT(order), order);
>>       else
>> -        kvm_riscv_hfence_gvma_vmid_gpa(gstage->kvm, -1UL, 0, addr, 
>> BIT(order), order);
>> +        kvm_riscv_hfence_gvma_vmid_gpa(gstage->kvm, -1UL, 0, addr, 
>> BIT(order), order,
>> +                           gstage->vmid);
>>   }
>>   int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
>> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
>> index 349fcfc93f54..3c5a70a2b927 100644
>> --- a/arch/riscv/kvm/tlb.c
>> +++ b/arch/riscv/kvm/tlb.c
>> @@ -251,6 +251,12 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
>>                   kvm_riscv_local_hfence_gvma_vmid_gpa(d.vmid, d.addr,
>>                                        d.size, d.order);
>>               break;
>> +        case KVM_RISCV_HFENCE_GVMA_VMID_ALL:
>> +            if (kvm_riscv_nacl_available())
>> +                nacl_hfence_gvma_vmid_all(nacl_shmem(), d.vmid);
>> +            else
>> +                kvm_riscv_local_hfence_gvma_vmid_all(d.vmid);
>> +            break;
>>           case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
>>               kvm_riscv_vcpu_pmu_incr_fw(vcpu, 
>> SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
>>               if (kvm_riscv_nacl_available())
>> @@ -276,6 +282,13 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
>>                   kvm_riscv_local_hfence_vvma_gva(d.vmid, d.addr,
>>                                   d.size, d.order);
>>               break;
>> +        case KVM_RISCV_HFENCE_VVMA_ALL:
>> +            kvm_riscv_vcpu_pmu_incr_fw(vcpu, 
>> SBI_PMU_FW_HFENCE_VVMA_RCVD);
>> +            if (kvm_riscv_nacl_available())
>> +                nacl_hfence_vvma_all(nacl_shmem(), d.vmid);
>> +            else
>> +                kvm_riscv_local_hfence_vvma_all(d.vmid);
>> +            break;
>>           default:
>>               break;
>>           }
>> @@ -328,14 +341,13 @@ void kvm_riscv_fence_i(struct kvm *kvm,
>>   void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
>>                       unsigned long hbase, unsigned long hmask,
>>                       gpa_t gpa, gpa_t gpsz,
>> -                    unsigned long order)
>> +                    unsigned long order, unsigned long vmid)
>>   {
>> -    struct kvm_vmid *v = &kvm->arch.vmid;
>>       struct kvm_riscv_hfence data;
>>       data.type = KVM_RISCV_HFENCE_GVMA_VMID_GPA;
>>       data.asid = 0;
>> -    data.vmid = READ_ONCE(v->vmid);
>> +    data.vmid = vmid;
>>       data.addr = gpa;
>>       data.size = gpsz;
>>       data.order = order;
>> @@ -344,23 +356,28 @@ void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm 
>> *kvm,
>>   }
>>   void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
>> -                    unsigned long hbase, unsigned long hmask)
>> +                    unsigned long hbase, unsigned long hmask,
>> +                    unsigned long vmid)
>>   {
>> -    make_xfence_request(kvm, hbase, hmask, KVM_REQ_TLB_FLUSH,
>> -                KVM_REQ_TLB_FLUSH, NULL);
>> +    struct kvm_riscv_hfence data = {0};
>> +
>> +    data.type = KVM_RISCV_HFENCE_GVMA_VMID_ALL;
>> +    data.vmid = vmid;
>> +    make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
>> +                KVM_REQ_TLB_FLUSH, &data);
>>   }
>>   void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
>>                       unsigned long hbase, unsigned long hmask,
>>                       unsigned long gva, unsigned long gvsz,
>> -                    unsigned long order, unsigned long asid)
>> +                    unsigned long order, unsigned long asid,
>> +                    unsigned long vmid)
>>   {
>> -    struct kvm_vmid *v = &kvm->arch.vmid;
>>       struct kvm_riscv_hfence data;
>>       data.type = KVM_RISCV_HFENCE_VVMA_ASID_GVA;
>>       data.asid = asid;
>> -    data.vmid = READ_ONCE(v->vmid);
>> +    data.vmid = vmid;
>>       data.addr = gva;
>>       data.size = gvsz;
>>       data.order = order;
>> @@ -370,15 +387,13 @@ void kvm_riscv_hfence_vvma_asid_gva(struct kvm 
>> *kvm,
>>   void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
>>                       unsigned long hbase, unsigned long hmask,
>> -                    unsigned long asid)
>> +                    unsigned long asid, unsigned long vmid)
>>   {
>> -    struct kvm_vmid *v = &kvm->arch.vmid;
>> -    struct kvm_riscv_hfence data;
>> +    struct kvm_riscv_hfence data = {0};
>>       data.type = KVM_RISCV_HFENCE_VVMA_ASID_ALL;
>>       data.asid = asid;
>> -    data.vmid = READ_ONCE(v->vmid);
>> -    data.addr = data.size = data.order = 0;
>> +    data.vmid = vmid;
>>       make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
>>                   KVM_REQ_HFENCE_VVMA_ALL, &data);
>>   }
>> @@ -386,14 +401,13 @@ void kvm_riscv_hfence_vvma_asid_all(struct kvm 
>> *kvm,
>>   void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
>>                      unsigned long hbase, unsigned long hmask,
>>                      unsigned long gva, unsigned long gvsz,
>> -                   unsigned long order)
>> +                   unsigned long order, unsigned long vmid)
>>   {
>> -    struct kvm_vmid *v = &kvm->arch.vmid;
>>       struct kvm_riscv_hfence data;
>>       data.type = KVM_RISCV_HFENCE_VVMA_GVA;
>>       data.asid = 0;
>> -    data.vmid = READ_ONCE(v->vmid);
>> +    data.vmid = vmid;
>>       data.addr = gva;
>>       data.size = gvsz;
>>       data.order = order;
>> @@ -402,16 +416,21 @@ void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
>>   }
>>   void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
>> -                   unsigned long hbase, unsigned long hmask)
>> +                   unsigned long hbase, unsigned long hmask,
>> +                   unsigned long vmid)
>>   {
>> -    make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_VVMA_ALL,
>> -                KVM_REQ_HFENCE_VVMA_ALL, NULL);
>> +    struct kvm_riscv_hfence data = {0};
>> +
>> +    data.type = KVM_RISCV_HFENCE_VVMA_ALL;
>> +    data.vmid = vmid;
>> +    make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
>> +                KVM_REQ_HFENCE_VVMA_ALL, &data);
>>   }
>>   int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 
>> nr_pages)
>>   {
>>       kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0,
>>                          gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT,
>> -                       PAGE_SHIFT);
>> +                       PAGE_SHIFT, READ_ONCE(kvm->arch.vmid.vmid));
>>       return 0;
>>   }
>> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/ 
>> vcpu_sbi_replace.c
>> index b17fad091bab..b490ed1428a6 100644
>> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
>> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
>> @@ -96,6 +96,7 @@ static int kvm_sbi_ext_rfence_handler(struct 
>> kvm_vcpu *vcpu, struct kvm_run *run
>>       unsigned long hmask = cp->a0;
>>       unsigned long hbase = cp->a1;
>>       unsigned long funcid = cp->a6;
>> +    unsigned long vmid;
>>       switch (funcid) {
>>       case SBI_EXT_RFENCE_REMOTE_FENCE_I:
>> @@ -103,22 +104,22 @@ static int kvm_sbi_ext_rfence_handler(struct 
>> kvm_vcpu *vcpu, struct kvm_run *run
>>           kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
>>           break;
>>       case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
>> +        vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>>           if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
>> -            kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask);
>> +            kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask, vmid);
> 
> This patch doesn't apply cleanly on 6.16-rc1.
> 
> <<<<<<< HEAD
>                  if (cp->a2 == 0 && cp->a3 == 0)
>                          kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, 
> hmask);
> =======
>                  vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>                  if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
>                          kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, 
> hmask, vmid);
>  >>>>>>> 57ec61198cc1 (RISC-V: KVM: Pass VMID as parameter to 
> kvm_riscv_hfence_xyz() APIs)
> else
>                          kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
>                                                    cp->a2, cp->a3, 
> PAGE_SHIFT, vmid);
>                  kvm_riscv_vcpu_pmu_incr_fw(vcpu, 
> SBI_PMU_FW_HFENCE_VVMA_SENT);
> break;
>          case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
> <<<<<<< HEAD
>                  if (cp->a2 == 0 && cp->a3 == 0)
> kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
>                                                         hbase, hmask, 
> cp->a4);
> =======
>                  vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>                  if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
> kvm_riscv_hfence_vvma_asid_all(vcpu->kvm, hbase, hmask,
>                                                         cp->a4, vmid);
>  >>>>>>> 57ec61198cc1 (RISC-V: KVM: Pass VMID as parameter to 
> kvm_riscv_hfence_xyz() APIs)
> 
> 

ohh you already queued the PATCH1 from v1 of this series. If I try to 
rebase on top of riscv_kvm_queue, I see the following error in b4 shazam.

---
Patch failed at 0008 RISC-V: KVM: Factor-out MMU related declarations 
into separate headers.
----

>>           else
>>               kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
>> -                          cp->a2, cp->a3, PAGE_SHIFT);
>> +                          cp->a2, cp->a3, PAGE_SHIFT, vmid);
>>           kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_SENT);
>>           break;
>>       case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
>> +        vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>>           if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
>> -            kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
>> -                               hbase, hmask, cp->a4);
>> +            kvm_riscv_hfence_vvma_asid_all(vcpu->kvm, hbase, hmask,
>> +                               cp->a4, vmid);
>>           else
>> -            kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm,
>> -                               hbase, hmask,
>> -                               cp->a2, cp->a3,
>> -                               PAGE_SHIFT, cp->a4);
>> +            kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm, hbase, hmask, 
>> cp->a2,
>> +                               cp->a3, PAGE_SHIFT, cp->a4, vmid);
>>           kvm_riscv_vcpu_pmu_incr_fw(vcpu, 
>> SBI_PMU_FW_HFENCE_VVMA_ASID_SENT);
>>           break;
>>       case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
>> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/ 
>> vcpu_sbi_v01.c
>> index 8f4c4fa16227..368dfddd23d9 100644
>> --- a/arch/riscv/kvm/vcpu_sbi_v01.c
>> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
>> @@ -23,6 +23,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu 
>> *vcpu, struct kvm_run *run,
>>       struct kvm *kvm = vcpu->kvm;
>>       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>>       struct kvm_cpu_trap *utrap = retdata->utrap;
>> +    unsigned long vmid;
>>       switch (cp->a7) {
>>       case SBI_EXT_0_1_CONSOLE_GETCHAR:
>> @@ -78,25 +79,21 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu 
>> *vcpu, struct kvm_run *run,
>>           if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
>>               kvm_riscv_fence_i(vcpu->kvm, 0, hmask);
>>           else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA) {
>> +            vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>>               if (cp->a1 == 0 && cp->a2 == 0)
>> -                kvm_riscv_hfence_vvma_all(vcpu->kvm,
>> -                              0, hmask);
>> +                kvm_riscv_hfence_vvma_all(vcpu->kvm, 0, hmask, vmid);
>>               else
>> -                kvm_riscv_hfence_vvma_gva(vcpu->kvm,
>> -                              0, hmask,
>> -                              cp->a1, cp->a2,
>> -                              PAGE_SHIFT);
>> +                kvm_riscv_hfence_vvma_gva(vcpu->kvm, 0, hmask, cp->a1,
>> +                              cp->a2, PAGE_SHIFT, vmid);
>>           } else {
>> +            vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>>               if (cp->a1 == 0 && cp->a2 == 0)
>> -                kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
>> -                                   0, hmask,
>> -                                   cp->a3);
>> +                kvm_riscv_hfence_vvma_asid_all(vcpu->kvm, 0, hmask,
>> +                                   cp->a3, vmid);
>>               else
>> -                kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm,
>> -                                   0, hmask,
>> -                                   cp->a1, cp->a2,
>> -                                   PAGE_SHIFT,
>> -                                   cp->a3);
>> +                kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm, 0, hmask,
>> +                                   cp->a1, cp->a2, PAGE_SHIFT,
>> +                                   cp->a3, vmid);
>>           }
>>           break;
>>       default:


