Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D582C4F8649
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346098AbiDGRfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 13:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbiDGRfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 13:35:44 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB36D13A1FC
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 10:33:37 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w7so6050093pfu.11
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 10:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xGRbiac9toXXNzU0tyvyrqhQhTOIou7FyrYj+X2weCI=;
        b=lY+aU6tRq6WsVqLG89jQ+0OCk0PZgRKRmujHlFx61XJNMTnGXk3Lpw0lnFs1WrGE2j
         48rZT/ruRncJnqcVy9SuWwFoUq4pqZaLPlWCCZpSd2jlB71NhZ8g3vmMYh7STnpZva5O
         szZ8T42xg0oMTgtQl158gtbc3nj5iZT7vmtu1UI/erEWI/Nr2+ReSxnehCnmuBNw9F2e
         Ulyh1n/5zBW4DCHLVZAs41fsvgx5tf9sK8tNpMLuJNm5jGJ3YtMY1K4nOD6OGdrhPInd
         WprHIxjba4Atj4TaryahRFSLxDi+JX72ozYnj/GruaLiXo2qEqGE+w5T7XYv0Wih7SFT
         E6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xGRbiac9toXXNzU0tyvyrqhQhTOIou7FyrYj+X2weCI=;
        b=iafUDcNrUj1y0rtLfIeIgQaOUKzRNaTdCLjWIINUzBefyeTGxGU9t8bPdXBrcJ704a
         aMXgwVR1qaUSaweEuSDua7/qWP6pMeqcLRvzQTkvoi4rgMaDxdm6cP5k4beOORwYIdGP
         +eO2bp5CkofJJ33iu/E3l4TUa0vTTiGM9McOoZwhuIIv7GOO9uj0v3atIlzQQajyvN6L
         8PgeRDHSi7zlSTOQ6yIVymYCJENNU/CMJirZQg/iesPTmd/5TvKGkCnlpD/gpKkLkufI
         8ZEcPJwQlngE80dzAk3P0RGe5I7ZrdINNgq31BSsQBHXC2J6OkiqFndDgWpjMh+ntfSH
         iYLA==
X-Gm-Message-State: AOAM5302XnWJEWgvLKsE20g4WkJ3ggEIt7lnwMOSW6hbhSDmxhBp0WfZ
        j1eHNkiK7pQJxRTgND9hH5+TYQ==
X-Google-Smtp-Source: ABdhPJxN6vzyurVuDzMoitz2SvsQTcINBF4WXPD8hLI12+/eQRc8uPVoGJYOL/W5pmZKlCUslM9JyA==
X-Received: by 2002:aa7:8049:0:b0:4fd:bfde:45eb with SMTP id y9-20020aa78049000000b004fdbfde45ebmr15464085pfm.76.1649352784639;
        Thu, 07 Apr 2022 10:33:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v8-20020a056a00148800b004fa9bd7ddc9sm23998007pfu.113.2022.04.07.10.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:33:03 -0700 (PDT)
Date:   Thu, 7 Apr 2022 17:33:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/31] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Message-ID: <Yk8gTB+x2UVE34Ds@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tIecicdRcj+9Bvwz"
Content-Disposition: inline
In-Reply-To: <20220407155645.940890-4-vkuznets@redhat.com>
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


--tIecicdRcj+9Bvwz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
> Currently, HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls are handled
> the exact same way as HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE{,EX}: by
> flushing the whole VPID and this is sub-optimal. Switch to handling
> these requests with 'flush_tlb_gva()' hooks instead. Use the newly
> introduced TLB flush ring to queue the requests.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 141 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 121 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 81c44e0eadf9..a54d41656f30 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1792,6 +1792,35 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
>  			      var_cnt * sizeof(*sparse_banks));
>  }
>  
> +static int kvm_hv_get_tlbflush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
> +				       u32 data_offset, int consumed_xmm_halves)

data_offset should be gpa_t, and the order of params should be consistent between
this and kvm_get_sparse_vp_set().

> +{
> +	int i;
> +
> +	if (hc->fast) {
> +		/*
> +		 * Each XMM holds two entries, but do not count halves that
> +		 * have already been consumed.
> +		 */
> +		if (hc->rep_cnt > (2 * HV_HYPERCALL_MAX_XMM_REGISTERS - consumed_xmm_halves))
> +			return -EINVAL;
> +
> +		for (i = 0; i < hc->rep_cnt; i++) {
> +			int j = i + consumed_xmm_halves;
> +
> +			if (j % 2)
> +				entries[i] = sse128_hi(hc->xmm[j / 2]);
> +			else
> +				entries[i] = sse128_lo(hc->xmm[j / 2]);
> +		}
> +
> +		return 0;
> +	}
> +
> +	return kvm_read_guest(kvm, hc->ingpa + data_offset,
> +			      entries, hc->rep_cnt * sizeof(entries[0]));

This is almost verbatim copy+pasted from kvm_get_sparse_vp_set().  If you slot in
the attached patched before this, then this function becomes:

static int kvm_hv_get_tlbflush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
				       int consumed_xmm_halves, gpa_t offset)
{
	return kvm_hv_get_hc_data(kvm, hc, hc->rep_cnt, hc->rep_cnt,
				  entries, consumed_xmm_halves, offset);
}


> +}

...

> @@ -1840,15 +1891,47 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> -
> -	kvm_vcpu_flush_tlb_guest(vcpu);
> -
> -	if (!hv_vcpu)
> +	struct kvm_vcpu_hv_tlbflush_entry *entry;
> +	int read_idx, write_idx;
> +	u64 address;
> +	u32 count;
> +	int i, j;
> +
> +	if (!tdp_enabled || !hv_vcpu) {
> +		kvm_vcpu_flush_tlb_guest(vcpu);
>  		return;
> +	}
>  
>  	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
> +	read_idx = READ_ONCE(tlb_flush_ring->read_idx);
> +	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
> +
> +	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
> +	smp_rmb();
>  
> -	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
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
> +	goto out_empty_ring;
> +
> +out_flush_all:
> +	kvm_vcpu_flush_tlb_guest(vcpu);
> +
> +out_empty_ring:
> +	tlb_flush_ring->read_idx = write_idx;
>  }
>  
>  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
> @@ -1857,12 +1940,13 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	struct hv_tlb_flush_ex flush_ex;
>  	struct hv_tlb_flush flush;
>  	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
> +	u64 entries[KVM_HV_TLB_FLUSH_RING_SIZE - 2];

What's up with the -2?  And given the multitude of things going on in this code,
I'd strongly prefer this be tlbflush_entries.

Actually, if you do:

	u64 __tlbflush_entries[KVM_HV_TLB_FLUSH_RING_SIZE - 2];
	u64 *tlbflush_entries;

and drop all_addr, the code to get entries can be

	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
	    hc->rep_cnt > ARRAY_SIZE(tlbflush_entries)) {
		tlbfluish_entries = NULL;
	} else {
		if (kvm_hv_get_tlbflush_entries(kvm, hc, __tlbflush_entries,
						consumed_xmm_halves, data_offset))
			return HV_STATUS_INVALID_HYPERCALL_INPUT;
		tlbfluish_entries = __tlbflush_entries;
	}

and the calls to queue flushes becomes

			hv_tlb_flush_ring_enqueue(v, tlbflush_entries, hc->rep_cnt);

That way a bug will "just" be a NULL pointer dereference and not consumption of
uninitialized data (though such a bug might be caught be caught by the compiler).

>  	u64 valid_bank_mask;
>  	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>  	struct kvm_vcpu *v;
>  	unsigned long i;
> -	bool all_cpus;
> -
> +	bool all_cpus, all_addr;
> +	int data_offset = 0, consumed_xmm_halves = 0;

data_offset should be a gpa_t.

>  	/*
>  	 * The Hyper-V TLFS doesn't allow more than 64 sparse banks, e.g. the
>  	 * valid mask is a u64.  Fail the build if KVM's max allowed number of

...

> +read_flush_entries:
> +	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
> +	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
> +	    hc->rep_cnt > (KVM_HV_TLB_FLUSH_RING_SIZE - 2)) {

Rather than duplicate the -2 magic, it's far better to do:


> +		all_addr = true;
> +	} else {
> +		if (kvm_hv_get_tlbflush_entries(kvm, hc, entries,
> +						data_offset, consumed_xmm_halves))

As mentioned, the order for this call should match kvm_get_sparse_vp_set().

>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		all_addr = false;
>  	}
>  
> -do_flush:
> +
>  	/*
>  	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
>  	 * analyze it here, flush TLB regardless of the specified address space.
>  	 */
>  	if (all_cpus) {
>  		kvm_for_each_vcpu(i, v, kvm)
> -			hv_tlb_flush_ring_enqueue(v);
> +			hv_tlb_flush_ring_enqueue(v, all_addr, entries, hc->rep_cnt);
>  
>  		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
>  	} else {
> @@ -1951,7 +2052,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  			v = kvm_get_vcpu(kvm, i);
>  			if (!v)
>  				continue;
> -			hv_tlb_flush_ring_enqueue(v);
> +			hv_tlb_flush_ring_enqueue(v, all_addr, entries, hc->rep_cnt);
>  		}
>  
>  		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
> -- 
> 2.35.1
> 

--tIecicdRcj+9Bvwz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-hyper-v-Add-helper-to-read-hypercall-data-fo.patch"

From ad6033048d498baba7889ae0e14788c92d4baacb Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 7 Apr 2022 09:52:46 -0700
Subject: [PATCH] KVM: x86: hyper-v: Add helper to read hypercall data for
 arrary

Move the guts of kvm_get_sparse_vp_set() to a helper so that the code for
reading a guest-provided array can be reused in the future, e.g. for
getting a list of virtual addresses whose TLB entries need to be flushed.

Opportunisticaly swap the order of the data and XMM adjustment so that
the XMM/gpa offsets are bundled together.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c | 53 +++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index e4f381b46a28..58e7aff6057a 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1782,38 +1782,51 @@ struct kvm_hv_hcall {
 	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
 };
 
-static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
-				 int consumed_xmm_halves,
-				 u64 *sparse_banks, gpa_t offset)
+
+static int kvm_hv_get_hc_data(struct kvm *kvm, struct kvm_hv_hcall *hc,
+			      u16 orig_cnt, u16 cnt_cap, u64 *data,
+			      int consumed_xmm_halves, gpa_t offset)
 {
-	u16 var_cnt;
-	int i;
-
-	if (hc->var_cnt > 64)
-		return -EINVAL;
-
-	/* Ignore banks that cannot possibly contain a legal VP index. */
-	var_cnt = min_t(u16, hc->var_cnt, KVM_HV_MAX_SPARSE_VCPU_SET_BITS);
+	/*
+	 * Preserve the original count when ignoring entries via a "cap", KVM
+	 * still needs to validate the guest input (though the non-XMM path
+	 * punts on the checks).
+	 */
+	u16 cnt = min(orig_cnt, cnt_cap);
+	int i, j;
 
 	if (hc->fast) {
 		/*
 		 * Each XMM holds two sparse banks, but do not count halves that
 		 * have already been consumed for hypercall parameters.
 		 */
-		if (hc->var_cnt > 2 * HV_HYPERCALL_MAX_XMM_REGISTERS - consumed_xmm_halves)
+		if (orig_cnt > 2 * HV_HYPERCALL_MAX_XMM_REGISTERS - consumed_xmm_halves)
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
-		for (i = 0; i < var_cnt; i++) {
-			int j = i + consumed_xmm_halves;
+
+		for (i = 0; i < cnt; i++) {
+			j = i + consumed_xmm_halves;
 			if (j % 2)
-				sparse_banks[i] = sse128_hi(hc->xmm[j / 2]);
+				data[i] = sse128_hi(hc->xmm[j / 2]);
 			else
-				sparse_banks[i] = sse128_lo(hc->xmm[j / 2]);
+				data[i] = sse128_lo(hc->xmm[j / 2]);
 		}
 		return 0;
 	}
 
-	return kvm_read_guest(kvm, hc->ingpa + offset, sparse_banks,
-			      var_cnt * sizeof(*sparse_banks));
+	return kvm_read_guest(kvm, hc->ingpa + offset, data,
+			      cnt * sizeof(*data));
+}
+
+static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
+				 u64 *sparse_banks, int consumed_xmm_halves,
+				 gpa_t offset)
+{
+	if (hc->var_cnt > 64)
+		return -EINVAL;
+
+	/* Cap var_cnt to ignore banks that cannot contain a legal VP index. */
+	return kvm_hv_get_hc_data(kvm, hc, hc->var_cnt, KVM_HV_MAX_SPARSE_VCPU_SET_BITS,
+				  sparse_banks, consumed_xmm_halves, offset);
 }
 
 static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
@@ -1952,7 +1965,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		if (!hc->var_cnt)
 			goto ret_success;
 
-		if (kvm_get_sparse_vp_set(kvm, hc, 2, sparse_banks,
+		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, 2,
 					  offsetof(struct hv_tlb_flush_ex,
 						   hv_vp_set.bank_contents)))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
@@ -2063,7 +2076,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		if (!hc->var_cnt)
 			goto ret_success;
 
-		if (kvm_get_sparse_vp_set(kvm, hc, 1, sparse_banks,
+		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, 1,
 					  offsetof(struct hv_send_ipi_ex,
 						   vp_set.bank_contents)))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;

base-commit: 9e28f2680fd1606225ab456bb28d30598110a520
-- 
2.35.1.1178.g4f1659d476-goog


--tIecicdRcj+9Bvwz--
