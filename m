Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B9F71F663
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 01:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjFAXLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 19:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjFAXLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 19:11:49 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7648513D
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 16:11:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56552a72cfbso21095297b3.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 16:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685661107; x=1688253107;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B75MWf6beC/EcJpe1cWIuOoPealFZbavFj3T8VogGVk=;
        b=J0qB3VL72cnJnHP5cq1iGMo1+hjJiyLIBiMsZ+lUWw1umPMX7n2ylJoaoblKfarfGC
         FJkhkWuO0wm/KTq35qfdnLa9lggzMUjlBaSIqC9E9jIF+aKOi7BmGJjc2vdN1DRpzEbL
         T/BSJ8iypKilY801Sqe2KBcSHTDJfj84uwARGnxhp1UedVATctheybTDrTGsh+zCbs3j
         pUdn2vfVmUK1Ymwe3AbfwYriMKm5a+XDh0UPksVh9TbyX2R2IujxFvTGE6Of0e5DtlyU
         NzcYmcxfx58JPuGjB9UE2zXLX7kxLpcmSHryLZpRg/Kh0EStod54mYy4hKDveZfxBRRs
         cIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685661107; x=1688253107;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B75MWf6beC/EcJpe1cWIuOoPealFZbavFj3T8VogGVk=;
        b=UieGwq5CrfEM5GUMSz0mDQbiYaqqHm8+OHZODZ6YPha89k91mXbV1lfisfhjSfbUip
         MfT2xOXgQWOwR67Wx0TywV6gKB/mUwCyLyPv8xMxiC7zYxN6+rUbY9VBUEF7AJqBbMHZ
         gVYz9p4xDZ2NfjcLC6mmckBTaMzOAbarUmBSgj6mhfQz23YETptw8TAAUwW+gtwyAMiA
         ktSAiRefzBrvS0/T0QVdD5OKUa9xM8QewAddZ9QvuI/fI4l8tpDymwfuUU65ihvDD2ov
         ZnCtZB0Z72KjZIenRdvqEORl/UZ9dBD3QzJ08niKJJY5fuaBB6sMcnHlI5cN8PCoZyCk
         SVCA==
X-Gm-Message-State: AC+VfDwLW+w37iEuRhSBScbOHM68w3AXiVdK0PYgb1EZyWWYFJBjv5tk
        MKjmevRfbEjVnklwtaw5viz8B9XW8j8=
X-Google-Smtp-Source: ACHHUZ7UXKJJsEoFN7F/4DTOWcZqkrap+Jv55GFFAVulUvY9dFiZ5GZVfP0cg5567cBORPtTYi16SGP5A3s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b727:0:b0:565:f05a:6ec1 with SMTP id
 v39-20020a81b727000000b00565f05a6ec1mr6578110ywh.6.1685661107757; Thu, 01 Jun
 2023 16:11:47 -0700 (PDT)
Date:   Thu, 1 Jun 2023 16:11:46 -0700
In-Reply-To: <20230526235048.2842761-4-seanjc@google.com>
Mime-Version: 1.0
References: <20230526235048.2842761-1-seanjc@google.com> <20230526235048.2842761-4-seanjc@google.com>
Message-ID: <ZHklss/E5uQdRktD@google.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Add test for race in kvm_recalculate_apic_map()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, Sean Christopherson wrote:
> From: Michal Luczaj <mhal@rbox.co>
> 
> Keep switching between LAPIC_MODE_X2APIC and LAPIC_MODE_DISABLED during
> APIC map construction to hunt for TOCTOU bugs in KVM.  KVM's optimized map
> recalc makes multiple passes over the list of vCPUs, and the calculations
> ignore vCPU's whose APIC is hardware-disabled, i.e. there's a window where
> toggling LAPIC_MODE_DISABLED is quite interesting.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../kvm/x86_64/recalc_apic_map_race.c         | 76 +++++++++++++++++++
>  2 files changed, 77 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c

Since there's another bug+test related to kvm_recalculate_apic_map()[*], I think
it makes sense to name this recalc_apic_map_test, and then fold the LDR test into
this one.  The LDR test is tiny enough that I don't think it's worth a separate
binary, even though I generally prefer to keep the selftests small.
