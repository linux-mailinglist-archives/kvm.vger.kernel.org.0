Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD4F57A81C
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 22:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbiGSUPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 16:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiGSUPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 16:15:22 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DF9140FF
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:15:21 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s27so14461217pga.13
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NEfS/eoC3Nf00HaXxYG0DEJSxAw0JNVTBJo/RCeny3A=;
        b=AD0ma5BqumwDv7a5beqdIOAf2q4v1HKvJvxvlz1PIt7KzKSKvxN3tviTN7HZPA8wi5
         FHO5WtxtfIW4KQYtVnFjEwHDeyd7SbYZOZEMzeR/Wfuv+/7CepejK8SPD9nfCZ7ywHI2
         f4u485c0kU6rgzaVEtn3f9mT8l5YrZO+h+5ay5NGts8uw6T0+mUN/aNYMabgiv3f/4bP
         Nl/uzyXBHgdve2FvTljLDjfel61ViB7n8T7YiKXW10wnsBnwzwLWCAN2PhoDm5H/BFsU
         Hpa3Z6sdVK4zGPf1rZ7esR0C95oIAAU8+IYhluk7GLr5N/yrvNjF/fA61ExUi8rI1jz7
         gl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NEfS/eoC3Nf00HaXxYG0DEJSxAw0JNVTBJo/RCeny3A=;
        b=UJLeRMsvsB5GKxVSavj0a2K2sU2YdFy2dfK7/w4t9EmQLxd13n5kpZGQBVpLR4jvGW
         Mu0oHjiX/tAD7BrEOMO0KsvqJukSL3RC5b71zdS39sXfJ/I5xeOgHQsZmXZXWaoP+tBq
         VAFRtwdoMfMOZnKHvjotarVaq2P7SMhgswdOMoDi7d4Vyega2LgRCSNkeX7PF46fWlm0
         ukLICzQ/485ZnuaxpiQUR69iUXc5XG1iL5AwQfr6XWrESY8Sx0ZHdTxp00NXIpl1lCtE
         Y3cShj99AcjnnQ072Nqa5s/YzBwzcFOCnHHjdUkVZzsh4s2qwoFEzzLNhkt9kUnQ9nDi
         SLAQ==
X-Gm-Message-State: AJIora8D4jMxde0YLDnckUhfaLRtq20Qqjm78kFKgX9Wfp2HI0AVfRQl
        f/4oDTFyU7rJ381eNR51+K2KDlPztyM30w==
X-Google-Smtp-Source: AGRyM1vx3ot4fWpyHImsnTiXOQOl5quGrhQswKXzrqXQ1M3UZ70xaSJ3Pb4dFhb5jR2IEqIVYGUEJw==
X-Received: by 2002:a63:5b5f:0:b0:416:1e31:5704 with SMTP id l31-20020a635b5f000000b004161e315704mr30558147pgm.523.1658261720495;
        Tue, 19 Jul 2022 13:15:20 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902710800b0016c28a68ad0sm11936220pll.253.2022.07.19.13.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 13:15:20 -0700 (PDT)
Date:   Tue, 19 Jul 2022 20:15:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 07/12] KVM: X86/MMU: Remove the useless struct
 mmu_page_path
Message-ID: <YtcQ1GuTAttXaUk+@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-8-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605064342.309219-8-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, s/useless/now-unused, or "no longer used".  I associate "useless" in shortlogs
as "this <xyz> is pointless and always has been pointless", whereas "now-unused"
is likely to be interpreted as "remove <xyz> as it's no longer used after recent
changes".

Alternatively, can this patch be squashed with the patch that removes
mmu_pages_clear_parents()?  Yeah, it'll be a (much?) larger patch, but leaving
dead code behind is arguably worse.

On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> struct mmu_page_path is set and updated but never used since
> mmu_pages_clear_parents() is removed.
> 
> Remove it.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
