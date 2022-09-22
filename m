Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CFD5E6A81
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIVSQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiIVSP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:15:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63693ECCF6
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 11:15:55 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fs14so10599358pjb.5
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 11:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=nr+7IOo73RGkvtgVJL29Z6tTdRJTDEqf8P4Dgi+ndyk=;
        b=iCbAH699W/1jdjiG2kRIgTTGjNJ5vcrMUHEZiTItrbfKJTprZauxI3v9qa0UROhNZr
         DZVLcgpXxGfjASMaNGvsr+48JArAMzqrKzmuUwDRSzXAO+AV38MGkuSd8IKWFWMxmq57
         IVAlqyLz4MjUrkcJEWxDoYgZmZjildnN9Mn4b5brZXAEjMP74jepQoH/jsSRDHnHWFSL
         keK98O4wx8P4KazUlE6D2uVkK0AZwMmyKqiIzEr19A5psRnmcVPw6zrNtA47R26O9Ux8
         1UKArM89stdi9Sv/I+ry6iDlkr44SkIuFvhejq69GNvmuHB3Lg1fZnMH/a3LfaTzvZQu
         jcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nr+7IOo73RGkvtgVJL29Z6tTdRJTDEqf8P4Dgi+ndyk=;
        b=Xlzjvd/uIfRCWKzGKCYi+NSgsIkBEjioID2omWWKvx726pfZT7kb6CdBAysltvBjSC
         45kV+MiGsp1tradAx7aJDBPw5e6ALwceWWRw/L7sGg8lScHAiuIDY84bYjelTrC31QWi
         NjH+Go/UfkdwxM00vKTcrdSrdwANUcYQeRN9x766sW3H7w7nlwLV8IaPOt+5gflxJec6
         JR353JIcISJKt3lCUchtxflCtB4UPtlQiAifeTRpY7JYtSeQi7YoyanZTlXWQErkAccn
         y1qG9563XbamQv0XxabONu1wSf3SSCj/pJMmhT9yct9kO0PfYRvwiM7UPrz4uMfa+CEi
         UmEQ==
X-Gm-Message-State: ACrzQf2qJ6Md9oREpxzNSRW7dGwrZ1mB+wt0deL7J9kcW3+RggPilrmw
        Ac8hhRoCe3s9S7M1LOniMLIa4Q==
X-Google-Smtp-Source: AMsMyM5kij3DFL/RpvWafQ7/3nGP1AgvQjnHkj47Y1XxBIToLerAFAgu3hxeiBE8fghxkrFPyShFzw==
X-Received: by 2002:a17:90b:4b4c:b0:203:1eef:d810 with SMTP id mi12-20020a17090b4b4c00b002031eefd810mr16788791pjb.75.1663870554760;
        Thu, 22 Sep 2022 11:15:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902ecc400b0016dcbdf9492sm4414118plh.92.2022.09.22.11.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 11:15:54 -0700 (PDT)
Date:   Thu, 22 Sep 2022 18:15:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 0/5] KVM: selftests: Fix "fix hypercall test" build errors
Message-ID: <YyymVtI2afiKtIbN@google.com>
References: <20220908233134.3523339-1-seanjc@google.com>
 <CALzav=cZBsmtD3+hBko3kW6bh2+RC7j533r94576ExuPx7SgEQ@mail.gmail.com>
 <CALMp9eTgQyj22XgO4r1MYvjh4UVC3+4KF+xMUZxV50W3iYYgVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTgQyj22XgO4r1MYvjh4UVC3+4KF+xMUZxV50W3iYYgVw@mail.gmail.com>
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

On Thu, Sep 22, 2022, Jim Mattson wrote:
> On Thu, Sep 22, 2022 at 10:20 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Thu, Sep 8, 2022 at 4:34 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > After a toolchain upgrade (I think), the x86 fix_hypercall_test started
> > > throwing warnings due to -Werror=array-bounds rightly complaining that
> > > the test is generating an out-of-bounds array access.
> > >
> > > The "obvious" fix is to replace the memcpy() with a memcmp() and compare
> > > only the exact size of the hypercall instruction.  That worked, until I
> > > fiddled with the code a bit more and suddenly the test started jumping into
> > > the weeds due to gcc generating a call to the external memcmp() through the
> > > PLT, which isn't supported in the selftests.
> > >
> > > To fix that mess, which has been a pitfall for quite some time, provide
> > > implementations of memcmp(), memcpy(), and memset() to effectively override
> > > the compiler built-ins.  My thought is to start with the helpers that are
> > > most likely to be used in guest code, and then add more as needed.
> >
> > Ah ha! This also fixes an issue I've long since noticed and finally
> > got around to debugging this morning. userspace_io_test fails for me
> > when built with Clang but passes with GCC. It turns out Clang
> > generates a call to <memset@plt>, whereas GCC directly generates rep
> > stos, to clear @buffer in guest_code().
> 
> Hey! Did I miss a revert of commit ed290e1c20da ("KVM: selftests: Fix
> nested SVM tests when built with clang") in that patch set?

LOL, no, no you did not.  I'll do that in v2.
