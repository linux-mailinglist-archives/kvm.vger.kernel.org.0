Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19513348A2
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 21:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhCJUGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 15:06:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232064AbhCJUGM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 15:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615406771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MZqOerku4ka3IhMUBjG/XTRlN6lYxBxQ2MLf7EPvQE8=;
        b=cj3XsgcqkOVGyDxGmuHB7+iklIAOzSwBwQi4S3VkUSFPKZq59Z//PL8YH78rfXmf2Tz+mV
        6usKUJZR0udPViiXoZtsg0ySfnYr2OlGyReQQKmY72QwODBH5pKAu5HZQrZHh+x0J1XJZl
        51zpTsVxG7N7jM+QQ+z6QMyx2sNcSR0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-PU1mr1JGP7a_GU5__lAA3w-1; Wed, 10 Mar 2021 15:06:09 -0500
X-MC-Unique: PU1mr1JGP7a_GU5__lAA3w-1
Received: by mail-qv1-f70.google.com with SMTP id x20so4438046qvd.21
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 12:06:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MZqOerku4ka3IhMUBjG/XTRlN6lYxBxQ2MLf7EPvQE8=;
        b=Vd+cEV6y2LMkgokpRvnvI2B6kTjyFEitMlB7Wi7hB4Fd4NvN/E/1gIhwgUwtSCXvU/
         b5tElRyR+aQfbyxocfLXnfGeE+TsZuZjTPseZGlR3dgcQ9lmIZnn4R2pK03XCsLNUbXc
         wObPwmb8ULiQhTD1N1fU3OCj0JclClencw0RXNh0+knh9PuHRFq4/qHROam4zhgHXbYL
         IEnCESIt9figdiL8BteUb/O4eKDdRT0uhkXT0aiUN52prGEPDiy+Pl4DCiQoHJENcXHy
         sqkmWOW0LqfKQV+M1FYfMR4dXO+dtquMlO8tqdmlWoIFK47dhfVL6Otncnb7ZlcYJh4U
         Q2CQ==
X-Gm-Message-State: AOAM531aWZwWMqyNCvHmOD4KPcyiW2VpT4p049pf/rQxblQjC3y1EYeq
        e5jbcWQRQ2l+m9mrxe60aV2fFcoT2DDcdVrousSK58n9MVtEUHnjzgduE14F53nil/TmhiC2wcV
        f34lCiDYFgWS5
X-Received: by 2002:aed:3741:: with SMTP id i59mr2410754qtb.303.1615406769019;
        Wed, 10 Mar 2021 12:06:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzT3IYnqEF4ggAfCl202qrDbK8JrUuXkacUIxpIN6UHTxsbOnQgsrU2TqIx7iJ6zbkiigwpgA==
X-Received: by 2002:aed:3741:: with SMTP id i59mr2410742qtb.303.1615406768814;
        Wed, 10 Mar 2021 12:06:08 -0800 (PST)
Received: from xz-x1 ([142.126.89.138])
        by smtp.gmail.com with ESMTPSA id 131sm284373qkl.74.2021.03.10.12.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 12:06:08 -0800 (PST)
Date:   Wed, 10 Mar 2021 15:06:07 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, prime.zeng@hisilicon.com,
        cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210310200607.GG6530@xz-x1>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
 <20210310181446.GZ2356281@nvidia.com>
 <20210310113406.6f029fcf@omen.home.shazbot.org>
 <20210310184011.GA2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210310184011.GA2356281@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 02:40:11PM -0400, Jason Gunthorpe wrote:
> On Wed, Mar 10, 2021 at 11:34:06AM -0700, Alex Williamson wrote:
> 
> > > I think after the address_space changes this should try to stick with
> > > a normal io_rmap_pfn_range() done outside the fault handler.
> > 
> > I assume you're suggesting calling io_remap_pfn_range() when device
> > memory is enabled,
> 
> Yes, I think I saw Peter thinking along these lines too
> 
> Then fault just always causes SIGBUS if it gets called

Indeed that looks better than looping in the fault().

But I don't know whether it'll be easy to move io_remap_pfn_range() to device
memory enablement.  If it's a two-step thing, we can fix the BUG_ON and vma
duplication issue first, then the full rework can be done in the bigger series
as what be chosen as the last approach.

Thanks,

-- 
Peter Xu

