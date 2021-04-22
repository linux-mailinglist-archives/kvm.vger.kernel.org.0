Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC023681CE
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 15:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbhDVNuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 09:50:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59667 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhDVNuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 09:50:16 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQzLS4gwsz9sW5;
        Thu, 22 Apr 2021 23:49:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1619099380;
        bh=PhzqVOhEd/h/0Fbbb3BAwftaycIPw8RDL50QyqE12IM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=opAHDFQP4CkPQG2bXglbuqBieFuhtxeywVbuoUy6F6KRrIYll/aQ4VCFGZ+1SK9ww
         qkC27cYMIYRHgi8TycPRBwvXaDwBGTnXMQvEVQhwKjswSnF0TiXP9XoXJJH8uAMdxR
         lMSsBJYzwnLenDSlSt5RcjvvzILAWNdsjd3NeCn1uh6z9wZ4h29Ve3grGN/tFByXrh
         laZUoPJjgJvzIviuLVCQoLLfZr/DN4nqji6OiiVCjJx3TKVyz53aJyIcQrAkkTTzmJ
         lKYWFa+XMX4Vq2TMF7e9f3rRkMEJ3MQkjQhp4H2W940Tex0j4MPNi8CrUl2AaEhvuK
         7NueaXiSceWgg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio/pci: remove vfio_pci_nvlink2
In-Reply-To: <20210412082304.5e7c0a80@omen>
References: <20210326061311.1497642-1-hch@lst.de>
 <20210326061311.1497642-2-hch@lst.de> <20210406133805.715120bd@omen>
 <87y2dndelm.fsf@mpe.ellerman.id.au> <20210412082304.5e7c0a80@omen>
Date:   Thu, 22 Apr 2021 23:49:31 +1000
Message-ID: <87h7jybf9w.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex Williamson <alex.williamson@redhat.com> writes:
> On Mon, 12 Apr 2021 19:41:41 +1000
> Michael Ellerman <mpe@ellerman.id.au> wrote:
>
>> Alex Williamson <alex.williamson@redhat.com> writes:
>> > On Fri, 26 Mar 2021 07:13:10 +0100
>> > Christoph Hellwig <hch@lst.de> wrote:
>> >  
>> >> This driver never had any open userspace (which for VFIO would include
>> >> VM kernel drivers) that use it, and thus should never have been added
>> >> by our normal userspace ABI rules.
>> >> 
>> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> >> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >> ---
>> >>  drivers/vfio/pci/Kconfig            |   6 -
>> >>  drivers/vfio/pci/Makefile           |   1 -
>> >>  drivers/vfio/pci/vfio_pci.c         |  18 -
>> >>  drivers/vfio/pci/vfio_pci_nvlink2.c | 490 ----------------------------
>> >>  drivers/vfio/pci/vfio_pci_private.h |  14 -
>> >>  include/uapi/linux/vfio.h           |  38 +--
>> >>  6 files changed, 4 insertions(+), 563 deletions(-)
>> >>  delete mode 100644 drivers/vfio/pci/vfio_pci_nvlink2.c  
>> >
>> > Hearing no objections, applied to vfio next branch for v5.13.  Thanks,  
>> 
>> Looks like you only took patch 1?
>> 
>> I can't take patch 2 on its own, that would break the build.
>> 
>> Do you want to take both patches? There's currently no conflicts against
>> my tree. It's possible one could appear before the v5.13 merge window,
>> though it would probably just be something minor.
>> 
>> Or I could apply both patches to my tree, which means patch 1 would
>> appear as two commits in the git history, but that's not a big deal.
>
> I've already got a conflict in my next branch with patch 1, so it's
> best to go through my tree.  Seems like a shared branch would be
> easiest to allow you to merge and manage potential conflicts against
> patch 2, I've pushed a branch here:
>
> https://github.com/awilliam/linux-vfio.git v5.13/vfio/nvlink

Thanks.

My next is based on rc2, so I won't pull that in directly, because I
don't want to pull all of rc6 in with it.

I'll put it in a topic branch and merge it into my next after my first
pull has gone to Linus.

cheers
