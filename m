Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDB52DCEE4
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 10:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgLQJyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 04:54:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727810AbgLQJyw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 04:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608198806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=slGT5K33RN/QdR07Hge0DUcVRdIqX6nwhSDJgyel27c=;
        b=M6Ls09BAPrirtjsPP/Cyr6RXeM9N/T/maw6jIoKH+u6uVsUPgJU17KOiWF7naG6ZGBDk02
        IClZMsDcxzqkjd/NyP73raQlcqn3dHqwopXXHsnGeirfjpWBmmssVkfI5O0FhLdu05Bd97
        jk6grFasOS7TszPI+NKVvdCakaa/1/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-qwI3ZRjNMji_bdrL_8sHXg-1; Thu, 17 Dec 2020 04:53:24 -0500
X-MC-Unique: qwI3ZRjNMji_bdrL_8sHXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9534801B21;
        Thu, 17 Dec 2020 09:53:22 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-175.ams2.redhat.com [10.36.112.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B95717577;
        Thu, 17 Dec 2020 09:53:17 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 7/8] s390x: Add diag318 intercept test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-8-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <4f689585-ae2e-4632-9055-f2332d9f7751@redhat.com>
Date:   Thu, 17 Dec 2020 10:53:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201211100039.63597-8-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/2020 11.00, Janosch Frank wrote:
> Not much to test except for the privilege and specification
> exceptions.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/sclp.c  |  2 ++
>  lib/s390x/sclp.h  |  6 +++++-
>  s390x/intercept.c | 19 +++++++++++++++++++
>  3 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index cf6ea7c..0001993 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -138,6 +138,8 @@ void sclp_facilities_setup(void)
>  
>  	assert(read_info);
>  
> +	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
> +
>  	cpu = (void *)read_info + read_info->offset_cpu;
>  	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>  		if (cpu->address == cpu0_addr) {
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 6c86037..58f8e54 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -105,7 +105,8 @@ extern struct sclp_facilities sclp_facilities;
>  
>  struct sclp_facilities {
>  	uint64_t has_sief2 : 1;
> -	uint64_t : 63;
> +	uint64_t has_diag318 : 1;
> +	uint64_t : 62;
>  };
>  
>  typedef struct ReadInfo {
> @@ -130,6 +131,9 @@ typedef struct ReadInfo {
>      uint16_t highest_cpu;
>      uint8_t  _reserved5[124 - 122];     /* 122-123 */
>      uint32_t hmfai;
> +    uint8_t reserved7[134 - 128];
> +    uint8_t byte_134_diag318 : 1;
> +    uint8_t : 7;
>      struct CPUEntry entries[0];

... the entries[] array can be moved around here without any further ado?
Looks confusing to me. Should there be a CPUEntry array here at all, or only
in ReadCpuInfo?

>  } __attribute__((packed)) ReadInfo;
>  

 Thomas

