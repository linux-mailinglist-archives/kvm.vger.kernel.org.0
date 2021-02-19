Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64567320126
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 23:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhBSWEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 17:04:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229983AbhBSWDx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 17:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613772147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VMwl2ARrFtttYnheAWs2MecA8KG8y/PoCZqgvarbQAM=;
        b=MG34wcoAyWvJJenEpLwbjFgCpvdSBWZ5ivZpj7hmZRk14M5DJq3QLbnrrcf5jzgMdV+jOB
        /ZyPDDs2jh9hExFZJiHrwF13sMccK5MLCBI7r2u1RONAgOlODJlQkrLD1uzYesZE48WrN5
        +HuE9LWILj6Q7pspZEmE7JyrtM7tvAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-NBe4Qgu4OJyT7FX1GSzsEA-1; Fri, 19 Feb 2021 17:02:24 -0500
X-MC-Unique: NBe4Qgu4OJyT7FX1GSzsEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 227AD804023;
        Fri, 19 Feb 2021 22:02:23 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9842A100239F;
        Fri, 19 Feb 2021 22:02:19 +0000 (UTC)
Date:   Fri, 19 Feb 2021 15:02:19 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [PATCH 1/3] vfio: Introduce vma ops registration and notifier
Message-ID: <20210219150219.7c0de5ad@omen.home.shazbot.org>
In-Reply-To: <20210218230404.GD4247@nvidia.com>
References: <161315658638.7320.9686203003395567745.stgit@gimli.home>
        <161315805248.7320.13358719859656681660.stgit@gimli.home>
        <20210212212057.GW4247@nvidia.com>
        <20210218011209.GB4247@nvidia.com>
        <20210218145606.09f08044@omen.home.shazbot.org>
        <20210218230404.GD4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 19:04:04 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Feb 18, 2021 at 02:56:06PM -0700, Alex Williamson wrote:
> 
> > Looks pretty slick.  I won't claim it's fully gelled in my head yet,
> > but AIUI you're creating these inodes on your new pseudo fs and
> > associating it via the actual user fd via the f_mapping pointer, which
> > allows multiple fds to associate and address space back to this inode
> > when you want to call unmap_mapping_range().    
> 
> Yes, from what I can tell all the fs/inode stuff is just mandatory
> overhead to get a unique address_space pointer, as that is the only
> thing this is actually using.
> 
> I have to check the mmap flow more carefully, I recall pointing to a
> existing race here with Daniel, but the general idea should hold.
> 
> > That clarifies from the previous email how we'd store the inode on
> > the vfio_device without introducing yet another tracking list for
> > device fds.  
> 
> Right, you can tell from the vma what inode it is for, and the inode
> can tell you if it is a VFIO VMA or not, so no tracking lists needed
> at all.

Seems to be a nice cleanup for vfio as well, more testing and analysis
required, but here are a few (4) wip commits that re-implement the
current vma zapping scheme following your example: 

https://github.com/awilliam/linux-vfio/commits/vfio-unmap-mapping-range

Thanks,
Alex

