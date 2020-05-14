Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAD01D2F18
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 14:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgENMDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 08:03:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59021 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726890AbgENMD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 08:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589457808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X9P3ilbuiM5hq1mDk1jO3ylAtuZB0CqNukgCfSSywrw=;
        b=hOvJGs8dsfhaqyNbXeMp0qA8X1En6RDORHAq1hhugT3EYHXie01AOB98Mmka195zigs2Rl
        UitSENPLsCTJoNWFwshPhc36xRWsjIjPZrx6kbCYvOuC61eEdr/oX6TNr2k8DpVIXTljph
        NyIf9uKY5Va6J6LLqH6GHQ1VP2rbP0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-JAfqr1lYMOCcj6sTsNublg-1; Thu, 14 May 2020 08:03:23 -0400
X-MC-Unique: JAfqr1lYMOCcj6sTsNublg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 668DB19057A3;
        Thu, 14 May 2020 12:03:22 +0000 (UTC)
Received: from gondolin (unknown [10.40.192.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F10D5C1BE;
        Thu, 14 May 2020 12:03:17 +0000 (UTC)
Date:   Thu, 14 May 2020 14:03:15 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 05/10] s390x: Library resources for
 CSS tests
Message-ID: <20200514140315.6077046b.cohuck@redhat.com>
In-Reply-To: <1587725152-25569-6-git-send-email-pmorel@linux.ibm.com>
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
        <1587725152-25569-6-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Apr 2020 12:45:47 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> These are the include and library utilities for the css tests patch
> series.

"Provide some definitions and library routines that can be used by
tests targeting the channel subsystem."

?

> 
> Debug function can be activated by defining DEBUG_CSS before the
> inclusion of the css.h header file.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h      | 256 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/css_dump.c | 157 ++++++++++++++++++++++++++
>  2 files changed, 413 insertions(+)
>  create mode 100644 lib/s390x/css.h
>  create mode 100644 lib/s390x/css_dump.c

(...)

> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
> new file mode 100644
> index 0000000..2f33fab
> --- /dev/null
> +++ b/lib/s390x/css_dump.c
> @@ -0,0 +1,157 @@
> +/*
> + * Channel subsystem structures dumping
> + *
> + * Copyright (c) 2020 IBM Corp.
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + *
> + * Description:
> + * Provides the dumping functions for various structures used by subchannels:
> + * - ORB  : Operation request block, describes the I/O operation and points to
> + *          a CCW chain
> + * - CCW  : Channel Command Word, describes the data and flow control

"describes the command, data, and flow control" ?

> + * - IRB  : Interuption response Block, describes the result of an operation

s/operation/operation;/

> + *          holds a SCSW and model-dependent data.
> + * - SCHIB: SubCHannel Information Block composed of:

> + *   - SCSW: SubChannel Status Word, status of the channel.
> + *   - PMCW: Path Management Control Word
> + * You need the QEMU ccw-pong device in QEMU to answer the I/O transfers.
> + */

(...)

Otherwise, looks good.

