Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B141C9E07
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 23:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEGV7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 17:59:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47143 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726742AbgEGV7O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 17:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588888753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zoaD/vZ99qPVucnfK3IScYf0rbMkx7qHOiz4Yv3Ogzg=;
        b=Ni1mw1pBzEkIkKE11YYFAQf1jBwyRJNPYsA+w4J2sSLRQC3nZrbnNy6HPOlUrGWZWcT9Of
        DAkVE/iC6yyEbThvTgO1CjpTB0yYzZaROkOQ421QDj7caYpdP9FviKu9s33G4SDSyrIjIP
        0N5lg/rmxsJ998rVxoxz3KNnlKvayrk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-aqVUs1jSOk-jZkPcrrqjUg-1; Thu, 07 May 2020 17:59:11 -0400
X-MC-Unique: aqVUs1jSOk-jZkPcrrqjUg-1
Received: by mail-qt1-f199.google.com with SMTP id d8so5861128qtq.0
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 14:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zoaD/vZ99qPVucnfK3IScYf0rbMkx7qHOiz4Yv3Ogzg=;
        b=N7/46tcrEXmjqDDKKQLxIJymUoH6HEeJx1x8oZx22Lv6JV9UgUq+OxLJ7eee2bE8nr
         9iSYjb0wyH6KXt95Nv43TryiHyQoYnoEF3XvnrWu7uV4/nN0kdgXz+WqaaeGD5Bozlgk
         MEcyNIVLgPfdCArFPtj8LbQRhuS6OtzpVn6X90SYjf0ecl5AhEArjU2KN3eBN6XVkAIo
         ToKZpMdv0AvCGcETVvIHGWZ13OikR98f2GAN/4bvew7wUXu73YfwAq3uJyrwXmQv/bvd
         8lMkG+ZvInQoNm6rXHlBTDow8p4ZcQx52+Jy82C5oBxKBOo019Q9qIXkTOModihFA76v
         W9kw==
X-Gm-Message-State: AGi0PuaxO8Q4KrwrRPMg1RUWuXeAfHupkGta80k2rrknCoWB4FixbW6Q
        ekgj7HMKfxdLsf5UnBCqxceBCs5rNPmf1nRUrUuuPvsUTio2Ao7GWn8Xm1OMySOugUEvgFnV63k
        m3GMfO3whrG7Z
X-Received: by 2002:aed:2dc1:: with SMTP id i59mr16853123qtd.182.1588888750767;
        Thu, 07 May 2020 14:59:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypLd8+jTdEka04fZzv2vUUpL+dHbxVfK9jv6upQkE8gQ0PDY1mJ/wapufSn+uMj7hMA/3PNRSg==
X-Received: by 2002:aed:2dc1:: with SMTP id i59mr16853106qtd.182.1588888750522;
        Thu, 07 May 2020 14:59:10 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id y3sm5259605qkc.4.2020.05.07.14.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 14:59:09 -0700 (PDT)
Date:   Thu, 7 May 2020 17:59:08 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 0/3] vfio-pci: Block user access to disabled device
 MMIO
Message-ID: <20200507215908.GQ228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <158871401328.15589.17598154478222071285.stgit@gimli.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 03:54:36PM -0600, Alex Williamson wrote:
> v2:
> 
> Locking in 3/ is substantially changed to avoid the retry scenario
> within the fault handler, therefore a caller who does not allow retry
> will no longer receive a SIGBUS on contention.  IOMMU invalidations
> are still not included here, I expect that will be a future follow-on
> change as we're not fundamentally changing that issue in this series.
> The 'add to vma list only on fault' behavior is also still included
> here, per the discussion I think it's still a valid approach and has
> some advantages, particularly in a VM scenario where we potentially
> defer the mapping until the MMIO BAR is actually DMA mapped into the
> VM address space (or the guest driver actually accesses the device
> if that DMA mapping is eliminated at some point).  Further discussion
> and review appreciated.  Thanks,

Hi, Alex,

I have a general question on the series.

IIUC this series tries to protect illegal vfio userspace writes to device MMIO
regions which may cause platform-level issues.  That makes perfect sense to me.
However what if the write comes from the devices' side?  E.g.:

  - Device A maps MMIO region X

  - Device B do VFIO_IOMMU_DMA_MAP on Device A's MMIO region X
    (so X's MMIO PFNs are mapped in device B's IOMMU page table)

  - Device A clears PCI_COMMAND_MEMORY (reset, etc.)
    - this should zap all existing vmas that mapping region X, however device
      B's IOMMU page table is not aware of this?

  - Device B writes to MMIO region X of device A even if PCI_COMMAND_MEMORY
    cleared on device A's PCI_COMMAND register

Could this happen?

Thanks,

-- 
Peter Xu

