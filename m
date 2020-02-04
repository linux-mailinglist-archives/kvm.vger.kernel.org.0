Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486BD151B4C
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 14:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgBDN2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 08:28:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32957 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727181AbgBDN2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 08:28:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580822882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=MqLa+YfRfjcyNT4R5QG1r6j619M9gnQmBojB2p11C1w=;
        b=HDgXMZjhO4unyBtHzmdG3Zsfzw7per0h+WHUQwDzypp88s9aykCE9Ka7gxPgYbtLTXcBKy
        +geqopAXhqAiUQt1L4yuIHVV8xz4qbNaKnV+9TF05OoOBR0G29Br/VoERFro3U4n4idEIX
        /pFUfw6mqQPfPiJv6RpN8vqrFpJDGBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-3vMc-v0hMY61u1ZBvhYTVw-1; Tue, 04 Feb 2020 08:27:59 -0500
X-MC-Unique: 3vMc-v0hMY61u1ZBvhYTVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E68D1DB2C;
        Tue,  4 Feb 2020 13:27:57 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9727A60BF4;
        Tue,  4 Feb 2020 13:27:53 +0000 (UTC)
Subject: Re: [RFCv2 07/37] KVM: s390: add new variants of UV CALL
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-8-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e2f34580-d853-ce73-b13f-dd2e17179513@redhat.com>
Date:   Tue, 4 Feb 2020 14:27:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-8-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
>=20
> This add 2 new variants of the UV CALL.
>=20
> The first variant handles UV CALLs that might have longer busy
> conditions or just need longer when doing partial completion. We should
> schedule when necessary.
>=20
> The second variant handles UV CALLs that only need the handle but have
> no payload (e.g. destroying a VM). We can provide a simple wrapper for
> those.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 58 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
>=20
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
> =20
> @@ -92,6 +93,18 @@ struct uv_cb_cfs {
>  	u64 paddr;
>  } __packed __aligned(8);
> =20
> +/*
> + * A common UV call struct for the following calls:
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
> =20
> +/*
> + * Low level uv_call that takes r1 and r2 as parameter and avoids
> + * stalls for long running busy conditions by doing schedule
> + */
> +static inline int uv_call_sched(unsigned long r1, unsigned long r2)
> +{
> +	int cc =3D 3;
> +
> +	while (cc > 1) {
> +		asm volatile(
> +			"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> +			"		ipm	%[cc]\n"
> +			"		srl	%[cc],28\n"
> +			: [cc] "=3Dd" (cc)
> +			: [r1] "a" (r1), [r2] "a" (r2)

You could use "d" instead of "a" for both, r1 and r2, here.

> +			: "memory", "cc");
> +		if (need_resched())
> +			schedule();
> +	}

It's a matter of taste, but I'd rather do:

   int cc;
   do {
       ...
   } while (cc > 1);

(i.e. no need to pre-initialize cc with 3)

> +	return cc;
> +}

 Thomas

