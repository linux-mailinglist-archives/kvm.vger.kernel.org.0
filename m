Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42721E7B66
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 13:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgE2LNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 07:13:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27953 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725681AbgE2LNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 07:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590750789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gB04A63VI2Unw4Ky1vvnST2Pf8KKP9aXv3QcFy13LxE=;
        b=dUL1/qiXKM4AxHX0hqHPiSRjVvqqgCSSO3v367U1qGhRBsyHDe66GYIcONZ+/keoJjOMAD
        dE8Gx3LoiKFMEaWBibpf1nBfuWm0E3b3L3kbCLdDur5r5qvOTiLW4sdgWNc0x7mHi9dVzg
        uYh1FVQRzkFipKBa+HbfZld60owUo8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-Og0uXFZ_M4imNKBXPBF75w-1; Fri, 29 May 2020 07:13:07 -0400
X-MC-Unique: Og0uXFZ_M4imNKBXPBF75w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95D4C1005510;
        Fri, 29 May 2020 11:13:04 +0000 (UTC)
Received: from work-vm (ovpn-113-111.ams2.redhat.com [10.36.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00D7C1A7C8;
        Fri, 29 May 2020 11:12:57 +0000 (UTC)
Date:   Fri, 29 May 2020 12:12:54 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
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
Message-ID: <20200529111254.GH2856@work-vm>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <20200519105804.02f3cae8@x1.home>
 <20200525065925.GA698@joy-OptiPlex-7040>
 <426a5314-6d67-7cbe-bad0-e32f11d304ea@nvidia.com>
 <20200526141939.2632f100@x1.home>
 <20200527062358.GD19560@joy-OptiPlex-7040>
 <20200527084822.GC3001@work-vm>
 <20200528080101.GD1378@joy-OptiPlex-7040>
 <20200528165340.53a57e22@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528165340.53a57e22@x1.home>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> On Thu, 28 May 2020 04:01:02 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > > > > This is my understanding of the protocol as well, when the device is
> > > > > running, pending_bytes might drop to zero if no internal state has
> > > > > changed and may be non-zero on the next iteration due to device
> > > > > activity.  When the device is not running, pending_bytes reporting zero
> > > > > indicates the device is done, there is no further state to transmit.
> > > > > Does that meet your need/expectation?
> > > > >  
> > > > (1) on one side, as in vfio_save_pending(),
> > > > vfio_save_pending()
> > > > {
> > > >     ...
> > > >     ret = vfio_update_pending(vbasedev);
> > > >     ...
> > > >     *res_precopy_only += migration->pending_bytes;
> > > >     ...
> > > > }
> > > > the pending_bytes tells migration thread how much data is still hold in
> > > > device side.
> > > > the device data includes
> > > > device internal data + running device dirty data + device state.
> > > > 
> > > > so the pending_bytes should include device state as well, right?
> > > > if so, the pending_bytes should never reach 0 if there's any device
> > > > state to be sent after device is stopped.  
> > > 
> > > I hadn't expected the pending-bytes to include a fixed offset for device
> > > state (If you mean a few registers etc) - I'd expect pending to drop
> > > possibly to zero;  the heuristic as to when to switch from iteration to
> > > stop, is based on the total pending across all iterated devices; so it's
> > > got to be allowed to drop otherwise you'll never transition to stop.
> > >   
> > ok. got it.
> 
> Yeah, as I understand it, a device is not required to participate in
> reporting data available while (_SAVING | _RUNNING), there will always
> be an iteration while the device is !_RUNNING.  Therefore if you have
> fixed device state that you're always going to send, it should only be
> sent once when called during !_RUNNING.  The iterative phase should be
> used where you have a good chance to avoid re-sending data at the
> stop-and-copy phase.  Thanks,

Right.

Dave

> Alex
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

