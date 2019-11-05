Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF29EFF10
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 14:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389306AbfKENzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 08:55:15 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26409 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389264AbfKENzO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 08:55:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572962113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98WfjUYr/kZLtNdGh6skuftwm270AeiHL8h81L2pNJA=;
        b=PzA1ceYVJ8dAG5lApshptt6zF7SlWojHPGSjvEzeFjiQk2oTjqzT2RML9GdHCses3MNYcL
        nS5Bm1wpxv6nmiipipPDB8NV8W9r7jBSmEsCPqkffRlgQAWzG/MLd97WejI6utmll2O0po
        45+kEliyj20gcg01LNI5gHGs7ZxlCok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-AKNNCdYgNsKYOe2J0e14wQ-1; Tue, 05 Nov 2019 08:55:09 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61F40477;
        Tue,  5 Nov 2019 13:55:08 +0000 (UTC)
Received: from [10.36.116.43] (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FC7D600F4;
        Tue,  5 Nov 2019 13:55:02 +0000 (UTC)
Subject: Re: [RFC 19/37] KVM: s390: protvirt: Add new gprs location handling
To:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-20-frankja@linux.ibm.com>
 <2eba24a5-063d-1e93-acf0-1153963facfe@redhat.com>
 <8f7a9da4-2a49-9e3f-573e-199cd71fc99c@de.ibm.com>
 <1588a5e9-9bd9-428d-5b05-114a9307ceee@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <658457c3-398b-7dde-2c6d-073e4d3feac8@redhat.com>
Date:   Tue, 5 Nov 2019 14:55:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1588a5e9-9bd9-428d-5b05-114a9307ceee@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: AKNNCdYgNsKYOe2J0e14wQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.11.19 13:39, Janosch Frank wrote:
> On 11/5/19 1:01 PM, Christian Borntraeger wrote:
>>
>>
>> On 04.11.19 12:25, David Hildenbrand wrote:
>>> On 24.10.19 13:40, Janosch Frank wrote:
>>>> Guest registers for protected guests are stored at offset 0x380.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  =C2=A0 arch/s390/include/asm/kvm_host.h |=C2=A0 4 +++-
>>>>  =C2=A0 arch/s390/kvm/kvm-s390.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 11 +++++++++++
>>>>  =C2=A0 2 files changed, 14 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/=
kvm_host.h
>>>> index 0ab309b7bf4c..5deabf9734d9 100644
>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>> @@ -336,7 +336,9 @@ struct kvm_s390_itdb {
>>>>  =C2=A0 struct sie_page {
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_s390_sie_block sie_block;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mcck_volatile_info mcck_info;=
=C2=A0=C2=A0=C2=A0 /* 0x0200 */
>>>> -=C2=A0=C2=A0=C2=A0 __u8 reserved218[1000];=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /* 0x0218 */
>>>> +=C2=A0=C2=A0=C2=A0 __u8 reserved218[360];=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /* 0x0218 */
>>>> +=C2=A0=C2=A0=C2=A0 __u64 pv_grregs[16];=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 /* 0x380 */
>>>> +=C2=A0=C2=A0=C2=A0 __u8 reserved400[512];
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_s390_itdb itdb;=C2=A0=C2=A0=
=C2=A0 /* 0x0600 */
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 reserved700[2304];=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* 0x0700 */
>>>>  =C2=A0 };
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 490fde080107..97d3a81e5074 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -3965,6 +3965,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, =
int exit_reason)
>>>>  =C2=A0 static int __vcpu_run(struct kvm_vcpu *vcpu)
>>>>  =C2=A0 {
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int rc, exit_reason;
>>>> +=C2=A0=C2=A0=C2=A0 struct sie_page *sie_page =3D (struct sie_page *)v=
cpu->arch.sie_block;
>>>>  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * We try to hold kvm->srcu durin=
g most of vcpu_run (except when run-
>>>> @@ -3986,8 +3987,18 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 guest_enter_ir=
qoff();
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __disable_cpu_=
timer_accounting(vcpu);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local_irq_enab=
le();
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm_s390_pv_is_protect=
ed(vcpu->kvm)) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 me=
mcpy(sie_page->pv_grregs,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->run->s.regs.gprs,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(sie_page->pv_grregs));
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exit_reason =
=3D sie64a(vcpu->arch.sie_block,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->run->=
s.regs.gprs);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm_s390_pv_is_protect=
ed(vcpu->kvm)) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 me=
mcpy(vcpu->run->s.regs.gprs,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sie_page->pv_grregs,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(sie_page->pv_grregs));
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>
>>> sie64a will load/save gprs 0-13 from to vcpu->run->s.regs.gprs.
>>>
>>> I would have assume that this is not required for prot virt, because th=
e HW has direct access via the sie block?
>>
>> Yes, that is correct. The load/save in sie64a is not necessary for pv gu=
ests.
>>
>>>
>>>
>>> 1. Would it make sense to have a specialized sie64a() (or a parameter, =
e.g., if you pass in NULL in r3), that optimizes this loading/saving? Event=
ually we can also optimize which host registers to save/restore then.
>>
>> Having 2 kinds of sie64a seems not very nice for just saving a small num=
ber of cycles.
>>
>>>
>>> 2. Avoid this copying here. We have to store the state to vcpu->run->s.=
regs.gprs when returning to user space and restore the state when coming fr=
om user space.
>>
>> I like this proposal better than the first one and

It was actually an additional proposal :)

1. avoids unnecessary saving/loading/saving/restoring
2. avoids the two memcpy

>>>
>>> Also, we access the GPRS from interception handlers, there we might use=
 wrappers like
>>>
>>> kvm_s390_set_gprs()
>>> kvm_s390_get_gprs()
>>
>> having register accessors might be useful anyway.
>> But I would like to defer that to a later point in time to keep the chan=
ges in here
>> minimal?
>>
>> We can add a "TODO" comment in here so that we do not forget about this
>> for a future patch. Makes sense?

While it makes sense, I guess one could come up with a patch for 2. in=20
less than 30 minutes ... but yeah, whatever you prefer. ;)

--=20

Thanks,

David / dhildenb

