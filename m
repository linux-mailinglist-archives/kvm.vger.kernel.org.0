Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035A1116C82
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 12:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfLILtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 06:49:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46654 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727438AbfLILtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 06:49:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575892160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Tbte9ZJpX/i/On2r7macBFFPSxwyvmsLYyUwn1YIzf4=;
        b=EpXSzw7nWBVDBUCGsgpeXndhVNg1IBLag0lMi3fWPrANn/F1/FnFOkq9j8Xd3uqqIQBoIq
        D6Z5K42dbMAWWbHdryvh8syJok+WFs5MrPp99+hCSIpzwqfbmJOYYW3KWHrZcScv/FlC1A
        BLV7bzo2kOyadpiDfB2DiScuDyf/Too=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-mOBd_LcLPaGU4Vig8IQJag-1; Mon, 09 Dec 2019 06:49:16 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF4761005513;
        Mon,  9 Dec 2019 11:49:14 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-121.ams2.redhat.com [10.36.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDE5960BEC;
        Mon,  9 Dec 2019 11:49:10 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 5/9] s390x: Library resources for CSS
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-6-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <66233a15-7cc4-45b5-d930-abbedbd0729d@redhat.com>
Date:   Mon, 9 Dec 2019 12:49:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1575649588-6127-6-git-send-email-pmorel@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: mOBd_LcLPaGU4Vig8IQJag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/2019 17.26, Pierre Morel wrote:
> These are the include and library utilities for the css tests patch
> series.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h      | 259 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/css_dump.c | 156 ++++++++++++++++++++++++++
>  2 files changed, 415 insertions(+)
>  create mode 100644 lib/s390x/css.h
>  create mode 100644 lib/s390x/css_dump.c
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> new file mode 100644
> index 0000000..6f19bb5
> --- /dev/null
> +++ b/lib/s390x/css.h
[...]
> +/* Debug functions */
> +char *dump_pmcw_flags(uint16_t f);
> +char *dump_scsw_flags(uint32_t f);
> +#undef DEBUG
> +#ifdef DEBUG
> +void dump_scsw(struct scsw *);
> +void dump_irb(struct irb *irbp);
> +void dump_schib(struct schib *sch);
> +struct ccw *dump_ccw(struct ccw *cp);
> +#else
> +static inline void dump_scsw(struct scsw *scsw) {}
> +static inline void dump_irb(struct irb *irbp) {}
> +static inline void dump_pmcw(struct pmcw *p) {}
> +static inline void dump_schib(struct schib *sch) {}
> +static inline void dump_orb(struct orb *op) {}
> +static inline struct ccw *dump_ccw(struct ccw *cp)
> +{
> +	return NULL;
> +}
> +#endif

I'd prefer to not have a "#undef DEBUG" (or "#define DEBUG") statement
in the header here - it could trigger unexpected behavior with other
files that also use a DEBUG macro.

Could you please declare the prototypes here and move the "#else" part
to the .c file instead? Thanks!

 Thomas

