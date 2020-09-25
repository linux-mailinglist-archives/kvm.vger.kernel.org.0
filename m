Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE032780D7
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 08:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgIYGp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 02:45:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727086AbgIYGp0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 02:45:26 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601016325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J0CZK/f2OKB0mRsrYIropTRs5MMWxWbWR7P2envZVy4=;
        b=SQzw8R+vQTpf0VSdURaSb/b4NsxMvlZi1gjPHZuQhGUGHHwvtmeUXHnDwiBB3KQ61pYy0U
        87DckysX/KtK6OtyhXKFgNjGK/E0KsyRLW3aA2qSnhByMlgdYRqJVXl0XxZMXWNqHH2I5x
        HtkXeLoE2G8qQagQKRpCI94UB/IPJrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-yo6BK945O-S3akHS3g_V9A-1; Fri, 25 Sep 2020 02:45:19 -0400
X-MC-Unique: yo6BK945O-S3akHS3g_V9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22A1E188C126;
        Fri, 25 Sep 2020 06:45:18 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-251.ams2.redhat.com [10.36.112.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4951A5D9F1;
        Fri, 25 Sep 2020 06:45:17 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] configure: Test if compiler supports -m16
 on x86
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
References: <20200924182401.95891-1-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <bebc89f8-9692-2627-acf6-fb413b444964@redhat.com>
Date:   Fri, 25 Sep 2020 08:45:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200924182401.95891-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/2020 20.24, Roman Bolshakov wrote:
> -m16 option is available only since GCC 4.9.0 [1]. That causes a build
> failure on centos-7 [2] that has GCC 4.8.5.
> 
> Fallback to -m32 if -m16 is not available.
> 
> 1. http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59672
> 2. https://gitlab.com/bonzini/kvm-unit-tests/-/jobs/755368387
> 
> Fixes: 2616ad934e2 ("x86: realmode: Workaround clang issues")
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  configure           | 11 +++++++++++
>  x86/Makefile.common |  4 ++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/configure b/configure
> index f930543..7dc2e3b 100755
> --- a/configure
> +++ b/configure
> @@ -16,6 +16,7 @@ pretty_print_stacks=yes
>  environ_default=yes
>  u32_long=
>  wa_divide=
> +m16_support=
>  vmm="qemu"
>  errata_force=0
>  erratatxt="$srcdir/errata.txt"
> @@ -167,6 +168,15 @@ EOF
>    rm -f lib-test.{o,S}
>  fi
>  
> +# check if -m16 is supported
> +if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
> +  cat << EOF > lib-test.c
> +int f(int a, int b) { return a + b; }
> +EOF
> +  m16_support=$("$cross_prefix$cc" -m16 -c lib-test.c >/dev/null 2>&1 && echo yes)
> +  rm -f lib-test.{o,c}
> +fi
> +
>  # require enhanced getopt
>  getopt -T > /dev/null
>  if [ $? -ne 4 ]; then
> @@ -224,6 +234,7 @@ ENVIRON_DEFAULT=$environ_default
>  ERRATATXT=$erratatxt
>  U32_LONG_FMT=$u32_long
>  WA_DIVIDE=$wa_divide
> +M16_SUPPORT=$m16_support
>  EOF
>  
>  cat <<EOF > lib/config.h
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 5567d66..553bf49 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -72,7 +72,11 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
>  	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
>  	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
>  
> +ifeq ($(M16_SUPPORT),yes)
>  $(TEST_DIR)/realmode.o: bits = 16
> +else
> +$(TEST_DIR)/realmode.o: bits = 32
> +endif
>  
>  $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
>  
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

