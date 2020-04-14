Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B669A1A7BA2
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 15:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502495AbgDNNCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 09:02:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58827 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502486AbgDNNC1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 09:02:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586869345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8KYrjFdKV0F0kc/rQUca0FTze+6bSQcKKl07Ya/wHr0=;
        b=hDLGuK38yVtcUBvM/ohTt4iK5EfqEQWi95kkyNyAg5Y2Yi+31Cd7DfMar0Mm9UCmpaRI0H
        /QkMjRojuzzxmEamNvBixkLztFlw4EwPFe9jj5RtTcYgbycD1faTKX6bCIy+zAna2pg64d
        ZbPAOyWXVyWtnY5N0veCaN0wlZrSDJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-lQWz2TjjPiOvng-9rirdaw-1; Tue, 14 Apr 2020 09:02:23 -0400
X-MC-Unique: lQWz2TjjPiOvng-9rirdaw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0566D18C35A2;
        Tue, 14 Apr 2020 13:02:22 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-15.gru2.redhat.com [10.97.116.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1F1060C88;
        Tue, 14 Apr 2020 13:02:10 +0000 (UTC)
Subject: Re: [PATCH 01/10] KVM: selftests: Take vcpu pointer instead of id in
 vm_vcpu_rm()
To:     Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
 <20200410231707.7128-2-sean.j.christopherson@intel.com>
 <b696c5b9-2507-8849-e196-37c83806cfdf@redhat.com>
 <20200413212659.GB21204@linux.intel.com>
 <20200414082556.nfdgec63kuqknpxc@kamzik.brq.redhat.com>
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-ID: <023b0cb2-50d7-9145-d065-32436d429806@redhat.com>
Date:   Tue, 14 Apr 2020 10:02:08 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200414082556.nfdgec63kuqknpxc@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/14/20 5:25 AM, Andrew Jones wrote:
> On Mon, Apr 13, 2020 at 02:26:59PM -0700, Sean Christopherson wrote:
>> On Mon, Apr 13, 2020 at 03:26:55PM -0300, Wainer dos Santos Moschetta wrote:
>>> On 4/10/20 8:16 PM, Sean Christopherson wrote:
>>>> The sole caller of vm_vcpu_rm() already has the vcpu pointer, take it
>>>> directly instead of doing an extra lookup.
>>>
>>> Most of (if not all) vcpu related functions in kvm_util.c receives an id, so
>>> this change creates an inconsistency.
>> Ya, but taking the id is done out of "necessity", as everything is public
>> and for whatever reason the design of the selftest framework is to not
>> expose 'struct vcpu' outside of the utils.  vm_vcpu_rm() is internal only,
>> IMO pulling the id out of the vcpu just to lookup the same vcpu is a waste
>> of time.
> Agreed


Thanks Sean and Andrew for your comments. I'm not in position to 
change/propose any design of kvm selftests but even though I aimed to 
foster this discussion.

So, please, consider my Reviewed-by...

- Wainer


>
>> FWIW, I think the whole vcpuid thing is a bad interface, almost all the
>> tests end up defining an arbitrary number for the sole VCPU_ID, i.e. the
>> vcpuid interface just adds a pointless layer of obfuscation.  I haven't
>> looked through all the tests, but returning the vcpu and making the struct
>> opaque, same as kvm_vm, seems like it would yield more readable code with
>> less overhead.
> Agreed
>
>> While I'm on a soapbox, hiding 'struct vcpu' and 'struct kvm_vm' also seems
>> rather silly, but at least that doesn't directly lead to funky code.
> Agreed. While the concept has been slowly growing on me, I think accessor
> functions for each of the structs members are growing even faster...
>
> Thanks,
> drew
>
>>> Disregarding the above comment, the changes look good to me. So:
>>>
>>> Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
>>>
>>>
>>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>>> ---
>>>>   tools/testing/selftests/kvm/lib/kvm_util.c | 7 +++----
>>>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
>>>> index 8a3523d4434f..9a783c20dd26 100644
>>>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>>>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>>>> @@ -393,7 +393,7 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
>>>>    *
>>>>    * Input Args:
>>>>    *   vm - Virtual Machine
>>>> - *   vcpuid - VCPU ID
>>>> + *   vcpu - VCPU to remove
>>>>    *
>>>>    * Output Args: None
>>>>    *
>>>> @@ -401,9 +401,8 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
>>>>    *
>>>>    * Within the VM specified by vm, removes the VCPU given by vcpuid.
>>>>    */
>>>> -static void vm_vcpu_rm(struct kvm_vm *vm, uint32_t vcpuid)
>>>> +static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
>>>>   {
>>>> -	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
>>>>   	int ret;
>>>>   	ret = munmap(vcpu->state, sizeof(*vcpu->state));
>>>> @@ -427,7 +426,7 @@ void kvm_vm_release(struct kvm_vm *vmp)
>>>>   	int ret;
>>>>   	while (vmp->vcpu_head)
>>>> -		vm_vcpu_rm(vmp, vmp->vcpu_head->id);
>>>> +		vm_vcpu_rm(vmp, vmp->vcpu_head);
>>>>   	ret = close(vmp->fd);
>>>>   	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"

