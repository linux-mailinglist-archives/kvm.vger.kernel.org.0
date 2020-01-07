Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2ED132092
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 08:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgAGHjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 02:39:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20888 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbgAGHjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 02:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578382762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=XP6X6jfo2D1Ntt4i7WREXuOToJDDJqraHYyom/OfMhg=;
        b=fNqETqSFQQZT+C77IEqFUjzPfFv//9JD0kTNfDgSdDbsdcBnhcrgHyJO9DsbbFlNqNS/ut
        vCXmfO5eA1oU6qba9KR2ZFNrf8z6qm3Dk5zVoYkg5vlQ2RGClfKlQ7nM3Un23SOFksWYai
        3kGWrub8z6QqFudEo7iwS6VYWBXsJkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-r5ygW_KtMd6V1DRyzLNExQ-1; Tue, 07 Jan 2020 02:39:19 -0500
X-MC-Unique: r5ygW_KtMd6V1DRyzLNExQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E214800D4C;
        Tue,  7 Jan 2020 07:39:17 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-116.ams2.redhat.com [10.36.116.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 074FB84672;
        Tue,  7 Jan 2020 07:39:11 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 14/16] arm/run: Allow Migration tests
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-15-eric.auger@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9b03fb14-008b-549b-9336-d5e91208a54f@redhat.com>
Date:   Tue, 7 Jan 2020 08:39:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191216140235.10751-15-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/2019 15.02, Eric Auger wrote:
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
> index 99fd315..aa9e1b5 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -87,6 +87,19 @@ void puts(const char *s)
>  	spin_unlock(&uart_lock);
>  }
>  
> +/*
> + * Minimalist implementation for migration completion detection.
> + * Needs to be improved for more advanced Rx cases
> + */
> +int __getchar(void)
> +{
> +	int ret;
> +
> +	ret =  readb(uart0_base);

Duplicated space before "readb"...

> +	if (!ret)
> +		return -1;
> +	return ret;
> +}
>  
>  /*
>   * Defining halt to take 'code' as an argument guarantees that it will
> 

... but apart from that nit:
Reviewed-by: Thomas Huth <thuth@redhat.com>

