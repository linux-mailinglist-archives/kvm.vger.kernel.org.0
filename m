Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CCF11CCB5
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 13:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfLLMBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 07:01:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726492AbfLLMBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 07:01:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576152082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CPE/8oIGO26OJsajbewmS01w56jDq0RNArcjOdYfuO4=;
        b=X5mwd5CXRYW9g3pg4FcJE7vBjOVg0ku46FJGPNhVLVkLzOV7C5PXhnvqs/CiHEnL2nEQZi
        Jtlx7Bz3rwcfvyz4ZHgvZ5xCKU1kYIFtzhQflSIwBfaFbPW+tk+8wePTiLGvFKSwGYIBlN
        /Z4Sn9nf7HmNUnM6jazEi169fR7Id4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-PZRf8znCNCSf5aavRxb3KQ-1; Thu, 12 Dec 2019 07:01:18 -0500
X-MC-Unique: PZRf8znCNCSf5aavRxb3KQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E788100551D;
        Thu, 12 Dec 2019 12:01:17 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1913A19C58;
        Thu, 12 Dec 2019 12:01:13 +0000 (UTC)
Date:   Thu, 12 Dec 2019 13:01:11 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 7/9] s390x: css: msch, enable test
Message-ID: <20191212130111.0f75fe7f.cohuck@redhat.com>
In-Reply-To: <1576079170-7244-8-git-send-email-pmorel@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
        <1576079170-7244-8-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Dec 2019 16:46:08 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> A second step when testing the channel subsystem is to prepare a channel
> for use.
> This includes:
> - Get the current SubCHannel Information Block (SCHIB) using STSCH
> - Update it in memory to set the ENABLE bit
> - Tell the CSS that the SCHIB has been modified using MSCH
> - Get the SCHIB from the CSS again to verify that the subchannel is
>   enabled.
> 
> This tests the success of the MSCH instruction by enabling a channel.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index dfab35f..b8824ad 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -19,12 +19,24 @@
>  #include <asm/time.h>
>  
>  #include <css.h>
> +#include <asm/time.h>
>  
>  #define SID_ONE		0x00010000
>  
>  static struct schib schib;
>  static int test_device_sid;
>  
> +static inline void delay(unsigned long ms)
> +{
> +	unsigned long startclk;
> +
> +	startclk = get_clock_ms();
> +	for (;;) {
> +		if (get_clock_ms() - startclk > ms)
> +			break;
> +	}
> +}

Would this function be useful for other callers as well? I.e., should
it go into a common header?

> +
>  static void test_enumerate(void)
>  {
>  	struct pmcw *pmcw = &schib.pmcw;
> @@ -64,11 +76,64 @@ out:
>  	report(1, "Devices, tested: %d, I/O type: %d", scn, scn_found);
>  }
>  
> +static void test_enable(void)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +		int count = 0;

Odd indentation.

> +	int cc;
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +	/* Read the SCHIB for this subchannel */
> +	cc = stsch(test_device_sid, &schib);
> +	if (cc) {
> +		report(0, "stsch cc=%d", cc);
> +		return;
> +	}
> +
> +	/* Update the SCHIB to enable the channel */
> +	pmcw->flags |= PMCW_ENABLE;
> +
> +	/* Tell the CSS we want to modify the subchannel */
> +	cc = msch(test_device_sid, &schib);
> +	if (cc) {
> +		/*
> +		 * If the subchannel is status pending or
> +		 * if a function is in progress,
> +		 * we consider both cases as errors.
> +		 */
> +		report(0, "msch cc=%d", cc);
> +		return;
> +	}
> +
> +	/*
> +	 * Read the SCHIB again to verify the enablement
> +	 * insert a little delay and try 5 times.
> +	 */
> +	do {
> +		cc = stsch(test_device_sid, &schib);
> +		if (cc) {
> +			report(0, "stsch cc=%d", cc);
> +			return;
> +		}
> +		delay(10);

That's just a short delay to avoid a busy loop, right? msch should be
immediate, and you probably should not delay on success?

> +	} while (!(pmcw->flags & PMCW_ENABLE) && count++ < 5);

How is this supposed to work? Doesn't the stsch overwrite the control
block again, so you need to re-set the enable bit before you retry?

> +
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		report(0, "Enable failed. pmcw: %x", pmcw->flags);
> +		return;
> +	}
> +	report(1, "Tested");
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
>  } tests[] = {
>  	{ "enumerate (stsch)", test_enumerate },
> +	{ "enable (msch)", test_enable },
>  	{ NULL, NULL }
>  };
>  

