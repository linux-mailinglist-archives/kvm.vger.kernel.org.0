Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C9F170E31
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 03:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgB0CFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 21:05:17 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41247 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbgB0CFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 21:05:17 -0500
Received: by mail-lj1-f195.google.com with SMTP id h23so1434600ljc.8
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 18:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Mks7WPIStX26xKT4utK5SMfh3XCSfplCi0QhdyUu/c=;
        b=rQAMcf/Qhdk6xfj3sTTruTtohWc/FUBhJozCEVzjpRNC9aCVKSIW2i03xJtZC3MxeL
         7OplH0X3ik1yEVZB36DOGfc69VXiYwgaAaaGXl3u8m+gvDCGll73+u0Mg6DQxOh4ONMl
         PCuPx3PGUM8dtct6aV+dq86/vonrByU34+GV/sWge3HzhUmbRtTgtQVPC6WpHGOAMFm1
         z4VxF9V0GU2oe2WbhlAG8h0ekumZATs1JQLIQGmEPkhCRBhkAGUj0xE2+ooZ6yRdkKjr
         qc+snK1LdyjjMGyjZ1y5cRSgcwqQX4ep1Rg2MUfYT5jzct+UJ4sKsUBZVELopj7JlkMG
         wR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Mks7WPIStX26xKT4utK5SMfh3XCSfplCi0QhdyUu/c=;
        b=Qn7EuUj2vJ61o8cZlxY6Kd/S8N7wRpQTSHQ0WxaqHVKN2IQeBTSL9PdwrfztPzxlFj
         FVndMJWBsKN85lIrVYInP+WTFo4UwBJkeSovP2D5K05HCTmmQctIwDMV4cfqZzSG+BQh
         Oyi28GOH+i57V+yqs82pkVbGOzcdotlHt2MN2uNscUD+jcTIdFp18MZZK7AvJCAx7sok
         CRWF6iclNvfSXhdCvWsh97bXqu4bmb48op7bMg/jA6azaaJuGNykXj4KhP1X4tw0Y+9D
         tMDYAW4p5K2PnzSd9gvx8Md5nFwsKNCcKDnWMdXJDaYiIGICsf+FAIOJdrVsGABC9x5c
         BEqg==
X-Gm-Message-State: ANhLgQ3XfkMMmhJv1dRHSlG69oMyh3+Afml/JrFON16ku85AFn/Rchr1
        L+x1Jr47VxttWS1hODOiY9lpkp6avEJpoqMMLTwLzw==
X-Google-Smtp-Source: ADFU+vsvhEzOA6YS7FiPKv57LLJy0iOvCytWDxUP3hgyW7EFSD2uPGdIEwOvU+ik5Dnx25ek2VvalQLtbXlZ1fbGdXM=
X-Received: by 2002:a2e:8711:: with SMTP id m17mr1173536lji.284.1582769114695;
 Wed, 26 Feb 2020 18:05:14 -0800 (PST)
MIME-Version: 1.0
References: <20200226094433.210968-1-morbo@google.com> <20200226201243.86988-1-morbo@google.com>
 <20200226201243.86988-8-morbo@google.com>
In-Reply-To: <20200226201243.86988-8-morbo@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 26 Feb 2020 18:05:03 -0800
Message-ID: <CAOQ_Qsg9GyoX3R+wgJfgD18LkOfwXLvGgijJ-2=vzJm-WRqhYg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 7/7] x86: VMX: the "noclone" attribute
 is gcc-specific
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, drjones@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bill,

Perhaps it would be better to drill down the noclone attribute by GCC
version as well. May I suggest the following?

diff --git a/lib/compiler.h b/lib/compiler.h
new file mode 100644
index 000000000000..5cbcda94b0fe
--- /dev/null
+++ b/lib/compiler.h
@@ -0,0 +1,12 @@
+#ifndef _LIB_COMPILER_H_
+#define _LIB_COMPILER_H_
+
+#if GCC_VERSION >= 40500
+#define __noclone      __attribute__((__noclone__, __optimize__("no-tracer")))
+#endif /* GCC_VERSION >= 40500 */
+
+#if !defined(__noclone)
+#define __noclone
+#endif
+
+#endif /* _LIB_COMPILER_H_ */
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0e2c2f8a7d34..2dfc010d5d49 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5,6 +5,7 @@
  */

 #include <asm/debugreg.h>
+#include <compiler.h>

 #include "vmx.h"
 #include "msr.h"
@@ -4974,7 +4975,7 @@ extern unsigned char test_mtf1;
 extern unsigned char test_mtf2;
 extern unsigned char test_mtf3;

-__attribute__((noclone)) static void test_mtf_guest(void)
+__noclone static void test_mtf_guest(void)
 {
        asm ("vmcall;\n\t"
             "out %al, $0x80;\n\t"
-- 
Thanks,
Oliver

On Wed, Feb 26, 2020 at 12:13 PM Bill Wendling <morbo@google.com> wrote:
>
> Don't use the "noclone" attribute for clang as it's not supported.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/vmx_tests.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index ad8c002..ec88016 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4976,7 +4976,10 @@ extern unsigned char test_mtf1;
>  extern unsigned char test_mtf2;
>  extern unsigned char test_mtf3;
>
> -__attribute__((noclone)) static void test_mtf_guest(void)
> +#ifndef __clang__
> +__attribute__((noclone))
> +#endif
> +static void test_mtf_guest(void)
>  {
>         asm ("vmcall;\n\t"
>              "out %al, $0x80;\n\t"
> --
> 2.25.1.481.gfbce0eb801-goog
>
