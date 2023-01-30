Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD3E680C30
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 12:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbjA3Lox convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Jan 2023 06:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbjA3Low (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 06:44:52 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4ED2CC6F
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 03:44:43 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-16-m21HMkQXND-wH1dPst9cdw-1; Mon, 30 Jan 2023 11:44:40 +0000
X-MC-Unique: m21HMkQXND-wH1dPst9cdw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.45; Mon, 30 Jan
 2023 11:44:39 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.045; Mon, 30 Jan 2023 11:44:39 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joerg Roedel' <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: RE: [PATCH] x86/debug: Fix stack recursion caused by DR7 accesses
Thread-Topic: [PATCH] x86/debug: Fix stack recursion caused by DR7 accesses
Thread-Index: AQHZNI6OfTMv+SJU9USLFxgOS06ds6621EUw
Date:   Mon, 30 Jan 2023 11:44:39 +0000
Message-ID: <692eae653e1d462e980859fb933e5118@AcuMS.aculab.com>
References: <20230130093717.460-1-joro@8bytes.org>
In-Reply-To: <20230130093717.460-1-joro@8bytes.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel
> Sent: 30 January 2023 09:37
> 
> From: Joerg Roedel <jroedel@suse.de>
> 
> In kernels compiled with CONFIG_PARAVIRT=n the compiler re-orders the
> DR7 read in exc_nmi() to happen before the call to sev_es_ist_enter().

More the case that you happen to be 'unlucky' in this case.

> This is problematic when running as an SEV-ES guest because in this
> environemnt the DR7 read might cause a #VC exception, and taking #VC
> exceptions is not safe in exc_nmi() before sev_es_ist_enter() has run.
> 
> The result is stack recursion if the NMI was caused on the #VC IST
> stack, because a subsequent #VC exception in the NMI handler will
> overwrite the stack frame of the interrupted #VC handler.
> 
> As there are no compiler barriers affecting the ordering of DR7
> reads/writes, make the accesses to this register volatile, forbidding
> the compiler to re-order them.

Is that enough?
IIRC 'asm volatile' are only ordered w.r.t other 'asm volatile'.
To stop normal memory accesses being re-ordered you need a "memory" clobber.

All cpu registers are effectively memory, you should be able to use
partial memory clobber for any without side effects.
But if they have side effects on any other memory (or cpu register)
accesses I'd have thought you pretty much need a full compiler
memory barrier.

For most code the cost of a full compiler memory barrier is likely
to be limited.

	David

> 
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/debugreg.h | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
> index b049d950612f..eb6238a5f60c 100644
> --- a/arch/x86/include/asm/debugreg.h
> +++ b/arch/x86/include/asm/debugreg.h
> @@ -39,7 +39,18 @@ static __always_inline unsigned long native_get_debugreg(int regno)
>  		asm("mov %%db6, %0" :"=r" (val));
>  		break;
>  	case 7:
> -		asm("mov %%db7, %0" :"=r" (val));
> +		/*
> +		 * Make DR7 reads volatile to forbid re-ordering them with other
> +		 * code. This is needed because a DR7 access can cause a #VC
> +		 * exception when running under SEV-ES. But taking a #VC
> +		 * exception is not safe at everywhere in the code-flow and
> +		 * re-ordering might place the access into an unsafe place.
> +		 *
> +		 * This happened in the NMI handler, where the DR7 read was
> +		 * re-ordered to happen before the call to sev_es_ist_enter(),
> +		 * causing stack recursion.
> +		 */
> +		asm volatile ("mov %%db7, %0" : "=r" (val));
>  		break;
>  	default:
>  		BUG();
> @@ -66,7 +77,21 @@ static __always_inline void native_set_debugreg(int regno, unsigned long value)
>  		asm("mov %0, %%db6"	::"r" (value));
>  		break;
>  	case 7:
> -		asm("mov %0, %%db7"	::"r" (value));
> +		/*
> +		 * Make DR7 writes volatile to forbid re-ordering them with
> +		 * other code. This is needed because a DR7 access can cause a
> +		 * #VC exception when running under SEV-ES.  But taking a #VC
> +		 * exception is not safe at everywhere in the code-flow and
> +		 * re-ordering might place the access into an unsafe place.
> +		 *
> +		 * This happened in the NMI handler, where the DR7 read was
> +		 * re-ordered to happen before the call to sev_es_ist_enter(),
> +		 * causing stack recursion.
> +		 *
> +		 * While is didn't happen with a DR7 write, add the volatile
> +		 * here too to avoid similar problems in the future.
> +		 */
> +		asm volatile ("mov %0, %%db7"	::"r" (value));
>  		break;
>  	default:
>  		BUG();
> --
> 2.39.0

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

