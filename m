Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2140C344F58
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 19:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhCVS51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 14:57:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230511AbhCVS44 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 14:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616439415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rmxk6W1K4JaaHy3riMqy1nF6KWzopa5q4ig8BRJZZZs=;
        b=N9I8tN4Ua49gbT1B8v9Y4hXBab2hShJV1yNpXvM//0Z4HP9C/hrXd2Ibo6pgwvIFbwi3EY
        xpszvxfQMmD490iX3NLHf95+klO4NONkDdZmI3kgUHeSjJEAdHV6MxmCjG6nmFejuypG7a
        UBE41/OiLXIvLk0N2yAiUn6QTw1sPzg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-scZlzYnRPcKvxaiQIAjJng-1; Mon, 22 Mar 2021 14:56:51 -0400
X-MC-Unique: scZlzYnRPcKvxaiQIAjJng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 305F383DD2E;
        Mon, 22 Mar 2021 18:56:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87D4610023BE;
        Mon, 22 Mar 2021 18:56:48 +0000 (UTC)
Date:   Mon, 22 Mar 2021 19:56:45 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Fix the devicetree parser for
 stdout-path
Message-ID: <20210322185645.6j6cagld5u6l5qiq@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
 <20210322085336.2lxg457refhvntls@kamzik.brq.redhat.com>
 <20210322180445.7164b991@slackpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322180445.7164b991@slackpad.fritz.box>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 06:04:45PM +0000, Andre Przywara wrote:
> On Mon, 22 Mar 2021 09:53:36 +0100
> Andrew Jones <drjones@redhat.com> wrote:
> 
> > On Thu, Mar 18, 2021 at 06:07:23PM +0000, Nikos Nikoleris wrote:
> > > This set of patches fixes the way we parse the stdout-path
> > > property in the DT. The stdout-path property is used to set up
> > > the console. Prior to this, the code ignored the fact that
> > > stdout-path is made of the path to the uart node as well as
> > > parameters. As a result, it would fail to find the relevant DT
> > > node. In addition to minor fixes in the device tree code, this
> > > series pulls a new version of libfdt from upstream.
> > > 
> > > v1: https://lore.kernel.org/kvm/20210316152405.50363-1-nikos.nikoleris@arm.com/
> > > 
> > > Changes in v2:
> > >   - Added strtoul and minor fix in strrchr
> > >   - Fixes in libfdt_clean
> > >   - Minor fix in lib/libfdt/README
> > > 
> > > Thanks,
> > > 
> > > Nikos
> > >  
> > 
> > Applied to arm/queue
> 
> So I understand that this is a bit late now, but is this really the way
> forward: to just implement libc functions as we go, from scratch, and
> merge them without any real testing?
> I understand that hacking up strchr() is fun, but when it comes to
> those string parsing functions, it gets a bit hairy, and I feel like we
> are dismissing decades of experience here by implementing stuff from
> scratch. At the very least we should run some unit tests (!) on newly
> introduced C library functions?

Who says I didn't test the new string functions? Did you come up with a
test case that breaks something?

> 
> Or probably the better alternative: we pick some existing C library,
> and start to borrow implementations from there? Is klibc[1] a good
> choice, maybe?

The trivial functions like strchr don't really scare me much. And the
more complicated functions don't always adapt to our framework.
I just looked at klibc's strtol. It doesn't have any error handling;
not the errno type specified in the man page and not the type we do in
kvm-unit-tests (asserts). IOW, our implementation is even more complete.

Anyway, after like 15 years of development, kvm-unit-tests only has
20 string, 3 stdlib, and 4 printf functions. I'm not too worried
about overly reinventing the wheel just yet :-)

Thanks,
drew


> 
> Cheers,
> Andre
> 
> [1] https://git.kernel.org/pub/scm/libs/klibc/klibc.git/
> 
> 
> > 
> > https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
> > 
> > Thanks,
> > drew 
> > 
> 

