Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D10D2D7575
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 13:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392064AbgLKMU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 07:20:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405426AbgLKMUX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 07:20:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607689136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BB93t3uEekX1OXoTCVVBT3JM62/OkLr/OpczYGAUq5k=;
        b=D4q4Rr5JIID5gk6O+ErllQKOCAigGEZehhY7GlvxE6Rv9nih0Drmc2JlRHL5boIjCezzz3
        6StJhk8FU68++HYm6FkXm8k/o23i8vpaFF6SE7PYNQCF7ITT03T0lMbs+yUDw1pM07Gk2+
        X/9E6SgWS8KC/GgozY4e7kdpEY1su0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-Yn0XApXhMh68o9fHlNQoFA-1; Fri, 11 Dec 2020 07:18:52 -0500
X-MC-Unique: Yn0XApXhMh68o9fHlNQoFA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61ED718C8C12;
        Fri, 11 Dec 2020 12:18:48 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32A2E6268F;
        Fri, 11 Dec 2020 12:18:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 4/8] s390x: Split assembly and move to
 s390x/asm/
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <5f1e9f51-86d9-4bb1-1dcf-09ec687419f4@redhat.com>
Date:   Fri, 11 Dec 2020 13:18:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201211100039.63597-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/2020 11.00, Janosch Frank wrote:
> I've added too much to cstart64.S which is not start related
> already. Now that I want to add even more code it's time to split
> cstart64.S. lib.S has functions that are used in tests. macros.S
> contains macros which are used in cstart64.S and lib.S
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile             |   8 +--
>  s390x/{ => asm}/cstart64.S | 119 ++-----------------------------------
>  s390x/asm/lib.S            |  65 ++++++++++++++++++++
>  s390x/asm/macros.S         |  77 ++++++++++++++++++++++++
>  4 files changed, 150 insertions(+), 119 deletions(-)
>  rename s390x/{ => asm}/cstart64.S (50%)
>  create mode 100644 s390x/asm/lib.S
>  create mode 100644 s390x/asm/macros.S
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index b079a26..fb62e87 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -66,10 +66,10 @@ cflatobjs += lib/s390x/css_lib.o
>  
>  OBJDIRS += lib/s390x
>  
> -cstart.o = $(TEST_DIR)/cstart64.o
> +asmlib = $(TEST_DIR)/asm/cstart64.o $(TEST_DIR)/asm/lib.o
>  
>  FLATLIBS = $(libcflat)
> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(cstart.o)
> +%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>  	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
>  		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
>  	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
> @@ -87,7 +87,7 @@ FLATLIBS = $(libcflat)
>  	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
>  
>  arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d $(TEST_DIR)/asm/*.{o,elf,bin} $(TEST_DIR)/asm/.*.d
>  
>  generated-files = $(asm-offsets)
> -$(tests:.elf=.o) $(cstart.o) $(cflatobjs): $(generated-files)
> +$(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)

Did you check this with both, in-tree and out-of-tree builds?
(I wonder whether that new asm directory needs some special handling for
out-of-tree builds?)

> diff --git a/s390x/asm/lib.S b/s390x/asm/lib.S
> new file mode 100644
> index 0000000..4d78ec6
> --- /dev/null
> +++ b/s390x/asm/lib.S
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * s390x assembly library
> + *
> + * Copyright (c) 2019 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <asm/asm-offsets.h>
> +#include <asm/sigp.h>
> +
> +#include "macros.S"
> +
> +/*
> + * load_reset calling convention:
> + * %r2 subcode (0 or 1)
> + */
> +.globl diag308_load_reset
> +diag308_load_reset:

Thinking about this twice ... this function is only used by s390x/diag308.c,
so it's not really a library function, but rather part of a single test ...
I think it would be cleaner to put it into a separate file instead, what do
you think?

 Thomas


