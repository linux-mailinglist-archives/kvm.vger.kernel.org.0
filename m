Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A4C6DB2F6
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 20:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjDGSn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 14:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDGSn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 14:43:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FC3AD3E
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 11:43:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d83-20020a25e656000000b00b8befc985b5so7464624ybh.22
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 11:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680893034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KTGyQJpsDYEA+ECgHaBU8J5GFE8459lqAKWuCN2VE10=;
        b=N5ouWoSwHwMQwDRM8d9SvrZ07L3cAttFnF9gL7e3zCwMO8xJQ7OBeqML5ecamdThqE
         ZgF+EuxBXJM1DsvhK/hvcwQ10oWlAH2B0jfy+/LUUaqQPpYSeWBtJnSqYrS/j+cMsp6c
         ccI2wvjc4m6l4nD785njQFFVJbsMwdsclVSff8yugVZjQRIZgq005XqDTf/qH67JUDw3
         kORI04SSVuuLn+UF+JlXivUoAJY4kDnXRz9peDaNG0siPLGXPuEmjpRyInjTM6vBbyA/
         7TibPSlo8CaJvlWDE42CpRSY+n0xN4SE9lAIO8R+00iAarjWlbvhiEjikrQY4StngumX
         XPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680893034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTGyQJpsDYEA+ECgHaBU8J5GFE8459lqAKWuCN2VE10=;
        b=3z1xriPEXD1X7q89kQ/eIXVmgRzQXk5Obdp1R9URnAquCWxGJm+r1AGAs2/Ga91w1Z
         X0Zv+eXHRtq++B2NvvEaIHK8T4/MzKxfnkxuOfg1FtO1UYPSgFsI/3OPZJuIseVOd0bl
         IPhx4ZW0fr7lV4YHZ/wsv8aqDFNFOE4afuTb90OuSKr5l+RcpuR1O7lb4cXH4Q/Aw3HH
         pBJgcU8S0PkL+o3+lPStl8Q/orrjGX+4uOKnWmM3PMX+g6+ZHzwBvWcGak2Npx8xzX+S
         QvXqJV+a772JfWMHO6D0GbwQww5PzqHxb/dx+kq9v85xZTqbUmEgRwsJ4f2pf+wdm7Dn
         0AkQ==
X-Gm-Message-State: AAQBX9eHK7m1YS+2L4wBliO3DXqJbqYqNVdKtuQJ8XbYd7HHaDiUVqFo
        Ib+5D4oNNzZiGy8J7h2mDlWaISlOP4E=
X-Google-Smtp-Source: AKy350Y+aJXSI4wDD0m5/dNXmEeC7t9XvTba+mrRe8l1OAZNWCjlZtHKUAWSgp5eP1iCbNxjGqdusFzB0U4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d416:0:b0:b8c:692:3e07 with SMTP id
 m22-20020a25d416000000b00b8c06923e07mr2264436ybf.10.1680893034611; Fri, 07
 Apr 2023 11:43:54 -0700 (PDT)
Date:   Fri, 7 Apr 2023 11:43:53 -0700
In-Reply-To: <20230307141400.1486314-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com> <20230307141400.1486314-3-aaronlewis@google.com>
Message-ID: <ZDBkabDVMMZWeo0Z@google.com>
Subject: Re: [PATCH v3 2/5] KVM: selftests: Add a common helper to the guest
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        like.xu.linux@gmail.com
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

LOL, the shortlog is hilariously generic.  I realize it's annoying to have to
clarify what test is affected, but it's not exactly hard, e.g.

  KVM: selftests: Add a common helper for the PMU event filter guest code

On Tue, Mar 07, 2023, Aaron Lewis wrote:
> Split out the common parts of the Intel and AMD guest code into a
> helper function.  This is in preparation for adding
> additional counters to the test.

Similar whining here

  Split out the common parts of the Intel and AMD guest code in the PMU
  event filter test into a helper function.  This is in preparation for
  adding additional counters to the test.

> 
> No functional changes intended.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 31 ++++++++++++-------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index bad7ef8c5b92..f33079fc552b 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -100,6 +100,17 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
>  		GUEST_SYNC(0);
>  }
>  
> +static uint64_t test_guest(uint32_t msr_base)

test_guest() is again too generic, and arguably inaccurate, e.g. it's not really
testing anything, just running code and capturing event counts.  How about
run_and_measure_loop()?
