Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920436082E2
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 02:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiJVAeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 20:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJVAeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 20:34:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C722B4EA5
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 17:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666398841;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dRmE3usPLT/+DOeenrYAe2e61ZJThI4ZaW7NJa+NZ5M=;
        b=ESJ29D1WBXFvWzAOKNh/WIWauXc+utQt8KGFvQnEYC/e3sAX5qaUlnGu7KJBSzEu9UlNPm
        PFTZolhT7GOMpO27lqpwvRiLNcyS+v7dUm9sMg6Yqohgh+Jj9jl3riz9QMXcS1BfzqZtcb
        8GvAyofLygOCuHDoD6nn/acagH9GI8E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-ynjnnVcCPyGTIn5YF8mIzw-1; Fri, 21 Oct 2022 20:33:57 -0400
X-MC-Unique: ynjnnVcCPyGTIn5YF8mIzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D1878027F5;
        Sat, 22 Oct 2022 00:33:56 +0000 (UTC)
Received: from [10.64.54.99] (vpn2-54-99.bne.redhat.com [10.64.54.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D4CF2166B2C;
        Sat, 22 Oct 2022 00:33:44 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, peterx@redhat.com, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, shan.gavin@gmail.com
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com> <Y1Hdc/UVta3A5kHM@google.com>
 <0adc538b-594e-c662-5a38-3ca6b98ab059@redhat.com>
 <Y1MpQTprxk+XdYFb@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <2ce535e9-f57a-0ab6-5c30-2b8afd4472e6@redhat.com>
Date:   Sat, 22 Oct 2022 08:33:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y1MpQTprxk+XdYFb@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 10/22/22 7:20 AM, Sean Christopherson wrote:
> On Fri, Oct 21, 2022, Gavin Shan wrote:
>>> What about inverting the naming to better capture that this is about the dirty
>>> bitmap, and less so about the dirty ring?  It's not obvious what "exclusive"
>>> means, e.g. I saw this stub before reading the changelog and assumed it was
>>> making a dirty ring exclusive to something.
>>>
>>> Something like this?
>>>
>>> bool kvm_use_dirty_bitmap(struct kvm *kvm)
>>> {
>>> 	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
>>> }
>>>
>>
>> If you agree, I would rename is to kvm_dirty_ring_use_bitmap(). In this way,
>> we will have "kvm_dirty_ring" prefix for the function name, consistent with
>> other functions from same module.
> 
> I'd prefer to avoid "ring" in the name at all, because in the common case (well,
> legacy case at least) the dirty ring has nothing to do with using the dirty
> bitmap, e.g. this code ends up being very confusing because the "dirty_ring"
> part implies that KVM _doesn't_ need to allocate the bitmap when the dirty ring
> isn't being used.
> 
> 		if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
> 			new->dirty_bitmap = NULL;
> 		else if (old && old->dirty_bitmap)
> 			new->dirty_bitmap = old->dirty_bitmap;
> 		else if (kvm_dirty_ring_use_bitmap(kvm) {
> 			r = kvm_alloc_dirty_bitmap(new);
> 			if (r)
> 				return r;
> 
> 			if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> 				bitmap_set(new->dirty_bitmap, 0, new->npages);
> 		}
> 
> The helper exists because the dirty ring exists, but the helper is fundamentally
> about the dirty bitmap, not the ring.
> 

Thanks for the details. Yeah, it makes sense to avoid "ring" then. Lets use
the name kvm_use_dirty_bitmap() for the function.

>>> But dirty_ring_with_bitmap really shouldn't need to exist.  It's mandatory for
>>> architectures that have HAVE_KVM_DIRTY_RING_WITH_BITMAP, and unsupported for
>>> architectures that don't.  In other words, the API for enabling the dirty ring
>>> is a bit ugly.
>>>
>>> Rather than add KVM_CAP_DIRTY_LOG_RING_ACQ_REL, which hasn't been officially
>>> released yet, and then KVM_CAP_DIRTY_LOG_ING_WITH_BITMAP on top, what about
>>> usurping bits 63:32 of cap->args[0] for flags?  E.g.
>>>
>>> Ideally we'd use cap->flags directly, but we screwed up with KVM_CAP_DIRTY_LOG_RING
>>> and didn't require flags to be zero :-(
>>>
>>> Actually, what's the point of allowing KVM_CAP_DIRTY_LOG_RING_ACQ_REL to be
>>> enabled?  I get why KVM would enumerate this info, i.e. allowing checking, but I
>>> don't seen any value in supporting a second method for enabling the dirty ring.
>>>
>>> The acquire-release thing is irrelevant for x86, and no other architecture
>>> supports the dirty ring until this series, i.e. there's no need for KVM to detect
>>> that userspace has been updated to gain acquire-release semantics, because the
>>> fact that userspace is enabling the dirty ring on arm64 means userspace has been
>>> updated.
>>>
>>> Same goes for the "with bitmap" capability.  There are no existing arm64 users,
>>> so there's no risk of breaking existing userspace by suddenly shoving stuff into
>>> the dirty bitmap.
>>>
>>> KVM doesn't even get the enabling checks right, e.g. KVM_CAP_DIRTY_LOG_RING can be
>>> enabled on architectures that select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL but not
>>> KVM_CAP_DIRTY_LOG_RING.  The reverse is true (ignoring that x86 selects both and
>>> is the only arch that selects the TSO variant).
>>>
>>> Ditto for KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP...
>>
>> If I didn't miss anything in the previous discussions, we don't want to make
>> KVM_CAP_DIRTY_LOG_RING_ACQ_REL and KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
>> architecture dependent. If they become architecture dependent, the userspace
>> will have different stubs (x86, arm64, other architectures to support
>> dirty-ring in future) to enable those capabilities. It's not friendly to
>> userspace. So I intend to prefer the existing pattern: advertise, enable. To
>> enable a capability without knowing if it's supported sounds a bit weird to
>> me.
> 
> Enabling without KVM advertising that it's supported would indeed be odd.  Ugh,
> and QEMU doesn't have existing checks to restrict the dirty ring to x86, i.e. we
> can't make the ACQ_REL capability a true attribute without breaking userspace.
> 
> Rats.
> 

Currently, QEMU doesn't use ACQ_REL and WITH_BITMAP. After both capability are
supported by kvm, we need go ahead to change QEMU so that these two capabilities
can be enabled in QEMU.

>> I think it's a good idea to enable KVM_CAP_DIRTY_LOG_RING_{ACQ_REL, WITH_BITMAP} as
>> flags, instead of standalone capabilities. In this way, those two capabilities can
>> be treated as sub-capability of KVM_CAP_DIRTY_LOG_RING. The question is how these
>> two flags can be exposed by kvm_vm_ioctl_check_extension_generic(), if we really
>> want to expose those two flags.
>>
>> I don't understand your question on how KVM has wrong checks when KVM_CAP_DIRTY_LOG_RING
>> and KVM_CAP_DIRTY_LOG_RING_ACQ_REL are enabled.
> 
> In the current code base, KVM only checks that _a_ form of dirty ring is supported,
> by way of kvm_vm_ioctl_enable_dirty_log_ring()'s check on KVM_DIRTY_LOG_PAGE_OFFSET.
> 
> The callers don't verify that the "correct" capability is enabled.
> 
> 	case KVM_CAP_DIRTY_LOG_RING:
> 	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
> 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> 
> E.g. userspace could do
> 
> 	if (kvm_check(KVM_CAP_DIRTY_LOG_RING_ACQ_REL))
> 		kvm_enable(KVM_CAP_DIRTY_LOG_RING)
> 
> and KVM would happily enable the dirty ring.  Functionally it doesn't cause
> problems, it's just weird.
> 
> Heh, we can fix without more ifdeffery by using the check internally.
> 

Hmm, nice catch! Lets fix it up in a separate patch.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e30f1b4ecfa5..300489a0eba5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4585,6 +4585,8 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>          }
>          case KVM_CAP_DIRTY_LOG_RING:
>          case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
> +               if (!kvm_vm_ioctl_check_extension_generic(kvm, cap->cap))
> +                       return -EINVAL;
>                  return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
>          default:
>                  return kvm_vm_ioctl_enable_cap(kvm, cap);
> 

Thanks,
Gavin

