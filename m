Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FF14AB6AB
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 09:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbiBGIiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 03:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243374AbiBGIaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 03:30:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B5D7C043181
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 00:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644222622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Tgu8NU8kx/MzJz+tw2bHaoQFz1xbDGIOoBlb5WHVtg=;
        b=NKGZHTmjW9atyQqYPgpGgeSAVgOM9cHduI35lMs9sBjqAQYIN5LFrnJbbDuPNXPM24ZAMh
        KAunkBr/sKT0bHUdj+3u8BXJd3cSimoZ2F4Uiv6jXtGQb+wd8C3xzwLOMWUGI322l4EliX
        yYZbSbQdnFWQ9wqooER+UXY+vlMk8fM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-N8a6INfDMTKha-eEGwL6DA-1; Mon, 07 Feb 2022 03:30:19 -0500
X-MC-Unique: N8a6INfDMTKha-eEGwL6DA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CDFB8519E1;
        Mon,  7 Feb 2022 08:30:17 +0000 (UTC)
Received: from localhost (unknown [10.39.193.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18CB510589D0;
        Mon,  7 Feb 2022 08:29:46 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/30] s390/airq: allow for airq structure that uses
 an input vector
In-Reply-To: <20220204211536.321475-7-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-7-mjrosato@linux.ibm.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 07 Feb 2022 09:29:44 +0100
Message-ID: <87fsovw03r.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04 2022, Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> When doing device passthrough where interrupts are being forwarded from
> host to guest, we wish to use a pinned section of guest memory as the
> vector (the same memory used by the guest as the vector). To accomplish
> this, add a new parameter for airq_iv_create which allows passing an
> existing vector to be used instead of allocating a new one. The caller
> is responsible for ensuring the vector is pinned in memory as well as for
> unpinning the memory when the vector is no longer needed.
>
> A subsequent patch will use this new parameter for zPCI interpretation.
>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/airq.h     |  4 +++-
>  arch/s390/pci/pci_irq.c          |  8 ++++----
>  drivers/s390/cio/airq.c          | 10 +++++++---
>  drivers/s390/virtio/virtio_ccw.c |  2 +-
>  4 files changed, 15 insertions(+), 9 deletions(-)

For virtio-ccw:

Acked-by: Cornelia Huck <cohuck@redhat.com>

