Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719F0D4297
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 16:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbfJKOTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 10:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfJKOTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 10:19:09 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CAB218C428E;
        Fri, 11 Oct 2019 14:19:09 +0000 (UTC)
Received: from [10.36.117.27] (ovpn-117-27.ams2.redhat.com [10.36.117.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1ED9C100194E;
        Fri, 11 Oct 2019 14:19:07 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?B?THVrw6HFoSBEb2t0b3I=?= <ldoktor@redhat.com>
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <986a6fc2-ef7b-4df4-8d4e-a4ab94238b32@redhat.com>
Date:   Fri, 11 Oct 2019 16:19:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 11 Oct 2019 14:19:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.09.19 01:11, Bill Wendling wrote:
> Clang warns that passing an object that undergoes default argument
> promotion to "va_start" is undefined behavior:
> 
> lib/report.c:106:15: error: passing an object that undergoes default
> argument promotion to 'va_start' has undefined behavior
> [-Werror,-Wvarargs]
>          va_start(va, pass);
> 
> Using an "unsigned" type removes the need for argument promotion.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>   lib/libcflat.h | 4 ++--
>   lib/report.c   | 6 +++---
>   2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index b94d0ac..b6635d9 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -99,9 +99,9 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
>    __attribute__((format(printf, 1, 2)));
>   extern void report_prefix_push(const char *prefix);
>   extern void report_prefix_pop(void);
> -extern void report(const char *msg_fmt, bool pass, ...)
> +extern void report(const char *msg_fmt, unsigned pass, ...)
>    __attribute__((format(printf, 1, 3)));
> -extern void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
> +extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
>    __attribute__((format(printf, 1, 4)));
>   extern void report_abort(const char *msg_fmt, ...)
>    __attribute__((format(printf, 1, 2)))
> diff --git a/lib/report.c b/lib/report.c
> index ca9b4fd..7d259f6 100644
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -81,7 +81,7 @@ void report_prefix_pop(void)
>   }
> 
>   static void va_report(const char *msg_fmt,
> - bool pass, bool xfail, bool skip, va_list va)
> + unsigned pass, bool xfail, bool skip, va_list va)
>   {
>    const char *prefix = skip ? "SKIP"
>      : xfail ? (pass ? "XPASS" : "XFAIL")
> @@ -104,7 +104,7 @@ static void va_report(const char *msg_fmt,
>    spin_unlock(&lock);
>   }
> 
> -void report(const char *msg_fmt, bool pass, ...)
> +void report(const char *msg_fmt, unsigned pass, ...)
>   {
>    va_list va;
>    va_start(va, pass);
> @@ -112,7 +112,7 @@ void report(const char *msg_fmt, bool pass, ...)
>    va_end(va);
>   }
> 
> -void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
> +void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
>   {
>    va_list va;
>    va_start(va, pass);
> 

This patch breaks the selftest on s390x:

t460s: ~/git/kvm-unit-tests (kein Branch, Rebase von Branch master im Gange) $ ./run_tests.sh 
FAIL selftest-setup (14 tests, 2 unexpected failures)

t460s: ~/git/kvm-unit-tests (kein Branch, Rebase von Branch master im Gange) $ cat logs/selftest-setup.log 
timeout -k 1s --foreground 90s /usr/bin/qemu-system-s390x -nodefaults -nographic -machine s390-ccw-virtio,accel=tcg -chardev stdio,id=con0 -device sclpconsole,chardev=con0 -kernel s390x/selftest.elf -smp 1 -append test 123 # -initrd /tmp/tmp.JwIjS9RWlv
PASS: selftest: true
PASS: selftest: argc == 3
PASS: selftest: argv[0] == PROGNAME
PASS: selftest: argv[1] == test
PASS: selftest: argv[2] == 123
PASS: selftest: 3.0/2.0 == 1.5
PASS: selftest: Program interrupt: expected(1) == received(1)
PASS: selftest: Program interrupt: expected(5) == received(5)
FAIL: selftest: malloc: got vaddr
PASS: selftest: malloc: access works
FAIL: selftest: malloc: got 2nd vaddr
PASS: selftest: malloc: access works
PASS: selftest: malloc: addresses differ
PASS: selftest: Program interrupt: expected(5) == received(5)
SUMMARY: 14 tests, 2 unexpected failures

EXIT: STATUS=3



A fix for the test would look like this:

diff --git a/s390x/selftest.c b/s390x/selftest.c
index f4acdc4..dc1c476 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -49,9 +49,10 @@ static void test_malloc(void)
        *tmp2 = 123456789;
        mb();
 
-       report("malloc: got vaddr", (uintptr_t)tmp & 0xf000000000000000ul);
+       report("malloc: got vaddr", !!((uintptr_t)tmp & 0xf000000000000000ul));
        report("malloc: access works", *tmp == 123456789);
-       report("malloc: got 2nd vaddr", (uintptr_t)tmp2 & 0xf000000000000000ul);
+       report("malloc: got 2nd vaddr",
+              !!((uintptr_t)tmp2 & 0xf000000000000000ul));
        report("malloc: access works", (*tmp2 == 123456789));
        report("malloc: addresses differ", tmp != tmp2);


But I am not sure if that is the right fix.

(why don't we run sanity tests to detect that, this tests works
just fine with s390x TCG)

-- 

Thanks,

David / dhildenb
