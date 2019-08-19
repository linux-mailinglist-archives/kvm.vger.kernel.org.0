Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9913691E2B
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 09:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfHSHl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 03:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbfHSHl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 03:41:56 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBBD4204EC;
        Mon, 19 Aug 2019 07:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566200515;
        bh=Bj5VwIQaJmiMtcxgccis/IQVQu1dOXG6ktRvVZc/tNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hh2QkeT6BWiakhxFyxX9eSPmMkYOaiZFJPreOEHHkevteQ4TsbD9fioIq6IEE6Kfp
         fviD/EiJU+ZfDV/9mNNGA5506rtM8Djweu+6R4NaTOHrtySt0ioPWxKXyDCAvPmZnh
         Dr+0/2szM3Ji0q9d4xn65pL7CbnjsX3M8gGmrsME=
Date:   Mon, 19 Aug 2019 08:41:50 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, qemu-arm@nongnu.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Allow more than 256 vcpus for
 KVM_IRQ_LINE
Message-ID: <20190819074150.jv3dyyxqazoawgds@willie-the-truck>
References: <20190818140710.23920-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818140710.23920-1-maz@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 18, 2019 at 03:07:10PM +0100, Marc Zyngier wrote:
> While parts of the VGIC support a large number of vcpus (we
> bravely allow up to 512), other parts are more limited.
> 
> One of these limits is visible in the KVM_IRQ_LINE ioctl, which
> only allows 256 vcpus to be signalled when using the CPU or PPI
> types. Unfortunately, we've cornered ourselves badly by allocating
> all the bits in the irq field.
> 
> Since the irq_type subfield (8 bit wide) is currently only taking
> the values 0, 1 and 2 (and we have been careful not to allow anything
> else), let's reduce this field to only 4 bits, and allocate the
> remaining 4 bits to a vcpu2_index, which acts as a multiplier:
> 
>   vcpu_id = 256 * vcpu2_index + vcpu_index
> 
> With that, and a new capability (KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)
> allowing this to be discovered, it becomes possible to inject
> PPIs to up to 4096 vcpus. But please just don't.

Do you actually need a new capability for this? Older kernels reject
non-zero upper bits in the 'irq_type', so isn't that enough to probe
for this directly?

Will
