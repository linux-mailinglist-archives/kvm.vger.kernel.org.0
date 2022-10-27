Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3813261067E
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 01:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbiJ0Xo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 19:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234966AbiJ0Xo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 19:44:26 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DCF58530
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:44:24 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b29so3306632pfp.13
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3K80MN9bkBOzZMD0qoUIC7k6xdItcRKiiiG44YLHOOY=;
        b=a2AbcNamBS9wZRKHQ/dty1cV0ZVVuAiLR4xwUHPNUWujTRbe3yBFkh3QMYECMnnlA1
         Jzd+Q5yE11Q3/4jMwmZ1Ef7KORgWvosj0nlV5WBvzlutsup4ml87KmcYuZxcP+aPJGPK
         j9qw8AdPaVn9GZNcO/lJFIPsP3DF9MClQ4qD0udj7Mny/VeGKuC2TMaKl8FPEPTz7Oap
         FWmRBcx+wCt9MKZ5nA2BjfSdUgVaoTEMzy/OY0u0VmaWtQ7jIvnRENNl5jyk1VauQbmA
         WZJUQKDWk0C3TFwOqR0elYtzddmsFpJEtle4ygb9duFGgQIPyAmyuRoN0ARxvFB9rcX6
         Ez6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3K80MN9bkBOzZMD0qoUIC7k6xdItcRKiiiG44YLHOOY=;
        b=rH3SBPz/GGpWPQneIxxXNUFx/PejZ7flboU0cRfRRQ5nP+YcjTR5aQpHWiVY+cnWq2
         vs/WHfZ7H65NFYmipSWuBYhdg6EQTDgXWgIC+qaXqbEy20/ENGzmKldIRxqZTSLZOdnk
         2yr7yrhvqeauFpu8wyD3FWc2opunfnr4Y3at6dJpw+ZjoNqpargMeWVSTDdYyM7+H/dF
         Xvoo+XSC1or6Psrvvy4qcVfCqY8N3TH+NUi2pI/s6wdgtJ0qHlrp1Rx9gVP907ciCxMc
         zX0/1ho1upZWDkA8IJwfJ389isKV1uubkbrO7k7TcaKVW5QNfEB2fjf1sJM7Lh9kKxf/
         mzBg==
X-Gm-Message-State: ACrzQf3f3cM0WMmDEtxun8lO08IxGtmuhScqrrZVUID+jZyxs6x+wa4D
        noD0ltgz8cq0C4/Ibq2go4bejg==
X-Google-Smtp-Source: AMsMyM73HXykmM2pqv39a6SxcRzZgYx7457bXRwihaRMWSSYXqLHYYPAqrKtNVKsk5wBI05I3DHSig==
X-Received: by 2002:a63:985:0:b0:46e:e3b7:65ca with SMTP id 127-20020a630985000000b0046ee3b765camr24897024pgj.331.1666914264101;
        Thu, 27 Oct 2022 16:44:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e9-20020a17090301c900b001782f94f8ebsm1787005plh.3.2022.10.27.16.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 16:44:23 -0700 (PDT)
Date:   Thu, 27 Oct 2022 23:44:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/8] KVM: selftests: Delete dead ucall code
Message-ID: <Y1sX1FP4YIWRl5YU@google.com>
References: <20221018214612.3445074-1-dmatlack@google.com>
 <20221018214612.3445074-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221018214612.3445074-4-dmatlack@google.com>
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

On Tue, Oct 18, 2022, David Matlack wrote:
> Delete a bunch of code related to ucall handling from
> smaller_maxphyaddr_emulation_test. The only thing
> smaller_maxphyaddr_emulation_test needs to check is that the vCPU exits
> with UCALL_DONE after the second vcpu_run().
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../smaller_maxphyaddr_emulation_test.c       | 54 +------------------
>  1 file changed, 2 insertions(+), 52 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> index c5353ad0e06d..d6e71549ca08 100644
> --- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> @@ -90,64 +90,15 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
>  	vcpu_regs_set(vcpu, &regs);
>  }
>  
> -static void do_guest_assert(struct ucall *uc)
> -{
> -	REPORT_GUEST_ASSERT(*uc);
> -}
> -
> -static void check_for_guest_assert(struct kvm_vcpu *vcpu)
> +static void assert_ucall_done(struct kvm_vcpu *vcpu)

I vote to delete this helper too, it's used exactly once and doesn't exactly make
the code more readable.

>  	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
>  		    "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
>  		    uc.cmd, UCALL_DONE);

I believe the warning is due to gcc resolving the VA args inputs to test_assert()
before the call to get_ucall().  One thought:

  uint64_t cmd = get_ucall(vcpu, NULL);

  TEST_ASSERT(cmd == UCALL_DONE, ...)

In file included from x86_64/smaller_maxphyaddr_emulation_test.c:11:
include/test_util.h: In function ‘assert_ucall_done’:
include/test_util.h:54:9: warning: ‘uc.cmd’ is used uninitialized [-Wuninitialized]
   54 |         test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
      |         ^~~~~~~~~~~
x86_64/smaller_maxphyaddr_emulation_test.c:69:22: note: ‘uc’ declared here
   69 |         struct ucall uc;
      |                      ^~

