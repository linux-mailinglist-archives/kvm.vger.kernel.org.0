Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2878030C7DB
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhBBRdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:33:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236512AbhBBRb3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:31:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612287004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPZ3creScpQEExnhVsJILHItpjZC6SwU5BrqG5rqdx8=;
        b=YNYRMSmCL76b2QiOdrgybfjDdU+M3UDKpVNBB1WL1mTG87Mxgcqhn5W7jxyercGDvWkiZl
        yF5IuujdOtaADnw/ctfbMAkUN+H8NPyD8rr/VAjhv/k4icrIcrikt7Nn8vcx3wLdLRExkG
        Cq3qyJ8l0WTJQrydwrG6jPMoOjYhfyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-P3WC4TVFMqyXTD9L0qakVA-1; Tue, 02 Feb 2021 12:29:59 -0500
X-MC-Unique: P3WC4TVFMqyXTD9L0qakVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C48A10066FE;
        Tue,  2 Feb 2021 17:29:50 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-112.ams2.redhat.com [10.36.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65D9960C5F;
        Tue,  2 Feb 2021 17:29:48 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 2/5] s390x: css: simplifications of the
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-3-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <daf7ef77-98fc-3e29-d753-78b933a494d5@redhat.com>
Date:   Tue, 2 Feb 2021 18:29:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611930869-25745-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/2021 15.34, Pierre Morel wrote:
> In order to ease the writing of tests based on:
> - interrupt
> - enabling a subchannel
> - using multiple I/O on a channel without disabling it
> 
> We do the following simplifications:
> - the I/O interrupt handler is registered on CSS initialization
> - We do not enable again a subchannel in senseid if it is already
>    enabled
> - we add a css_enabled() function to test if a subchannel is enabled
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
[...]
> diff --git a/s390x/css.c b/s390x/css.c
> index 18dbf01..230f819 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -56,36 +56,27 @@ static void test_enable(void)
>    * - We need the test device as the first recognized
>    *   device by the enumeration.
>    */
> -static void test_sense(void)
> +static bool do_test_sense(void)
>   {
>   	struct ccw1 *ccw;
> +	bool retval = false;
>   	int ret;
>   	int len;
>   
>   	if (!test_device_sid) {
>   		report_skip("No device");
> -		return;
> +		return retval;
>   	}
>   
> -	ret = css_enable(test_device_sid, IO_SCH_ISC);
> -	if (ret) {
> -		report(0, "Could not enable the subchannel: %08x",
> -		       test_device_sid);
> -		return;
> +	if (!css_enabled(test_device_sid)) {
> +		report(0, "enabled subchannel: %08x", test_device_sid);
> +		return retval;
>   	}
>   
> -	ret = register_io_int_func(css_irq_io);
> -	if (ret) {
> -		report(0, "Could not register IRQ handler");
> -		return;
> -	}
> -
> -	lowcore_ptr->io_int_param = 0;
> -
>   	senseid = alloc_io_mem(sizeof(*senseid), 0);
>   	if (!senseid) {
>   		report(0, "Allocation of senseid");
> -		goto error_senseid;
> +		return retval;
>   	}
>   
>   	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
> @@ -129,16 +120,21 @@ static void test_sense(void)
>   	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
>   		    senseid->reserved, senseid->cu_type, senseid->cu_model,
>   		    senseid->dev_type, senseid->dev_model);
> +	report_info("cu_type expected 0x%04x got 0x%04x", (uint16_t)cu_type,
> +		    senseid->cu_type);
>   
> -	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
> -	       (uint16_t)cu_type, senseid->cu_type);
> +	retval = senseid->cu_type == cu_type;
>   
>   error:
>   	free_io_mem(ccw, sizeof(*ccw));
>   error_ccw:
>   	free_io_mem(senseid, sizeof(*senseid));
> -error_senseid:
> -	unregister_io_int_func(css_irq_io);
> +	return retval;
> +}

Maybe use "success" as a name for the variable instead of "retval"? ... 
since it's a boolean value...

  Thomas

