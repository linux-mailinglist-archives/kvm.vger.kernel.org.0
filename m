Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B6B4DAC7C
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 09:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350092AbiCPIdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 04:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354229AbiCPIdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 04:33:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA91063BCC
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 01:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647419551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jjZm70XMrj/Rp5s34/zzGgqrERGbjp7SPfa5KT7Pao4=;
        b=bCKQxZ0wfO30YzWp9lUmxjYd2fVkbrB+zw4Viveux91MjauvQAqtI/wHwR0sDXMdNxG7Y5
        wC6d5qBYzFjMjgXhML7xt7xRVOve5iAnwlcl0sFtGNhsOuYAm3yN/ignwVEmR1q9loC6/C
        tD4h9HxWExZ33WuXGwAQ3KXYGmaqG0M=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-pizImFNsOYWzDkyxeUKqYw-1; Wed, 16 Mar 2022 04:32:27 -0400
X-MC-Unique: pizImFNsOYWzDkyxeUKqYw-1
Received: by mail-pf1-f197.google.com with SMTP id g189-20020a6252c6000000b004f6f5bbaf7cso1402110pfb.16
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 01:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jjZm70XMrj/Rp5s34/zzGgqrERGbjp7SPfa5KT7Pao4=;
        b=EltZTxXhH1riISvnsGRcOu5iSJNvBW1MNzBAkoNgkSQEm++DI720D7aF0HWc6lF/nI
         d6VJqAznMd/Ennf8r2cndM34qX9FiCIwcxZZgq566nj/VjZdDNHKelNWNZEBlQYb8DwG
         kkcNtcoHV1w69pIxr8jepiz3YSajlq8uA7ADeDNPcVLlOLnsk6e2L0jkxWjYYtQAUko2
         01Ewk0egeNRTo9wbtdL7QL03+cxuIhnWfELUwBeQ+KJ07UPcLCSpB1nNYQAoNTvqeMbK
         wWr8mwkCHVLlc1ugccNmakiTS0TCbWsXZDkIp+xz7QIdKsk753g2/unwWXyqITT4Gly3
         QyRQ==
X-Gm-Message-State: AOAM531M+cPDGgq9FupuTEjWNK8bYDpbplnd2nWutVShaM18/1VLBbuB
        bMMmGJbCPYUPkEC/eMNKAX3m2dkBbLahhFxILEAVJ0bU64s4By1666m+xqPDOpIOrozu6zkOt6k
        BUI+CHDh3+Z5W
X-Received: by 2002:a63:4e14:0:b0:374:4a37:4966 with SMTP id c20-20020a634e14000000b003744a374966mr26992335pgb.118.1647419542790;
        Wed, 16 Mar 2022 01:32:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNPcz5i9opLI37VCXelA4fPh3aZshlOtJoDylYilxYNapzjAAQzajYYuBDJJrlk3n3Pyh3Pw==
X-Received: by 2002:a63:4e14:0:b0:374:4a37:4966 with SMTP id c20-20020a634e14000000b003744a374966mr26992316pgb.118.1647419542495;
        Wed, 16 Mar 2022 01:32:22 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.128])
        by smtp.gmail.com with ESMTPSA id a5-20020a621a05000000b004f79f8f795fsm2072222pfa.0.2022.03.16.01.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 01:32:22 -0700 (PDT)
Date:   Wed, 16 Mar 2022 16:32:13 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v2 16/26] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <YjGgjTnP/9sG8L+2@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-17-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-17-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:18AM +0000, David Matlack wrote:
> In order to split a huge page we need to know what access bits to assign
> to the role of the new child page table. This can't be easily derived
> from the huge page SPTE itself since KVM applies its own access policies
> on top, such as for HugePage NX.
> 
> We could walk the guest page tables to determine the correct access
> bits, but that is difficult to plumb outside of a vCPU fault context.
> Instead, we can store the original access bits for each leaf SPTE
> alongside the GFN in the gfns array. The access bits only take up 3
> bits, which leaves 61 bits left over for gfns, which is more than
> enough. So this change does not require any additional memory.

I have a pure question on why eager page split needs to worry on hugepage
nx..

IIUC that was about forbidden huge page being mapped as executable.  So
afaiu the only missing bit that could happen if we copy over the huge page
ptes is the executable bit.

But then?  I think we could get a page fault on fault->exec==true on the
split small page (because when we copy over it's cleared, even though the
page can actually be executable), but it should be well resolved right
after that small page fault.

The thing is IIUC this is a very rare case, IOW, it should mostly not
happen in 99% of the use case?  And there's a slight penalty when it
happens, but only perf-wise.

As I'm not really fluent with the code base, perhaps I missed something?

> 
> In order to keep the access bit cache in sync with the guest, we have to
> extend FNAME(sync_page) to also update the access bits.

Besides sync_page(), I also see that in mmu_set_spte() there's a path that
we will skip the rmap_add() if existed:

	if (!was_rmapped) {
		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
		kvm_update_page_stats(vcpu->kvm, level, 1);
		rmap_add(vcpu, slot, sptep, gfn);
	}

I didn't check, but it's not obvious whether the sync_page() change here
will cover all of the cases, hence raise this up too.

> 
> Now that the gfns array caches more information than just GFNs, rename
> it to shadowed_translation.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 32 +++++++++++++++++++-------------
>  arch/x86/kvm/mmu/mmu_internal.h | 15 +++++++++++++--
>  arch/x86/kvm/mmu/paging_tmpl.h  |  7 +++++--
>  4 files changed, 38 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f72e80178ffc..0f5a36772bdc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -694,7 +694,7 @@ struct kvm_vcpu_arch {
>  
>  	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> -	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
> +	struct kvm_mmu_memory_cache mmu_shadowed_translation_cache;

I'd called it with a shorter name.. :) maybe mmu_shadowed_info_cache?  No
strong opinion.

>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
>  
>  	/*

[...]

> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index b6e22ba9c654..c5b8ee625df7 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -32,6 +32,11 @@ extern bool dbg;
>  
>  typedef u64 __rcu *tdp_ptep_t;
>  
> +struct shadowed_translation_entry {
> +	u64 access:3;
> +	u64 gfn:56;

Why 56?

> +};

Thanks,

-- 
Peter Xu

