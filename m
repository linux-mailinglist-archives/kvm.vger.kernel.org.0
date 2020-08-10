Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52172407D7
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 16:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgHJOuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 10:50:18 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59165 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726566AbgHJOuQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Aug 2020 10:50:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597071014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bK7LTugR9irDMksjSOKMpjczsYVFGyJFGSt1kjQOOJs=;
        b=d3fbgqQokHaTD2YmRWUFRUYPQR0QkoHDFpctAEhke7lgaRgyXu9vGkM5vaaL8M4Dlb77Io
        div+ITZ2ESnj9vnqGWIIeGiwyXpF9gHHcvbORWHFxCeqcj27kJuczucMETX/59CdhGZJ5H
        ZOKJ3N9xkOwDCcN64kWMx8TJR63rIA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-zkZN_HHvPEaNy1sWmqzmMQ-1; Mon, 10 Aug 2020 10:50:12 -0400
X-MC-Unique: zkZN_HHvPEaNy1sWmqzmMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48C268005B0;
        Mon, 10 Aug 2020 14:50:11 +0000 (UTC)
Received: from gondolin (ovpn-112-218.ams2.redhat.com [10.36.112.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4AB669319;
        Mon, 10 Aug 2020 14:50:06 +0000 (UTC)
Date:   Mon, 10 Aug 2020 16:50:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
Message-ID: <20200810165004.02c4b5bf.cohuck@redhat.com>
In-Reply-To: <20200807111555.11169-4-frankja@linux.ibm.com>
References: <20200807111555.11169-1-frankja@linux.ibm.com>
        <20200807111555.11169-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Aug 2020 07:15:55 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Test the error conditions of guest 2 Ultravisor calls, namely:
>      * Query Ultravisor information
>      * Set shared access
>      * Remove shared access
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h  |  74 ++++++++++++++++++++
>  s390x/Makefile      |   1 +
>  s390x/unittests.cfg |   3 +
>  s390x/uv-guest.c    | 162 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 240 insertions(+)
>  create mode 100644 lib/s390x/asm/uv.h
>  create mode 100644 s390x/uv-guest.c

(...)

> +static inline int uv_call(unsigned long r1, unsigned long r2)
> +{
> +	int cc;
> +
> +	/*
> +	 * The brc instruction will take care of the cc 2/3 case where
> +	 * we need to continue the execution because we were
> +	 * interrupted. The inline assembly will only return on
> +	 * success/error i.e. cc 0/1.
> +	*/

Thanks, that is helpful.

> +	asm volatile(
> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> +		"		brc	3,0b\n"
> +		"		ipm	%[cc]\n"
> +		"		srl	%[cc],28\n"
> +		: [cc] "=d" (cc)
> +		: [r1] "a" (r1), [r2] "a" (r2)
> +		: "memory", "cc");
> +	return cc;
> +}
> +
> +#endif

(...)

> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> new file mode 100644
> index 0000000..1aaf7ca
> --- /dev/null
> +++ b/s390x/uv-guest.c
> @@ -0,0 +1,162 @@
> +/*
> + * Guest Ultravisor Call tests
> + *
> + * Copyright (c) 2020 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#include <libcflat.h>
> +#include <alloc_page.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/facility.h>
> +#include <asm/uv.h>
> +
> +static unsigned long page;
> +
> +static inline int share(unsigned long addr, u16 cmd)
> +{
> +	struct uv_cb_share uvcb = {
> +		.header.cmd = cmd,
> +		.header.len = sizeof(uvcb),
> +		.paddr = addr
> +	};
> +
> +	uv_call(0, (u64)&uvcb);
> +	return uvcb.header.rc;

Any reason why you're not checking rc and cc here...

> +}
> +
> +static inline int uv_set_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
> +}
> +
> +static inline int uv_remove_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
> +}

(...)

> +static void test_sharing(void)
> +{
> +	struct uv_cb_share uvcb = {
> +		.header.cmd = UVC_CMD_SET_SHARED_ACCESS,
> +		.header.len = sizeof(uvcb) - 8,
> +	};
> +	int cc;
> +
> +	report_prefix_push("share");
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");

...while you do it for this command (as for all the others)?

> +	report(uv_set_shared(page) == UVC_RC_EXECUTED, "share");

So, is that one of the cases where something is actually indicated in
rc on success? Or does cc=0/1 have a different meaning for these calls?

> +	report_prefix_pop();
> +
> +	report_prefix_push("unshare");
> +	uvcb.header.cmd = UVC_CMD_REMOVE_SHARED_ACCESS;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
> +	report(uv_remove_shared(page) == UVC_RC_EXECUTED, "unshare");
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}

(...)

