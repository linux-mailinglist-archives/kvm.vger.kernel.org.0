Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E993582E5
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhDHMJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:09:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhDHMJZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:09:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617883754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rdpdfQzM446muxH6P5CozRuSvNifAeX4ooK3/0ZCJss=;
        b=iJq/nO3uCB7eQXc+0gbatobxzRryRrzPfwdJ7udQHjKjB6bL20y+h3dMk7jeAbEEIe7djX
        bGDJmowLUYg8G2ETghWQB6vCmT8QK4Lr9wbMf40TjOvhbVw6GkT9rjBYjyrSenOlDQpALQ
        78zkELklDJhvif/t/k3EtXOMsPRP5M0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-OViqOe25Oqurm52CflQveg-1; Thu, 08 Apr 2021 08:09:12 -0400
X-MC-Unique: OViqOe25Oqurm52CflQveg-1
Received: by mail-ej1-f70.google.com with SMTP id d25so297690ejb.14
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 05:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rdpdfQzM446muxH6P5CozRuSvNifAeX4ooK3/0ZCJss=;
        b=MeJwH48xQTfgICj21IbrfE2jAyRWHBvVowKkXZaqHHCWqmiZYGe/ljAHRWSax64seT
         32z470P3tXU5er1bztBCyxz71fNBjxT9wwET22DXQjDwxPBpqDdT9WA4vAm8gTYlPK27
         ph5Sd5dIrDo4YGTlPbmGZCgG8KTHoIA5Dw1CG4iY2UUE4vlyg8MPe9x3UVXp+qSqJvNp
         wdjPqQTGOpRiuf/xS+0jMi69EECCwP9tqdhjdweeB1xaAB75ScIsOSJFeJZdVfxp7IZv
         MfWqp0Mk3XfKuiulhzJqzYYHE3gURjd6iWniTIjAdj2miX9vVJipUIAhJM6zv1RAhyvx
         DAGA==
X-Gm-Message-State: AOAM5330r5E945sn9sg4pS1aWKXKwpOEq2lg5mdV1laZH4znzwtBQYCQ
        75IG1fa9ulMzfgoa8uknSJvIysbgV3efhScMYDR/+E2CVcA3hCb97pb/y2moSm7/WMC9CP6WFK8
        hdAARBTHr8NzH
X-Received: by 2002:a17:906:958f:: with SMTP id r15mr9954073ejx.450.1617883751554;
        Thu, 08 Apr 2021 05:09:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwE1OEbopDmkYK5v4FDEcViOLJemUWoKVpGTwpGGwnEEY68wRznkBYOfU9GHvneFj/l7+bdow==
X-Received: by 2002:a17:906:958f:: with SMTP id r15mr9954052ejx.450.1617883751407;
        Thu, 08 Apr 2021 05:09:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o26sm7272353ejx.90.2021.04.08.05.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 05:09:10 -0700 (PDT)
Subject: Re: [PATCH v2 07/17] KVM: x86/mmu: Check PDPTRs before allocating PAE
 roots
To:     Wanpeng Li <kernellwp@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210305011101.3597423-1-seanjc@google.com>
 <20210305011101.3597423-8-seanjc@google.com>
 <CANRm+CzUAzR+D3BtkYpe71sHf_nmtm_Qmh4neqc=US2ETauqyQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f6ae3dbb-cfa5-4d8b-26bf-92db6fc9eab1@redhat.com>
Date:   Thu, 8 Apr 2021 14:09:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CzUAzR+D3BtkYpe71sHf_nmtm_Qmh4neqc=US2ETauqyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/21 13:15, Wanpeng Li wrote:
> I saw this splatting:
> 
>   BUG: sleeping function called from invalid context at
> arch/x86/kvm/kvm_cache_regs.h:115
>    kvm_pdptr_read+0x20/0x60 [kvm]
>    kvm_mmu_load+0x3bd/0x540 [kvm]
> 
> There is a might_sleep() in kvm_pdptr_read(), however, the original
> commit didn't explain more. I can send a formal one if the below fix
> is acceptable.

I think we can just push make_mmu_pages_available down into
kvm_mmu_load's callees.  This way it's not necessary to hold the lock
until after the PDPTR check:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0d92a269c5fa..f92c3695bfeb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3244,6 +3244,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
  	u8 shadow_root_level = mmu->shadow_root_level;
  	hpa_t root;
  	unsigned i;
+	int r;
+
+	write_lock(&vcpu->kvm->mmu_lock);
+	r = make_mmu_pages_available(vcpu);
+	if (r < 0)
+		goto out_unlock;
  
  	if (is_tdp_mmu_enabled(vcpu->kvm)) {
  		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
@@ -3266,13 +3272,16 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
  		mmu->root_hpa = __pa(mmu->pae_root);
  	} else {
  		WARN_ONCE(1, "Bad TDP root level = %d\n", shadow_root_level);
-		return -EIO;
+		r = -EIO;
  	}
  
+out_unlock:
+	write_unlock(&vcpu->kvm->mmu_lock);
+
  	/* root_pgd is ignored for direct MMUs. */
  	mmu->root_pgd = 0;
  
-	return 0;
+	return r;
  }
  
  static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
@@ -3282,6 +3291,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
  	gfn_t root_gfn, root_pgd;
  	hpa_t root;
  	int i;
+	int r;
  
  	root_pgd = mmu->get_guest_pgd(vcpu);
  	root_gfn = root_pgd >> PAGE_SHIFT;
@@ -3300,6 +3310,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
  		}
  	}
  
+	write_lock(&vcpu->kvm->mmu_lock);
+	r = make_mmu_pages_available(vcpu);
+	if (r < 0)
+		goto out_unlock;
+
  	/*
  	 * Do we shadow a long mode page table? If so we need to
  	 * write-protect the guests page table root.
@@ -3308,7 +3323,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
  		root = mmu_alloc_root(vcpu, root_gfn, 0,
  				      mmu->shadow_root_level, false);
  		mmu->root_hpa = root;
-		goto set_root_pgd;
+		goto out_unlock;
  	}
  
  	if (WARN_ON_ONCE(!mmu->pae_root))
@@ -3350,7 +3365,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
  	else
  		mmu->root_hpa = __pa(mmu->pae_root);
  
-set_root_pgd:
+out_unlock:
+	write_unlock(&vcpu->kvm->mmu_lock);
  	mmu->root_pgd = root_pgd;
  
  	return 0;
@@ -4852,14 +4868,10 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
  	r = mmu_alloc_special_roots(vcpu);
  	if (r)
  		goto out;
-	write_lock(&vcpu->kvm->mmu_lock);
-	if (make_mmu_pages_available(vcpu))
-		r = -ENOSPC;
-	else if (vcpu->arch.mmu->direct_map)
+	if (vcpu->arch.mmu->direct_map)
  		r = mmu_alloc_direct_roots(vcpu);
  	else
  		r = mmu_alloc_shadow_roots(vcpu);
-	write_unlock(&vcpu->kvm->mmu_lock);
  	if (r)
  		goto out;
  

Paolo

