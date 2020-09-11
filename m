Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F7D26674E
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgIKRli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:41:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54740 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725981AbgIKMlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 08:41:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599828067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ScUjzYeMKL2oNRc7AhTDlDfSyj77AbtBTspQLIULrBA=;
        b=SaWPGdFDeE/Obuhas+2V/i8DB/YYxEbiP5DXo7rEg5oqf3uXQYpRqSzkwmNn8f/25Qdfp4
        GnYfy3RNNg3MggSgSkjmVPaZAeob1IyxqFB1jrC9m1QiaF6f2dKmGxIbPL1sBN7Bj99aX+
        3G27X1f3d77JX5SKiohUquz84w5umL4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-yEKvR8T3OSCNHhxfAzO5kQ-1; Fri, 11 Sep 2020 08:41:06 -0400
X-MC-Unique: yEKvR8T3OSCNHhxfAzO5kQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8E76DF7C0;
        Fri, 11 Sep 2020 12:41:04 +0000 (UTC)
Received: from gondolin (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A27F75128;
        Fri, 11 Sep 2020 12:41:00 +0000 (UTC)
Date:   Fri, 11 Sep 2020 14:40:58 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [PATCH v1 2/3] s390: define UV compatible I/O allocation
Message-ID: <20200911144058.5fe82f26.cohuck@redhat.com>
In-Reply-To: <1598875533-19947-3-git-send-email-pmorel@linux.ibm.com>
References: <1598875533-19947-1-git-send-email-pmorel@linux.ibm.com>
        <1598875533-19947-3-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 31 Aug 2020 14:05:32 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> To centralize the memory allocation for I/O we define
> the alloc/free_io_page() functions which share the I/O
> memory with the host in case the guest runs with
> protected virtualization.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/malloc_io.c | 53 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/malloc_io.h | 14 ++++++++++++
>  s390x/Makefile        |  1 +
>  3 files changed, 68 insertions(+)
>  create mode 100644 lib/s390x/malloc_io.c
>  create mode 100644 lib/s390x/malloc_io.h
> 
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> new file mode 100644
> index 0000000..0e67aab
> --- /dev/null
> +++ b/lib/s390x/malloc_io.c
> @@ -0,0 +1,53 @@
> +/*
> + * I/O page allocation
> + *
> + * Copyright (c) 2020 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + *
> + * Using this interface provide host access to the allocated pages in
> + * case the guest is a secure guest.
> + * This is needed for I/O buffers.
> + *
> + */
> +
> +#include <libcflat.h>
> +#include <alloc_page.h>
> +#include <asm/page.h>
> +#include <asm/uv.h>
> +#include <malloc_io.h>
> +#include <asm/facility.h>
> +
> +
> +void *alloc_io_page(int size)
> +{
> +	void *p;
> +
> +	assert(size <= PAGE_SIZE);
> +	p = alloc_page();

I see that you use this for some I/O structures in the next patch. Is
this guaranteed to be under 2G all the time?

