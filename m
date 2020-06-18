Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A691D1FF23B
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 14:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgFRMrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 08:47:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25779 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727091AbgFRMrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 08:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592484430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TlsMc1mLQuW6Fy9nTnXlEoj8JWjnrS7Ag2B0bw3WO+0=;
        b=hcvUqJNHx7VuqItLfUrqnABeCIA4YRU1qF1V1RN4CwvuipUwx0iZa2HFJTT/cdP+HDT9kC
        b+Uz2KGpBbOKhZbqfazMYPPZxRqP0ysjwNDbcHoe/YNzX7W7WfJ4P4jedDawJ9DIlYhk87
        c8npjuqBU2H3fdET+2Rmuyucez/X3NY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431--p8fARLGP9OVjj786ZgFmQ-1; Thu, 18 Jun 2020 08:47:09 -0400
X-MC-Unique: -p8fARLGP9OVjj786ZgFmQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2CF9107ACCD;
        Thu, 18 Jun 2020 12:47:07 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-20.rdu2.redhat.com [10.10.115.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C52D5D9D3;
        Thu, 18 Jun 2020 12:47:01 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id B8E99222D7B; Thu, 18 Jun 2020 08:47:00 -0400 (EDT)
Date:   Thu, 18 Jun 2020 08:47:00 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, virtio-fs@redhat.com,
        miklos@szeredi.hu, stefanha@redhat.com, dgilbert@redhat.com,
        pbonzini@redhat.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kvm: Add capability to be able to report async pf
 error to guest
Message-ID: <20200618124700.GA3814@redhat.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
 <20200616214847.24482-3-vgoyal@redhat.com>
 <87lfklhm58.fsf@vitty.brq.redhat.com>
 <20200617183224.GK26818@linux.intel.com>
 <20200617215152.GF26770@redhat.com>
 <20200617230052.GB27751@linux.intel.com>
 <20200617230548.GC27751@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617230548.GC27751@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 04:05:48PM -0700, Sean Christopherson wrote:
> On Wed, Jun 17, 2020 at 04:00:52PM -0700, Sean Christopherson wrote:
> > On Wed, Jun 17, 2020 at 05:51:52PM -0400, Vivek Goyal wrote:
> > What I'm saying is that KVM cannot do the filtering.  KVM, by design, does
> > not know what lies behind any given hva, or what the associated gpa maps to
> > in the guest.  As is, userspace can't even opt out of this behavior, e.g.
> > it can't even "filter" on a per-VM granularity, since kvm_pv_enable_async_pf()
> > unconditionally allows the guest to enable the behavior[*].
> 
> Let me rephrase that slightly.  KVM can do the filtering, but it cannot make
> the decision on what to filter.  E.g. if the use case is compatible with doing
> this at a memslot level, then a memslot flag could be added to control the
> behavior.

Ok, may be. But what is that thing which you want to filter out. Just
creating a framework for filtering selective regions without any specific
use case is hard.

Right now we have one switch to enable/disable error reporting and
this can be turned off both at qemu level as well as guest level.

If the desire is that this needs to me more finer grained, I need
to have some examples which show that in these cases we don't want
to report page fault errors.

Anyway, it seems that atleast first patch is less contentious and
can be relatively easily be done. That is exit to user space if
page fault error happens instead of getting into an infinite loop.
I will post that separately.

Thanks
Vivek

