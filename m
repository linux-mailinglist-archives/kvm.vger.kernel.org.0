Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678125EE9C6
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 00:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiI1W4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 18:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiI1W43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 18:56:29 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3E81162E0
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:56:28 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id c7so13481768pgt.11
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=3AkUHvnKzL4Hlpc/bkIJl5rxEFjWAbVhXJ4cRADP1EE=;
        b=kZUaI18X2OGapOb/tTH8V00yNbmozyUJygTKIkKQwG3C/YlHEc8KKvCNYPlo90Co4I
         jw11indSHwo+UKYgVMCJQnoihgRfP55p1mhw5hqKvnGET4e1hSPoPHx1vcr0k9ytd3G4
         klwI+5LlJFBhIW4XxO0Trf/DNBW+cYJ5fm8YMllNlJ6VZHFKRshAxslZG+a/8kzpoSfH
         qxT4lCByvTRq2FfNgFBws6g8lmU6F3eyhSGWcYGfU00bQtFPQ3FPZtZLeBHCLAeu6VuE
         q2OJFhN7e2TGeWcNrCVDoHNpPwHPxf2vnkC5zlVkp/fQvWKPaUwp/j2WYHR5WZt8mME6
         guNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=3AkUHvnKzL4Hlpc/bkIJl5rxEFjWAbVhXJ4cRADP1EE=;
        b=Tk50kNzJLhElXNeTWiS0aq8cncPTfrWy5lSkL7rwM9ZKhrsL+eqz5lkzvYUKe/7T2v
         eRYjIKZr99MFbT/jbakMsU835JJMUI8BN32uEj3ul/DNTfJsBPiMLz2jAUuq73FSJhPa
         EBlJsbwY5yT9Enfn9wn9vFLE0ZWnKvE4mLUZ1LkbO88HVxHwc637zBodUKlo9Yw1ibB6
         OVe4SiNaFqtBH9K05VHAp4Vof4QHdc3XjVWk9QCG56Na+6qRrWOYHNi8bHvBbEaitRcb
         MxsFV9tz3F74Y4RtNeffAPaji6eiB/p93ZVVlqK0Pykspjakx0ZHccF2VviG51q2uP9q
         ykiQ==
X-Gm-Message-State: ACrzQf35F8rCTGgjaGXllXiKowYmsozF5NX8rhsLMV4Qo2sqYR7WfAr4
        nkURj2AZ/Ic+kfZpZUMV9IFWpA==
X-Google-Smtp-Source: AMsMyM7VFN9IB3bhWV4LbwHocSLLSugU4TaFY19KV4cCT2jOsXJIU+rVm7avMq2gD+69ABz5+ByWUw==
X-Received: by 2002:a63:2cce:0:b0:434:e004:a218 with SMTP id s197-20020a632cce000000b00434e004a218mr103889pgs.241.1664405788345;
        Wed, 28 Sep 2022 15:56:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f76-20020a62384f000000b00537b6bfab7fsm4565556pfa.177.2022.09.28.15.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 15:56:27 -0700 (PDT)
Date:   Wed, 28 Sep 2022 22:56:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Gracefully handle empty stack traces
Message-ID: <YzTRGGKAfmu4qQaa@google.com>
References: <20220927190515.984143-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927190515.984143-1-dmatlack@google.com>
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

On Tue, Sep 27, 2022, David Matlack wrote:
> Bail out of test_dump_stack() if the stack trace is empty rather than
> invoking addr2line with zero addresses. The problem with the latter is
> that addr2line will block waiting for addresses to be passed in via
> stdin, e.g. if running a selftest from an interactive terminal.
> 
> Opportunistically fix up the comment that mentions skipping 3 frames
> since only 2 are skipped in the code, and move the call to backtrace()
> down to where it is used.
> 
> Cc: Vipin Sharma <vipinsh@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

In case Paolo sees the error of his ways ;-)

Reviewed-by: Sean Christopherson <seanjc@google.com>
