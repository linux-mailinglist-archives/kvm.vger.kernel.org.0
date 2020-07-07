Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62E6216BE7
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 13:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgGGLo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 07:44:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44168 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbgGGLo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 07:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594122264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bK52xSnGv5KALSSP8RQDYWVeUBeLYys217igIjb+VMw=;
        b=a2w1MLjj5QfY2ufHc6VQZLmjF7i7MfVNBTYcV4KmpC4SFTnkeSSTLjvDfTKONpKq10p0ak
        +cxkbDsPp5ddBLYrYlVBhuUGHVZ4vhc1jl89/fG/DT+D1B6Skt2dbNnADJtfT32IWoAOf0
        YmIy5rYWkBBKB5X+EO7JOt9idfTRPbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-72XByr4aPoWsJqziO5lEag-1; Tue, 07 Jul 2020 07:44:23 -0400
X-MC-Unique: 72XByr4aPoWsJqziO5lEag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31739800D5C;
        Tue,  7 Jul 2020 11:44:22 +0000 (UTC)
Received: from gondolin (ovpn-113-54.ams2.redhat.com [10.36.113.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AF2978521;
        Tue,  7 Jul 2020 11:44:18 +0000 (UTC)
Date:   Tue, 7 Jul 2020 13:44:15 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests v2 PATCH] s390x/cpumodel: The missing DFP
 facility on TCG is expected
Message-ID: <20200707134415.39e47538.cohuck@redhat.com>
In-Reply-To: <20200707104205.25085-1-thuth@redhat.com>
References: <20200707104205.25085-1-thuth@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jul 2020 12:42:05 +0200
Thomas Huth <thuth@redhat.com> wrote:

> When running the kvm-unit-tests with TCG on s390x, the cpumodel test
> always reports the error about the missing DFP (decimal floating point)
> facility. This is kind of expected, since DFP is not required for
> running Linux and thus nobody is really interested in implementing
> this facility in TCG. Thus let's mark this as an expected error instead,
> so that we can run the kvm-unit-tests also with TCG without getting
> test failures that we do not care about.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v2:
>  - Rewrote the logic, introduced expected_tcg_fail flag
>  - Use manufacturer string instead of VM name to detect TCG
> 
>  s390x/cpumodel.c | 49 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 6 deletions(-)

(...)

> +static bool is_tcg(void)
> +{
> +	const char qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
> +	bool ret = false;
> +	uint8_t *buf;
> +
> +	buf = alloc_page();
> +	if (!buf)
> +		return false;
> +
> +	if (stsi(buf, 1, 1, 1)) {
> +		goto out;
> +	}

This does an alloc_page() and a stsi() every time you call it...

> +
> +	/*
> +	 * If the manufacturer string is "QEMU" in EBCDIC, then we are on TCG
> +	 * (otherwise the string is "IBM" in EBCDIC)
> +	 */
> +	if (!memcmp(&buf[32], qemu_ebcdic, sizeof(qemu_ebcdic)))
> +		ret =  true;
> +out:
> +	free_page(buf);
> +	return ret;
> +}
> +
> +
>  int main(void)
>  {
>  	int i;
> @@ -46,11 +81,13 @@ int main(void)
>  
>  	report_prefix_push("dependency");

...so maybe cache the value for is_tcg() here instead of checking
multiple times in the loop?

(Or cache the value in is_tcg().)

>  	for (i = 0; i < ARRAY_SIZE(dep); i++) {
> -		if (test_facility(dep[i][0])) {
> -			report(test_facility(dep[i][1]), "%d implies %d",
> -				dep[i][0], dep[i][1]);
> +		if (test_facility(dep[i].facility)) {
> +			report_xfail(dep[i].expected_tcg_fail && is_tcg(),
> +				     test_facility(dep[i].implied),
> +				     "%d implies %d",
> +				     dep[i].facility, dep[i].implied);
>  		} else {
> -			report_skip("facility %d not present", dep[i][0]);
> +			report_skip("facility %d not present", dep[i].facility);
>  		}
>  	}
>  	report_prefix_pop();

