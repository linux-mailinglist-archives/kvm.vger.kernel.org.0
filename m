Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6A2619B91
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 16:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiKDP1b convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 4 Nov 2022 11:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiKDP1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 11:27:16 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 632F62EF33
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 08:27:14 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46B371FB;
        Fri,  4 Nov 2022 08:27:20 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 436413F703;
        Fri,  4 Nov 2022 08:27:13 -0700 (PDT)
Date:   Fri, 4 Nov 2022 15:27:09 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     hbuxiaofei <hbuxiaofei@gmail.com>
Cc:     will@kernel.org, kvm@vger.kernel.org,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [PATCH kvmtool] hw/i8042: Fix value uninitialized in kbd_io()
Message-ID: <20221104152709.10235b86@donnerap.cambridge.arm.com>
In-Reply-To: <20221102080501.69274-1-hbuxiaofei@gmail.com>
References: <20221102080501.69274-1-hbuxiaofei@gmail.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  2 Nov 2022 16:05:01 +0800
hbuxiaofei <hbuxiaofei@gmail.com> wrote:

Hi,

>   GCC Version:
>     gcc (GCC) 8.4.1 20200928 (Red Hat 8.4.1-1)
> 
>   hw/i8042.c: In function ‘kbd_io’:
>   hw/i8042.c:153:19: error: ‘value’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
>      state.write_cmd = val;
>      ~~~~~~~~~~~~~~~~^~~~~
>   hw/i8042.c:298:5: note: ‘value’ was declared here
>     u8 value;
>        ^~~~~
>   cc1: all warnings being treated as errors
>   make: *** [Makefile:508: hw/i8042.o] Error 1

Yeah, I have seen this with the Ubuntu 18.04 GCC as well (Ubuntu
7.5.0-3ubuntu1-18.04), when compiling for x86. It's pretty clearly a
compiler bug (or rather inability to see through all the branches), but as
the code currently stands, value will always be initialised.
So while it's easy to brush this off as "go and fix your compiler", for
users of Ubuntu 18.04 and RedHat 8 that's probably not an easy thing to do.
So since we force breakage on people by using Werror, I'd support the idea
of taking this patch, potentially with a comment, to make people's life
easier.

Cheers,
Andre

> Signed-off-by: hbuxiaofei <hbuxiaofei@gmail.com>
> ---
>  hw/i8042.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/hw/i8042.c b/hw/i8042.c
> index 20be36c..6e4b559 100644
> --- a/hw/i8042.c
> +++ b/hw/i8042.c
> @@ -295,7 +295,7 @@ static void kbd_reset(void)
>  static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>  		   u8 is_write, void *ptr)
>  {
> -	u8 value;
> +	u8 value = 0;
>  
>  	if (is_write)
>  		value = ioport__read8(data);

