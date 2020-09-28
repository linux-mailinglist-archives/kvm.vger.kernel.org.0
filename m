Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D69727B3C2
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgI1R5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgI1R5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 13:57:32 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5277121548;
        Mon, 28 Sep 2020 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601315851;
        bh=FiszVX2X8aJ3JQctQxAoRVYSBkNKuAV65IqHDIVEDrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UgVhqWZrdi8d79p/SWmzNIKWAx9QY2xxFutpMs2SAKlkY/0GIzKc+JxKnxdBuFB6x
         9OT11LaaBlPGY87mYS0o64wfRW1lATLgsh5WOGTW9SBu2UE75JH+0WdgGGqPWROjxA
         cYdRwSOinofw/TDgdBAoCMVzsDC5BTKWRj/BAdJI=
Date:   Mon, 28 Sep 2020 18:57:25 +0100
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, sumit.garg@linaro.org, maz@kernel.org,
        swboyd@chromium.org, catalin.marinas@arm.com,
        Julien Thierry <julien.thierry@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v7 5/7] KVM: arm64: pmu: Make overflow handler NMI safe
Message-ID: <20200928175725.GB11792@willie-the-truck>
References: <20200924110706.254996-1-alexandru.elisei@arm.com>
 <20200924110706.254996-6-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924110706.254996-6-alexandru.elisei@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 24, 2020 at 12:07:04PM +0100, Alexandru Elisei wrote:
> From: Julien Thierry <julien.thierry@arm.com>
> 
> kvm_vcpu_kick() is not NMI safe. When the overflow handler is called from
> NMI context, defer waking the vcpu to an irq_work queue.
> 
> A vcpu can be freed while it's not running by kvm_destroy_vm(). Prevent
> running the irq_work for a non-existent vcpu by calling irq_work_sync() on
> the PMU destroy path.
> 
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
> Cc: kvm@vger.kernel.org
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Tested-by: Sumit Garg <sumit.garg@linaro.org> (Developerbox)
> [Alexandru E.: Added irq_work_sync()]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> I suggested in v6 that I will add an irq_work_sync() to
> kvm_pmu_vcpu_reset(). It turns out it's not necessary: a vcpu reset is done
> by the vcpu being reset with interrupts enabled, which means all the work
> has had a chance to run before the reset takes place.

I don't understand this ^^

But the patch itself looks good, so I'm going to queue this lot anyway!

Will
