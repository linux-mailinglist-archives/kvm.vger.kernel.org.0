Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDC411E12B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 10:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbfLMJuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 04:50:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54878 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725799AbfLMJuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 04:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576230619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sb1dTjMZ9HzpDhd/n04vmVM+Q+wH13AKDyjIlsf+IvM=;
        b=bIafQFo65v6xU7/m69oh9XCF7L9OtqeY71gwuMfPtpsI9179SKZVs3D8mZkgtOYKQB0fwF
        wH7XCPyzk5Qvv+1ms7qhhh33A5iZBlnYt90vCcrwsgQam3xa0W6KvBBQNuYjEuRmeU4ddG
        J4hS2v967hW5CEVtLNtuXCXq6gKyadM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-r4ErXIL1P9OcdSq93F0IVQ-1; Fri, 13 Dec 2019 04:50:16 -0500
X-MC-Unique: r4ErXIL1P9OcdSq93F0IVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B5891883522;
        Fri, 13 Dec 2019 09:50:15 +0000 (UTC)
Received: from gondolin (ovpn-116-226.ams2.redhat.com [10.36.116.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5C5F5D9C9;
        Fri, 13 Dec 2019 09:50:11 +0000 (UTC)
Date:   Fri, 13 Dec 2019 10:50:09 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 9/9] s390x: css: ping pong
Message-ID: <20191213105009.482bab48.cohuck@redhat.com>
In-Reply-To: <1576079170-7244-10-git-send-email-pmorel@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
        <1576079170-7244-10-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Dec 2019 16:46:10 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> To test a write command with the SSCH instruction we need a QEMU device,
> with control unit type 0xC0CA. The PONG device is such a device.
> 
> This type of device responds to PONG_WRITE requests by incrementing an
> integer, stored as a string at offset 0 of the CCW data.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index 7b9bdb1..a09cdff 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -26,6 +26,9 @@
>  
>  #define CSS_TEST_INT_PARAM	0xcafec0ca
>  #define PONG_CU_TYPE		0xc0ca
> +/* Channel Commands for PONG device */
> +#define PONG_WRITE	0x21 /* Write */
> +#define PONG_READ	0x22 /* Read buffer */
>  
>  struct lowcore *lowcore = (void *)0x0;
>  
> @@ -302,6 +305,48 @@ unreg_cb:
>  	unregister_io_int_func(irq_io);
>  }
>  
> +static void test_ping(void)
> +{
> +	int success, result;
> +	int cnt = 0, max = 4;
> +
> +	if (senseid.cu_type != PONG_CU) {
> +		report_skip("No PONG, no ping-pong");
> +		return;
> +	}
> +
> +	result = register_io_int_func(irq_io);
> +	if (result) {
> +		report(0, "Could not register IRQ handler");
> +		return;
> +	}
> +
> +	while (cnt++ < max) {
> +		snprintf(buffer, BUF_SZ, "%08x\n", cnt);
> +		success = start_subchannel(PONG_WRITE, buffer, 8);

Magic value? Maybe introduce a #define for the lengths of the
reads/writes?

[This also got me thinking about your start_subchannel function
again... do you also want to allow flags like e.g. SLI? It's not
unusual for commands to return different lengths of data depending on
what features are available; it might be worthwhile to allow short data
if you're not sure that e.g. a command returns either the short or the
long version of a structure.]


> +		if (!success) {
> +			report(0, "start_subchannel failed");
> +			goto unreg_cb;
> +		}
> +		delay(100);
> +		success = start_subchannel(PONG_READ, buffer, 8);
> +		if (!success) {
> +			report(0, "start_subchannel failed");
> +			goto unreg_cb;
> +		}
> +		result = atol(buffer);
> +		if (result != (cnt + 1)) {
> +			report(0, "Bad answer from pong: %08x - %08x",
> +			       cnt, result);
> +			goto unreg_cb;
> +		}
> +	}
> +	report(1, "ping-pong count 0x%08x", cnt);
> +
> +unreg_cb:
> +	unregister_io_int_func(irq_io);
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -309,6 +354,7 @@ static struct {
>  	{ "enumerate (stsch)", test_enumerate },
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
> +	{ "ping-pong (ssch/tsch)", test_ping },
>  	{ NULL, NULL }
>  };
>  

