Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C3EE4530
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437719AbfJYIFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 04:05:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35273 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437690AbfJYIFB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 04:05:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571990699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z62dBP634h2LiXBgNYzdEmlRocL8Yc1yodjmdo8Qex0=;
        b=iNrzOTbukN/VncReE472oca7ZxV3tPzWf9aM1MygsFWElUOi9ZwWYf1FKynEMbYD78/Sfw
        bBUl1lDJ/oXmwrqzSscbj986bWcHuS9sB7UPVuZWhZG0f/gsTe9yiKzXUPRIr71OJOWRoR
        TZGluLHSc+ggmEzJy8vadONoWkTHn5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-5BbnLK3wPYmv83TaYQh9Qw-1; Fri, 25 Oct 2019 04:04:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 934A2107AD31;
        Fri, 25 Oct 2019 08:04:54 +0000 (UTC)
Received: from [10.36.116.205] (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B33B57A7;
        Fri, 25 Oct 2019 08:04:52 +0000 (UTC)
Subject: Re: [RFC 07/37] KVM: s390: protvirt: Secure memory is not mergeable
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-8-frankja@linux.ibm.com>
 <f80519a0-a8da-1a98-c450-b81dfcf2e897@redhat.com>
 <3f7cc352-56d8-f0c7-3cb2-7278b8262035@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <af9b9d01-4837-a48f-c9ce-2b20d9e8cb96@redhat.com>
Date:   Fri, 25 Oct 2019 10:04:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <3f7cc352-56d8-f0c7-3cb2-7278b8262035@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 5BbnLK3wPYmv83TaYQh9Qw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.10.19 09:18, Janosch Frank wrote:
> On 10/24/19 6:07 PM, David Hildenbrand wrote:
>> On 24.10.19 13:40, Janosch Frank wrote:
>>> KSM will not work on secure pages, because when the kernel reads a
>>> secure page, it will be encrypted and hence no two pages will look the
>>> same.
>>>
>>> Let's mark the guest pages as unmergeable when we transition to secure
>>> mode.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>    arch/s390/include/asm/gmap.h |  1 +
>>>    arch/s390/kvm/kvm-s390.c     |  6 ++++++
>>>    arch/s390/mm/gmap.c          | 28 ++++++++++++++++++----------
>>>    3 files changed, 25 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.=
h
>>> index 6efc0b501227..eab6a2ec3599 100644
>>> --- a/arch/s390/include/asm/gmap.h
>>> +++ b/arch/s390/include/asm/gmap.h
>>> @@ -145,4 +145,5 @@ int gmap_mprotect_notify(struct gmap *, unsigned lo=
ng start,
>>>   =20
>>>    void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_=
bitmap[4],
>>>    =09=09=09     unsigned long gaddr, unsigned long vmaddr);
>>> +int gmap_mark_unmergeable(void);
>>>    #endif /* _ASM_S390_GMAP_H */
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index 924132d92782..d1ba12f857e7 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -2176,6 +2176,12 @@ static int kvm_s390_handle_pv(struct kvm *kvm, s=
truct kvm_pv_cmd *cmd)
>>>    =09=09if (r)
>>>    =09=09=09break;
>>>   =20
>>> +=09=09down_write(&current->mm->mmap_sem);
>>> +=09=09r =3D gmap_mark_unmergeable();
>>> +=09=09up_write(&current->mm->mmap_sem);
>>> +=09=09if (r)
>>> +=09=09=09break;
>>> +
>>>    =09=09mutex_lock(&kvm->lock);
>>>    =09=09kvm_s390_vcpu_block_all(kvm);
>>>    =09=09/* FMT 4 SIE needs esca */
>>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>>> index edcdca97e85e..bf365a09f900 100644
>>> --- a/arch/s390/mm/gmap.c
>>> +++ b/arch/s390/mm/gmap.c
>>> @@ -2548,6 +2548,23 @@ int s390_enable_sie(void)
>>>    }
>>>    EXPORT_SYMBOL_GPL(s390_enable_sie);
>>>   =20
>>> +int gmap_mark_unmergeable(void)
>>> +{
>>> +=09struct mm_struct *mm =3D current->mm;
>>> +=09struct vm_area_struct *vma;
>>> +
>>> +=09for (vma =3D mm->mmap; vma; vma =3D vma->vm_next) {
>>> +=09=09if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
>>> +=09=09=09=09MADV_UNMERGEABLE, &vma->vm_flags)) {
>>> +=09=09=09mm->context.uses_skeys =3D 0;
>>
>> That skey setting does not make too much sense when coming via
>> kvm_s390_handle_pv(). handle that in the caller?
>=20
> Hmm, I think the name of that variable is just plain wrong.
> It should be "can_use_skeys" or "uses_unmergeable" (which would fit
> better into the mm context anyway) and then we could add a
> kvm->arch.uses_skeys to tell that we actually used them for migration
> checks, etc..
>=20
> I had long discussions with Martin over these variable names a long time
> ago..

uses_skeys is set during s390_enable_skey(). that is used when we

a) Call an skey instruction
b) Migrate skeys

So it should match "uses" or what am I missing?

If you look at the users of "mm_uses_skeys(mm)" I think=20
"uses_unmergeable" would actually be misleading. (e.g.,=20
pgste_set_key()). it really means "somebody used skeys". The unmergable=20
is just a required side effect.

--=20

Thanks,

David / dhildenb

