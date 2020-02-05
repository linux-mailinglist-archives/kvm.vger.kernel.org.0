Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5961E1532AB
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgBEOSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:18:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44388 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728057AbgBEOSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 09:18:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580912314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1dGbRA7pmfjMTjjm0vzl9/+wz0Bn0fpu96k2WzDU2gg=;
        b=MUrw6Dy+JLsmiUWYv/rUs+SluR2vIZlp+ikqPCGoNJs9sUIrdWDzJWZ8CLb/FXu1d0aAsS
        GnegyrUVarQhP4s+yAHezADAb1jkUH87gMOubrlg9fDsClZngL7svZUCmpEF9avuEFm86L
        E+F4KSacN7hf0giQQiRiLX0dTJgCcOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-amSae5N0MbyMQZpTPJVfbQ-1; Wed, 05 Feb 2020 09:18:29 -0500
X-MC-Unique: amSae5N0MbyMQZpTPJVfbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4BEA801E76;
        Wed,  5 Feb 2020 14:18:27 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 095EF790D4;
        Wed,  5 Feb 2020 14:18:26 +0000 (UTC)
Date:   Wed, 5 Feb 2020 07:18:26 -0700
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
Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Message-ID: <20200205071826.6d4d43d7@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1ABFF9@SHSMSX104.ccr.corp.intel.com>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
        <20200204161737.34696b91@w520.home>
        <A2975661238FB949B60364EF0F2C25743A1ABFF9@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Feb 2020 07:57:36 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, February 5, 2020 7:18 AM
> > To: kvm@vger.kernel.org
> > Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
> > 
> > 
> > Promised example QEMU test case...
> > 
> > commit 3557c63bcb286c71f3f7242cad632edd9e297d26
> > Author: Alex Williamson <alex.williamson@redhat.com>
> > Date:   Tue Feb 4 13:47:41 2020 -0700
> > 
> >     vfio-pci: QEMU support for vfio-pci VF tokens
> > 
> >     Example support for using a vf_token to gain access to a device as
> >     well as using the VFIO_DEVICE_FEATURE interface to set the VF token.
> >     Note that the kernel will disregard the additional option where it's
> >     not required, such as opening the PF with no VF users, so we can
> >     always provide it.
> > 
> >     NB. It's unclear whether there's value to this QEMU support without
> >     further exposure of SR-IOV within a VM.  This is meant mostly as a
> >     test case where the real initial users will likely be DPDK drivers.
> > 
> >     Signed-off-by: Alex Williamson <alex.williamson@redhat.com>  
> 
> Just curious how UUID is used across the test. Should the QEMU
> which opens VFs add the vfio_token=UUID or the QEMU which
> opens PF add the vfio_token=UUID? or both should add vfio_token=UUID.

In this example we do both as this covers the case where there are
existing VF users, which requires the PF to also provide the vf_token.
If there are no VF users, the PF is not required to provide a vf_token
and vfio-pci will not fail the device match if a vf_token is provided
but not needed.  In fact, when a PF is probed by vfio-pci a random
vf_token is set, so it's required to use a PF driver to set a known
vf_token before any VF users can access their VFs.  Thanks,

Alex

