Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D3E21D31F
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 11:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgGMJr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 05:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgGMJr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 05:47:56 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F79C061755
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 02:47:56 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so12530438wmh.2
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 02:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wU36Y0dkg3gAVd6d1AcAnpID0ooqTkwf12/Wn37dSh8=;
        b=A7ZsCQpbegT8axsNvUlyF9UT89ZbeiGiZkLrgxw1YmwTLxFMJeSBX5PVPDvwemiCQf
         +xdOx4uXQ04sxIVCK4z4DHESzUOUwvxMl1Pbr2+u1DqVXylIXHlVdC9tQ8cu4q2bMAkp
         3wcfRjrV8MULjMq8vbKugMS7E27X5BQMVf3Gk7wUolkk8AQHn380jLXMJcIFP+iHcONA
         wF86WUEtjwWADcagCLRleHr0e33uzB5lqVIMz3Q7LzU4PjbEaF6qRmFAEMcxtiKTvCaW
         lbrWyFdP56eeGYvwuHdtddQQo1T2XJL+8FS5TzY3Ak5EL5I/kkTT71VshclQHeN7BbpE
         25RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wU36Y0dkg3gAVd6d1AcAnpID0ooqTkwf12/Wn37dSh8=;
        b=aAPeff7pgs9RFn1Iil2bzGol4rU9lCY1WystWNoK5btNunujCG3YcsoMLAtfV8bjSY
         viPcveh+hL0QHP3dLYMxODtjFUJJ6lJjcVgLXEbhMCPTbqZstkhXrph515i2tjCd6J6O
         cUYBfBre93N1wyDW9BuiNJcA5HkMLzswuQGwuBHuHqI3D485TMsu0mldIeugzwjmHmoL
         EchHSBfzJJkVk+ccPbdxksMJftHaV4F+nMnAah4OWzIp3Z+IrSDA44DKRh7sehvXyx6+
         HvCIU4XM8C8uMx2TbI9l+VQGtX4fHtS5CKWRhDILZNnbFvrqzfiJwXrt0cWM+CKW8x4r
         tspA==
X-Gm-Message-State: AOAM530dSfuROQJCfwVlVN5Byj7qznX5QTUQOTAmIhZSy9SZNxLXDAmb
        6rZN+dQ9xQZqisI4ZqDVWMt0nrOt39Q=
X-Google-Smtp-Source: ABdhPJwyciHJulV8GXvdtkPxOyujpSo+cQuGQ3mGaHjDjrbR5btQ2IIFf/d0BtLDW6TxzTCNb06wKA==
X-Received: by 2002:a1c:c387:: with SMTP id t129mr17858571wmf.27.1594633675285;
        Mon, 13 Jul 2020 02:47:55 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
        by smtp.gmail.com with ESMTPSA id z6sm19636364wmf.33.2020.07.13.02.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 02:47:54 -0700 (PDT)
Date:   Mon, 13 Jul 2020 10:47:49 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
Message-ID: <20200713094749.GA1705612@google.com>
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615132719.1932408-2-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 02:27:03PM +0100, Marc Zyngier wrote:
> -static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
> +static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm_s2_mmu *mmu,
>  						  struct tlb_inv_context *cxt)
>  {
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> @@ -79,22 +79,19 @@ static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
>  		isb();
>  	}
>  
> -	/* __load_guest_stage2() includes an ISB for the workaround. */
> -	__load_guest_stage2(kvm);
> -	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
> +	__load_guest_stage2(mmu);
>  }

Just noticed that this drops the ISB when the speculative AT workaround
is not active.

This alternative is 'backwards' to avoid a double ISB as there is one in
__load_guest_stage2 when the workaround is active. I hope to address
this smell in an upcoming series but, for now, we should at least have
an ISB.
