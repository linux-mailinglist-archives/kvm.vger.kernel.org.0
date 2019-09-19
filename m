Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEEE5B8244
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 22:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403860AbfISULG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 16:11:06 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46911 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392383AbfISULG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 16:11:06 -0400
Received: by mail-io1-f66.google.com with SMTP id d17so10694094ios.13
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 13:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=huuyT7UhL4LtbgEK4KafTswtAHXCVT6GC89SV33vdF8=;
        b=v4q1lQuZP7djpPFRZAqaZNVGbsFEOlSb14F9LjDLvRbHyIakRBGHb9c3Eq8cOqJ567
         bsqFZ5tiMbkbEwl5ClbFwRFiHz5WMCxYuNeL5qxqnwgEJOzcNNIyY1SH1/uR61ue+b5Q
         z2XbWGyMIj0GCNPZCwSIBoY+368OOHdX3b0fQ2+Rirv04eKDuTYSHtDwqNA6qeKZE8eS
         pNluZxMIwe1Zi7ww3opJRh7xbfVI1xBhITfIv7g8ELq+n71csMfHY+4JThQIG5hB4xF2
         EB2pxR3ATDXVwNMdYXQGUvnJmHTmhAuZTnWIRExUVEvsm4xxieOdwhQPItyDdU4Brggk
         lSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=huuyT7UhL4LtbgEK4KafTswtAHXCVT6GC89SV33vdF8=;
        b=K+Pg5xOo60qn/DSVsAzxVslKWL5Bwdu74TIS4UGwMBT5yr2Ddutbf/GyDv5e5BaiVB
         1SAYjfiPv3vJS62edMeF9HhbXeMP/1EvOTYsnQ+vuWjFHhvWc5Rqb3a4e3PHe66Thru1
         dwjPzPxxJAKh0Kzkfa6LcGZLFlTra9sXWZe8rx/xWw95qa0hm7AYAF1YvWtFMdwa/reY
         33TIOi1PeKyqJXblQhHX48MNAU89NaxzyA0PLKozp3oAWFUvYg/CDHd5X80E819sMLk+
         dpEyBRO1VT2FZj8iY3KdAeSgUhswFeFKtUnpzchuzDnPIsm5paRXcKXY9AIpX8hBQ/b3
         R38Q==
X-Gm-Message-State: APjAAAVVHVPB0w33b7dVwskkmg5oIUrLhIdibeHuPdkrJRfEUykohzay
        asufEgazmM7J/XcgIM6W/59hKJsmVhDmwe8xjnhSnw==
X-Google-Smtp-Source: APXvYqwCl7O6Hh4jCkDl5D4BdR2+sL/EKdp7li0kbHvvFV+6fY2bL7yoxmJcOTQJGhKnFfDdmovyGo7ukzO+MnPY0oU=
X-Received: by 2002:a6b:4117:: with SMTP id n23mr6246501ioa.119.1568923863651;
 Thu, 19 Sep 2019 13:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190911023142.85970-1-morbo@google.com>
In-Reply-To: <20190911023142.85970-1-morbo@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 19 Sep 2019 13:10:52 -0700
Message-ID: <CALMp9eQshrTgD7m7=+U7kLkfZ4Gh3dh9BPHzoaTVmHEckxfJsQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: setjmp: check expected value of "i"
 to give better feedback
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 7:32 PM Bill Wendling <morbo@google.com> wrote:
>
> Use a list of expected values instead of printing out numbers, which
> aren't very meaningful. This prints only if the expected and actual
> values differ.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/setjmp.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/x86/setjmp.c b/x86/setjmp.c
> index 976a632..c0b25ec 100644
> --- a/x86/setjmp.c
> +++ b/x86/setjmp.c
> @@ -1,19 +1,30 @@
>  #include "libcflat.h"
>  #include "setjmp.h"
>
> +int expected[] = {
> +       0, 1, 2, 3, 4, 5, 6, 7, 8, 9
> +};
> +
> +#define NUM_EXPECTED (sizeof(expected) / sizeof(int))
> +
>  int main(void)
>  {
> -    volatile int i;
> +    volatile int i = -1, index = 0;
> +    volatile bool had_errors = false;
>      jmp_buf j;
>
>      if (setjmp(j) == 0) {
>             i = 0;
>      }
> -    printf("%d\n", i);
> -    if (++i < 10) {
> +    if (expected[index++] != i) {
> +           printf("FAIL: actual %d / expected %d\n", i, expected[index]);
> +            had_errors = true;
> +    }
> +    if (index < NUM_EXPECTED) {
> +           i++;
>             longjmp(j, 1);
>      }
>
> -    printf("done\n");
> +    printf("Test %s\n", had_errors ? "FAILED" : "PASSED");
>      return 0;
>  }
> --
> 2.23.0.162.g0b9fbb3734-goog
Acked-by: Jim Mattson <jmattson@google.com>
