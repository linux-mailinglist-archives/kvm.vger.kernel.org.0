Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082583C9BE1
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 11:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbhGOJd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 05:33:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22419 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237096AbhGOJd5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 05:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626341458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oRa7CucM5Vt3L+B9qwVeAxCopp9Y3dh0aWmqipflzGo=;
        b=OrEMyy7V5lNQUdfykMd0IiTAqZAccedPXJVjPJSZGF7rpwMetOfydwBFz0IwynyQnzSUWn
        8mXD5oqoSaVRVDpRvU8ATIPsAGXxUTn/uF8d1PJBK5t28Qe48yjkWEhFD5JaE+sZEjjWwf
        bZ/WRRPSxNtJQ2aTBqwK23/E+8H2qrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-pF8wQyEWPVqG6xcDXS4Xag-1; Thu, 15 Jul 2021 05:30:57 -0400
X-MC-Unique: pF8wQyEWPVqG6xcDXS4Xag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3D16845F2F;
        Thu, 15 Jul 2021 09:30:55 +0000 (UTC)
Received: from localhost (ovpn-112-104.ams2.redhat.com [10.36.112.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 936CC10016F5;
        Thu, 15 Jul 2021 09:30:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v1 1/2] s390x: KVM: accept STSI for CPU topology
 information
In-Reply-To: <db788a8c-99a9-6d99-07ab-b49e953d91a2@redhat.com>
Organization: Red Hat GmbH
References: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
 <1626276343-22805-2-git-send-email-pmorel@linux.ibm.com>
 <db788a8c-99a9-6d99-07ab-b49e953d91a2@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 15 Jul 2021 11:30:49 +0200
Message-ID: <87fswfdiuu.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15 2021, David Hildenbrand <david@redhat.com> wrote:

> On 14.07.21 17:25, Pierre Morel wrote:
>> STSI(15.1.x) gives information on the CPU configuration topology.
>> Let's accept the interception of STSI with the function code 15 and
>> let the userland part of the hypervisor handle it.
>> 
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/kvm/priv.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 9928f785c677..4ab5f8b7780e 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -856,7 +856,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>   	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>   		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>   
>> -	if (fc > 3) {
>> +	if (fc > 3 && fc != 15) {
>>   		kvm_s390_set_psw_cc(vcpu, 3);
>>   		return 0;
>>   	}
>> @@ -893,6 +893,15 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>   			goto out_no_data;
>>   		handle_stsi_3_2_2(vcpu, (void *) mem);
>>   		break;
>> +	case 15:
>> +		if (sel1 != 1 || sel2 < 2 || sel2 > 6)
>> +			goto out_no_data;
>> +		if (vcpu->kvm->arch.user_stsi) {
>> +			insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
>> +			return -EREMOTE;

This bypasses the trace event further down.

>> +		}
>> +		kvm_s390_set_psw_cc(vcpu, 3);
>> +		return 0;
>>   	}
>>   	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>>   		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
>> 
>
> 1. Setting GPRS to 0
>
> I was wondering why we have the "vcpu->run->s.regs.gprs[0] = 0;"
> for existing fc 1,2,3 in case we set cc=0.
>
> Looking at the doc, all I find is:
>
> "CC 0: Requested configuration-level number placed in
> general register 0 or requested SYSIB informa-
> tion stored"
>
> But I don't find where it states that we are supposed to set
> general register 0 to 0. Wouldn't we also have to do it for
> fc=15 or for none?
>
> If fc 1,2,3 and 15 are to be handled equally, I suggest the following:
>
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 9928f785c677..6eb86fa58b0b 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -893,17 +893,23 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>                          goto out_no_data;
>                  handle_stsi_3_2_2(vcpu, (void *) mem);
>                  break;
> +       case 15:
> +               if (sel1 != 1 || sel2 < 2 || sel2 > 6)
> +                       goto out_no_data;
> +               break;
>          }
> -       if (kvm_s390_pv_cpu_is_protected(vcpu)) {
> -               memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
> -                      PAGE_SIZE);
> -               rc = 0;
> -       } else {
> -               rc = write_guest(vcpu, operand2, ar, (void *)mem, PAGE_SIZE);
> -       }
> -       if (rc) {
> -               rc = kvm_s390_inject_prog_cond(vcpu, rc);
> -               goto out;
> +       if (mem) {
> +               if (kvm_s390_pv_cpu_is_protected(vcpu)) {
> +                       memcpy((void *)sida_origin(vcpu->arch.sie_block),
> +                              (void *)mem, PAGE_SIZE);
> +               } else {
> +                       rc = write_guest(vcpu, operand2, ar, (void *)mem,
> +                                        PAGE_SIZE);
> +                       if (rc) {
> +                               rc = kvm_s390_inject_prog_cond(vcpu, rc);
> +                               goto out;
> +                       }
> +               }
>          }
>          if (vcpu->kvm->arch.user_stsi) {
>                  insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);

Something like that sounds good, the code is getting a bit convoluted.

>
>
> 2. maximum-MNest facility
>
> "
> 1. If the maximum-MNest facility is installed and
> selector 2 exceeds the nonzero model-depen-
> dent maximum-selector-2 value."
>
> 2. If the maximum-MNest facility is not installed and
> selector 2 is not specified as two.
> "
>
> We will we be handling the presence/absence of the maximum-MNest facility
> (for our guest?) in QEMU, corect?
>
> I do wonder if we should just let any fc=15 go to user space let the whole
> sel1 / sel2 checking be handled there. I don't think it's a fast path after all.
> But no strong opinion.

If that makes handling easier, I think it would be a good idea.

>
> How do we identify availability of maximum-MNest facility?
>
>
> 3. User space awareness
>
> How can user space identify that we actually forward these intercepts?
> How can it enable them? The old KVM_CAP_S390_USER_STSI capability
> is not sufficient.

Why do you think that it is not sufficient? USER_STSI basically says
"you may get an exit that tells you about a buffer to fill in some more
data for a stsi command, and we also tell you which call". If userspace
does not know what to add for a certain call, it is free to just do
nothing, and if it does not get some calls it would support, that should
not be a problem, either?

>
> I do wonder if we want KVM_CAP_S390_USER_STSI_15 or sth like that to change
> the behavior once enabled by user space.
>
>
> 4. Without vcpu->kvm->arch.user_stsi, we indicate cc=0 to our guest,
> also for fc 1,2,3. Is that actually what we want? (or do we simply not care
> because the guest is not supposed to use stsi?)

If returning an empty buffer is ok, it should not be a problem, I
guess. (I have not looked yet at the actual definitions.)

