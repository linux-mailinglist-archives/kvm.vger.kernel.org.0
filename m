Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDD63BE755
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 13:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhGGLpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 07:45:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231417AbhGGLpN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 07:45:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625658153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nuo7XN5inHAQRmRQx8wnRqd6hqtyVn9XgjE1E3fOGqE=;
        b=eB0SAeO6J6dPKXQ/dnenCrTNwhicZL3L5oAx5yHhnMRG7DWkHq5qjucu1ucrr9Vf9ZGEoc
        2dqqttL1lYYnOgbp4frMQTb+aTXlrTpuG7f6CtKtFVg39fexAJj4oZerg116eI4yzKE9sZ
        59SbEr8RbHQ9/tz3g3q/4/1llyeaU2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-cT3YJMXZPO6MMDaior_MZg-1; Wed, 07 Jul 2021 07:42:30 -0400
X-MC-Unique: cT3YJMXZPO6MMDaior_MZg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5FB81023F40;
        Wed,  7 Jul 2021 11:42:28 +0000 (UTC)
Received: from localhost (ovpn-112-160.ams2.redhat.com [10.36.112.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 935C710016F4;
        Wed,  7 Jul 2021 11:42:24 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390)" 
        <kvm@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: s390: Enable specification exception interpretation
In-Reply-To: <243a5476-153f-8d4b-7e0a-bb291010a3bd@linux.vnet.ibm.com>
Organization: Red Hat GmbH
References: <20210706114714.3936825-1-scgl@linux.ibm.com>
 <05430c91-6a84-0fc9-0af4-89f408eb691f@de.ibm.com>
 <87lf6ifqs5.fsf@redhat.com>
 <243a5476-153f-8d4b-7e0a-bb291010a3bd@linux.vnet.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 07 Jul 2021 13:42:23 +0200
Message-ID: <87im1mfizk.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07 2021, Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com> wrote:

> On 7/7/21 10:54 AM, Cornelia Huck wrote:
>
> [...]
>
>> 
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index b655a7d82bf0..aadd589a3755 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -3200,6 +3200,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>>>>   		vcpu->arch.sie_block->ecb |= ECB_SRSI;
>>>>   	if (test_kvm_facility(vcpu->kvm, 73))
>>>>   		vcpu->arch.sie_block->ecb |= ECB_TE;
>> 
>> Maybe add
>> 
>> /* no facility bit, but safe as the hardware may ignore it */
>> 
>> or something like that, so that we don't stumble over that in the future?
>
> Well, the hardware being allowed to ignore the bit makes its introduction
> without an indication forward compatible because it does not require vSIE to be adapted.
> The reserved bits are implicitly set to 0 which means new features are disabled
> by default and one observes all the interception one expects.
>
> Maybe this:
>
> /* no facility bit, can opt in because we do not need
>    to observe specification exception intercepts */
>
> ?

Works for me as well.

>
>> 
>>>> +	if (!kvm_is_ucontrol(vcpu->kvm))
>>>> +		vcpu->arch.sie_block->ecb |= ECB_SPECI;
>>>>
>>>>   	if (test_kvm_facility(vcpu->kvm, 8) && vcpu->kvm->arch.use_pfmfi)
>>>>   		vcpu->arch.sie_block->ecb2 |= ECB2_PFMFI;
>> 
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> 

