Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09EB4A81F5
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 10:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349923AbiBCJvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 04:51:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236063AbiBCJvy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 04:51:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643881914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QK7QeelnBgMuLDC5Mt99kveOzip384EfbthyE/YqvhQ=;
        b=cCi7cc/R323hupEPnQRY/c6n/xKl8eqdslc8iYdSnzX5wHEWNSggnpcDWDeSutJFxMcgwK
        RYaeGm/kWdP27FojTmd29XghPT3I56dYxFCB/O7ztHZ/h2AsB7xEkgdb63x0/rDdMLZXbS
        hVDCFfO/IlS/qsoTy3I8GHUJOaelD4s=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-1g-aMyahM1iobOCBAkW7tA-1; Thu, 03 Feb 2022 04:51:52 -0500
X-MC-Unique: 1g-aMyahM1iobOCBAkW7tA-1
Received: by mail-ej1-f72.google.com with SMTP id fx12-20020a170906b74c00b006bbeab42f06so935460ejb.3
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 01:51:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QK7QeelnBgMuLDC5Mt99kveOzip384EfbthyE/YqvhQ=;
        b=zLEJwnppPlLghVLpo1sLLk2aWcX0kVZazKog+rxEXxz7bUTnMqqW+XBEsHxHSM8TQx
         E9UijjubLDHV4JmNKQI706FCyc+ZzinORZDZnJecKRZANYH1uQnwVgwgG7cc6GQP4fEL
         mydM3J5meJAalbk5r0KDS5jRUJvxAWt4ze4KDfsWkdbLOoXF9+peR+siGS1xiHQxMzdN
         6qZFeBk16vmuhAVtUAvmNuMdW+7JXAJLaw1TJYdXFpcr/q659nKmrj/BfjiD2jySjCsQ
         7Dnlf4lR6sA8sG+KZRdyfisE5OMpq0IU05ZmyGUxDb4KMdD+DWsjWGQcS8/ZPnL08WlT
         vK4Q==
X-Gm-Message-State: AOAM530bGErnDkBAj2cid2L3m+4iAHeFSRvuchVQWf/luvd7x1uljKHI
        oiktraN2KJdA3wxUVWq6L/ECSY7KnlyIQ6lKbWGBpXlr4Yitb6Ergwl4IZN29XAp4qOH/TN86k+
        I1p8SMwFX0u5V
X-Received: by 2002:aa7:c6c8:: with SMTP id b8mr34787595eds.392.1643881911533;
        Thu, 03 Feb 2022 01:51:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/idJWteG3a2i4lVifO74FtI/xr/NVTP5oo/QwQcQFsQSvQVVdEMI4k/TDJkIvwi541lQNJw==
X-Received: by 2002:aa7:c6c8:: with SMTP id b8mr34787584eds.392.1643881911408;
        Thu, 03 Feb 2022 01:51:51 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bx18sm18752074edb.93.2022.02.03.01.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 01:51:50 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: SVM: nSVM: Implement Enlightened MSR-Bitmap
 for Hyper-V-on-KVM
In-Reply-To: <429afd81-7bef-8ead-6ca4-12671378d581@redhat.com>
References: <20220202095100.129834-1-vkuznets@redhat.com>
 <429afd81-7bef-8ead-6ca4-12671378d581@redhat.com>
Date:   Thu, 03 Feb 2022 10:51:49 +0100
Message-ID: <87czk4b7m2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 2/2/22 10:50, Vitaly Kuznetsov wrote:
...
>>    KVM: nSVM: Implement Enlightened MSR-Bitmap feature
...
>
> Queued, thanks.

While writing a selftest for the feature, I've discovered an embarassing
bug: in nested_svm_vmrun_msrpm() I check bit number instead of bit
mask. It worked in testing by pure luck, it seems genuine Hyper-V sets
some other clean fields simultaneously.

Would it be possible to squash the attached patch in? Thanks!

I'll be sending out selftests shortly.

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-KVM-nSVM-Fix-the-check-for-VMCB_HV_NESTED_ENLIGHTENM.patch

From cfb538876ccc59dade7cadde553863bea8312f90 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Thu, 3 Feb 2022 10:22:30 +0100
Subject: [PATCH] KVM: nSVM: Fix the check for VMCB_HV_NESTED_ENLIGHTENMENTS
 bin in nested_svm_vmrun_msrpm()

VMCB_HV_NESTED_ENLIGHTENMENTS (VMCB_SW) is a bit number, not a bit mask.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7b26a4b518f7..7acf4f2aa445 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -188,7 +188,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	if (!svm->nested.force_msr_bitmap_recalc &&
 	    kvm_hv_hypercall_enabled(&svm->vcpu) &&
 	    hve->hv_enlightenments_control.msr_bitmap &&
-	    (svm->nested.ctl.clean & VMCB_HV_NESTED_ENLIGHTENMENTS))
+	    (svm->nested.ctl.clean & BIT(VMCB_HV_NESTED_ENLIGHTENMENTS)))
 		goto set_msrpm_base_pa;
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
-- 
2.34.1


--=-=-=--

