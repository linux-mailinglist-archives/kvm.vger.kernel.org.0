Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9352D4A547A
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 02:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbiBABI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 20:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiBABI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 20:08:57 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E249EC06173B
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 17:08:57 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id c2-20020a056a000ac200b004cc359dbb4eso7921434pfl.10
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 17:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+cGTUlncoKI8qOYBohRERc3y0sAWcqimeQBl8Ab9RTI=;
        b=e+kmca8jtulDGdN54BEXwgAQTzwVvQmOdxghFymavue4yUbH/JhbYwHShmg1mknAC6
         TGWIGxmq/jFX2ptfeKHdKOfDRmgEQ5v4CL5i0MZStw7TyXz0CKikehanAZ6q80gNqdkb
         Ln5rWelPLY+WQKzPp2vu9zFOh71C0LYNRNranTXX76/y2XvUFmFfGmEf/iVuidZzaps1
         CjSQiklb9jr+iJ0X5DmoXGzzY6x4s3D4XjdeLZJcY33tvhR/KBRMFbbVerGg86YRHTIL
         osbxNrDIlYlZl+1rA1VTn8E3fc1/sAuiWV221P8fbNWyWHM3ryGiW4oTC8AqpbxI3xiT
         Avcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+cGTUlncoKI8qOYBohRERc3y0sAWcqimeQBl8Ab9RTI=;
        b=uIwGRZTXt4drSWzpplQVMLhDP4sE5qnE3xZ6neTof4g20VYYgAWArjWlM801j98PTi
         GaRB2zAWHZQ2anLidE4xmEZr785ZvgBYdlPnCYj4Unf9ml700eI1B8nNyqX6Vc+PWJV0
         1D4n+A3tYutDXY13YcqIuGiN1i407+nwb0a4WxGhCdL7j9VEZEma82TsZoKLs4DxjI2M
         h6uzk1qxec1bI3Mp0txk8ROxkk6f3rpD2Lr2YlDbMTG5NIfVT7Jr7oLYxtE2KD/tgo7G
         Mo99rqbY8E5L1KutzFoWqrbqgyeZ+h3j80PNGfScXzSD4NllzpgtF9gV5SG0+RcokAqq
         UrZA==
X-Gm-Message-State: AOAM530Ng/c06Gxhtx0kgzdbVP77VvTPopW6YbqN1dpsLHyuRTiKgdUM
        64d8YyVywjbf/2eiswzQpDUGYbTEgvg=
X-Google-Smtp-Source: ABdhPJwCxixihN3pWoO3t60Sv6arP9CVtFwc3hJkZSrBPQ+/8LfdsTga0XZrersZPuDddjA//zRW0Ms6kc8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c086:: with SMTP id
 j6mr22888340pld.101.1643677736737; Mon, 31 Jan 2022 17:08:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  1 Feb 2022 01:08:34 +0000
In-Reply-To: <20220201010838.1494405-1-seanjc@google.com>
Message-Id: <20220201010838.1494405-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220201010838.1494405-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 1/5] Kconfig: Add option for asm goto w/ tied outputs to
 workaround clang-13 bug
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a config option to guard (future) usage of asm_volatile_goto() that
includes "tied outputs", i.e. "+" constraints that specify both an input
and output parameter.  clang-13 has a bug[1] that causes compilation of
such inline asm to fail, and KVM wants to use a "+m" constraint to
implement a uaccess form of CMPXCHG[2].  E.g. the test code fails with

  <stdin>:1:29: error: invalid operand in inline asm: '.long (${1:l}) - .'
  int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }
                            ^
  <stdin>:1:29: error: unknown token in expression
  <inline asm>:1:9: note: instantiated into assembly here
          .long () - .
                 ^
  2 errors generated.

on clang-13, but passes on gcc (with appropriate asm goto support).  The
bug is fixed in clang-14, but won't be backported to clang-13 as the
changes are too invasive/risky.

[1] https://github.com/ClangBuiltLinux/linux/issues/1512
[2] https://lore.kernel.org/all/YfMruK8%2F1izZ2VHS@google.com

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 init/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index e9119bf54b1f..a206b21703be 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -77,6 +77,10 @@ config CC_HAS_ASM_GOTO_OUTPUT
 	depends on CC_HAS_ASM_GOTO
 	def_bool $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
 
+config CC_HAS_ASM_GOTO_TIED_OUTPUT
+	depends on CC_HAS_ASM_GOTO_OUTPUT
+	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
+
 config TOOLS_SUPPORT_RELR
 	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

