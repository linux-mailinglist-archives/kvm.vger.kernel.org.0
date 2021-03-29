Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC7934C831
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 10:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhC2IUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 04:20:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233263AbhC2IUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 04:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617006000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=geY4WOZBZrtvFZL1EED3oLoJjZ1WyL5k6uL4wJ/IXSo=;
        b=A1Ae3+7Atobh6jQZgblpskwt9MQ8vgAz3VLLXdjs3SX4V4qWyZq6ffr4VB4Ww953n007ue
        93TZzJYtspKa93lsQJQwo8Ykhjny2pr07QU+rXKWEAuU+K/r65Bhbitb9bgDZxmk5D/ygd
        bD5TwkYDFeJCCA36ziuTVQaV1WAn3N8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-JoeqiOSfPIW2zJlZamQNgA-1; Mon, 29 Mar 2021 04:19:58 -0400
X-MC-Unique: JoeqiOSfPIW2zJlZamQNgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B7898189C7;
        Mon, 29 Mar 2021 08:19:57 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2BC35D9D3;
        Mon, 29 Mar 2021 08:19:51 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x: css: simplify skipping tests
 on no device
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <5caf129d-08e9-0efa-5110-9330ac856eff@redhat.com>
Date:   Mon, 29 Mar 2021 10:19:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/2021 10.39, Pierre Morel wrote:
> We will lhave to test if a device is present for every tests
> in the future.
> Let's provide a macro to check if the device is present and
> to skip the tests if it is not.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   s390x/css.c | 27 +++++++++++----------------
>   1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index c340c53..16723f6 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -27,6 +27,13 @@ static int test_device_sid;
>   static struct senseid *senseid;
>   struct ccw1 *ccw;
>   
> +#define NODEV_SKIP(dev) do {						\
> +				if (!(dev)) {				\
> +					report_skip("No device");	\
> +					return;				\
> +				}					\
> +			} while (0)
> +
>   static void test_enumerate(void)
>   {
>   	test_device_sid = css_enumerate();
> @@ -41,10 +48,7 @@ static void test_enable(void)
>   {
>   	int cc;
>   
> -	if (!test_device_sid) {
> -		report_skip("No device");
> -		return;
> -	}
> +	NODEV_SKIP(test_device_sid);
>   
>   	cc = css_enable(test_device_sid, IO_SCH_ISC);
>   
> @@ -62,10 +66,7 @@ static void test_sense(void)
>   	int ret;
>   	int len;
>   
> -	if (!test_device_sid) {
> -		report_skip("No device");
> -		return;
> -	}
> +	NODEV_SKIP(test_device_sid);
>   
>   	ret = css_enable(test_device_sid, IO_SCH_ISC);
>   	if (ret) {
> @@ -218,10 +219,7 @@ static void test_schm_fmt0(void)
>   	struct measurement_block_format0 *mb0;
>   	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
>   
> -	if (!test_device_sid) {
> -		report_skip("No device");
> -		return;
> -	}
> +	NODEV_SKIP(test_device_sid);
>   
>   	/* Allocate zeroed Measurement block */
>   	mb0 = alloc_io_mem(shared_mb_size, 0);
> @@ -289,10 +287,7 @@ static void test_schm_fmt1(void)
>   {
>   	struct measurement_block_format1 *mb1;
>   
> -	if (!test_device_sid) {
> -		report_skip("No device");
> -		return;
> -	}
> +	NODEV_SKIP(test_device_sid);
>   
>   	if (!css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
>   		report_skip("Extended measurement block not available");
> 

I wonder whether it would be easier to simply skip all tests in main() if 
the test device is not available, instead of checking it again and again and 
again...?

  Thomas

