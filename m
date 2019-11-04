Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CC0EE5C0
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 18:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfKDRWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 12:22:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbfKDRWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 12:22:45 -0500
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81C7159455
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 17:22:45 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id k53so19512605qtk.0
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 09:22:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hGun/xxBDTM75WA+PPVD/XZnt9nEDVLB5zx43UE5Aso=;
        b=ElyrKDMr1NMeHzz31doNPqu9ApNmyZ6FpgAsJghGSApUdTXBaZo+VaZ2tg2amERlDJ
         j39MB66qZzoMqDznKvHBO2BP39CHwjmgzgu/GiGOX8+6RkJgzgQR/fsjflVzbDBleG5t
         mZIziuXnQS/3DhvRwo4+2o77yJLoKyYTVUesqijquanq5CavihwouTXHB2knNFF2J1D0
         cRyaWS3kg8V2vyRus2mkXXJuI8zx808dW2CX7iJV0jlZC51r6tcHP/j+8zCCqnhPeVX3
         h3jd3rKBwZTUABdy0S/3WRL6JFn2qNJu4OVV6n5U5Lh0wYgXkqG89foe7Pmoq3nNWsBw
         S1hw==
X-Gm-Message-State: APjAAAUooe95rvgj6D39sXTb8wu5fkGX4mDphXN4yrNnLO1ec9PoMcUf
        fJaHMqOEDC0xC6+dPN2bNxSNyAJXl9m24OTR1zUPPsmsvXZcHkt9gy/RECC3aS4AS29YVtxNo+Y
        8pCvbWnF/aXAz
X-Received: by 2002:aed:24e4:: with SMTP id u33mr13311107qtc.259.1572888164830;
        Mon, 04 Nov 2019 09:22:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqwXDSii1Sp1JoXaaC96NK08xiocEah+dkAX0IB2PhxwphYwtk8Zpi5wlbG9RUjxaUVdk1G54w==
X-Received: by 2002:aed:24e4:: with SMTP id u33mr13311086qtc.259.1572888164607;
        Mon, 04 Nov 2019 09:22:44 -0800 (PST)
Received: from xz-x1.metropole.lan ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h21sm1097470qkl.13.2019.11.04.09.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 09:22:43 -0800 (PST)
Date:   Mon, 4 Nov 2019 12:22:42 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org
Subject: Re: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VM
Message-ID: <20191104172242.GD26023@xz-x1.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 08:34:21AM -0400, Liu Yi L wrote:
> Shared virtual address (SVA), a.k.a, Shared virtual memory (SVM) on Intel
> platforms allow address space sharing between device DMA and applications.
> SVA can reduce programming complexity and enhance security.
> This series is intended to expose SVA capability to VMs. i.e. shared guest
> application address space with passthru devices. The whole SVA virtualization
> requires QEMU/VFIO/IOMMU changes. This series includes the QEMU changes, for
> VFIO and IOMMU changes, they are in separate series (listed in the "Related
> series").
> 
> The high-level architecture for SVA virtualization is as below:
> 
>     .-------------.  .---------------------------.
>     |   vIOMMU    |  | Guest process CR3, FL only|
>     |             |  '---------------------------'
>     .----------------/
>     | PASID Entry |--- PASID cache flush -
>     '-------------'                       |
>     |             |                       V
>     |             |                CR3 in GPA
>     '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>       v        v                          v
> Host
>     .-------------.  .----------------------.
>     |   pIOMMU    |  | Bind FL for GVA-GPA  |
>     |             |  '----------------------'
>     .----------------/  |
>     | PASID Entry |     V (Nested xlate)
>     '----------------\.------------------------------.
>     |             |   |SL for GPA-HPA, default domain|
>     |             |   '------------------------------'
>     '-------------'
> Where:
>  - FL = First level/stage one page tables
>  - SL = Second level/stage two page tables

Yi,

Would you mind to always mention what tests you have been done with
the patchset in the cover letter?  It'll be fine to say that you're
running this against FPGAs so no one could really retest it, but still
it would be good to know that as well.  It'll even be better to
mention that which part of the series is totally untested if you are
aware of.

Thanks,

-- 
Peter Xu
