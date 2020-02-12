Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF23D15A85B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgBLLzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:55:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29763 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725781AbgBLLzK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 06:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581508509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+nCekSvtnF5ICGx5lYNRGTF4VRbsHea62qKJdV2fz/U=;
        b=Umv7n+deaH7BMJARaGuXrp6tSJTNHsAu7JQ5NS9stDayDDm4Itx7X0hvsA//5+Zbhzd2Ud
        uV/mUPJuQHLj6IA/879L7n5+yJ34wKjIIUTOuc29GLTyQvtHBczmNvLhEW7VtBM64H7TdU
        R+lzBdoEQBikxIVJ76cyOB20ctGQWK8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-6hy8pD6VP7OkfObyPOZmFA-1; Wed, 12 Feb 2020 06:55:06 -0500
X-MC-Unique: 6hy8pD6VP7OkfObyPOZmFA-1
Received: by mail-wm1-f72.google.com with SMTP id m4so848767wmi.5
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:55:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+nCekSvtnF5ICGx5lYNRGTF4VRbsHea62qKJdV2fz/U=;
        b=eDo7aYFfDupY97mZKKcrdQoD1tZW1Xi+vLoPOVsvCE6o4ZE9FTIbNCqMwWvQ2CrQ/K
         IfBJn2AJz0aseNCiIyKbbHtmkq3VbBc6GRQlwG9mwf/BF6JIcR/fLvUh3gdpkQkIm7Gg
         4gflocWNJX+RGZNnvbwlGx8I024wqQ1XEaWppltwUg88+NG3DRYQBLXPECdo66of2u9l
         OclwqU/w2B8X3VXj3E0VjaUkvzs3PuT5pmT6fFMpTPaIPl39zXO8kpt5ABsdSSKJib6v
         PPDgKTrvED6371b9RJoTHFeGuDkSySWjkLHMQmuTDiusGR2FNTmANNuCwwXrQJop6Wim
         cuaA==
X-Gm-Message-State: APjAAAXmaP0eN8GALLmITfvMxEzFDTEA/2Ot+D/ftmRvKnK7w+9BtM+L
        kx7KH7Lip59WaxtMBQRTu2YecP5c8TILg9NmtCUplIS3D6/JrgpwKpedylmmVNGgn4+jYEGsyRH
        A8KPNi7LUMEX1
X-Received: by 2002:a05:6000:10c:: with SMTP id o12mr15163424wrx.106.1581508505084;
        Wed, 12 Feb 2020 03:55:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqzhqQox9crYXM4E5K0/jOBGNlzJTU+ZSosFlntFfc8I8yK1mEtYnXRBjEkAkS76pfnNva2ofA==
X-Received: by 2002:a05:6000:10c:: with SMTP id o12mr15163402wrx.106.1581508504809;
        Wed, 12 Feb 2020 03:55:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id b13sm377412wrq.48.2020.02.12.03.55.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:55:03 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Avoid retpoline on ->page_fault() with TDP
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200206221434.23790-1-sean.j.christopherson@intel.com>
 <878sleg2z7.fsf@vitty.brq.redhat.com> <20200207155539.GC2401@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <408bfd4c-7407-48cd-95fb-db44a7c1c2bf@redhat.com>
Date:   Wed, 12 Feb 2020 12:55:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200207155539.GC2401@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 16:55, Sean Christopherson wrote:
> It becomes a matter of weighing the maintenance cost and robustness against
> the performance benefits.  For the TDP case, amost no one (that cares about
> performance) uses shadow paging, the change is very explicit, tiny and
> isolated, and TDP page fault are a hot path, e.g. when booting the VM.
> I.e. low maintenance overhead, still robust, and IMO worth the shenanigans.

The "NULL" trick does not seem needed though.  Any objections to this?

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9277ee8a54a5..a647601c9e1c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -109,7 +109,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
 {
 #ifdef CONFIG_RETPOLINE
-	if (likely(!vcpu->arch.mmu->page_fault))
+	if (likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault))
 		return kvm_tdp_page_fault(vcpu, cr2_or_gpa, err, prefault);
 #endif
 	return vcpu->arch.mmu->page_fault(vcpu, cr2_or_gpa, err, prefault);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5267f1440677..87e9ba27ada1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4925,12 +4925,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		return;
 
 	context->mmu_role.as_u64 = new_role.as_u64;
-#ifdef CONFIG_RETPOLINE
-	/* Nullify ->page_fault() to use direct kvm_tdp_page_fault() call. */
-	context->page_fault = NULL;
-#else
 	context->page_fault = kvm_tdp_page_fault;
-#endif
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
 	context->update_pte = nonpaging_update_pte;

Paolo

