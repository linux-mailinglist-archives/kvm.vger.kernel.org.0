Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E27B528E61
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 21:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345970AbiEPTnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 15:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346061AbiEPTmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 15:42:49 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9742F3F329
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 12:41:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so283021pjq.2
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 12:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NkuNZUIBL8MZdXmO1J6bie/4FoMF9dlGbvJ/EnJshUg=;
        b=YSYkkeSYlazR/KnZ9A3FW/RivmtBBtfwOD590Y2/k8rYpyPkbUuOO+rwGs2/8RHYhV
         jvz06DdSkgy4vQhhjr/YXryV5B9qyTetWcD0yxlDdQKdQD6xsBfjHe6w35CK+ecaogDy
         t8NbscOxGVlR++e0P74FmdEVrpyZPXXKOWEko8abAtjkWwU5ME5mPT5c/rvp4azYvIga
         QBkUI8VqyqQ0723yj0rYnoB9KlDwuBoqWUzd7kALSg45s1LqvYiDqdwAVytXc3sTyQFy
         LYY/6iAlFXwrmbY1qhWCKl4EbDHptbmMarKlWiRWblBkCUhKixRRpXbfjJ636mxb9x8G
         tgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NkuNZUIBL8MZdXmO1J6bie/4FoMF9dlGbvJ/EnJshUg=;
        b=wlqzbA/DldOsP3u504inncsZ9585gzwIlf10upkZq1lFhQktt1ggiM9r9XdZSc7MFL
         1ICrpXJbFJ1RzBTji1268UKG8Q77m+KsrZufxmLTX+FctBmFiIhvf0OFXihQvNXvkpzQ
         qmF61T8KoR2EB8l8HHQShsp/maPbGHTBY4KiN59nU2bhHRT46H5ha68ODET2t+DsQOt6
         Np2th1U3srNCgkmzuZQMdCwQs/1UErr3rFNZw0pf7A0vH3BwVBS+DTpGRWqSediyheRj
         cl82z23yN62p93QfYdKNy7zwHPCFlTPEtZCoxYLb4chHtICuZ2uLG+/Z8nHQ5Rf8QWtt
         An6Q==
X-Gm-Message-State: AOAM533yV54E0ToOtovFeYEQ5XmU6rDJuv1v3zwzoJBYLpo63kAGK6DK
        0ivOTIZipdpDtkjxolgTUODm++69uJjQPg==
X-Google-Smtp-Source: ABdhPJzhqjOIS7ooa6ljXBdDLvsM/Pulyqi/qmAlcWfUFcQwQ8Rv2LI1aAxACX8ZVtfXOR3acBcAow==
X-Received: by 2002:a17:90b:33c6:b0:1dc:ba92:41bb with SMTP id lk6-20020a17090b33c600b001dcba9241bbmr20912338pjb.26.1652730071981;
        Mon, 16 May 2022 12:41:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e13-20020a170902ed8d00b0015e8d4eb1fcsm7467421plj.70.2022.05.16.12.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 12:41:11 -0700 (PDT)
Date:   Mon, 16 May 2022 19:41:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/34] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Message-ID: <YoKo1An5t7+owfzR@google.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-5-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414132013.1588929-5-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022, Vitaly Kuznetsov wrote:
> @@ -1862,15 +1890,58 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	struct kvm_vcpu_hv_tlb_flush_entry *entry;
> +	int read_idx, write_idx;
> +	u64 address;
> +	u32 count;
> +	int i, j;
>  
> -	kvm_vcpu_flush_tlb_guest(vcpu);
> -
> -	if (!hv_vcpu)
> +	if (!tdp_enabled || !hv_vcpu) {
> +		kvm_vcpu_flush_tlb_guest(vcpu);
>  		return;
> +	}
>  
>  	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
>  
> -	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
> +	/*
> +	 * TLB flush must be performed on the target vCPU so 'read_idx'
> +	 * (AKA 'tail') cannot change underneath, the compiler is free
> +	 * to re-read it.
> +	 */
> +	read_idx = tlb_flush_ring->read_idx;
> +
> +	/*
> +	 * 'write_idx' (AKA 'head') can be concurently updated by a different
> +	 * vCPU so we must be sure it's read once.
> +	 */
> +	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
> +
> +	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
> +	smp_rmb();
> +
> +	for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
> +		entry = &tlb_flush_ring->entries[i];
> +
> +		if (entry->flush_all)
> +			goto out_flush_all;
> +
> +		/*
> +		 * Lower 12 bits of 'address' encode the number of additional
> +		 * pages to flush.
> +		 */
> +		address = entry->addr & PAGE_MASK;
> +		count = (entry->addr & ~PAGE_MASK) + 1;
> +		for (j = 0; j < count; j++)
> +			static_call(kvm_x86_flush_tlb_gva)(vcpu, address + j * PAGE_SIZE);
> +	}
> +	++vcpu->stat.tlb_flush;

Bumping tlb_flush is inconsistent with how KVM handles INVLPG, and could be wrong
if the ring is empty (might be impossible without a bug?).  And if my math is right,
or at least in the ballpark, tlb_flush will be incremented once regardless of whether
the loop flushed 1 page or 64k pages (completely full ring, full count on every one).

I'd prefer to either drop the stat adjustment entirely, or bump invlpg in the loop, e.g.

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 56f06cf85282..5654c9d56289 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1945,10 +1945,11 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
        for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
                address = tlb_flush_ring->entries[i] & PAGE_MASK;
                count = (tlb_flush_ring->entries[i] & ~PAGE_MASK) + 1;
-               for (j = 0; j < count; j++)
+               for (j = 0; j < count; j++) {
                        static_call(kvm_x86_flush_tlb_gva)(vcpu, address + j * PAGE_SIZE);
+                       ++vcpu->stat.invlpg;
+               }
        }
-       ++vcpu->stat.tlb_flush;

 out_empty_ring:
        tlb_flush_ring->read_idx = write_idx;


> +	goto out_empty_ring;
> +
> +out_flush_all:
> +	kvm_vcpu_flush_tlb_guest(vcpu);
> +
> +out_empty_ring:
> +	tlb_flush_ring->read_idx = write_idx;
>  }
>  
