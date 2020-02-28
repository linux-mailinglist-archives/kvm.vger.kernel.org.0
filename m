Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729B8173517
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 11:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgB1KQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 05:16:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37421 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726583AbgB1KQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 05:16:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582884976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Yuq0w99xWOCSYSMhOpYFNZZ7MnQhsxMdcr2Kk7+fsM=;
        b=BLsyzh4jatwVCEGpU3+gB9yEONiUDTIKHJYwvB3ha69n/j3bIOVozYgvuxs4gjRnhR43zz
        nbIlu5DxYD5wzBq/SiOiI5XiuT3pwbpdVyv5UumjgrbZotWv0bvtBnpkcgz9f4AFqW8rnL
        NWuM1q+nqxAr73kt/K6AXK9sntXK7vA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-S2GISpCnOdeXQftE2-LCqg-1; Fri, 28 Feb 2020 05:16:13 -0500
X-MC-Unique: S2GISpCnOdeXQftE2-LCqg-1
Received: by mail-wr1-f69.google.com with SMTP id 72so1135522wrc.6
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 02:16:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Yuq0w99xWOCSYSMhOpYFNZZ7MnQhsxMdcr2Kk7+fsM=;
        b=pkKb1WbuJVPM49kq7Lqo3WAdX799WCea1YQovV3PtXIzp5gJoNWRvV0h9WFksnFKJx
         bD1Dfxi2wzcbUqho2JDhnZ329j/B2YzaT9quttcem4q77mfFbKT+NF8wYHGDz4rRtJi4
         Em1pl1+LqTUfVW8XYKkhy50DLzvoc3I1zrLVB+34P5Ty0coPWwwtojt2JtQh5OXot2Ws
         WbApe7KC6OiHgaUPKuUKsG4YbAx/n1HdQwXuO36P4WOg8GBYfPs89MzBDHBZecBJN8E7
         Sn98yQ5al3PFr84b30jP2O9DBFvCDKZefCVqoWC8H+4haOozWDblt4WeJNtdb1arVXUs
         GYSQ==
X-Gm-Message-State: APjAAAVyMbv5GHl2yTvgwy9MbNiYLd/QCbHE4NuiXSDTfHMJZGtV1r1e
        +npYRfzwzc5xl2H35FL7dyMUe1Sk21VLNyMraPXMPSE6yakFBKoKlhZv/6NhvRU4/CaKvBy5WOW
        9cIIVkjWNTSmK
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr4093671wma.84.1582884972240;
        Fri, 28 Feb 2020 02:16:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqww48iU01L+2UIHDN8maT/6XhdwCadWPyvh9i05KWipKkTPXTpA9aSzjcGgKDcRq+I5vQkURw==
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr4093643wma.84.1582884971917;
        Fri, 28 Feb 2020 02:16:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id 133sm1683182wmd.5.2020.02.28.02.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 02:16:11 -0800 (PST)
Subject: Re: [PATCH 1/3] KVM: VMX: Always VMCLEAR in-use VMCSes during crash
 with kexec support
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200227223047.13125-1-sean.j.christopherson@intel.com>
 <20200227223047.13125-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9edc8cef-9aa4-11ca-f8f2-a1fea990b87e@redhat.com>
Date:   Fri, 28 Feb 2020 11:16:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227223047.13125-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/02/20 23:30, Sean Christopherson wrote:
> -void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
> +void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use)
>  {
>  	vmcs_clear(loaded_vmcs->vmcs);
>  	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
>  		vmcs_clear(loaded_vmcs->shadow_vmcs);
> +
> +	if (in_use) {
> +		list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
> +
> +		/*
> +		 * Ensure deleting loaded_vmcs from its current percpu list
> +		 * completes before setting loaded_vmcs->vcpu to -1, otherwise
> +		 * a different cpu can see vcpu == -1 first and add loaded_vmcs
> +		 * to its percpu list before it's deleted from this cpu's list.
> +		 * Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
> +		 */
> +		smp_wmb();
> +	}
> +

I'd like to avoid the new in_use argument and, also, I think it's a 
little bit nicer to always invoke the memory barrier.  Even though we 
use "asm volatile" for vmclear and therefore the compiler is already 
taken care of, in principle it's more correct to order the ->cpu write 
against vmclear's.

This gives the following patch on top:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9d6152e7a4d..77a64110577b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -656,25 +656,24 @@ static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr,
 	return ret;
 }
 
-void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use)
+void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
 {
 	vmcs_clear(loaded_vmcs->vmcs);
 	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
 		vmcs_clear(loaded_vmcs->shadow_vmcs);
 
-	if (in_use) {
+	if (!list_empty(&loaded_vmcs->loaded_vmcss_on_cpu_link))
 		list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
 
-		/*
-		 * Ensure deleting loaded_vmcs from its current percpu list
-		 * completes before setting loaded_vmcs->vcpu to -1, otherwise
-		 * a different cpu can see vcpu == -1 first and add loaded_vmcs
-		 * to its percpu list before it's deleted from this cpu's list.
-		 * Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
-		 */
-		smp_wmb();
-	}
-
+	/*
+	 * Ensure all writes to loaded_vmcs, including deleting it
+	 * from its current percpu list, complete before setting
+	 * loaded_vmcs->vcpu to -1; otherwise,, a different cpu can
+	 * see vcpu == -1 first and add loaded_vmcs to its percpu
+	 * list before it's deleted from this cpu's list.  Pairs
+	 * with the smp_rmb() in vmx_vcpu_load_vmcs().
+	 */
+	smp_wmb();
 	loaded_vmcs->cpu = -1;
 	loaded_vmcs->launched = 0;
 }
@@ -701,7 +700,7 @@ static void __loaded_vmcs_clear(void *arg)
 	if (per_cpu(current_vmcs, cpu) == loaded_vmcs->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
 
-	loaded_vmcs_init(loaded_vmcs, true);
+	loaded_vmcs_init(loaded_vmcs);
 }
 
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
@@ -2568,7 +2567,8 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 
 	loaded_vmcs->shadow_vmcs = NULL;
 	loaded_vmcs->hv_timer_soft_disabled = false;
-	loaded_vmcs_init(loaded_vmcs, false);
+	INIT_LIST_HEAD(&loaded_vmcs->loaded_vmcss_on_cpu_link);
+	loaded_vmcs_init(loaded_vmcs);
 
 	if (cpu_has_vmx_msr_bitmap()) {
 		loaded_vmcs->msr_bitmap = (unsigned long *)

Paolo

