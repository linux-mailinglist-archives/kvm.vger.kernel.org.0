Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BF93F0E1B
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 00:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhHRWYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 18:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbhHRWYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 18:24:33 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE43C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 15:23:57 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id l11so2754930plk.6
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 15:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=63gVPEj1noUQl8SV7kXsZsczRwjyhAO39ZV+DC8YyRw=;
        b=pVOi6N+ypgp22caV5JNSMiXFyj+4Go0ociFoiwmYF1UKaigF81J/i++Qt6xgDm0fVZ
         0WOPkNXk72ny+7vUL5QIXYb4hH6U9Rst0RCj4UR6otmrtTG38yNbW30kXJ9bUQ1le8VJ
         bvergKmKhgpagDEnu/bataPp70vuy9xuZkXRbPbSfG6HAKosD4LRLt1TGZwQx8yGP5TA
         nBsRJyHkGbvCusf9+BK+HG6K6zdrCnOHoheePcgX7wUHJf9DdAQAku+kxAZmZd1B7roD
         WYksjgb5U+78tZo7OYG2QwTd2rfTY+LLll7qR6wrIerXFcxIyN6ZwgMCMRK3eSHthwPb
         d1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=63gVPEj1noUQl8SV7kXsZsczRwjyhAO39ZV+DC8YyRw=;
        b=ZovjE2j2nxXyVDafYC55xgtznx3hkXmOvpKm9qYl1MUz2H94Nc2KAFT+DlebSd6U+d
         qmSq1407+azX0PrP5GTJZvHsgHPBSXy8hDyLkP3hlyYWDFrhJHdKKfGGXfu8kWJlvhm3
         QUJs9gq2vv3K/eVnILSWVcLOstySBfbP6h4LTcbp3/EL+rKioefgHz2RmZeYMSKSSaFH
         6dF8TzIdUS8Wkr4sTNT2ZdibQjK8f68MAs5tC6Xth6HovbvOGxWFrQKArt8qhWHOB9n1
         JFaJPcbWycnh2nl1A6ldBsHnapni8tGdJlwWThlVtGMJ5z3xkgtGC+DHFafQF63tr6Jg
         LE+Q==
X-Gm-Message-State: AOAM531nktFm+2FNLVMjDecQ62SBcAkHNDhJvOo0z5JLc3YxAy9fCYWZ
        TO5uf5THvT/A3LhTfgwzBln+aw==
X-Google-Smtp-Source: ABdhPJxCx+/RS6MF5ihyo37JULjM2KZTV3oIxzdBgz6zLB/KlSw3We5F9hzFt40Bc0hsA8OKsBp1og==
X-Received: by 2002:a17:90b:3144:: with SMTP id ip4mr11327705pjb.42.1629325437205;
        Wed, 18 Aug 2021 15:23:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q3sm934192pgl.23.2021.08.18.15.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 15:23:56 -0700 (PDT)
Date:   Wed, 18 Aug 2021 22:23:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: kvm: Demote level of already loaded message from
 error to info
Message-ID: <YR2Id14e9kagM6u0@google.com>
References: <20210818114956.7171-1-pmenzel@molgen.mpg.de>
 <f9ba6fec-f764-dae7-e4f9-c532f4672359@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9ba6fec-f764-dae7-e4f9-c532f4672359@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021, Maciej S. Szmigiero wrote:
> On 18.08.2021 13:49, Paul Menzel wrote:
> > In scripts, running
> > 
> >      modprobe kvm_amd     2>/dev/null
> >      modprobe kvm_intel   2>/dev/null
> > 
> > to ensure the modules are loaded causes Linux to log errors.
> > 
> >      $ dmesg --level=err
> >      [    0.641747] [Firmware Bug]: TSC_DEADLINE disabled due to Errata; please update microcode to version: 0x3a (or later)
> >      [   40.196868] kvm: already loaded the other module
> >      [   40.219857] kvm: already loaded the other module
> >      [   55.501362] kvm [1177]: vcpu0, guest rIP: 0xffffffff96e5b644 disabled perfctr wrmsr: 0xc2 data 0xffff
> >      [   56.397974] kvm [1418]: vcpu0, guest rIP: 0xffffffff81046158 disabled perfctr wrmsr: 0xc1 data 0xabcd
> >      [1007981.827781] kvm: already loaded the other module
> >      [1008000.394089] kvm: already loaded the other module
> >      [1008030.706999] kvm: already loaded the other module
> >      [1020396.054470] kvm: already loaded the other module
> >      [1020405.614774] kvm: already loaded the other module
> >      [1020410.140069] kvm: already loaded the other module
> >      [1020704.049231] kvm: already loaded the other module
> > 
> > As one of the two KVM modules is already loaded, KVM is functioning, and
> > their is no error condition. Therefore, demote the log message level to
> > informational.

Hrm, but there is an error condition.  Userspace explicitly requested something
and KVM couldn't satisfy the request.

KVM is also going to complain at level=err one way or another, e.g. if a script
probes kvm_amd before kvm_intel on an Intel CPU it's going to get "kvm: no hardware
support", so this isn't truly fixing the problem.  Is the issue perhaps that this
particular message isn't ratelimited?

It's also easy for the script to grep /proc/cpuinfo, so it's hard to feel too
bad about the kludgy message, e.g. look for a specific vendor, 'vmx' or 'svm', etc...

if [[ -z $kvm ]]; then
    grep vendor_id "/proc/cpuinfo" | grep -q AuthenticAMD
    if [[ $? -eq 0 ]]; then
        kvm=kvm_amd
    else
        kvm=kvm_intel
    fi
fi


> Shouldn't this return ENODEV when loading one of these modules instead
> as there is no hardware that supports both VMX and SVM?

Probably not, as KVM would effectively be speculating, e.g. someone could load an
out-of-tree variant of kvm_{intel,amd}.  Maybe instead of switching to ENODEV,
reword the comment, make it ratelimited, and shove it down?  That way the message
and -EEXIST fires iff the vendor module actually has some chance of being loaded.

From 3528e66bd5107d5ac4f6a6ae50503cf64446866a Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Aug 2021 15:17:43 -0700
Subject: [PATCH] KVM: x86: Tweak handling and message when vendor module is
 already loaded

Reword KVM's error message if a vendor module is already loaded to state
exactly that instead of assuming "the other" module is loaded, ratelimit
said message to match the other errors, and move the check down below the
basic functionality checks so that attempting to load an unsupported
module provides the same result regardless of whether or not a supported
vendor module is already loaded.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fdc0c18339fb..15bd4bd3c81d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8357,12 +8357,6 @@ int kvm_arch_init(void *opaque)
 	struct kvm_x86_init_ops *ops = opaque;
 	int r;

-	if (kvm_x86_ops.hardware_enable) {
-		printk(KERN_ERR "kvm: already loaded the other module\n");
-		r = -EEXIST;
-		goto out;
-	}
-
 	if (!ops->cpu_has_kvm_support()) {
 		pr_err_ratelimited("kvm: no hardware support\n");
 		r = -EOPNOTSUPP;
@@ -8374,6 +8368,12 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}

+	if (kvm_x86_ops.hardware_enable) {
+		pr_err_ratelimited("kvm: already loaded a vendor module\n");
+		r = -EEXIST;
+		goto out;
+	}
+
 	/*
 	 * KVM explicitly assumes that the guest has an FPU and
 	 * FXSAVE/FXRSTOR. For example, the KVM_GET_FPU explicitly casts the
--
2.33.0.rc2.250.ged5fa647cd-goog


