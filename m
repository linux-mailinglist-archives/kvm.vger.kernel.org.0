Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA7421EF74
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 13:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgGNLiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 07:38:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55629 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725905AbgGNLiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 07:38:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594726699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=1eBjHCzpSjDRY6mPEfoIvr06VG9d2om2O3gPo+8bFxE=;
        b=Moo4U4HLeg/kQhPuLfq22suqv7xB8mBLAYx3R5wZZoKgjAkSrI7Ee6MFOBilntMixO/DXv
        p35t5Nybicd2aY06xZ1sii8jiXwgDq8YvcT45WM+HnfVv3MnVWiV0Frh+bOWEwzv1aIzlC
        BfDmJgZhKp5SqOUYEphASfoYANl2OFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-1-VvKzx-OpiXeoLvLcKybQ-1; Tue, 14 Jul 2020 07:38:18 -0400
X-MC-Unique: 1-VvKzx-OpiXeoLvLcKybQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E47C01080;
        Tue, 14 Jul 2020 11:38:16 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-11.ams2.redhat.com [10.36.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 568CA710A2;
        Tue, 14 Jul 2020 11:38:12 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v12 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, drjones@redhat.com
References: <1594725348-10034-1-git-send-email-pmorel@linux.ibm.com>
 <1594725348-10034-10-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <865cb20f-ac2d-f54a-6613-5d580675eb97@redhat.com>
Date:   Tue, 14 Jul 2020 13:38:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1594725348-10034-10-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/07/2020 13.15, Pierre Morel wrote:
> After a channel is enabled we start a SENSE_ID command using
> the SSCH instruction to recognize the control unit and device.
> 
> This tests the success of SSCH, the I/O interruption and the TSCH
> instructions.
> 
> The SENSE_ID command response is tested to report 0xff inside
> its reserved field and to report the same control unit type
> as the cu_type kernel argument.
> 
> Without the cu_type kernel argument, the test expects a device
> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
[...]
> @@ -102,6 +113,19 @@ struct irb {
>  	uint32_t emw[8];
>  } __attribute__ ((aligned(4)));
>  
> +#define CCW_CMD_SENSE_ID	0xe4
> +#define CSS_SENSEID_COMMON_LEN	8
> +struct senseid {
> +	/* common part */
> +	uint8_t reserved;        /* always 0x'FF' */
> +	uint16_t cu_type;        /* control unit type */
> +	uint8_t cu_model;        /* control unit model */
> +	uint16_t dev_type;       /* device type */
> +	uint8_t dev_model;       /* device model */
> +	uint8_t unused;          /* padding byte */
> +	uint8_t padding[256 - 10]; /* Extra padding for CCW */
> +} __attribute__ ((aligned(4))) __attribute__ ((packed));

Is that padding[256 - 10] right? If I count right, there are only 8
bytes before the padding field, so "10" sounds wrong here?

[...]
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index e47a945..274c293 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
[...]
> +/*
> + * css_residual_count
> + * Return the residual count, if it is valid.
> + *
> + * Return value:
> + * Success: the residual count
> + * Not meaningful: -1 (-1 can not be a valid count)
> + */
> +int css_residual_count(unsigned int schid)
> +{
> +
> +	if (!(irb.scsw.ctrl & (SCSW_SC_PENDING | SCSW_SC_PRIMARY)))
> +		goto invalid;
> +
> +	if (irb.scsw.dev_stat)
> +		if (irb.scsw.sch_stat & ~(SCSW_SCHS_PCI | SCSW_SCHS_IL))
> +			goto invalid;
> +
> +	return irb.scsw.count;
> +
> +invalid:
> +	return -1;
> +}

Cosmetical nit: Unless you want to add something between "invalid:" and
"return -1" later, I'd rather replace "goto invalid" with "return -1"
and get rid of the "invalid" label here.

 Thomas

