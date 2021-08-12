Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BFA3EA4BA
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 14:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbhHLMcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 08:32:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233956AbhHLMcI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 08:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628771502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rnNjIqA1+BUdo8u1KLcdyDhWXb97GWcNWBJ+sfqkX88=;
        b=SxjokamoAeoY00FKOkzE+l3c5zRf+8/MHt11puTDBN4tEjGLlBDaBAZ2UvWsFeIZ2ZbJHZ
        evgv4NUMmuDJm94BUQNwRwX9U6sSBkFCwWBPQKWHONWuIpXzKM1tU2dYqqfmaZvkKhP9I/
        vXddhY6EUKjeH5FBv/3k6ph4AeCa0iw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-_HWWfSCTNbWDPMw18O5p_Q-1; Thu, 12 Aug 2021 08:31:41 -0400
X-MC-Unique: _HWWfSCTNbWDPMw18O5p_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85CBE101F019;
        Thu, 12 Aug 2021 12:31:40 +0000 (UTC)
Received: from localhost (unknown [10.39.193.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2851D60916;
        Thu, 12 Aug 2021 12:31:40 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: css: check the CSS is working
 with any ISC
In-Reply-To: <1628769189-10699-2-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
References: <1628769189-10699-1-git-send-email-pmorel@linux.ibm.com>
 <1628769189-10699-2-git-send-email-pmorel@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 12 Aug 2021 14:31:38 +0200
Message-ID: <87fsvevo7p.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12 2021, Pierre Morel <pmorel@linux.ibm.com> wrote:

> In the previous version we did only check that one ISC dedicated by
> Linux for I/O is working fine.
>
> However, there is no reason to prefer one ISC to another ISC, we are
> free to take anyone.
>
> Let's check all possible ISC to verify that QEMU/KVM is really ISC
> independent.

It's probably a good idea to test for a non-standard isc. Not sure
whether we need all of them, but it doesn't hurt.

Do you also have plans for a test to verify the priority handling for
the different iscs?

>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
>

(...)

> @@ -142,7 +143,6 @@ static void sense_id(void)
>  
>  static void css_init(void)
>  {
> -	assert(register_io_int_func(css_irq_io) == 0);
>  	lowcore_ptr->io_int_param = 0;
>  
>  	report(get_chsc_scsc(), "Store Channel Characteristics");
> @@ -351,11 +351,20 @@ int main(int argc, char *argv[])
>  	int i;
>  
>  	report_prefix_push("Channel Subsystem");
> -	enable_io_isc(0x80 >> IO_SCH_ISC);
> -	for (i = 0; tests[i].name; i++) {
> -		report_prefix_push(tests[i].name);
> -		tests[i].func();
> -		report_prefix_pop();
> +
> +	for (io_isc = 0; io_isc < 8; io_isc++) {
> +		report_info("ISC: %d\n", io_isc);
> +
> +		enable_io_isc(0x80 >> io_isc);
> +		assert(register_io_int_func(css_irq_io) == 0);

Why are you registering/deregistering the irq handler multiple times? It
should be the same, regardless of the isc?

> +
> +		for (i = 0; tests[i].name; i++) {
> +			report_prefix_push(tests[i].name);
> +			tests[i].func();
> +			report_prefix_pop();
> +		}
> +
> +		unregister_io_int_func(css_irq_io);
>  	}
>  	report_prefix_pop();
>  
>

