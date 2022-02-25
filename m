Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5FE4C43FB
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 12:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbiBYLzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 06:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240299AbiBYLzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 06:55:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04330247772
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 03:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645790107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lUNVJXD1lz8UG2j9TwfXnUiNWI5WtClpcdiSs6wBp3w=;
        b=MCCnrQGFQWlIb1w5NkmHmrTMDC8ABc0rg2em7QiARCJllq8Tkml0PcPHS0rO7J7G2absVT
        E0r/jcZVhr2HbVE3jE7a7X+rNtYC5ZAJb4878kTp9MpZbTHgujhD0xga5PTiMAtTJigxb2
        6/JmybgBuOQzpxnuvb0G2Gwsc8ag2sI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-o6V__BA4NoKOKaS1opzKNA-1; Fri, 25 Feb 2022 06:55:06 -0500
X-MC-Unique: o6V__BA4NoKOKaS1opzKNA-1
Received: by mail-wm1-f71.google.com with SMTP id m21-20020a7bcf35000000b00380e364b5d2so1238980wmg.2
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 03:55:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lUNVJXD1lz8UG2j9TwfXnUiNWI5WtClpcdiSs6wBp3w=;
        b=Z5bZw8KciH3OfM5/bbcfQ+nJfNOnVuCvMUyjIUO2jQpA3uKgrjiyIChjNZ+36qmidH
         oMm11ZviUk7O6vu7+yPpu5Eh4SMaENII6BqovuW20f6DGTnEwTeDXmkUwAvw2XBSa8pf
         cTTZq6SPTPLd/8a4Sx1nZxjJsROGkUaRnEIyIcQwwImNa0UCVUMgshJrtri7BvRWT1E5
         QNMLP9P7cw1eATYPVAkx2I0dvNSEmBJpIh7MWnh3mCB4+PaxiIFsdkJs4G7e0b2RCRWQ
         1CRQ5bmCI2sMKKMMJHUX7jTZkpcKyqiz3mNHccvxFpTRvrXXRITw1Y0LpuVgHW+fJg1q
         coHw==
X-Gm-Message-State: AOAM530N2KFlEU0+U7Tej1zu9zKct3xhW3jG4KZ2FLin7yX4nqY+OdBn
        iyqi7I22cuYl3296eYjrupGIJVPMwyRoAaLFTrojR828VUc4zIHoO/4i6AYr8Rvk7nVKD/kL1Qz
        4vtHsNc43Zwes
X-Received: by 2002:adf:e0ce:0:b0:1ef:706d:d6b9 with SMTP id m14-20020adfe0ce000000b001ef706dd6b9mr1582731wri.71.1645790104565;
        Fri, 25 Feb 2022 03:55:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQFWVO7uVjQPqJRx7TR8N5IYfKnQ7QytJcaMLYtARr61zd3Vc2XOVv8scYuFxSx+ZQrhesqQ==
X-Received: by 2002:adf:e0ce:0:b0:1ef:706d:d6b9 with SMTP id m14-20020adfe0ce000000b001ef706dd6b9mr1582710wri.71.1645790104274;
        Fri, 25 Feb 2022 03:55:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h5-20020adffd45000000b001b36cba20adsm2038473wrs.42.2022.02.25.03.55.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 03:55:03 -0800 (PST)
Message-ID: <b466b80c-21d1-f298-b4cd-a4b58988f767@redhat.com>
Date:   Fri, 25 Feb 2022 12:55:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/4] KVM: x86: hyper-v: XMM fast hypercalls fixes
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
References: <20220222154642.684285-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222154642.684285-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 16:46, Vitaly Kuznetsov wrote:
> While working on some Hyper-V TLB flush improvements and Direct TLB flush
> feature for Hyper-V on KVM I experienced Windows Server 2019 crashes on
> boot when XMM fast hypercall input feature is advertised. Turns out,
> HVCALL_SEND_IPI_EX is also an XMM fast hypercall and returning an error
> kills the guest. This is fixed in PATCH4. PATCH3 fixes erroneous capping
> of sparse CPU banks for XMM fast TLB flush hypercalls. The problem should
> be reproducible with >360 vCPUs.
> 
> Vitaly Kuznetsov (4):
>    KVM: x86: hyper-v: Drop redundant 'ex' parameter from
>      kvm_hv_send_ipi()
>    KVM: x86: hyper-v: Drop redundant 'ex' parameter from
>      kvm_hv_flush_tlb()
>    KVM: x86: hyper-v: Fix the maximum number of sparse banks for XMM fast
>      TLB flush hypercalls
>    KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
> 
>   arch/x86/kvm/hyperv.c | 84 +++++++++++++++++++++++--------------------
>   1 file changed, 45 insertions(+), 39 deletions(-)
> 

Merging this in 5.18 is a bit messy.  Please check that the below
patch against kvm/next makes sense:

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 653e08c993c4..98fb998c31ce 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1770,9 +1770,11 @@ struct kvm_hv_hcall {
  };
  
  static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
+				 int consumed_xmm_halves,
  				 u64 *sparse_banks, gpa_t offset)
  {
  	u16 var_cnt;
+	int i;
  
  	if (hc->var_cnt > 64)
  		return -EINVAL;
@@ -1780,13 +1782,29 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
  	/* Ignore banks that cannot possibly contain a legal VP index. */
  	var_cnt = min_t(u16, hc->var_cnt, KVM_HV_MAX_SPARSE_VCPU_SET_BITS);
  
+	if (hc->fast) {
+		/*
+		 * Each XMM holds two sparse banks, but do not count halves that
+		 * have already been consumed for hypercall parameters.
+		 */
+		if (hc->var_cnt > 2 * HV_HYPERCALL_MAX_XMM_REGISTERS - consumed_xmm_halves)
+			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		for (i = 0; i < var_cnt; i++) {
+			int j = i + consumed_xmm_halves;
+			if (j % 2)
+				sparse_banks[i] = sse128_lo(hc->xmm[j / 2]);
+			else
+				sparse_banks[i] = sse128_hi(hc->xmm[j / 2]);
+		}
+		return 0;
+	}
+
  	return kvm_read_guest(kvm, hc->ingpa + offset, sparse_banks,
  			      var_cnt * sizeof(*sparse_banks));
  }
  
-static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
+static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
  {
-	int i;
  	struct kvm *kvm = vcpu->kvm;
  	struct hv_tlb_flush_ex flush_ex;
  	struct hv_tlb_flush flush;
@@ -1803,7 +1821,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
  	 */
  	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64);
  
-	if (!ex) {
+	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
+	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE) {
  		if (hc->fast) {
  			flush.address_space = hc->ingpa;
  			flush.flags = hc->outgpa;
@@ -1859,17 +1878,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
  		if (!hc->var_cnt)
  			goto ret_success;
  
-		if (hc->fast) {
-			if (hc->var_cnt > HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
-				return HV_STATUS_INVALID_HYPERCALL_INPUT;
-			for (i = 0; i < hc->var_cnt; i += 2) {
-				sparse_banks[i] = sse128_lo(hc->xmm[i / 2 + 1]);
-				sparse_banks[i + 1] = sse128_hi(hc->xmm[i / 2 + 1]);
-			}
-			goto do_flush;
-		}
-
-		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks,
+		if (kvm_get_sparse_vp_set(kvm, hc, 2, sparse_banks,
  					  offsetof(struct hv_tlb_flush_ex,
  						   hv_vp_set.bank_contents)))
  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
@@ -1913,7 +1922,7 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
  	}
  }
  
-static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
+static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
  {
  	struct kvm *kvm = vcpu->kvm;
  	struct hv_send_ipi_ex send_ipi_ex;
@@ -1924,7 +1933,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
  	u32 vector;
  	bool all_cpus;
  
-	if (!ex) {
+	if (hc->code == HVCALL_SEND_IPI) {
  		if (!hc->fast) {
  			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
  						    sizeof(send_ipi))))
@@ -1943,9 +1952,15 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
  
  		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
  	} else {
-		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
-					    sizeof(send_ipi_ex))))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (!hc->fast) {
+			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
+						    sizeof(send_ipi_ex))))
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		} else {
+			send_ipi_ex.vector = (u32)hc->ingpa;
+			send_ipi_ex.vp_set.format = hc->outgpa;
+			send_ipi_ex.vp_set.valid_bank_mask = sse128_lo(hc->xmm[0]);
+		}
  
  		trace_kvm_hv_send_ipi_ex(send_ipi_ex.vector,
  					 send_ipi_ex.vp_set.format,
@@ -1964,7 +1979,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
  		if (!hc->var_cnt)
  			goto ret_success;
  
-		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks,
+		if (kvm_get_sparse_vp_set(kvm, hc, 1, sparse_banks,
  					  offsetof(struct hv_send_ipi_ex,
  						   vp_set.bank_contents)))
  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
@@ -2126,6 +2141,7 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
+	case HVCALL_SEND_IPI_EX:
  		return true;
  	}
  
@@ -2283,46 +2299,43 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
  				kvm_hv_hypercall_complete_userspace;
  		return 0;
  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
-		if (unlikely(!hc.rep_cnt || hc.rep_idx || hc.var_cnt)) {
+		if (unlikely(hc.var_cnt)) {
  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
  			break;
  		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
-		break;
-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
-		if (unlikely(hc.rep || hc.var_cnt)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
-		break;
+		fallthrough;
  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
  		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
  			break;
  		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc);
  		break;
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
+		if (unlikely(hc.var_cnt)) {
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		}
+		fallthrough;
  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
  		if (unlikely(hc.rep)) {
  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
  			break;
  		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc);
  		break;
  	case HVCALL_SEND_IPI:
-		if (unlikely(hc.rep || hc.var_cnt)) {
+		if (unlikely(hc.var_cnt)) {
  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
  			break;
  		}
-		ret = kvm_hv_send_ipi(vcpu, &hc, false);
-		break;
+		fallthrough;
  	case HVCALL_SEND_IPI_EX:
-		if (unlikely(hc.fast || hc.rep)) {
+		if (unlikely(hc.rep)) {
  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
  			break;
  		}
-		ret = kvm_hv_send_ipi(vcpu, &hc, true);
+		ret = kvm_hv_send_ipi(vcpu, &hc);
  		break;
  	case HVCALL_POST_DEBUG_DATA:
  	case HVCALL_RETRIEVE_DEBUG_DATA:


The resulting merge commit is already in kvm/queue shortly (which should
become the next kvm/next as soon as tests complete).

Paolo

