Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6F3C9C87
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 12:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbhGOKTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 06:19:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241257AbhGOKTK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 06:19:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626344176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JYQMJYctnlNOap/G1b0ozhwT2Ts7Z4hiy1PTpVQjlPg=;
        b=XdA2ZaGUCyfWFrgvBKOpcH6u29jLQWIlInGzvYGwNPd77vOmQ2YGZ137Y8j9yuWkJerJtg
        +RWG5aTgQGiSBwb9FPUn+S977Wpw4j4eHuleNyAcn7WVkuUMEphBQlUhF8aDg/gkSm71oP
        7Z1WtiHPNWxZJ/x2A+IB2mutPT18QJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371--VREVZRXM9yevE_01oB9ug-1; Thu, 15 Jul 2021 06:16:13 -0400
X-MC-Unique: -VREVZRXM9yevE_01oB9ug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1C9C100C610;
        Thu, 15 Jul 2021 10:16:11 +0000 (UTC)
Received: from localhost (ovpn-112-104.ams2.redhat.com [10.36.112.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6699D5D9DD;
        Thu, 15 Jul 2021 10:16:07 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v1 1/2] s390x: KVM: accept STSI for CPU topology
 information
In-Reply-To: <57e57ba5-62ea-f1ff-0d83-5605d57be92d@redhat.com>
Organization: Red Hat GmbH
References: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
 <1626276343-22805-2-git-send-email-pmorel@linux.ibm.com>
 <db788a8c-99a9-6d99-07ab-b49e953d91a2@redhat.com>
 <87fswfdiuu.fsf@redhat.com>
 <57e57ba5-62ea-f1ff-0d83-5605d57be92d@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 15 Jul 2021 12:16:06 +0200
Message-ID: <87czrjdgrd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15 2021, David Hildenbrand <david@redhat.com> wrote:

> On 15.07.21 11:30, Cornelia Huck wrote:
>> On Thu, Jul 15 2021, David Hildenbrand <david@redhat.com> wrote:
>> 
>>> On 14.07.21 17:25, Pierre Morel wrote:
>>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>>> Let's accept the interception of STSI with the function code 15 and
>>>> let the userland part of the hypervisor handle it.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    arch/s390/kvm/priv.c | 11 ++++++++++-
>>>>    1 file changed, 10 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>>> index 9928f785c677..4ab5f8b7780e 100644
>>>> --- a/arch/s390/kvm/priv.c
>>>> +++ b/arch/s390/kvm/priv.c
>>>> @@ -856,7 +856,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>>    	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>>>    		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>>>    
>>>> -	if (fc > 3) {
>>>> +	if (fc > 3 && fc != 15) {
>>>>    		kvm_s390_set_psw_cc(vcpu, 3);
>>>>    		return 0;
>>>>    	}
>>>> @@ -893,6 +893,15 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>>    			goto out_no_data;
>>>>    		handle_stsi_3_2_2(vcpu, (void *) mem);
>>>>    		break;
>>>> +	case 15:
>>>> +		if (sel1 != 1 || sel2 < 2 || sel2 > 6)
>>>> +			goto out_no_data;
>>>> +		if (vcpu->kvm->arch.user_stsi) {
>>>> +			insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
>>>> +			return -EREMOTE;
>> 
>> This bypasses the trace event further down.
>> 
>>>> +		}
>>>> +		kvm_s390_set_psw_cc(vcpu, 3);
>>>> +		return 0;
>>>>    	}
>>>>    	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>>>>    		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
>>> 3. User space awareness
>>>
>>> How can user space identify that we actually forward these intercepts?
>>> How can it enable them? The old KVM_CAP_S390_USER_STSI capability
>>> is not sufficient.
>> 
>> Why do you think that it is not sufficient? USER_STSI basically says
>> "you may get an exit that tells you about a buffer to fill in some more
>> data for a stsi command, and we also tell you which call". If userspace
>> does not know what to add for a certain call, it is free to just do
>> nothing, and if it does not get some calls it would support, that should
>> not be a problem, either?
>
> If you migrate your VM from machine a to machine b, from kernel a to 
> kernel b, and kernel b does not trigger exits to user space for fc=15, 
> how could QEMU spot and catch the different capabilities to make sure 
> the guest can continue using the feature?

Wouldn't that imply that the USER_STSI feature, in the function-agnostic
way it is documented, was broken from the start?

Hm. Maybe we need some kind of facility where userspace can query the
kernel and gets a list of the stsi subcodes it may get exits for, and
possibly fail to start the migration. Having a new capability to be
enabled for every new subcode feels like overkill. I don't think we can
pass a payload ("enable these subfunctions") to a cap.

Or can we tie a subcode to another feature, like the mystery cap that
was mentioned in the description, but does not seem to appear in the
code?

