Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD2A1521E7
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 22:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgBDVVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 16:21:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46397 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727564AbgBDVVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 16:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580851274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=TOOXNSyHi7JTRoQu2UaBp9jB+r7kRJrDhf/+4ngIFtc=;
        b=KwyuII+6AkwNiWWkHKEA4IPX1FeVmo1cQHmo9j2S0p6AHP7nyW6qfFAeRKLAutoz9hrtXW
        9zANsvINThodoNJRpX501oPt7wS1BRBgqCbT1HB0JwAetVDlcPFPtTKsGt8uE6ILTvYU9D
        Avp7eZR+nNhw1i6WeQa8MNtDxgSHadU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-ax_XGMlIOjunTnxHxCsmUg-1; Tue, 04 Feb 2020 16:21:10 -0500
X-MC-Unique: ax_XGMlIOjunTnxHxCsmUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F42C1088387;
        Tue,  4 Feb 2020 21:21:09 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-98.ams2.redhat.com [10.36.116.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 073047792A;
        Tue,  4 Feb 2020 21:21:03 +0000 (UTC)
Subject: Re: [RFCv2 13/37] KVM: s390: protvirt: Instruction emulation
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-14-borntraeger@de.ibm.com>
 <da579f7a-f2a2-7f81-a606-3829878dec5d@redhat.com>
 <3d727c22-fa75-2c9a-75de-33ded36367eb@de.ibm.com>
 <20200204180712.2b02274e.cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <92ae240b-0581-5874-e79e-3de071ff8a63@redhat.com>
Date:   Tue, 4 Feb 2020 22:21:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200204180712.2b02274e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/2020 18.07, Cornelia Huck wrote:
> On Tue, 4 Feb 2020 13:29:46 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 04.02.20 13:20, David Hildenbrand wrote:
>>> On 03.02.20 14:19, Christian Borntraeger wrote:  
>>>> From: Janosch Frank <frankja@linux.ibm.com>
>>>>
>>>> We have two new SIE exit codes dealing with instructions.
>>>> 104 (0x68) for a secure instruction interception, on which the SIE needs
>>>> hypervisor action to complete the instruction. We can piggy-back on the
>>>> existing instruction handlers.
>>>>
>>>> 108 which is merely a notification and provides data for tracking and
>>>> management. For example this is used to tell the host about a new value
>>>> for the prefix register. As there will be several special case handlers
>>>> in later patches, we handle this in a separate function.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  arch/s390/include/asm/kvm_host.h |  2 ++
>>>>  arch/s390/kvm/intercept.c        | 11 +++++++++++
>>>>  2 files changed, 13 insertions(+)
>>>>
>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>>> index d63ed05272ec..58845b315be0 100644
>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>> @@ -217,6 +217,8 @@ struct kvm_s390_sie_block {
>>>>  #define ICPT_KSS	0x5c
>>>>  #define ICPT_PV_MCHKR	0x60
>>>>  #define ICPT_PV_INT_EN	0x64
>>>> +#define ICPT_PV_INSTR	0x68
>>>> +#define ICPT_PV_NOTIF	0x6c  
>>>
>>> NOTIFY? NOTIFICATION? NOTIF is weird.  
>>
>> ack. I used NOTIFY to keep the numbers aligned.
>>
>>>   
>>>>  	__u8	icptcode;		/* 0x0050 */
>>>>  	__u8	icptstatus;		/* 0x0051 */
>>>>  	__u16	ihcpu;			/* 0x0052 */
>>>> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>>>> index eaa2a21c3170..4b3fbbde1674 100644
>>>> --- a/arch/s390/kvm/intercept.c
>>>> +++ b/arch/s390/kvm/intercept.c
>>>> @@ -444,6 +444,11 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
>>>>  	return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>>>>  }
>>>>  
>>>> +static int handle_pv_not(struct kvm_vcpu *vcpu)  
>>>
>>> "notification" please. not not. You see why ;)  
>>
>> ack. 
>>
> 
> With these changes on top:

I concur, with the changes on top:

Reviewed-by: Thomas Huth <thuth@redhat.com>

