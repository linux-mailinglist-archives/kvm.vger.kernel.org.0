Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64F665DCF7
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 20:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbjADTkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 14:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbjADTkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 14:40:19 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33B3BF4
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 11:40:18 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cp9-20020a17090afb8900b00226a934e0e5so1710501pjb.1
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 11:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=78Xud8uaBV6HMH18sEo7KX+Q7S8hBzv9DwytUiPzVXc=;
        b=blRiiJyMG0QFf70ZcWAtGacCvsBwciLVCQXLdhc8+vV0GBhpFeCDB3/S4HgskxMRvn
         gvTjkfb32S6N6NG7A4JBQevbxu7rMxkYBb2zFwAvw4E+p3fOHPbrWy30Do3VXuLWEkDp
         fzU47nn8DJ3DY4bC7my3tkw+A0pW69PPrqidvOyBwPvSLCS7pafZpG6x3aEyW7nmuVWk
         1y8xd6cue/C2L3r08VxPGtoDqMgLmoliw1KjwZEkmb62ipIMX+ewkYPQweuI1/OGOVDm
         F60F7L/T8EDwJdlUWERfFsuhyUukQVLbQ7CABuIFOjts5/i339sIvS//3ti04ZGUNwdz
         L2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78Xud8uaBV6HMH18sEo7KX+Q7S8hBzv9DwytUiPzVXc=;
        b=a2afAl26XmRTE0ZnGcYCTFDHpCFgTaWeJJ/4Fv2/gyOW+Qk5PoRAhMtI0T0bYPP9hu
         nWytOEKXUEheY1MdyBv6tSdl2/FMHVXQtDROdwT02aUQ0d6PQjzRDQkD9RpwAkVEAEnJ
         6jNuv6VSFtu/uRX6o2LYuu/aKrMs+MWT8inf9ECTVI9AYasNvjN0W3Do9mpO4fuZM8ps
         KLJAyKaU5ABg1nEptQpRJRCUirT65is7gnLg86R3r1LRhM8PC5K4/y4rD+s4vldoFbOc
         XuGmAGRXva/TZEZCZV/VauqqbJTiyfsNSWMo7zKoCF9mPhlPtniI8KL/KbIlajnmif60
         JRvg==
X-Gm-Message-State: AFqh2kqXLT08+cxDAgUs5UdgspSUJ8MHwZurMnjsKljIhBsiuI4DF4mc
        Hoz4pgRXMs5+EjJcgbh6UytJmQ==
X-Google-Smtp-Source: AMrXdXsH095EcaGEvfVVviy/+4gQ6bUYk6ez6u38GKfOav+N0EC7dY+ovj6RpVZufmNIKRdZf/KeSQ==
X-Received: by 2002:a05:6a20:7f59:b0:ac:af5c:2970 with SMTP id e25-20020a056a207f5900b000acaf5c2970mr3251490pzk.3.1672861218316;
        Wed, 04 Jan 2023 11:40:18 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 11-20020a63050b000000b0049b7b1205a0sm14393894pgf.54.2023.01.04.11.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 11:40:17 -0800 (PST)
Date:   Wed, 4 Jan 2023 19:40:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v6 2/2] KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info)
 sub-leaves, if present
Message-ID: <Y7XWHr1kb4AHd4Lv@google.com>
References: <20221220134053.15591-1-pdurrant@amazon.com>
 <20221220134053.15591-3-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220134053.15591-3-pdurrant@amazon.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022, Paul Durrant wrote:
> @@ -143,6 +148,8 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
>  #include <asm/xen/interface.h>
>  #include <xen/interface/vcpu.h>
>  
> +#define XEN_SIGNATURE "XenVMMXenVMM"

arch/x86/include/asm/xen/hypervisor.h also open codes the signature.  Rather than
add a KVM-specific define, what about putting in xen/cpuid.h?  (I've had a version
of this series sitting in my todo pile for far too long, sorry).

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 11 Jul 2022 15:18:42 -0700
Subject: [PATCH] xen: Add a #define to provide Xen's CPUID signature as a
 string

Add XEN_SIGNATURE instead of open coding it in xen_cpuid_base() so
that KVM can reuse the definition when querying a VM's CPUID.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/xen/cpuid.h      | 1 +
 arch/x86/include/asm/xen/hypervisor.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/xen/cpuid.h b/arch/x86/include/asm/xen/cpuid.h
index 6daa9b0c8d11..38f1bd153f42 100644
--- a/arch/x86/include/asm/xen/cpuid.h
+++ b/arch/x86/include/asm/xen/cpuid.h
@@ -49,6 +49,7 @@
  * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
  *      of a Xen host.
  */
+#define XEN_SIGNATURE     "XenVMMXenVMM"
 #define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
 #define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
 #define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 16f548a661cf..32ff6583b3d9 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -37,10 +37,11 @@ extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
 #include <asm/processor.h>
+#include <asm/xen/cpuid.h>
 
 static inline uint32_t xen_cpuid_base(void)
 {
-	return hypervisor_cpuid_base("XenVMMXenVMM", 2);
+	return hypervisor_cpuid_base(XEN_SIGNATURE, 2);
 }
 
 struct pci_dev;

base-commit: 91dc252b0dbb6879e4067f614df1e397fec532a1
-- 
