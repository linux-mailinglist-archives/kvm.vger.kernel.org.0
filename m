Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E3E23D8C3
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 11:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgHFJhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 05:37:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44991 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729228AbgHFJg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 05:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596706615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2SRXYqR/w4ZPmQdMHnc72Nwp3MhKm+bh3iVJiUJELNE=;
        b=ISelayjvZq0aFt5mkkgJVvzj00VbSJBZZGgzsuTGeH067PsenEEvUsUj8IzBONYtRK45qG
        DFfO1pZSfqPSjhjSYbQhVh7c3w7SspCH/jhpZOamrjoheNH5Fz5ZPWyGyEUih7A+dWfDYi
        oklV5b2Y/xb4Ir2hxGemH6lri1uGUok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-H-9PRI80Pv28O2DYRxpUzg-1; Thu, 06 Aug 2020 05:36:53 -0400
X-MC-Unique: H-9PRI80Pv28O2DYRxpUzg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B39D1940922;
        Thu,  6 Aug 2020 09:36:52 +0000 (UTC)
Received: from gondolin (ovpn-113-2.ams2.redhat.com [10.36.113.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E70F5C6D9;
        Thu,  6 Aug 2020 09:36:48 +0000 (UTC)
Date:   Thu, 6 Aug 2020 11:36:45 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio-pci: Avoid recursive read-lock usage
Message-ID: <20200806113645.47de0bfa.cohuck@redhat.com>
In-Reply-To: <159665024415.30380.4401928486051321567.stgit@gimli.home>
References: <159665024415.30380.4401928486051321567.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 05 Aug 2020 11:58:05 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> A down_read on memory_lock is held when performing read/write accesses
> to MMIO BAR space, including across the copy_to/from_user() callouts
> which may fault.  If the user buffer for these copies resides in an
> mmap of device MMIO space, the mmap fault handler will acquire a
> recursive read-lock on memory_lock.  Avoid this by reducing the lock
> granularity.  Sequential accesses requiring multiple ioread/iowrite
> cycles are expected to be rare, therefore typical accesses should not
> see additional overhead.
> 
> VGA MMIO accesses are expected to be non-fatal regardless of the PCI
> memory enable bit to allow legacy probing, this behavior remains with
> a comment added.  ioeventfds are now included in memory access testing,
> with writes dropped while memory space is disabled.
> 
> Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_private.h |    2 +
>  drivers/vfio/pci/vfio_pci_rdwr.c    |  120 ++++++++++++++++++++++++++++-------
>  2 files changed, 98 insertions(+), 24 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

