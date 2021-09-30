Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149FF41DA75
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 15:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349419AbhI3NG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 09:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349366AbhI3NG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 09:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 980FF61528;
        Thu, 30 Sep 2021 13:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633007084;
        bh=+s6LJxFuBmlJp9/9dcn48u7vnNbcZ8iPNN4iyAdSDPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lAOSz70qSb1/bv1kHlkZDOvTg6wttP2zJv3px1/YqJm0Nkout2msVt9Z7nDY73GAo
         IOXXwUdhK3TOZmhdrG/nZwueGWjuzn643i9AYHDZlUA0YElj0iGWcNIWN8u9PLJ+k6
         Ja2+FCVgU9FMvV0SnGhUngXQAZryBYCwibjq0iYqhH4HIyuj8njLPx98MhcScnjTbZ
         ewyKZGdTTN2cuiES30Azq3cB48JBVsTvj9EA6zyu41+eWw88Q8nTLYkNPLwuDVuhjk
         C+Yx4N6m86OLcA6uH0W9bXGAPlpcJg475/K/ePPzUDVwJaSJpYOJlAUCucyi38qcKC
         oBFc0p1Hjsejw==
Date:   Thu, 30 Sep 2021 14:04:38 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v6 01/12] KVM: arm64: Move __get_fault_info() and co into
 their own include file
Message-ID: <20210930130437.GA23809@willie-the-truck>
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-2-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922124704.600087-2-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 01:46:53PM +0100, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> In order to avoid including the whole of the switching helpers
> in unrelated files, move the __get_fault_info() and related helpers
> into their own include file.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/fault.h  | 75 +++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 61 +-------------------
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  2 +-
>  3 files changed, 77 insertions(+), 61 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
> new file mode 100644
> index 000000000000..1b8a2dcd712f
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2015 - ARM Ltd
> + * Author: Marc Zyngier <marc.zyngier@arm.com>

May as well fix the broken email address? ^^

> + */
> +
> +#ifndef __ARM64_KVM_HYP_FAULT_H__
> +#define __ARM64_KVM_HYP_FAULT_H__
> +
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_hyp.h>
> +#include <asm/kvm_mmu.h>

Strictly speaking, I think you're probably missing a bunch of includes here
(e.g. asm/sysreg.h, asm/kvm_arm.h, asm/cpufeature.h, ...)

Nits aside:

Acked-by: Will Deacon <will@kernel.org>

Will
