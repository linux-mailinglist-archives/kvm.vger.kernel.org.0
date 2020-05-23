Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CF31DFAB7
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 21:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbgEWTeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 15:34:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32388 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727962AbgEWTeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 15:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590262462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZwVeospWQzWBd2Ckz6qsa+cBIBayXfsa3U5rcqOkNSc=;
        b=hGBvsA05+/RATfO0md7Bm9LDTyR3azhsdHRSQPMlBDjP1KkcoNzoUNg/0P9TDANFqOkvzk
        aXhY4rlqE7Tr9+2q/8U/ZupVNt7+tIIy8AIj86waJjniBDGF1Vl4AzRq+RnUGYm0Idg1TJ
        iIfkZtPQAYsZDG/0AhSHno/fikS/gok=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-KV9JyzhaP62NWxxCLe-NoA-1; Sat, 23 May 2020 15:34:20 -0400
X-MC-Unique: KV9JyzhaP62NWxxCLe-NoA-1
Received: by mail-qk1-f197.google.com with SMTP id p5so9375409qkg.12
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 12:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZwVeospWQzWBd2Ckz6qsa+cBIBayXfsa3U5rcqOkNSc=;
        b=SdtTnYRZCPTpPR5rWjr0+pcp9O3Jp/OgIdG5M1cRs5eCKtLIuT1uCJ40ycvwPvz4lz
         RxKEJ86Orxhl95+4ASVAbmnSP1gjaptr6fQT2P/b9hcw3m75nx1ZlMpwtRUPs/MPXG+F
         0AYdOQ+USi4Z0tJBs7inY5ajxZJRJyxzE9Dv0mUaioY9ptvJOKj0wL4c1ldQr0zxhGd+
         YsgPrAhUJWrAdistYfc58aIgvoLQVKMqORwzbBeis/+hSS/vDKndeY3fgZ9wvlDxA8Sx
         xYA8NF01tEpzo+yB9N7365W8pboPQFo3CuvR4BOP2AL4Yu9sZa7gZPrVrEZnoEK62Plp
         Qgaw==
X-Gm-Message-State: AOAM530ZgvMIlFh7zPXR/nz73Z9V3rdnSyXmPbZSwKCNMwqZ0Qiv2PXx
        hq5NKwLCK9kL2D/avQOkT6tZPXkMWiirGbV+NZLhTN2zb/hxYk80U/6SFXGtlNS17lUbU0EbyAc
        eWADVWbabsq0/
X-Received: by 2002:a37:490:: with SMTP id 138mr20187713qke.199.1590262460143;
        Sat, 23 May 2020 12:34:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXoWZIY0o5CFf8fx4b1C6Zs4/6XKmwWKD3ydRMLJhK+DLPOyxQZBXyhKbfchOrVAsReukLiA==
X-Received: by 2002:a37:490:: with SMTP id 138mr20187698qke.199.1590262459865;
        Sat, 23 May 2020 12:34:19 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id s45sm725970qte.26.2020.05.23.12.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 12:34:18 -0700 (PDT)
Date:   Sat, 23 May 2020 15:34:17 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca, cai@lca.pw
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200523193417.GI766834@xz-x1>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
 <159017506369.18853.17306023099999811263.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <159017506369.18853.17306023099999811263.stgit@gimli.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Alex,

On Fri, May 22, 2020 at 01:17:43PM -0600, Alex Williamson wrote:
> @@ -1346,15 +1526,32 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct vfio_pci_device *vdev = vma->vm_private_data;
> +	vm_fault_t ret = VM_FAULT_NOPAGE;
> +
> +	mutex_lock(&vdev->vma_lock);
> +	down_read(&vdev->memory_lock);

I remembered to have seen the fault() handling FAULT_FLAG_RETRY_NOWAIT at least
in the very first version, but it's not here any more...  Could I ask what's
the reason behind?  I probably have missed something along with the versions,
I'm just not sure whether e.g. this would potentially block a GUP caller even
if it's with FOLL_NOWAIT.

Side note: Another thing I thought about when reading this patch - there seems
to have quite some possibility that the VFIO_DEVICE_PCI_HOT_RESET ioctl will
start to return -EBUSY now.  Not a problem for this series, but maybe we should
rememeber to let the userspace handle -EBUSY properly as follow up too, since I
saw QEMU seemed to not handle -EBUSY for host reset path right now.

Thanks,

-- 
Peter Xu

