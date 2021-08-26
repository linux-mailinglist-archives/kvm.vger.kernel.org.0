Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8967E3F8AFC
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbhHZP0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 11:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242955AbhHZP0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 11:26:03 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F446C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 08:25:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so2624046pjb.2
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 08:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AFQYJg6t7YDcRiXNnJzDduQRcWM/IYvk5kfPLa6RFVw=;
        b=je+HZQz9+sdsMRniZrRISkdipkGGwZJVSY2E4xIo+dHLEiRYubgb9ogzZRetPLf1k9
         X1oMF1ftVST026OWfXTMU9U4+0oP6yL277zYY7F9yyP/dJtfJ0U8weai8mG/gA1Kn+S8
         E0mhEy0XRNNZx/g2zrehOufvqpS0FaS+TlCa5Bur3ShNFEri1ef/QhOA5CPGmV84LuGr
         cEvccvdePhUBKnKGv3IVMtEtx+0b5AaGvJ2Y4RRl75TK8+pNZyUeN/1FDMDVAYx+TdyQ
         cNqatB+og8n1WoP9DMh4pTpbdlCoi4Ek6NoEAt8pnBkBHpJWjbdhnHO6rcjayPZSrORt
         b7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AFQYJg6t7YDcRiXNnJzDduQRcWM/IYvk5kfPLa6RFVw=;
        b=jutoNzmbo5tR728lEG/f5y5crocq5ZcxFdOjcDDbCtTYkKaKuGEHwo5xPOt3adENBu
         wCnr/FRqh7i3mgqiSdNZtt/G79rbdXlxIm2rdwGH26P/hYuHkc2hH/eJbY5vztAXoqw1
         2d6VWXP3onw2ysykkzdYVSfwoh2rDRGzDB80PQ7d+6VXzTnVlKn0BBVn9FakAZQV1+/H
         mX+zoArT6oYlK0sMSJth+/n1CMZC97kY2cVb1AjojVidTw3YxK0SesIlpE+c+jfolorD
         CHjZaGqao4YkAJkBJbeghT6YZV60HOVossapNhBWhl8M5yjCQwKapZhMjA/Q/Mw5o5Tg
         iOqw==
X-Gm-Message-State: AOAM5336zRUF0xWPpHQauPI4HwAnDgWl+Vyu7nQn2PHPyNgw40SHdvZH
        lzNL5rJ6jaz3gxWevv42b8Nxzg==
X-Google-Smtp-Source: ABdhPJzsBAIKMKcDv3gE5wn2ygtwm1nMUTd7y5zw9u/jKaEntnSFz8AesWY6Zt5ct5iLHOSyFM+b7A==
X-Received: by 2002:a17:902:e80f:b0:137:3940:ec35 with SMTP id u15-20020a170902e80f00b001373940ec35mr4339756plg.16.1629991515410;
        Thu, 26 Aug 2021 08:25:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w188sm2586132pfd.32.2021.08.26.08.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 08:25:15 -0700 (PDT)
Date:   Thu, 26 Aug 2021 15:25:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] KVM: Optimize kvm_make_vcpus_request_mask() a bit
Message-ID: <YSeyV9cWQXCd+UKk@google.com>
References: <20210826122442.966977-1-vkuznets@redhat.com>
 <20210826122442.966977-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826122442.966977-4-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021, Vitaly Kuznetsov wrote:
> Iterating over set bits in 'vcpu_bitmap' should be faster than going
> through all vCPUs, especially when just a few bits are set.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

...

> +	if (vcpu_bitmap) {
> +		for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
> +			vcpu = kvm_get_vcpu(kvm, i);
> +			if (!vcpu || vcpu == except)
> +				continue;
> +			kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
> +		}
> +	} else {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			if (vcpu == except)
> +				continue;
> +			kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
>  		}
>  	}

Rather than feed kvm_make_all_cpus_request_except() into kvm_make_vcpus_request_mask(),
I think it would be better to move the kvm_for_each_vcpu() path into
kvm_make_all_cpus_request_except() (see bottom of the mail).  That eliminates the
silliness of calling a "mask" function without a mask, and also allows a follow-up
patch to drop @except from kvm_make_vcpus_request_mask(), which is truly nonsensical
as the caller can and should simply not set that vCPU in the mask.  E.g.

---
 arch/x86/kvm/hyperv.c    | 2 +-
 arch/x86/kvm/x86.c       | 2 +-
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 3 +--
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index fe4a02715266..5787becdcfe4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1848,7 +1848,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
 	kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
-				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
+				    vcpu_mask, &hv_vcpu->tlb_flush);
 
 ret_success:
 	/* We always do full TLB flush, set 'Reps completed' = 'Rep Count' */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 11c7a02f839c..cf8fb6eb676a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9182,7 +9182,7 @@ void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
 	kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
-				    NULL, vcpu_bitmap, cpus);
+				    vcpu_bitmap, cpus);
 
 	free_cpumask_var(cpus);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 70700d4d5410..742f3b2f7c73 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -160,7 +160,6 @@ static inline bool is_error_page(struct page *page)
 #define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
-				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0d2b7fbfe43..56b524365f69 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -298,7 +298,6 @@ static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
 }
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
-				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
 	struct kvm_vcpu *vcpu;
@@ -309,7 +308,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 
 	for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
 		vcpu = kvm_get_vcpu(kvm, i);
-		if (!vcpu || vcpu == except)
+		if (!vcpu)
 			continue;
 		kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
 	}
-- 



on top of...

---
 virt/kvm/kvm_main.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a800a9f89806..d0d2b7fbfe43 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -301,25 +301,17 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
-	int i, me;
 	struct kvm_vcpu *vcpu;
+	int i, me;
 	bool called;

 	me = get_cpu();

-	if (vcpu_bitmap) {
-		for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
-			vcpu = kvm_get_vcpu(kvm, i);
-			if (!vcpu || vcpu == except)
-				continue;
-			kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
-		}
-	} else {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			if (vcpu == except)
-				continue;
-			kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
-		}
+	for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		if (!vcpu || vcpu == except)
+			continue;
+		kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
 	}

 	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
@@ -331,12 +323,23 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except)
 {
+	struct kvm_vcpu *vcpu;
 	cpumask_var_t cpus;
 	bool called;
+	int i, me;

 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);

-	called = kvm_make_vcpus_request_mask(kvm, req, except, NULL, cpus);
+	me = get_cpu();
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu == except)
+			continue;
+		kvm_make_vcpu_request(kvm, vcpu, req, cpus, me);
+	}
+
+	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
+	put_cpu();

 	free_cpumask_var(cpus);
 	return called;
--

