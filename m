Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220E3A4D64
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 05:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfIBDGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Sep 2019 23:06:18 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53241 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbfIBDGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Sep 2019 23:06:18 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46MFN75NkJz9sNx; Mon,  2 Sep 2019 13:06:15 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 35872480da47ec714fd9c4f2f3d2d83daf304851
In-Reply-To: <20190829085252.72370-2-aik@ozlabs.ru>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alistair Popple <alistair@popple.id.au>,
        kvm-ppc@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel v3 1/5] powerpc/powernv/ioda: Split out TCE invalidation from TCE updates
Message-Id: <46MFN75NkJz9sNx@ozlabs.org>
Date:   Mon,  2 Sep 2019 13:06:15 +1000 (AEST)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-08-29 at 08:52:48 UTC, Alexey Kardashevskiy wrote:
> At the moment updates in a TCE table are made by iommu_table_ops::exchange
> which update one TCE and invalidates an entry in the PHB/NPU TCE cache
> via set of registers called "TCE Kill" (hence the naming).
> Writing a TCE is a simple xchg() but invalidating the TCE cache is
> a relatively expensive OPAL call. Mapping a 100GB guest with PCI+NPU
> passed through devices takes about 20s.
> 
> Thankfully we can do better. Since such big mappings happen at the boot
> time and when memory is plugged/onlined (i.e. not often), these requests
> come in 512 pages so we call call OPAL 512 times less which brings 20s
> from the above to less than 10s. Also, since TCE caches can be flushed
> entirely, calling OPAL for 512 TCEs helps skiboot [1] to decide whether
> to flush the entire cache or not.
> 
> This implements 2 new iommu_table_ops callbacks:
> - xchg_no_kill() to update a single TCE with no TCE invalidation;
> - tce_kill() to invalidate multiple TCEs.
> This uses the same xchg_no_kill() callback for IODA1/2.
> 
> This implements 2 new wrappers on top of the new callbacks similar to
> the existing iommu_tce_xchg().
> 
> This does not use the new callbacks yet, the next patches will;
> so this should not cause any behavioral change.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Series applied to powerpc topic/ppc-kvm, thanks.

https://git.kernel.org/powerpc/c/35872480da47ec714fd9c4f2f3d2d83daf304851

cheers
