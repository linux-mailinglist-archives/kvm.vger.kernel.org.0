Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86992DF1A1
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 17:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfJUPdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 11:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbfJUPdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 11:33:40 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0652359451
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 15:33:40 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id z5so3276464wma.5
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jW0wmcy6qkQ0RW5vNPiq+emhshwwv10KB07Z/LD6g4o=;
        b=AZIyEA+HHViJjBk9rfKcIER/9nCcZdPHtr0oY8hc70f6mDCYMAGXheniIEHGKTBXst
         wuPxNYtWkdcvUVATh3DviuY3fJyxZptbe0fGezqIba2AEpQq1BcbnKYfbaL5tpFD2QZ7
         pfl0Tf4tcqCDTvD4/n7kiCo86QXqbeGsC46tP9qyZvdcDE6Rp8LaOqLXHS2VV9RqYNFR
         traGV7Z0IC3ZoqhMj3iEzdEvBCOV+DTyI+nVXsL71Q/O9QYvyeu21wV8L4R+8m0IkhfI
         lWVImNXkWoH4v9HZ7C0oFmLtQi/QKteWVwDPDs3Reo4OBUBJvCNEl1mUBKtD+AkzIUfb
         f33A==
X-Gm-Message-State: APjAAAUmdZGQPXt/gT0QNW36rtXb9yS5qsS90CLA7aeXAztevtYwZjIO
        uwI9COo9Wd6Ovr1e1X9UtM3VhhugoM1pWkVXNLoMdgXWR4YiL7mN+mfg+BgIgowvIVU6NHq0sea
        h3I2MIYMGNkeg
X-Received: by 2002:adf:ea01:: with SMTP id q1mr19738168wrm.240.1571672018504;
        Mon, 21 Oct 2019 08:33:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwXKEjiV2cyIjaS4iP0DeRR3D2hFlNYwXanegb+xlahv/kGIB7IpfbKFcslG+it22bFm9XJGw==
X-Received: by 2002:adf:ea01:: with SMTP id q1mr19738147wrm.240.1571672018187;
        Mon, 21 Oct 2019 08:33:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id r13sm24784546wra.74.2019.10.21.08.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:33:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests v2 PATCH 2/2] x86: don't compare two global
 objects' addrs for inequality
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        alexandru.elisei@arm.com, thuth@redhat.com
Cc:     jmattson@google.com
References: <20191012074454.208377-1-morbo@google.com>
 <20191015204603.47845-1-morbo@google.com>
 <20191015204603.47845-3-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1bdb4560-3abf-1494-060b-e462d48f551e@redhat.com>
Date:   Mon, 21 Oct 2019 17:33:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015204603.47845-3-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 22:46, Bill Wendling wrote:
> Two global objects can't have the same address in C. Clang uses this
> fact to omit the check on the first iteration of the loop in
> check_exception_table. Avoid compariting inequality by using less-than.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/x86/desc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 451f504..4002203 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -113,7 +113,7 @@ static void check_exception_table(struct ex_regs *regs)
>  		(((regs->rflags >> 16) & 1) << 8);
>      asm("mov %0, %%gs:4" : : "r"(ex_val));
>  
> -    for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
> +    for (ex = &exception_table_start; ex < &exception_table_end; ++ex) {
>          if (ex->rip == regs->rip) {
>              regs->rip = ex->handler;
>              return;
> 

Queued, thanks.

Paolo
