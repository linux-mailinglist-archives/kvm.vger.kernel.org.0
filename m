Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509F8675C7D
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 19:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjATSMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 13:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjATSMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 13:12:05 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61687B2E5
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 10:12:04 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so5675238pjb.4
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 10:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=40zi89liXeYL+C9ETOMWoCnJSHW1HBOSzJ0x60fdhBs=;
        b=Dj65CWChx/HfzXrMn5Ke4NzBYkq+bqtd56VEVUiAWCUzdHg8ltegLc/vhEJ0W9duvx
         eGAnD5fcuKZAQyjEFpsOwtEatSmZ5xyckipR0Hi5iEMKDKk2emRgrZR/s79PUienHV44
         yU/y/OVH+mM+RokNADiN50K1jIJKketXBcd3eAIXEH0hd0QKgnqZgmZ5e4pWrdwdjnfD
         Y6LAeHsha3/4EDVn5C1DhWXLiJbGAIv3OaKJuEvaDq4UfKAn/SA2fRjf2/Qg/qpWtik5
         LJgHd1siPHuX4vtETOYwg/0RT7l81SkJ13c6OLVkhkIagsg90kZGHhCHIepZK7fCvSSx
         VCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40zi89liXeYL+C9ETOMWoCnJSHW1HBOSzJ0x60fdhBs=;
        b=F1LGiHXm45sAJG4mX48tI3x9vMwxO3NfQCXTxfrNhjmN0RYfborqJLmKD6C3b4C5sV
         GsdM4/TA4m5rq2+c0MU884dah5vCAlDCnkWQrGEXmhedvxKVmK5/QUpaEVsWcHjoyQsq
         0flP6af7Neaa1wm/yYLM5gcFGOrzMWQRnQzMN9oqYQgghhn1J8jFkUZIzoAKrgeIaWX/
         Rf/1mFrSCal6WlzeBjjeS/m8p/XaHWKvscQ7O/Cn5gMeK87pXVxbJv6FF3oZKSh8kOma
         JWGLJkEnIscI3noKP+aQu36TfdipW6YnL/uYpeqaN6/51qZPoTmuetQnbVXvtl4Yulou
         J6Dw==
X-Gm-Message-State: AFqh2krGpvbdnhzQt2Te7JX6OllxNUnYDSIB9Wq4tzzbV3KFjuOj8/DE
        K9K+nMvP8s0Ix15zb5BPcGmN8dXNe/YFJT2LQDQ=
X-Google-Smtp-Source: AMrXdXtgT2JL5VLjxdY+JjCD6MZti8CUbYU0FuBMKdDBC9+EH0LhWcHFbH9kZmD9wsNjHUb9CXw7VA==
X-Received: by 2002:a17:902:ebce:b0:191:1543:6b2f with SMTP id p14-20020a170902ebce00b0019115436b2fmr265666plg.3.1674238323657;
        Fri, 20 Jan 2023 10:12:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i12-20020a170902c94c00b00189a50d2a3esm14408753pla.241.2023.01.20.10.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 10:12:03 -0800 (PST)
Date:   Fri, 20 Jan 2023 18:11:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, like.xu.linux@gmail.com
Subject: Re: [PATCH v8 0/7] Introduce and test masked events
Message-ID: <Y8rZb3x2yQjmtWYr@google.com>
References: <20221220161236.555143-1-aaronlewis@google.com>
 <167409081639.2375192.4460110033173378501.b4-ty@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167409081639.2375192.4460110033173378501.b4-ty@google.com>
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

On Thu, Jan 19, 2023, Sean Christopherson wrote:
> On Tue, 20 Dec 2022 16:12:29 +0000, Aaron Lewis wrote:
> > This series introduces the concept of masked events to the pmu event
> > filter. Masked events can help reduce the number of events needed in the
> > pmu event filter by allowing a more generalized matching method to be
> > used for the unit mask when filtering guest events in the pmu.  With
> > masked events, if an event select should be restricted from the guest,
> > instead of having to add an entry to the pmu event filter for each
> > event select + unit mask pair, a masked event can be added to generalize
> > the unit mask values.
> > 
> > [...]
> 
> Applied to kvm-x86 pmu, thanks!
> 
> [1/7] kvm: x86/pmu: Correct the mask used in a pmu event filter lookup
>       https://github.com/kvm-x86/linux/commit/aa570a7481c3
> [2/7] kvm: x86/pmu: Remove impossible events from the pmu event filter
>       https://github.com/kvm-x86/linux/commit/778e86e3a2fd
> [3/7] kvm: x86/pmu: prepare the pmu event filter for masked events
>       https://github.com/kvm-x86/linux/commit/11794a3da07f
> [4/7] kvm: x86/pmu: Introduce masked events to the pmu event filter
>       https://github.com/kvm-x86/linux/commit/651daa44b11c
> [5/7] selftests: kvm/x86: Add flags when creating a pmu event filter
>       https://github.com/kvm-x86/linux/commit/6a6b17a7c594
> [6/7] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
>       https://github.com/kvm-x86/linux/commit/b1a865796643
> [7/7] selftests: kvm/x86: Test masked events
>       https://github.com/kvm-x86/linux/commit/5ed12ae83c4c

FYI, I forced pushed to pmu to fix a minor warning in the docs and decided to
opportunistically update all of the shortlogs to fix (again minor) issues with
the scope since this series is currently the only thing sitting in pmu.

[1/7] KVM: x86/pmu: Correct the mask used in a pmu event filter lookup
      https://github.com/kvm-x86/linux/commit/1d2489485e28
[2/7] KVM: x86/pmu: Remove impossible events from the pmu event filter
      https://github.com/kvm-x86/linux/commit/1110a9128858
[3/7] KVM: x86/pmu: prepare the pmu event filter for masked events
      https://github.com/kvm-x86/linux/commit/3b049af387c4
[4/7] KVM: x86/pmu: Introduce masked events to the pmu event filter
      https://github.com/kvm-x86/linux/commit/22f39725f0f6
[5/7] KVM: selftests: Add flags when creating a pmu event filter
      https://github.com/kvm-x86/linux/commit/963fd783390f
[6/7] KVM: selftests: Add testing for KVM_SET_PMU_EVENT_FILTER
      https://github.com/kvm-x86/linux/commit/1c1045925ed4
[7/7] KVM: selftests: Test masked events in PMU filter
      https://github.com/kvm-x86/linux/commit/526d9f600225
