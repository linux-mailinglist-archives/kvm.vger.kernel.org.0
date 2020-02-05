Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8AF153259
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 14:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgBEN6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 08:58:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32310 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbgBEN6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 08:58:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580911125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YJfMTUUUyxi1VxzyCVz1DpE8ZQQJQVENAYA2Qdsr+C4=;
        b=dwLrnXlK25oW+gZJhMnHoe/GUlXiqNZZKJQcS77r5u014ZLYG2XzNp7Ud1HsaLN/ufTiNS
        dyRd6P46FH5QGkDXWYo5Bd8BqSY0wtenC2Jpy6mx8L/JY1F1sZgwNLb5U1qNPoOgZhEKy1
        iC/7dMv+4wFgBms8hZl+/5bHH3vxBPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-L5PxdEJ5PkSHPDZ0suQfBQ-1; Wed, 05 Feb 2020 08:58:41 -0500
X-MC-Unique: L5PxdEJ5PkSHPDZ0suQfBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 589E12EEB;
        Wed,  5 Feb 2020 13:58:39 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A37419C7F;
        Wed,  5 Feb 2020 13:58:38 +0000 (UTC)
Date:   Wed, 5 Feb 2020 06:58:36 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Message-ID: <20200205065836.12308197@x1.home>
In-Reply-To: <20200205070109.GA18027@infradead.org>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
        <20200205070109.GA18027@infradead.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Feb 2020 23:01:09 -0800
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Feb 04, 2020 at 04:05:34PM -0700, Alex Williamson wrote:
> > We address this in a few ways in this series.  First, we can use a bus
> > notifier and the driver_override facility to make sure VFs are bound
> > to the vfio-pci driver by default.  This should eliminate the chance
> > that a VF is accidentally bound and used by host drivers.  We don't
> > however remove the ability for a host admin to change this override.  
> 
> That is just such a bad idea.  Using VFs in the host is a perfectly
> valid use case that you are breaking.

vfio-pci currently does not allow binding to a PF with VFs enabled and
does not provide an sriov_configure callback, so it's not possible to
have VFs on a vfio-pci bound PF.  Therefore I'm not breaking any
existing use cases.  I'm also not preventing VFs from being used in the
host, I only set a default driver_override value, which can be replaced
if a different driver binding is desired.  So I also don't see that I'm
breaking a usage model here.  I do stand by the idea that VFs sourced
from a user owned PF should not by default be used in the host (ie.
autoprobed on device add).  There's a pci-pf-stub driver that can be
used to create VFs on a PF if no userspace access of the PF is required.
Thanks,

Alex

