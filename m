Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3264A6588
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 21:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239130AbiBAURI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 15:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239059AbiBAURH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 15:17:07 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12241C06173B
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 12:17:06 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id q127so25793316ljq.2
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 12:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f3bcsAklugUA8X5S8eqHouC9oaHAaVuRIrrTe+rJW24=;
        b=Kyj6Bc9QCO+JV2e2BYCdvw63ME+XVX7mD1L0xBJ/nJR7GpK9LZTXleDRaKPB68Hxqf
         NF3WNVeqUx6R8F54VtcOKlozz9fWtsQTPFA/AD1Pn0jyl7Lj1dKaXDHiOb1YWkjeoGoJ
         MtGMRnHvg7Z5dGCMlqb/pWt0QVDxwvRARjEk0xuXalkpvBZpFsZDM3SWTGZT17z6jwOS
         lh3I5vIbaqNcWcZoxrH1NQILkUplY21IAs+EM9cLeg2p5s25+9obBeljDVfK+Hws4w3J
         hK5/clJiK6Qu5YhvtVndyA1SEURtS0GIwvwz9ztDT22zdvvM/9IxjtIRXHGgvTG8fflo
         UsOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f3bcsAklugUA8X5S8eqHouC9oaHAaVuRIrrTe+rJW24=;
        b=Pbq31KvEfQbr+6XyKEds9qP3bGiINGTusZXOJUpkt3PIjvftqwofxDAOeukZaOrHdA
         bHYv6dFO5ZFj6T5PcyTyJz4+xARUAvRIbw49fNnq4qcqNxANc70ZUHjv3/mK/Q+jYxAK
         6VeOZjfdPtV2z7LdIwc5dPCMEan33vktJs5s/XmhYDOk5W1sZg8V047v03NQb28LTEmQ
         KfGIFGk0onbc+TCvyEgZBsij/ShQ211JNy8XS4FEECU4YSBPSkfuTlfIGa+Xk2G5OJ5K
         6j4IhMTDTYPR34LM+gyhpoyWu4T9tRmWlKFz9Cj3qW52+E66dV0H9DHAdTm6zGaLvVdh
         Q94w==
X-Gm-Message-State: AOAM532tlLpvLEozHC6ooHf69QHAe55EwP+KE6Mf1sZkNJkVyTLetFPM
        GnG2b93X21Bkf1TQ8clXv2NekXVj63lmY3JrzYVy5Q==
X-Google-Smtp-Source: ABdhPJyjkIdvcR7h9sTh/jFdfLCfqLgmMdmefPijoRUk1ZPBatDBaznmuG2+rrSk2e+yl8Dtm+jGInhyLkuUyY9YRjA=
X-Received: by 2002:a2e:954:: with SMTP id 81mr8682225ljj.198.1643746624322;
 Tue, 01 Feb 2022 12:17:04 -0800 (PST)
MIME-Version: 1.0
References: <20220201010838.1494405-1-seanjc@google.com> <20220201010838.1494405-2-seanjc@google.com>
In-Reply-To: <20220201010838.1494405-2-seanjc@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 1 Feb 2022 12:16:52 -0800
Message-ID: <CAKwvOd=9nwR7z7wn50SU=mf5AywFLd95ZMH-EbYdHfbeHVvq1A@mail.gmail.com>
Subject: Re: [PATCH 1/5] Kconfig: Add option for asm goto w/ tied outputs to
 workaround clang-13 bug
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
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

On Mon, Jan 31, 2022 at 5:08 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Add a config option to guard (future) usage of asm_volatile_goto() that
> includes "tied outputs", i.e. "+" constraints that specify both an input
> and output parameter.  clang-13 has a bug[1] that causes compilation of
> such inline asm to fail, and KVM wants to use a "+m" constraint to
> implement a uaccess form of CMPXCHG[2].  E.g. the test code fails with
>
>   <stdin>:1:29: error: invalid operand in inline asm: '.long (${1:l}) - .'
>   int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }
>                             ^
>   <stdin>:1:29: error: unknown token in expression
>   <inline asm>:1:9: note: instantiated into assembly here
>           .long () - .
>                  ^
>   2 errors generated.
>
> on clang-13, but passes on gcc (with appropriate asm goto support).  The
> bug is fixed in clang-14, but won't be backported to clang-13 as the
> changes are too invasive/risky.

LGTM.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

If you're going to respin the series, consider adding a comment in the
source along the lines of:
```
clang-14 and gcc-11 fixed this.
```
or w/e. This helps us find (via grep) and remove cruft when the
minimum supported compiler versions are updated.

Note: gcc-10 had a bug with the symbolic references to labels when
using tied constraints.
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=98096

Both compilers had bugs here, and it may be worth mentioning that in
the commit message.

>
> [1] https://github.com/ClangBuiltLinux/linux/issues/1512
> [2] https://lore.kernel.org/all/YfMruK8%2F1izZ2VHS@google.com
>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  init/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index e9119bf54b1f..a206b21703be 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -77,6 +77,10 @@ config CC_HAS_ASM_GOTO_OUTPUT
>         depends on CC_HAS_ASM_GOTO
>         def_bool $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
>
> +config CC_HAS_ASM_GOTO_TIED_OUTPUT
> +       depends on CC_HAS_ASM_GOTO_OUTPUT
> +       def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
> +
>  config TOOLS_SUPPORT_RELR
>         def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
>
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>


-- 
Thanks,
~Nick Desaulniers
