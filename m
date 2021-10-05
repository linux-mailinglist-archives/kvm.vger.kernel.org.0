Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E796F422C4B
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 17:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbhJEPYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 11:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhJEPYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 11:24:34 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6887C061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 08:22:43 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 133so20112207pgb.1
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 08:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jsoEJt9R8crAH2RcsfBnQLCdcmXo4iVFPCHH8skN9hQ=;
        b=Ed27JI5WdcMBjzCmHglgYbPkFapHRW8VivzST0erYb/L/PV6Fx0rpTBNDt1223jRVb
         eQ5IVgSRDi5VCqGDiJM5A7rbcPMvwg6w1jg0wDhDNxogy7g8tXHb5gAQu3MkQZ4aTk9Q
         D+35shvAdiTeBDH9W72MNR7F3tUnMUT8t+zTm8lCHdonVdqfrCyFpDQ97vP6AwGRNn/X
         GOqBrTVYIjZiBhdOV7etEqYr4+lx5qlCy7z4mzvugVDQwWWAnXWWM9Dac9u4kMeqF4o0
         q66/1KN+gVVuBQ71H+9jz7Qi8kNlcIq5g+ueK+T83d6rxeradLUvtNWie9PUJyUcAjyk
         VesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jsoEJt9R8crAH2RcsfBnQLCdcmXo4iVFPCHH8skN9hQ=;
        b=Hi7CUDBy7GKODqUNE5YVHPB7vl8uDT0ePfVMJ64W3z8nso5/ONLB6KWXvpk0vyHZK+
         alLqEjKAbTZOlE00UT/t0aWmpzq/E6EqgN+IKoZCSqDua0QcfUOG5V2vOo7Bp+Hnd1z8
         SYNA2kRE+h649rmgiETCglq+rtqG/rI1D5ykuGeOjC+FDm3ttVeKBMaOuoZv9vDPo5D1
         CVbMGWQ/mJyInmvyOqyaLY+aEfb1s7kD562Fvt70DuHUBsB77Aw8qbnbVI/3UyK98psH
         P1zQ29/ePYV9EByzCMadjtAo9yWkG8r056E3jsmzy8jnjztf4x+hqRSJmO+T0gkBeG+n
         9XaA==
X-Gm-Message-State: AOAM5306zSlIKsrU8b3xhpMaGLIXYmF+JzCsAPH+yNFSIhmZ6tKhpwSC
        POe596pe9Ur0EAU2NMdQxk0ugA==
X-Google-Smtp-Source: ABdhPJyd+BrY951cMRvWU+Hdnw02yUD1081dLTCog2uFgukEdDRDWflW+t6MGsO3nWUcqCgRuybMcw==
X-Received: by 2002:a62:b50d:0:b0:44b:b81f:a956 with SMTP id y13-20020a62b50d000000b0044bb81fa956mr30655368pfe.27.1633447363159;
        Tue, 05 Oct 2021 08:22:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z2sm6907837pfe.210.2021.10.05.08.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 08:22:42 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:22:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
Message-ID: <YVxtvx3IJ5g1SG+x@google.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210916181538.968978-8-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021, Oliver Upton wrote:
> +static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr = (u64 __user *)attr->addr;

...

> +static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr = (u64 __user *)attr->addr;

These casts break 32-bit builds because of truncating attr->addr from 64-bit int
to a 32-bit pointer.  The address should also be checked to verify bits 63:32 are
not set on 32-bit kernels.

arch/x86/kvm/x86.c: In function ‘kvm_arch_tsc_get_attr’:
arch/x86/kvm/x86.c:4947:22: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
 4947 |  u64 __user *uaddr = (u64 __user *)attr->addr;
      |                      ^
arch/x86/kvm/x86.c: In function ‘kvm_arch_tsc_set_attr’:
arch/x86/kvm/x86.c:4967:22: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
 4967 |  u64 __user *uaddr = (u64 __user *)attr->addr;
      |                      ^


Not sure if there's a more elegant approach than casts galore?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e5e462ffd65..3930e5dcdf0e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4944,9 +4944,12 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
 static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
                                 struct kvm_device_attr *attr)
 {
-       u64 __user *uaddr = (u64 __user *)attr->addr;
+       u64 __user *uaddr = (u64 __user *)(unsigned long)attr->addr;
        int r;

+       if ((u64)(unsigned long)uaddr != attr->addr)
+               return -EFAULT;
+
        switch (attr->attr) {
        case KVM_VCPU_TSC_OFFSET:
                r = -EFAULT;
@@ -4964,10 +4967,13 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
 static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
                                 struct kvm_device_attr *attr)
 {
-       u64 __user *uaddr = (u64 __user *)attr->addr;
+       u64 __user *uaddr = (u64 __user *)(unsigned long)attr->addr;
        struct kvm *kvm = vcpu->kvm;
        int r;

+       if ((u64)(unsigned long)uaddr != attr->addr)
+               return -EFAULT;
+
        switch (attr->attr) {
        case KVM_VCPU_TSC_OFFSET: {
                u64 offset, tsc, ns;
