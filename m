Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E477C8BE9
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 19:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjJMRCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 13:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjJMRCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 13:02:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760E1AD
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 10:02:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9e994fd94so13029115ad.3
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 10:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697216564; x=1697821364; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jb2BclJUU7GtSLFO/2WDLc/5XqeRqydzOe9LedmH49A=;
        b=yMGt3yxemVAgOP5eqHkJfULa0vqhmzwzcWOV6aoVaAnScuQwaGifzk/gG0O8BlmVuz
         4+7gXkG8ZLohgyc2XB/Wv5BuLT2Obk2w4Lc7Hl/oZOKk0GteJN/0JULJejy6xbnJhDmU
         6qrZsLlmxpxv5nuYUDaAdt3s+pRX7mrq6JEwM5JjZNQdwP4u9eOz71b89XvlxGXxsE/7
         jz+KhlhPDeNWzouC/VoEoyeIwLS0Hb2nJpCxAPfYhB1i1/ho/eI8+TyY+O3mXzVqKdJo
         6wiB6INFSDoK+NRwaZoIBTEBJ8ALpOP3+VSWK+B+RMDK22XkuHG7lQHn7/aiPBgpRXTv
         q8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697216564; x=1697821364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jb2BclJUU7GtSLFO/2WDLc/5XqeRqydzOe9LedmH49A=;
        b=SmIDUHI1nVOyclJ9SkNCtJPamX9gF8RbUcZ1LB6MJK3H9GTZQhhkFmO2hrAkCBJii+
         83xhPu2y8a9xH5aCnh12m8CdJ9ErEKe5YF8Rs9Sth4FbHs/Yo2VUsg+PIHirlOI9nduk
         VbWCrkgOQuJVfig70z8K/bEcBCk5PURJm5njmZYM/cI0guQDCTTiUr2y5QPCE+cXQCx+
         +MKCJj8ALB9eLsatQ4Ok7y0EfX2nHXgsoXLdW7Clg9elmafLoBBB0Wq/tWUguLtQjH7a
         6zW4iyPwtzLvFUDgRYWI2xmhPNNkkab+9V21LOaKxTGzIzQieuFlUlT3ZCGF1gp/aoTA
         ZXRw==
X-Gm-Message-State: AOJu0YwRzVQl0rYC8k6rzmV9JtpZ5rQhsamWdX6O9v5OJgO13t3+XPjg
        SbNX9RMhMsO+8rzz7rkmYIFZ2YiIl0E=
X-Google-Smtp-Source: AGHT+IGWJDA/JkbHL4UxviRK8nPCM0Hpb/X0tVV0gEaz38BaIdBKPIHz0U862gy2aLpqFqqR9Gkc+FYROfI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:189:b0:1c8:922e:e018 with SMTP id
 z9-20020a170903018900b001c8922ee018mr398841plg.13.1697216563840; Fri, 13 Oct
 2023 10:02:43 -0700 (PDT)
Date:   Fri, 13 Oct 2023 10:02:42 -0700
In-Reply-To: <20231011142003.GF19999@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net> <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net> <ZRwx7gcY7x1x3a5y@google.com>
 <20231004112152.GA5947@noisy.programming.kicks-ass.net> <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
 <ZR3eNtP5IVAHeFNC@google.com> <20231011142003.GF19999@noisy.programming.kicks-ass.net>
Message-ID: <ZSl4Mp3EZ5AnLGRD@google.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Mingwei Zhang <mizhang@google.com>, Ingo Molnar <mingo@kernel.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023, Peter Zijlstra wrote:
> On Wed, Oct 04, 2023 at 02:50:46PM -0700, Sean Christopherson wrote:
> 
> > Thinking about this more, what if we do a blend of KVM's FPU swapping and debug
> > register swapping?
> > 
> >   A. Load guest PMU state in vcpu_enter_guest() after IRQs are disabled
> >   B. Put guest PMU state (and load host state) in vcpu_enter_guest() before IRQs
> >      are enabled, *if and only if* the current CPU has one or perf events that
> >      wants to use the hardware PMU
> >   C. Put guest PMU state at vcpu_put()
> >   D. Add a perf callback that is invoked from IRQ context when perf wants to
> >      configure a new PMU-based events, *before* actually programming the MSRs,
> >      and have KVM's callback put the guest PMU state
> > 
> 
> No real objection, but I would suggest arriving at that solution by
> first building the simple-stupid thing and then making it more
> complicated in additinoal patches. Hmm?

Yeah, for sure.
