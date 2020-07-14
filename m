Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A146421F79F
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 18:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgGNQsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 12:48:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726062AbgGNQsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 12:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594745290;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T2JyUvXm344iGgCnax4ZsyF6v+hYO+iw65yyDRl2VeI=;
        b=DScZmE8oSQQgUMqibEK80Yb0zlsQhGejqi5hKVymvyomaCbjQC4rZ0KoBDtXuHRATdOvUw
        EeLhW8DdTMOQPbBspBsVQAvb2T3zWQNJaqVd0sBnGflvQVYGIKZiRFwiPe0yOlj14kJUKv
        80arJWRbNeOUp3ST3gEZCJOPU7T2kiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-HJPZdL5PN0ieLWFL52Csnw-1; Tue, 14 Jul 2020 12:47:42 -0400
X-MC-Unique: HJPZdL5PN0ieLWFL52Csnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D510D102CC38;
        Tue, 14 Jul 2020 16:47:39 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.42])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97C815D9C5;
        Tue, 14 Jul 2020 16:47:25 +0000 (UTC)
Date:   Tue, 14 Jul 2020 17:47:22 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, devel@ovirt.org,
        openstack-discuss@lists.openstack.org, libvir-list@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, smooney@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, corbet@lwn.net,
        kwankhede@nvidia.com, dgilbert@redhat.com, eauger@redhat.com,
        jian-feng.ding@intel.com, hejie.xu@intel.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, bao.yumeng@zte.com.cn,
        xin-ran.wang@intel.com, shaohe.feng@intel.com
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200714164722.GL25187@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
 <20200714102129.GD25187@redhat.com>
 <20200714101616.5d3a9e75@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200714101616.5d3a9e75@x1.home>
User-Agent: Mutt/1.14.5 (2020-06-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 10:16:16AM -0600, Alex Williamson wrote:
> On Tue, 14 Jul 2020 11:21:29 +0100
> Daniel P. Berrangé <berrange@redhat.com> wrote:
> 
> > On Tue, Jul 14, 2020 at 07:29:57AM +0800, Yan Zhao wrote:
> > > 
> > > The string read from migration_version attribute is defined by device vendor
> > > driver and is completely opaque to the userspace.
> > > for a Intel vGPU, string format can be defined like
> > > "parent device PCI ID" + "version of gvt driver" + "mdev type" + "aggregator count".
> > > 
> > > for an NVMe VF connecting to a remote storage. it could be
> > > "PCI ID" + "driver version" + "configured remote storage URL"
> > > 
> > > for a QAT VF, it may be
> > > "PCI ID" + "driver version" + "supported encryption set".
> > > 
> > > (to avoid namespace confliction from each vendor, we may prefix a driver name to
> > > each migration_version string. e.g. i915-v1-8086-591d-i915-GVTg_V5_8-1)
> 
> It's very strange to define it as opaque and then proceed to describe
> the contents of that opaque string.  The point is that its contents
> are defined by the vendor driver to describe the device, driver version,
> and possibly metadata about the configuration of the device.  One
> instance of a device might generate a different string from another.
> The string that a device produces is not necessarily the only string
> the vendor driver will accept, for example the driver might support
> backwards compatible migrations.


> > IMHO there needs to be a mechanism for the kernel to report via sysfs
> > what versions are supported on a given device. This puts the job of
> > reporting compatible versions directly under the responsibility of the
> > vendor who writes the kernel driver for it. They are the ones with the
> > best knowledge of the hardware they've built and the rules around its
> > compatibility.
> 
> The version string discussed previously is the version string that
> represents a given device, possibly including driver information,
> configuration, etc.  I think what you're asking for here is an
> enumeration of every possible version string that a given device could
> accept as an incoming migration stream.  If we consider the string as
> opaque, that means the vendor driver needs to generate a separate
> string for every possible version it could accept, for every possible
> configuration option.  That potentially becomes an excessive amount of
> data to either generate or manage.
> 
> Am I overestimating how vendors intend to use the version string?

If I'm interpreting your reply & the quoted text orrectly, the version
string isn't really a version string in any normal sense of the word
"version".

Instead it sounds like string encoding a set of features in some arbitrary
vendor specific format, which they parse and do compatibility checks on
individual pieces ? One or more parts may contain a version number, but
its much more than just a version.

If that's correct, then I'd prefer we didn't call it a version string,
instead call it a "capability string" to make it clear it is expressing
a much more general concept, but...

> We'd also need to consider devices that we could create, for instance
> providing the same interface enumeration prior to creating an mdev
> device to have a confidence level that the new device would be a valid
> target.
> 
> We defined the string as opaque to allow vendor flexibility and because
> defining a common format is hard.  Do we need to revisit this part of
> the discussion to define the version string as non-opaque with parsing
> rules, probably with separate incoming vs outgoing interfaces?  Thanks,

..even if the huge amount of flexibility is technically relevant from the
POV of the hardware/drivers, we should consider whether management apps
actually want, or can use, that level of flexibility.

The task of picking which host to place a VM on has alot of factors to
consider, and when there are a large number of hosts, the total amount
of information to check gets correspondingly large.  The placement
process is also fairly performance critical.

Running complex algorithmic logic to check compatibility of devices
based on a arbitrary set of rules is likely to be a performance
challenge. A flat list of supported strings is a much simpler
thing to check as it reduces down to a simple set membership test.

IOW, even if there's some complex set of device type / vendor specific
rules to check for compatibility, I fear apps will ignore them and
just define a very simplified list of compatible string, and ignore
all the extra flexibility.

I'm sure OpenStack maintainers can speak to this more, as they've put
alot of work into their scheduling engine to optimize the way it places
VMs largely driven from simple structured data reported from hosts.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

