Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FD7220875
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 11:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbgGOJRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 05:17:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31283 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729592AbgGOJRF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jul 2020 05:17:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594804624;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u4BynM0bo8sz1ax9kTNFDfebTLK2fVb4wN9VUIwN5GY=;
        b=WTbqRjvLmWBs0mSMxuT6nZoLAD4yUjfAYfY17VZPl7i5r5fKYH9B7zAvq573/l/Hza4M0L
        kaCtuIOJvIAsMm8l5zzrK0vSkzfjpMcdiKGbHzmZaQlki0aoHcYe3KwNUc5/LAzhYrEMYL
        bV+6Yhd68WliFVeN7trJ/cjK3VdsmK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-kfLB2Gn9PieX4IjTTidrFQ-1; Wed, 15 Jul 2020 05:17:01 -0400
X-MC-Unique: kfLB2Gn9PieX4IjTTidrFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B7268027FA;
        Wed, 15 Jul 2020 09:16:58 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2156B10013D0;
        Wed, 15 Jul 2020 09:16:44 +0000 (UTC)
Date:   Wed, 15 Jul 2020 10:16:41 +0100
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
Message-ID: <20200715091641.GD68910@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
 <20200714102129.GD25187@redhat.com>
 <20200714101616.5d3a9e75@x1.home>
 <20200714164722.GL25187@redhat.com>
 <20200714144715.0ef70074@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200714144715.0ef70074@x1.home>
User-Agent: Mutt/1.14.5 (2020-06-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:47:15PM -0600, Alex Williamson wrote:
> On Tue, 14 Jul 2020 17:47:22 +0100
> Daniel P. Berrangé <berrange@redhat.com> wrote:

> > I'm sure OpenStack maintainers can speak to this more, as they've put
> > alot of work into their scheduling engine to optimize the way it places
> > VMs largely driven from simple structured data reported from hosts.
> 
> I think we've weeded out that our intended approach is not worthwhile,
> testing a compatibility string at a device is too much overhead, we
> need to provide enough information to the management engine to predict
> the response without interaction beyond the initial capability probing.

Just to clarify in case people mis-interpreted my POV...

I think that testing a compatibility string at a device *is* useful, as
it allows for a final accurate safety check to be performed before the
migration stream starts. Libvirt could use that reasonably easily I
believe.

It just isn't sufficient for a complete solution.

In parallel with the device level test in sysfs, we need something else
to support the host placement selection problems in an efficient way, as
you are trying to address in the remainder of your mail.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

