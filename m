Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FE3596572
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 00:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiHPWXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 18:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237893AbiHPWXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 18:23:08 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452DF276
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:23:06 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f30so10548607pfq.4
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=+TNnx1dvmda/Lv7ys0WsGi7Qw8HijA+5loROtGlHDMQ=;
        b=LQ1EVAcV5dNOwoU/W9/2lHc048oEom0zyeEB5KHkA+qwNr+/I4LkjK+TLTeNJak9zH
         u5lBg5s9ADmflAAE/AUqYG0c2CpRwnNquEv33BPHHMNohvPzzs6yh6soip5xpKZWEGs1
         O4CIkxGzEq/EQpcuVtgo1ar3zyv2x3Jg5i6fypRCUJBmxSkIq1SKf7GHWN2Lkmj1SKho
         9nu57cfn7o6wwrcOuEWOCtQzQhmeV53CS3eH6kjpiktfpBCEjEy8EPivvpikwJx/r7MD
         1OLwRYSOlD8m20USk21OHThe0zRLVegrMrlWAvSdisk5yEQOEathlxHbIw4FbkJuvcp4
         W3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=+TNnx1dvmda/Lv7ys0WsGi7Qw8HijA+5loROtGlHDMQ=;
        b=yvA8//3pFetZTtcbQLmTC79S5f5kbexYPDRIhioZ3Z9f/MK86kDrICB0wgnxA8hfuy
         awnsynGmmpMGmONDpAXvbptxOKuCdNZ9IOd6v9LWEuYNNI4XXSNyJFX7cQrrkzISE1gm
         QQfi1yFJQUDo16UKBaOJkqRVhmIBU0Bo34GyRjrTEaqh6FXwQtck/vOeVHLATIWwW5Wu
         kzTl24tbRBA6f9EC4ihiW8sAAR9Bk9c1li0EtKKADc3JqA9s5DCrTitAxI6BKVqq5UHy
         WX78xfuTlsY8/5XhaPAX2Z+Uk25lIS2Xi5OWO9sMIbs5iDa/JUKITAV4/JFNxTofn8OJ
         8pfQ==
X-Gm-Message-State: ACgBeo3BNfTMdfUqvEliYSfHkseLxN4M12E46GF890UkOct+eF4PPlr1
        xV7MmzJwY1GvSA6sFLFNpMm0oQ==
X-Google-Smtp-Source: AA6agR75Oq14Fdh+tX2fxCj/DPx+VQc5mfO76YBWcRAtPB/vfTWm4VKe0ZIorrzX4EsFqy1Q0/6L1A==
X-Received: by 2002:a63:9042:0:b0:41c:cdd4:ae66 with SMTP id a63-20020a639042000000b0041ccdd4ae66mr19087027pge.47.1660688585597;
        Tue, 16 Aug 2022 15:23:05 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id nh14-20020a17090b364e00b001fa867105a3sm62942pjb.4.2022.08.16.15.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 15:23:05 -0700 (PDT)
Date:   Tue, 16 Aug 2022 22:23:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Andrew Jones <andrew.jones@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, xudong.hao@intel.com,
        regressions@lists.linux.dev
Subject: Re: [KVM] e923b0537d: kernel-selftests.kvm.rseq_test.fail
Message-ID: <YvwYxeE4vc/Srbil@google.com>
References: <Yvn60W/JpPO8URLY@xsang-OptiPlex-9020>
 <Yvq9wzXNF4ZnlCdk@google.com>
 <5034abb9-e176-d480-c577-1ec5dd47182b@redhat.com>
 <9bfeae26-b4b1-eedb-6cbd-b4f9f1e1cc55@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bfeae26-b4b1-eedb-6cbd-b4f9f1e1cc55@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022, Gavin Shan wrote:
> Hi Sean,
> 
> On 8/16/22 3:02 PM, Gavin Shan wrote:
> > On 8/16/22 7:42 AM, Sean Christopherson wrote:
> > > On Mon, Aug 15, 2022, kernel test robot wrote:
> > > > commit: e923b0537d28e15c9d31ce8b38f810b325816903 ("KVM: selftests: Fix target thread to be migrated in rseq_test")
> > > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > 
> > > ...
> > > 
> > > > # selftests: kvm: rseq_test
> > > > # ==== Test Assertion Failure ====
> > > > #   rseq_test.c:278: i > (NR_TASK_MIGRATIONS / 2)
> > > > #   pid=49599 tid=49599 errno=4 - Interrupted system call
> > > > #      1    0x000000000040265d: main at rseq_test.c:278
> > > > #      2    0x00007fe44eed07fc: ?? ??:0
> > > > #      3    0x00000000004026d9: _start at ??:?
> > > > #   Only performed 23174 KVM_RUNs, task stalled too much?
> > > > #
> > > > not ok 56 selftests: kvm: rseq_test # exit=254
> > > 
> > > ...
> > > 
> > > > # Automatically generated file; DO NOT EDIT.
> > > > # Linux/x86_64 5.19.0-rc6 Kernel Configuration
> > > > #
> > > > CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-3) 11.3.0"
> > > > CONFIG_CC_IS_GCC=y
> > > > CONFIG_GCC_VERSION=110300
> > > > CONFIG_CLANG_VERSION=0
> > > > CONFIG_AS_IS_GNU=y
> > > > CONFIG_AS_VERSION=23800
> > > > CONFIG_LD_IS_BFD=y
> > > > CONFIG_LD_VERSION=23800
> > > > CONFIG_LLD_VERSION=0
> > > 
> > > Assuming 23800 == 2.38, this is a known issue.
> > > 
> > > https://lore.kernel.org/all/20220810104114.6838-1-gshan@redhat.com
> > > 
> > 
> > It's probably different story this time.

Doh, if I had bothered to actually look at the error message...

> > The assert is triggered because of the following instructions. I would
> > guess the reason is vcpu thread has been running on CPU where we has high
> > CPU load. In this case, the vcpu thread can't be run in time. More
> > specific, the vcpu thread can't be run in the 1 - 10us time window, which
> > is specified by the migration worker (thread).
> > 
> >      TEST_ASSERT(i > (NR_TASK_MIGRATIONS / 2),
> >                  "Only performed %d KVM_RUNs, task stalled too much?\n", i);
> > 
> > I think we need to improve the handshake mechanism between the vcpu thread
> > and migration worker. In current implementation, the handshake is done through
> > the atomic counter. The mechanism is simple enough, but vcpu thread can miss
> > the aforementioned time window. Another issue is the test case much more time
> > than expected to finish.

There's not really an expected time to finish.  The original purpose of the test
is to trigger a kernel race condition, so it's a balance between letting the test
run long enough to have some confidence that the kernel is bug free, and not running
so long that it wastes time.

> > Sean, if you think it's reasonable, I can figure out something to do:
> > 
> > - Reuse the atomic counter for a full synchronization between these two
> >    threads. Something like below:
> > 
> >    #define RSEQ_TEST_STATE_RUN_VCPU       0     // vcpu_run()
> >    #define RSEQ_TEST_STATE_MIGRATE        1     // sched_setaffinity()
> >    #define RSEQ_TEST_STATE_CHECK          2     // Check rseq.cpu_id and get_cpu()
> > 
> >    The atomic counter is reset to RSEQ_TEST_STATE_RUN_VCPU after RSEQ_TEST_STATE_RUN_VCPU

Again, because one of the primary goals is to ensure the kernel is race free, the
test should avoid full synchronization.

> > 
> > - Reduce NR_TASK_MIGRATIONS from 100000 to num_of_online_cpus(). With this,
> >    less time is needed to finish the test case.
> > 
> 
> I'm able to recreate the issue on my local arm64 system.
> 
> - From the source code, the iteration count is changed from 100000 to 1000
> - Only CPU#0 and CPU#1 are exposed in calc_min_max_cpu, meaning other CPUs
>   are cleared from @possible_mask
> - Run some CPU bound task on CPU#0 and CPU#1
>   # while true; do taskset -c 0 ./a; done
>   # while true; do taskset -c 1 ./a; done
> - Run 'rseq_test' and hit the issue

At this point, this isn't a test bug.  The test is right to complain that it didn't
provide the coverage it's supposed to provide.

If the bot failure is a one-off, my preference is to leave things as-is for now.
If the failure is an ongoing issue, then we probably need to understand why the
bot is failing.
