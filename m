Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD4721A637
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgGIRrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:47:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58424 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728771AbgGIRrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594316831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQEZ/X60w4Dr4Yx057tjgU0MuPGoc8zws3NdcP5xzU0=;
        b=IxDs99KS/vPtVEJ9ywdxFYS61v+fbsUXCrn9xgWGljWEFe9Uvt4U1EAncIJZraHuL/Tygi
        fr7wQkyAjmtBDhYzZcq/vgET8doxz9GuREd3nGU+iCz1yJEZ2Sz0bCHaMdDpsfuVvDdFDg
        pqleWg7PsfxdWXR7gohIWT4gszNgors=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-0FPAXLTKMAStkmC4ATvxng-1; Thu, 09 Jul 2020 13:47:10 -0400
X-MC-Unique: 0FPAXLTKMAStkmC4ATvxng-1
Received: by mail-wr1-f70.google.com with SMTP id z1so2588073wrn.18
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 10:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tQEZ/X60w4Dr4Yx057tjgU0MuPGoc8zws3NdcP5xzU0=;
        b=gQzHLO0zaGOt318JXP1pqaaTg/FW+nHTOcHWFhsA4tp1NQahh6X8tuFnhRR2TOvaMh
         Hi55/2+eLl67IQmBmPI8Uw+1Zb7PJz9p/UtCULcZbIgeHXD689kUy4Y9rixlUtcTpc7t
         4nkDR+ih5Cw8yVwZKoGbxG+l0cLDNKYlK/pN1QwbGR0hzHcWvzlv34EMIXbqzCCh7DFk
         EkhrJ+i50lUlQ0h3zITYtBz2wQ2FYIole+2ntQkRl9Zic+6tiM9UL9zaV0FnU9B9JL2n
         ersM+41ZCciGMwcN8mpsxiRefGrvDZFE7JJa3eHXxc5OEG3X39zplMInCNUHAwvwxgtZ
         Wy4Q==
X-Gm-Message-State: AOAM532HcewuhB/ubbv+QwtEzoKm0U8riFTmjIprsYnATcCNo9757Hdc
        ro1p3yEQDe+jmtIZL837bWnOxM3Vc26/TjOxFFOk1gsm4nLZeQM6jiqaahKnQ12O+v+Eqlv1wnJ
        wr7MQki03U3Rm
X-Received: by 2002:adf:ec42:: with SMTP id w2mr65079443wrn.269.1594316828757;
        Thu, 09 Jul 2020 10:47:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzKy2sg6Y5Mw1xuBaOwDSwnR6MCjcqFzdAlEFQ64OSxQdEBmpqMG1KLCfhQXYJsbmlYAJtCw==
X-Received: by 2002:adf:ec42:: with SMTP id w2mr65079426wrn.269.1594316828506;
        Thu, 09 Jul 2020 10:47:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id f15sm6067638wrx.91.2020.07.09.10.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 10:47:08 -0700 (PDT)
Subject: Re: [PATCH v3 2/9] KVM: nSVM: stop dereferencing vcpu->arch.mmu to
 get the context in kvm_init_shadow{,_npt}_mmu()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
References: <20200709145358.1560330-1-vkuznets@redhat.com>
 <20200709145358.1560330-3-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1c6999b7-1eae-4b26-7220-6e3e68457511@redhat.com>
Date:   Thu, 9 Jul 2020 19:47:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709145358.1560330-3-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 16:53, Vitaly Kuznetsov wrote:
> Now as kvm_init_shadow_npt_mmu() is separated from kvm_init_shadow_mmu()
> we always know the MMU context we need to use so there is no need to
> dereference vcpu->arch.mmu pointer.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 

This is actually true of all init functions, so we can squash this in too
(my fault for being too concise):

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2c4fb5684782..78c88e8aecfa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4850,7 +4850,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 
 static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
 		kvm_calc_tdp_mmu_root_page_role(vcpu, false);
 
@@ -4989,7 +4989,7 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     bool accessed_dirty, gpa_t new_eptp)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	u8 level = vmx_eptp_page_walk_level(new_eptp);
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
@@ -5023,7 +5023,7 @@ EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 
 	kvm_init_shadow_mmu(vcpu,
 			    kvm_read_cr0_bits(vcpu, X86_CR0_PG),


(BTW, a patch to rename nested_mmu to nested_walk_mmu and guest_mmu to
nested_tdp_mmu would be welcome).

Paolo

