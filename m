Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187C34AB6BC
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 09:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiBGIhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 03:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238788AbiBGI25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 03:28:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15A36C043184
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 00:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644222536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FJ5taJzIn7M+azZADWBSS56Hl06do4D4nfM2v7m4sMo=;
        b=Zej+rzkLGgNvngSoXiMAdBgmbAYYL4Xg97QLLqg5o4XppqgxzCL5IGwDfeFTWeWxpLur4I
        GO5AQti37rhD0a9qFAE+Swm2ipLDm6i2+pxv3UEKMspY4lXJW5rGw4gKin9N/W12FaNWTV
        wghruRh37vVe9QOJ1Zo9zRDZ04ZJEvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-ThYU6bVkMjCJpBn0dqlQMQ-1; Mon, 07 Feb 2022 03:28:51 -0500
X-MC-Unique: ThYU6bVkMjCJpBn0dqlQMQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D93261091DA0;
        Mon,  7 Feb 2022 08:28:48 +0000 (UTC)
Received: from localhost (unknown [10.39.193.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 851F810589D0;
        Mon,  7 Feb 2022 08:28:29 +0000 (UTC)
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
Subject: Re: [PATCH v3 05/30] s390/airq: pass more TPI info to airq handlers
In-Reply-To: <20220204211536.321475-6-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-6-mjrosato@linux.ibm.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 07 Feb 2022 09:28:27 +0100
Message-ID: <87iltrw05w.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04 2022, Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> A subsequent patch will introduce an airq handler that requires additional
> TPI information beyond directed vs floating, so pass the entire tpi_info
> structure via the handler.  Only pci actually uses this information today,
> for the other airq handlers this is effectively a no-op.
>
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/airq.h     | 3 ++-
>  arch/s390/kvm/interrupt.c        | 4 +++-
>  arch/s390/pci/pci_irq.c          | 9 +++++++--
>  drivers/s390/cio/airq.c          | 2 +-
>  drivers/s390/cio/qdio_thinint.c  | 6 ++++--
>  drivers/s390/crypto/ap_bus.c     | 9 ++++++---
>  drivers/s390/virtio/virtio_ccw.c | 4 +++-
>  7 files changed, 26 insertions(+), 11 deletions(-)

For virtio-ccw:

Acked-by: Cornelia Huck <cohuck@redhat.com>

