Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3726F5F71F0
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 01:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiJFXih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 19:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiJFXif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 19:38:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BD0B7EC3
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 16:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665099512;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3YZJeFTA/Tj+Wqb3gKBQ3wuXJ9QktL5f9e36mUvVsCQ=;
        b=dwvCEWtY0g75no6FxavXPxbp3LCS4sE+JgeppssLit+iG8jgcaviDabgTst3XFU7QyXtXt
        2NaCxamSbbvfxDz8KkEF6ztIDqMdLc8n+BklMLf9JwKiDLIq5W+f1CdHon4w/6KgVX8j6p
        0WCPSq8SyzqkPF+KVapV2o1HdQ6dmTE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-jvIBj9zXMiaDV3J6q88Osg-1; Thu, 06 Oct 2022 19:38:29 -0400
X-MC-Unique: jvIBj9zXMiaDV3J6q88Osg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6601E3C0F434;
        Thu,  6 Oct 2022 23:38:28 +0000 (UTC)
Received: from [10.64.54.52] (vpn2-54-52.bne.redhat.com [10.64.54.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89A821457F36;
        Thu,  6 Oct 2022 23:38:22 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        seanjc@google.com, shan.gavin@gmail.com
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
Date:   Fri, 7 Oct 2022 07:38:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Yz86gEbNflDpC8As@x1n>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 10/7/22 4:28 AM, Peter Xu wrote:
> On Wed, Oct 05, 2022 at 08:41:50AM +0800, Gavin Shan wrote:
>> -8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
>> -----------------------------------------------------------
>> +8.29 KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL, RING_ALLOW_BITMAP}
>> +--------------------------------------------------------------
> 
> Shall we make it a standalone cap, just to rely on DIRTY_RING[_ACQ_REL]
> being enabled first, instead of making the three caps at the same level?
> 
> E.g. we can skip creating bitmap for DIRTY_RING[_ACQ_REL] && !_ALLOW_BITMAP
> (x86).
> 

Both KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LONG_RING_ACQ_REL are available
to x86. So KVM_CAP_DIRTY_LONG_RING_ACQ_REL can be enabled on x86 in theory.
However, the idea to disallow bitmap for KVM_CAP_DIRTY_LOG_RING (x86) makes
sense to me. I think you may be suggesting something like below.

- bool struct kvm::dirty_ring_allow_bitmap

- In kvm_vm_ioctl_enable_dirty_log_ring(), set 'dirty_ring_allow_bitmap' to
   true when the capability is KVM_CAP_DIRTY_LONG_RING_ACQ_REL

   static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 cap, u32 size)
   {
     :
     mutex_lock(&kvm->lock);

     if (kvm->created_vcpus) {
        /* We don't allow to change this value after vcpu created */
        r = -EINVAL;
     } else {
        kvm->dirty_ring_size = size;
        kvm->dirty_ring_allow_bitmap = (cap == KVM_CAP_DIRTY_LOG_RING_ACQ_REL);
        r = 0;
     }

     mutex_unlock(&kvm->lock);
     return r;
   }
   
- In kvm_vm_ioctl_check_extension_generic(), KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP
   is always flase until KVM_CAP_DIRTY_LOG_RING_ACQ_REL is enabled.

   static long kvm_vm_ioctl_check_extension_generic(...)
   {
     :
     case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
         return kvm->dirty_ring_allow_bitmap ? 1 : 0;
   }

- The suggested dirty_ring_exclusive() is used.

>> @@ -2060,10 +2060,6 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>>   	unsigned long n;
>>   	unsigned long any = 0;
>>   
>> -	/* Dirty ring tracking is exclusive to dirty log tracking */
>> -	if (kvm->dirty_ring_size)
>> -		return -ENXIO;
> 
> Then we can also have one dirty_ring_exclusive(), with something like:
> 
> bool dirty_ring_exclusive(struct kvm *kvm)
> {
>          return kvm->dirty_ring_size && !kvm->dirty_ring_allow_bitmap;
> }
> 
> Does it make sense?  Thanks,
> 

Thanks,
Gavin

