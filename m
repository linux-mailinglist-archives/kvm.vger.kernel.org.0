Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED4331CC74
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 15:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhBPOxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 09:53:41 -0500
Received: from foss.arm.com ([217.140.110.172]:36732 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhBPOxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 09:53:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36D8431B;
        Tue, 16 Feb 2021 06:52:55 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3677B3F694;
        Tue, 16 Feb 2021 06:52:54 -0800 (PST)
Subject: Re: [PATCH kvmtool 16/21] vfio: Switch to new ioport trap handlers
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-17-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <797e9b63-2e0b-b2b0-f291-97f722f4a64d@arm.com>
Date:   Tue, 16 Feb 2021 14:52:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-17-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

Looks good, _vfio_ioport_{in,out} could have been renamed to vfio_ioport_{in,out},
but it's fine either way:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

On 12/10/20 2:29 PM, Andre Przywara wrote:
> Now that the vfio device has a trap handler adhering to the MMIO fault
> handler prototype, let's switch over to the joint registration routine.
>
> This allows us to get rid of the ioport shim routines.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  vfio/core.c | 29 ++++++-----------------------
>  1 file changed, 6 insertions(+), 23 deletions(-)
>
> diff --git a/vfio/core.c b/vfio/core.c
> index f55f1f87..10919101 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -160,25 +160,6 @@ static void vfio_ioport_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>  		_vfio_ioport_in(region, offset, data, len);
>  }
>  
> -static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> -			    u16 port, void *data, int len)
> -{
> -	vfio_ioport_mmio(vcpu, port, data, len, true, ioport->priv);
> -	return true;
> -}
> -
> -static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> -			   u16 port, void *data, int len)
> -{
> -	vfio_ioport_mmio(vcpu, port, data, len, false, ioport->priv);
> -	return true;
> -}
> -
> -static struct ioport_operations vfio_ioport_ops = {
> -	.io_in	= vfio_ioport_in,
> -	.io_out	= vfio_ioport_out,
> -};
> -
>  static void vfio_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>  			     u8 is_write, void *ptr)
>  {
> @@ -223,9 +204,11 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
>  				  struct vfio_region *region)
>  {
>  	if (region->is_ioport) {
> -		int port = ioport__register(kvm, region->port_base,
> -					   &vfio_ioport_ops, region->info.size,
> -					   region);
> +		int port;
> +
> +		port = kvm__register_pio(kvm, region->port_base,
> +					 region->info.size, vfio_ioport_mmio,
> +					 region);
>  		if (port < 0)
>  			return port;
>  		return 0;
> @@ -292,7 +275,7 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
>  		munmap(region->host_addr, region->info.size);
>  		region->host_addr = NULL;
>  	} else if (region->is_ioport) {
> -		ioport__unregister(kvm, region->port_base);
> +		kvm__deregister_pio(kvm, region->port_base);
>  	} else {
>  		kvm__deregister_mmio(kvm, region->guest_phys_addr);
>  	}
