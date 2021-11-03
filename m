Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8671443DB2
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhKCHc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:32:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231985AbhKCHcZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 03:32:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635924589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CQ7RwctJaPB30k0BVCJlm2BF8i4qZ47433hS6BmU8nU=;
        b=MankySAiWuX6r33T/feWmOUOz91VklIJxEq0xTKgGT9PkVhQyyGIzenxZHDbgg5jbzGSzT
        ftEfTW0AWqKB+QNl8eecQm6suZoJzEdoLrTHfJZZuWVy/vMqtqRvwGvTKD8GX/BsqHRPbZ
        FollA+LLphRTq+2gK1C/0fKTqaXiVjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-lcCObUt3NNemnkOBx2Kkjw-1; Wed, 03 Nov 2021 03:29:46 -0400
X-MC-Unique: lcCObUt3NNemnkOBx2Kkjw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68B3D19057A6;
        Wed,  3 Nov 2021 07:29:45 +0000 (UTC)
Received: from [10.39.192.84] (unknown [10.39.192.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95BDF5D9DE;
        Wed,  3 Nov 2021 07:29:43 +0000 (UTC)
Message-ID: <e880646b-4fba-c363-7387-b96b3acdf13d@redhat.com>
Date:   Wed, 3 Nov 2021 08:29:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 2/7] s390x: css: add callback for
 emnumeration
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-3-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <1630059440-15586-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/2021 12.17, Pierre Morel wrote:
> We will need to look for a device inside the channel subsystem
> based upon device specificities.
> 
> Let's provide a callback for an upper layer to be called during
> the enumeration of the channel subsystem.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h     | 3 ++-
>   lib/s390x/css_lib.c | 4 +++-
>   s390x/css.c         | 2 +-
>   3 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index d644971f..2005f4d7 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -278,7 +278,8 @@ void dump_irb(struct irb *irbp);
>   void dump_pmcw(struct pmcw *p);
>   void dump_orb(struct orb *op);
>   
> -int css_enumerate(void);
> +typedef int (enumerate_cb_t)(int);
> +int css_enumerate(enumerate_cb_t *f);
>   #define MAX_ENABLE_RETRIES      5
>   
>   #define IO_SCH_ISC      3
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index efc70576..484f9c41 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -117,7 +117,7 @@ bool get_chsc_scsc(void)
>    * On success return the first subchannel ID found.
>    * On error return an invalid subchannel ID containing cc
>    */
> -int css_enumerate(void)
> +int css_enumerate(enumerate_cb_t *f)

I'd maybe call it "cb" instead of "f" ... but that's just my personal taste, 
I guess.

>   {
>   	struct pmcw *pmcw = &schib.pmcw;
>   	int scn_found = 0;
> @@ -153,6 +153,8 @@ int css_enumerate(void)
>   			schid = scn | SCHID_ONE;
>   		report_info("Found subchannel %08x", scn | SCHID_ONE);
>   		dev_found++;
> +		if (f)
> +			f(scn | SCHID_ONE);
>   	}
>   
>   out:
> diff --git a/s390x/css.c b/s390x/css.c
> index c340c539..b50fbc67 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -29,7 +29,7 @@ struct ccw1 *ccw;
>   
>   static void test_enumerate(void)
>   {
> -	test_device_sid = css_enumerate();
> +	test_device_sid = css_enumerate(NULL);
>   	if (test_device_sid & SCHID_ONE) {
>   		report(1, "Schid of first I/O device: 0x%08x", test_device_sid);
>   		return;
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

