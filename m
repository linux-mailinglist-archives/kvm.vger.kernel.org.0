Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6B0768044
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 17:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjG2PHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jul 2023 11:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbjG2PHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jul 2023 11:07:45 -0400
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0273E3ABA;
        Sat, 29 Jul 2023 08:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1690643255;
        bh=mf/g08zyt6vliP5ksLrCtviPkpRZ6Ksl4YtB9hpnaPU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=S/9n7AufcmGKMdsA2mmxdWcPq7BgMhZJ9PXycHMkMbp5QAAwyUlTmscSC7PY/ccy5
         pT1PE7NpapxhiOFTPIEivgtQ8qPxYhhKyjLV6svmHoKRtBt5vy1irhQeQ6y2YDWP86
         +UzTUdgi8unS/vIFS0/nJwiQSUA2wE0SriXGFAeHEMQ1/DG7NjGQ5Xym9L8mcFY/Hu
         gOgtT8Jhp10jM/qMI5S+ad8ZcwNTgk48ZiWdaEeznA2XgYgn26FV1qIo2BfRAEfrKQ
         z0vpSEn4weqvCGnQBDAQFTA0j2ocOCCkaDH3Fod+R/CCKmI01a2nq5+g1h8XgBZuIi
         1+67eUaNKEPnw==
Received: from [172.24.0.4] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4RCntH4tD5z1Jw4;
        Sat, 29 Jul 2023 11:07:35 -0400 (EDT)
Message-ID: <48e70e65-010b-52ef-8585-9075a7874d76@efficios.com>
Date:   Sat, 29 Jul 2023 11:08:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] selftests/rseq: Play nice with binaries statically linked
 against glibc 2.35+
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        kvm@vger.kernel.org
References: <20230721223352.2333911-1-seanjc@google.com>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20230721223352.2333911-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/23 18:33, Sean Christopherson wrote:
> To allow running rseq and KVM's rseq selftests as statically linked
> binaries, initialize the various "trampoline" pointers to point directly
> at the expect glibc symbols, and skip the dlysm() lookups if the rseq
> size is non-zero, i.e. the binary is statically linked *and* the libc
> registered its own rseq.
> 
> Define weak versions of the symbols so as not to break linking against
> libc versions that don't support rseq in any capacity.
> 
> The KVM selftests in particular are often statically linked so that they
> can be run on targets with very limited runtime environments, i.e. test
> machines.

Thanks!

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Fixes: 233e667e1ae3 ("selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35")
> Cc: Aaron Lewis <aaronlewis@google.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Note, this is very much the result of throwing noodles until something
> stuck, it seems like there's gotta be a less awful way to handle this :-(
> 
> I Cc'd stable@ because I know I'm not the only person that runs statically
> linked KVM selftests, and figuring all this out was quite painful.
> 
>   tools/testing/selftests/rseq/rseq.c | 28 ++++++++++++++++++++++------
>   1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
> index 4e4aa006004c..a723da253244 100644
> --- a/tools/testing/selftests/rseq/rseq.c
> +++ b/tools/testing/selftests/rseq/rseq.c
> @@ -34,9 +34,17 @@
>   #include "../kselftest.h"
>   #include "rseq.h"
>   
> -static const ptrdiff_t *libc_rseq_offset_p;
> -static const unsigned int *libc_rseq_size_p;
> -static const unsigned int *libc_rseq_flags_p;
> +/*
> + * Define weak versions to play nice with binaries that are statically linked
> + * against a libc that doesn't support registering its own rseq.
> + */
> +__weak ptrdiff_t __rseq_offset;
> +__weak unsigned int __rseq_size;
> +__weak unsigned int __rseq_flags;
> +
> +static const ptrdiff_t *libc_rseq_offset_p = &__rseq_offset;
> +static const unsigned int *libc_rseq_size_p = &__rseq_size;
> +static const unsigned int *libc_rseq_flags_p = &__rseq_flags;
>   
>   /* Offset from the thread pointer to the rseq area. */
>   ptrdiff_t rseq_offset;
> @@ -155,9 +163,17 @@ unsigned int get_rseq_feature_size(void)
>   static __attribute__((constructor))
>   void rseq_init(void)
>   {
> -	libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
> -	libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
> -	libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");
> +	/*
> +	 * If the libc's registered rseq size isn't already valid, it may be
> +	 * because the binary is dynamically linked and not necessarily due to
> +	 * libc not having registered a restartable sequence.  Try to find the
> +	 * symbols if that's the case.
> +	 */
> +	if (!*libc_rseq_size_p) {
> +		libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
> +		libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
> +		libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");
> +	}
>   	if (libc_rseq_size_p && libc_rseq_offset_p && libc_rseq_flags_p &&
>   			*libc_rseq_size_p != 0) {
>   		/* rseq registration owned by glibc */
> 
> base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

