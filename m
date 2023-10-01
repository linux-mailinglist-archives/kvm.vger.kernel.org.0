Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EB47B44D0
	for <lists+kvm@lfdr.de>; Sun,  1 Oct 2023 02:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbjJAAbz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 30 Sep 2023 20:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjJAAby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 20:31:54 -0400
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52DDCA;
        Sat, 30 Sep 2023 17:31:51 -0700 (PDT)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-79f82b26abfso535713739f.1;
        Sat, 30 Sep 2023 17:31:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696120311; x=1696725111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6AchQhtz3Is06siYaW/kQahKNyjQihWPGVqucswhxyA=;
        b=ppAKVSi1Cw9A6DkzkD+q2HLS+JObvee0vZCvRdiB/9V3n9GSGBnixtwRizS4ABjiO/
         Xvh/1CogDnKQVVwiVSwFQxgbhPbbhui/QI6YVDhe4BxUzbHD7ZNaoz/KMPADDlc10/v/
         QY4m9h/qsDd4Y2o5zrfnqXmkG150NvlaD+Ol4Nd3pNyLYUudbCdFesSESJkqfIlD159H
         +NFl61KvzSzBISZAFOuqd0nr1RUzI9XkO7N1GdSnjq53PgzX3sX98dx6r9WK7Wu+Obfl
         Tf7m+Ij5RjHRhDqY0M6nLqgS89NkVQWcR9tZuA7xqDdPXUP5SkoASq1g5J9EHew+K5gK
         umSg==
X-Gm-Message-State: AOJu0YwQD/KIU1v6n+io5eFnyHLuX35i50PqVHTrDKRHcavcaXBOLV0n
        0K4FtpHPmwA9xKx3pUKhncRNA5gHZcGkE+E6YFI=
X-Google-Smtp-Source: AGHT+IEIuyCUmgl8NoW7qHnN40o6vLbYUrnuavgpMVki/1orj3aUsiFGyagAFy3NRnmXZA2QMl/So1fOPYUh8MBoVBQ=
X-Received: by 2002:a6b:5b15:0:b0:79f:99f5:fadd with SMTP id
 v21-20020a6b5b15000000b0079f99f5faddmr8947813ioh.6.1696120310760; Sat, 30 Sep
 2023 17:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com> <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com> <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com> <CALMp9eQvCLJCQYHfZ5K3nZ8jK14dUMmfEsSvkdteE2OUtg=8+g@mail.gmail.com>
In-Reply-To: <CALMp9eQvCLJCQYHfZ5K3nZ8jK14dUMmfEsSvkdteE2OUtg=8+g@mail.gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Sat, 30 Sep 2023 17:31:39 -0700
Message-ID: <CAM9d7ciksqA7KGgc07HJAdE0TMpe1YCoS+NhzNEvdygh8T=PPA@mail.gmail.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        David Dunn <daviddunn@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Fri, Sep 29, 2023 at 8:29 PM Jim Mattson <jmattson@google.com> wrote:
> For things to work well in the "vPMU as a client of host perf" world,
> we need to have the following at a minimum:
> 1) Guaranteed identity mapping of guest PMCs to host PMCs, so that we
> don't have to intercept accesses to IA32_PERF_GLOBAL_CTRL.
> 2) Exclusive ownership of the PMU MSRs while in the KVM_RUN loop, so
> that we don't have to switch any PMU MSRs on VM-entry/VM-exit (with
> the exception of IA32_PERF_GLOBAL_CTRL, which has guest and host
> fields in the VMCS).

IIUC that means multiplexing should be handled in the guest.
Not sure it can support mixing host and guest events at the
same time.

Thanks,
Namhyung
