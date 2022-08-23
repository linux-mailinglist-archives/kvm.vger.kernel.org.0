Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C57E59E805
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 18:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245729AbiHWQvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 12:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242011AbiHWQui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 12:50:38 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101CDC6525
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 07:19:09 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f4so10562269pgc.12
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 07:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=175Tx1o+AcPU3xIQcxGY0p90o1xkOnxMQw2F4Mql3hA=;
        b=g40Sym1Y/k5jQq5mIQaiKchWvsZwkT+6FMRKyCxWrCIYSgJ7rjKuci9WGR6UP5v6tP
         3rN6MCtm0AX4irPPXd4+2BAWeyHBwFUwoyX5fj9bzhGo55ZAeqf4frJEURN23ANbonZc
         8XQdLD+9PdNl8oEhIldOyFYLoFc8BU7Sm2rfepjYI/+KA/Dv/EuWhTQF1CZzLbxGtFRJ
         sn+AB2fAF+wyq7Fo2muOFkf+5/FdYXb0EXc3luW/2583vQn0EUF0geUndA9LArEccEvX
         LOHb2jz5/v+Vlt9MwNkcIXBYBtj3tRNiAs0QjhDR2fodN0kbJXaX3jFdFmDDm2metWie
         crKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=175Tx1o+AcPU3xIQcxGY0p90o1xkOnxMQw2F4Mql3hA=;
        b=HK5ECTmQPyiav5v2xIFtfo8dGN5qEoAOEWnhI/MK2Fxfng0YAn6JyiiLRi6EINpo5c
         wzTReiSaJzMIXIrttsQylQFuxTqqWmClardyelmPZRNemUMx5ansH7R6icwGLxb/98pb
         GJCqtd0sbiXVb59w5ygoF2XJVaOwOonFIHYIemsQ9NIzcGbg3sQjccJMk9AWxkgE/LCW
         KRwxbSU3pJXjUd+qKC/YDk72YsSxnCS40Pv2lNfiPyeog3NGMewjXkc3auSv+6YPmRWC
         wmqxa2WbAOuZYPQeWScpUT1LT2rdlpUskBRCQMyJFgc6RYek0SrkHnSg11xSDmtFhgGu
         nmtA==
X-Gm-Message-State: ACgBeo0S+9DwCH65I15AF+ii6jiy7KgorbYrJ/7nTQ+eV28lLorESqta
        PcsxG3Xlt/P1N0QURn73S7PN8A==
X-Google-Smtp-Source: AA6agR4AjDYuPoJb4HqR5MqljTFQc36MwxuFqSl1NHZ6tMHGoXxKF68QKhb/fJx3y/Z5grSQMC/vzA==
X-Received: by 2002:a63:ad0d:0:b0:41d:433:8c42 with SMTP id g13-20020a63ad0d000000b0041d04338c42mr20536046pgf.105.1661264349336;
        Tue, 23 Aug 2022 07:19:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x2-20020a17090a164200b001f50e4c43c4sm11993896pje.22.2022.08.23.07.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 07:19:08 -0700 (PDT)
Date:   Tue, 23 Aug 2022 14:19:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: FYI:  xapic_state_test selftest fails with avic enabled
Message-ID: <YwTh2b8ThbiEA7iq@google.com>
References: <cdbe3d8d07557d73d7a96cd4a69e717574494e34.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdbe3d8d07557d73d7a96cd4a69e717574494e34.camel@redhat.com>
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

On Tue, Aug 23, 2022, Maxim Levitsky wrote:
> Hi!
> 
> I just noticed that this test fails when the AVIC is enabled.
> 
> It seems that it exposes actual shortcomings in the AVIC hardware implementation,
> although these should not matter in real life usage of it.
> 
> 
> First of all it seems that AVIC just allows to set the APIC_ICR_BUSY bit (it should be read-only)
> and it never clears it if set.
> 
> Second AVIC seems to drop writes to low 24 bits of to ICR2, because these are not really used,
> although technically not marked as reserved in the spec (though APIC_ID register in AMD spec,
> states explicity that only bits 24-31 can be set, and the rest are reserved).
> 
> And finally AVIC inhibit when x2apic is exposed to the guest was recently removed,
> because in this case AVIC also works just fine (but with msr emulation) and that
> means that we don't need anymore to hide x2apic from the guest to avoid AVIC inhibit.

KUT's APIC test also fails for a variety of reasons when AVIC is enabled.

https://lore.kernel.org/all/20220204214410.3315068-1-seanjc@google.com
