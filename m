Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE80C2C2FCA
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 19:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390801AbgKXSMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 13:12:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390661AbgKXSMe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 13:12:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606241553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2oBIff2vrXptsOCDgJqXcxsBYnjbQeRRHymVbCela8Y=;
        b=iambVB7RaNJVgMF2xdeXvuIPNhUj6J3ZHt3kPUVGfVNiKuLP8gsMyrKNxzhh9DQ1OpJjsv
        j3wrJglq6asAKY91OQnqhH7etR+5dR/+9ZFQqzP0qNmha3L8oJFH60lj0TlorujYu845Ok
        9g4/FzumrwZajALTHjEDfbfqaMyrpMM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-pJBqUPlWOtS6qyMSjytxxQ-1; Tue, 24 Nov 2020 13:12:31 -0500
X-MC-Unique: pJBqUPlWOtS6qyMSjytxxQ-1
Received: by mail-qv1-f70.google.com with SMTP id o16so2755150qvq.4
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 10:12:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2oBIff2vrXptsOCDgJqXcxsBYnjbQeRRHymVbCela8Y=;
        b=TCJCJ4COEffALSQlCJ63j7SUhYKe7sGqshTMeB122QnUjxrG3YS5IcJrQq+9fvDuvy
         GMLjS0BgDRRUojPM+JxAU9XELR9RTCw5HY8zJWEfBI2agDUD1Obaa1jal6Rv9uG5cC75
         AXdoqtb60cC/kTSwLxJXUEzgIJqS+WU88VKNfFTigqCWuANX4pYTNrXfqhnuZr3qKeJ1
         cWZte2xBXMIu8viXUeJs5DBTWpq+rKGtSZPzrtxulH57eXxeq6WojEeM2H1xYfsqRbja
         r3QiTjwuRXQyFlGaKGstAXJjLeru6B35CSdehlf+MZYp5PL9X+p7LL1t9DG3PqKNqBDF
         vqsA==
X-Gm-Message-State: AOAM531TKAu2r9EJ13FfwB7T2xMBa0gZFzrbqKulVWwl7JJDlzOFO/P7
        MohjGPEQO4ioizQQNb6NhI3Giho6ZmEEfl/c63rs76noHkN1R9PaUMWL/92U42eGkhhXA3IjBht
        7Sd/ZcueVogr6
X-Received: by 2002:a0c:eec4:: with SMTP id h4mr6166751qvs.35.1606241551010;
        Tue, 24 Nov 2020 10:12:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyYkcubJCjDfr3L92syDxFxlSzaLINmTiYCYOGr9X/iVg27guubvICQfcGQ1RnmdVIfefltCQ==
X-Received: by 2002:a0c:eec4:: with SMTP id h4mr6166727qvs.35.1606241550714;
        Tue, 24 Nov 2020 10:12:30 -0800 (PST)
Received: from xz-x1 ([142.126.81.247])
        by smtp.gmail.com with ESMTPSA id q32sm14116193qtb.71.2020.11.24.10.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 10:12:29 -0800 (PST)
Date:   Tue, 24 Nov 2020 13:12:28 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jia He <justin.he@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Message-ID: <20201124181228.GA276043@xz-x1>
References: <20201119142737.17574-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201119142737.17574-1-justin.he@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jia,

On Thu, Nov 19, 2020 at 10:27:37PM +0800, Jia He wrote:
> The permission of vfio iommu is different and incompatible with vma
> permission. If the iotlb->perm is IOMMU_NONE (e.g. qemu side), qemu will
> simply call unmap ioctl() instead of mapping. Hence vfio_dma_map() can't
> map a dma region with NONE permission.
> 
> This corner case will be exposed in coming virtio_fs cache_size
> commit [1]
>  - mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>    memory_region_init_ram_ptr()
>  - re-mmap the above area with read/write authority.

If iiuc here we'll remap the above PROT_NONE into PROT_READ|PROT_WRITE, then...

>  - vfio_dma_map() will be invoked when vfio device is hotplug added.

... here I'm slightly confused on why VFIO_IOMMU_MAP_DMA would encounter vma
check fail - aren't they already get rw permissions?

I'd appreciate if you could explain why vfio needs to dma map some PROT_NONE
pages after all, and whether QEMU would be able to postpone the vfio map of
those PROT_NONE pages until they got to become with RW permissions.

Thanks,

-- 
Peter Xu

