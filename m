Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F20422EBF5
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 14:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgG0MUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 08:20:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43749 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727088AbgG0MUv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 08:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595852450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=iauMB52mqXOIqXTYfmHeVxFCv5nckIDI3t6Hqn0OjUI=;
        b=HAmXK0ypgHgujjOat3f2xloEd/o+bDXWUNWRZkucvmkFYDEB7MHlcphoE2CnAV6h04uPIQ
        wmpVyloXgh1uoxcbLEtwWYHyOgLUCGbXPbhPVhWMECFBivdg43ap0PhbkCTrydOTxII2dk
        xuYn2SZjhLH7uNN3Z00OJZdwBYRgqBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-oS3ABpabNACmXxhTn-uoZQ-1; Mon, 27 Jul 2020 08:20:48 -0400
X-MC-Unique: oS3ABpabNACmXxhTn-uoZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC114102C853;
        Mon, 27 Jul 2020 12:20:36 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-156.ams2.redhat.com [10.36.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A93079D02;
        Mon, 27 Jul 2020 12:20:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x: skrf: Add exception new skey
 test and add test to unittests.cfg
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200727095415.494318-1-frankja@linux.ibm.com>
 <20200727095415.494318-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b5b0f9d1-075d-edf6-8a30-39cb84f7b42c@redhat.com>
Date:   Mon, 27 Jul 2020 14:20:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200727095415.494318-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/07/2020 11.54, Janosch Frank wrote:
> When an exception new psw with a storage key in its mask is loaded
> from lowcore, a specification exception is raised. This differs from
> the behavior when trying to execute skey related instructions, which
> will result in special operation exceptions.
> 
> Also let's add the test unittests.cfg so it is run more often.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/skrf.c        | 80 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  2 files changed, 84 insertions(+)
> 
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index 9cae589..fe78711 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -11,12 +11,16 @@
>   */
>  #include <libcflat.h>
>  #include <asm/asm-offsets.h>
> +#include <asm-generic/barrier.h>
>  #include <asm/interrupt.h>
>  #include <asm/page.h>
>  #include <asm/facility.h>
>  #include <asm/mem.h>
> +#include <asm/sigp.h>
> +#include <smp.h>
>  
>  static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
> +static int testflag = 0;
>  
>  static void test_facilities(void)
>  {
> @@ -106,6 +110,81 @@ static void test_tprot(void)
>  	report_prefix_pop();
>  }
>  
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
> +	lc->sw_int_crs[0] = 0x0000000000040000;
> +
> +	/*
> +	 * PGM old contains the ext new PSW, we need to clean it up,
> +	 * so we don't get a special operation exception on the lpswe
> +	 * of pgm old.
> +	 */
> +	lc->pgm_old_psw.mask = 0x0000000180000000UL;
> +	lc->pgm_old_psw.addr = (unsigned long)wait_for_flag;

I don't quite understand why you are using wait_for_flag here? Won't
that function return immediately due to the set_flag(1) below? And if it
returns, where does the cpu continue to exec code in that case? Wouldn't
it be better to leave the .addr unchanged, so that the CPU returns to
the endless loop in smp_cpu_setup_state ?

 Thomas


> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	set_flag(1);
> +}
> +
> +/* Set a key into the external new psw mask and open external call masks */
> +static void ecall_setup(void)
> +{
> +	struct lowcore *lc = (void *)0x0;
> +	uint64_t mask;
> +
> +	register_pgm_int_func(ecall_cleanup);
> +	expect_pgm_int();
> +	/* Put a skey into the ext new psw */
> +	lc->ext_new_psw.mask = 0x00F0000180000000UL;
> +	/* Open up ext masks */
> +	ctl_set_bit(0, 13);
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_EXT;
> +	load_psw_mask(mask);
> +	/* Tell cpu 0 that we're ready */
> +	set_flag(1);
> +}
> +
> +static void test_exception_ext_new(void)
> +{
> +	struct psw psw = {
> +		.mask = extract_psw_mask(),
> +		.addr = (unsigned long)ecall_setup
> +	};
> +
> +	report_prefix_push("exception external new");
> +	if (smp_query_num_cpus() < 2) {
> +		report_skip("Need second cpu for exception external new test.");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	smp_cpu_setup(1, psw);
> +	wait_for_flag();
> +	set_flag(0);
> +
> +	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
> +	wait_for_flag();
> +	smp_cpu_stop(1);
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("skrf");
> @@ -121,6 +200,7 @@ int main(void)
>  	test_mvcos();
>  	test_spka();
>  	test_tprot();
> +	test_exception_ext_new();
>  
>  done:
>  	report_prefix_pop();
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 0f156af..b35269b 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -88,3 +88,7 @@ extra_params = -m 3G
>  [css]
>  file = css.elf
>  extra_params = -device virtio-net-ccw
> +
> +[skrf]
> +file = skrf.elf
> +smp = 2
> 

