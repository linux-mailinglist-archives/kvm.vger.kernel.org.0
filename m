Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3335C2AEFCD
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 12:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgKKLj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 06:39:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbgKKLj5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 06:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605094796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XlYzUDAcgUlGZIszeYGpD2M6L/zgkiNXLXJDjwj3mg8=;
        b=C+7SvhTud8352qlY0cPMI/BeT/usgKigk6djMd/7V30RaKSBLcymw3DDITinsMxE/DJ47v
        8C8FTBOvwzYkBv0kAyl6eOw51MIiYxipGz8jJy9dwyyL/9gMtfOL53riPcLZ2utyeNdyFU
        CEwBouMdWgFk1VmuQtoEkf+FTbuNBYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-1A1m-9blN5mvmmBHB4i9nA-1; Wed, 11 Nov 2020 06:39:53 -0500
X-MC-Unique: 1A1m-9blN5mvmmBHB4i9nA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 640D91074647;
        Wed, 11 Nov 2020 11:39:52 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B1085B4C8;
        Wed, 11 Nov 2020 11:39:50 +0000 (UTC)
Date:   Wed, 11 Nov 2020 12:39:48 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 0/2] arm64: Add support for configuring
 the translation granule
Message-ID: <20201111113948.euekaukhjlhvpz5v@kamzik.brq.redhat.com>
References: <20201104130352.17633-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104130352.17633-1-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 01:03:50PM +0000, Nikos Nikoleris wrote:
> Hi all,
> 
> One more update to the series that allows us to configure the
> translation granule in arm64. Again, thanks to Drew and Alex for
> their reviews and their suggestions.
> 
> v1: 
> https://lore.kernel.org/kvm/006a19c0-cdf7-e76c-8335-03034bea9c7e@arm.com/T
> v2: 
> https://lore.kernel.org/kvm/20201102113444.103536-1-nikos.nikoleris@arm.com/
> 
> 
> Changes in v3:
>   - Re-ordered the two changes in the series
>   - Moved much of the code to check the configured granule from the C
>     preprocessor to run time.
>   - Avoid block mappings at the PUD level (Thanks Alex!)
>   - Formatting changes
> 
> Changes in v2:
>   - Change the configure option from page-shift to page-size
>   - Check and warn if the configured granule is not supported
> 
> Thanks,
> 
> Nikos
> 
> 
> Nikos Nikoleris (2):
>   arm64: Check if the configured translation granule is supported
>   arm64: Add support for configuring the translation granule
> 
>  configure                     | 27 ++++++++++++++
>  lib/arm/asm/page.h            |  4 +++
>  lib/arm/asm/pgtable-hwdef.h   |  4 +++
>  lib/arm/asm/pgtable.h         |  6 ++++
>  lib/arm/asm/thread_info.h     |  4 ++-
>  lib/arm64/asm/page.h          | 35 ++++++++++++++----
>  lib/arm64/asm/pgtable-hwdef.h | 42 +++++++++++++++++-----
>  lib/arm64/asm/pgtable.h       | 68 +++++++++++++++++++++++++++++++++--
>  lib/arm64/asm/processor.h     | 36 +++++++++++++++++++
>  lib/libcflat.h                | 20 ++++++-----
>  lib/arm/mmu.c                 | 31 ++++++++++------
>  arm/cstart64.S                | 10 +++++-
>  12 files changed, 249 insertions(+), 38 deletions(-)
> 
> -- 
> 2.17.1
>

Applied, thanks.

