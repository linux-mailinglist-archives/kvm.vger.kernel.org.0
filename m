Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97F41C9E85
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 00:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEGWep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 18:34:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54178 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726515AbgEGWep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 18:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588890884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YFxt0hAMAmZMhnnigW2On7zZSB0TMxbZAm7tsfbKgfA=;
        b=Fh45KTMZ7E/w3pwNnI7aK0L7zP9uSP4YrRHpqQM8Q0JfSJwpvUPiuYRhZAZwhB3+epWwYQ
        WirJY5aMxyc6/biPYEnPlp4u6Nt3Z7+PNRLry6CUqA/AVIFhtbX8dnpSKPdn4pPWydawXp
        wIhzD5XgleItkziCemCOcRzBDHYO/Nk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-pXGr9zU4Nwa0r0PzW6Vb6A-1; Thu, 07 May 2020 18:34:42 -0400
X-MC-Unique: pXGr9zU4Nwa0r0PzW6Vb6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C59C107ACCA;
        Thu,  7 May 2020 22:34:41 +0000 (UTC)
Received: from x1.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E05A5C1B0;
        Thu,  7 May 2020 22:34:38 +0000 (UTC)
Date:   Thu, 7 May 2020 16:34:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 0/3] vfio-pci: Block user access to disabled device
 MMIO
Message-ID: <20200507163437.77b4bf2e@x1.home>
In-Reply-To: <20200507215908.GQ228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
        <20200507215908.GQ228260@xz-x1>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 May 2020 17:59:08 -0400
Peter Xu <peterx@redhat.com> wrote:

> On Tue, May 05, 2020 at 03:54:36PM -0600, Alex Williamson wrote:
> > v2:
> > 
> > Locking in 3/ is substantially changed to avoid the retry scenario
> > within the fault handler, therefore a caller who does not allow retry
> > will no longer receive a SIGBUS on contention.  IOMMU invalidations
> > are still not included here, I expect that will be a future follow-on
> > change as we're not fundamentally changing that issue in this series.
> > The 'add to vma list only on fault' behavior is also still included
> > here, per the discussion I think it's still a valid approach and has
> > some advantages, particularly in a VM scenario where we potentially
> > defer the mapping until the MMIO BAR is actually DMA mapped into the
> > VM address space (or the guest driver actually accesses the device
> > if that DMA mapping is eliminated at some point).  Further discussion
> > and review appreciated.  Thanks,  
> 
> Hi, Alex,
> 
> I have a general question on the series.
> 
> IIUC this series tries to protect illegal vfio userspace writes to device MMIO
> regions which may cause platform-level issues.  That makes perfect sense to me.
> However what if the write comes from the devices' side?  E.g.:
> 
>   - Device A maps MMIO region X
> 
>   - Device B do VFIO_IOMMU_DMA_MAP on Device A's MMIO region X
>     (so X's MMIO PFNs are mapped in device B's IOMMU page table)
> 
>   - Device A clears PCI_COMMAND_MEMORY (reset, etc.)
>     - this should zap all existing vmas that mapping region X, however device
>       B's IOMMU page table is not aware of this?
> 
>   - Device B writes to MMIO region X of device A even if PCI_COMMAND_MEMORY
>     cleared on device A's PCI_COMMAND register
> 
> Could this happen?

Yes, this can happen and Jason has brought up variations on this
scenario that are important to fix as well.  I've got some ideas, but
the access in this series was the current priority.  There are also
issues in the above scenario that if a platform considers a DMA write
to an invalid IOMMU PTE and triggering an IOMMU fault to have the same
severity as the write to disabled MMIO space we've prevented, then our
hands are tied.  Thanks,

Alex

