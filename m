Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B022C7D05CC
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 02:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbjJTA2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 20:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbjJTA2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 20:28:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234BD137
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 17:28:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9ace796374so342884276.0
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 17:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697761727; x=1698366527; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/luxcsSCFUvYWRTb1sE7Q6KZTce5i+T1PA+X88JDWC4=;
        b=BX56QL+yaHR/zLyYEum5ju4JkkUYS2P8OAhAUTnyOYPypa7GspTINSSfKz+DAKnNon
         TYujVI0VVLj93ZsD3BRggkDjQlwH0ZwhbYC3P1XAMzTfTh9FxZQqXZIym9vmVhC4+bkN
         5OShC9Ps2VK2GU/XupLIzz8w47lSvSMRv/W4b8UsraXeoqeT5ksC6vuEKvkec2O/zLqs
         Fc/U5WSpYuQnNpRr+rKVbxuIGAlPKoMTAl6Jwq0yvZqr84xzocqH4fG8LIojszg9D7jV
         FfSiVsP1iSad77uYcas7vJbHi/RH4uyrzlGuFlQ6a7Efr2UGxtfbB3tppsSNSixrXcrF
         PtLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697761727; x=1698366527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/luxcsSCFUvYWRTb1sE7Q6KZTce5i+T1PA+X88JDWC4=;
        b=Ozta+H7GDbxwoBwK4bc7PA43PlZQ+T39fYkBdL9S5jmInG5zI/e+lIXpGlc/N8ZFrt
         Slrw+jjECyI9Z7pkfFsQiwPsBi0+SnAAS6RybQUR+1SYF9qovvXTW86JNy5KC8CBke6l
         yCeBHEP8LG+WfGdDmG3J2yoaju70tM4S+ZEVtX/COBGKGwRq4juI3vXvy4bU7aW7KtRc
         d5VYo1YBjrDy8f8TiB3Jzgwo7LegvH4Au0Z2f87tmbDkDdsEJ1tlFDDG9pZj6MnvsdMy
         yWbhul07etzV4H+9nOasOu3b27AWH3JU11nhicFVIOwuVJ2D/4ht/P9FUCT7NZ5JZLKo
         AJFA==
X-Gm-Message-State: AOJu0Yx3WjnLkeeShpx2ACMcctJhZKDunY6osZq+NwgS+1DLFfKDr8Vn
        QLHOmGArRVSiK0fsxRhrH6cNTO0Ubwg=
X-Google-Smtp-Source: AGHT+IFW9zksA+H9m2GPfcJ75jDt4TnSyJLPRLkb++tMA2TuGlsg2r96LFRoWWzK/+/A6+1E0byX/Eksjqs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d05:0:b0:d9a:5b63:a682 with SMTP id
 5-20020a250d05000000b00d9a5b63a682mr7309ybn.13.1697761727279; Thu, 19 Oct
 2023 17:28:47 -0700 (PDT)
Date:   Thu, 19 Oct 2023 17:28:45 -0700
In-Reply-To: <20230911114347.85882-1-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com>
Message-ID: <ZTHJvQm-nDNkvldM@google.com>
Subject: Re: [PATCH v4 0/9] KVM: selftests: Test the consistency of the PMU's
 CPUID and its features
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, Sep 11, 2023, Jinrong Liang wrote:
> Jinrong Liang (9):
>   KVM: selftests: Add vcpu_set_cpuid_property() to set properties
>   KVM: selftests: Extend this_pmu_has() and kvm_pmu_has() to check arch
>     events
>   KVM: selftests: Add pmu.h for PMU events and common masks
>   KVM: selftests: Test Intel PMU architectural events on gp counters
>   KVM: selftests: Test Intel PMU architectural events on fixed counters
>   KVM: selftests: Test consistency of CPUID with num of gp counters
>   KVM: selftests: Test consistency of CPUID with num of fixed counters
>   KVM: selftests: Test Intel supported fixed counters bit mask
>   KVM: selftests: Test consistency of PMU MSRs with Intel PMU version

I've pushed a modified version to 

  https://github.com/sean-jc/linux/branches x86/pmu_counter_tests

which also has fixes for KVM's funky handling of fixed counters.  I'll wait for
you to respond, but will tentatively plan on posting the above branch as v5
some time next week.
