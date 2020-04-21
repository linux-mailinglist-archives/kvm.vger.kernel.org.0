Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29D91B2B41
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 17:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDUPf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 11:35:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27651 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725870AbgDUPf5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 11:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587483355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PGNerKQ1UQx6WT1P5HU0VQqoOoFnJq56uynZHi+cqPw=;
        b=PLjncxSMm4aH4eYJPLwK7Ezlco9aAueGQPly5ug06Wj0I7pKVu+KEgp4EGrw1znEuFrZnY
        0AxhbiaAutKCpOC4swlteQUFR1c/XBipd4a+fx2AR+DF+LzNSREzgGw2joO7NCDgYtqL5h
        nkLvQsVg4yYwI1AlWmlrCXcCpqj/fL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-XULLsK9UOUaHAmQxCyg8NQ-1; Tue, 21 Apr 2020 11:35:50 -0400
X-MC-Unique: XULLsK9UOUaHAmQxCyg8NQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3AED1005510;
        Tue, 21 Apr 2020 15:35:48 +0000 (UTC)
Received: from gondolin (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5290A5C1B2;
        Tue, 21 Apr 2020 15:35:47 +0000 (UTC)
Date:   Tue, 21 Apr 2020 17:35:44 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v3 0/8] s390x/vfio-ccw: Channel Path Handling [KVM]
Message-ID: <20200421173544.36b48657.cohuck@redhat.com>
In-Reply-To: <20200417023001.65006-1-farman@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 04:29:53 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Here is a new pass at the channel-path handling code for vfio-ccw.
> Changes from previous versions are recorded in git notes for each patch.
> 
> I dropped the "Remove inline get_schid()" patch from this version.
> When I made the change suggested in v2, it seemed rather frivolous and
> better to just drop it for the time being.
> 
> I suspect that patches 5 and 7 would be better squashed together, but I
> have not done that here.  For future versions, I guess.

The result also might get a bit large.

> 
> With this, and the corresponding QEMU series (to be posted momentarily),
> applied I am able to configure off/on a CHPID (for example, by issuing
> "chchp -c 0/1 xx" on the host), and the guest is able to see both the
> events and reflect the updated path masks in its structures.

Basically, this looks good to me (modulo my comments).

One thing though that keeps coming up: do we need any kind of
serialization? Can there be any confusion from concurrent reads from
userspace, or are we sure that we always provide consistent data?

