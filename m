Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A09E7AB62F
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjIVQli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjIVQlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:41:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361B9196
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:41:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81d85aae7cso93561276.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695400890; x=1696005690; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jHa3naU1XzxEBhK7V3RItz2lj4bCVrBUNq4F0vxDu+A=;
        b=QJdPdeIyYt5wEH51jj0ES32JUFakKXL6TUmQV6k3EPwjwT8wx7J3iMNYnxn2MoLdC0
         NJcS+7OUWh+e/9p6dJ7iWcYw4/vbcxaXAVPX9Aog4qIAEGMvNTmCC1e4AuV33Qp2yyl5
         D30gxWZkNM3Qi5IjWRsUVkd9/LhjYe7BsYW//ysrDP84/aoP+xBeroPQEKlyUHL329OE
         mxARoFFql/y5sMxkO5fAwe3cMnXqdIyqHDFOtUTJC/sh2rH87kUeC65v6pDfKc/2+xWq
         Rqxn1sNPlxrkZ1aBJbkKlIfLH9j5wonO+6mAzgFaRZLjMWYDD/JY10Z+r0VNclEDImlD
         tkIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695400890; x=1696005690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jHa3naU1XzxEBhK7V3RItz2lj4bCVrBUNq4F0vxDu+A=;
        b=j+GF2aM1vPevgwgquP3jf5dR2aQJT/ddsEN5Ai+VjGz8BZDsQxK1hIURpEhfi/TKCn
         /Z1mkq+gibOqEpAHJ1+8XXvwvYqEbIALtonmWlRb+2AR8bhjq4GMYEjA/zSFA6VOI5IG
         qQ2lBaSY6zv6eDxdr4KhssrRcnUvHdhLqCHhJeFdBF3Jax4S3m29lG72pxinLQo0rHI2
         1ZfotUUwtOK8QCinhOwkT94Tcv5C8hEeJX93yZTkGcZdEG+pbJHjOyiVZbnkatxde7QM
         GiLgvbBldp2L6w1tHFxZp4oFXhsDDPvmAPsAoSAYOgZod0Q6wCAldL3xNE5bR58FZv8G
         01Qw==
X-Gm-Message-State: AOJu0Yz3KS9RB23jvVqI5cOXrqVciZ+q0cx7l8VQm6464h55mR/IAp2P
        E4uE8G/EF6fJtKEWdfIkyDyKU+JVZvY=
X-Google-Smtp-Source: AGHT+IEfj6LfUD9ppAnMo5t0SipvGgdfUvx/5/AzTlfYReFo6QlHzVGaWmM4CAe+wZc+p0lFdkNIMevEiPE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a2c7:0:b0:d77:fb00:b246 with SMTP id
 c7-20020a25a2c7000000b00d77fb00b246mr54465ybn.1.1695400890443; Fri, 22 Sep
 2023 09:41:30 -0700 (PDT)
Date:   Fri, 22 Sep 2023 09:41:28 -0700
In-Reply-To: <20230921114940.957141-1-pbonzini@redhat.com>
Mime-Version: 1.0
References: <20230921114940.957141-1-pbonzini@redhat.com>
Message-ID: <ZQ3DuFZNFXNWqlbz@google.com>
Subject: Re: [PATCH] x86/cpu: clear SVM feature if disabled by BIOS
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023, Paolo Bonzini wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f283eb47f6ac..7b91efb72ea6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -531,8 +531,6 @@ static bool __kvm_is_svm_supported(void)
>  	int cpu = smp_processor_id();
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
>  
> -	u64 vm_cr;
> -
>  	if (c->x86_vendor != X86_VENDOR_AMD &&
>  	    c->x86_vendor != X86_VENDOR_HYGON) {
>  		pr_err("CPU %d isn't AMD or Hygon\n", cpu);
> @@ -549,12 +547,6 @@ static bool __kvm_is_svm_supported(void)
>  		return false;
>  	}

Hidden in here is

	if (!cpu_has(c, X86_FEATURE_SVM)) {
		pr_err("SVM not supported by CPU %d\n", cpu);
		return false;
	}

which will be technically wrong and potentially misleading when SVM is disabled
by BIOS, but supported by the CPU.  We should do the same thing that VMX does
and manually query CPUID to check "is SVM supported", and then rely on cpu_has()
for the "is SVM supported _and_ enabled".  E.g.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f283eb47f6ac..9bcd8aad28d7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -539,22 +539,21 @@ static bool __kvm_is_svm_supported(void)
                return false;
        }
 
-       if (!cpu_has(c, X86_FEATURE_SVM)) {
+       if (!(cpuid_ecx(0x80000001) & feature_bit(SVM))) {
                pr_err("SVM not supported by CPU %d\n", cpu);
                return false;
        }
 
+       if (!cpu_has(c, X86_FEATURE_SVM)) {
+               pr_err("SVM disabled (by BIOS) in MSR_VM_CR on CPU %d\n", cpu);
+               return false;
+       }
+
        if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
                pr_info("KVM is unsupported when running as an SEV guest\n");
                return false;
        }
 
-       rdmsrl(MSR_VM_CR, vm_cr);
-       if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE)) {
-               pr_err("SVM disabled (by BIOS) in MSR_VM_CR on CPU %d\n", cpu);
-               return false;
-       }
-
        return true;
 }
