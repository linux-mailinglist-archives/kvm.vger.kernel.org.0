Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8821658CC29
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 18:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244054AbiHHQcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 12:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244043AbiHHQcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 12:32:12 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45E5E084
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 09:32:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p8so8987499plq.13
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 09:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=zdnIMMRn/tmCkhrQbu7Gzy2kj/CPlvHj3RNCw+uYd60=;
        b=MtXSfoUNxFGPZ/E4xNtpVrNK9V609BTQ/z7qf9+deCwjoRygTEISksjrk+MpzL8jb0
         kFPAL36w2LDMJVBZ5pGqugSo+HZGHvf0b5HtDe34jzKdB0xDf2XjGISxx+Y0UUA3tdP5
         yc0jvKx0eHDRl9U6gSwFlxDvMKIV1qmoJbT7TckBMs7uJLqnWysngmm3Nfa2xyWtkT/T
         s2Z4KXBRr1rvq+wRCDlGlXz2lDsKM4dKTB1O76Crqdwp7y8l8RSIc9LToJs361fmuRp+
         YWQmEc48qK6S/IkhA5MPzNyZrPLM1h31+JgiiF0R0i/SqRYfuJiqK31J9JhWhyixe50Z
         65jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=zdnIMMRn/tmCkhrQbu7Gzy2kj/CPlvHj3RNCw+uYd60=;
        b=yc04RKlfuKQmGfirtyscfjLNIiMTp/I9KLg1OBvVnYAWJpftxb8dBXlQ0z/a8kOgkI
         sLxoWsvFmjb2WdLdVE5A8/50WrUoRMjYl8M16Q2CAFvFccQ5N1cD/dCdkFReGfCEkhev
         NXno0ikv8XEHrRGysytmHL4q4bsr3fXCt+9hETu9F5YPvcb4jtxBXo8P/U2Xr8zzYriS
         BMdbZkJDAbDQBdGdFKs29/rr9jzYrf8WtdJFSqmAHB5fepnv2mL8DPs4XUw3co7MkLDF
         AuWnKPFOzCRPOoOsPBroLcfuSd32+OfBkf30EUgM7x740EwwVeW37TCLVldIkvP7buqD
         HrAw==
X-Gm-Message-State: ACgBeo17Qb69UKZvDc78IsWRx4hl71cagFh/4WJ90utyDfEeDofaVQLW
        F/1qHqRJkPTkFUpuAIXaXK0x4A==
X-Google-Smtp-Source: AA6agR7UFdytmbBSvBpdzd8aGjAkNtq448DTXUUQXiwfNx3SAJ7mMEOdzhKfZ97vbexhCKQYWOfw4g==
X-Received: by 2002:a17:90b:1bcf:b0:1f5:53cf:c01d with SMTP id oa15-20020a17090b1bcf00b001f553cfc01dmr26405812pjb.37.1659976330133;
        Mon, 08 Aug 2022 09:32:10 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902d2c200b0016db774e702sm9112612plc.93.2022.08.08.09.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 09:32:09 -0700 (PDT)
Date:   Mon, 8 Aug 2022 16:32:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 4/5] x86: Dedup 32-bit vs. 64-bit
 ASM_TRY() by stealing kernel's __ASM_SEL()
Message-ID: <YvE6hZfwPWmgBkBs@google.com>
References: <20220807142832.1576-1-mhal@rbox.co>
 <20220807142832.1576-5-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220807142832.1576-5-mhal@rbox.co>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022, Michal Luczaj wrote:
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 0324220..30e2de8 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -19,6 +19,18 @@
>  #  define S "4"
>  #endif
>  
> +#ifdef __ASSEMBLY__
> +#define __ASM_FORM(x, ...)	x,## __VA_ARGS__
> +#else
> +#define __ASM_FORM(x, ...)	" " xstr(x,##__VA_ARGS__) " "
> +#endif
> +
> +#ifndef __x86_64__
> +#define __ASM_SEL(a,b)		__ASM_FORM(a)
> +#else
> +#define __ASM_SEL(a,b)		__ASM_FORM(b)
> +#endif

Argh, this can't go in processor.h, because processor.h includes desc.h (to use
ASM_TRY).  This patch "works" because emulator.c includes both process.or and
desc.h, but things go sideways if ASM_TRY_FEP() is moved into desc.h.

I'll post a new version of the entire series, the KVM_FEP macro and a helper to
check for FEP availability should really go in a common location, e.g. the PMU
test can use the common helper instead of requiring a separate unittest.cfg entry.
