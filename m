Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A532DAAFA
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgLOKeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 05:34:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727807AbgLOKdz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Dec 2020 05:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608028348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ckovXueqNToJoyauJ6BBxrCZAffZux6jQj9uhlKTS6U=;
        b=aPturgJJF0qWXFDKuctSLE12AyqDzSDhEajmfCt5FStCz8eL+sY47GUmBVmUZMg37DUK5i
        LuTuzuf2dlkYJLgOIrkL4OodZamRmz6Of7R9SS5v5s6jv389h1DwMJGDTKDIhneAdCeS55
        EHhEBY7Gxi00wndtPBMecpBWTLAhoVM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-7Ng8gODrP-i0Dcgjg8JuAw-1; Tue, 15 Dec 2020 05:32:26 -0500
X-MC-Unique: 7Ng8gODrP-i0Dcgjg8JuAw-1
Received: by mail-ed1-f69.google.com with SMTP id i15so9776480edx.9
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 02:32:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ckovXueqNToJoyauJ6BBxrCZAffZux6jQj9uhlKTS6U=;
        b=DYVWPyJDUoqMNK6cs0XTlG1939rCcauJKbsmD6jCGDNOr/gngZq1rZVjJ4+ox11eTY
         UE2osndyoyvAf2bnoGJmg9OoOdeQN9gJ8SVvTj+dpSIiFQuruRsclRWU+OLhZeNZ1ICb
         IIvVI7TtZPjkxWbiqTIooi1KgWS/9qY4sFwCfxe4EsU4sXq/YXpatu4+PTMAinWiHAYE
         PVWorK/hwPhbt1d99pjfif7+umTihe4rxlQZWVhkTN3LChZoP/vxgeLc/n/jOYNMBRx2
         Xh6mprxUJ3IOQ+qlh2RRr6z9oXN0AX/QQ4ol+I4678dFOL2BMTBzcRL4++AhCDBeThdx
         a/tw==
X-Gm-Message-State: AOAM532IZwMdptZjDIsEPc82te/kUlBflwrjCvc/uFXY2KpE6ylPwnIG
        ha+Ko19Mi7KNAaroakmnVkZzAgus3NvIaJ8Sofep6aQsHdXfx/Eu10xknpxeuMWPGVR37OoGbRu
        aHfIP/OtGLGsG
X-Received: by 2002:a17:907:20f1:: with SMTP id rh17mr25919263ejb.147.1608028344789;
        Tue, 15 Dec 2020 02:32:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyln15V4fjgJWljXqjU9fYmJSjQNmNN8qCXounds/yTQF5md7b/wLva1eXixiztbKeWanW0Bg==
X-Received: by 2002:a17:907:20f1:: with SMTP id rh17mr25919249ejb.147.1608028344617;
        Tue, 15 Dec 2020 02:32:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g18sm17603258edt.2.2020.12.15.02.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 02:32:23 -0800 (PST)
Subject: Re: [PATCH] kvm: don't lose the higher 32 bits of tlbs_dirty
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>
References: <20201213044913.15137-1-jiangshanlai@gmail.com>
 <X9ee7RzW+Dhv1aoW@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea0938d2-f766-99de-2019-9daf5798ccac@redhat.com>
Date:   Tue, 15 Dec 2020 11:32:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X9ee7RzW+Dhv1aoW@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/20 18:20, Sean Christopherson wrote:
> On Sun, Dec 13, 2020, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
>> 	need_tlb_flush |= kvm->tlbs_dirty;
>> with need_tlb_flush's type being int and tlbs_dirty's type being long.
>>
>> It means that tlbs_dirty is always used as int and the higher 32 bits
>> is useless.
> 
> It's probably worth noting in the changelog that it's _extremely_ unlikely this
> bug can cause problems in practice.  It would require encountering tlbs_dirty
> on a 4 billion count boundary, and KVM would need to be using shadow paging or
> be running a nested guest.
> 
>> We can just change need_tlb_flush's type to long to
>> make full use of tlbs_dirty.
> 
> Hrm, this does solve the problem, but I'm not a fan of continuing to use an
> integer variable as a boolean.  Rather than propagate tlbs_dirty to
> need_tlb_flush, what if this bug fix patch checks tlbs_dirty directly, and then
> a follow up patch converts need_tlb_flush to a bool and removes the unnecessary
> initialization (see below).

Indeed, the compiler should be able to convert || to | if useful and 
valid (it may or may not do it depending on the sizes of types involved, 
but that's Someone Else's Problem and this is not really a path where 
every instruction matter).

Paolo

> E.g. the net result of both patches would be:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3abcb2ce5b7d..93b6986d3dfc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -473,7 +473,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>                                          const struct mmu_notifier_range *range)
>   {
>          struct kvm *kvm = mmu_notifier_to_kvm(mn);
> -       int need_tlb_flush = 0, idx;
> +       bool need_tlb_flush;
> +       int idx;
> 
>          idx = srcu_read_lock(&kvm->srcu);
>          spin_lock(&kvm->mmu_lock);
> @@ -483,11 +484,10 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>           * count is also read inside the mmu_lock critical section.
>           */
>          kvm->mmu_notifier_count++;
> -       need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
> -                                            range->flags);
> -       need_tlb_flush |= kvm->tlbs_dirty;
> +       need_tlb_flush = !!kvm_unmap_hva_range(kvm, range->start, range->end,
> +                                              range->flags);
>          /* we've to flush the tlb before the pages can be freed */
> -       if (need_tlb_flush)
> +       if (need_tlb_flush || kvm->tlbs_dirty)
>                  kvm_flush_remote_tlbs(kvm);
> 
>          spin_unlock(&kvm->mmu_lock);
> 
> Cc: stable@vger.kernel.org
> Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")
> 
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
>>   virt/kvm/kvm_main.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 2541a17ff1c4..4e519a517e9f 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -470,7 +470,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>>   					const struct mmu_notifier_range *range)
>>   {
>>   	struct kvm *kvm = mmu_notifier_to_kvm(mn);
>> -	int need_tlb_flush = 0, idx;
>> +	long need_tlb_flush = 0;
> 
> need_tlb_flush doesn't need to be initialized here, it's explicitly set via the
> call to kvm_unmap_hva_range().
> 
>> +	int idx;
>>   
>>   	idx = srcu_read_lock(&kvm->srcu);
>>   	spin_lock(&kvm->mmu_lock);
>> -- 
>> 2.19.1.6.gb485710b
>>
> 

