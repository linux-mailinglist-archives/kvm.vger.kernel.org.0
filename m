Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BD3640D3F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiLBSbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbiLBSbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:31:11 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404ACE7877
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:31:10 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so5907481pjm.2
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfK+kfqbWPptgCq2tZCiMpVEUs5CosRMB5lioDGYMKk=;
        b=ihCOICzU9nJEOo0P2BhftCjjX0ng291HIJTq+vBvOtmTjDX2nctPCeEY54SNqvCoKH
         Ho477OJgIkHgoBM5aUUXyNdBQvjrTfbO9K3yPIodpY7uFCH7Th53RYvtZ4OjIoPYGOZy
         OH6uyhO0hSAiB9v2AHNP5icPXZGWNmyW4njPIBV05dgLLAEYqWdL0wqMbomqDJOo9HmV
         g+13AgTUNTn5vOGErc0sqTcjcbYdxyVW8rUhNOPGwOs3HVIxZhfBGkHeZ/KZVxaTegFN
         Min0mX0FvZfX9Het51hhpAMaFuW/dLQ77hSth14Gz7JzY2mtNSEsXuOy20hbMcU0uFVa
         Hgow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfK+kfqbWPptgCq2tZCiMpVEUs5CosRMB5lioDGYMKk=;
        b=Wx6XdydLT7WnaLOiB4/AuNuuV0ZlThXiJJHrc4z7INRZPZI45b4WsVlr7ppC+d2wdt
         f9pQ57hI/+d1wiSFJdFcTNkRUQ+Y1JFdcucbkhRMJRC488nPKF7ebNb9V2hEevIbzj5n
         sFjYdiF93aHv3MOmY3Q8jGXE4ezxA1wGD4GA6xysA1SQAyITuOQLo2uaDMDoPPxBb3Y2
         7kc0n6RJeu0EY1ojWVgnU5lACSQmkQIgnpCd/Ko6FIVp7kxXIcpg33JFFfJA1bYRQl0Q
         GC8Tg+yG3hc5w55Z7VYMJZ8KnY5TKWES4VZ/qetuyfOa1st6pQWktzEYNl247VtXJj+T
         UDrg==
X-Gm-Message-State: ANoB5pk5k+gx1OVxqXrqgTBT4APBSd3pjIAUuQUrP/h6GQxvYVdyHdGi
        DFGKDo9u0BOsYC+mXnApmJ9K4v93nLuz+kd5
X-Google-Smtp-Source: AA0mqf6HaLY2x1LQczWVnG+WVM5qZCz4SaGDPltGY08HbQBpPiqU6EAI8SfB8StMG3TIYceogMwsYw==
X-Received: by 2002:a17:902:b282:b0:189:91f3:bfe2 with SMTP id u2-20020a170902b28200b0018991f3bfe2mr24328012plr.34.1670005869670;
        Fri, 02 Dec 2022 10:31:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id fa13-20020a17090af0cd00b00218abadb6a8sm5019339pjb.49.2022.12.02.10.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 10:31:09 -0800 (PST)
Date:   Fri, 2 Dec 2022 18:31:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Colin King (gmail)" <colin.i.king@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] KVM: selftests: Fix spelling mistake
 "probabalistic" -> "probabilistic"
Message-ID: <Y4pEaaQsnDWEOxjH@google.com>
References: <20221201091354.1613652-1-colin.i.king@gmail.com>
 <Y4o0Nq4SKGZgDOxi@google.com>
 <10445a4d-0175-3e5e-aa74-9d232737a7c2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10445a4d-0175-3e5e-aa74-9d232737a7c2@gmail.com>
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

On Fri, Dec 02, 2022, Colin King (gmail) wrote:
> On 02/12/2022 17:21, Sean Christopherson wrote:
> > On Thu, Dec 01, 2022, Colin Ian King wrote:
> > > There is a spelling mistake in some help text. Fix it.
> > 
> > I assume you have a script/tool of some form to do spell checking?  If so, can
> > you point me at it?  I'd love to incorporate something like that into my workflow.
> 
> https://github.com/ColinIanKing/kernelscan
> 
> It needs an appropriate dictionary to be installed. It's very fast (but
> sometimes makes mistakes, I need to fix those!).
> 
> ./kernelscan -k src_directory > mistakes.txt

Ah, it's specifically checking messages to avoid false postives on code and whatnot.
Neat!

> I normally run this across the entire kernel git repo on a daily basis, and
> diff the new results with the previous results using meld and figure out
> what needs to be fixed.
> 
> You may be better off with using codespell

Heh, my kind of nitpicking people :-)

  MSDOS->MS-DOS

Thanks a ton, that's exactly what I was looking for!
