Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB715EC167
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 13:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiI0LcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 07:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiI0LcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 07:32:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC9AE0A3
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 04:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664278321;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzM4UgG32xbsNP1OM3CxJA0n8fbwgYOZ+v3G/KQ/gb4=;
        b=NROHQTpd1qWlBwufdYHmEkr1awrRzNWYcHtDGYbwEryT1ZeUtf6tdxKU6Dq48z3p/QdzkQ
        i2q0kEkqdJP42UBGtwLZoB9CTJMoyq0m7MUw5RU5Ws9E6oZHMlqh4WU5AuEmZfFU5E67vJ
        8Umrm5o4p+gwXWjguu0rnUgjFLdgi6E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-EmTPAt2-OzClej66ExLb9w-1; Tue, 27 Sep 2022 07:31:58 -0400
X-MC-Unique: EmTPAt2-OzClej66ExLb9w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5D46185A7A9;
        Tue, 27 Sep 2022 11:31:57 +0000 (UTC)
Received: from [10.64.54.143] (vpn2-54-143.bne.redhat.com [10.64.54.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E93F92166B26;
        Tue, 27 Sep 2022 11:31:45 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/6] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-2-gshan@redhat.com> <86y1u56rku.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <a75f7896-320c-4d15-f14d-dc900c8e27b2@redhat.com>
Date:   Tue, 27 Sep 2022 21:31:43 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <86y1u56rku.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/27/22 8:26 PM, Marc Zyngier wrote:
> On Mon, 26 Sep 2022 20:54:34 -0400,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> This adds KVM_REQ_RING_SOFT_FULL, which is raised when the dirty
>> ring of the specific VCPU becomes softly full in kvm_dirty_ring_push().
>> The VCPU is enforced to exit when the request is raised and its
>> dirty ring is softly full on its entrance.
>>
>> The event is checked and handled in the newly introduced helper
>> kvm_dirty_ring_check_request(). With this, kvm_dirty_ring_soft_full()
>> becomes a private function.
>>
>> Suggested-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c             | 15 ++++++---------
>>   include/linux/kvm_dirty_ring.h | 13 +++++++------
>>   include/linux/kvm_host.h       |  1 +
>>   virt/kvm/dirty_ring.c          | 19 ++++++++++++++++++-
>>   4 files changed, 32 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b0c47b41c264..0dd0d32073e7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10260,16 +10260,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>   
>>   	bool req_immediate_exit = false;
>>   
>> -	/* Forbid vmenter if vcpu dirty ring is soft-full */
>> -	if (unlikely(vcpu->kvm->dirty_ring_size &&
>> -		     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
>> -		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
>> -		trace_kvm_dirty_ring_exit(vcpu);
>> -		r = 0;
>> -		goto out;
>> -	}
>> -
>>   	if (kvm_request_pending(vcpu)) {
>> +		/* Forbid vmenter if vcpu dirty ring is soft-full */
>> +		if (kvm_dirty_ring_check_request(vcpu)) {
>> +			r = 0;
>> +			goto out;
>> +		}
>> +
>>   		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
>>   			r = -EIO;
>>   			goto out;
>> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
>> index 906f899813dc..b188bfcf3a09 100644
>> --- a/include/linux/kvm_dirty_ring.h
>> +++ b/include/linux/kvm_dirty_ring.h
>> @@ -54,6 +54,11 @@ static inline void kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
>>   {
>>   }
>>   
>> +static inline bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +
> 
> nit: I don't think this is needed at all. The dirty ring feature is
> not user-selectable, and this is always called from arch code that is
> fully aware of that option.
> 
> This can be fixed when applying the patch though, no need to resend
> for this.
> 

I had the assumption that the corresponding kernel config options are
dropped from arch/x86/kvm/Kconfig or arch/arm64/kvm/Kconfig by developers.
I think it's fine to drop it because the developers need to add the
stub in this particular and rare case.

Please help to drop it if you're going to queue the series. I will drop
it if another respin is needed.

Thanks,
Gavin

