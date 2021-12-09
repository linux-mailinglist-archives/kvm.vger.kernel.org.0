Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237A646F32F
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243373AbhLIShr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhLIShq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:37:46 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2027C061746;
        Thu,  9 Dec 2021 10:34:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z5so22927675edd.3;
        Thu, 09 Dec 2021 10:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VmHNjKHHTgpu8LKf+wLbu6tr5d2B6TY5WNkaxl4rmr8=;
        b=gZq6Dj67kII8EQrFcvQRrysaXkPXfgaFl8h/21JGy/fEUeqdUxugDKnd0CNL1EUdHK
         KJPwK37d4PW840KmytVunGJapbLoZk4G3qw+TbDO8UYWUa2yu8kM7BqASqD3VbTbjPSr
         uYvvS+DgMUmrivsJTJ5U61ojewQPuA8oKfTgJidcMoKvKd75dFwAseVuJPPbufqS40gT
         sn9TuVUT5jgHVAMipF5b2yN0DSs3jGlOqB8UJmtZWNWcU0Bopi2mvXa3ytZ+oA/p2nkv
         P6BXBfcqsPMiZ2N//CV0MDTVNZrb5hlDan1lqFxK+s+uKW5LM3ou1RBnyIftv4h7SWPY
         xNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VmHNjKHHTgpu8LKf+wLbu6tr5d2B6TY5WNkaxl4rmr8=;
        b=FnuPtWS1r8i3j+ZosldJAoEIJERZ2GFoJ0Sfbp8bJBCttRCk+FF7XWFPjT7qsA0R7r
         NM3FdiZi915B5XQg03XMGEG7vFu2QoojAZ1+5G3yrWyqTU4aAsrlXfzAvtLjNFFGPBK7
         SvV1ePRlxlk15y5mOSlD/n2jOzXJG9Kw0kiE8qP92A6MQ0mI7Wwu4xH9GjdMYP+2WQSm
         G291xLlnPn16LLVv9ST/ahHnnkqpaCZOgWiMiBxtvG0+oIR1LB8W0MiTDWzys8GAga2B
         mexVdOVrjCir6Qv2/JMLjtHkvauBXyN7ysyKDDVqTg+sIR39INEl4u0ZCD8SiIFyS87t
         fCaQ==
X-Gm-Message-State: AOAM5304p81JenlD1I+FxaA1eQsQ8a3QX1difPmrmoiEU6fwcfWiem2J
        EWHmpsng2rwFuWlBeBJsKp4=
X-Google-Smtp-Source: ABdhPJzPr2JWAHHRiyW9tf+vJ9HDTL67K/LwoYescyr21dhuVB9iq2UisCXP0bQ++tHwzdvxo9UJXA==
X-Received: by 2002:a17:906:f43:: with SMTP id h3mr17722168ejj.414.1639074851284;
        Thu, 09 Dec 2021 10:34:11 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id yd20sm299781ejb.47.2021.12.09.10.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 10:34:10 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b1bacc6f-be56-4108-6e52-4315a021184b@redhat.com>
Date:   Thu, 9 Dec 2021 19:34:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 08/12] KVM: Reinstate gfn_to_pfn_cache with
 invalidation support
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-9-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211121125451.9489-9-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for the late review...

On 11/21/21 13:54, David Woodhouse wrote:
> +EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
> +
> +static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva,
> +			  gpa_t gpa, bool dirty)
> +{
> +	/* Unmap the old page if it was mapped before, and release it */
> +	if (!is_error_noslot_pfn(pfn)) {
> +		if (khva) {
> +			if (pfn_valid(pfn))
> +				kunmap(pfn_to_page(pfn));
> +#ifdef CONFIG_HAS_IOMEM
> +			else
> +				memunmap(khva);
> +#endif
> +		}

Considering that the khva is passed directly to memunmap, perhaps it's
cleaner to ensure it's page-aligned:

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 13cae72d39e9..267477bd2972 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -147,7 +147,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  
  	old_gpa = gpc->gpa;
  	old_pfn = gpc->pfn;
-	old_khva = gpc->khva;
+	old_khva = (void *)((unsigned long)gpc->khva & ~PAGE_MASK);
  	old_uhva = gpc->uhva;
  	old_valid = gpc->valid;
  	old_dirty = gpc->dirty;
@@ -209,7 +209,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  
  		if (gpc->kernel_map) {
  			if (new_pfn == old_pfn) {
-				new_khva = (void *)((unsigned long)old_khva - page_offset);
+				new_khva = old_khva;
  				old_pfn = KVM_PFN_ERR_FAULT;
  				old_khva = NULL;
  			} else if (pfn_valid(new_pfn)) {
@@ -265,7 +265,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
  
  	gpc->valid = false;
  
-	old_khva = gpc->khva;
+	old_khva = (void *)((unsigned long)gpc->khva & ~PAGE_MASK);
  	old_dirty = gpc->dirty;
  	old_gpa = gpc->gpa;
  	old_pfn = gpc->pfn;


> 
> +	retry_map:
> +		mmu_seq = kvm->mmu_notifier_seq;
> +		smp_rmb();
> +
> +		/* We always request a writeable mapping */
> +		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
> +		if (is_error_noslot_pfn(new_pfn)) {
> +			ret = -EFAULT;
> +			goto map_done;
> +		}
> +
> +		KVM_MMU_READ_LOCK(kvm);
> +		retry = mmu_notifier_retry_hva(kvm, mmu_seq, uhva);
> +		KVM_MMU_READ_UNLOCK(kvm);
> +		if (retry) {
> +			cond_resched();
> +			goto retry_map;
> +		}
> +

This should also be a separate function, like

static kvm_pfn_t hva_to_pfn_retry(unsigned long uhva)
{
         kvm_pfn_t new_pfn
         unsigned long mmu_seq;
         int retry;

retry_map:
         mmu_seq = kvm->mmu_notifier_seq;
         smp_rmb();

         /* We always request a writeable mapping */
         new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
         if (is_error_noslot_pfn(new_pfn))
                 return new_pfn;

         KVM_MMU_READ_LOCK(kvm);
         retry = mmu_notifier_retry_hva(kvm, mmu_seq, uhva);
         KVM_MMU_READ_UNLOCK(kvm);
         if (retry) {
                 cond_resched();
                 goto retry_map;
         }
         return new_pfn;
}

> 
> +		write_lock_irq(&gpc->lock);
> +		if (ret) {
> +			gpc->valid = false;
> +			gpc->pfn = KVM_PFN_ERR_FAULT;
> +			gpc->khva = NULL;
> +		} else {
> +			/* At this point, gpc->valid may already have been cleared */
> +			gpc->pfn = new_pfn;
> +			gpc->khva = new_khva + page_offset;
> +		}

Should set gpc->khva only if new_khva != NULL (i.e. only if gpc->kernel_map
is true).

Paolo
