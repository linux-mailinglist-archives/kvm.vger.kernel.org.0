Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5398516BE72
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 11:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgBYKSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 05:18:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45567 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728958AbgBYKSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 05:18:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582625924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hUu2xKTRsnYqwk0ndYloc0mXEMdSG6DAu7XN/C9HERw=;
        b=AELDJzV+D+61UWmF4vLP5MdngGDf6Psesh/MobT57TUWbpJ/5DtU4UNKqRU4kFVfm+Qt+b
        HKupKiYE5C0LtYA1vCMlmwqrpObjow8LDyupkyz5NL6d73hMCc6bwn6rzYQ4HFC4rM+r6F
        kmNHF+S7WcPSgn0QX2y/WX0KboGd/AI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-RF6-T8c0OzqEI0GF9iSGqw-1; Tue, 25 Feb 2020 05:18:40 -0500
X-MC-Unique: RF6-T8c0OzqEI0GF9iSGqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8D0A189F769;
        Tue, 25 Feb 2020 10:18:38 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 948AE60BF7;
        Tue, 25 Feb 2020 10:18:34 +0000 (UTC)
Date:   Tue, 25 Feb 2020 11:18:31 +0100
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
Subject: Re: [PATCH v4 02/36] KVM: s390/interrupt: do not pin adapter
 interrupt pages
Message-ID: <20200225111831.436c6e0a.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-3-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-3-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:40:33 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> 
> The adapter interrupt page containing the indicator bits is currently
> pinned. That means that a guest with many devices can pin a lot of
> memory pages in the host. This also complicates the reference tracking
> which is needed for memory management handling of protected virtual
> machines. It might also have some strange side effects for madvise
> MADV_DONTNEED and other things.
> 
> We can simply try to get the userspace page set the bits and free the
> page. By storing the userspace address in the irq routing entry instead
> of the guest address we can actually avoid many lookups and list walks
> so that this variant is very likely not slower.
> 
> If userspace messes around with the memory slots the worst thing that
> can happen is that we write to some other memory within that process.
> As we get the the page with FOLL_WRITE this can also not be used to
> write to shared read-only pages.
> 
> Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch simplification]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  Documentation/virt/kvm/devices/s390_flic.rst |  11 +-
>  arch/s390/include/asm/kvm_host.h             |   3 -
>  arch/s390/kvm/interrupt.c                    | 170 ++++++-------------
>  3 files changed, 51 insertions(+), 133 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

