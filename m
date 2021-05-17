Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02CA386C3D
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 23:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbhEQV15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 17:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhEQV15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 17:27:57 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540F8C061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 14:26:40 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id a11so3904223plh.3
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 14:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dhb1uTVRdTSDSDqMMsX7uuUg8xt1a4Se/9Ofk8WS2vY=;
        b=Y+CnDpzs3ikZKam2vkznv3FYm9jlSBtByhLjS+j+lNsS84Tnmcv0zsiaV0Uiuvf5T5
         +G4u0N2NKEoRNYoggemPLimodzLgYMqH+Gl/i6aKozHmVoTiL0klsgLLkLPD6D8TzLhc
         E2FWpJAYDWCl0AHvdq/ZFcO1sGpglEMLu00uHxUHrhXkOVpvBB/zKcua7pGj+q4nVuq+
         Pm9mOdDWTE2xLxb1KmAdzxqJCw6ssR82sKJiBrYGsUexh3LdytZCHRJa5B3YG+Dj/14c
         k51fwtedyZzgeLi/m8uDyquwXAELz874WwZ2ezpetcxXKsDCIWcWwSNHeW/qIKCB+juu
         mF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dhb1uTVRdTSDSDqMMsX7uuUg8xt1a4Se/9Ofk8WS2vY=;
        b=Ef88PlRdW0wSRsgQLLX5ZK8+x0ZTZjWDCiZI8uUDA7YcJ240E77gM/iK1TEojUPnJ9
         9Y8ncdKG1UBVdO0GjU07dxwXDO3R1FYETtybYk+YRl8YF2IwMhPXVu4dL0XINydBG4JD
         sHOEtsQuSBMY5YV8ob6v6Oz14ooLnRSfkznXw+i5BTNYOnXOOdq9epEDWuPopJIHdQ3c
         RlIbpN+y5FiFXABE0RvC4PKbstTpAyH3t0N/Z3NqPTwi/OqYbIZSwBQlX5HE6ts7tW9z
         B4u6u6FyvdP4LlIJBNSr4XmiOpv3sfpRp8Uc5X6wetcBlkolz/7XAppXJ5BnbhcFkXLK
         K4RQ==
X-Gm-Message-State: AOAM530XzmUM1Gf4qdHTs8ulXvte0abFf0MeAGDX49bpTbHi+0lLjwhG
        phou7tUKyzjgHEATDe5H7dxYJQ==
X-Google-Smtp-Source: ABdhPJysVdDoDestSBDLBZRxY7hfIZLLWozeiiMqnT2Nf93oFJudVtNcA3f2Ij1/+l8OsbqXR2J8JQ==
X-Received: by 2002:a17:90a:aa96:: with SMTP id l22mr1119473pjq.173.1621286799769;
        Mon, 17 May 2021 14:26:39 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c191sm2637624pfc.94.2021.05.17.14.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 14:26:39 -0700 (PDT)
Date:   Mon, 17 May 2021 21:26:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kechen Lu <kechenl@nvidia.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86: Invert APICv/AVIC enablement check
Message-ID: <YKLfi4Xn95hDefgH@google.com>
References: <20210513113710.1740398-1-vkuznets@redhat.com>
 <20210513113710.1740398-2-vkuznets@redhat.com>
 <YKLaKV5Z+x30iNG9@google.com>
 <CALMp9eSR3tAZx3iW4_aVRWtFvVma-NYC979SDG5z3MG-F4M5dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSR3tAZx3iW4_aVRWtFvVma-NYC979SDG5z3MG-F4M5dw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021, Jim Mattson wrote:
> On Mon, May 17, 2021 at 2:03 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, May 13, 2021, Vitaly Kuznetsov wrote:
> > > Currently, APICv/AVIC enablement is global ('enable_apicv' module parameter
> > > for Intel, 'avic' module parameter for AMD) but there's no way to check
> > > it from vendor-neutral code. Add 'apicv_supported()' to kvm_x86_ops and
> > > invert kvm_apicv_init() (which now doesn't need to be called from arch-
> > > specific code).
> >
> > Rather than add a new hook, just move the variable to x86.c, and export it so
> > that VMX and SVM can give it different module names.  The only hiccup is that
> > avic is off by default, but I don't see why that can't be changed.
> 
> See https://www.spinics.net/lists/kvm/msg208722.html.

Boo.  A common enable_apicv can still work, SVM just needs an intermediary
between the module param and enable_apicv.

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -185,6 +185,10 @@ module_param(vls, int, 0444);
 static int vgif = true;
 module_param(vgif, int, 0444);

+/* enable / disable AVIC */
+static bool avic;
+module_param(avic, bool, S_IRUGO);
+
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);

@@ -1009,16 +1013,19 @@ static __init int svm_hardware_setup(void)
                        nrips = false;
        }

-       if (avic) {
-               if (!npt_enabled ||
-                   !boot_cpu_has(X86_FEATURE_AVIC) ||
-                   !IS_ENABLED(CONFIG_X86_LOCAL_APIC)) {
-                       avic = false;
-               } else {
-                       pr_info("AVIC enabled\n");
+       if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
+               avic = false;

-                       amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-               }
+       /*
+        * Override the common enable_apicv.  AVIC is disabled by default
+        * because Jim said so.
+        */
+       enable_apicv = avic;
+
+       if (enable_apicv) {
+               pr_info("AVIC enabled\n");
+
+               amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
        }

        if (vls) {
