Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6C6217C6C
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 03:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgGHBGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 21:06:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56847 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727945AbgGHBGp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 21:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594170403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MyBL39NEb8P3d0jU5/s3v3hCuzlaOZFArMfQRq0UeVI=;
        b=cwoVp3BnBjKjh0s+2y6dr3xW9uNFjhnKyT8N34DKn5w/C2AeA3wHV34TprKgujwwkQdWaJ
        V2fJlpU5sPF4e/bMbTZP3GrHtAp9t3eK70w4j5SWNtt4ubSqp0Atq8BfXyuScqtVIkJBCG
        jRCLAPBNrNV3RRQHYmo73GqSAKcIC9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-fpsK9bDJMomPq0HBpIi2cA-1; Tue, 07 Jul 2020 21:06:36 -0400
X-MC-Unique: fpsK9bDJMomPq0HBpIi2cA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6A4280183C;
        Wed,  8 Jul 2020 01:06:35 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FFB578468;
        Wed,  8 Jul 2020 01:06:35 +0000 (UTC)
Date:   Tue, 7 Jul 2020 19:06:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Message-ID: <20200707190634.4d9055fe@x1.home>
In-Reply-To: <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
        <20200408055824.2378-1-zhenyuw@linux.intel.com>
        <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jul 2020 23:28:39 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> Hi, Alex, 
> 
> Gentle ping... Please let us know whether this version looks good.

I figured this is entangled with the versioning scheme.  There are
unanswered questions about how something that assumes a device of a
given type is software compatible to another device of the same type
handles aggregation and how the type class would indicate compatibility
with an aggregated instance.  Thanks,

Alex


> > From: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Sent: Wednesday, April 8, 2020 1:58 PM
> > 
> > Hi,
> > 
> > This is a refresh on previous series:
> > https://patchwork.kernel.org/cover/11208279/
> > and https://patchwork.freedesktop.org/series/70425/
> > 
> > Current mdev device create interface depends on fixed mdev type, which
> > get uuid from user to create instance of mdev device. If user wants to
> > use customized number of resource for mdev device, then only can
> > create new mdev type for that which may not be flexible. This
> > requirement comes not only from to be able to allocate flexible
> > resources for KVMGT, but also from Intel scalable IO virtualization
> > which would use vfio/mdev to be able to allocate arbitrary resources
> > on mdev instance. More info on [1] [2] [3].
> > 
> > As we agreed that for current opaque mdev device type, we'd still
> > explore management interface based on mdev sysfs definition. And this
> > one tries to follow Alex's previous suggestion to create generic
> > parameters under 'mdev' directory for each device, so vendor driver
> > could provide support like as other defined mdev sysfs entries.
> > 
> > For mdev type with aggregation support, files as "aggregated_instances"
> > and "max_aggregation" should be created under 'mdev' directory. E.g
> > 
> > /sys/devices/pci0000:00/0000:00:02.0/<UUID>/mdev/
> >    |-- aggregated_instances
> >    |-- max_aggregation
> > 
> > "aggregated_instances" is used to set or return current number of
> > instances for aggregation, which can not be larger than "max_aggregation".
> > 
> > The first patch is to update the document for new mdev parameter directory.
> > The second one is to add aggregation support in GVT driver.
> > 
> > References:
> > [1] https://software.intel.com/en-us/download/intel-virtualization-
> > technology-for-directed-io-architecture-specification
> > [2] https://software.intel.com/en-us/download/intel-scalable-io-
> > virtualization-technical-specification
> > [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
> > 
> > Changelog:
> > v3:
> > - add more description for sysfs entries
> > - rebase GVT support
> > - rename accounting function
> > 
> > Zhenyu Wang (2):
> >   Documentation/driver-api/vfio-mediated-device.rst: update for
> >     aggregation support
> >   drm/i915/gvt: mdev aggregation type
> > 
> >  .../driver-api/vfio-mediated-device.rst       |  22 +++
> >  drivers/gpu/drm/i915/gvt/aperture_gm.c        |  44 +++--
> >  drivers/gpu/drm/i915/gvt/gtt.c                |   9 +-
> >  drivers/gpu/drm/i915/gvt/gvt.c                |   7 +-
> >  drivers/gpu/drm/i915/gvt/gvt.h                |  42 +++--
> >  drivers/gpu/drm/i915/gvt/kvmgt.c              | 115 +++++++++++-
> >  drivers/gpu/drm/i915/gvt/vgpu.c               | 172 ++++++++++++------
> >  7 files changed, 317 insertions(+), 94 deletions(-)
> > 
> > --
> > 2.25.1  
> 

