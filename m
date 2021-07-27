Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270F63D6FC4
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 08:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbhG0Gzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 02:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbhG0Gzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 02:55:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6B8C061757;
        Mon, 26 Jul 2021 23:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7KMq2+jcB6YY9vgnn3lHstykTQ5w8Jynl0Css7fXju4=; b=QxWtqTcavr9FiRdPY3+Gz0qwpL
        19U78vOHJqIO3qKHxF5FnMeAVEKBc9iW/O2/KP3miLRpnN5ED0ICroruKyuwBXjlX6sh8eDW7EsMW
        dXRrI750D4Y2pVTrfwUdZ1HAKE5wrEvyBp0BA6idpVnHfuEXsu4Pgxe0VomMaH6N9aZSiVKsxG8by
        YXX048XDoqy/WLkomvELM+1ZdBOWf6WmGwxczgGXV7a/l9t78k/iqWgKJUo0eze1zmkh5XhgY8jze
        6GAXhI0ZQHOJU2P31LzY3BJ5gvtyq97uFPeeKI/18PnpdJa+tAuobR+UnForVehWEO6OvaHjlv+eR
        fN49w6CA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8GzA-00ElSs-BE; Tue, 27 Jul 2021 06:54:50 +0000
Date:   Tue, 27 Jul 2021 07:54:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] s390/vfio-ap: replace open coded locks for
 VFIO_GROUP_NOTIFY_SET_KVM notification
Message-ID: <YP+tsMvpr7afAXl8@infradead.org>
References: <20210719193503.793910-1-akrowiak@linux.ibm.com>
 <20210719193503.793910-3-akrowiak@linux.ibm.com>
 <20210721164550.5402fe1c.pasic@linux.ibm.com>
 <c3b80f79-6795-61ce-2dd1-f4cc7110e417@linux.ibm.com>
 <20210723162625.59cead27.pasic@linux.ibm.com>
 <5380652f-e68f-bbd0-10c0-c7d541065843@linux.ibm.com>
 <20210726223628.4d7759bf.pasic@linux.ibm.com>
 <20210726220317.GA1721383@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726220317.GA1721383@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 07:03:17PM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 26, 2021 at 10:36:28PM +0200, Halil Pasic wrote:
> 
> > You may end up with open and close running interleaved. What I'
> > trying to say is, to my best knowledge, normally there is no
> > you have to close it before you open it again rule for files.
> 
> This is an existing bug in this driver, I've fixed in the reflck series.
> 
> open_device/close_device will not run concurrently, or out of order,
> afer it is fixed.

Btw, while I've got all your attention, I've been struggling a bit with
how that SET_KVM notifier is supposed to work.

The i915 gvt code simplify assumes the notification registration hits
the case of KVM already being active, and gets away with that as at
least qemu ensures that the KVM_DEV_VFIO_GROUP_ADD has been called before
the device FDs are opened.  Is that something we could generalize and
never allow to actually notify for SET_KVM with non-null data beeing
called at runtime and avoid the locking entirely?

Similarly the removal case is a little weird: with Jason's work to only
call a release function on the last reference drop which solves a lot
of concurrency issues nicely  this still creates a nasty corner case
with a sideband release under weird locking rules.   What prevents the
vfio core from simply holding a refefeence to the struct kvm as long as
the device is open to close that hole?
