Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD0A13C71E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 16:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAOPMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 10:12:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23165 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726165AbgAOPMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 10:12:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579101152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QY8+0O7c2VwRb5cv2HAAJnI3AuJd5YIMsYZK7EcA7eM=;
        b=gQ7Ovka41D1ndqnlJNXMWFZW0O5gqgk6JVeuoPHa9CpXPHtZokbn4w9LOSm0zjODhpELR8
        VyhAn6CyuDsUV/LYJEpD62fm6uIkLjSKqYYkwNgIFV4SAq6B8xY9b/237h8o6BiaxW0hiY
        VZK6xtcOBQi3Hw2vbjlkP2agITzYIis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-fEpNw1loObWxgDUPpaV5nQ-1; Wed, 15 Jan 2020 10:12:29 -0500
X-MC-Unique: fEpNw1loObWxgDUPpaV5nQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 041D410052E2;
        Wed, 15 Jan 2020 15:12:28 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB0EA84322;
        Wed, 15 Jan 2020 15:12:24 +0000 (UTC)
Date:   Wed, 15 Jan 2020 08:12:24 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kevin.tian@intel.com, joro@8bytes.org, peterx@redhat.com,
        baolu.lu@linux.intel.com
Subject: Re: [PATCH v4 05/12] vfio_pci: duplicate vfio_pci.c
Message-ID: <20200115081224.215a994c@w520.home>
In-Reply-To: <20200115120300.24874a37.cohuck@redhat.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-6-git-send-email-yi.l.liu@intel.com>
        <20200115120300.24874a37.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Jan 2020 12:03:00 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue,  7 Jan 2020 20:01:42 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch has no code change, just a file copy. In following patches,
> > vfio_pci_common.c will be modified to only include the common functions
> > and related static functions in original vfio_pci.c. Meanwhile, vfio_pci.c
> > will be modified to only include vfio-pci module specific codes.
> > 
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_common.c | 1708 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 1708 insertions(+)
> >  create mode 100644 drivers/vfio/pci/vfio_pci_common.c  
> 
> This whole procedure of "let's copy the file and rip out unneeded stuff
> later" looks very ugly to me, especially if I'd come across it in the
> future, e.g. during a bisect. This patch only adds a file that is not
> compiled, and later changes will be "rip out unwanted stuff from
> vfio_pci_common.c" instead of the more positive "move common stuff to
> vfio_pci_common.c". I think refactoring/moving interfaces/code that it
> makes sense to share makes this more reviewable, both now and in the
> future.

I think this comes largely at my request from previous reviews.  It's
very easy to apply this patch and diff the files to see that nothing
has changed, then review the subsequent patch to see that code is only
added or removed to check that there are no actual code changes.  If we
just selectively move code then I think it's left to our inspection to
verify nothing has changed.  Maybe this is a dummy step in a bisect,
but I don't see that you lose any granularity.  Thanks,

Alex

