Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67AB4E6031
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 09:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345816AbiCXIQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 04:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbiCXIQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 04:16:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B31E56D4CA
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 01:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648109713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mStAd675IKnvi6lI8izFZCOtYDVPmeABKbfP2C39e7k=;
        b=GrUMe8qaCBONojKhutZIlBCgUWIHFH38EHns9SHqWjCzXPOaLNKSX9ppMj4ibgm7w/KfK0
        iPmcxmnRUZ32VLQB0ykdoeTShN2rAT5pd+wcLAHjG2FHdBtA0Z1AI7VQ5wGQaCv/jzIfbU
        01eJufKpnbfp3MgBZ8CrysVuBJ6Nygk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-W20uOyRuMdKHEGWZiAvqPw-1; Thu, 24 Mar 2022 04:15:10 -0400
X-MC-Unique: W20uOyRuMdKHEGWZiAvqPw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FED4296A603;
        Thu, 24 Mar 2022 08:15:09 +0000 (UTC)
Received: from [10.39.192.221] (unknown [10.39.192.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55176141DEDE;
        Thu, 24 Mar 2022 08:15:07 +0000 (UTC)
Message-ID: <4cd394c9-e43a-4831-d39e-66dcb3d95074@redhat.com>
Date:   Thu, 24 Mar 2022 09:15:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH kvm-unit-tests v2 2/6] s390x: smp: Test SIGP RESTART
 against stopped CPU
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220311173822.1234617-1-farman@linux.ibm.com>
 <20220311173822.1234617-3-farman@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220311173822.1234617-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/03/2022 18.38, Eric Farman wrote:
> test_restart() makes two smp_cpu_restart() calls against CPU 1.
> It claims to perform both of them against running (operating) CPUs,
> but the first invocation tries to achieve this by calling
> smp_cpu_stop() to CPU 0. This will be rejected by the library.
> 
> Let's fix this by making the first restart operate on a stopped CPU,
> to ensure it gets test coverage instead of relying on other callers.
> 
> Fixes: 166da884d ("s390x: smp: Add restart when running test")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/smp.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 068ac74d..2f4af820 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -50,10 +50,6 @@ static void test_start(void)
>   	report_pass("start");
>   }
>   
> -/*
> - * Does only test restart when the target is running.
> - * The other tests do restarts when stopped multiple times already.
> - */
>   static void test_restart(void)
>   {
>   	struct cpu *cpu = smp_cpu_from_idx(1);
> @@ -62,8 +58,8 @@ static void test_restart(void)
>   	lc->restart_new_psw.mask = extract_psw_mask();
>   	lc->restart_new_psw.addr = (unsigned long)test_func;
>   
> -	/* Make sure cpu is running */
> -	smp_cpu_stop(0);
> +	/* Make sure cpu is stopped */
> +	smp_cpu_stop(1);

It might be a good idea to check the return code of smp_cpu_stop() for 
success ... but that can also be done in a later patch, so for this one:

Reviewed-by: Thomas Huth <thuth@redhat.com>


>   	set_flag(0);
>   	smp_cpu_restart(1);
>   	wait_for_flag();

