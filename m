Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD9710EC07
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 16:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfLBPDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 10:03:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59245 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727417AbfLBPDw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 10:03:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575299031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zwiu4k4N1pSKduhjQSjgpy1dNfgDH4lSfwh55hWSVbo=;
        b=S6L8HMwLUB+AYLCUGXldl2bCgFDPnrHNRhLMxDuP86NlQkz/p8P0vyhBG6Dy24vtxrWDg4
        57J1uM8H6FjWUx2OOXuWSoOYYObEXZByUYCYZwOwqri4Hze7ZX16JdCbpwDdnqAz2+Bz7B
        TXwWDr9cn+TZQXDs9Rx/pFNqBUxha1I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-fQKVT74JN2y3nUtrunTlTw-1; Mon, 02 Dec 2019 10:03:48 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21F3F107ACC7;
        Mon,  2 Dec 2019 15:03:47 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 648C0600C8;
        Mon,  2 Dec 2019 15:03:43 +0000 (UTC)
Date:   Mon, 2 Dec 2019 16:03:41 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 9/9] s390x: css: ping pong
Message-ID: <20191202160341.5e96fb81.cohuck@redhat.com>
In-Reply-To: <1574945167-29677-10-git-send-email-pmorel@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
        <1574945167-29677-10-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: fQKVT74JN2y3nUtrunTlTw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Nov 2019 13:46:07 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> To test a write command with the SSCH instruction we need a QEMU device,
> with control unit type 0xC0CA. The PONG device is such a device.

"We want to test some read/write ccws via the SSCH instruction with a
QEMU device with control unit type 0xC0CA." ?

> 
> This type of device respond to PONG_WRITE requests by incrementing an

s/respond/responds/

> integer, stored as a string at offset 0 of the CCW data.
> 
> This is only a success test, no error expected.

Nobody expects the Spanish Inquisition^W^W^W an error :)

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index 534864f..0761e70 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -23,6 +23,10 @@
>  #define SID_ONE		0x00010000
>  #define PSW_PRG_MASK (PSW_MASK_IO | PSW_MASK_EA | PSW_MASK_BA)
>  
> +/* Local Channel Commands */

/* Channel commands for the PONG device */

?

> +#define PONG_WRITE	0x21 /* Write */
> +#define PONG_READ	0x22 /* Read buffer */
> +
>  struct lowcore *lowcore = (void *)0x0;
>  
>  static struct schib schib;
> @@ -31,7 +35,8 @@ static struct ccw ccw[NB_CCW];
>  #define NB_ORB  100
>  static struct orb orb[NB_ORB];
>  static struct irb irb;
> -static char buffer[0x1000] __attribute__ ((aligned(8)));
> +#define BUF_SZ	0x1000
> +static char buffer[BUF_SZ] __attribute__ ((aligned(8)));

Merge this with the introduction of this variable?

>  static struct senseid senseid;
>  
>  static const char *Channel_type[3] = {
> @@ -224,6 +229,44 @@ static void test_sense(void)
>  		report("cu_type: expect c0ca, got %04x", 0, senseid.cu_type);
>  }
>  
> +static void test_ping(void)
> +{
> +	int success, result;
> +	int cnt = 0, max = 4;
> +
> +	if (senseid.cu_type != PONG_CU) {
> +		report_skip("No PONG, no ping-pong");

:D

> +		return;
> +	}
> +
> +	enable_io_irq();

Hasn't that been enabled already for doing SenseID?

> +
> +	while (cnt++ < max) {
> +report_info("cnt..: %08x", cnt);

Wrong indentation?

> +		snprintf(buffer, BUF_SZ, "%08x\n", cnt);
> +		success = start_subchannel(PONG_WRITE, buffer, 8);
> +		if (!success) {
> +			report("start_subchannel failed", 0);
> +			return;
> +		}
> +		delay(100);
> +		success = start_subchannel(PONG_READ, buffer, 8);
> +		if (!success) {
> +			report("start_subchannel failed", 0);
> +			return;
> +		}
> +		result = atol(buffer);
> +		if (result != (cnt + 1)) {
> +			report("Bad answer from pong: %08x - %08x", 0, cnt, result);
> +			return;
> +		} else 
> +			report_info("%08x - %08x", cnt, result);
> +
> +		delay(100);
> +	}
> +	report("ping-pong count 0x%08x", 1, cnt);
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -231,6 +274,7 @@ static struct {
>  	{ "enumerate (stsch)", test_enumerate },
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
> +	{ "ping-pong (ssch/tsch)", test_ping },
>  	{ NULL, NULL }
>  };
>  

