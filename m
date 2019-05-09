Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DC018D66
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 17:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfEIPye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 11:54:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfEIPye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 11:54:34 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22D1599C1D;
        Thu,  9 May 2019 15:54:28 +0000 (UTC)
Received: from gondolin (dhcp-192-213.str.redhat.com [10.33.192.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B360F1001E65;
        Thu,  9 May 2019 15:54:06 +0000 (UTC)
Date:   Thu, 9 May 2019 17:54:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        intel-gvt-dev@lists.freedesktop.org, arei.gonglei@huawei.com,
        aik@ozlabs.ru, Zhengxiao.zx@alibaba-inc.com,
        shuangtai.tst@alibaba-inc.com, qemu-devel@nongnu.org,
        eauger@redhat.com, yi.l.liu@intel.com, ziye.yang@intel.com,
        mlevitsk@redhat.com, pasic@linux.ibm.com, felipe@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, eskultet@redhat.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, cjia@nvidia.com,
        kwankhede@nvidia.com, berrange@redhat.com, dinechin@redhat.com
Subject: Re: [PATCH v2 1/2] vfio/mdev: add version attribute for mdev device
Message-ID: <20190509175404.512ae7aa.cohuck@redhat.com>
In-Reply-To: <20190509154857.GF2868@work-vm>
References: <20190506014514.3555-1-yan.y.zhao@intel.com>
        <20190506014904.3621-1-yan.y.zhao@intel.com>
        <20190507151826.502be009@x1.home>
        <20190509173839.2b9b2b46.cohuck@redhat.com>
        <20190509154857.GF2868@work-vm>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 09 May 2019 15:54:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 May 2019 16:48:57 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Cornelia Huck (cohuck@redhat.com) wrote:
> > On Tue, 7 May 2019 15:18:26 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> > > On Sun,  5 May 2019 21:49:04 -0400
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:  
> >   
> > > > +  Errno:
> > > > +  If vendor driver wants to claim a mdev device incompatible to all other mdev
> > > > +  devices, it should not register version attribute for this mdev device. But if
> > > > +  a vendor driver has already registered version attribute and it wants to claim
> > > > +  a mdev device incompatible to all other mdev devices, it needs to return
> > > > +  -ENODEV on access to this mdev device's version attribute.
> > > > +  If a mdev device is only incompatible to certain mdev devices, write of
> > > > +  incompatible mdev devices's version strings to its version attribute should
> > > > +  return -EINVAL;    
> > > 
> > > I think it's best not to define the specific errno returned for a
> > > specific situation, let the vendor driver decide, userspace simply
> > > needs to know that an errno on read indicates the device does not
> > > support migration version comparison and that an errno on write
> > > indicates the devices are incompatible or the target doesn't support
> > > migration versions.  
> > 
> > I think I have to disagree here: It's probably valuable to have an
> > agreed error for 'cannot migrate at all' vs 'cannot migrate between
> > those two particular devices'. Userspace might want to do different
> > things (e.g. trying with different device pairs).  
> 
> Trying to stuff these things down an errno seems a bad idea; we can't
> get much information that way.

So, what would be a reasonable approach? Userspace should first read
the version attributes on both devices (to find out whether migration
is supported at all), and only then figure out via writing whether they
are compatible?

(Or just go ahead and try, if it does not care about the reason.)
