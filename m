Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0799258D3CF
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 08:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbiHIGdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 02:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHIGdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 02:33:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D95420185
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 23:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660026818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wDEFUEUXWfV3mOjw64c6fomBw3vcWdz+3Pw9Zm2DtUE=;
        b=Qos1JZwaZOMoQGXmCHsKMJnJ7rbsafAdYDvp3xDVunATtuaiCh3VUXfWxH2JU4PyMcQV1T
        2gaWw/pwQ50QQHRk4Pkh5NMJRSSTO3pygwCYWvVAR0pZQ78Jtwh92QM+ePuPoRZ5CjkSHU
        U15xVPN5GYJjc74QtRHwB9Gfhman6LY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-4-ft3tWvNVOUZxhcd6aQLg-1; Tue, 09 Aug 2022 02:33:36 -0400
X-MC-Unique: 4-ft3tWvNVOUZxhcd6aQLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D77EC805B9A;
        Tue,  9 Aug 2022 06:33:35 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.193.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F41A51121315;
        Tue,  9 Aug 2022 06:33:32 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        andrew.jones@linux.dev, seanjc@google.com,
        mathieu.desnoyers@efficios.com, yihyu@redhat.com,
        shan.gavin@gmail.com
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
References: <20220809060627.115847-1-gshan@redhat.com>
        <20220809060627.115847-2-gshan@redhat.com>
Date:   Tue, 09 Aug 2022 08:33:31 +0200
In-Reply-To: <20220809060627.115847-2-gshan@redhat.com> (Gavin Shan's message
        of "Tue, 9 Aug 2022 14:06:26 +0800")
Message-ID: <8735e6ncxw.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Gavin Shan:

> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index a54d4d05a058..acb1bf1f06b3 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -9,6 +9,7 @@
>  #include <string.h>
>  #include <signal.h>
>  #include <syscall.h>
> +#include <dlfcn.h>
>  #include <sys/ioctl.h>
>  #include <sys/sysinfo.h>
>  #include <asm/barrier.h>

I'm surprised that there isn't a Makefile update to link with -ldl
(still required for glibc 2.33 and earlier).

> @@ -36,6 +37,8 @@ static __thread volatile struct rseq __rseq = {
>   */
>  #define NR_TASK_MIGRATIONS 100000
>  
> +static bool __rseq_ownership;
> +static volatile struct rseq *__rseq_info;
>  static pthread_t migration_thread;
>  static cpu_set_t possible_mask;
>  static int min_cpu, max_cpu;
> @@ -49,11 +52,33 @@ static void guest_code(void)
>  		GUEST_SYNC(0);
>  }
>  
> +static void sys_rseq_ownership(void)
> +{
> +	long *offset;
> +	unsigned int *size, *flags;
> +
> +	offset = dlsym(RTLD_NEXT, "__rseq_offset");
> +	size = dlsym(RTLD_NEXT, "__rseq_size");
> +	flags = dlsym(RTLD_NEXT, "__rseq_flags");
> +
> +	if (offset && size && *size && flags) {
> +		__rseq_ownership = false;
> +		__rseq_info = (struct rseq *)((uintptr_t)__builtin_thread_pointer() +
> +					      *offset);

__builtin_thread_pointer doesn't work on all architectures/GCC versions.
Is this a problem for selftests?

Thanks,
Florian

