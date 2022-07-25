Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C30C57FD62
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 12:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiGYKZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 06:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiGYKZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 06:25:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9342312755
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 03:25:45 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C69662B;
        Mon, 25 Jul 2022 03:25:45 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BD913F73D;
        Mon, 25 Jul 2022 03:25:44 -0700 (PDT)
Date:   Mon, 25 Jul 2022 11:26:15 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     will@kernel.org, kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sami.mujawar@arm.com
Subject: Re: [PATCH kvmtool 1/4] Makefile: Add missing build dependencies
Message-ID: <Yt5vrPljvE0lMHPX@monolith.localdoman>
References: <20220722141731.64039-1-jean-philippe@linaro.org>
 <20220722141731.64039-2-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722141731.64039-2-jean-philippe@linaro.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jul 22, 2022 at 03:17:29PM +0100, Jean-Philippe Brucker wrote:
> When running kvmtool after updating without doing a make clean, one
> might run into strange issues such as:
> 
>   Warning: Failed init: symbol_init
>   Fatal: Initialisation failed
> 
> or worse. This happens because symbol.o is not automatically rebuilt
> after a change of headers, because .symbol.o.d is not in the $(DEPS)
> variable. So if the layout of struct kvm_config changes, for example,
> symbols.o that was built for an older version will try to read
> kvm->vmlinux from the wrong location in struct kvm, and lkvm will die.
> 
> Add all .d files to $(DEPS). Also include $(STATIC_DEPS) which was
> previously set but not used.

This makes sense to me. And hopefully it should fix some weird errors that
went away for me by doing a make clean before a rebuild.

> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 1f9903d8..f0df76f4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -383,7 +383,7 @@ comma = ,
>  # The dependency file for the current target
>  depfile = $(subst $(comma),_,$(dir $@).$(notdir $@).d)
>  
> -DEPS	:= $(foreach obj,$(OBJS),\
> +DEPS	:= $(foreach obj,$(OBJS) $(OBJS_DYNOPT) $(OTHEROBJS) $(GUEST_OBJS),\

Checked and those are indeed all the objects.

>  		$(subst $(comma),_,$(dir $(obj)).$(notdir $(obj)).d))
>  
>  DEFINES	+= -D_FILE_OFFSET_BITS=64
> @@ -590,6 +590,7 @@ cscope:
>  # Escape redundant work on cleaning up
>  ifneq ($(MAKECMDGOALS),clean)
>  -include $(DEPS)
> +-include $(STATIC_DEPS)

In the spirit in keeping the makefile as small as possible and reading
fewer files, maybe STATIC_DEPS should be included only if the target is
$(PROGRAM)-static.

Regardless of how you want to handle that, the patch looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

>  
>  KVMTOOLS-VERSION-FILE:
>  	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
> -- 
> 2.37.1
> 
