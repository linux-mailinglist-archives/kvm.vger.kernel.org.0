Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60E26C6AEB
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjCWO2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjCWO2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:28:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694B02D55
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:28:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so22966110ybg.21
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679581700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DST7Zdtha5usLEL23PyggdBetaqRMbKgjFtYxqu0mj8=;
        b=dCbeyb1VpESsaFYPVIDjWShqt4Z47AWqkoAszWTqrR066WcXDd0bJZSBNU6lsIWi/5
         EVFJKObH3DJrjjCVM25tiSfciAZRs06aWdrrmnisuUvhpGmMxxmqA1/7hivIZ8WlpfR7
         dGRLmysC9bU162uLCcKAY7GYDSyAMMBOuRh26PBKsxjMmTZ2jJ6E9rdrNhNVC/+VVdl7
         EljxaDq9K2zFvb3c2bTRkvcS1TruXIJk4qNYPrV/CPuDVkUbLUwflbjhRp281t8t8eVR
         br/LM2mOPihc71xhmIYlqOFSQwxMoENANy8aWgRKJ5y2mWN1IMhC0En1OoIXPa6h+Ub1
         1ydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679581700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DST7Zdtha5usLEL23PyggdBetaqRMbKgjFtYxqu0mj8=;
        b=2oTKRsFNRPxcVsO1FL2RxK2NSljnMPhuIZ0NSgV7B7yYPeDN64KgxdVkKwd/Pc8yEF
         hRCXHzYiGjc4LsHeOvtwSgpVRp6wI/PQ7fz5/gPeVZWyPIiMTXw+yLVhzZyYmSFlg6zG
         +rPSj8084U0mUTtZNkF6bkPGoyg9TuC4n/yxBOu2rXWodfOuwbS7H3wlEYWNT+0HT7N0
         QsdBs06PApJncUMani045G2pdzIXrgBkv+V9HjQVrcMB98qb1+dWXCPmOGcBeueWgjjY
         Qg142EbTXwjKEX3NXGcQy7q+FbMRETXRndr4IELXARO667JqyBNZD6slY88FgJRbVufM
         Mtcw==
X-Gm-Message-State: AAQBX9fsDrNIUbGywGt391BqzOotNst8r/vGv7C1VhDmVLiyC9Gg4kkN
        e+0KczDqIc9IR2nTVgRxJvRtgECck5g=
X-Google-Smtp-Source: AKy350bD0HPFYISjF6Bb6ZbDlux6DFGRRLp69S4WcP4JEtD2zlX/CDFfmli7r7nr8AF+M5RwRR3ehhQI31c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a1e4:0:b0:acd:7374:f154 with SMTP id
 a91-20020a25a1e4000000b00acd7374f154mr2235107ybi.7.1679581700709; Thu, 23 Mar
 2023 07:28:20 -0700 (PDT)
Date:   Thu, 23 Mar 2023 07:28:19 -0700
In-Reply-To: <e8fa4f0e-7d06-2b8d-56e2-acfc05b8e886@gmail.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com> <20230214050757.9623-3-likexu@tencent.com>
 <Y+6cfen/CpO3/dLO@google.com> <3e0f74af-772b-547b-18a9-7ac5c325dd35@gmail.com>
 <e8fa4f0e-7d06-2b8d-56e2-acfc05b8e886@gmail.com>
Message-ID: <ZBxiA/Kik0su4W+7@google.com>
Subject: Re: [PATCH v4 02/12] KVM: VMX: Refactor intel_pmu_set_msr() to align
 with other set_msr() helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, Mar 23, 2023, Like Xu wrote:
> Hi Sean,
> 
> the kvm-x86/pmu branch is basically unchanged up to now,
> do you need a V5 for this feature ? Thanks.

Unknown at this time, I've been fighting fires and am behind where I wanted to be
in terms of review for 6.4.  I'm partially batching areas this time around for a
variety of reasons.  Next up is selftests, and PMU is after.  Hopefully selftests
will go relatively quickly and I'll be able to focus on PMU sometime next week.
Sorry for the delay.
