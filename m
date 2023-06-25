Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292B273D527
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 01:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjFYXHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 19:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjFYXHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 19:07:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B67F1BE
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:48 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-544c0d768b9so2328513a12.0
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687734468; x=1690326468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vfmqHhQfkj9wC5y9/5OT1WX/hmOglQnl+4M6B/wqw8Q=;
        b=S776eYOJGIf7CwEDDfYfATHy9A1TlgYbn8wbW+TPiSHW0EcypEhxakbQberham4ku1
         l0i+S/qpkhCwbf1GbimM/m7DN50hfk8OOn5ex4FeHtg+c/Hk9M2Eb/ivqSzy/InniVH9
         bXdoO/0xBD58ho+gZUU6mSTZTO07tANHjRf5d/Pk2AS0MHUP9NrD9lFVuJJK10JHfuTP
         gNVB2/YG4HTwZcXvdGRQwYcmr9g6NrJb1nkSPKZK5SvB97Y5RFh/7tEuIKiRGHYPblbO
         4u5Jw2+HN99/sbv26YQo3ZUt8TBUX76MZf8JYUBgQBGF5kKXN5OKNglP4wEbl2s18Hj/
         JZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687734468; x=1690326468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vfmqHhQfkj9wC5y9/5OT1WX/hmOglQnl+4M6B/wqw8Q=;
        b=YqLHEDnLmxkHlYZDLwqVpwpu9wbPuUhqSm+cxjAaA800d5bwzVn5G4e/8nK3S/Ua8K
         wnub3bcARtQeRIYoH3vgTH/iMuoIbxk58Pg0EvhpTUnR0uRPU7iG4jWrSDlw9FWlby94
         IwiZ/PrH6SbZim5nPCRZT3aTIWTIl6K7SI/Ul9sz3QB/MdlrESFFL16P4pv1Vznt1s2k
         585fXGUq4obEBjYXd/2Ftmxvg5b/LVjeS9RG1LokMAXB+X/A+sx3Y5rftWJcT2ch4XDq
         //ZU1KO07a28MNVQfhWEUBlHkicjAhsNOKr7fKm/9juuXApIxp9WQXVjdApR5AY1+OQC
         MgBA==
X-Gm-Message-State: AC+VfDxBXOzifDP9Noz0hJIJCRRsNW7d8iP3UpvUn9Av1d1K1/O12Mm7
        xOycr1izVsbcHYfl3h3ZVxYeW/ZHeMQ=
X-Google-Smtp-Source: ACHHUZ7Mm+1kxGkAESQaQXiARzivg+Gp3MSHekPBONhiuqLGDZQkz6zhBpxUCwrRX8SkdMrmUlknig==
X-Received: by 2002:a05:6a20:8427:b0:10a:e9ff:808d with SMTP id c39-20020a056a20842700b0010ae9ff808dmr37725342pzd.0.1687734467528;
        Sun, 25 Jun 2023 16:07:47 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b006668f004420sm2716397pfa.148.2023.06.25.16.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 16:07:46 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v2 0/6] arm64: improve debuggability
Date:   Sun, 25 Jun 2023 23:07:10 +0000
Message-Id: <20230625230716.2922-1-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

My recent experience in debugging ARM64 tests on EFI was not as fun as I
expected it to be.

There were several reasons for that besides the questionable definition
of "fun":

1. ARM64 is not compiled with frame pointers and there is no stack
   unwinder when the stack is dumped.

2. Building an EFI drops the debug information.

3. The addresses that are printed on dump_stack() and the use of GDB
   are hard because taking code relocation into account is non trivial.

The patches help both ARM64 and EFI for this matter. The image address
is printed when EFI is used to allow the use of GDB. Symbols are emitted
into a separate debug file. The frame pointer is included and special
entry is added upon an exception to allow backtracing across
exceptions.

v1->v2:
* Andrew comments [see in individual patches]
* Few cleanups

Nadav Amit (6):
  efi: keep efi debug information in a separate file
  lib/stack: print base addresses on efi
  arm64: enable frame pointer and support stack unwinding
  arm64: stack: update trace stack on exception
  efi: print address of image
  arm64: dump stack on bad exception

 arm/Makefile.arm        |  3 --
 arm/Makefile.arm64      |  1 +
 arm/Makefile.common     |  8 +++++-
 arm/cstart64.S          | 13 +++++++++
 configure               |  3 ++
 lib/arm64/asm-offsets.c |  6 +++-
 lib/arm64/asm/stack.h   |  3 ++
 lib/arm64/processor.c   |  1 +
 lib/arm64/stack.c       | 62 +++++++++++++++++++++++++++++++++++++++++
 lib/efi.c               |  4 +++
 lib/stack.c             | 31 +++++++++++++++++++--
 x86/Makefile.common     |  5 +++-
 12 files changed, 132 insertions(+), 8 deletions(-)
 create mode 100644 lib/arm64/stack.c

-- 
2.34.1

