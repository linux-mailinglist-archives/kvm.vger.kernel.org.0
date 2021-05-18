Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1A038783C
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 14:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348946AbhERMBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 08:01:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348925AbhERMBf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 08:01:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IBlY8m058093;
        Tue, 18 May 2021 08:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fDqI/9Bf4nbAzLJhSZmnuMVCjOZ+SR/1c4d5fB4+Kgw=;
 b=L/3EKFH7Dd2mJQ4vxiQX/fJaE1NCtB/pby1J1B0tylVMrvjDCTwlNNSjJHC4dxnp3L3a
 7cjNkOzLI2A7Luo1trHdnIMrnAmwfZLD3v/RVhVlqTv634S+KnCzQw9qBCxdnLqPPue7
 fzV1QPGeRQPkSKdHDnKXfgjHgKEuAnXHbRN6FTlLMGpMJjaxwuM+bAl6E0/GhI6JAWks
 FoHiMmj6of2Cf1X8RLhWXoJv/31fxFeXxz0gqzrhanLZJuAzxv1yF1VJ8hW660oxHt59
 q9uFDq7rN7m9x3qaTLE0aAGdoCMqSv9MVOIiW4LLYztFoAlOJZ8ZxaN9OyMhW/0kM8CF bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38md14g8h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 08:00:16 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IBr4Ws095044;
        Tue, 18 May 2021 08:00:15 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38md14g8ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 08:00:15 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IBwH4J000902;
        Tue, 18 May 2021 12:00:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 38mceh80f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:00:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IC0Aew39518640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 12:00:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20873A4040;
        Tue, 18 May 2021 12:00:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C98AA4081;
        Tue, 18 May 2021 12:00:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.37.27])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 May 2021 12:00:09 +0000 (GMT)
Subject: Re: [PATCH v1 01/11] KVM: s390: pv: leak the ASCE page when destroy
 fails
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
 <20210517200758.22593-2-imbrenda@linux.ibm.com>
 <13cb02d1-df3b-7994-8a31-99aacfd15566@linux.ibm.com>
 <20210518124027.48f36caa@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <62e16545-d078-6d91-2370-e4e5677306c7@linux.ibm.com>
Date:   Tue, 18 May 2021 14:00:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210518124027.48f36caa@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VWvI3ObC1yZIO9X-rdR8eWOQirAD2PrH
X-Proofpoint-ORIG-GUID: wD2Tqk0huFotGSIbvIukuAjMqMMKGU6f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_04:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105180082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/21 12:40 PM, Claudio Imbrenda wrote:
> On Tue, 18 May 2021 12:26:51 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 5/17/21 10:07 PM, Claudio Imbrenda wrote:
>>> When the destroy configuration UVC fails, the page pointed to by the
>>> ASCE of the VM becomes poisoned, and, to avoid issues it must not be
>>> used again.
>>>
>>> Since the page becomes in practice unusable, we set it aside and
>>> leak it.  
>>
>> I think we need something a bit more specific.
>>
>> On creation of a protected guest the top most level of page tables are
>> marked by the Ultravisor and can only be used as top level page tables
>> for the protected guest that was created. If another protected guest
>> would re-use those pages for its top level page tables the UV would
>> throw errors.
>>
>> When a destroy fails the UV will not remove the markings so these
>> pages are basically unusable since we can't guarantee that they won't
>> be used for a guest ASCE in the future.
>>
>> Hence we choose to leak those pages in the very unlikely event that a
>> destroy fails.
> 
> it's more than that. the top level page, once marked, also cannot be
> used as backing for the virtual and real memory areas donated with the
> create secure configuration and create secure cpu UVCs.
> 
> and there might also other circumstances in which that page cannot be
> used that I am not aware of
> 

Even more reason to document it :)

>>
>> LGTM
>>
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>  arch/s390/kvm/pv.c | 53
>>> +++++++++++++++++++++++++++++++++++++++++++++- 1 file changed, 52
>>> insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
>>> index 813b6e93dc83..e0532ab725bf 100644
>>> --- a/arch/s390/kvm/pv.c
>>> +++ b/arch/s390/kvm/pv.c
>>> @@ -150,6 +150,55 @@ static int kvm_s390_pv_alloc_vm(struct kvm
>>> *kvm) return -ENOMEM;
>>>  }
>>>  
>>> +/*
>>> + * Remove the topmost level of page tables from the list of page
>>> tables of
>>> + * the gmap.
>>> + * This means that it will not be freed when the VM is torn down,
>>> and needs
>>> + * to be handled separately by the caller, unless an intentional
>>> leak is
>>> + * intended.
>>> + */
>>> +static void kvm_s390_pv_remove_old_asce(struct kvm *kvm)
>>> +{
>>> +	struct page *old;
>>> +
>>> +	old = virt_to_page(kvm->arch.gmap->table);
>>> +	list_del(&old->lru);
>>> +	/* in case the ASCE needs to be "removed" multiple times */
>>> +	INIT_LIST_HEAD(&old->lru);  
>>
>> ?
>>
>>> +}
>>> +
>>> +/*
>>> + * Try to replace the current ASCE with another equivalent one.
>>> + * If the allocation of the new top level page table fails, the
>>> ASCE is not
>>> + * replaced.
>>> + * In any case, the old ASCE is removed from the list, therefore
>>> the caller
>>> + * has to make sure to save a pointer to it beforehands, unless an
>>> + * intentional leak is intended.
>>> + */
>>> +static int kvm_s390_pv_replace_asce(struct kvm *kvm)
>>> +{
>>> +	unsigned long asce;
>>> +	struct page *page;
>>> +	void *table;
>>> +
>>> +	kvm_s390_pv_remove_old_asce(kvm);
>>> +
>>> +	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
>>> +	if (!page)
>>> +		return -ENOMEM;
>>> +	list_add(&page->lru, &kvm->arch.gmap->crst_list);
>>> +
>>> +	table = page_to_virt(page);
>>> +	memcpy(table, kvm->arch.gmap->table, 1UL <<
>>> (CRST_ALLOC_ORDER + PAGE_SHIFT)); +
>>> +	asce = (kvm->arch.gmap->asce & ~PAGE_MASK) | __pa(table);
>>> +	WRITE_ONCE(kvm->arch.gmap->asce, asce);
>>> +	WRITE_ONCE(kvm->mm->context.gmap_asce, asce);
>>> +	WRITE_ONCE(kvm->arch.gmap->table, table);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  /* this should not fail, but if it does, we must not free the
>>> donated memory */ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16
>>> *rc, u16 *rrc) {
>>> @@ -164,9 +213,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16
>>> *rc, u16 *rrc) atomic_set(&kvm->mm->context.is_protected, 0);
>>>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
>>> *rc, *rrc); WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc
>>> %x", *rc, *rrc);
>>> -	/* Inteded memory leak on "impossible" error */
>>> +	/* Intended memory leak on "impossible" error */
>>>  	if (!cc)
>>>  		kvm_s390_pv_dealloc_vm(kvm);
>>> +	else
>>> +		kvm_s390_pv_replace_asce(kvm);
>>>  	return cc ? -EIO : 0;
>>>  }
>>>  
>>>   
>>
> 

