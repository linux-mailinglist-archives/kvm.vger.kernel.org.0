Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAAD1E6FCC
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 00:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437376AbgE1W7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 18:59:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52270 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437266AbgE1W7P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 18:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590706753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jzbxq2mlHqD0DlEQ0FYL4cGWSmL4FdNDgfV81d/7bRI=;
        b=dfsiTZBYxFM9DL8qPhK4xr+//JeRAVaPXt4188CBCkY3ga04w3zDkXZHGVqgCPPwijUXJu
        PU60TEX/bnCe/pl7Hn35pqCEXmayHukU1w8nJks5et4BHQjbFDr4ccicaYDNT7/Nw6SmYa
        Zx5ffUl8d0zRcqNOdR/XTg/Je30HERQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-sNEQlx0IOQOQbn7UfuparQ-1; Thu, 28 May 2020 18:59:11 -0400
X-MC-Unique: sNEQlx0IOQOQbn7UfuparQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 812C7107ACF4;
        Thu, 28 May 2020 22:59:09 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4229C10013D0;
        Thu, 28 May 2020 22:59:07 +0000 (UTC)
Date:   Thu, 28 May 2020 16:59:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, cjia@nvidia.com,
        kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, jonathan.davies@nutanix.com, eauger@redhat.com,
        aik@ozlabs.ru, pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200528165906.7d03f689@x1.home>
In-Reply-To: <20200527084822.GC3001@work-vm>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
        <20200519105804.02f3cae8@x1.home>
        <20200525065925.GA698@joy-OptiPlex-7040>
        <426a5314-6d67-7cbe-bad0-e32f11d304ea@nvidia.com>
        <20200526141939.2632f100@x1.home>
        <20200527062358.GD19560@joy-OptiPlex-7040>
        <20200527084822.GC3001@work-vm>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 May 2020 09:48:22 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> * Yan Zhao (yan.y.zhao@intel.com) wrote:
> > BTW, for viommu, the downtime data is as below. under the same network
> > condition and guest memory size, and no running dirty data/memory produced
> > by device.
> > (1) viommu off
> > single-round dirty query: downtime ~100ms   
> 
> Fine.
> 
> > (2) viommu on
> > single-round dirty query: downtime 58s   
> 
> Youch.

Double Youch!  But we believe this is because we're getting the dirty
bitmap one IOMMU leaf page at a time, right?  We've enable the kernel
to get a dirty bitmap across multiple mappings, but QEMU isn't yet
taking advantage of it.  Do I have this correct?  Thanks,

Alex

