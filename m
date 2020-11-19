Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F347E2B8E84
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 10:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgKSJQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 04:16:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbgKSJQE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 04:16:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605777363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zRD5uSUHFbJ/7pmDNZtf1aSvfpbfTAex7AeYjeEcSRQ=;
        b=AUAmItuPZoIgwQDCeALmIveCOH5y5dD6tiTo0WfdQsLlWzQIGEKAPipLIy9rfNP+kzgXwt
        HALG6anAgXftEw4vL1weaEjDQEDUxDTB8jZ1dLRJRH1XNoYQZEu1X0BwmMc11JJtvcqoH/
        U5AekEL1U9P+mwRV56jeFZEkMwzoxlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-Hnr2kFZINleFYCfblVYGZw-1; Thu, 19 Nov 2020 04:15:59 -0500
X-MC-Unique: Hnr2kFZINleFYCfblVYGZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 589B6835DE0;
        Thu, 19 Nov 2020 09:15:58 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DDC15D6A8;
        Thu, 19 Nov 2020 09:15:52 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 3/5] s390x: SCLP feature checking
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20201117154215.45855-1-frankja@linux.ibm.com>
 <20201117154215.45855-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e9845ca1-96ac-23b8-5136-7a6916fb1b92@redhat.com>
Date:   Thu, 19 Nov 2020 10:15:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201117154215.45855-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/11/2020 16.42, Janosch Frank wrote:
> Availability of SIE is announced via a feature bit in a SCLP info CPU
> entry. Let's add a framework that allows us to easily check for such
> facilities.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 19 +++++++++++++++++++
>  lib/s390x/sclp.h | 15 +++++++++++++++
>  3 files changed, 35 insertions(+)
[...]
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 6620531..bcc9f4b 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -101,6 +101,20 @@ typedef struct CPUEntry {
>      uint8_t reserved1;
>  } __attribute__((packed)) CPUEntry;
>  
> +extern struct sclp_facilities sclp_facilities;
> +
> +struct sclp_facilities {
> +	u64 has_sief2 : 1;
> +};
> +
> +/*
> + * test_bit() uses unsigned long ptrs so we give it the ptr to the
> + * address member and offset bits by 1> + */
> +enum sclp_cpu_feature_bit {
> +	SCLP_CPU_FEATURE_SIEF2_BIT = 16 + 4,
> +};

That's kind of ugly ... why don't you simply replace the CPUEntry.features[]
array with a bitfield, similar to what the kernel does with "struct
sclp_core_entry" ?

 Thomas


