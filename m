Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0501355424
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 14:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbhDFMog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 08:44:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238486AbhDFMof (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 08:44:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617713066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XAgdQOF6nl4yc6byYEW/k/j0Mm09mAE/VYX0VP8wNZQ=;
        b=JehBWOEwJw6yFVeKPhDYMmGe3UKQE8y5N3hcryniz8JJSKy8j2NF7Tp4DN/Jz48faGwGz9
        zQaWcuDW2PfJgZE8/GoABLCee+TofLHy3xQVcu05uqFWGcRfXvSYFpB50K5zIsuxp+JOWE
        vOjirYZIsWlszPm3fkkrfhg6s7t/vA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-k9HnyphpNAiA5KUwy_4g6A-1; Tue, 06 Apr 2021 08:44:23 -0400
X-MC-Unique: k9HnyphpNAiA5KUwy_4g6A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13F20108EE00;
        Tue,  6 Apr 2021 12:44:13 +0000 (UTC)
Received: from gondolin (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F7C31037E96;
        Tue,  6 Apr 2021 12:44:07 +0000 (UTC)
Date:   Tue, 6 Apr 2021 14:44:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 03/16] s390x: css: simplify skipping
 tests on no device
Message-ID: <20210406144405.09647bb4.cohuck@redhat.com>
In-Reply-To: <1617694853-6881-4-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
        <1617694853-6881-4-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  6 Apr 2021 09:40:40 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We will have to test if a device is present for every tests
> in the future.
> Let's provide separate the first tests from the test loop and
> skip the remaining tests if no device is present.

What about the following patch description:

"We keep adding tests that act upon a concrete device, and we have to
test that a device is present for all of those.

Instead, just skip all of the tests requiring a device if we were not
able to set it up in the first place. The enumeration test will already
have failed in that case."

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 36 ++++++++++++++----------------------
>  1 file changed, 14 insertions(+), 22 deletions(-)
> 

(...)

> @@ -336,8 +316,6 @@ static struct {
>  	void (*func)(void);
>  } tests[] = {
>  	/* The css_init test is needed to initialize the CSS Characteristics */

If you remove the css_init test from this list, the above comment does
not make sense anymore :)

> -	{ "initialize CSS (chsc)", css_init },
> -	{ "enumerate (stsch)", test_enumerate },
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
>  	{ "measurement block (schm)", test_schm },
> @@ -352,11 +330,25 @@ int main(int argc, char *argv[])
>  
>  	report_prefix_push("Channel Subsystem");
>  	enable_io_isc(0x80 >> IO_SCH_ISC);
> +
> +	report_prefix_push("initialize CSS (chsc)");
> +	css_init();
> +	report_prefix_pop();
> +
> +	report_prefix_push("enumerate (stsch)");
> +	test_enumerate();
> +	report_prefix_pop();

Could we maybe have two lists of tests: one that don't require a
device, and one that does?

> +
> +	if (!test_device_sid)
> +		goto end;

In any case, I think we should log an explicit message that we skip the
remaining tests because of no device being available.

> +
>  	for (i = 0; tests[i].name; i++) {
>  		report_prefix_push(tests[i].name);
>  		tests[i].func();
>  		report_prefix_pop();
>  	}
> +
> +end:
>  	report_prefix_pop();
>  
>  	return report_summary();

