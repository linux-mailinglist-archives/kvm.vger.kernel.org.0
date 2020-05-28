Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23B21E6F9E
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 00:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437315AbgE1Wxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 18:53:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2437268AbgE1Wxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 18:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590706430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0fP2ApTtN9i4VyxWY+o5Q36Obi7PmYNpALvuVo0SLA8=;
        b=f4XUUBc0/Xymv24TTXQ1LcWPWeu5x7xFTSj4xQJHf/qDkRavDhvR1HTK8Rj6XwGxgFDDLV
        rYl2I8sUL0YlOR/mMfxGi5kmuFc/DG3HGW42/XBiMGHCy4xkjij+ACIJcal4zU+WOT1kKF
        WsuuOdb8thh1cCLLEJLTqdhXd6fqfVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-LeE-_7KEOYCMqSIgEvVNUQ-1; Thu, 28 May 2020 18:53:46 -0400
X-MC-Unique: LeE-_7KEOYCMqSIgEvVNUQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 133148014D7;
        Thu, 28 May 2020 22:53:43 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9CFA7A8BB;
        Thu, 28 May 2020 22:53:40 +0000 (UTC)
Date:   Thu, 28 May 2020 16:53:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
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
Message-ID: <20200528165340.53a57e22@x1.home>
In-Reply-To: <20200528080101.GD1378@joy-OptiPlex-7040>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
        <20200519105804.02f3cae8@x1.home>
        <20200525065925.GA698@joy-OptiPlex-7040>
        <426a5314-6d67-7cbe-bad0-e32f11d304ea@nvidia.com>
        <20200526141939.2632f100@x1.home>
        <20200527062358.GD19560@joy-OptiPlex-7040>
        <20200527084822.GC3001@work-vm>
        <20200528080101.GD1378@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 May 2020 04:01:02 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> > > > This is my understanding of the protocol as well, when the device is
> > > > running, pending_bytes might drop to zero if no internal state has
> > > > changed and may be non-zero on the next iteration due to device
> > > > activity.  When the device is not running, pending_bytes reporting zero
> > > > indicates the device is done, there is no further state to transmit.
> > > > Does that meet your need/expectation?
> > > >  
> > > (1) on one side, as in vfio_save_pending(),
> > > vfio_save_pending()
> > > {
> > >     ...
> > >     ret = vfio_update_pending(vbasedev);
> > >     ...
> > >     *res_precopy_only += migration->pending_bytes;
> > >     ...
> > > }
> > > the pending_bytes tells migration thread how much data is still hold in
> > > device side.
> > > the device data includes
> > > device internal data + running device dirty data + device state.
> > > 
> > > so the pending_bytes should include device state as well, right?
> > > if so, the pending_bytes should never reach 0 if there's any device
> > > state to be sent after device is stopped.  
> > 
> > I hadn't expected the pending-bytes to include a fixed offset for device
> > state (If you mean a few registers etc) - I'd expect pending to drop
> > possibly to zero;  the heuristic as to when to switch from iteration to
> > stop, is based on the total pending across all iterated devices; so it's
> > got to be allowed to drop otherwise you'll never transition to stop.
> >   
> ok. got it.

Yeah, as I understand it, a device is not required to participate in
reporting data available while (_SAVING | _RUNNING), there will always
be an iteration while the device is !_RUNNING.  Therefore if you have
fixed device state that you're always going to send, it should only be
sent once when called during !_RUNNING.  The iterative phase should be
used where you have a good chance to avoid re-sending data at the
stop-and-copy phase.  Thanks,

Alex

