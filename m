Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C052FD188
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbhATMwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388909AbhATMIv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 07:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611144441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=opfJNQRQcs9MJxN8ETRTKMayG1fw4B2T7Jjff0QeIhU=;
        b=hJt6gki01iEs0pMMLAjcjC71VSY3PjlhHqQI/9SzHB9IuBqHtbTlXjWUjHxYw3Jvb/rmkF
        NYnT1UMTnCSYC+n3dZ75xOshw1C96H2QbYDAFzKQXAL6pBd//57ZefOtaMtYasF2yPQY65
        g0GV1B4t5Gs3eY8w4vSSpn7kO4dTcZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-ec8CHfhCNPmZyAA8Lm3CkQ-1; Wed, 20 Jan 2021 07:03:47 -0500
X-MC-Unique: ec8CHfhCNPmZyAA8Lm3CkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF73F100947B;
        Wed, 20 Jan 2021 12:03:45 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-135.ams2.redhat.com [10.36.114.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF4655D9C2;
        Wed, 20 Jan 2021 12:03:40 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: css: pv: css test adaptation
 for PV
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
 <1611085944-21609-4-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b4656e81-1492-d902-73cf-5a08a0a6247d@redhat.com>
Date:   Wed, 20 Jan 2021 13:03:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611085944-21609-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/01/2021 20.52, Pierre Morel wrote:
> We want the tests to automatically work with or without protected
> virtualisation.
> To do this we need to share the I/O memory with the host.
> 
> Let's replace all static allocations with dynamic allocations
> to clearly separate shared and private memory.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
[...]
> diff --git a/s390x/css.c b/s390x/css.c
> index ee3bc83..4b0b6b1 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -17,13 +17,15 @@
>   #include <interrupt.h>
>   #include <asm/arch_def.h>
>   
> +#include <malloc_io.h>
>   #include <css.h>
> +#include <asm/barrier.h>
>   
>   #define DEFAULT_CU_TYPE		0x3832 /* virtio-ccw */
>   static unsigned long cu_type = DEFAULT_CU_TYPE;
>   
>   static int test_device_sid;
> -static struct senseid senseid;
> +static struct senseid *senseid;
>   
>   static void test_enumerate(void)
>   {
> @@ -57,6 +59,7 @@ static void test_enable(void)
>    */
>   static void test_sense(void)
>   {
> +	struct ccw1 *ccw;
>   	int ret;
>   	int len;
>   
> @@ -80,9 +83,15 @@ static void test_sense(void)
>   
>   	lowcore_ptr->io_int_param = 0;
>   
> -	memset(&senseid, 0, sizeof(senseid));
> -	ret = start_single_ccw(test_device_sid, CCW_CMD_SENSE_ID,
> -			       &senseid, sizeof(senseid), CCW_F_SLI);
> +	senseid = alloc_io_page(sizeof(*senseid));

Would it make sense to move the above alloc_io_page into the ccw_alloc() 
function, too?

> +	if (!senseid)
> +		goto error_senseid;
> +
> +	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
> +	if (!ccw)
> +		goto error_ccw;
> +
> +	ret = start_ccw1_chain(test_device_sid, ccw);
>   	if (ret)
>   		goto error;

I think you should add a "report(0, ...)" or report_abort() in front of all 
three gotos above - otherwise the problems might go unnoticed.

> @@ -97,7 +106,7 @@ static void test_sense(void)
>   	if (ret < 0) {
>   		report_info("no valid residual count");
>   	} else if (ret != 0) {
> -		len = sizeof(senseid) - ret;
> +		len = sizeof(*senseid) - ret;
>   		if (ret && len < CSS_SENSEID_COMMON_LEN) {
>   			report(0, "transferred a too short length: %d", ret);
>   			goto error;
> @@ -105,21 +114,25 @@ static void test_sense(void)
>   			report_info("transferred a shorter length: %d", len);
>   	}
>   
> -	if (senseid.reserved != 0xff) {
> -		report(0, "transferred garbage: 0x%02x", senseid.reserved);
> +	if (senseid->reserved != 0xff) {
> +		report(0, "transferred garbage: 0x%02x", senseid->reserved);
>   		goto error;
>   	}
>   
>   	report_prefix_pop();
>   
>   	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
> -		    senseid.reserved, senseid.cu_type, senseid.cu_model,
> -		    senseid.dev_type, senseid.dev_model);
> +		    senseid->reserved, senseid->cu_type, senseid->cu_model,
> +		    senseid->dev_type, senseid->dev_model);
>   
> -	report(senseid.cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
> -	       (uint16_t) cu_type, senseid.cu_type);
> +	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
> +	       (uint16_t) cu_type, senseid->cu_type);
>   
>   error:
> +	free_io_page(ccw);
> +error_ccw:
> +	free_io_page(senseid);
> +error_senseid:
>   	unregister_io_int_func(css_irq_io);
>   }
>   
> 

  Thomas

