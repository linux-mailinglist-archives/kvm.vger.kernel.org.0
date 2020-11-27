Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB762C6755
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 15:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbgK0N7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 08:59:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729913AbgK0N7R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 08:59:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606485555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JZS1ZR/K0GaVEwHxac0n2j4gAmwkKCDQwBnR0/v76y8=;
        b=UTZFSLU8djQmtWN1YlVPOjwCjVostsCsHhSa5/1WZN2AsBtGuTZJbBP8+ny+TAlJqj060u
        VzpQNqOzOwR7sQ5zJEOtclglyNLV5uI01A4igxTGgRDGPXb89y7WCh6FFb/nDm8e8mgM69
        Yg1X/w4FhbYB7M8eZAwD/I/IPUkeDdQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-5Z5e8iiDPp6I6ZUt45fXjw-1; Fri, 27 Nov 2020 08:59:11 -0500
X-MC-Unique: 5Z5e8iiDPp6I6ZUt45fXjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAFF2809DD4;
        Fri, 27 Nov 2020 13:59:10 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-70.ams2.redhat.com [10.36.113.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB47860BF1;
        Fri, 27 Nov 2020 13:59:05 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/7] s390x: Consolidate sclp read info
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201127130629.120469-1-frankja@linux.ibm.com>
 <20201127130629.120469-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <491a5e03-5c07-97a4-e8e3-99ea97b681b2@redhat.com>
Date:   Fri, 27 Nov 2020 14:59:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201127130629.120469-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/11/2020 14.06, Janosch Frank wrote:
> Let's only read the information once and pass a pointer to it instead
> of calling sclp multiple times.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 29 +++++++++++++++++++++++------
>  lib/s390x/sclp.h |  3 +++
>  lib/s390x/smp.c  | 28 +++++++++++-----------------
>  4 files changed, 38 insertions(+), 23 deletions(-)
...
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 4e2ac18..ff56c44 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -25,6 +25,8 @@ extern unsigned long stacktop;
>  static uint64_t storage_increment_size;
>  static uint64_t max_ram_size;
>  static uint64_t ram_size;
> +char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
> +static ReadInfo *read_info;
>  
>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>  static volatile bool sclp_busy;
> @@ -110,6 +112,22 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
>  	report_abort("READ_SCP_INFO failed");
>  }
>  
> +void sclp_read_info(void)
> +{
> +	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
> +	read_info = (ReadInfo *)_read_info;
> +}
> +
> +int sclp_get_cpu_num(void)
> +{

I forgot to say: Maybe add a

       assert(read_info);

here, just in case? (since we can dereference the NULL pointer in the k-u-t)

> +	return read_info->entries_cpu;
> +}
> +
> +CPUEntry *sclp_get_cpu_entries(void)
> +{

dito.

> +	return (void *)read_info + read_info->offset_cpu;
> +}

 Thomas

