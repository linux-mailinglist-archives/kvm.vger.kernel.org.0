Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB2816C3E8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbgBYOai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:30:38 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55875 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729065AbgBYOah (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 09:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582641037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=koTgLB/h3FfY8DKoEzbvukIhrVm4ASkj0z5WG+Qybgc=;
        b=Wq3BAiQr163Z+5ns61NgGfvU9x6JqAX5vpodVwtzjNbJFj30kuTjXLeUkcEjEFhqCE67st
        aueDZVaiJj15br+cJAsuDrYq6sK92JgFJ73vmTBa8J9Dp6+hPjrDlRMv4L4U5kcaFosW8z
        e/5ruL9XxB3ofNkhRoXh2kK4lKg5y5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-VMqk_S0_OP2XuHSGEYKvpA-1; Tue, 25 Feb 2020 09:30:33 -0500
X-MC-Unique: VMqk_S0_OP2XuHSGEYKvpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E39D1005512;
        Tue, 25 Feb 2020 14:30:31 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D4358ED01;
        Tue, 25 Feb 2020 14:30:27 +0000 (UTC)
Date:   Tue, 25 Feb 2020 15:30:24 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v4 20/36] KVM: s390/mm: handle guest unpin events
Message-ID: <20200225153024.62e1ed7f.cohuck@redhat.com>
In-Reply-To: <2c45d494-8fdf-69c1-e786-0f07c6f09a40@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-21-borntraeger@de.ibm.com>
        <20200225131838.2d68e7f9.cohuck@redhat.com>
        <2c45d494-8fdf-69c1-e786-0f07c6f09a40@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 15:21:42 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 25.02.20 13:18, Cornelia Huck wrote:
> > On Mon, 24 Feb 2020 06:40:51 -0500
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >>
> >> The current code tries to first pin shared pages, if that fails (e.g.
> >> because the page is not shared) it will export them. For shared pages
> >> this means that we get a new intercept telling us that the guest is
> >> unsharing that page. We will make the page secure at that point in time
> >> and revoke the host access. This is synchronized with other host events,
> >> e.g. the code will wait until host I/O has finished.
> >>
> >> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >> Acked-by: David Hildenbrand <david@redhat.com>
> >> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  arch/s390/kvm/intercept.c | 24 ++++++++++++++++++++++++
> >>  1 file changed, 24 insertions(+)

> I will also fixup the misleading patch description:
> 
> The current code tries to first pin shared pages, if that fails (e.g.
> because the page is not shared) it will export them. For shared pages
> this means that we get a new intercept telling us that the guest is
> unsharing that page. We will unpin the page at that point in time,
> following the same rules as for make secure. (wait for writeback, no
> elevated page refs etc).

I'd suggest:

"...as for making a page secure (i.e. waiting for writeback, no
elevated page references, etc.)"

With the touchups,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

