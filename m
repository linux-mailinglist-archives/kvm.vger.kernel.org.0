Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD8143F70
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 15:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgAUOYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 09:24:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37358 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726968AbgAUOYl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 09:24:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579616680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iietA04mTbBj3y8KEP1nE87RzCPxCIolbi4wDz4ohvY=;
        b=h9olVkrBMpXSUk4fbMIGFl8Qtd95ggkE4VUWihSjGq+lnWftqFKwE0qIgIeiIfUrucATX/
        QjK8TmM7O5dElxzsZE9hwy8ccG+cppB0rVmRfheXZzgLPIEMAioO90Vnybu73IyAtTDm7s
        sVrHYgRScfePHvcnsGIaXIriOBbIb24=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-vcab4kLnMZWG9lrl2Hj_yA-1; Tue, 21 Jan 2020 09:24:38 -0500
X-MC-Unique: vcab4kLnMZWG9lrl2Hj_yA-1
Received: by mail-wm1-f71.google.com with SMTP id 18so676840wmp.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 06:24:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iietA04mTbBj3y8KEP1nE87RzCPxCIolbi4wDz4ohvY=;
        b=nibz0S0q1LKWM6e1JyyJLG9QuWtZ8sObODcMqIoRnfLDlyQD101o7IyN7Z0+bnaGYf
         R14ZcTOq/3zNbCFNusS7CxPMpjfn9R43DYacVqY3VjI3HrvFaPcQtC8U9q++fxLl2D/D
         6ucK1aWDtHZrZakW8A4z0XE5QBnKAsmsPK+Irmv8PrymVdhKXnHrEnG8CMNyj6tZjnz6
         ozC3Eb1z5sy1wA3F61gFDwHQeE3hNr2RA9Guxylc9VzAgOT7cpN4LBQ6PDqkCBZwNS2K
         Hadr2V/zdTtb/PHK//LT+ZptndXLoJgzpyMQz779uk7w/wu46Spix9zhXTRpSU10ijj/
         hp0A==
X-Gm-Message-State: APjAAAWMyEnZbxzBzR1aykINYH8w/demEFgvLUJNKB1Y51gdUku9WhKi
        g0+B5b9hADi3T8A4hZ6gTk+pilg8S8SpfDSiwkhZjXANcg+ohScXcRXjsw8PAjsN3N/6TnWuToe
        vOdjdvpzoTF2A
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr5440090wrt.339.1579616673969;
        Tue, 21 Jan 2020 06:24:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqyTZsEeiVXo1aYXs9MoGNtX19umLmm3R/ZbsXqxiGO2rVQCtL37lQcA37U+6PdsUBw/nSKlMg==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr5440056wrt.339.1579616673641;
        Tue, 21 Jan 2020 06:24:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id m3sm51279088wrs.53.2020.01.21.06.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 06:24:33 -0800 (PST)
Subject: Re: [PATCH 04/14] KVM: Play nice with read-only memslots when
 querying host page size
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barret Rhoden <brho@google.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <20200108202448.9669-5-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2c091d40-8e32-1e55-2eff-27a4b43e0674@redhat.com>
Date:   Tue, 21 Jan 2020 15:24:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108202448.9669-5-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 21:24, Sean Christopherson wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5f7f06824c2b..d9aced677ddd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1418,15 +1418,23 @@ EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
>  
>  unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
> +	struct kvm_memory_slot *slot;
>  	struct vm_area_struct *vma;
>  	unsigned long addr, size;
>  
>  	size = PAGE_SIZE;
>  
> -	addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
> -	if (kvm_is_error_hva(addr))
> +	/*
> +	 * Manually do the equivalent of kvm_vcpu_gfn_to_hva() to avoid the
> +	 * "writable" check in __gfn_to_hva_many(), which will always fail on
> +	 * read-only memslots due to gfn_to_hva() assuming writes.
> +	 */
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
>  		return PAGE_SIZE;
>  
> +	addr = __gfn_to_hva_memslot(slot, gfn);
> +
>  	down_read(&current->mm->mmap_sem);
>  	vma = find_vma(current->mm, addr);
>  	if (!vma)
> 

Even simpler: use kvm_vcpu_gfn_to_hva_prot

-	addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
+	addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gfn, NULL);

"You are in a maze of twisty little functions, all alike".

Paolo

