Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A69E6A675C
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjCAFem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCAFel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:34:41 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C3118169
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:40 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id cj27-20020a056a00299b00b005f1ef2e4e1aso4916173pfb.6
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677648879;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y2/uC1tUUef+9sIKRmX0Xv6uHP+YTUxS5Yc+82//BfI=;
        b=UccyDP1G8YnW9m2hFOV8uJh3dDvO/XsoyJNizsu0I+ZsUEDVW76pjuxiRyzwxKeF9H
         uZttYaLNZa/JVh5Un++jJYL2335d8KTSD/6UyLymBXdJOaUUhwBdqWADoCfaSZkCKezF
         zJTP5NWfvJEq4vn7Jnhero6VnaOBrQJ57elQszv9TfHbFO8mmP/y/nlH2zTCOQ3mwMfP
         YapP22PGS++5t3bGM1CepOpl05wV+nMt2N0ArQidHtjGOJSWqZTo0sfN64gFrzjwdxVC
         QaoxEw3hGaijl7RZayQ1OKYLRX4VsZW/taNaoiyICpG7+ZGge2dX9YlYNvCHzq9Kxxdp
         d4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677648879;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y2/uC1tUUef+9sIKRmX0Xv6uHP+YTUxS5Yc+82//BfI=;
        b=xHBcLRErF28/GAc5rf6u2MCCfhu8byZ302OueL732SFP9TlN5aOiWWe8lG+TlgkZ0C
         BGxN5zI4H7DMhu+sAoxeDYIXxJfurZSXKKdW3u7bGhlYInZHPARr3/AZXRDL8gzPQhjZ
         7R8E8Dpayt7Sb2tPpJxblc4uMLePZ2aM31sKjFLlFKUSiL4pg4A/aFr/oREhNkDCvEVn
         Tw5YyR7QblLl3EzDV0XgGEGmwntZEA2zws1awGXdqvj5HUfKbeLet+3cnixzJPe9P/yR
         hNkzfIv8IwlKGLDFxeytSt527RspFK1LGKeZxei+W0yHb+F+FO1IE0mus2lo4K/bm6Q9
         Tg2A==
X-Gm-Message-State: AO0yUKWLmUOER5CfIVqd2xym1FL6/GQEcK4pBjAFve0o0MOnwGLRTOL7
        +jrhb6oKtlVpXjNXV8297Nq6BXIMRc410psn8YhNO5q8dB0QoZpzxeW7BjWXjlmrMG9L1cjwEF0
        WDwsUQU3/U0uG/38BoSIwfFIDE38FAO0sJAJLRXORQmO347yJNDLEBe/NH068NXn8cA2F
X-Google-Smtp-Source: AK7set/dodv9ZNKhcCTo9ziDdgoAfB5wbhA1We3SpLdv6JfuBdYRftPmeRDlX8gDdH5rVeQpe2TTUr26j4D8qaeo
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:485:b0:19a:f22b:31d4 with SMTP
 id jj5-20020a170903048500b0019af22b31d4mr1902741plb.7.1677648879103; Tue, 28
 Feb 2023 21:34:39 -0800 (PST)
Date:   Wed,  1 Mar 2023 05:34:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301053425.3880773-1-aaronlewis@google.com>
Subject: [PATCH 0/8] Add printf and formatted asserts in the guest
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the ucall framework to offer GUEST_PRINTF and GUEST_ASSERT_FMT
in selftests.  This allows the guest to use string formating for easier
debugging and richer assert messages.

I was originally going to send this series out as an RFC to demonstrate
two different ways of implementing prints in the guest (both through the
same ucall interface).  I ultimately decided against it because the other
approach had enough cons to convince me that this one is better.

As a quick overview on the approach I abondoned, it involved adding enough
support to the guest to allow it to call the LIBC version of vsprintf()
directly.  In order to do that a simple TLS segment had to be added to the
guest, AVX-512 needed to be enabled, and the loadable ELF segments needed
to be copied from the host.  This all seemed very intrusive to the guest.
I tried reducing this burden by getting the string functions to not
use AVX-512 instructions, unfortunately the complier flags I tried didn't
work.  Also, the approach used in this series is far less intrusive to
the guest anyway, so I abondoned it.

That exercise informed how I set up the selftest.  The selftest, aside
from using GUEST_PRINTF and GUEST_ASSERT_FMT, also checks XCR0 to show
that the prints work without AVX-512 being enabled.  Two things I
learned LIBC loves to do when using string functions is use the TLS and
call AVX-512 instructions.  Either of which will cause the test to either
crash or (unintentionally) assert.

I say unintentionally assert because the test ends with a formatted
assert firing.  This is intentional, and is meant to demonstrate the
formatted assert.

That is one reason I don't really expect the selftest to be accepted with
this series.  The other reason is it doesn't test anything in the kernel.
And if the selftest is not accepted then the first two patches can be
omitted too.  The core of the series are patches 3-7.

Patches 1-2:
 - Adds XGETBV/XSETBV and xfeature flags to common code.
 - Needed for the selftest added in the final commit.
 - Also included in:
     https://lore.kernel.org/kvm/20230224223607.1580880-1-aaronlewis@google.com/
 - Can be omitted from the final series along with the selftest.

Patches 3-5:
 - Adds a local version of vsprintf to the selftests for the guest.

Patches 6-7:
 - Adds GUEST_PRINTF and GUEST_ASSERT_FMT to the ucall framework.

Patch 8:
 - Adds a selftest to demonstrate the usage of prints and formatted
   asserts in the guest.
 - This test is a demo and doesn't have to be merged with this series,
   which also means patches 1 and 2 don't have to be merged either.

Aaron Lewis (8):
  KVM: selftests: Hoist XGETBV and XSETBV to make them more accessible
  KVM: selftests: Add XFEATURE masks to common code
  KVM: selftests: Add strnlen() to the string overrides
  KVM: selftests: Copy printf.c to KVM selftests
  KVM: selftests: Add vsprintf() to KVM selftests
  KVM: selftests: Add additional pages to the guest to accommodate ucall
  KVM: selftests: Add string formatting options to ucall
  KVM: selftests: Add a selftest for guest prints and formatted asserts

 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/include/test_util.h |   2 +
 .../selftests/kvm/include/ucall_common.h      |  20 ++
 .../selftests/kvm/include/x86_64/processor.h  |  36 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   4 +
 tools/testing/selftests/kvm/lib/printf.c      | 286 ++++++++++++++++++
 .../selftests/kvm/lib/string_override.c       |   9 +
 .../testing/selftests/kvm/lib/ucall_common.c  |  24 ++
 tools/testing/selftests/kvm/x86_64/amx_test.c |  46 +--
 .../selftests/kvm/x86_64/guest_print_test.c   | 100 ++++++
 10 files changed, 495 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/printf.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/guest_print_test.c

-- 
2.40.0.rc0.216.gc4246ad0f0-goog

