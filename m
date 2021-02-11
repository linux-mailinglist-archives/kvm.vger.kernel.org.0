Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB20531934E
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 20:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhBKTp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 14:45:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229731AbhBKTp1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 14:45:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613072640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eFsY3BREFzEWy1QnYPGFKXq13XSYJPUDZ/zXRChLIII=;
        b=YgsETP2xc4aHDeWj6yCVLIMGla87hznfNvoY6VnAyyGYYx6g/iH2RPtSeprIBknczS9j69
        VHmoqiS8k+GMtcYrK5cJTiaaGER1IUOM7YYTvVgNPrhOKjjGzv+2oTPx3aKiCAbT2iMAdH
        Q2j/7OURieArPlmnXmB87zjvffmb+vE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-PDd46njoMeKtUChwvOp2uQ-1; Thu, 11 Feb 2021 14:43:56 -0500
X-MC-Unique: PDd46njoMeKtUChwvOp2uQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C818801965;
        Thu, 11 Feb 2021 19:43:53 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A6A510013D7;
        Thu, 11 Feb 2021 19:43:52 +0000 (UTC)
Date:   Thu, 11 Feb 2021 12:43:51 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, gmataev@nvidia.com,
        cjia@nvidia.com, yishaih@nvidia.com, aik@ozlabs.ru
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210211124351.53a833c5@omen.home.shazbot.org>
In-Reply-To: <20210211084426.GB2378134@infradead.org>
References: <20210202170659.1c62a9e8.cohuck@redhat.com>
        <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
        <20210202105455.5a358980@omen.home.shazbot.org>
        <20210202185017.GZ4247@nvidia.com>
        <20210202123723.6cc018b8@omen.home.shazbot.org>
        <20210202204432.GC4247@nvidia.com>
        <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
        <20210202143013.06366e9d@omen.home.shazbot.org>
        <20210202230604.GD4247@nvidia.com>
        <20210202165923.53f76901@omen.home.shazbot.org>
        <20210211084426.GB2378134@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Feb 2021 08:44:26 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Feb 02, 2021 at 04:59:23PM -0700, Alex Williamson wrote:
> > vfio-pci-igd support knows very little about the device, we're
> > effectively just exposing a firmware table and some of the host bridge
> > config space (read-only).  So the idea that the host kernel needs to
> > have updated i915 support in order to expose the device to userspace
> > with these extra regions is a bit silly.  
> 
> On the other hand assuming the IGD scheme works for every device
> with an Intel Vendor ID and a VGA classcode that hangs off an Intel
> host bridge seems highly dangerous.  Is this actually going to work
> for the new discreete Intel graphics?  For the old i740?  And if not
> what is the failure scenario?

The failure scenario is that we expose read-only copies of the OpRegion
firmware table and host and lpc bridge config space to userspace.  Not
exactly dangerous.  For discrete graphics we'd simply fail the device
probe if the target device isn't on the root bus.  This would cover the
old i740 as well, assuming you're seriously concerned about someone
plugging in a predominantly AGP graphics card from 20+ years ago into a
modern system and trying to assign it to a guest.  Thanks,

Alex

