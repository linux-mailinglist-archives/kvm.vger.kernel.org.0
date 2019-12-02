Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F26C10EB8E
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 15:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfLBOap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 09:30:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25887 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727435AbfLBOap (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 09:30:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575297044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHLw/CKyF7b4f+/xJD6YQmy6nHy0GIf124zVAzM3X+U=;
        b=AokrjXWPu0oVLojUkXdhfLp5tR73qmuvP7Gt1P9jXKqAUPcgWP2okg2JN54rsKWV/Ygbqw
        /vLt2rr5fTBWxmGQvsixuiH5hLmlvyRfsV8puSEINn5hvo2ByaaJjhIFBocJqquNibpnyB
        V9Vu0K15rbt3Z86u2OSTFZDN2mR7D+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-kCbas5S4PCqKkKg3V3lR_g-1; Mon, 02 Dec 2019 09:30:40 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D829291207;
        Mon,  2 Dec 2019 14:30:38 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FE6167E5F;
        Mon,  2 Dec 2019 14:30:18 +0000 (UTC)
Date:   Mon, 2 Dec 2019 15:30:16 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 7/9] s390x: css: msch, enable test
Message-ID: <20191202153016.382e3fa8.cohuck@redhat.com>
In-Reply-To: <1574945167-29677-8-git-send-email-pmorel@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
        <1574945167-29677-8-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: kCbas5S4PCqKkKg3V3lR_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Nov 2019 13:46:05 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> A second step when testing the channel subsystem is to prepare a channel
> for use.
> 
> This tests the success of the MSCH instruction by enabling a channel.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index 8186f55..e42dc2f 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -62,11 +62,38 @@ static void test_enumerate(void)
>  	return;
>  }
>  
> +static void set_schib(void)
> +{
> +	struct pmcw *p = &schib.pmcw;
> +
> +	p->intparm = 0xdeadbeef;
> +	p->flags |= PMCW_ENABLE;
> +}
> +
> +static void test_enable(void)
> +{
> +	int ret;
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +	set_schib();
> +	dump_schib(&schib);
> +
> +	ret = msch(test_device_sid, &schib);
> +	if (ret)
> +		report("msch cc=%d", 0, ret);

Maybe do a stsch and then check/dump the contents of the schib again?

Background: The architecture allows that msch returns success, but that
the fields modified by the issuer remain unchanged at the subchannel
regardless. That should not happen with QEMU; but I remember versions
of z/VM where we sometimes had to call msch twice to make changes stick.

> +	else
> +		report("Tested", 1);
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

