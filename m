Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441B04700DC
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 13:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbhLJMpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 07:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbhLJMpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 07:45:35 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C5DC061746;
        Fri, 10 Dec 2021 04:42:00 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w1so29385322edc.6;
        Fri, 10 Dec 2021 04:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e+3kBKYd0gs8YdT/Y0LV1C8OqhIxbxJP+Wplk4g6xBE=;
        b=cO6r/sVyNXoUzeji7uong2FcLYTZxKa5aNR6uGV6MjIc0UprO3UlEijIrStbVSR0tj
         u1eY9j6/B/+8DWng0IzeutmNQIULYQqWh5296yK6iANqRhFkgaVpb7lfp2iof5gIpYBD
         ptX9BEwcB9C44B5cEEwwsNXwyN0HKGmdU2YV9d6iATkG6xZ5FJKb/zECZVo553UETtgN
         mbz9HIb67AFkS2a+8wp1t+SXhUY8BaMH8yPnm0DebD8zLb/QXJS7kxvz/9JPuTACTgUt
         5FrxJ8/dHCwI+YSRDr0Jp3Q8LnW7s9FP9FCA/nUYFBqY2PVy6jFcEbtLzhCllt6LFo9A
         2U1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e+3kBKYd0gs8YdT/Y0LV1C8OqhIxbxJP+Wplk4g6xBE=;
        b=aJpTYQGaNyebrI4nqnjHTOrntdyASkSCw6gkjUWHEEN7HUqE2T86w8QS5sm13qFBCm
         +qdZu7NMgsiazKpsdtlJfzIhWpED2xzmhU7b7gUUqQ04H6Hkd8u2TM/0k3Nzk+I4a6XT
         PQ0XE4RUtOcS1tPuyg1fK9qBzcMCjQLs8vAW7/l/rGaVCHm2taZ/v1kqqcWEJMLJ3JG8
         7ECekHNt53/MxTujApgSyqOc7/7X+o+IQhD+dIo+4QWZP2moOS2ORkx3LwOk6jdFlB4O
         hFzUyYb2VhmsfYYwQVYMKzBSqEc5FJni/BMGF8t+9PGJF3oHAPLEuMXjNBO1d+16+mud
         o8+g==
X-Gm-Message-State: AOAM532qcO5iEVqifxAGorxDm36B6Lv1PQNkdeDh0NyfgyUziw7Ma5OD
        WMIQWo9sDx6yfbcRbvM2Me2XLeN9UV8=
X-Google-Smtp-Source: ABdhPJxFH9UXDm/WjBpC0VjnpTeUtlGTtiT3mJa7S2K8w5HUCflcNaSGfIfUOMtaGnrY+zVJuWQuJQ==
X-Received: by 2002:a05:6402:254f:: with SMTP id l15mr36668875edb.12.1639140118979;
        Fri, 10 Dec 2021 04:41:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id g15sm1440029ejt.10.2021.12.10.04.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 04:41:58 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <c94b3aec-981e-8557-ba29-0094b075b8e4@redhat.com>
Date:   Fri, 10 Dec 2021 13:41:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/7] KVM: x86: Retry page fault if MMU reload is pending
 and root has no sp
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <20211209060552.2956723-1-seanjc@google.com>
 <20211209060552.2956723-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211209060552.2956723-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 07:05, Sean Christopherson wrote:
> +	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
> +	if (sp && is_obsolete_sp(vcpu->kvm, sp))
> +		return true;
> +
> +	/*
> +	 * Roots without an associated shadow page are considered invalid if
> +	 * there is a pending request to free obsolete roots.  The request is
> +	 * only a hint that the current root_may_  be obsolete and needs to be
> +	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
> +	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
> +	 * to reload even if no vCPU is actively using the root.
> +	 */
> +	if (!sp && kvm_test_request(KVM_REQ_MMU_RELOAD, vcpu))
>   		return true;

Hmm I don't understand this (or maybe I do and I just don't like what I
understand).

KVM_REQ_MMU_RELOAD is raised after kvm->arch.mmu_valid_gen is fixed (of
course, otherwise the other CPU might just not see any obsoleted page
from the legacy MMU), therefore any check on KVM_REQ_MMU_RELOAD is just
advisory.

This is not a problem per se; in the other commit message you said,

     For other MMUs, the resulting behavior is far more convoluted,
     though unlikely to be truly problematic.

but it's unnecessarily complicating the logic.  I'm more inclined to
just play it simple and make the special roots process the page fault;
Jiangshan's work should clean things up a bit:

--------- 8< -------------
 From 0c1e30d4e7e17692668d960452107f983dd2c9a9 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 10 Dec 2021 07:41:02 -0500
Subject: [PATCH] KVM: x86: Do not check obsoleteness of roots that have no sp
  attached

The "special" roots, e.g. pae_root when KVM uses PAE paging, are not
backed by a shadow page.  Running with TDP disabled or with nested NPT
explodes spectaculary due to dereferencing a NULL shadow page pointer.
Play nice with a NULL shadow page when checking for an obsolete root in
is_page_fault_stale().

Fixes: a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Analyzed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2e1d012df22..4a3bcdd3cfe7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3987,7 +3987,17 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
  static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
  				struct kvm_page_fault *fault, int mmu_seq)
  {
-	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
+	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root_hpa);
+
+	/*
+	 * Special roots, e.g. pae_root, are not backed by shadow pages
+	 * so there isn't an easy way to detect if they're obsolete.
+	 * If they are, any child SPTE created by the fault will be useless
+	 * (they will instantly be treated as obsolete because they don't
+	 * match the mmu_valid_gen); but they will not leak, so just play
+	 * it simple.
+	 */
+	if (sp && is_obsolete_sp(vcpu->kvm, sp))
  		return true;
  
  	return fault->slot &&
