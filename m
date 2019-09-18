Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733CAB6465
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 15:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfIRNau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 09:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfIRNau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 09:30:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EDB420856;
        Wed, 18 Sep 2019 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568813449;
        bh=RbC4fN4+WoQJjBQGTdi17JBf/Ifl1VTx05MBsOOyhtM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HMU51kJ2hcS415mcVYxqXJCb3ohmmTf0wzhM8CN3+/4v/NSDHTsAOLEaOwN/+5MSM
         wJxD3jlSeGhDsjlhp4AvyxSnO/rdHwxmr/MhjBQFfwpH+aT+Dr12+hwhjj3/t56QHQ
         YGR4sLeV25BoxLU77UgArb8CNxjJAn+yAeuBYBuQ=
Date:   Wed, 18 Sep 2019 15:30:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, kernellwp@gmail.com,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "# 5 . 2 . y" <stable@kernel.org>
Subject: Re: [PATCH] kvm: Ensure writes to the coalesced MMIO ring are within
 bounds
Message-ID: <20190918133047.GC1908968@kroah.com>
References: <20190918131545.6405-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918131545.6405-1-will@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 18, 2019 at 02:15:45PM +0100, Will Deacon wrote:
> When records are written to the coalesced MMIO ring in response to a
> vCPU MMIO exit, the 'ring->last' field is used to index the ring buffer
> page. Although we hold the 'kvm->ring_lock' at this point, the ring
> structure is mapped directly into the host userspace and can therefore
> be modified to point at arbitrary pages within the kernel.
> 
> Since this shouldn't happen in normal operation, simply bound the index
> by KVM_COALESCED_MMIO_MAX to contain the accesses within the ring buffer
> page.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: <stable@kernel.org> # 5.2.y
> Fixes: 5f94c1741bdc ("KVM: Add coalesced MMIO support (common part)")
> Reported-by: Bill Creasey <bcreasey@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 
> I think there are some other fixes kicking around for this, but they
> still rely on 'ring->last' being stable, which isn't necessarily the
> case. I'll send the -stable backport for kernels prior to 5.2 once this
> hits mainline.
> 
>  virt/kvm/coalesced_mmio.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 5294abb3f178..09b3e4421550 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -67,6 +67,7 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
>  {
>  	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
>  	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
> +	u32 last;
>  
>  	if (!coalesced_mmio_in_range(dev, addr, len))
>  		return -EOPNOTSUPP;
> @@ -79,13 +80,13 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
>  	}
>  
>  	/* copy data in first free entry of the ring */
> -
> -	ring->coalesced_mmio[ring->last].phys_addr = addr;
> -	ring->coalesced_mmio[ring->last].len = len;
> -	memcpy(ring->coalesced_mmio[ring->last].data, val, len);
> -	ring->coalesced_mmio[ring->last].pio = dev->zone.pio;
> +	last = ring->last % KVM_COALESCED_MMIO_MAX;
> +	ring->coalesced_mmio[last].phys_addr = addr;
> +	ring->coalesced_mmio[last].len = len;
> +	memcpy(ring->coalesced_mmio[last].data, val, len);
> +	ring->coalesced_mmio[last].pio = dev->zone.pio;
>  	smp_wmb();
> -	ring->last = (ring->last + 1) % KVM_COALESCED_MMIO_MAX;
> +	ring->last = (last + 1) % KVM_COALESCED_MMIO_MAX;
>  	spin_unlock(&dev->kvm->ring_lock);
>  	return 0;
>  }

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
