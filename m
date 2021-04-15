Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA7E360A2D
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhDONJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:09:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21927 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232844AbhDONJz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 09:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618492172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9mFjqIW0FLUWlSw3xnD81019MFjYU02iqIypqRJLxc0=;
        b=bCzI+CGgy8fTfMtUR1FB4tKycMMRymkb/Bdz/7nxbgGi/ZT3/MtEF7OGRa+RCDRGXAsc85
        Z0/b6X6n+pw8UzwcflE8dHwNBitwS+MfhL1UDCNbgG0fM/VKOsfgUseKkEyab8hzVh7TKC
        oZsUdCTlLBKi2/E9XV4xW2w5xaRUBcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-QuVWWnFgOVi8jkICILP4SA-1; Thu, 15 Apr 2021 09:09:30 -0400
X-MC-Unique: QuVWWnFgOVi8jkICILP4SA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FA14BBEE2;
        Thu, 15 Apr 2021 13:09:29 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1AD610023B0;
        Thu, 15 Apr 2021 13:09:23 +0000 (UTC)
Date:   Thu, 15 Apr 2021 15:09:20 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 4/8] arm/arm64: mmu: Stop mapping an
 assumed IO region
Message-ID: <20210415130920.cmxgcbyyrnbj7uie@kamzik.brq.redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-5-drjones@redhat.com>
 <4f593d38-a462-aa00-2903-8a1f0c38a8e6@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f593d38-a462-aa00-2903-8a1f0c38a8e6@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 14, 2021 at 04:42:17PM +0100, Alexandru Elisei wrote:
> On 4/7/21 7:59 PM, Andrew Jones wrote:
> > +void mmu_set_persistent_maps(pgd_t *pgtable)
> > +{
> > +	struct mmu_persistent_map *map;
> > +
> > +	for (map = &mmu_persistent_maps[0]; map->phys_end; ++map) {
> > +		if (map->sect)
> > +			mmu_set_range_sect(pgtable, map->virt_offset,
> > +					   map->phys_start, map->phys_end,
> > +					   map->prot);
> > +		else
> > +			mmu_set_range_ptes(pgtable, map->virt_offset,
> > +					   map->phys_start, map->phys_end,
> > +					   map->prot);
> > +	}
> > +}
> 
> I assume the purpose of all of this machinery is to add mappings to idmap that
> were created before setup_mmu(). Or are you planning to use it for something else?
> 
> Why not allocate the idmap in __ioremap (if it's NULL) and add entries to it in
> that function? Then setup_mmu() can allocate the idmap only if it's NULL, and the
> mappings added by __ioremap would still be there.
>

Hi Alex,

I like your suggestion and will implement it that way for v2. If we ever
do need these mappings for anything else, then we can revisit this,
possibly stashing the mappings at the same time we add them to the idmap.

Thanks,
drew

