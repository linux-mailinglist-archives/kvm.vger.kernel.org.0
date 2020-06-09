Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD271F35FE
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 10:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgFIIPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 04:15:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54083 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727888AbgFIIPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 04:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591690545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=2H1cEu11xRZi20T3bItzRnWAM0EXJANfv0M4dLM3/rM=;
        b=cn0g4jsvooqYUBDXjrC6aA9Kn/d4E8sqb7xM0FAU9+u3NA8THr2sz3J98JQRyspxjW8paD
        pSMgmmthjiJfKQ0oNaz3jUon7K9tYW6em2aimpcL+zh3jopyFmKJRNfzt/gNUKl5SRG6Ou
        kwsoMkfFqSdoa9C7QYHeGHfNHn0hFMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-bLPwCHAKMBCuQY_kS0cI5g-1; Tue, 09 Jun 2020 04:15:41 -0400
X-MC-Unique: bLPwCHAKMBCuQY_kS0cI5g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3D7F100A8F1;
        Tue,  9 Jun 2020 08:15:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 887635D9C9;
        Tue,  9 Jun 2020 08:15:36 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 12/12] s390x: css: ssch/tsch with sense
 and interrupt
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-13-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <bfae9aa6-5802-dd24-a59f-75291cd5f67a@redhat.com>
Date:   Tue, 9 Jun 2020 10:15:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1591603981-16879-13-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 10.13, Pierre Morel wrote:
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
>  lib/s390x/css.h     |  20 ++++++
>  lib/s390x/css_lib.c |  46 ++++++++++++++
>  s390x/css.c         | 149 +++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 214 insertions(+), 1 deletion(-)
[...]
> +}
> diff --git a/s390x/css.c b/s390x/css.c
> index 6f58d4a..79c997d 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -16,10 +16,26 @@
>  #include <string.h>
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
> +#include <kernel-args.h>
>  
>  #include <css.h>
>  
> +#define DEFAULT_CU_TYPE		0x3832
> +static unsigned long cu_type = DEFAULT_CU_TYPE;
> +
> +struct lowcore *lowcore = (void *)0x0;
> +
>  static int test_device_sid;
> +static struct irb irb;
> +static struct senseid senseid;
> +
> +static void set_io_irq_subclass_mask(uint64_t const new_mask)
> +{
> +	asm volatile (
> +		"lctlg %%c6, %%c6, %[source]\n"
> +		: /* No outputs */
> +		: [source] "R" (new_mask));

I think the "R" constraint is wrong here - this instruction does not use
an index register. "Q" is likely the better choice. But it might be
easier to use the lctlg() wrapper from lib/s390x/asm/arch_def.h instead.

[...]
> +
> +	report((senseid.cu_type == cu_type),

Please drop the innermost parentheses here.

> +	       "cu_type: expect 0x%04x got 0x%04x",
> +	       (uint16_t) cu_type, senseid.cu_type);
> +
> +unreg_cb:
> +	unregister_io_int_func(irq_io);
> +}

 Thomas

