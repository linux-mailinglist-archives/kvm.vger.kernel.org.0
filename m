Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD3433FAB7
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 23:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhCQV71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 17:59:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhCQV7F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 17:59:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616018344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSnaWPyHU+XNaUdwtMxbOXhvZ96oK+zmkpA1zD9dlWI=;
        b=B7sEWRtwYta+Bzm8L1EYeiYL6+Xm/x3BNLnPQgXHwLcQKE5LdGbnhSxMZ8zQoBgyPOLh5f
        jKM/P/6Y+TDRWbmP4VwV9f5Jafv+KH780KuG9LJvF5iqiuQKkmGSzLd/iJNNzeNRilioZz
        +LWN3d7QaxsRDgr+DEtVwVGxehicT+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-YtIt6xFbOryfMhTj4ZZEAA-1; Wed, 17 Mar 2021 17:59:00 -0400
X-MC-Unique: YtIt6xFbOryfMhTj4ZZEAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CED1108BD07;
        Wed, 17 Mar 2021 21:58:59 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 461FE5D6CF;
        Wed, 17 Mar 2021 21:58:59 +0000 (UTC)
Date:   Wed, 17 Mar 2021 15:58:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Derrick, Jonathan" <jonathan.derrick@intel.com>
Cc:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Instantiate mdev device in host?
Message-ID: <20210317155858.666cdeba@omen.home.shazbot.org>
In-Reply-To: <abb1183682ccc1bc8bb2239bf581a0b635c21804.camel@intel.com>
References: <abb1183682ccc1bc8bb2239bf581a0b635c21804.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 17 Mar 2021 19:13:30 +0000
"Derrick, Jonathan" <jonathan.derrick@intel.com> wrote:

> Hi Kirti, Alex,
> 
> I've written a host mdev driver for a pcie instrument that divides its
> resources to a guest driver and manages per-instance interfacing.
> 
> We have a use case where we might want to drive the instrument directly
> from the host in the same application that the mdev guest would use.
> 
> Is there a way to instantiate the emulated pci device in the host?
> Or a recommended way to interface an existing pci (guest) driver to the
> vfio-mdev device?

No, mdev is exposing the device through the vfio API, you either need a
driver for that API (ex. DPDK) or you need something to compose that
API into a virtual PCI device for a guest (QEMU).  mdev devices cannot
make a new struct pci_dev in the host for a host drivers to bind to,
you'd want something more like direct SR-IOV for that.  Potentially if
you're willing to run the application in a container, a Kata container
could transparently include that re-composition in QEMU.  This seems
like the same problem your SIOV friends @Intel are facing, where
creating separate userspace interfaces, one via mdev and one via device
specific mechanism has been discouraged.  You might look at how idxd
development has been working to address this criticism.  Thanks,

Alex

