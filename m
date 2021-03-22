Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5108E344087
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 13:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhCVMLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 08:11:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhCVMLe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 08:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616415094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=79pq0FH2whoGoR73m0FtibIDHp+ZDObicIdr+SoGidQ=;
        b=L/od/BHoQ1OA4pUr80z1PdP7EsmMgaxXhlNDvi11kxb53efYdSRHJzqy4+jH+pzP2cjbov
        r9J0y5hYu7a3pWM36kmaiCfHKiYeBbHrZ4Qr5LHLNDwCmLW8wDX2aiIcVb+PtM2xtAUVW5
        hJ0QVyaFzA5xGSqeNauZr4imIHaJl5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-C4s6QkubPp-JgPplWF9VpQ-1; Mon, 22 Mar 2021 08:11:32 -0400
X-MC-Unique: C4s6QkubPp-JgPplWF9VpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D440D1084D6D;
        Mon, 22 Mar 2021 12:11:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA6CD60C04;
        Mon, 22 Mar 2021 12:11:29 +0000 (UTC)
Date:   Mon, 22 Mar 2021 13:11:26 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/4] arm/arm64: Track whether thread_info
 has been initialized
Message-ID: <20210322121126.l4whxdz5kylmf77q@kamzik.brq.redhat.com>
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
 <20210319122414.129364-4-nikos.nikoleris@arm.com>
 <9325d09d-aa0b-0715-f013-8926de3673cb@arm.com>
 <80c2632b-4a04-f9b0-9ff9-8403ca1e9451@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80c2632b-4a04-f9b0-9ff9-8403ca1e9451@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 10:59:31AM +0000, Nikos Nikoleris wrote:
> Hi Alex,
> 
> On 22/03/2021 10:34, Alexandru Elisei wrote:
> > Hi Nikos,
> > 
> > On 3/19/21 12:24 PM, Nikos Nikoleris wrote:
> > > Introduce a new flag in the thread_info to track whether a thread_info
> > > struct is initialized yet or not.
> > 
> > There's no explanation why this is needed. The flag checked only by is_user(), and
> > before thread_info is initialized, flags is zero, so is_user() would return false,
> > right? Or am I missing something?
> > 
> 
> I am still not sure what's the right approach here. I didn't like and I
> still don't like the fact that we rely on implicit 0 initialization to get
> the right behavior. This will break once we add support for EFI. I think we
> should explicitly initialize thread_info to 0.

I just sent a patch doing this. Let me know what you think.


> I was thinking of adding a
> thread_info_alloc() function to do this.

I'm not sure how this would look. We want the thread-info to live on the
bottom of the stack and the bootcpu's stack is allocated in the linker
script.

> 
> By having this flag I think we can guard accesses to the thread_info in
> general. I didn't want to turn the define smp_processor_id to a function
> here but I think we should and assert that the thread_info is valid and
> avoid reading current_thread_info()->cpu.

Hmm, yeah, hopefully we can avoid this flag and adding an assert to
smp_processor_id(). Let's take another look at this after we ensure
that the thread-info is explicitly zeroed at startup.

Thanks,
drew

