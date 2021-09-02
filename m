Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E308D3FF413
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 21:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347367AbhIBTXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 15:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243832AbhIBTXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 15:23:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7C9C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 12:22:44 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n18so1832095plp.7
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 12:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uNPtW+6uA+IorMmx89tZvAje5LA6sRmLTggdZeiUpKQ=;
        b=DUPBVsET97fo8gZE+12RRIe3oBglmGvYRDpWjPC2p+hbEXLBsAYdQvDjInkq6gYd9W
         aD0keO3ba193KwUAVcMMcw+goFfB2DAN7bF6mvu7quwJ39X0u0GDdq6d0OOhIGbnCvNx
         jE0qJTjzRRm6E8cO1WHrwHdmnAAbN2EB+EIKY49b88wbvHWGVELVHCLjaPF8+CX3gjAG
         a4OToBU85qyLrfFq90ge6iKk8oVInT2Lj4C0lF3v/U7veqJLjRlG/5Jd9L1Rhtw1lTsU
         qi+PWSS7OrPNvrRmJQp/0Rnc2emt5+f/oh+VuZc/SgzPRcMJG/Qe1jrYCg1dxv07hOOU
         Ae6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uNPtW+6uA+IorMmx89tZvAje5LA6sRmLTggdZeiUpKQ=;
        b=doVj9kbUa84L8/kPCw/R6GszXBriznuTiKnkK2jXvXo0WZRvp95Qm5xt7dX1HINkpB
         A9sEfFHFCNSam0Qa7rwOjP8YU1NSnh86rOhQz4PsoqH2kyUbJ7YuSZFL/csGUmBD7HG1
         ccbAQOHdn/SB5sgQrFIcRh4EnM3Ck8hkVJsEXetNhkcO2mx0WPtXOKYPSRrqUJa+lGiD
         oJTfhDGWSEiqNnaKJUdmIvT6rsOV3NQVvEMXzVPP5d2YT4udzDlF+kq8aka24Q+FkIvA
         DCw86KxD4Qg4eQysS4sQqyiRwNlWlqSKr/0JwfRqK+HosSPn6yq8D4LAMfXRkTY8RAHr
         CWcA==
X-Gm-Message-State: AOAM531hAXyDThUkT6sIjvlLWLkIHRuMnRRvUoYvhETAh1HGTm2ylDfv
        MOOvZUVW4tQV/wq8e3fQujV3BQ==
X-Google-Smtp-Source: ABdhPJyA+Ul43RLuBvaJkLgS2mR6ljKmyKfNqIQzvT0/kC56lZBa3GlaBfo3GRItE1F4k7nstvQBhg==
X-Received: by 2002:a17:90a:ad02:: with SMTP id r2mr5529728pjq.182.1630610563431;
        Thu, 02 Sep 2021 12:22:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x75sm3674726pgx.43.2021.09.02.12.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:22:42 -0700 (PDT)
Date:   Thu, 2 Sep 2021 19:22:39 +0000
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
Subject: Re: [PATCH v7 4/6] KVM: x86: Take the pvclock sync lock behind the
 tsc_write_lock
Message-ID: <YTEkf3wn/PbVpYni@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816001130.3059564-5-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021, Oliver Upton wrote:
> A later change requires that the pvclock sync lock be taken while
> holding the tsc_write_lock. Change the locking in kvm_synchronize_tsc()
> to align with the requirement to isolate the locking change to its own
> commit.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/locking.rst | 11 +++++++++++
>  arch/x86/kvm/x86.c                 |  2 +-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> index 8138201efb09..0bf346adac2a 100644
> --- a/Documentation/virt/kvm/locking.rst
> +++ b/Documentation/virt/kvm/locking.rst
> @@ -36,6 +36,9 @@ On x86:
>    holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
>    there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
>  
> +- kvm->arch.tsc_write_lock is taken outside
> +  kvm->arch.pvclock_gtod_sync_lock
> +
>  Everything else is a leaf: no other lock is taken inside the critical
>  sections.
>  
> @@ -222,6 +225,14 @@ time it will be set using the Dirty tracking mechanism described above.
>  :Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
>  		migration.
>  
> +:Name:		kvm_arch::pvclock_gtod_sync_lock
> +:Type:		raw_spinlock_t
> +:Arch:		x86
> +:Protects:	kvm_arch::{cur_tsc_generation,cur_tsc_nsec,cur_tsc_write,
> +			cur_tsc_offset,nr_vcpus_matched_tsc}
> +:Comment:	'raw' because updating the kvm master clock must not be
> +		preempted.
> +
>  :Name:		kvm_arch::tsc_write_lock
>  :Type:		raw_spinlock
>  :Arch:		x86
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b1e9a4885be6..f1434cd388b9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2533,7 +2533,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
>  
>  	kvm_vcpu_write_tsc_offset(vcpu, offset);
> -	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  
>  	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
>  	if (!matched) {
> @@ -2544,6 +2543,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  
>  	kvm_track_tsc_matching(vcpu);
>  	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);

Drop the irqsave/irqrestore in this patch instead of doing so while refactoring
the code in the next patch.

> +	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  }
>  
>  static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
> -- 
> 2.33.0.rc1.237.g0d66db33f3-goog
> 
