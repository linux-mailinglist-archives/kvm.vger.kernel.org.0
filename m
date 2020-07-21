Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBBB22797B
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 09:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgGUH2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 03:28:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46137 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726389AbgGUH2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 03:28:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595316503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=gFYIrP6SxJv4FFWpufQslMRruo20TmAP8n4kSVHQNSY=;
        b=MZcCn3jrBeZvmz33cOM+c4LU+3qkvbUptXbnI3FwpS41Sb+uY3i5m4ZFoPVT1F/h+Fgow3
        IrTx6V6FbR2P1IjzeHfgxxZ64dII3452MjJ9Az7YgtWG5Vt0DZOHY1bPC+NeZTBOJr14TD
        fKZ8wnlktYIYhPMBtceu/CZIQjhww44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-8UAeTKH1P2eBg9EetBxsYQ-1; Tue, 21 Jul 2020 03:28:21 -0400
X-MC-Unique: 8UAeTKH1P2eBg9EetBxsYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF2B8184C5E2;
        Tue, 21 Jul 2020 07:28:19 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-102.ams2.redhat.com [10.36.112.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D2451A888;
        Tue, 21 Jul 2020 07:28:15 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: skrf: Add exception new skey
 test and add test to unittests.cfg
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200717145813.62573-1-frankja@linux.ibm.com>
 <20200717145813.62573-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <78da93f7-118d-2c1d-582a-092232f36108@redhat.com>
Date:   Tue, 21 Jul 2020 09:28:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200717145813.62573-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/2020 16.58, Janosch Frank wrote:
> If a exception new psw mask contains a key a specification exception
> instead of a special operation exception is presented.

I have troubles parsing that sentence... could you write that differently?
(and: "s/a exception/an exception/")

> Let's test
> that.
> 
> Also let's add the test to unittests.cfg so it is run more often.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/skrf.c        | 81 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  2 files changed, 85 insertions(+)
> 
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index 9cae589..9733412 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -15,6 +15,8 @@
>  #include <asm/page.h>
>  #include <asm/facility.h>
>  #include <asm/mem.h>
> +#include <asm/sigp.h>
> +#include <smp.h>
>  
>  static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
>  
> @@ -106,6 +108,84 @@ static void test_tprot(void)
>  	report_prefix_pop();
>  }
>  
> +#include <asm-generic/barrier.h>

Can we keep the #includes at the top of the file, please?

> +static int testflag = 0;
> +
> +static void wait_for_flag(void)
> +{
> +	while (!testflag)
> +		mb();
> +}
> +
> +static void set_flag(int val)
> +{
> +	mb();
> +	testflag = val;
> +	mb();
> +}
> +
> +static void ecall_cleanup(void)
> +{
> +	struct lowcore *lc = (void *)0x0;
> +
> +	lc->ext_new_psw.mask = 0x0000000180000000UL;

Don't we have defines for the PSW values yet?

> +	lc->sw_int_crs[0] = 0x0000000000040000;
> +
> +	/*
> +	 * PGM old contains the ext new PSW, we need to clean it up,
> +	 * so we don't get a special oepration exception on the lpswe

operation

> +	 * of pgm old.
> +	 */
> +	lc->pgm_old_psw.mask = 0x0000000180000000UL;
> +	lc->pgm_old_psw.addr = (unsigned long)wait_for_flag;
> +
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	set_flag(1);
> +}

 Thomas

