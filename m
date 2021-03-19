Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173523428AA
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 23:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhCSWZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 18:25:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230492AbhCSWZr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 18:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616192747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Id8lKuzviOLir6fJj9EbKS5v9KIiHuyo8EpvVLbwXV0=;
        b=USEe2b12aCcKjyigTXD1MrJ8SRT3PedS9olEPVXQcbiGIyzuL/V/qidpEWOwTy4fRn6QMw
        xevid3mIi+1+6WLFmZ9kINqH8GW4MlJ/pEKGoZknwVd5zL+NbMnj4ZMoJ6v9bu/mANrIzL
        nUtLeDT9WyaEYDTgPlsUxMEAWF7hBOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-I9ohOC_MMVWdYe0Edf_HjQ-1; Fri, 19 Mar 2021 18:25:45 -0400
X-MC-Unique: I9ohOC_MMVWdYe0Edf_HjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3106F87A82A;
        Fri, 19 Mar 2021 22:25:44 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9467210013C1;
        Fri, 19 Mar 2021 22:25:40 +0000 (UTC)
Date:   Fri, 19 Mar 2021 16:25:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Subject: Re: [PATCH v1 07/14] vfio: Add a device notifier interface
Message-ID: <20210319162540.0c5fe9dd@omen.home.shazbot.org>
In-Reply-To: <20210310075639.GB662265@infradead.org>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
        <161524010999.3480.14282676267275402685.stgit@gimli.home>
        <20210310075639.GB662265@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Mar 2021 07:56:39 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Mar 08, 2021 at 02:48:30PM -0700, Alex Williamson wrote:
> > Using a vfio device, a notifier block can be registered to receive
> > select device events.  Notifiers can only be registered for contained
> > devices, ie. they are available through a user context.  Registration
> > of a notifier increments the reference to that container context
> > therefore notifiers must minimally respond to the release event by
> > asynchronously removing notifiers.  
> 
> Notifiers generally are a horrible multiplexed API.  Can't we just
> add a proper method table for the intended communication channel?

I've been trying to figure out how, but I think not.  A user can have
multiple devices, each with entirely separate IOMMU contexts.  For each
device, the user can create an mmap of memory to that device and add it
to every other IOMMU context.  That enables peer to peer DMA between
all the devices, across all the IOMMU contexts.  But each individual
device has no direct reference to any IOMMU context other than its own.
A callback on the IOMMU can't reach those other contexts either, there's
no guarantee those other contexts are necessarily managed via the same
vfio IOMMU backend driver.  A notifier is the best I can come up with,
please suggest if you have other ideas.  Thanks,

Alex

