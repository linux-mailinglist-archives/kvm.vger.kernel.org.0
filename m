Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E759C73D7AB
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 08:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjFZGPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 02:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjFZGPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 02:15:41 -0400
Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [IPv6:2001:41d0:1004:224b::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C991EE
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 23:15:36 -0700 (PDT)
Date:   Mon, 26 Jun 2023 08:15:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687760133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fNF07VoGo26+xilKqlR9Lg2Z/PCRyjJsqNC3ggaqlDE=;
        b=B0LqQENq/ffVQH4/QI+7xzw0SQlH/bxiYYusDkLFDS9Zt7F1rkLB4oCsA/IM/uA0YizPdt
        wHJM6UUUXttNsIp5lPgYhFIirWyKorxMgbVjmDldrNXghZ8eaHN7ojeHt3+nauASYxVajw
        6fnb8E3UbW8sGTj1A2LrNgqUvSnBefQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/6] efi: keep efi debug information in
 a separate file
Message-ID: <20230626-9f6f98244a9ea949a48db91d@orel>
References: <20230625230716.2922-1-namit@vmware.com>
 <20230625230716.2922-2-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230625230716.2922-2-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 25, 2023 at 11:07:11PM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Debugging tests that run on EFI is hard because the debug information is
> not included in the EFI file. Dump it into a separeate .debug file to
> allow the use of gdb or pretty_print_stacks script.

We're still missing the run_tests.sh change needed for
pretty_print_stacks, but I can post that myself.

Thanks,
drew

> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> 
> ---
> 
> v1->v2:
> * Making clean should remove .debug [Andrew]
> * x86 EFI support [Andrew]
> ---
>  arm/Makefile.common | 5 ++++-
>  x86/Makefile.common | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index d60cf8c..9b45a8f 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -78,6 +78,9 @@ ifeq ($(CONFIG_EFI),y)
>  
>  %.efi: %.so
>  	$(call arch_elf_check, $^)
> +	$(OBJCOPY) --only-keep-debug $^ $@.debug
> +	$(OBJCOPY) --strip-debug $^
> +	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
>  	$(OBJCOPY) \
>  		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
>  		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
> @@ -103,7 +106,7 @@ $(libeabi): $(eabiobjs)
>  	$(AR) rcs $@ $^
>  
>  arm_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi} $(libeabi) $(eabiobjs) \
> +	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} $(libeabi) $(eabiobjs) \
>  	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/arm/.*.d
>  
>  generated-files = $(asm-offsets)
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 9f2bc93..c42c3e4 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -54,6 +54,9 @@ ifeq ($(CONFIG_EFI),y)
>  	@chmod a-x $@
>  
>  %.efi: %.so
> +	$(OBJCOPY) --only-keep-debug $^ $@.debug
> +	$(OBJCOPY) --strip-debug $^
> +	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
>  	$(OBJCOPY) \
>  		-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
>  		-j .rela -j .reloc -S --target=$(FORMAT) $< $@
> @@ -124,4 +127,4 @@ arch_clean:
>  	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
>  	$(TEST_DIR)/.*.d lib/x86/.*.d \
>  	$(TEST_DIR)/efi/*.o $(TEST_DIR)/efi/.*.d \
> -	$(TEST_DIR)/*.so $(TEST_DIR)/*.efi
> +	$(TEST_DIR)/*.so $(TEST_DIR)/*.efi $(TEST_DIR)/*.debug
> -- 
> 2.34.1
> 
