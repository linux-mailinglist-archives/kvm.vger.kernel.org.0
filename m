Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535DA216742
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 09:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGGHWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 03:22:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27806 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGHWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 03:22:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594106559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QItpKQI65IOOmTN9ZGrRwmJjuUTo/G8ysVeNWDCnsM=;
        b=gAb24aS1OKHRiQQpffIAt4A6gvHngjulPuzT+kBb8LwaHxJ5ejTGG7n0F6yHeCImgd7Mz4
        p9CwCPRtDQUjNfyghyF54GnnTITaSQcwoQsGWgb5YX0dckubt09KP23s3qJ0YUngWNu2q5
        qis6B/G/moL8kgHkHH3TsYGtbjSNNY8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-zZp69FNVNBe1p5xnUf6gBQ-1; Tue, 07 Jul 2020 03:22:37 -0400
X-MC-Unique: zZp69FNVNBe1p5xnUf6gBQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3C6F1005510;
        Tue,  7 Jul 2020 07:22:36 +0000 (UTC)
Received: from gondolin (ovpn-113-54.ams2.redhat.com [10.36.113.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7679771674;
        Tue,  7 Jul 2020 07:22:32 +0000 (UTC)
Date:   Tue, 7 Jul 2020 09:22:29 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x/cpumodel: The missing DFP facility
 on TCG is expected
Message-ID: <20200707092229.20ca019e.cohuck@redhat.com>
In-Reply-To: <20200707055619.6162-1-thuth@redhat.com>
References: <20200707055619.6162-1-thuth@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jul 2020 07:56:19 +0200
Thomas Huth <thuth@redhat.com> wrote:

> When running the kvm-unit-tests with TCG on s390x, the cpumodel test
> always reports the error about the missing DFP (decimal floating point)
> facility. This is kind of expected, since DFP is not required for
> running Linux and thus nobody is really interested in implementing
> this facility in TCG. Thus let's mark this as an expected error instead,
> so that we can run the kvm-unit-tests also with TCG without getting
> test failures that we do not care about.

Checking for tcg seems reasonable.

> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  s390x/cpumodel.c | 51 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 5d232c6..4310b92 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -11,6 +11,7 @@
>   */
>  
>  #include <asm/facility.h>
> +#include <alloc_page.h>
>  
>  static int dep[][2] = {
>  	/* from SA22-7832-11 4-98 facility indications */
> @@ -38,6 +39,49 @@ static int dep[][2] = {
>  	{ 155,  77 },
>  };
>  
> +/*
> + * A hack to detect TCG (instead of KVM): QEMU uses "TCGguest" as guest
> + * name by default when we are running with TCG (otherwise it's "KVMguest")

The guest name can be overwritten; I think it would be better to check
for something hardcoded.

Maybe the manufacturer name in SYSIB 1.1.1? When running under tcg,
it's always 'QEMU' (it's 'IBM' when running under KVM).

> + */
> +static bool is_tcg(void)
> +{
> +	bool ret = false;
> +	uint8_t *buf;
> +
> +	buf = alloc_page();
> +	if (!buf)
> +		return false;
> +
> +	if (stsi(buf, 3, 2, 2)) {
> +		goto out;
> +	}
> +
> +	/* Does the name start with "TCG" in EBCDIC? */
> +	if (buf[2048] == 0x54 && buf[2049] == 0x43 && buf[2050] == 0x47)
> +		ret = true;
> +
> +out:
> +	free_page(buf);
> +	return ret;
> +}
> +
> +static void check_dependency(int dep1, int dep2)

<bikeshed>
Can we find more speaking parameter names? facility/implied?
</bikeshed>

> +{
> +	if (test_facility(dep1)) {
> +		if (dep1 == 37) {
> +			/* TCG does not have DFP and is unlikely to
> +			 * get it implemented soon. */
> +			report_xfail(is_tcg(), test_facility(dep2),
> +				     "%d implies %d", dep1, dep2);
> +		} else {
> +			report(test_facility(dep2), "%d implies %d",
> +			       dep1, dep2);
> +		}
> +	} else {
> +		report_skip("facility %d not present", dep1);
> +	}
> +}
> +
>  int main(void)
>  {
>  	int i;
> @@ -46,12 +90,7 @@ int main(void)
>  
>  	report_prefix_push("dependency");
>  	for (i = 0; i < ARRAY_SIZE(dep); i++) {
> -		if (test_facility(dep[i][0])) {
> -			report(test_facility(dep[i][1]), "%d implies %d",
> -				dep[i][0], dep[i][1]);
> -		} else {
> -			report_skip("facility %d not present", dep[i][0]);
> -		}
> +		check_dependency(dep[i][0], dep[i][1]);
>  	}
>  	report_prefix_pop();
>  

