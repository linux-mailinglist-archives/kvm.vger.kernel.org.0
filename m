Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2F79AB53
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 22:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjIKUrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242988AbjIKQjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 12:39:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A96DE0
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 09:39:00 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-vrPoX74tNACScjDw2HW1IQ-1; Mon, 11 Sep 2023 12:38:53 -0400
X-MC-Unique: vrPoX74tNACScjDw2HW1IQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 344FF38117E5;
        Mon, 11 Sep 2023 16:38:53 +0000 (UTC)
Received: from redhat.com (unknown [10.39.192.243])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F73D40C6EA8;
        Mon, 11 Sep 2023 16:38:51 +0000 (UTC)
Date:   Mon, 11 Sep 2023 18:38:50 +0200
From:   Kevin Wolf <kwolf@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v3] target/i386: Restrict system-specific features from
 user emulation
Message-ID: <ZP9Cmqgy2H3ypDf3@redhat.com>
References: <20230911142729.25548-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230911142729.25548-1-philmd@linaro.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 11.09.2023 um 16:27 hat Philippe Mathieu-Daudé geschrieben:
> Since commits 3adce820cf ("target/i386: Remove unused KVM
> stubs") and ef1cf6890f ("target/i386: Allow elision of
> kvm_hv_vpindex_settable()"), when building on a x86 host
> configured as:
> 
>   $ ./configure --cc=clang \
>     --target-list=x86_64-linux-user,x86_64-softmmu \
>     --enable-debug
> 
> we get:
> 
>   [71/71] Linking target qemu-x86_64
>   FAILED: qemu-x86_64
>   /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in function `cpu_x86_cpuid':
>   cpu.c:(.text+0x1374): undefined reference to `kvm_arch_get_supported_cpuid'
>   /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in function `x86_cpu_filter_features':
>   cpu.c:(.text+0x81c2): undefined reference to `kvm_arch_get_supported_cpuid'
>   /usr/bin/ld: cpu.c:(.text+0x81da): undefined reference to `kvm_arch_get_supported_cpuid'
>   /usr/bin/ld: cpu.c:(.text+0x81f2): undefined reference to `kvm_arch_get_supported_cpuid'
>   /usr/bin/ld: cpu.c:(.text+0x820a): undefined reference to `kvm_arch_get_supported_cpuid'
>   /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o:cpu.c:(.text+0x8225): more undefined references to `kvm_arch_get_supported_cpuid' follow
>   clang: error: linker command failed with exit code 1 (use -v to see invocation)
>   ninja: build stopped: subcommand failed.
> 
> libqemu-x86_64-linux-user.fa is user emulation specific, so
> having system emulation code called there is dubious.
> 
> '--enable-debug' disables optimizations (CFLAGS=-O0).
> 
> While at this (un)optimization level GCC eliminate the
> following dead code (CPP output of mentioned build):
> 
>  static void x86_cpu_get_supported_cpuid(uint32_t func, uint32_t index,
>                                          uint32_t *eax, uint32_t *ebx,
>                                          uint32_t *ecx, uint32_t *edx)
>  {
>      if ((0)) {
>          *eax = kvm_arch_get_supported_cpuid(kvm_state, func, index, R_EAX);
>          *ebx = kvm_arch_get_supported_cpuid(kvm_state, func, index, R_EBX);
>          *ecx = kvm_arch_get_supported_cpuid(kvm_state, func, index, R_ECX);
>          *edx = kvm_arch_get_supported_cpuid(kvm_state, func, index, R_EDX);
>      } else if (0) {
>          *eax = 0;
>          *ebx = 0;
>          *ecx = 0;
>          *edx = 0;
>      } else {
>          *eax = 0;
>          *ebx = 0;
>          *ecx = 0;
>          *edx = 0;
>      }
>  }
> 
> Clang does not.
> 
> Instead of trying to deal with compiler specific checks around
> __OPTIMIZE__ (see commit 2140cfa51d "i386: Fix build by providing
> stub kvm_arch_get_supported_cpuid()"), simply restrict code
> belonging to system emulation, easing user emulation linking.
> 
> Reported-by: Kevin Wolf <kwolf@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Can we make the function declarations in the header file for the
functions without stubs conditional on !CONFIG_USER_ONLY, too, so that
trying to call them would already fail during compilation (and also with
-O2), not only when linking without optimisations?

Kevin

