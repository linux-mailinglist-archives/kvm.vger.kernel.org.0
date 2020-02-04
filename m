Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4D151A5A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 13:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgBDMLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 07:11:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51071 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727097AbgBDMLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 07:11:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580818279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aGaLcN1NuPtrJD4/Yv84mAID3PPqbNw6pOiPY4XCA7I=;
        b=IA5OWq1Fqx1Sd55BEKZ/qz2Yg0hcDMaEbYOm0kTzh34p8jThoBYi1GYSmuRoGEQkhqBIza
        Gkx4WtTOHP6CX9Dx1Y18UDJbD3M9BhzLhj/IXiGlGP5Lc24sWsgWD4XPge7zCFN1wjpMQY
        ucTLQytIdQmDv3YpSvJVosVS4D0Ljg0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-hNPdstVBPeaOqM-d7ddV2A-1; Tue, 04 Feb 2020 07:11:15 -0500
X-MC-Unique: hNPdstVBPeaOqM-d7ddV2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 274A08010CB;
        Tue,  4 Feb 2020 12:11:14 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FAA61BC6D;
        Tue,  4 Feb 2020 12:11:09 +0000 (UTC)
Date:   Tue, 4 Feb 2020 13:11:07 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 07/37] KVM: s390: add new variants of UV CALL
Message-ID: <20200204131107.6c7b3dae.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-8-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-8-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:27 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

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
> ---
>  arch/s390/include/asm/uv.h | 58 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 4eaea95f5c64..3448f12ef57a 100644
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
> @@ -92,6 +93,18 @@ struct uv_cb_cfs {
>  	u64 paddr;
>  } __packed __aligned(8);
>  
> +/*
> + * A common UV call struct for the following calls:

"for calls that take no payload"?

In case there will be more of them in the future :)

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
> @@ -99,6 +112,31 @@ struct uv_cb_share {
>  	u64 reserved28;
>  } __packed __aligned(8);
>  
> +/*
> + * Low level uv_call that takes r1 and r2 as parameter and avoids
> + * stalls for long running busy conditions by doing schedule

This can only ever return 0 or 1, right?

> + */
> +static inline int uv_call_sched(unsigned long r1, unsigned long r2)
> +{
> +	int cc = 3;
> +
> +	while (cc > 1) {
> +		asm volatile(
> +			"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> +			"		ipm	%[cc]\n"
> +			"		srl	%[cc],28\n"
> +			: [cc] "=d" (cc)
> +			: [r1] "a" (r1), [r2] "a" (r2)
> +			: "memory", "cc");
> +		if (need_resched())
> +			schedule();
> +	}
> +	return cc;
> +}
> +
> +/*
> + * Low level uv_call that takes r1 and r2 as parameter
> + */
>  static inline int uv_call(unsigned long r1, unsigned long r2)
>  {
>  	int cc;
> @@ -114,6 +152,26 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>  	return cc;
>  }
>  
> +/*
> + * special variant of uv_call that only transport the cpu or guest

s/transport/transports/

> + * handle and the command, like destroy or verify.
> + */
> +static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret)
> +{
> +	int rc;
> +	struct uv_cb_nodata uvcb = {
> +		.header.cmd = cmd,
> +		.header.len = sizeof(uvcb),
> +		.handle = handle,
> +	};
> +
> +	WARN(!handle, "No handle provided to Ultravisor call cmd %x\n", cmd);

Just return -EINVAL for !handle?

> +	rc = uv_call_sched(0, (u64)&uvcb);
> +	if (ret)
> +		*ret = *(u32 *)&uvcb.header.rc;

Does that rc value in the block contain anything sensible if you didn't
get cc==0?

> +	return rc ? -EINVAL : 0;
> +}
> +
>  struct uv_info {
>  	unsigned long inst_calls_list[4];
>  	unsigned long uv_base_stor_len;

