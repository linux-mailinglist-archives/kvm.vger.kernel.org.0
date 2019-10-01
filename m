Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 716B3C3948
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 17:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389604AbfJAPiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 11:38:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfJAPix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 11:38:53 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6AB7C10C0944;
        Tue,  1 Oct 2019 15:38:53 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ACC95C226;
        Tue,  1 Oct 2019 15:38:52 +0000 (UTC)
Date:   Tue, 1 Oct 2019 09:38:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shawn Anastasio <shawn@anastas.io>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, Donald Dutile <ddutile@redhat.com>
Subject: Re: [PATCH RFC 0/1] VFIO: Region-specific file descriptors
Message-ID: <20191001093852.5c1d9c7c@x1.home>
In-Reply-To: <20190930235533.2759-1-shawn@anastas.io>
References: <20190930235533.2759-1-shawn@anastas.io>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 01 Oct 2019 15:38:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Sep 2019 18:55:32 -0500
Shawn Anastasio <shawn@anastas.io> wrote:

> This patch adds region file descriptors to VFIO, a simple file descriptor type
> that allows read/write/mmap operations on a single region of a VFIO device.
> 
> This feature is particularly useful for privileged applications that use VFIO
> and wish to share file descriptors with unprivileged applications without
> handing over full control of the device.

Such as?  How do we defined "privileged"?  VFIO already allows
"unprivileged applications" to own a device, only file permissions are
necessary for the VFIO group.  Does region level granularity really
allow us to claim that the consumer of this fd doesn't have full
control of the device?  Clearly device ioctls, including interrupts,
and DMA mappings are not granted with only access to a region, but said
unprivileged application may have absolute full control of the device
itself via that region.

> It also allows applications to use
> regular offsets in read/write/mmap instead of the region index + offset that
> must be used with device file descriptors.

How is this actually an issue that needs a solution?

> The current implementation is very raw (PCI only, no reference counting which
> is probably wrong), but I wanted to get a sense to see if this feature is
> desired. If it is, tips on how to implement this more correctly are
> appreciated.

Handling the ownership and life cycle of the region fds is the more
complicated problem.  If an unprivileged user has an mmap to a device
owned by a privileged user, how does it get revoked by the privileged
part of this equation?  How do we decide which regions merit this
support, for instance a device specific region could have just as
viable a use case as a BAR.  Why does this code limit support to
regions supporting mmap but then support read/write as well?

Technically, isn't the extent of functionality provided in this RFC
already available via the PCI resource files in sysfs?

Without a concrete use case, this looks like a solution in search of a
problem.  Thanks,

Alex
