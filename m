Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02844556EE
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 09:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244558AbhKRI3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 03:29:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244559AbhKRI3O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 03:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637223972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KfYISkdEc2V4yWdoQrmXj3ghyO61a+5LaQtRAknXNrU=;
        b=ZzoqH214lfLZMTfvASAbSucUWOU2WTI48k52rqbEtO8J2olz1ec0nWs94pMFSnY48NWNly
        7eGP0sj+XbU9mY1sQS6PiuvYP8NG58uuzMGLZ7Pg9cLGWuXOTVxr33RXKk2VopUAU6Gxq+
        XvaU4Aos50TeXijPogQCDQolOI3nghc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-iCq5skcUOBOPSUwlQra6zg-1; Thu, 18 Nov 2021 03:26:06 -0500
X-MC-Unique: iCq5skcUOBOPSUwlQra6zg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C935802C99;
        Thu, 18 Nov 2021 08:26:04 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6809D62A44;
        Thu, 18 Nov 2021 08:25:52 +0000 (UTC)
Message-ID: <d85d87d3-8ace-ec64-c6dd-0784063e9fb0@redhat.com>
Date:   Thu, 18 Nov 2021 09:25:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 05/15] KVM: x86/mmu: Remove need for a vcpu from
 kvm_slot_page_track_is_active
Content-Language: en-US
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20211115234603.2908381-1-bgardon@google.com>
 <20211115234603.2908381-6-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211115234603.2908381-6-bgardon@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 00:45, Ben Gardon wrote:
> kvm_slot_page_track_is_active only uses its vCPU argument to get a
> pointer to the assoicated struct kvm, so just pass in the struct KVM to
> remove the need for a vCPU pointer.
> 
> No functional change intended.
> 
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/include/asm/kvm_page_track.h | 2 +-
>   arch/x86/kvm/mmu/mmu.c                | 4 ++--
>   arch/x86/kvm/mmu/page_track.c         | 4 ++--
>   3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 9d4a3b1b25b9..e99a30a4d38b 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -63,7 +63,7 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
>   void kvm_slot_page_track_remove_page(struct kvm *kvm,
>   				     struct kvm_memory_slot *slot, gfn_t gfn,
>   				     enum kvm_page_track_mode mode);
> -bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
> +bool kvm_slot_page_track_is_active(struct kvm *kvm,
>   				   struct kvm_memory_slot *slot, gfn_t gfn,
>   				   enum kvm_page_track_mode mode);
>   
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2ada6dee920a..7d0da79668c0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2587,7 +2587,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>   	 * track machinery is used to write-protect upper-level shadow pages,
>   	 * i.e. this guards the role.level == 4K assertion below!
>   	 */
> -	if (kvm_slot_page_track_is_active(vcpu, slot, gfn, KVM_PAGE_TRACK_WRITE))
> +	if (kvm_slot_page_track_is_active(vcpu->kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
>   		return -EPERM;
>   
>   	/*
> @@ -3884,7 +3884,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
>   	 * guest is writing the page which is write tracked which can
>   	 * not be fixed by page fault handler.
>   	 */
> -	if (kvm_slot_page_track_is_active(vcpu, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
> +	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
>   		return true;
>   
>   	return false;
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index cc4eb5b7fb76..35c221d5f6ce 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -173,7 +173,7 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
>   /*
>    * check if the corresponding access on the specified guest page is tracked.
>    */
> -bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
> +bool kvm_slot_page_track_is_active(struct kvm *kvm,
>   				   struct kvm_memory_slot *slot, gfn_t gfn,
>   				   enum kvm_page_track_mode mode)
>   {
> @@ -186,7 +186,7 @@ bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
>   		return false;
>   
>   	if (mode == KVM_PAGE_TRACK_WRITE &&
> -	    !kvm_page_track_write_tracking_enabled(vcpu->kvm))
> +	    !kvm_page_track_write_tracking_enabled(kvm))
>   		return false;
>   
>   	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
> 

Queued, thanks.

Paolo

