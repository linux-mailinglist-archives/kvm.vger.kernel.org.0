Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8290139913
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 19:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgAMSlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 13:41:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34196 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726878AbgAMSlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 13:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578940869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lzsvSn3vm+wBgNMJ8PeCKY2Pk4Acog14y15igrOXvYo=;
        b=Ej2aKg0OrdLngKsZLfmnFwyAhwTPAIf+AEa6lZ84O+Bx+Xvvg3kpXXi2FSV9lnD6E/3/8F
        bA+pg1OiaTgENXdna/y3u54jM0RUo8UiXxWACkEppOAu2/0Y3PbXFhI0yTOesW5wr6G3sc
        KvgAgqCte+LST5H23TzS+0RE9MCLk70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-5paUai2PN46VI-a3bWSjqw-1; Mon, 13 Jan 2020 13:41:05 -0500
X-MC-Unique: 5paUai2PN46VI-a3bWSjqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E10E9907607;
        Mon, 13 Jan 2020 18:41:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3302A19C5B;
        Mon, 13 Jan 2020 18:40:57 +0000 (UTC)
Date:   Mon, 13 Jan 2020 19:40:55 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 14/16] arm/run: Allow Migration tests
Message-ID: <20200113184055.tu3qqpsc72xqfw6t@kamzik.brq.redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-15-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110145412.14937-15-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 03:54:10PM +0100, Eric Auger wrote:
> Let's link getchar.o to use puts and getchar from the
> tests.
> 
> Then allow tests belonging to the migration group to
> trigger the migration from the test code by putting
> "migrate" into the uart. Then the code can wait for the
> migration completion by using getchar().
> 
> The __getchar implement is minimalist as it just reads the
> data register. It is just meant to read the single character
> emitted at the end of the migration by the runner script.
> 
> It is not meant to read more data (FIFOs are not enabled).
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  arm/Makefile.common |  2 +-
>  arm/run             |  2 +-
>  lib/arm/io.c        | 13 +++++++++++++
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 7cc0f04..327f112 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -32,7 +32,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
>  asm-offsets = lib/$(ARCH)/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
>  
> -cflatobjs += lib/util.o
> +cflatobjs += lib/util.o lib/getchar.o
>  cflatobjs += lib/alloc_phys.o
>  cflatobjs += lib/alloc_page.o
>  cflatobjs += lib/vmalloc.o
> diff --git a/arm/run b/arm/run
> index 277db9b..a390ca5 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -61,6 +61,6 @@ fi
>  M+=",accel=$ACCEL"
>  command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
>  command+=" -display none -serial stdio -kernel"
> -command="$(timeout_cmd) $command"
> +command="$(migration_cmd) $(timeout_cmd) $command"
>  
>  run_qemu $command "$@"
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 99fd315..ed89e19 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -87,6 +87,19 @@ void puts(const char *s)
>  	spin_unlock(&uart_lock);
>  }
>  
> +/*
> + * Minimalist implementation for migration completion detection.
> + * Needs to be improved for more advanced Rx cases

Please add that QEMU supports reading a maximum of 16 characters in
this minimal mode. We could even add a counter and then assert if
we try to read 16 or more.

> + */
> +int __getchar(void)
> +{
> +	int ret;
> +
> +	ret = readb(uart0_base);
> +	if (!ret)
> +		return -1;
> +	return ret;
> +}

What about taking the lock?

>  
>  /*
>   * Defining halt to take 'code' as an argument guarantees that it will
> -- 
> 2.20.1
> 

What do you think of the __getchar below?

Thanks,
drew


diff --git a/lib/arm/io.c b/lib/arm/io.c
index 99fd31560084..77beb331d6b2 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -79,6 +79,31 @@ void io_init(void)
 	chr_testdev_init();
 }
 
+static int ____getchar(void)
+{
+	int c;
+
+	spin_lock(&uart_lock);
+	c = readb(uart0_base);
+	spin_unlock(&uart_lock);
+
+	return c ?: -1;
+}
+
+int __getchar(void)
+{
+	static int count;
+	int c;
+
+	if ((c = ____getchar()) != -1)
+		++count;
+
+	/* Without special UART initialization we can only read 16 characters. */
+	assert(count < 16);
+
+	return c;
+}
+
 void puts(const char *s)
 {
 	spin_lock(&uart_lock);

