Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F4725ADB8
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgIBOrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 10:47:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52725 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726173AbgIBONE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 10:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599055983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+SlazSrbBYVrkGDDfctr1NZcX102DoU/4jHmOlehDKs=;
        b=f7++PhQK4XLaQyIsvo69iiHJ8AFE+WjvM8+CkJELiLWgBQwUbCiLA2Aa0zRTIV+sEr7BPC
        q7Aj5wo7+byIP6y6jtQaUu0vk5atxxhkB+fLfoHzQEE7CvhEg+AAQbV5SPjkJjCYLhYe3X
        CWaDeQ3sM+DRWaSpcUwfDaUEVHVNiLo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-KqL5LNM7P2mV3FndMs5icQ-1; Wed, 02 Sep 2020 10:13:00 -0400
X-MC-Unique: KqL5LNM7P2mV3FndMs5icQ-1
Received: by mail-wr1-f69.google.com with SMTP id 3so2117415wrm.4
        for <kvm@vger.kernel.org>; Wed, 02 Sep 2020 07:13:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+SlazSrbBYVrkGDDfctr1NZcX102DoU/4jHmOlehDKs=;
        b=pEigZyXfesJFjZhU+OqKq6uiDbnnjJxK0vGIykezR2K3d7Aa1/FFfQxvrbukM5D0DS
         UJKildqYIs4LcQXYyjdk6MAgS68k10rBNNFGS08LLFCjzM0u9Yb1EE3QUOrb/DK03v/m
         ElxHcYgLY00UXKnVwIbDeKwDex8tBlCKtkX9BboCurhaY/RZ0VJpR4T5lcQA5BLUrqKr
         WSVozJ63g06QShdkAgCgnQ1Fmp0LUv9JL3bm7zthMYkZ9qkWrf9bVhBRwABgq8lORX44
         CupTmO0izxY/4UhPSteElnYjB09PCAl5wWvFtdmMBHMpwSSNfPFrrXXWFvp7G0p1x4Oh
         Enew==
X-Gm-Message-State: AOAM533tdiOtjNq7GAhzhLnglzy5NIyXrl90TmS+uYPrKUOyVJvkH3tV
        Ux+u+xULHRRbfWAk/4B2B7JLChsjrCXVB4+DWhXLH5YahzzLAhY/72r9Tpvgl7gKdOouzbBTEAU
        ekOMtEyNgGDW2
X-Received: by 2002:adf:e610:: with SMTP id p16mr7928659wrm.71.1599055978758;
        Wed, 02 Sep 2020 07:12:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxXtyvuCzBi/izdiadlCE9hj/SCj7ZzU6crCLAPok8THyns5DedtXVkwYAbCi73bOsWypnPw==
X-Received: by 2002:adf:e610:: with SMTP id p16mr7928622wrm.71.1599055978525;
        Wed, 02 Sep 2020 07:12:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a85sm7218993wmd.26.2020.09.02.07.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:12:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH V2] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
In-Reply-To: <20200902135421.31158-1-jiangshanlai@gmail.com>
References: <87y2ltx6gl.fsf@vitty.brq.redhat.com> <20200902135421.31158-1-jiangshanlai@gmail.com>
Date:   Wed, 02 Sep 2020 16:12:55 +0200
Message-ID: <871rjkp8rc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lai Jiangshan <jiangshanlai@gmail.com> writes:

> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> When kvm_mmu_get_page() gets a page with unsynced children, the spt
> pagetable is unsynchronized with the guest pagetable. But the
> guest might not issue a "flush" operation on it when the pagetable
> entry is changed from zero or other cases. The hypervisor has the 
> responsibility to synchronize the pagetables.
>
> The linux kernel behaves as above for many years, But
> 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)

Nit: checkpatch.pl complains here with 

ERROR: Please use git commit description style 'commit <12+ chars of
sha1> ("<title line>")' - ie: 'commit 8c8560b83390 ("KVM: x86/mmu: Use
KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes")'
#118: 
8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)

> inadvertently included a line of code to change it without giving any
> reason in the changelog. It is clear that the commit's intention was to
> change KVM_REQ_TLB_FLUSH -> KVM_REQ_TLB_FLUSH_CURRENT, so we don't
> unneedlesly flush other contexts but one of the hunks changed
> nearby KVM_REQ_MMU_SYNC instead.
>
> The this patch changes it back.
>
> Link: https://lore.kernel.org/lkml/20200320212833.3507-26-sean.j.christopherson@intel.com/
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from v1:
> 	update patch description
>
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4e03841f053d..9a93de921f2b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2468,7 +2468,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  		}
>  
>  		if (sp->unsync_children)
> -			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>  
>  		__clear_sp_write_flooding_count(sp);

FWIW, 

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

but it'd be great to hear from Sean).

-- 
Vitaly

