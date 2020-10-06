Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15220284FC4
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 18:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJFQYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 12:24:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbgJFQYP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 12:24:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602001454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iTFHZeHpRZeGDIriRmYC9dE/HIjQlj5bWS/e7+7rp/E=;
        b=be5vt2z6Q1HbifTxLCRSw6fZMGxCj+GqqTRXCsI76t6sa1zvPyxWWMvfNPhSfXeWR9J27T
        kGk6aakGR7bENqAiXTZuPBUE/gyzBMmkvLP3cID15fOsTrDr5+ZXEwm2um6iBjU3ARLI+w
        UiLjkcKffCe7yAOG60rdI1KAoRvyZjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-cMA5fL7OM1m8t7Ty_6lYIg-1; Tue, 06 Oct 2020 12:24:12 -0400
X-MC-Unique: cMA5fL7OM1m8t7Ty_6lYIg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E54C018829D5;
        Tue,  6 Oct 2020 16:24:10 +0000 (UTC)
Received: from horse.redhat.com (ovpn-117-72.rdu2.redhat.com [10.10.117.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D2A61A835;
        Tue,  6 Oct 2020 16:24:07 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E76F5220AD7; Tue,  6 Oct 2020 12:24:06 -0400 (EDT)
Date:   Tue, 6 Oct 2020 12:24:06 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201006162406.GE5306@redhat.com>
References: <20201002211314.GE24460@linux.intel.com>
 <20201005153318.GA4302@redhat.com>
 <20201005161620.GC11938@linux.intel.com>
 <20201006134629.GB5306@redhat.com>
 <877ds38n6r.fsf@vitty.brq.redhat.com>
 <20201006141501.GC5306@redhat.com>
 <874kn78l2z.fsf@vitty.brq.redhat.com>
 <20201006150817.GD5306@redhat.com>
 <871rib8ji1.fsf@vitty.brq.redhat.com>
 <20201006161200.GB17610@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006161200.GB17610@linux.intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 09:12:00AM -0700, Sean Christopherson wrote:
> On Tue, Oct 06, 2020 at 05:24:54PM +0200, Vitaly Kuznetsov wrote:
> > Vivek Goyal <vgoyal@redhat.com> writes:
> > > So you will have to report token (along with -EFAULT) to user space. So this
> > > is basically the 3rd proposal which is extension of kvm API and will
> > > report say HVA/GFN also to user space along with -EFAULT.
> > 
> > Right, I meant to say that guest kernel has full register state of the
> > userspace process which caused APF to get queued and instead of trying
> > to extract it in KVM and pass to userspace in case of a (later) failure
> > we limit KVM api change to contain token or GFN only and somehow keep
> > the rest in the guest. This should help with TDX/SEV-ES.
> 
> Whatever gets reported to userspace should be identical with and without
> async page faults, i.e. it definitely shouldn't have token information.
> 
> Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
> into the guest is not an option.  Nor do I think that's "correct"
> behavior (see everyone's objections to using #PF for APF fixed).  I.e. the
> event should probably be an IRQ.

I am not sure if IRQ for "Page not Present" works. Will it have some
conflicts/issues with other high priority interrupts which can
get injected before "Page not present".

Vivek

