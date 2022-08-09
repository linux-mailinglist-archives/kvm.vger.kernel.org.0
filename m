Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4635458D8CA
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 14:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242678AbiHIMgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 08:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242651AbiHIMgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 08:36:21 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43A29186D6
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 05:36:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A97FA23A;
        Tue,  9 Aug 2022 05:36:20 -0700 (PDT)
Received: from [192.168.12.23] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5861A3F5A1;
        Tue,  9 Aug 2022 05:36:18 -0700 (PDT)
Message-ID: <6d3498f8-80f7-be78-fbdf-643014828c54@arm.com>
Date:   Tue, 9 Aug 2022 13:36:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests RFC PATCH 01/19] Makefile: Define __ASSEMBLY__
 for assembly files
Content-Language: en-GB
To:     Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
        thuth@redhat.com, andrew.jones@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-2-alexandru.elisei@arm.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20220809091558.14379-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/2022 10:15, Alexandru Elisei wrote:
> There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
> with functionality relies on the __ASSEMBLY__ prepocessor constant being
> correctly defined to work correctly. So far, kvm-unit-tests has relied on
> the assembly files to define the constant before including any header
> files which depend on it.
> 
> Let's make sure that nobody gets this wrong and define it as a compiler
> constant when compiling assembly files. __ASSEMBLY__ is now defined for all
> .S files, even those that didn't set it explicitely before.
> 

This is a great idea.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   Makefile           | 5 ++++-
>   arm/cstart.S       | 1 -
>   arm/cstart64.S     | 1 -
>   powerpc/cstart64.S | 1 -
>   4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6ed5deaccb41..42c61aa45d50 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -94,6 +94,9 @@ CFLAGS += $(wmissing_parameter_type)
>   CFLAGS += $(wold_style_declaration)
>   CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>   
> +AFLAGS  = $(CFLAGS)
> +AFLAGS += -D__ASSEMBLY__
> +
>   autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
>   
>   LDFLAGS += $(CFLAGS)
> @@ -117,7 +120,7 @@ directories:
>   	@mkdir -p $(OBJDIRS)
>   
>   %.o: %.S
> -	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<
>   
>   -include */.*.d */*/.*.d
>   
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 7036e67fc0d8..39260e0fa470 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -5,7 +5,6 @@
>    *
>    * This work is licensed under the terms of the GNU LGPL, version 2.
>    */
> -#define __ASSEMBLY__
>   #include <auxinfo.h>
>   #include <asm/assembler.h>
>   #include <asm/thread_info.h>
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index e4ab7d06251e..d62360cf3859 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -5,7 +5,6 @@
>    *
>    * This work is licensed under the terms of the GNU GPL, version 2.
>    */
> -#define __ASSEMBLY__
>   #include <auxinfo.h>
>   #include <asm/asm-offsets.h>
>   #include <asm/assembler.h>
> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> index 972851f9ed65..1a823385fd0f 100644
> --- a/powerpc/cstart64.S
> +++ b/powerpc/cstart64.S
> @@ -5,7 +5,6 @@
>    *
>    * This work is licensed under the terms of the GNU LGPL, version 2.
>    */
> -#define __ASSEMBLY__
>   #include <asm/hcall.h>
>   #include <asm/ppc_asm.h>
>   #include <asm/rtas.h>
