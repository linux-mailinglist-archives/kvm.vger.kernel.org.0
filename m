Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234081E29C5
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 20:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgEZSLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 14:11:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727112AbgEZSLI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 14:11:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590516667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=GeKr05eU6LC0bzH+Uv5c1Xlvssxs0fTf4/hmCopeS5E=;
        b=T+mr9+hyzI+1BCgVbqgEdg0YehpomhoTrqK/e5XmU0q+uZYMqeV7XXrweECL/iEqm7I3WP
        e4xk/ITU3V+XniZ/CkRKCP4LG4lrQeUzyTymEBIVCkD+7z5V54e0PXzYr/MYiMsorxQ2BD
        EvH9oLolSlCsaI7H5CBa6NfXKywaORw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-Y3O1d_HoPvaYbS2EX83Q7w-1; Tue, 26 May 2020 14:11:02 -0400
X-MC-Unique: Y3O1d_HoPvaYbS2EX83Q7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A3DB800688;
        Tue, 26 May 2020 18:11:01 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-8.ams2.redhat.com [10.36.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 088656ED98;
        Tue, 26 May 2020 18:10:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 05/12] s390x: export the clock
 get_clock_ms() utility
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-6-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <80ccd983-df12-a6ee-239e-b367ebc9dded@redhat.com>
Date:   Tue, 26 May 2020 20:10:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1589818051-20549-6-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/2020 18.07, Pierre Morel wrote:
> To serve multiple times, the function get_clock_ms() is moved
> from intercept.c test to the new file asm/time.h.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/asm/time.h | 26 ++++++++++++++++++++++++++
>  s390x/intercept.c    | 11 +----------
>  2 files changed, 27 insertions(+), 10 deletions(-)
>  create mode 100644 lib/s390x/asm/time.h
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> new file mode 100644
> index 0000000..25c7a3c
> --- /dev/null
> +++ b/lib/s390x/asm/time.h
> @@ -0,0 +1,26 @@
> +/*
> + * Clock utilities for s390
> + *
> + * Authors:
> + *  Thomas Huth <thuth@redhat.com>
> + *
> + * Copied from the s390/intercept test by:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +#ifndef _ASM_S390X_TIME_H_
> +#define _ASM_S390X_TIME_H_

Please also remove the underscores at the beginning (and preferably also
at the end) here.

 Thanks,
  Thomas

