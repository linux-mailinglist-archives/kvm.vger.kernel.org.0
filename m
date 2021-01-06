Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A364B2EC1DA
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 18:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbhAFRNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 12:13:33 -0500
Received: from foss.arm.com ([217.140.110.172]:44484 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbhAFRNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 12:13:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CF011FB;
        Wed,  6 Jan 2021 09:12:47 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A49AE3F70D;
        Wed,  6 Jan 2021 09:12:45 -0800 (PST)
Subject: Re: [PATCH 2/9] KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
 read
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-3-eric.auger@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <888cf519-8c0e-f781-98a1-86594bdfacb1@arm.com>
Date:   Wed, 6 Jan 2021 17:12:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201212185010.26579-3-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

The patch looks correct to me. kvm_vgic_addr() masks out all the bits except index
from addr, so we don't need to do it in vgic_get_common_attr():

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

One nitpick below.

On 12/12/20 6:50 PM, Eric Auger wrote:
> The doc says:
> "The characteristics of a specific redistributor region can
>  be read by presetting the index field in the attr data.
>  Only valid for KVM_DEV_TYPE_ARM_VGIC_V3"
>
> Unfortunately the existing code fails to read the input attr data
> and thus the index always is 0.

addr is allocated on the stack, I don't think it will always be 0.

Thanks,
Alex
>
> Fixes: 04c110932225 ("KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION")
> Cc: stable@vger.kernel.org#v4.17+
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 44419679f91a..2f66cf247282 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -226,6 +226,9 @@ static int vgic_get_common_attr(struct kvm_device *dev,
>  		u64 addr;
>  		unsigned long type = (unsigned long)attr->attr;
>  
> +		if (copy_from_user(&addr, uaddr, sizeof(addr)))
> +			return -EFAULT;
> +
>  		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
>  		if (r)
>  			return (r == -ENODEV) ? -ENXIO : r;
