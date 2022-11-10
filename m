Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7297624E94
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 00:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiKJXsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 18:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKJXsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 18:48:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758085EF84
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 15:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668124076;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l/S99FK4xwZYulOn9XcTDfve9yrQ0bx8bO5yJsTeUs4=;
        b=FT1rHjyYPAVIGkJUbs555/aA+snqL1WzesUWBV1ktZr4ZFEED6UnsenFT+0zMaK3hRWB/S
        t84riqlzfNXlU7J6TJn1LJVrVfwCZhbOmO4FxfkO1z19Kw93MqNZWjS1s4BeUyFtpHcon4
        +iTAgSy9IzqiwGATr70SuDc//bNKHBU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-nspV85alPy-_54xzV4j23w-1; Thu, 10 Nov 2022 18:47:52 -0500
X-MC-Unique: nspV85alPy-_54xzV4j23w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79E02382C969;
        Thu, 10 Nov 2022 23:47:51 +0000 (UTC)
Received: from [10.64.54.49] (vpn2-54-49.bne.redhat.com [10.64.54.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C97FA40C83DD;
        Thu, 10 Nov 2022 23:47:44 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with
 bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org,
        catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com> <Y20q3lq5oc2gAqr+@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
Date:   Fri, 11 Nov 2022 07:47:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y20q3lq5oc2gAqr+@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 11/11/22 12:46 AM, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Gavin Shan wrote:
>> @@ -3305,7 +3305,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>   	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>>   
>>   #ifdef CONFIG_HAVE_KVM_DIRTY_RING
>> -	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>> +	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>> +		return;
>> +
>> +	if (WARN_ON_ONCE(!kvm_arch_allow_write_without_running_vcpu(kvm) && !vcpu))
> 
> Nit, the !vcpu check should come first.  99.9% of the time @vcpu will be non-NULL,
> in which case the call to kvm_arch_allow_write_without_running_vcpu() can be
> avoided.  And checking for !vcpu should also be cheaper than said call.
> 
> Since the below code is gaining a check on "vcpu" when using the dirty ring, and
> needs to gain a check on memslot->dirty_bitmap, I think it makes sense to let KVM
> continue on instead of bailing.  I.e. fill the dirty bitmap if possible instead
> of dropping the dirty info and potentiall corrupting guest memory.
> 
> The "vcpu->kvm != kvm" check is different; if that fails, KVM would potentially
> log the dirty page into the wrong VM's context, which could be fatal to one or
> both VMs.
> 
> If it's not too late to rewrite history, this could even be done as a prep patch,
> e.g. with a changelog explaning that KVM should try to log to the dirty bitmap
> even if KVM has a bug where a write to guest memory was triggered without a running
> vCPU.
> 

The series has been merged to Marc's 'next' branch. I will post another
patch on the top to cover your comments since it's an additional improvement.

About these two checks kvm_arch_allow_write_without_running_vcpu() and !vcpu,
the first one is literally the precondition to the later one. It was my
thought. However, you're right that we have vcpu context for 99.9% time.
So it sounds good to me to swap their positions, to check !vcpu first.

Assume we run into !kvm_arch_allow_write_without_running_vcpu() and !vcpu,
it's a unknown (new) case where no running vcpu exists. Note the only known
case is vgic/its at present. The userspace is going to enable the backup bitmap
for the new reported case. Right, it'd better to keep it going instead of
bailing early. In this way, we don't have backwards compatible issue at
least, meaning new application and old kernel are still working.
'memslot->dirty_bitmap' needs to be checked if we don't bail early.

> ---
>   virt/kvm/kvm_main.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 43bbe4fde078..b1115bbd6038 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3313,18 +3313,20 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>   	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>   
>   #ifdef CONFIG_HAVE_KVM_DIRTY_RING
> -	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> +	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>   		return;
> +
> +	WARN_ON_ONCE(!vcpu);
>   #endif
>   
>   	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>   		unsigned long rel_gfn = gfn - memslot->base_gfn;
>   		u32 slot = (memslot->as_id << 16) | memslot->id;
>   
> -		if (kvm->dirty_ring_size)
> +		if (kvm->dirty_ring_size && vcpu)
>   			kvm_dirty_ring_push(&vcpu->dirty_ring,
>   					    slot, rel_gfn);
> -		else
> +		else if (memslot->dirty_bitmap)
>   			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>   	}
>   }
> 
> base-commit: 01b4689ee519329ce5f50ae02692e8acdaba0beb
>> Not checking memslot->dirty_bitmap will allow a malicious userspace to induce a
> NULL pointer dereference, e.g. enable dirty ring without the bitmap and save the
> ITS tables.  The KVM_DEV_ARM_ITS_SAVE_TABLES path in patch 4 doesn't check that
> kvm_use_dirty_bitmap() is true.

> If requiring kvm_use_dirty_bitmap() to do KVM_DEV_ARM_ITS_SAVE_TABLES is deemed
> to prescriptive, the best this code can do is:
>
>		if (kvm->dirty_ring_size && vcpu)
>			kvm_dirty_ring_push(&vcpu->dirty_ring,
>					    slot, rel_gfn);
>		else if (memslot->dirty_bitmap)
>			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>
> If ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES, then this can be:
>
>		if (kvm->dirty_ring_size && vcpu)
>			kvm_dirty_ring_push(&vcpu->dirty_ring,
>					    slot, rel_gfn);
>		else if (!WARN_ON_ONCE(!memslot->dirty_bitmap))
>			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>

The first hunk of changes looks good to me as the back bitmap is required to
save vgic/its tables. For unknown (new) case where we don't have running vcpu,
we have WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm)) to
catch it.

---

commit b05377ecbe003f12c8b79846fa3a300401dcab68 (HEAD -> kvm/arm64_dirtyring)
Author: Gavin Shan <gshan@redhat.com>
Date:   Fri Nov 11 07:13:12 2022 +0800

     KVM: Push dirty information unconditionally to backup bitmap
     
     In mark_page_dirty_in_slot(), we bail out when no running vcpu exists and
     a running vcpu context is strictly required by architecture. It may cause
     backwards compatible issue. Currently, saving vgic/its tables is the only
     case where no running vcpu context is required. We may have other unknown
     cases where no running vcpu context exists and it's reported by the warning
     message. For this, the application is going to enable the backup bitmap for
     the unknown cases. However, the dirty information can't be pushed to the
     backup bitmap even though the backup bitmap has been enabled, until the
     unknown cases are added to the allowed list of non-running vcpu context
     with extra code changes to the host kernel.
     
     In order to make the new application, where the backup bitmap has been
     enabled, to work with the unchanged host, we continue to push the dirty
     information to the backup bitmap instead of bailing out early.
     
     Suggested-by: Sean Christopherson <seanjc@google.com>
     Signed-off-by: Gavin Shan <gshan@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2719e10dd37d..03e6a38094c1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3308,8 +3308,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
         if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
                 return;
  
-       if (WARN_ON_ONCE(!kvm_arch_allow_write_without_running_vcpu(kvm) && !vcpu))
-               return;
+       WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm));
  #endif
  
         if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
@@ -3318,7 +3317,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
  
                 if (kvm->dirty_ring_size && vcpu)
                         kvm_dirty_ring_push(vcpu, slot, rel_gfn);
-               else
+               else if (memslot->dirty_bitmap)
                         set_bit_le(rel_gfn, memslot->dirty_bitmap);
         }
  }


Thanks,
Gavin



