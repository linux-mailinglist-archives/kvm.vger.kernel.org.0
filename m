Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8301831D311
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 00:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBPXpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 18:45:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229876AbhBPXpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 18:45:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613519022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CSP5TYqu650KhYGvjztOmE5csI9NW0yzVVbY0leWkZI=;
        b=DrTSy3kafGd7ffVdU1taQe9jO/Spb5kDV2AlsM+bxFAqYGh2CjQMnxHuDAN+6wXsiytC7H
        JF01K23QH2Z5hUnffvO+08R6AuaSac29/T9TwLgrw4AO6PNuKnilghn1eTZtfDfAeivwX3
        wMVnmM7AqSefGozLK9//KGA5b//8LCg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-GPkCL7QtPxybKXRD9zqMzg-1; Tue, 16 Feb 2021 18:43:40 -0500
X-MC-Unique: GPkCL7QtPxybKXRD9zqMzg-1
Received: by mail-qk1-f199.google.com with SMTP id s6so9510540qkg.15
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 15:43:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CSP5TYqu650KhYGvjztOmE5csI9NW0yzVVbY0leWkZI=;
        b=Cue9aJBs32+geTEWrMfbGrBQzeCaWz2f1WXD/biqZWhQ2CrJXy+eJMaF+qjuFTlvh+
         nk9z3BvqVZSCzE/7bloRMLf+/VEJ5PU1YpUzT6AF3btjsjiLp3+jgfEoSmfrLoR+osTv
         ohfQd2UqB81zAG/LYNnXgdZ99yQ7YByz9QmyQMToBFL9MbeSabh0juf5YbH0hoZNkVBo
         MNVkFmlUpVlxhbLT8tOqesRDCa4khYVeJIO3KAm/2FQGagAKMAziMOanhuMkqmWoDxgw
         4UvxXZpXCciq1KQP6JtQVP7OoPhIfzCU0pUOlv5WLKnAhvN/FZJbE2jd3HuYquLvC7rn
         fjKw==
X-Gm-Message-State: AOAM530ew+FYoN3iUFpd5Z4mSFwCP2h2UzN9DUFgIe1Dm5bB4TDA+Q1w
        STYVrsKbzkCaTZATSaDavlwVBy5URsmvAfpc0+iYpWkhM2x9TUr+1VMOpoutIQ1euzPA5tnvAK7
        4GoN48KFOy/5z
X-Received: by 2002:a05:620a:cd6:: with SMTP id b22mr21492231qkj.451.1613519020095;
        Tue, 16 Feb 2021 15:43:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwoewrF38Q6wgd1ErfBYD6lARPXXVDP/Bm9c/cbXWNMU4YW9mO/tBw/lLitRcK/s+IpTQcsSQ==
X-Received: by 2002:a05:620a:cd6:: with SMTP id b22mr21492214qkj.451.1613519019928;
        Tue, 16 Feb 2021 15:43:39 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-182.dsl.bell.ca. [174.93.89.182])
        by smtp.gmail.com with ESMTPSA id d17sm418815qkc.40.2021.02.16.15.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 15:43:39 -0800 (PST)
Date:   Tue, 16 Feb 2021 18:43:37 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, jgg@nvidia.com
Subject: Re: [PATCH v2] vfio/type1: Use follow_pte()
Message-ID: <20210216234337.GE91264@xz-x1>
References: <161351571186.15573.5602248562129684350.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <161351571186.15573.5602248562129684350.stgit@gimli.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 03:49:34PM -0700, Alex Williamson wrote:
> follow_pfn() doesn't make sure that we're using the correct page
> protections, get the pte with follow_pte() so that we can test
> protections and get the pfn from the pte.
> 
> Fixes: 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

