Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4EE61002D
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 20:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiJ0S15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 14:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236227AbiJ0S1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 14:27:45 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5D86C13F
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 11:27:43 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q1so2327132pgl.11
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 11:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tb0YCZSXao2tHCSOjai9BRgZ3Fzz/7Cb5vr5oaEhVz0=;
        b=ruSg6t44tQpsOQGpht7nt1BC5oZrffvRGZpmmf7rg3gmVCF0YuPSlgkpie0l8JEd7l
         zZ6MQUzHpntg5Sn4/F6PgCctgGiDoRS2rrTycSCCl+UB3u+qNp62Cw37hj0Kjv8NloMh
         3V9gWBAxC1Igf2OXMWjhW3XqTnTZfcHU1poKBeU7BuTYSO8rA8/gQmfNhLUEJ0yEE05+
         Hi6ZMBM0nyM4Ve80SvtMDLkOrpyL0Ljy2JMs6/VLCFl7SOvuQGPRcZsIXbFB50ph9lRk
         YEF8P+3MQejax+pHyUgHDYaYm7KfZmVyuQOiIk6YPrRBTgmLLl3JpFgiDCylb5CU4PDA
         J7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tb0YCZSXao2tHCSOjai9BRgZ3Fzz/7Cb5vr5oaEhVz0=;
        b=6Z0YvKn0vdYvdhiHgbrQcvAcXT+QqCN00381X27cgBteFUBuH7JHRCjRNAria5wims
         4XH0M2DtSh4EYB2YOSt8KpEGB+N7TjEAga5byCGLsVoofNNOI0hdHGrKCaXVClSFHHM2
         A4gQdMpywr0yR0yLkaf6/rITAckVt8CMxHyDZdLY8jaoum+/uyWzYCUoYlMvhWIcGJGG
         BUkaSCHSMTHZN/LuMZO/KJ3Sqb/lJHd2yIMxrxA2u+j4QoIhb2mccL8EwRe6avys2mR3
         Kfnid1e9l/qPRvoOLLWjMql48oqZ6qzpVUV5gCgv+w+c6IVsZREVhUK+437HVCw0GWQ0
         wK/A==
X-Gm-Message-State: ACrzQf0EoF6qVBCgX7QfOtQzMN5TbcW3kENNBeXYH/oCi2EZHb12t5eF
        LP8G78OeTTK83OGI72oDsADpng==
X-Google-Smtp-Source: AMsMyM5Ol2z8MkITZibC1cbVlSM29dulVPWWckmU1l92mbCDKMklEUTI/batAJhAWIVtxwc52ynAEw==
X-Received: by 2002:a65:6955:0:b0:439:a99b:bca5 with SMTP id w21-20020a656955000000b00439a99bbca5mr43185555pgq.80.1666895263138;
        Thu, 27 Oct 2022 11:27:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i2-20020a170902e48200b00177faf558b5sm1467396ple.250.2022.10.27.11.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 11:27:42 -0700 (PDT)
Date:   Thu, 27 Oct 2022 18:27:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 00/18] KVM selftests code consolidation and cleanup
Message-ID: <Y1rNm0E6/I5y6K2a@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <Y1mlJqKdFtlgG3jR@google.com>
 <DS0PR11MB63731F2B467D4084F5C8D9B5DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1qnWFzekT27rYka@google.com>
 <CALzav=c4-FWVrWQebuYs--vbgnyPjEwZxfjSS1aMSRL3JMbWYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=c4-FWVrWQebuYs--vbgnyPjEwZxfjSS1aMSRL3JMbWYw@mail.gmail.com>
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

On Thu, Oct 27, 2022, David Matlack wrote:
> On Thu, Oct 27, 2022 at 8:44 AM Sean Christopherson <seanjc@google.com> wrote:
> > I like the idea in theory, but that'd be a daunting task to set up, and quite the
> > maintenance nightmare.  There are probably thousands of file => scope mappings
> > throughout the kernel, with any number of exceptions and arbitrary rules.
> 
> I was thinking about proposing this in checkpatch.pl, or in some
> KVM-specific check script. It seems like the following rule: If a
> commit only modifies files in tools/testing/selftests/kvm/*, then
> requires the shortlog match the regex "KVM: selftests: .*". That would
> handle the vast majority of cases without affecting other subsystems.
> 
> Sean are you more concerned that if we start validating shortlogs in
> checkpatch.pl then eventually it will get too out of hand? (i.e. not
> so concerned with this specific case, but the general problem?)

Ya, the general problem.  Hardcoding anything KVM specific in checkpatch.pl isn't
going to fly.  The checkpatch maintainers most definitely don't want to take on
the burden of maintaining subsystem rules.  Letting one subsystem add custom rules
effectively opens the flood gates to all subsystems adding custom rules.  And from
a KVM perspective, I don't want to have to get an Acked-by from a checkpatch
maintiainer just to tweak a KVM rule.

The only somewhat feasible approach I can think of would be to provide a generic
"language" for shortlog scope rules, and have checkpatch look for a well-known
file in relevant directories, e.g. add arch/x86/kvm/SCOPES or whatever.  But even
that is a non-trivial problem to solve, as it means coming up with a "language"
that has a reasonable chance of working for many subsystems without generating too
many false positives.

It's definitely doable, and likely not actually a maintenance nightmare (I wrote
that thinking of modifying a common rules file).  But it's still fairly daunting
as getting buy-in on something that affects the kernel at large tends to be easier
said then done.  Then again, I'm probably being pessimistic due to my sub-par
regex+scripting skills :-)
