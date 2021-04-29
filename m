Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6329C36EF74
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 20:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241138AbhD2S3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 14:29:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233338AbhD2S3c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 14:29:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619720925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ahhdjeTzVRBlGxvftGs550exL2vN9CqbDTNttH8KlQg=;
        b=iPwczHvoU0s35NX/pPwl4NRZvm7BrTYfgurtZPQl6F+BU9f/AL1vFXn0J6uI7Bz3Fm5k0o
        7O6SFn4/AdVZfJBrl4DBCPaPAGg+NFh0bjt4VaW1QgsffF8MeQluKZLRHffi8fY/M/5YMB
        jvDRKa44hNbFgsrgHTJ80hc2Xk1vXHQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-vDUQF24aPjCkdRuuxwsczA-1; Thu, 29 Apr 2021 14:28:43 -0400
X-MC-Unique: vDUQF24aPjCkdRuuxwsczA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7D1D1922966;
        Thu, 29 Apr 2021 18:28:41 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E40B75D6DC;
        Thu, 29 Apr 2021 18:28:40 +0000 (UTC)
Date:   Thu, 29 Apr 2021 12:28:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shanker Donthineni <sdonthineni@nvidia.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Vikram Sethi <vsethi@nvidia.com>,
        "Jason Sequeira" <jsequeira@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210429122840.4f98f78e@redhat.com>
In-Reply-To: <20210429162906.32742-2-sdonthineni@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
        <20210429162906.32742-2-sdonthineni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Apr 2021 11:29:05 -0500
Shanker Donthineni <sdonthineni@nvidia.com> wrote:

> For pass-through device assignment, the ARM64 KVM hypervisor retrieves
> the memory region properties physical address, size, and whether a
> region backed with struct page or not from VMA. The prefetchable
> attribute of a BAR region isn't visible to KVM to make an optimal
> decision for stage2 attributes.
> 
> This patch updates vma->vm_page_prot and maps with write-combine
> attribute if the associated BAR is prefetchable. For ARM64
> pgprot_writecombine() is mapped to memory-type MT_NORMAL_NC which
> has no side effects on reads and multiple writes can be combined.
> 
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 5023e23db3bc..1b734fe1dd51 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1703,7 +1703,11 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
>  	}
>  
>  	vma->vm_private_data = vdev;
> -	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	if (IS_ENABLED(CONFIG_ARM64) &&
> +	    (pci_resource_flags(pdev, index) & IORESOURCE_PREFETCH))
> +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +	else
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

If this were a valid thing to do, it should be done for all
architectures, not just ARM64.  However, a prefetchable range only
necessarily allows merged writes, which seems like a subset of the
semantics implied by a WC attribute, therefore this doesn't seem
universally valid.

I'm also a bit confused by your problem statement that indicates that
without WC you're seeing unaligned accesses, does this suggest that
your driver is actually relying on WC semantics to perform merging to
achieve alignment?  That seems rather like a driver bug, I'd expect UC
vs WC is largely a difference in performance, not a means to enforce
proper driver access patterns.  Per the PCI spec, the bridge itself can
merge writes to prefetchable areas, presumably regardless of this
processor attribute, perhaps that's the feature your driver is relying
on that might be missing here.  Thanks,

Alex

