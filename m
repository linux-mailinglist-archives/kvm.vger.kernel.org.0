Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E70472914C
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 09:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237916AbjFIHhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 03:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238974AbjFIHgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 03:36:40 -0400
Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [IPv6:2001:41d0:203:375::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F33B1FDA
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 00:36:38 -0700 (PDT)
Date:   Fri, 9 Jun 2023 09:36:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686296196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9jyuL0O1SbrNhDjfR+6vAmwAiSIZPDBUJ1ZLZU19qvc=;
        b=do/Vsrno4Nfga0OfFgjrDjsAl5E98LOtyJRzfSBNYnGA6cLA0CTgmBCWZJ5fW6Mba0cNTG
        y5UATzD4V3wgZ/yBVQTOYsr/WYp/+T2tcL4pDN3T+sYV8hBBeTsnMshwAqH1fpqy8fNo1w
        OpCTe0TyZjyxK1K7x4L/2aiBrLgjpl4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 28/32] arm64: Add support for efi in
 Makefile
Message-ID: <20230609-2c01e3ece17d5c6b3005ee4e@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-29-nikos.nikoleris@arm.com>
 <197A5432-65EA-49A7-AD6D-1AFCB58D30D0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <197A5432-65EA-49A7-AD6D-1AFCB58D30D0@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 01:41:58PM -0700, Nadav Amit wrote:
...
> > +%.efi: %.so
> > + $(call arch_elf_check, $^)
> > + $(OBJCOPY) \
> > + -j .text -j .sdata -j .data -j .dynamic -j .dynsym \
> > + -j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
> > + -j .reloc \
> > + -O binary $^ $@
> 
> I really appreciate your work Nikos, and I might be late since I see Drew
> already applied it to his queue.

It's not too late. arm/queue isn't stable so we can apply fixes while it
bakes there.

> So consider this email, my previous one, and
> others that might follow more as grievances that can easily be addressed later.
> 
> So: It would’ve been nice to keep the symbols and debug information in a
> separate file. Something like:
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index d60cf8c..f904702 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -69,7 +69,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
>  ifeq ($(CONFIG_EFI),y)
>  %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
>  %.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
> -       $(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
> +       $(CC) $(CFLAGS) -c -g -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
>                 -DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
>         $(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
>                 $(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
> @@ -78,6 +78,9 @@ ifeq ($(CONFIG_EFI),y)
>    %.efi: %.so
>         $(call arch_elf_check, $^)
> +       $(OBJCOPY) --only-keep-debug $^ $@.debug
> +       $(OBJCOPY) --strip-debug $^
> +       $(OBJCOPY) --add-gnu-debuglink=$@.debug $^
>         $(OBJCOPY) \
>                 -j .text -j .sdata -j .data -j .dynamic -j .dynsym \
>                 -j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \

This is nice, but I think it can wait and be posted later.

Thanks,
drew
