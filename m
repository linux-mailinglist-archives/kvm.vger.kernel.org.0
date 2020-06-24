Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE522207347
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 14:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389504AbgFXM0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 08:26:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44026 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388296AbgFXM0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 08:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593001591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//a7AwgdL3EMlmKzdzygrkm/h2UlJCHixiMJsRC6eY0=;
        b=jFYhhFeTOnSlGmL3FpqrF3Geq7ORbep1oul/VgMzRhADncWyvWt4TIa6/1qDLiU116332m
        x7G7sV2qXoEylgmYpRJ6E/7I1Sr9F3+UxrUkU4cDlE4SiPjuLDSwUGzMPvbtrwsBhYoapY
        6GzrKUx0f4wofKVEldqIjEdfdBccFqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-ti_anV-MOPSmAJ-nLh_sMg-1; Wed, 24 Jun 2020 08:26:28 -0400
X-MC-Unique: ti_anV-MOPSmAJ-nLh_sMg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3EAE107ACF5;
        Wed, 24 Jun 2020 12:26:26 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-35.ams2.redhat.com [10.36.114.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F15521008034;
        Wed, 24 Jun 2020 12:26:22 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v9 09/12] s390x: Library resources for CSS
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-10-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9de11879-4429-bfe8-7f1e-1f5880764a6a@redhat.com>
Date:   Wed, 24 Jun 2020 14:26:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1592213521-19390-10-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/2020 11.31, Pierre Morel wrote:
> Provide some definitions and library routines that can be used by
> tests targeting the channel subsystem.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h      | 256 +++++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/css_dump.c | 153 ++++++++++++++++++++++++++
>   s390x/Makefile       |   1 +
>   3 files changed, 410 insertions(+)
>   create mode 100644 lib/s390x/css.h
>   create mode 100644 lib/s390x/css_dump.c
[...]
> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
> new file mode 100644
> index 0000000..0c2b64e
> --- /dev/null
> +++ b/lib/s390x/css_dump.c
> @@ -0,0 +1,153 @@
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
> + * - CCW  : Channel Command Word, describes the command, data and flow control
> + * - IRB  : Interuption response Block, describes the result of an operation;
> + *          holds a SCSW and model-dependent data.
> + * - SCHIB: SubCHannel Information Block composed of:
> + *   - SCSW: SubChannel Status Word, status of the channel.
> + *   - PMCW: Path Management Control Word
> + * You need the QEMU ccw-pong device in QEMU to answer the I/O transfers.
> + */
> +
> +#include <libcflat.h>
> +#include <unistd.h>

Please don't use unistd.h in kvm-unit-tests - this header is not usable 
in cross-compilation environments:

  https://travis-ci.com/github/huth/kvm-unit-tests/jobs/353089278#L536

Thanks,
  Thomas

