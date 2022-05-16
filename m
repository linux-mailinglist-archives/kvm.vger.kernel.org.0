Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E9A528DFC
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 21:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345467AbiEPTeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 15:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345463AbiEPTeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 15:34:25 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D1A3E0F2
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 12:34:23 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n8so15419006plh.1
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 12:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SVySbs/pKm8mD10Q6l48VCkei76vA+pLjRUGboIm7dc=;
        b=p7y44Ny+pPHwQ6vqkUCviLhhrDaSlcmXlrI6cfZdH86cKMIypl6THg6HjORcWiYsNh
         YSoiMwP7gDa7y7M56EFaQcJhFsdTE0TGr66r9STUHfVLGA6vhqlt42taBXl+qHb0ySxw
         56lx5TozqEGglfi+zz8/B9SfuoP87nNtff7Y3hHKJ65zFG4Vn0Qk7Ry7FWp2Ix9Uf8+1
         sUTs997MU8+uLkWaQuggs0IyEWHKcEyZ7A2PwoswEmTJ6tPNawtXlggR3fgmfuczQZFN
         jB9VBUR6ZJtlcehIH8wBprKpE8CQAWHK2ju/mDxSsQx6ncBTUOlNeYXrmY8conH5dOis
         plow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SVySbs/pKm8mD10Q6l48VCkei76vA+pLjRUGboIm7dc=;
        b=Wr3tVat5ZDKzDVNYBk8x34IxZSgW40BYoyydeVbicAl9lqhUcxladOP3CKPNB8BoOL
         rtYwOAp095BZqM3vWjWV6Vhh4eGXtHzW3gFGPaeFpsoqW8h7VU51KX6Jx15X+a5bQL3O
         s6PxemkMi/85Fgg/SbTJ42amS3zhEWbQhXc57hNXZ2USnSaY+lGoymxmlax7rUq6tAw1
         QAYAignZwMNwF1h3Mrr+QUA5WNwg4IzpD7AsGGBgZGaaopIhhNLQd9dwv8LQexeVA/su
         VTwXzWmxQnOUw0Pc+COFN4oUEANjghTc5EFjCwJ77uXXt3Wf1STu+PPUHV5YSybxvan2
         p8tg==
X-Gm-Message-State: AOAM5326V4UG9bhW8nPPt+N4ZHsjMWVm1m+L4Nj8En2Lx5ZW3OGyin5X
        7pBqMaixI/o7GpCkYptovCxC/Q==
X-Google-Smtp-Source: ABdhPJxY72EdIlmFN++GGlCl07PuY39ucWWK9AfjTptXMi1q00EX780a08el01ir90s4XkdL+dNNIg==
X-Received: by 2002:a17:90b:4d01:b0:1dc:9314:869f with SMTP id mw1-20020a17090b4d0100b001dc9314869fmr21033219pjb.140.1652729662242;
        Mon, 16 May 2022 12:34:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x12-20020a62860c000000b0050dc7628198sm7241146pfd.114.2022.05.16.12.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 12:34:21 -0700 (PDT)
Date:   Mon, 16 May 2022 19:34:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/34] KVM: x86: hyper-v: Introduce TLB flush ring
Message-ID: <YoKnOqR68SaaPCdT@google.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414132013.1588929-3-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022, Vitaly Kuznetsov wrote:
> To allow flushing individual GVAs instead of always flushing the whole
> VPID a per-vCPU structure to pass the requests is needed. Introduce a
> simple ring write-locked structure to hold two types of entries:
> individual GVA (GFN + up to 4095 following GFNs in the lower 12 bits)
> and 'flush all'.
> 
> The queuing rule is: if there's not enough space on the ring to put
> the request and leave at least 1 entry for 'flush all' - put 'flush
> all' entry.
> 
> The size of the ring is arbitrary set to '16'.
> 
> Note, kvm_hv_flush_tlb() only queues 'flush all' entries for now so
> there's very small functional change but the infrastructure is
> prepared to handle individual GVA flush requests.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 16 +++++++
>  arch/x86/kvm/hyperv.c           | 83 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/hyperv.h           | 13 ++++++
>  arch/x86/kvm/x86.c              |  5 +-
>  arch/x86/kvm/x86.h              |  1 +
>  5 files changed, 116 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1de3ad9308d8..b4dd2ff61658 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -578,6 +578,20 @@ struct kvm_vcpu_hv_synic {
>  	bool dont_zero_synic_pages;
>  };
>  
> +#define KVM_HV_TLB_FLUSH_RING_SIZE (16)
> +
> +struct kvm_vcpu_hv_tlb_flush_entry {
> +	u64 addr;

"addr" misleading, this is overloaded to be both the virtual address and the count.
I think we make it a moot point, but it led me astray in thinkin we could use the
lower 12 bits for flags... until I realized those bits are already in use.

> +	u64 flush_all:1;
> +	u64 pad:63;

This is rather odd, why not just use a bool?  But why even have a "flush_all"
field, can't we just use a magic value for write_idx to indicate "flush_all"?
E.g. either an explicit #define or -1.

Writers set write_idx to -1 to indicate "flush all", vCPU/reader goes straight
to "flush all" if write_idx is -1/invalid.  That way, future writes can simply do
nothing until read_idx == write_idx, and the vCPU/reader avoids unnecessary flushes
if there's a "flush all" pending and other valid entries in the ring.

And it allows deferring the "flush all" until the ring is truly full (unless there's
an off-by-one / wraparound edge case I'm missing, which is likely...).

---
 arch/x86/include/asm/kvm_host.h |  8 +-----
 arch/x86/kvm/hyperv.c           | 47 +++++++++++++--------------------
 2 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b6b9a71a4591..bb45cc383ce4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -605,16 +605,10 @@ enum hv_tlb_flush_rings {
 	HV_NR_TLB_FLUSH_RINGS,
 };

-struct kvm_vcpu_hv_tlb_flush_entry {
-	u64 addr;
-	u64 flush_all:1;
-	u64 pad:63;
-};
-
 struct kvm_vcpu_hv_tlb_flush_ring {
 	int read_idx, write_idx;
 	spinlock_t write_lock;
-	struct kvm_vcpu_hv_tlb_flush_entry entries[KVM_HV_TLB_FLUSH_RING_SIZE];
+	u64 entries[KVM_HV_TLB_FLUSH_RING_SIZE];
 };

 /* Hyper-V per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1d6927538bc7..56f06cf85282 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1837,10 +1837,13 @@ static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc
 static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
 					 int read_idx, int write_idx)
 {
+	if (write_idx < 0)
+		return 0;
+
 	if (write_idx >= read_idx)
-		return KVM_HV_TLB_FLUSH_RING_SIZE - (write_idx - read_idx) - 1;
+		return KVM_HV_TLB_FLUSH_RING_SIZE - (write_idx - read_idx);

-	return read_idx - write_idx - 1;
+	return read_idx - write_idx;
 }

 static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu,
@@ -1869,6 +1872,9 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu,
 	 */
 	write_idx = tlb_flush_ring->write_idx;

+	if (write_idx < 0 && read_idx == write_idx)
+		read_idx = write_idx = 0;
+
 	ring_free = hv_tlb_flush_ring_free(hv_vcpu, read_idx, write_idx);
 	/* Full ring always contains 'flush all' entry */
 	if (!ring_free)
@@ -1879,21 +1885,13 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu,
 	 * entry in case another request comes in. In case there's not enough
 	 * space, just put 'flush all' entry there.
 	 */
-	if (!count || count >= ring_free - 1 || !entries) {
-		tlb_flush_ring->entries[write_idx].addr = 0;
-		tlb_flush_ring->entries[write_idx].flush_all = 1;
-		/*
-		 * Advance write index only after filling in the entry to
-		 * synchronize with lockless reader.
-		 */
-		smp_wmb();
-		tlb_flush_ring->write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
+	if (!count || count > ring_free - 1 || !entries) {
+		tlb_flush_ring->write_idx = -1;
 		goto out_unlock;
 	}

 	for (i = 0; i < count; i++) {
-		tlb_flush_ring->entries[write_idx].addr = entries[i];
-		tlb_flush_ring->entries[write_idx].flush_all = 0;
+		tlb_flush_ring->entries[write_idx] = entries[i];
 		write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
 	}
 	/*
@@ -1911,7 +1909,6 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
-	struct kvm_vcpu_hv_tlb_flush_entry *entry;
 	int read_idx, write_idx;
 	u64 address;
 	u32 count;
@@ -1940,26 +1937,18 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
 	smp_rmb();

+	if (write_idx < 0) {
+		kvm_vcpu_flush_tlb_guest(vcpu);
+		goto out_empty_ring;
+	}
+
 	for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
-		entry = &tlb_flush_ring->entries[i];
-
-		if (entry->flush_all)
-			goto out_flush_all;
-
-		/*
-		 * Lower 12 bits of 'address' encode the number of additional
-		 * pages to flush.
-		 */
-		address = entry->addr & PAGE_MASK;
-		count = (entry->addr & ~PAGE_MASK) + 1;
+		address = tlb_flush_ring->entries[i] & PAGE_MASK;
+		count = (tlb_flush_ring->entries[i] & ~PAGE_MASK) + 1;
 		for (j = 0; j < count; j++)
 			static_call(kvm_x86_flush_tlb_gva)(vcpu, address + j * PAGE_SIZE);
 	}
 	++vcpu->stat.tlb_flush;
-	goto out_empty_ring;
-
-out_flush_all:
-	kvm_vcpu_flush_tlb_guest(vcpu);

 out_empty_ring:
 	tlb_flush_ring->read_idx = write_idx;

base-commit: 62592c7c742ae78eb1f1005a63965ece19e6effe
--

