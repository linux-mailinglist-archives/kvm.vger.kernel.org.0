Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD575F3460
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 19:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJCRWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 13:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJCRWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 13:22:11 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F48222A1
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 10:22:05 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c3so5891440pfb.12
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 10:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=za0njCA3sgp6egI3b9JB+Szkqh+A7J7QZOy2kShgEeA=;
        b=sNNenaH/MXaQOPTG8DBJHdqgw2hHtH2WkOS8N+yo4znXwGDQq7r41FUs9DgJQs/PvH
         oL8Gc1ClUh2JglnngdCAwTZkayX24rFy0/aOYgi/qmMJk0za8I7OrZz8QfKZCbHS2obq
         tsl/pVr+cIxMQKClb/lIJLETg3owXP8EKLABdhIJ28b68QYz5T4QrKoPB1PKuLmwBw1P
         5S6Xt0joFXE/OgHFz+aKk/JEv331clZZiumJzq0W6GooV6rDpP5Xe/st+POzII7edNYy
         OkD0CNzm6jpmYmMagh0gOubOtROcWjwbKxotqPKYBVG7pOa/Gq6WVJMsYY/wS6CC8wTN
         dvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=za0njCA3sgp6egI3b9JB+Szkqh+A7J7QZOy2kShgEeA=;
        b=Mmk9bbXBj+RH+9MkL8abj733OcMue5ZaHFkkINgxpwPkzIgfYsdiR48/XUsLMPJEtM
         n6e3sDszZkjnT35iL3gaFm7/qmguT6f61/bJ41IDYPuM+GJFxWzNIQjduk1tK8N2AuA3
         2TdfHQ1b3ncvpX9msExwGkkUI8XkmUE0wWjYAMBAkc/mb48nhrWF5n23RfZ1oXyZvymc
         ymW5tAdqzGbGRatcdr+fEGmdJXdduVsm5Ede/cwG4BBQiWWHeO3ZsFKRu4y06Z03fwcR
         SqKes8DyB6phb+DarKtdLTHAjE1Be5jEMK4r77wXYuRX+FNEF4N7JcABNMLRXLVc26ch
         PHcw==
X-Gm-Message-State: ACrzQf3s8bUGdSXDBNDJoyzuG9Skn5ns8rQEjwAq09Y0jMIA7RJvxHKB
        je9cgZ03T1oqx8t74ZU/JG4i0w==
X-Google-Smtp-Source: AMsMyM6tMAq4APo86wDWg3IUzInkOiZmGfRnFMuo72kvveYFRzigFK1scDJeeSPH5/J824n1OwAnxA==
X-Received: by 2002:a65:560a:0:b0:447:f485:caef with SMTP id l10-20020a65560a000000b00447f485caefmr9933150pgs.161.1664817724395;
        Mon, 03 Oct 2022 10:22:04 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x21-20020a17090300d500b00176c431e7e2sm7410104plc.13.2022.10.03.10.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 10:22:04 -0700 (PDT)
Date:   Mon, 3 Oct 2022 17:22:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v4 0/5]  KVM: x86: Intel LBR related perf cleanups
Message-ID: <YzsaOMculnYH1d5l@google.com>
References: <20220901173258.925729-1-seanjc@google.com>
 <Yxnx8InRcF94zi0n@hirez.programming.kicks-ass.net>
 <YyUezO4WQSArXPI+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyUezO4WQSArXPI+@google.com>
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

On Sat, Sep 17, 2022, Sean Christopherson wrote:
> On Thu, Sep 08, 2022, Peter Zijlstra wrote:
> > On Thu, Sep 01, 2022 at 05:32:53PM +0000, Sean Christopherson wrote:
> > 
> > > Sean Christopherson (5):
> > >   perf/x86/core: Remove unnecessary stubs provided for KVM-only helpers
> > >   perf/x86/core: Drop the unnecessary return value from
> > >     x86_perf_get_lbr()
> > >   KVM: VMX: Move vmx_get_perf_capabilities() definition to vmx.c
> > >   KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()
> > >   KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs
> > 
> > These look good to me; how do you want this routed, if through the KVM
> > tree:
> > 
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> Thanks!  If you don't anticipate conflicts in the perf headers, I'll take 'em
> through KVM, patch 01 introduced a new warning that I need to resolve (hopefully
> it doesn't throw a wrench into things).

Rats, patch 01 is flat out wrong.  The stubs for Intel and AMD are necessary
because KVM_{AMD,INTEL} don't strictly require CPU_SUP_{AMD/INTEL}.  KVM_AMD
doesn't have any CPU_SUP_* requirement (which probably should be fixed), and
KVM_INTEL effectively require INTEL || CENTAUR || ZHAOXIN.

x86_perf_get_lbr() can still be cleaned up to fix KVM's benign bug of not checking
the result by zeroing the structure when LBRs are unsupported.

v5 incoming...
