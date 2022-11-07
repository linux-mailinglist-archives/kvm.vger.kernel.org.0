Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8CA61FD4B
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiKGSUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiKGST6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:19:58 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB6724966
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:19:29 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id v3so11173891pgh.4
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w7oQlQSGWErcIWmEijXaEvWPIfe56DxtjW2YodF6ZaE=;
        b=dral5VrDzWpIXTVIhpxyg4cWdu7i694XTx/CtLfAwwl9xnXJw/FNSm8HnbZ+uu1YsQ
         yzUabaLL/Wcw35lXOJyRUAf4lIYf51cyXMFoNHeJy7AVQ+376aM8en6Il5jJuLibCMas
         zLH5pw0Yl8eZ7dH3ihR//thkLoLSylcvErhF6x10I6yvnF3yfwEZ7aWOawqm0x6MDe6T
         NFAe+2RAo1zQrcwTAdDBnY/o5n31RmMMScKrAwj+xgbLXSkgDjbv+G+nhQ54v/df8TA1
         dVR7wgrXZtuz0UAJT2klX38uJSfKodmXM/uWCkf+m92aaZxca0pwYQwdF5SajPz+pdUV
         /9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w7oQlQSGWErcIWmEijXaEvWPIfe56DxtjW2YodF6ZaE=;
        b=K4IVkAWd+EC8m6EYPXPrD43vdcGEGxIgadSBM1AokRmucX6+bwm7hgZ64kWkG5yUkr
         LE218xVHO1+ZAgWGxqgBy82LHfIuzXEA4tfKWZw0/PJ/UwR/8JQcVDmDCgzAEp7uqHv9
         Da6TcWC4wL3nbsnXfr+X5gnRtUITfH0WW9HMJ6aTY2r+jkyxy9ePZRITGOPdSrG7y4dB
         s9+uUuo5azTnpkq0pFKwDpKOfUBEyF6CIpBU21wg33imnlPvOVjvKcChFMZZrhyIsSwi
         YlQPe7cMy5klOuVU1O4WYlF28QitWCwn0miEU1e1LHrMuZnfNNY+jXtwV3SC6VTjqUp+
         KeFA==
X-Gm-Message-State: ACrzQf1SivhNKjbMX8+qfOrtdcaxtAqeJeTxvWgFlQoTKr7gQWUF2U9P
        T/XdPjukMLUX90cke1m5yiUfrg==
X-Google-Smtp-Source: AMsMyM4rnkRsDtAGEb3zfh89py2cnTFpfYi1YlUckPJ0bJYEmer59wywHW7N5IxQ+TKIT8759KckpQ==
X-Received: by 2002:a63:8a42:0:b0:46f:5804:8d9e with SMTP id y63-20020a638a42000000b0046f58048d9emr44691332pgd.214.1667845168931;
        Mon, 07 Nov 2022 10:19:28 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902784900b00183e2a96414sm5288040pln.121.2022.11.07.10.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 10:19:28 -0800 (PST)
Date:   Mon, 7 Nov 2022 18:19:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 00/18] KVM selftests code consolidation and cleanup
Message-ID: <Y2lMLfjiRAF8ZrNT@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <Y1mlJqKdFtlgG3jR@google.com>
 <DS0PR11MB63731F2B467D4084F5C8D9B5DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1qnWFzekT27rYka@google.com>
 <CALzav=c4-FWVrWQebuYs--vbgnyPjEwZxfjSS1aMSRL3JMbWYw@mail.gmail.com>
 <Y1rNm0E6/I5y6K2a@google.com>
 <20221028124106.oze32j2lkq5ykifj@kamzik>
 <Y1v6AEInngzRxSJ+@google.com>
 <CALzav=chUT9v4wYVVy9dSLcevhADxONaf9iCMOWQ_vUOwpkV9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=chUT9v4wYVVy9dSLcevhADxONaf9iCMOWQ_vUOwpkV9g@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022, David Matlack wrote:
> On Fri, Oct 28, 2022 at 8:49 AM Sean Christopherson <seanjc@google.com> wrote:
> > Anyways, if someone wants to pursue this, these ideas and the "requirement" should
> > be run by the checkpatch maintainers.  They have far more experience and authority
> > in this area, and I suspect we aren't the first people to want checkpatch to get
> > involved in enforcing shortlog scope.
> 
> Documenting would at least be an improvement over what we have today
> since it would eliminate the need to re-explain the preferred rules
> every time. We can just point to the documentation when reviewing
> patches.

Agreed.  And there are many other things I want to formalize for KVM x86, e.g.
testing expectations, health requirements for the various branches, what each
branch is used for etc...

If you want to send a patch for the shortlogs thing, maybe create

  Documentation/process/maintainer-kvm-x86.rst

and link it into Documentation/process/maintainer-handbooks.rst?

> `git log --pretty=oneline` is not a great way to document shortlog
> scopes because it does not explain the rules (e.g. when to use "KVM:
> x86: " vs "KVM: x86/mmu: "), does not explain why things the way they
> are, and is inconsistent since we don't always catch every patch that
> goes by with a non-preferred shortlog scope.
