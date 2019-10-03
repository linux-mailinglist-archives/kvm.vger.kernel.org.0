Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF91BCA11B
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 17:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfJCPXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 11:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729991AbfJCPXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 11:23:34 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25F4989AC2
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 15:23:34 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id z1so1247055wrw.21
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 08:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qoKp+Xu3p0rV9GLZTHe3NuxMOYdJi2iigLcisiBAhlw=;
        b=BdUlB3bqb/Chx6FYgQdZ67153DE0kkSAfOXOIDpYWXonBUuWBk9Mii+FqyPc/ALgT8
         UZg9iz3ae9MMCgJcEfKTBbwXlQYsWsNkcLj7Hh0kbboD/+xBuf0gQRFrA1iMHUbFE0Lk
         Zx7p3UFWcW3O7mxDXG2SiIBKJxOzQ0ys1HcVrFO7RmApZYNOfgm8qV2LUdjwX0IH0QHB
         ykbhWsN6n1qwlMcN2s8WRHq787JtVs2pnKQaWIrWSz0Cs0DOqeuRtQIoxm7hD8CyqWut
         uIe3hsnq293OfBWaZuCHZTwMI1g5zpBcCZAsbSxyVGAM0ruZB4TvZ7Yf+sevAtbseRr2
         7tnw==
X-Gm-Message-State: APjAAAXBUIcS1z0BO8swnM7ewGvKNXKUqKL89PmqtkkKhj6iGoE8Wlkh
        +ufQYs21/emfTFdTkIXMFogf/GrxB0EVyxJINRmRGZTlduqRFvOzdeypKcAcQS/CeQLOTtFjlfP
        M62QdFaL3fn/g
X-Received: by 2002:adf:f68f:: with SMTP id v15mr4862280wrp.210.1570116212661;
        Thu, 03 Oct 2019 08:23:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwf/S5FwN3UK05IGT7/7YINNuBSZbZPYZrLMoJ2uKa2XDj8pX1CjOyKNDlcK9UuuCn41Wtrjw==
X-Received: by 2002:adf:f68f:: with SMTP id v15mr4862264wrp.210.1570116212388;
        Thu, 03 Oct 2019 08:23:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id t83sm3979935wmt.18.2019.10.03.08.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 08:23:31 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] svm: Fixed error code comparison in test
 npt_rsvd_pfwalk
To:     Cathy Avery <cavery@redhat.com>, kvm@vger.kernel.org
References: <20191003123845.2895-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redhat.com>
Date:   Thu, 3 Oct 2019 17:23:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003123845.2895-1-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 14:38, Cathy Avery wrote:
> According to the AMD64 spec Bit 3 (RSV) in exitinfo1 should be set
> to 1 if reserved bits were set in the corresponding nested page
> table entry. Exitinfo1 should be checking against error code
> 0x20000000eULL not 0x200000006ULL.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  x86/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index bc74e7c..bb39934 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -1066,7 +1066,7 @@ static bool npt_rsvd_pfwalk_check(struct test *test)
>      pdpe[0] &= ~(1ULL << 8);
>  
>      return (test->vmcb->control.exit_code == SVM_EXIT_NPF)
> -            && (test->vmcb->control.exit_info_1 == 0x200000006ULL);
> +            && (test->vmcb->control.exit_info_1 == 0x20000000eULL);
>  }
>  
>  static void npt_l1mmio_prepare(struct test *test)
> 

Queued, thanks.

Paolo
