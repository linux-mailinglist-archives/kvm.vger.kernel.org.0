Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7B41559AA
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 15:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgBGOep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 09:34:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20244 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726867AbgBGOep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 09:34:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581086082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=XGlHftD4p0/1OUISque/2SdzSbPsHuEO8pdtrMcZxgw=;
        b=CnTRfGohPgJMMzDPl6wPty5z+Id0aqAMVpUwfgp+Rrt6MnjcofDiB/4AMKh/y1kxM+01yF
        DT7n4TR5h4nL208Jv3Diuz8sS3SnLZIcTzU2W4AfzaThByRgKmcX8dSkzXoM0WjVt2ONZe
        2bbOLKX9M0vHNTxPjdwo66JT5akxPY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-EFhHva6sPI602H4eKnrcWQ-1; Fri, 07 Feb 2020 09:34:40 -0500
X-MC-Unique: EFhHva6sPI602H4eKnrcWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81959DBCE;
        Fri,  7 Feb 2020 14:34:38 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-143.ams2.redhat.com [10.36.116.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10A8C790FC;
        Fri,  7 Feb 2020 14:34:32 +0000 (UTC)
Subject: Re: [PATCH 07/35] KVM: s390: add new variants of UV CALL
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-8-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e387472b-4417-9079-2df2-8f6f1689093e@redhat.com>
Date:   Fri, 7 Feb 2020 15:34:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-8-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> This add 2 new variants of the UV CALL.
> 
> The first variant handles UV CALLs that might have longer busy
> conditions or just need longer when doing partial completion. We should
> schedule when necessary.
> 
> The second variant handles UV CALLs that only need the handle but have
> no payload (e.g. destroying a VM). We can provide a simple wrapper for
> those.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 59 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 1b97230a57ba..e1cef772fde1 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -14,6 +14,7 @@
>  #include <linux/types.h>
>  #include <linux/errno.h>
>  #include <linux/bug.h>
> +#include <linux/sched.h>
>  #include <asm/page.h>
>  #include <asm/gmap.h>
>  
> @@ -91,6 +92,19 @@ struct uv_cb_cfs {
>  	u64 paddr;
>  } __packed __aligned(8);
>  
> +/*
> + * A common UV call struct for calls that take no payload
> + * Examples:
> + * Destroy cpu/config
> + * Verify
> + */
> +struct uv_cb_nodata {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 handle;
> +	u64 reserved20[4];
> +} __packed __aligned(8);
> +
>  struct uv_cb_share {
>  	struct uv_cb_header header;
>  	u64 reserved08[3];
> @@ -98,6 +112,31 @@ struct uv_cb_share {
>  	u64 reserved28;
>  } __packed __aligned(8);
>  
> +/*
> + * Low level uv_call that takes r1 and r2 as parameter and avoids
> + * stalls for long running busy conditions by doing schedule
> + */
> +static inline int uv_call_sched(unsigned long r1, unsigned long r2)
> +{
> +	int cc;
> +
> +	do {
> +		asm volatile(
> +			"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> +			"		ipm	%[cc]\n"
> +			"		srl	%[cc],28\n"

Maybe remove one TAB before "ipm" and "srl" ?

Apart from that, patch looks fine to me now.

Reviewed-by: Thomas Huth <thuth@redhat.com>

