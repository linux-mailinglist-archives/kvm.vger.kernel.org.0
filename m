Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97FD213AFC2
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 17:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgANQqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 11:46:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42528 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728777AbgANQqE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jan 2020 11:46:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579020363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=vOobr5Pb/jq0pC9V3IkdQmUzSf4HvxBY4jE47O36xgY=;
        b=TE22XQuImKtHKmsAFA9fy1nXhiZ/kDSsB0nMRDznn2+uoAVHp1X1W50Q7MrK14r1riKMvt
        24JzQLDBUpJJlhuHTCYy8XhCHuNWFs2nr3yyO62pBbJRn5DwLeCuh6bqFoEdVIj8jQRIx1
        p4yvnKeMu6wpnjfti9twpMzaVMhFLxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-qQP0Y50nM06M4jwiYa4rrg-1; Tue, 14 Jan 2020 11:46:00 -0500
X-MC-Unique: qQP0Y50nM06M4jwiYa4rrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8ADE610C5683;
        Tue, 14 Jan 2020 16:45:57 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.36.118.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B93235C1D6;
        Tue, 14 Jan 2020 16:45:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/4] s390x: smp: Only use smp_cpu_setup
 once
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200114153054.77082-1-frankja@linux.ibm.com>
 <20200114153054.77082-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9db91398-0371-cd4a-9758-a185b74467a0@redhat.com>
Date:   Tue, 14 Jan 2020 17:45:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114153054.77082-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2020 16.30, Janosch Frank wrote:
> Let's stop and start instead of using setup to run a function on a
> cpu.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 4dee43e..767d167 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -47,7 +47,7 @@ static void test_start(void)
>  	psw.mask = extract_psw_mask();
>  	psw.addr = (unsigned long)test_func;
>  
> -	smp_cpu_setup(1, psw);
> +	smp_cpu_start(1, psw);
>  	wait_for_flag();
>  	report(1, "start");
>  }
> @@ -131,9 +131,8 @@ static void test_ecall(void)
>  
>  	report_prefix_push("ecall");
>  	testflag = 0;
> -	smp_cpu_destroy(1);
>  
> -	smp_cpu_setup(1, psw);
> +	smp_cpu_start(1, psw);
>  	wait_for_flag();
>  	testflag = 0;
>  	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
> @@ -166,9 +165,8 @@ static void test_emcall(void)
>  
>  	report_prefix_push("emcall");
>  	testflag = 0;
> -	smp_cpu_destroy(1);
>  
> -	smp_cpu_setup(1, psw);
> +	smp_cpu_start(1, psw);
>  	wait_for_flag();
>  	testflag = 0;
>  	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
> @@ -186,7 +184,7 @@ static void test_reset_initial(void)
>  	psw.addr = (unsigned long)test_func;
>  
>  	report_prefix_push("reset initial");
> -	smp_cpu_setup(1, psw);
> +	smp_cpu_start(1, psw);
>  
>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
> @@ -217,7 +215,7 @@ static void test_reset(void)
>  	psw.addr = (unsigned long)test_func;
>  
>  	report_prefix_push("cpu reset");
> -	smp_cpu_setup(1, psw);
> +	smp_cpu_start(1, psw);

I think this also fixes a memory leak in case the code did not call
smp_cpu_destroy() inbetween (since smp_cpu_setup() allocates new memory
for the low-core). So as far as I can see, this is a good idea:

Reviewed-by: Thomas Huth <thuth@redhat.com>

