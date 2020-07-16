Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A611221ED5
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgGPIrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 04:47:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54665 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726332AbgGPIrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 04:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594889226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=bRGA0Q+UclbwdgBkfmYT8NDUVsoq4uGQ9cVIJMesGxU=;
        b=Za63wpEQCcN0PyLUUsJuHLyuPkfHT141/GnRXOflXmVL0YbpcWyxkDUocr6ZquGQYd0OSw
        01ypNU8KiN3O+CzVRI84fKpNDsaf5OopXxbthpH6AebpEVc3K6LrCqN6ACyt4autfOcd2K
        A2Opbpo9mb0Fjw/0UThIS1rqMLtkPtM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-5dj8blDzNCGUJCo5B-0v-w-1; Thu, 16 Jul 2020 04:47:04 -0400
X-MC-Unique: 5dj8blDzNCGUJCo5B-0v-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A23331085;
        Thu, 16 Jul 2020 08:47:03 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BFAB78482;
        Thu, 16 Jul 2020 08:46:58 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v13 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, drjones@redhat.com
References: <1594887809-10521-1-git-send-email-pmorel@linux.ibm.com>
 <1594887809-10521-10-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d60336e9-9038-89b3-f1d6-82c9ee4b3aaa@redhat.com>
Date:   Thu, 16 Jul 2020 10:46:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1594887809-10521-10-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/2020 10.23, Pierre Morel wrote:
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

I still think this would look nicer without gotos. Anyway,

Acked-by: Thomas Huth <thuth@redhat.com>

