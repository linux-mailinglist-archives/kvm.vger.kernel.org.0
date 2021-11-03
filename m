Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AE744499F
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 21:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhKCUjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 16:39:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhKCUjc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 16:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635971815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DtigDghF2ssUHtOwYSYkoEecxKtrZExnNE2ZBsAjzuI=;
        b=hfL3Vh+y9dHjWp8Qw1ts+/kGP8nAbnYCy84pE/LUZNLi8jTvB0KraRjtrNqXLYTBYz/nqd
        KvrIP973UMyCrmykbthdgYurDMxgF7z1ouQPDcwXsJnKsYHSindQtvf/fo0vyNMuZdJwbW
        nbhu8/GkAB+aFkzzdpUE1n8XEJv8Kkg=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-vrFEFnzzObSYfjn5F0RDwg-1; Wed, 03 Nov 2021 16:36:53 -0400
X-MC-Unique: vrFEFnzzObSYfjn5F0RDwg-1
Received: by mail-oi1-f200.google.com with SMTP id n4-20020aca5904000000b002a754d90130so2135828oib.16
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 13:36:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DtigDghF2ssUHtOwYSYkoEecxKtrZExnNE2ZBsAjzuI=;
        b=PmaV92OliByAxLRwFpLv3zpMWOJGUPL7qzD1pJaw5cpdxocJCJkiyfnM/cFQusWZ28
         tNtlVRk7ZxZyhhvLgWsLWPwP1AmyuNuGvYicMHABXPxhXim6NRTmcTD7f1DJGVeUPvcs
         41Ay0Xye1iluopEofhJtA0/sGuuQYbaByWcwCMYl5yZYD2wTDOIPCwnl6Qv8Ke9edI2I
         rnFX4X9MUK8uGJdFNnG3VRBVNJ4eUbkAfvcwqgyPc+vo7gT0c1hX7vf80TnwTLRLAmqy
         K7qLi0tUqgy/H43JS6g3absnCqmCXayYg4Fs4yhWcOpYH2L4+i/FCi3JmSB2MV9nb5D2
         YONw==
X-Gm-Message-State: AOAM531ABWd+eZQcK8Bex9w73lFtodwmofrUYnU9AtlFz7Cb/8/VVStO
        JoPS0jgrz90AkHc0ZJfulj2iXq3rGDIZdSh0gABCYZKIcvbLPnls55R3XFGuCmdxwg2CN++0/vc
        yZKmcfh94j0sV
X-Received: by 2002:a54:418a:: with SMTP id 10mr12604204oiy.13.1635971813022;
        Wed, 03 Nov 2021 13:36:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkoiheVRyD2amwXOB0aCJUs9gQuPxdebH6gcLgvPS6LRbKu+PwVo/AOENO7Oo1oPM99MLXrQ==
X-Received: by 2002:a54:418a:: with SMTP id 10mr12604186oiy.13.1635971812798;
        Wed, 03 Nov 2021 13:36:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bb33sm840332oob.2.2021.11.03.13.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:36:52 -0700 (PDT)
Date:   Wed, 3 Nov 2021 14:36:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     <pbonzini@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <arei.gonglei@huawei.com>
Subject: Re: [PATCH v5 0/6] optimize the downtime for vfio migration
Message-ID: <20211103143651.6576c0c4.alex.williamson@redhat.com>
In-Reply-To: <20211103081657.1945-1-longpeng2@huawei.com>
References: <20211103081657.1945-1-longpeng2@huawei.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Nov 2021 16:16:51 +0800
"Longpeng(Mike)" <longpeng2@huawei.com> wrote:

> Hi guys,
>  
> In vfio migration resume phase, the cost would increase if the
> vfio device has more unmasked vectors. We try to optimize it in
> this series.
>  
> You can see the commit message in PATCH 6 for details.
>  
> Patch 1-3 are simple cleanups and fixup.
> Patch 4-5 are the preparations for the optimization.
> Patch 6 optimizes the vfio msix setup path.
> 
> Changes v4->v5:
>  - setup the notifier and irqfd in the same function to makes
>    the code neater.    [Alex]

I wish this was posted a day earlier, QEMU entered soft-freeze for the
6.2 release yesterday[1].  Since vfio migration is still an
experimental feature, let's pick this up when the next development
window opens, and please try to get an ack from Paolo for the deferred
msi route function in the meantime.  Thanks,

Alex

[1]https://wiki.qemu.org/Planning/6.2

> 
> Changes v3->v4:
>  - fix several typos and grammatical errors [Alex]
>  - remove the patches that fix and clean the MSIX common part
>    from this series [Alex]
>  - Patch 6:
>     - use vector->use directly and fill it with -1 on error
>       paths [Alex]
>     - add comment before enable deferring to commit [Alex]
>     - move the code that do_use/release on vector 0 into an
>       "else" branch [Alex]
>     - introduce vfio_prepare_kvm_msi_virq_batch() that enables
>       the 'defer_kvm_irq_routing' flag [Alex]
>     - introduce vfio_commit_kvm_msi_virq_batch() that clears the
>       'defer_kvm_irq_routing' flag and does further work [Alex]
> 
> Changes v2->v3:
>  - fix two errors [Longpeng]
> 
> Changes v1->v2:
>  - fix several typos and grammatical errors [Alex, Philippe]
>  - split fixups and cleanups into separate patches  [Alex, Philippe]
>  - introduce kvm_irqchip_add_deferred_msi_route to
>    minimize code changes    [Alex]
>  - enable the optimization in msi setup path    [Alex]
> 
> Longpeng (Mike) (6):
>   vfio: simplify the conditional statements in vfio_msi_enable
>   vfio: move re-enabling INTX out of the common helper
>   vfio: simplify the failure path in vfio_msi_enable
>   kvm: irqchip: extract kvm_irqchip_add_deferred_msi_route
>   Revert "vfio: Avoid disabling and enabling vectors repeatedly in VFIO
>     migration"
>   vfio: defer to commit kvm irq routing when enable msi/msix
> 
>  accel/kvm/kvm-all.c  |  15 ++++-
>  hw/vfio/pci.c        | 176 ++++++++++++++++++++++++++++++++-------------------
>  hw/vfio/pci.h        |   1 +
>  include/sysemu/kvm.h |   6 ++
>  4 files changed, 130 insertions(+), 68 deletions(-)
> 

