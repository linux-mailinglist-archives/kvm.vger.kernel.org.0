Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1450C13B0BE
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 18:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgANRWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 12:22:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34677 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbgANRWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 12:22:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579022538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=sWla06likJvspNcfV7lMmuepmszCna/vPLZSdJm85og=;
        b=cbvy0AOlU93BimDSRRe6ukwcl1V+sNL3cGByUCJlvw6ZX3Q7k1Q5X4ojUUNKZY+FxdRvVe
        aV08XkbE0LR7NfY1c3jxoCPDgmqqgy3g4OtiWu9Bfwk0OG9g5jxYLL3d7vWn5FcEjw2t8O
        7ouTARnUwa8JDyoIb9fOgtkXHzF4WaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-M4_8T6AgMVm_LJeUi-z4iA-1; Tue, 14 Jan 2020 12:22:17 -0500
X-MC-Unique: M4_8T6AgMVm_LJeUi-z4iA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F35C118543B1;
        Tue, 14 Jan 2020 17:22:15 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.36.118.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37DF4675AE;
        Tue, 14 Jan 2020 17:22:11 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 4/4] s390x: smp: Dirty fpc before initial
 reset test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200114153054.77082-1-frankja@linux.ibm.com>
 <20200114153054.77082-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3a68f0fd-4d62-1487-9896-7398b0e12df0@redhat.com>
Date:   Tue, 14 Jan 2020 18:22:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114153054.77082-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2020 16.30, Janosch Frank wrote:
> Let's dirty the fpc, before we test if the initial reset sets it to 0.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 11ab425..cd32342 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -177,6 +177,9 @@ static void test_emcall(void)
>  
>  static void test_func_initial(void)
>  {
> +	asm volatile(
> +		"	sfpc	%0\n"
> +		: : "d" (0x11) : );
>  	lctlg(1, 0x42000UL);
>  	lctlg(7, 0x43000UL);
>  	lctlg(13, 0x44000UL);
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

