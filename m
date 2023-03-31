Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AFE6D2580
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 18:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbjCaQaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 12:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjCaQ3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 12:29:51 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B5B2D942
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:25:31 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id b1-20020a17090a8c8100b002400db03706so6477437pjo.0
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680279894;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g9mtWwtZkK5nksQCRLnG7AmLoPS1teRH3z1WAvplmIs=;
        b=FcOb5MpS4rrPTeBFiQcmcpAR9BD2zcWNmxuCSLNl4QUWqWot3aETHSZcys4G9CQANs
         81ZGblQ77qsDhs49ToyGXHznQ1CUEGqUdttixj7kKEkyNdeRtul/d0V5GthgU/18ve5+
         Vgy6WBe0k2f5mvZcnSoawLDKsuw7IgAT8ORAXBhFcBdQo0DAhuKDIo4rR+3u6TTU9l3F
         i5a42sA12zKzIgpOczcBhsZJVaknyMgKaKAuuuK/Pjies8/9nEwpIxgLYomf28pHTP1o
         hWS6uTSInBLpM94TBEHX02Xfqvf2LNh+Qh771viJIOBU08P8h4fXnJgjduUJg2efNOPL
         CtMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680279894;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9mtWwtZkK5nksQCRLnG7AmLoPS1teRH3z1WAvplmIs=;
        b=QkkZMbM54qoUNb/TYVMgJ6GKGlw9anKvU93SO1MTJY5LRAJWSVDUhnce8oJQ5Ytt07
         6G/+HP+gmIPzzhWb9mMNTRziDrJlrkZBRID8k4jwOmHb4NlvZGaBaqEl2E7TX0nOIh58
         +33o9ingWtyWsoMDkDTUD3RB/oBzA0lbWmJ3lol7jpaixWvjSxjFGVAyqzPjcdVFqQPV
         tSR6K0mBXN4Pj3LYfK1TgoKKjWt4erHVVruc9EQtjU6G28CiNw+hwifVXAxH/tXkTgfS
         kNq/5EWFMnStly5Xkkz3kYsIpS5bORE+om7cHYlbWxL58oo4fLFxJwhGJxQMPQ9quwJz
         O0hQ==
X-Gm-Message-State: AAQBX9eHkGN2es3aaJVlS0jM0Jf/oIo0KPRk/CBulEnjHo6Kmu9xeyAv
        wpFhLnWGbqlGZ2DMKPoJ82XQGhls7MY=
X-Google-Smtp-Source: AKy350b3tgOV6ilfrhSuh/RWhkcuecZwNMrsbFYa1qX80gWKJ98uHvB2OjEO/mu31+7/f+82vbdO3jWiyyU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d241:0:b0:513:c7d:6ed3 with SMTP id
 t1-20020a63d241000000b005130c7d6ed3mr7745448pgi.4.1680279894183; Fri, 31 Mar
 2023 09:24:54 -0700 (PDT)
Date:   Fri, 31 Mar 2023 09:24:52 -0700
In-Reply-To: <20230331135709.132713-5-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230331135709.132713-1-minipli@grsecurity.net> <20230331135709.132713-5-minipli@grsecurity.net>
Message-ID: <ZCcJVFKwV5N+aVDh@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/4] x86/access: Try emulation for
 CR0.WP test as well
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023, Mathias Krause wrote:
> Enhance the CR.WP toggling test to do additional tests via the emulator
> as these used to trigger bugs when CR0.WP is guest owned.
> 
> Link: https://lore.kernel.org/kvm/ea3a8fbc-2bf8-7442-e498-3e5818384c83@grsecurity.net/
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  x86/access.c | 46 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index ae5e7d8e8892..21967434bc18 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -1107,27 +1107,43 @@ static int check_write_cr0wp(ac_pt_env_t *pt_env)
>  	 * We load CR0.WP with the inverse value of what would be used during
>  	 * the access test and toggle EFER.NX to flush and rebuild the current
>  	 * MMU context based on that value.
> +	 *
> +	 * This used to trigger a bug in the emulator we try to test via FEP.
>  	 */
> +	for (;;) {

As suggested in patch 2, I'm pretty sure it's easier to use a helper, and have
the print statement react to at->flags.
