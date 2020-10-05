Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66CD283BDE
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 18:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgJEQBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 12:01:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55995 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727165AbgJEQBY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 12:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601913683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WzM75OJ7dMVOtSH9g1wN1IBCIBR91LOKcFE/xZZuN3E=;
        b=dh1ShCBxw6DFAKq1vu2A3d2QPkunYHsiQ6qc4ZuDOQCsA60fnBC9AAbXWQLyhY0MrhQ+/m
        kbE5hX4r7y/ysIyRuT8X12c0qtvfKO9IZngx4N9Jpu+NTJzpeLLFdomvGxh6P7Lg9hPv2f
        mmW8LXZebfmWC/8TqBzmyYIMEAAtbV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-8PACy3Q2Nu-ACd69Gp7OEA-1; Mon, 05 Oct 2020 12:01:18 -0400
X-MC-Unique: 8PACy3Q2Nu-ACd69Gp7OEA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4885C107ACF7;
        Mon,  5 Oct 2020 16:01:16 +0000 (UTC)
Received: from gondolin (ovpn-112-191.ams2.redhat.com [10.36.112.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DCCB60C84;
        Mon,  5 Oct 2020 16:01:10 +0000 (UTC)
Date:   Mon, 5 Oct 2020 18:01:07 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] vfio-pci/zdev: define the vfio_zdev header
Message-ID: <20201005180107.5d027441.cohuck@redhat.com>
In-Reply-To: <8a71af3b-f8fc-48b2-45c6-51222fd2455b@linux.ibm.com>
References: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
        <1601668844-5798-4-git-send-email-mjrosato@linux.ibm.com>
        <20201002154417.20c2a7ef@x1.home>
        <8a71af3b-f8fc-48b2-45c6-51222fd2455b@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Oct 2020 09:52:25 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 10/2/20 5:44 PM, Alex Williamson wrote:

> > Can you discuss why a region with embedded capability chain is a better
> > solution than extending the VFIO_DEVICE_GET_INFO ioctl to support a
> > capability chain and providing this info there?  This all appears to be
> > read-only info, so what's the benefit of duplicating yet another  
> 
> It is indeed read-only info, and the device region was defined as such.
> 
> I would not necessarily be opposed to extending VFIO_DEVICE_GET_INFO 
> with these defined as capabilities; I'd say a primary motivating factor 
> to putting these in their own region was to avoid stuffing a bunch of 
> s390-specific capabilities into a general-purpose ioctl response.

Can't you make the zdev code register the capabilities? That would put
them nicely into their own configurable part.

> 
> But if you're OK with that notion, I can give that a crack in v3.
> 
> > capability chain in a region?  It would also be possible to define four
> > separate device specific regions, one for each of these capabilities
> > rather than creating this chain.  It just seems like a strange approach  
> 
> I'm not sure if creating separate regions would be the right approach 
> though; these are just the first 4.  There will definitely be additional 
> capabilities in support of new zPCI features moving forward, I'm not 
> sure how many regions we really want to end up with.  Some might be as 
> small as a single field, which seems more in-line with capabilities vs 
> an entire region.

If we are expecting more of these in the future, going with GET_INFO
capabilities when adding new ones seems like the best approach.

