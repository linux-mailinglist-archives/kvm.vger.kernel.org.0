Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA60670F9
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfGLOG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbfGLOG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:06:59 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C45D8307CDEA;
        Fri, 12 Jul 2019 14:06:58 +0000 (UTC)
Received: from redhat.com (ovpn-117-198.ams2.redhat.com [10.36.117.198])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E62DA5DABA;
        Fri, 12 Jul 2019 14:06:57 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PULL 00/19] Migration patches
In-Reply-To: <CAFEAcA8uwgmV47Dt8e=ZRLzssXKWn+1DivDFEuN5s2+N1FJX3w@mail.gmail.com>
        (Peter Maydell's message of "Thu, 11 Jul 2019 13:39:50 +0100")
References: <20190711104412.31233-1-quintela@redhat.com>
        <CAFEAcA8uwgmV47Dt8e=ZRLzssXKWn+1DivDFEuN5s2+N1FJX3w@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Fri, 12 Jul 2019 16:06:53 +0200
Message-ID: <878st38hz6.fsf@trasno.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 12 Jul 2019 14:06:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Maydell <peter.maydell@linaro.org> wrote:
> On Thu, 11 Jul 2019 at 11:56, Juan Quintela <quintela@redhat.com> wrote:
>>
>> The following changes since commit 6df2cdf44a82426f7a59dcb03f0dd2181ed7fdfa:
>>
>>   Update version for v4.1.0-rc0 release (2019-07-09 17:21:53 +0100)
>>
>> are available in the Git repository at:
>>
>>   https://github.com/juanquintela/qemu.git tags/migration-pull-request
>>
>> for you to fetch changes up to 0b47e79b3d04f500b6f3490628905ec5884133df:
>>
>>   migration: allow private destination ram with x-ignore-shared
>> (2019-07-11 12:30:40 +0200)
>>
>> ----------------------------------------------------------------
>> Migration pull request
>>
>> ----------------------------------------------------------------
>
> Hi; this fails "make check" on aarch32 host (possibly a general
> 32-bit host issue, as this is the only 32-bit host I test on):
>
> MALLOC_PERTURB_=${MALLOC_PERTURB_:-$(( ${RANDOM:-0} % 255 + 1))}
> tests/test-bitmap -m=quick -k --tap < /dev/null |
> ./scripts/tap-driver.pl --test-name="test-bitmap"
> **
> ERROR:/home/peter.maydell/qemu/tests/test-bitmap.c:39:check_bitmap_copy_with_offset:
> assertion failed (bmap1 == bmap2)
> Aborted
> ERROR - Bail out!
> ERROR:/home/peter.maydell/qemu/tests/test-bitmap.c:39:check_bitmap_copy_with_offset:
> assertion failed (bmap1 == bmap2)
> /home/peter.maydell/qemu/tests/Makefile.include:904: recipe for target
> 'check-unit' failed

Problem fixed, the code is right (TM), the test is wrong (also TM).

@@ -35,8 +36,8 @@ static void check_bitmap_copy_with_offset(void)
     /* Shift back 200 bits back */
     bitmap_copy_with_src_offset(bmap2, bmap3, 200, total);
 
-    g_assert_cmpmem(bmap1, total / sizeof(unsigned long),
-                    bmap2, total / sizeof(unsigned long));
+    g_assert_cmpmem(bmap1, total / BITS_PER_LONG,
+                    bmap2, total / BITS_PER_LONG);
 
     bitmap_clear(bmap1, 0, BMAP_SIZE);
     /* Set bits in bmap1 are 100-245 */


A long has 32 or 64 bits, not 4 or 8.

And why it worked in 64 bit?  Due to (bad?) luck.  64 bit is bigger, and
then it "overwrote" everypthing, and then it ends being zero on
destination by luck.

Resending.

Later, Juan.
