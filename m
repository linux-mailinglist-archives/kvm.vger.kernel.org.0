Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4CB12B496
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2019 13:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfL0Mqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Dec 2019 07:46:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57680 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbfL0Mq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Dec 2019 07:46:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577450788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8LBV3jPtWhqLiaq3NkLAnPZYa2Xi8iaa8G+TqCTENnc=;
        b=YyGfDEz8FH80XaU6IqlDfROTdsKxwF0cqmcjo9ifVJLXfUFa11xzvpjnvMBtD0C9wZPYxr
        3eu6jnCSc0ltBMlILCWqeuAdWc6fYrAtx1v8YoqGxmnOADSdVZP7Uv+ukyucxjR2Kkx+a7
        tpg6eldCJ5f8pwU13xNgdlZCgm1cAo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-eb31jIlPOg2_xmJWQeQE6g-1; Fri, 27 Dec 2019 07:46:25 -0500
X-MC-Unique: eb31jIlPOg2_xmJWQeQE6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 473DE1007303;
        Fri, 27 Dec 2019 12:46:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-101.brq.redhat.com [10.40.204.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AEA5A4B60;
        Fri, 27 Dec 2019 12:46:23 +0000 (UTC)
Date:   Fri, 27 Dec 2019 13:46:19 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests] ./run_tests.sh error?
Message-ID: <20191227124619.5kbs5l7gooei6lgp@kamzik.brq.redhat.com>
References: <46d9112f-1520-0d81-e109-015b7962b1a7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46d9112f-1520-0d81-e109-015b7962b1a7@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 25, 2019 at 01:38:53PM +0800, Haiwei Li wrote:
> When i run ./run_tests.sh, i get output like this:
> 
> SKIP apic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': No
> such file or directory)
> SKIP ioapic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': No
> such file or directory)
> SKIP apic (qemu: could not open kernel file '_NO_FILE_4Uhere_': No such file
> or directory)
> ......
> 
> Seems like the code below causing of "SKIP" above.
> 
> file: scripts/runtime.bash
> 
> # We assume that QEMU is going to work if it tried to load the kernel
> premature_failure()
> {
>     local log="$(eval $(get_cmdline _NO_FILE_4Uhere_) 2>&1)"
> 
>     echo "$log" | grep "_NO_FILE_4Uhere_" |
>         grep -q -e "could not load kernel" -e "error loading" &&
>         return 1
> 
>     RUNTIME_log_stderr <<< "$log"
> 
>     echo "$log"
>     return 0
> }
> 
> get_cmdline()
> {
>     local kernel=$1
>     echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run
> $kernel -smp $smp $opts"
> }
> 
> function run()
> {
> ...
>     last_line=$(premature_failure > >(tail -1)) && {
>         print_result "SKIP" $testname "" "$last_line"
>         return 77
>     }
> ...
> }
> 
> Is that proper? What can i do?
> 
> What i did:
> 
> 1. git clone git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> 2. cd kvm-unit-tests/
> 3. git checkout -b next origin/next
> 4. ./configure
> 5. make
> 6. ./run_test.sh
> 
> Related config file:
> 
> # cat config.mak
> SRCDIR=/data/kvm-unit-tests
> PREFIX=/usr/local
> HOST=x86_64
> ARCH=x86_64
> ARCH_NAME=x86_64
> PROCESSOR=x86_64
> CC=gcc
> CXX=g++
> LD=ld
> OBJCOPY=objcopy
> OBJDUMP=objdump
> AR=ar
> ADDR2LINE=addr2line
> API=yes
> TEST_DIR=x86
> FIRMWARE=
> ENDIAN=
> PRETTY_PRINT_STACKS=yes
> ENVIRON_DEFAULT=yes
> ERRATATXT=errata.txt
> U32_LONG_FMT=
>

You need https://patchwork.kernel.org/patch/11284587/ for this issue. But
I just tried a latest qemu on x86 and see tests are hanging. So that may
not be enough to get you running.

drew

