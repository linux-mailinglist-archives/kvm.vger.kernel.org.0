Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 584F9153293
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgBEONW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:13:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57925 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727991AbgBEONW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580912000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RA1q163tSFNoE4JSzx/Wt2GVMECMjZ7C0brv5EqYlAE=;
        b=LuOk1iZfmCvWRFqQN41E0nt5ayo6sxoc13xOe/7p26xVWoRHObP8ZxTuWhRWfE2cAUghfi
        xW45rv1hTlAz2Zu7JT3+wzplJhvvy+3g/ouZI//bGsrAhCm64h1OUTbP8dGJG0D/4yiaZX
        5bBBd5OYtxSmx30FOtc/I3b1UQXYumY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-CTlUFyNKOzCsy256PkLXAg-1; Wed, 05 Feb 2020 09:13:18 -0500
X-MC-Unique: CTlUFyNKOzCsy256PkLXAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D30B8018A1;
        Wed,  5 Feb 2020 14:13:17 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CC92100164D;
        Wed,  5 Feb 2020 14:13:16 +0000 (UTC)
Date:   Wed, 5 Feb 2020 07:13:15 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [RFC PATCH 3/7] vfio/pci: Introduce VF token
Message-ID: <20200205071315.0569ed9e@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1ABFF0@SHSMSX104.ccr.corp.intel.com>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
        <158085756068.9445.6284766069491778316.stgit@gimli.home>
        <A2975661238FB949B60364EF0F2C25743A1ABFF0@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Feb 2020 07:57:29 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, February 5, 2020 7:06 AM
> > To: kvm@vger.kernel.org
> > Subject: [RFC PATCH 3/7] vfio/pci: Introduce VF token
> > 
> > If we enable SR-IOV on a vfio-pci owned PF, the resulting VFs are not
> > fully isolated from the PF.  The PF can always cause a denial of
> > service to the VF, if not access data passed through the VF directly.
> > This is why vfio-pci currently does not bind to PFs with SR-IOV enabled
> > and does not provide access itself to enabling SR-IOV on a PF.  The
> > IOMMU grouping mechanism might allow us a solution to this lack of
> > isolation, however the deficiency isn't actually in the DMA path, so
> > much as the potential cooperation between PF and VF devices.  Also,
> > if we were to force VFs into the same IOMMU group as the PF, we severely
> > limit the utility of having independent drivers managing PFs and VFs
> > with vfio.
> > 
> > Therefore we introduce the concept of a VF token.  The token is
> > implemented as a UUID and represents a shared secret which must be set
> > by the PF driver and used by the VF drivers in order to access a vfio
> > device file descriptor for the VF.  The ioctl to set the VF token will
> > be provided in a later commit, this commit implements the underlying
> > infrastructure.  The concept here is to augment the string the user
> > passes to match a device within a group in order to retrieve access to
> > the device descriptor.  For example, rather than passing only the PCI
> > device name (ex. "0000:03:00.0") the user would also pass a vf_token
> > UUID (ex. "2ab74924-c335-45f4-9b16-8569e5b08258").  The device match
> > string therefore becomes:
> > 
> > "0000:03:00.0 vf_token=2ab74924-c335-45f4-9b16-8569e5b08258"
> > 
> > This syntax is expected to be extensible to future options as well, with
> > the standard being:
> > 
> > "$DEVICE_NAME $OPTION1=$VALUE1 $OPTION2=$VALUE2"
> > 
> > The device name must be first and option=value pairs are separated by
> > spaces.
> > 
> > The vf_token option is only required for VFs where the PF device is
> > bound to vfio-pci.  There is no change for PFs using existing host
> > drivers.
> > 
> > Note that in order to protect existing VF users, not only is it required
> > to set a vf_token on the PF before VFs devices can be accessed, but also
> > if there are existing VF users, (re)opening the PF device must also
> > provide the current vf_token as authentication.  This is intended to
> > prevent a VF driver starting with a trusted PF driver and later being
> > replaced by an unknown driver.  A vf_token is not required to open the
> > PF device when none of the VF devices are in use by vfio-pci drivers.  
> 
> So vfio_token is a kind of per-PF token?

Yes, the token is per-PF.  Note that the token can be changed and it
does not "de-authenticate" opened VFs.  Thanks,

Alex

