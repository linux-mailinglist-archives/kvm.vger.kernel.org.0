Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910BC154C94
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 21:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgBFUCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 15:02:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27868 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727791AbgBFUCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 15:02:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581019327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/yqizwNchM67CZ4udbXR6GdfQrlh05oiSzFTK/80D3I=;
        b=hBgEOeypVUq/Bk2/Mv0ebgPHdEH3aAt0k107JNazcsLPVG9J1D3PV/i+25ZFnhJxJO05js
        hdFJxlXUuCQ6NRRREzORuw6u9AAM2OlkpJd4UxQfk01ohUjkL61misp0lN4y7H9B0X6/HK
        PlGhGIOkvYMGNsnmW4+vePI6cz1WO4U=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-FcpskbkKN9K57xg_5UPCew-1; Thu, 06 Feb 2020 15:02:05 -0500
X-MC-Unique: FcpskbkKN9K57xg_5UPCew-1
Received: by mail-qv1-f69.google.com with SMTP id z9so4390472qvo.10
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 12:02:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/yqizwNchM67CZ4udbXR6GdfQrlh05oiSzFTK/80D3I=;
        b=YkGiAP/wgVTxh6GZLZVwZ5eiG2x6AI0Srt38VjDEoa6ptQBL1iPTwYuRSgcGrdZg6Q
         Ph/itm+r6H9NBIaP+ynd105dsCzpCirp+5CoRHjMwEH9NVU0OLJ1MZOpQfWcx30pDJJa
         Ods05o3OqLY180iDg01jAter6NrPY1Q/KzbiZNCQi+Y1Piy6+5iiSNiCajDEZItrXDbc
         HSc+oHqvHEioKi9XAo6h6D6DHGtzOPWqZahJyknah1PZYLsVHdDb7XjXil5EaIJgtift
         VkzhvJh9k69jn27sLo0w+0dB+DIjLwhck2zXZuu4GbwylQTIdsx4M0fNlluBuLtL1082
         uYfg==
X-Gm-Message-State: APjAAAWhI8TGPtXpFN3O/EuLKxKY1OaVvZd3uNQu1y24xFiYOjQ/yFJq
        Z2rHNQhjIONs3/qGpF3rvqD8yx0DWnKwzfmTEJMn87Oi/6PyUZq5ZcImE4we2RvrnRhzq3Z5h9D
        SkafRz/56RCCL
X-Received: by 2002:ac8:19b6:: with SMTP id u51mr4287207qtj.319.1581019324646;
        Thu, 06 Feb 2020 12:02:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqzOujc3lNLMWX/FRlR8tea+183dvvLwpGv6w6oIURj933aU7qyXuyTi9CIJeDyrMsTLUQvKYA==
X-Received: by 2002:ac8:19b6:: with SMTP id u51mr4287163qtj.319.1581019324320;
        Thu, 06 Feb 2020 12:02:04 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id k50sm163595qtc.90.2020.02.06.12.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 12:02:03 -0800 (PST)
Date:   Thu, 6 Feb 2020 15:02:00 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200206200200.GC700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-16-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:53PM -0800, Sean Christopherson wrote:

[...]

> -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
> +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
> +				  struct kvm_memory_slot *memslot)

If it's to flush TLB for a memslot, shall we remove the "dirty_log" in
the name of the function, because it has nothing to do with dirty
logging any more?  And...

>  {
> -	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *memslot;
> -	bool flush = false;
> -	int r;
> -
> -	mutex_lock(&kvm->slots_lock);
> -
> -	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
> -
> -	if (flush) {
> -		slots = kvm_memslots(kvm);
> -		memslot = id_to_memslot(slots, log->slot);
> -
> -		/* Let implementation handle TLB/GVA invalidation */
> -		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> -	}
> -
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
> +	/* Let implementation handle TLB/GVA invalidation */
> +	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);

... This may not directly related to the current patch, but I'm
confused on why MIPS cannot use kvm_flush_remote_tlbs() to flush TLBs.
I know nothing about MIPS code, but IIUC here flush_shadow_memslot()
is a heavier operation that will also invalidate the shadow pages.
Seems to be an overkill here when we only changed write permission of
the PTEs?  I tried to check the first occurance (2a31b9db15353) but I
didn't find out any clue of it so far.

But that matters to this patch because if MIPS can use
kvm_flush_remote_tlbs(), then we probably don't need this
arch-specific hook any more and we can directly call
kvm_flush_remote_tlbs() after sync dirty log when flush==true.

>  }
>  
>  long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 97ce6c4f7b48..0adaf4791a6d 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -799,6 +799,11 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
>  	return vcpu->kvm->arch.kvm_ops->check_requests(vcpu);
>  }
>  
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)

Since at it, maybe we can start to use __weak attribute for new hooks
especially when it's empty for most archs?

E.g., define:

void __weak kvm_arch_sync_dirty_log(...) {}

In the common code, then only define it again in arch that has
non-empty implementation of this method?

-- 
Peter Xu

