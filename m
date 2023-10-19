Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AFF7D0573
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 01:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346727AbjJSXjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 19:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbjJSXjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 19:39:08 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3CC11D
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 16:39:06 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9e0b9b96cso1785505ad.2
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 16:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697758746; x=1698363546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jKRVpHqiOcFkAlisvSEFvO+NQRHM9Xm9JCpjQkOWXE8=;
        b=p7EL6xu2pqmLNepsW0mS2MueKiHF0iLlbEe10hhNH/jYRBqyJTSBzQIoF+GWute3AK
         LMvn8Lg9U1OX3z9amLPbBL7paP0o1wH1rAeunu/27T+9TPK3G9gndB2JSb+Yxhb/3hJe
         XuWeAdDYhUa1zbdqgin1D6FDQ2KzFAj5UItYZwxrutnLnvuxtYaA72nwrM3w+AzcRkjC
         4L/XUunFGk2OwperCGXsD4m/aB9H1XHt+uchmiVjxPMkCc9AJdnL+a5BGDu0ktV0MlkJ
         A9QPjHW4HFKFjOIYymRUssbJqVSWTbD3kucttBjnVCXeXeO1Ox/eNNaMX57iRDSpMqf4
         jCWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697758746; x=1698363546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jKRVpHqiOcFkAlisvSEFvO+NQRHM9Xm9JCpjQkOWXE8=;
        b=d7RSrIzSty1DcvjOmRW/IdIwNY0Pb1AmQ8YvQi1nBd4DDBUn/7dpIFXcQroUvawH0U
         XmCAMMAqmwwmDPXfTdEZqfWTHn2KF6X2y+J20XqkhdcC+42qLOd5Dcy2wZT5Q1jT9Se1
         TuP7MVAJMVFnnA5djgyA5+X+dfhuF0PuTPAVm9LBRVIScgkB7p2yEwLZwnrO7jEnDMeQ
         O0K0J3h+FGgGN7aSn0okuUvL2XdeopNunkHFfar9trAP9z87hJfDOlO2MyJN6Sp5LFvx
         AEAwfFXnFKXZfZ6Fx3PArhGHWtq1JfiaWYF4axubGmFC/yimwYHiNIJGTxrHqwt8rXkI
         SmWg==
X-Gm-Message-State: AOJu0YwPxcLUJS+dJqWLu1G3AyHqjpOl1zVS1FwqjHoapE7FPn9HXfgH
        XKZi7wW3E2BZwiNUGClAvFfJQMFRV9o=
X-Google-Smtp-Source: AGHT+IEaajjcn0glSm/SziFaaXN2Oe2Bj3k8stVpq3YbjBTLHeHITMz6RMP0euJZHLbenG52J/N+01+5oZI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab0e:b0:1c9:bee2:e20b with SMTP id
 ik14-20020a170902ab0e00b001c9bee2e20bmr6432plb.11.1697758745829; Thu, 19 Oct
 2023 16:39:05 -0700 (PDT)
Date:   Thu, 19 Oct 2023 16:39:04 -0700
In-Reply-To: <20230911114347.85882-5-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com> <20230911114347.85882-5-cloudliang@tencent.com>
Message-ID: <ZTG-GGQ6Y7ODzq4K@google.com>
Subject: Re: [PATCH v4 4/9] KVM: selftests: Test Intel PMU architectural
 events on gp counters
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023, Jinrong Liang wrote:
> +static void test_intel_arch_events(void)
> +{
> +	uint8_t idx;
> +
> +	for (idx = 0; idx < NR_INTEL_ARCH_EVENTS; idx++) {
> +		/*
> +		 * Given the stability of performance event recurrence, only
> +		 * these arch events are currently being tested:
> +		 *
> +		 * - Core cycle event (idx = 0)
> +		 * - Instruction retired event (idx = 1)
> +		 * - Reference cycles event (idx = 2)
> +		 * - Branch instruction retired event (idx = 5)
> +		 */
> +		if (idx > INTEL_ARCH_INSTRUCTIONS_RETIRED &&
> +		    idx != INTEL_ARCH_BRANCHES_RETIRED)
> +			continue;
> +
> +		check_arch_event_is_unavl(idx);

Rather than completely skip the event, just don't check the counter.  That way
the test still verifies that it can program the event, it's only the result that
isn't stable enough to assert on.
