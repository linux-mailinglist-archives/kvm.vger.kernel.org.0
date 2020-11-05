Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C662A8ADA
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 00:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbgKEXjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 18:39:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730895AbgKEXjz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 18:39:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604619593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iDAyvR5gD4TyJZEtiMBAa4BmrmJW9bifhrNylm9H+Nk=;
        b=fcD/w3dephaXgphP+qbpJbTDLy8ezn5U/YqL5Bo80rWqQbBLoX90LW19QMjyReVEO0z6Sa
        R4gxhgrSSuQCjUrc3rvghpFK/I0EMbmUGKgxyKpds123NriYt6lEgmS+tiy1qGVJ1li6+e
        SIQ0fPPgTXSoTWvTFwfjU3afZC8bQv8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-oNAw0M3HN_SmrHQ7_g9_tw-1; Thu, 05 Nov 2020 18:39:52 -0500
X-MC-Unique: oNAw0M3HN_SmrHQ7_g9_tw-1
Received: by mail-qv1-f70.google.com with SMTP id z9so1998556qvo.20
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 15:39:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iDAyvR5gD4TyJZEtiMBAa4BmrmJW9bifhrNylm9H+Nk=;
        b=TkIns2Y5ulEqLrfYL/NJC12rTE0eduvN9MmMgOpTHsDEdicafq3O/quCWk0l2BAbQU
         EXly+FrVWD+L2VCwkXBKZwT5wPZx5UGIku9WYyjURMAC70GWAIywPykQvFB5oXhI4a96
         xutyEbzszRJFH8Vu03SY4r4BMME4FBFoUTW3IoZ/3tFShkg1C2hOXYMCAnMuqM1BLLuR
         01GOfoR+5RqtDAg3ZSXG5ZQjF3Tm5//n7/AfK8/KHkT+z2CvILe6Wvh0jx7dmPdr6619
         e28u/j8z7LCzdCjMRTd/4UhmFWfjXVsLc5uvL+FPX2DoHYNYy5xjAi7pc73oOJNxeHtu
         k8eQ==
X-Gm-Message-State: AOAM531xck2gf7vvbaekoPx+5nC543/tMg1/blSvLMBgyToMY6+4XeDZ
        Dgdo2AXN9CZY8fb6Qkx5KzpD8u43d79ZlwldJjFQSG0YmSk01hl83FFMB/2m/ql3RSlqFYhPf6p
        zvPMZiYn3TXTj
X-Received: by 2002:ad4:40c6:: with SMTP id x6mr4716989qvp.20.1604619591809;
        Thu, 05 Nov 2020 15:39:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXaBVJ1fUmPkbrXwNAai+AE1R0/5hqT+np0zBwOXHL0Ndalaxbbg2psuq6rJtap1TS0YnA1w==
X-Received: by 2002:ad4:40c6:: with SMTP id x6mr4716980qvp.20.1604619591661;
        Thu, 05 Nov 2020 15:39:51 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id p77sm2154612qke.39.2020.11.05.15.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 15:39:50 -0800 (PST)
Date:   Thu, 5 Nov 2020 18:39:49 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Message-ID: <20201105233949.GA138364@xz-x1>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 12:34:58PM -0400, Jason Gunthorpe wrote:
> Tom says VFIO device assignment works OK with KVM, so I expect only things
> like DPDK to be broken.

Is there more information on why the difference?  Thanks,

-- 
Peter Xu

