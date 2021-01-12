Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF0F2F3503
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 17:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392170AbhALQFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 11:05:05 -0500
Received: from foss.arm.com ([217.140.110.172]:48980 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392027AbhALQFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 11:05:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1DD51FB;
        Tue, 12 Jan 2021 08:04:19 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29ADD3F719;
        Tue, 12 Jan 2021 08:04:18 -0800 (PST)
Subject: Re: [PATCH 7/9] KVM: arm64: Simplify argument passing to
 vgic_uaccess_[read|write]
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-8-eric.auger@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ee2ec95e-4262-a364-b037-c43f3d396760@arm.com>
Date:   Tue, 12 Jan 2021 16:04:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201212185010.26579-8-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 12/12/20 6:50 PM, Eric Auger wrote:
> Instead of converting the vgic_io_device handle to a kvm_io_device
> handled and then do the oppositive, pass a vgic_io_device pointer all
> along the call chain.

To me, it looks like the commit message describes what the patch does instead of
why it does it.

What are "vgic_io_device handle" and "kvm_io_device handled"?

Thanks,
Alex
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> index b2d73fc0d1ef..48c6067fc5ec 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -938,10 +938,9 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
>  	return region;
>  }
>  
> -static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
> +static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
>  			     gpa_t addr, u32 *val)
>  {
> -	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
>  	const struct vgic_register_region *region;
>  	struct kvm_vcpu *r_vcpu;
>  
> @@ -960,10 +959,9 @@ static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>  	return 0;
>  }
>  
> -static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
> +static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
>  			      gpa_t addr, const u32 *val)
>  {
> -	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
>  	const struct vgic_register_region *region;
>  	struct kvm_vcpu *r_vcpu;
>  
> @@ -986,9 +984,9 @@ int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
>  		 bool is_write, int offset, u32 *val)
>  {
>  	if (is_write)
> -		return vgic_uaccess_write(vcpu, &dev->dev, offset, val);
> +		return vgic_uaccess_write(vcpu, dev, offset, val);
>  	else
> -		return vgic_uaccess_read(vcpu, &dev->dev, offset, val);
> +		return vgic_uaccess_read(vcpu, dev, offset, val);
>  }
>  
>  static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
