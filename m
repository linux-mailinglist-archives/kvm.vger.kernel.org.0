Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605787498E4
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 12:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjGFKCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 06:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjGFKBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 06:01:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F201986;
        Thu,  6 Jul 2023 03:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AF05618EC;
        Thu,  6 Jul 2023 10:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD42C433C8;
        Thu,  6 Jul 2023 10:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688637709;
        bh=1uw7peNXWbOZLFcB9mq2BFk7tvD/drZrJVzzlsJCqFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=snLh+kbUGeVCMoA+6j1NiXgyGq/FjkZbnGTrm9nidVQVXwFkv/QVK3CL/JdJdM6DD
         Mk/HKookNBQppeS2LPYd8249BnWwqm4wB2vqfiloLXWNRHrYUMi0Z4zu8O6lJVeXcl
         ETwReQjSDLhKY6oTbxVrRpRplbDZIaziMv0oJAOlYhOqurXwm/n6Il2lb6fXtAmq0B
         1nhf0VTZF3pX/pgxr7OcXS1KSRfjTFs6gMLl3gWBfp3aQ4HB5y8TxFmtVk8jpGSdaz
         sF03Ca3zNDHqfqeHjaHqdg5fmoQgyCM4cSWpq0Yd6oOGBvocG3HDVvgjYE8xKbJwWp
         G85Mz/024v2zQ==
Date:   Thu, 6 Jul 2023 12:01:46 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        Dan Carpenter <error27@gmail.com>,
        Chuang Wang <nashuiliang@gmail.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: Re: [RFC PATCH 11/14] context-tracking: Introduce work deferral
 infrastructure
Message-ID: <ZKaRCsWfYVPVMBcz@lothringen>
References: <20230705181256.3539027-1-vschneid@redhat.com>
 <20230705181256.3539027-12-vschneid@redhat.com>
 <ZKXtfWZiM66dK5xC@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKXtfWZiM66dK5xC@localhost.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 12:23:57AM +0200, Frederic Weisbecker wrote:
> diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
> index fdd537ea513f..ec3d172601c5 100644
> --- a/include/linux/context_tracking_state.h
> +++ b/include/linux/context_tracking_state.h
> @@ -10,14 +10,19 @@
>  #define DYNTICK_IRQ_NONIDLE	((LONG_MAX / 2) + 1)
>  
>  enum ctx_state {
> +	/* Following are values */
>  	CONTEXT_DISABLED	= -1,	/* returned by ct_state() if unknown */
>  	CONTEXT_KERNEL		= 0,
>  	CONTEXT_IDLE		= 1,
>  	CONTEXT_USER		= 2,
> -	CONTEXT_GUEST		= 3,
> -	CONTEXT_MAX		= 4,
> +	/* Following are bit numbers */
> +	CONTEXT_WORK		= 2,
> +	CONTEXT_MAX		= 16,
>  };
>  
> +#define CONTEXT_MASK (BIT(CONTEXT_WORK) - 1)
> +#define CONTEXT_WORK_MASK ((BIT(CONTEXT_MAX) - 1) & ~(BIT(CONTEXT_WORK) - 1))
> +
>  /* Even value for idle, else odd. */
>  #define RCU_DYNTICKS_IDX CONTEXT_MAX

And that should be:

#define RCU_DYNTICKS_IDX BIT(CONTEXT_MAX)

Did I mention it's not even build tested? :o)
