Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0C219FC4
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 14:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGIMOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 08:14:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38321 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726767AbgGIMOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 08:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594296841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2asj5z6GDxcxejvOPd+jW3fsNBthnd9siyOya9HivOI=;
        b=G/znWEqChMcn6AUJXwNK7k7jnu7FE9v/e/TCxcBgt7kiSS4gjKIDf3yfamb7TjMr3r7bjl
        Bkcrj9/hLEh/6APO1HD5NlwDpqQAWS+b7tNy4EHxcEa4kzgng2SYfFLs9uhGvYKm+2DyGE
        vRKY8xpJzd2nnkS5yISjNhHE/zv/FHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-YPfsv5fvPGiyh-eViCfsGw-1; Thu, 09 Jul 2020 08:13:57 -0400
X-MC-Unique: YPfsv5fvPGiyh-eViCfsGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68D171080;
        Thu,  9 Jul 2020 12:13:56 +0000 (UTC)
Received: from gondolin (ovpn-113-62.ams2.redhat.com [10.36.113.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A35826FEC2;
        Thu,  9 Jul 2020 12:13:51 +0000 (UTC)
Date:   Thu, 9 Jul 2020 14:13:48 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
Subject: Re: [kvm-unit-tests PATCH v11 9/9] s390x: css: ssch/tsch with sense
 and interrupt
Message-ID: <20200709141348.6ae5ff18.cohuck@redhat.com>
In-Reply-To: <1594282068-11054-10-git-send-email-pmorel@linux.ibm.com>
References: <1594282068-11054-1-git-send-email-pmorel@linux.ibm.com>
        <1594282068-11054-10-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Jul 2020 10:07:48 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> After a channel is enabled we start a SENSE_ID command using
> the SSCH instruction to recognize the control unit and device.
> 
> This tests the success of SSCH, the I/O interruption and the TSCH
> instructions.
> 
> The SENSE_ID command response is tested to report 0xff inside
> its reserved field and to report the same control unit type
> as the cu_type kernel argument.
> 
> Without the cu_type kernel argument, the test expects a device
> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |   1 +
>  lib/s390x/css.h          |  35 ++++++++
>  lib/s390x/css_lib.c      | 183 +++++++++++++++++++++++++++++++++++++++
>  s390x/css.c              |  80 +++++++++++++++++
>  4 files changed, 299 insertions(+)

(...)

> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index eda68a4..c64edd5 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -16,6 +16,7 @@
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
>  #include <asm/time.h>
> +#include <asm/arch_def.h>
>  
>  #include <css.h>
>  
> @@ -103,6 +104,9 @@ retry:
>  	/* Update the SCHIB to enable the channel and set the ISC */
>  	pmcw->flags |= flags;
>  
> +	/* Set Interruption Subclass to IO_SCH_ISC */
> +	pmcw->flags |= (isc << PMCW_ISC_SHIFT);

But isn't the isc already contained in 'flags'? I think you should just
delete these two lines.

> +
>  	/* Tell the CSS we want to modify the subchannel */
>  	cc = msch(schid, &schib);
>  	if (cc) {

(...)

> +/* wait_and_check_io_completion:
> + * @schid: the subchannel ID
> + *
> + * Makes the most common check to validate a successful I/O
> + * completion.
> + * Only report failures.
> + */
> +int wait_and_check_io_completion(int schid)
> +{
> +	int ret = 0;
> +
> +	wait_for_interrupt(PSW_MASK_IO);
> +
> +	report_prefix_push("check I/O completion");
> +
> +	if (lowcore_ptr->io_int_param != schid) {
> +		report(0, "interrupt parameter: expected %08x got %08x",
> +		       schid, lowcore_ptr->io_int_param);
> +		ret = -1;
> +		goto end;
> +	}
> +
> +	/* Verify that device status is valid */
> +	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
> +		report(0, "No status pending after interrupt. Subch Ctrl: %08x",
> +		       irb.scsw.ctrl);
> +		ret = -1;
> +		goto end;
> +	}
> +
> +	if (!(irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
> +		report(0, "Primary or secondary status missing. Subch Ctrl: %08x",
> +		       irb.scsw.ctrl);
> +		ret = -1;
> +		goto end;
> +	}
> +
> +	if (!(irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
> +		report(0, "No device end nor sch end. Dev. status: %02x",

s/nor/or/ ?

> +		       irb.scsw.dev_stat);
> +		ret = -1;
> +		goto end;
> +	}
> +
> +	if (irb.scsw.sch_stat & !(SCSW_SCHS_PCI | SCSW_SCHS_IL)) {

Did you mean ~(SCSW_SCHS_PCI | SCSW_SCHS_IL)?

If yes, why do think a PCI may show up?

> +		report_info("Unexpected Subch. status %02x", irb.scsw.sch_stat);
> +		ret = -1;
> +		goto end;
> +	}
> +
> +end:
> +	report_prefix_pop();
> +	return ret;

(...)

