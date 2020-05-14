Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C18B1D3FF4
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 23:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgENVZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 17:25:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22580 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726201AbgENVZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 17:25:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589491544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UMjf23zFxOglYOyxZxoYs74d6iz4BTimsqthHh9qfeo=;
        b=ULaTm6JvxlkqIAq+9VaZucu7t95MKMWbdA1ZXyu5CVMSbc6MG/9RBG2B2Pw4+MI1witUGq
        nW+XmRrXE0qnQGvO3iqB5p+cKR5JdXW6w8jSJIVM24MgdrU5j9dAHk+rsFEjlxA5ZN5Xv/
        605wSpNS4tuCWRISXZThwZXHCRGe/iY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-Q_fyCUyiOeSl9HzrSadRjA-1; Thu, 14 May 2020 17:25:42 -0400
X-MC-Unique: Q_fyCUyiOeSl9HzrSadRjA-1
Received: by mail-qk1-f198.google.com with SMTP id i10so4433975qkm.23
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 14:25:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UMjf23zFxOglYOyxZxoYs74d6iz4BTimsqthHh9qfeo=;
        b=DjH3Ty/DlnA/sFKNMELZ5t7UVriTNBI5RPYBA8hOoqvRH3N8PUv9iF0HX3TUtPgAb7
         8C/4CoA+fMSEmF8BkKnrZiw/phomGZ5kyTNmCxNVk8PmEVz265ASZfnFSwfRlG9KgZpZ
         GqucZYAZUbF/ExFMtUwVYTCTNEY/OyuvqzB1riWbsk7eyIqhtzo4+7uhxwUfEVP5nkaf
         NJgfLGqA/GiEfahxXkwAstmkr4Ry2EoRbnNovCpf9eNy0yUoX6c3DL9M4wYYvnJvf06g
         auniDQVLz6hbGRLCK2cfDhr1cbzGs1Hf2qsoTIv3yBpt75tnJGxrkyAD+XlWgFzTbybR
         ua4w==
X-Gm-Message-State: AOAM533bvETET7KjWJGxEeCborBkX28gghpuTBNNDh/JTi3OKidJfzM/
        hCbuDBhCC+gLRKgvt4Jcqu3beH0KDXz+0q20KaABos5cm1d5g2QLizQv1/C6ziZZvblAklCnzoi
        69MGspg5ZJ9KJ
X-Received: by 2002:a37:9a95:: with SMTP id c143mr336814qke.201.1589491541748;
        Thu, 14 May 2020 14:25:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiNs/Iz+y1EJvRQqDBIFBJ9ciXXLpzG5kxc5nWqOibFPZOFtWmZWw9dt+cyJR7ZguLOk4Vbg==
X-Received: by 2002:a37:9a95:: with SMTP id c143mr336788qke.201.1589491541421;
        Thu, 14 May 2020 14:25:41 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id v82sm75173qkb.102.2020.05.14.14.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 14:25:40 -0700 (PDT)
Date:   Thu, 14 May 2020 17:25:38 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH 0/2] vfio/type1/pci: IOMMU PFNMAP invalidation
Message-ID: <20200514212538.GB449815@xz-x1>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <158947414729.12590.4345248265094886807.stgit@gimli.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 10:51:46AM -0600, Alex Williamson wrote:
> This is a follow-on series to "vfio-pci: Block user access to disabled
> device MMIO"[1], which extends user access blocking of disabled MMIO
> ranges to include unmapping the ranges from the IOMMU.  The first patch
> adds an invalidation callback path, allowing vfio bus drivers to signal
> the IOMMU backend to unmap ranges with vma level granularity.  This
> signaling is done both when the MMIO range becomes inaccessible due to
> memory disabling, as well as when a vma is closed, making up for the
> lack of tracking or pinning for non-page backed vmas.  The second
> patch adds registration and testing interfaces such that the IOMMU
> backend driver can test whether a given PFNMAP vma is provided by a
> vfio bus driver supporting invalidation.  We can then implement more
> restricted semantics to only allow PFNMAP DMA mappings when we have
> such support, which becomes the new default.

Hi, Alex,

IIUC we'll directly tearing down the IOMMU page table without telling the
userspace for those PFNMAP pages.  I'm thinking whether there be any side
effect on the userspace side when userspace cached these mapping information
somehow.  E.g., is there a way for userspace to know this event?

Currently, QEMU VT-d will maintain all the IOVA mappings for each assigned
device when used with vfio-pci.  In this case, QEMU will probably need to
depend some invalidations sent from the guest (either userspace or kernel)
device drivers to invalidate such IOVA mappings after they got removed from the
hardware IOMMU page table underneath.  I haven't thought deeper on what would
happen if the vIOMMU has got an inconsistent mapping of the real device.

Thanks,

-- 
Peter Xu

