Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89772F371C
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404757AbhALR3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 12:29:38 -0500
Received: from foss.arm.com ([217.140.110.172]:50124 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388300AbhALR3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 12:29:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E72FA101E;
        Tue, 12 Jan 2021 09:28:51 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 655A13F719;
        Tue, 12 Jan 2021 09:28:50 -0800 (PST)
Subject: Re: [PATCH 8/9] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for
 userspace
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-9-eric.auger@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <fe0a3415-0c7b-be13-6438-89e82fe4c281@arm.com>
Date:   Tue, 12 Jan 2021 17:28:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201212185010.26579-9-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 12/12/20 6:50 PM, Eric Auger wrote:
> Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
> reporting of GICR_TYPER.Last for userspace") temporarily fixed
> a bug identified when attempting to access the GICR_TYPER
> register before the redistributor region setting but dropped
> the support of the LAST bit. This patch restores its
> support (if the redistributor region was set) while keeping the
> code safe.

If I understand your patch correctly, it is possible for the GICR_TYPER.Last bit
to be transiently 1 if the register is accessed before all the redistributors
regions have been configured.

Arm IHI 0069F states that accesses to the GICR_TYPER register are RO. I haven't
found exactly what RO means (please point me to the definition if you find it in
the architecture!), but I assume it means read-only and I'm not sure how correct
(from an architectural point of view) it is for two subsequent reads of this
register to return different values. Maybe Marc can shed some light on this.

Thanks,
Alex
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
>  include/kvm/arm_vgic.h             | 1 +
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 581f0f490000..2f9ef6058f6e 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -277,6 +277,8 @@ static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
>  						 gpa_t addr, unsigned int len)
>  {
>  	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_redist_region *rdreg = vgic_cpu->rdreg;
>  	int target_vcpu_id = vcpu->vcpu_id;
>  	u64 value;
>  
> @@ -286,7 +288,9 @@ static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
>  	if (vgic_has_its(vcpu->kvm))
>  		value |= GICR_TYPER_PLPIS;
>  
> -	/* reporting of the Last bit is not supported for userspace */
> +	if (rdreg && (vgic_cpu->rdreg_index == (rdreg->free_index - 1)))
> +		value |= GICR_TYPER_LAST;
> +
>  	return extract_bytes(value, addr & 7, len);
>  }
>  
> @@ -714,6 +718,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>  		return -EINVAL;
>  
>  	vgic_cpu->rdreg = rdreg;
> +	vgic_cpu->rdreg_index = rdreg->free_index;
>  
>  	rd_base = rdreg->base + rdreg->free_index * KVM_VGIC_V3_REDIST_SIZE;
>  
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index a8d8fdcd3723..596c069263a7 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -322,6 +322,7 @@ struct vgic_cpu {
>  	 */
>  	struct vgic_io_device	rd_iodev;
>  	struct vgic_redist_region *rdreg;
> +	u32 rdreg_index;
>  
>  	/* Contains the attributes and gpa of the LPI pending tables. */
>  	u64 pendbaser;
