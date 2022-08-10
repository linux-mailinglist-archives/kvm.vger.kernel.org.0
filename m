Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163CE58F3F4
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 23:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiHJVuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 17:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiHJVuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 17:50:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A9C22B06
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 14:50:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso3489737pjf.5
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 14:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ygnGbUt+3O0f54t0NpL5FO/i8B0HOZAB8jJX1TXwzyc=;
        b=pQskKtZc88n9oVzN2THdY+2FXloCsjP/mdoaiObGi2Pw5P69Bh2kqcNRv9GpI6nNYJ
         yVCSL5ovF76R0ympJV15iE1FBpRSnw18Xrb/Cdnvh04T3dtczdEEWPYQkURtrug1HLzN
         eg4BmYv5FYpHa1ku6gbcuZCTrud1h4E36TmWeXoJ4yoV16/QJF7kP25vXLXGhYDbGNuF
         w3QAbt2lvnuzNBZ2tGX5R36UOoEQO6ICUQ2Xe1gp2wqszvE/sM0Q8jaFGjU1Eq6uKK3L
         EpKlbWe5tQR2f9VKhnsV3FDBuVuysufNOtj3uCBqJDSsKVuGjd65ctExymHSzfWzFr20
         WJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ygnGbUt+3O0f54t0NpL5FO/i8B0HOZAB8jJX1TXwzyc=;
        b=byOmJsMdwxJ7VpapggxtDnPSdiDWRokVgYo3diD/Zs/1migjAwfTx1KV8mskiBKKs6
         dQcbdm4kNnCeD/KOlPfzwll3yssrXs9Ga0zDR90R6RlqyyE4PcNQj/x61Et2uFPsQaJG
         xRM2tKF1kS6z6JMsuWwutfcMOy8X6eVHtC5XLxcpQrvyPQHr+gU6FRs8W0s0iix5oSs1
         WfOauIFbtc3QSWCpnCErSOuP/OOK2eB+NHXNOazZL9uRKN66MijjENgNSXVD7qJz/34N
         1hoRfHbR0vbywqGFa03IJK2DMHETr1PE+uCpm2SqR+qme83/7gs9SKCHxJGXOwiQ8yb7
         n1Mg==
X-Gm-Message-State: ACgBeo2EgCtyefIB2pckzRqCoh/g83fyade1kYruKoKz1yW3njLtNDzH
        uHqv4pNEqi5snALkbTnja+6T8Q==
X-Google-Smtp-Source: AA6agR4g3dhWHHVar1ahE95FgPgAzhTz123FZfd+OXb38Ifb4sac3hZ8nwB8v4sBm0D747f7yfWXUg==
X-Received: by 2002:a17:902:ce04:b0:16c:e142:5dd7 with SMTP id k4-20020a170902ce0400b0016ce1425dd7mr30244257plg.173.1660168238377;
        Wed, 10 Aug 2022 14:50:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d48500b0016ee3d7220esm13555456plg.24.2022.08.10.14.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 14:50:37 -0700 (PDT)
Date:   Wed, 10 Aug 2022 21:50:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: VMX: Heed the 'msr' argument in
 msr_write_intercepted()
Message-ID: <YvQoKgquagMadG85@google.com>
References: <20220810213050.2655000-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810213050.2655000-1-jmattson@google.com>
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

On Wed, Aug 10, 2022, Jim Mattson wrote:
> Regardless of the 'msr' argument passed to the VMX version of
> msr_write_intercepted(), the function always checks to see if a
> specific MSR (IA32_SPEC_CTRL) is intercepted for write.  This behavior
> seems unintentional and unexpected.
> 
> Modify the function so that it checks to see if the provided 'msr'
> index is intercepted for write.
> 
> Fixes: 67f4b9969c30 ("KVM: nVMX: Handle dynamic MSR intercept toggling")
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

I could have sworn this got fixed already.  Or maybe Aaron just pointed it out
off-list?

Reviewed-by: Sean Christopherson <seanjc@google.com>
