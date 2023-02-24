Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF276A2311
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 21:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBXUOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 15:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBXUN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 15:13:59 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9564E1B2EA
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:13:50 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id h1-20020a62de01000000b005d943b97706so116482pfg.0
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xu4Wd78dUlax+rVxdmcGyhKF/xko4N1us6WpNVbjskM=;
        b=TNYaImb7KpwA3lA/HvadXaeXjMwfql9C9QtKiLEsSqRdNBVL9tOuJ75C4k2bl9iMLn
         OKE8knyO7G3mRkFTTkzcQdYABgwwiXkLskA1ktGoNww+20hObjennTC0bRbr/V+zE33j
         kCkIsBNMfocDH9BU5XukEu8SzcAgVU1tq6JwdTvSydI1C0AnwkhkMdwH45oyHNI32ESw
         wINyn2kN1vZGs+uJzZOmfYqWA5ncbex1mNmeajV6cVakLtuok3OxERvugc3vb1vUra6d
         wFynQ+ho2x3VAi0pr4u9aV5rXlh6f0hlt5akr9WGW8AxVDvUtLfEcI3mBPpO4N7G//bf
         gHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xu4Wd78dUlax+rVxdmcGyhKF/xko4N1us6WpNVbjskM=;
        b=CkgnPgomnmFlMyf45I/KzNAA+b97RkRsvCtqRdLpkRK7HL2b9q6mTDL4JsjPYr+k3+
         rW9fAGyz37LzKAoOVZbF2TiwX5EbSMLvpyvzJ6c5k31JfpbpXkBJb8rrXwJ51VtwipmU
         wW9G2PfosvM0a25rLjjb9sLj0Pi+qj38Pa+mAsvFprfZX157Y8x/5jC6OgvmhBwIiamo
         LiDF1RReOwBZsXNzkkNfKKhHbK8Q/nEvuZeHTWjopmN9YRXeKFysQMZrN2XDnXr1xj9t
         J90E2GS94MD/MEX2LurFDoIbLGTt75ZLemOzR10dm3xWiBrWwh6B88zjFEw7XqfLsCcX
         lCwQ==
X-Gm-Message-State: AO0yUKU+pGU1Xd/qfvRN5rytLfSBJw/VrnXzhlXGxGXxIF4/vtww1iTa
        1mpg6QiQGySOcC5rf7CgyS37273KeQA=
X-Google-Smtp-Source: AK7set/yxcMR+h3Ze6EVn2kygll81W5oHLf6yr4oy7xBDpPR+vf7ixJeMmGEJpWalz6xH6sESmbqyTsw2EU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2402:b0:19c:9999:e922 with SMTP id
 e2-20020a170903240200b0019c9999e922mr2960239plo.5.1677269629873; Fri, 24 Feb
 2023 12:13:49 -0800 (PST)
Date:   Fri, 24 Feb 2023 12:13:48 -0800
In-Reply-To: <gsnth6va967x.fsf@coltonlewis-kvm.c.googlers.com>
Mime-Version: 1.0
References: <Y/XJTGydjLCGKqRz@linux.dev> <gsnth6va967x.fsf@coltonlewis-kvm.c.googlers.com>
Message-ID: <Y/kafBuwgobKqacd@google.com>
Subject: Re: [PATCH] KVM: selftests: Provide generic way to read system counter
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, pbonzini@redhat.com,
        vipinsh@google.com, dmatlack@google.com, andrew.jones@linux.dev,
        ricarkol@google.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023, Colton Lewis wrote:
> Oliver Upton <oliver.upton@linux.dev> writes:
> 
> > > These functions were originally part of my patch to introduce latency
> > > measurements into dirty_log_perf_test. [1] Sean Christopherson
> > > suggested lifting these functions into their own patch in generic code
> > > so they can be used by any test. [2] Ricardo Koller suggested the
> > > addition of the MEASURE macro to more easily time individual
> > > statements. [3]
> 
> > > [1] https://lore.kernel.org/kvm/20221115173258.2530923-1-coltonlewis@google.com/
> > > [2] https://lore.kernel.org/kvm/Y8gfOP5CMXK60AtH@google.com/
> > > [3] https://lore.kernel.org/kvm/Y8cIdxp5k8HivVAe@google.com/
> 
> > This patch doesn't make a great deal of sense outside of [1]. Can you
> > send this as part of your larger series next time around?
> 
> I copied the wrong email link where Sean suggested this should be
> generic code in a separate patch. I may have been mistaken in thinking
> he meant to upstream it separately.
> 
> https://lore.kernel.org/kvm/Y8gjG6gG5UR6T3Yg@google.com/
> 
> But yes, I would prefer to keep this as part of the larger series.

Yeah, I just meant put it into a separate patch, but keep it in the series.
