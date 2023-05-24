Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FFE710126
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 00:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbjEXWx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 18:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjEXWx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 18:53:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B9A99
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:53:56 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2553b096ddfso201040a91.1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684968836; x=1687560836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x0WpqwanSmBKlqB/KYTJIHjiwaT4vo3S6eGEr+EhUoc=;
        b=0iFOfuXS06ChvMu47Nq+dNrsb1rcuvQm6ggloE98nwK6hu3HaudExnpKEc/CmuypvT
         VOg1Rw2c42mHnY0GBjBYW4SUTX1e86gIq+ZX0kdZvkVFRQCW65SN+2DvGcYYgg4fjh5c
         Mdlql7CzDEVVHmRYxd95Jiuuw+2zTNRwPuHpnvUUJO5tzsOEwzmA4uLbxLnUJ4iamf5e
         9JBSHoHtLSnO1Bx929g8Fxa1DQuhFCwcAAmQqTnde6AUSchsFYkIE2T8X9oJ0D0MF2cR
         tHu564hkvrDrqLveQCTXcZoJJWLeXLsDulCp9WJoROiQOCpXkfMJ8ddfhDbIMMYHL7Ar
         XIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684968836; x=1687560836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x0WpqwanSmBKlqB/KYTJIHjiwaT4vo3S6eGEr+EhUoc=;
        b=RYh8ulaL+SXjcBANobvpChKV5DIclWC/e3PiOFcS+o+VhfFfnNOcoIXAqW/C+Ambl9
         RD33GtnmN7MlhR844OaLfODdgoyoNGUHELdN4X81rkhsabpZnLRReW+a2rxBl5b7Rgn4
         /pYsmge1Xgm+XnsJcG+w3WnHzKqzzQnKbvi0ae5LNe8bUi7SkJoFgbaZDT8N3VJuiaal
         9eZpdc6Ilq1N8OUwrZmxckmKJ5t+h60HtJepcy0ZM+ZGc2dPCzR09HY+pSJNhUj+vdzW
         aQ+qsYeqi8GH56aqU0AY4j/gUkvhIYboakPWiVUUkJSg4XvKmYbderP4p57MmVNfD7pK
         FxHw==
X-Gm-Message-State: AC+VfDxnO/uvnwKp5zDL0FR7nOQoXRycBitMI4Z/j1cMrTBuYmKThotV
        4td4JB8PaWWMPBrqzrlCv2oTX0+Fo68=
X-Google-Smtp-Source: ACHHUZ476UqLrn2Q1a0Lg3CHSzK8Bih/IdjqbG0h2rX+yRAbJfPKV92Qs+JxZEmjEYmulJrCQYm6OeElP7w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e642:b0:23d:30a:692b with SMTP id
 ep2-20020a17090ae64200b0023d030a692bmr216909pjb.4.1684968836446; Wed, 24 May
 2023 15:53:56 -0700 (PDT)
Date:   Wed, 24 May 2023 15:53:55 -0700
In-Reply-To: <20230323072714.82289-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230323072714.82289-1-likexu@tencent.com>
Message-ID: <ZG6Vg0RZhJLXxoFC@google.com>
Subject: Re: [PATCH 0/7] KVM: selftests: Test the consistency of the PMU's
 CPUID and its features
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Thu, Mar 23, 2023, Like Xu wrote:
> Hi,
> 
> The KVM selfstests shows advantages over the KUT in terms of finding
> defects through flexible and varied guest settings form KVM user space.
> 
> This patch set tests whether Intel vPMU works properly with different
> Intel CPUID.0xA configurations, in which three issues were identified.
> It also provides test scaffolding and a sufficient number of pmu test cases
> to subsequently provide adequate code coverage of AMD vPMU or Intel
> complex features such as LBR or PEBS in selftests.
> 
> Please feel free to add more tests or share valuable comments.
> 
> Related bugs:
> KVM: x86/pmu: Fix emulation on Intel counters' bit width
> (https://lore.kernel.org/kvm/20230322093117.48335-1-likexu@tencent.com/)
> KVM: x86/pmu: Add Intel PMU supported fixed counters bit mask
> (https://lore.kernel.org/kvm/20230321112742.25255-1-likexu@tencent.com/)

Can you send a single combined series for these fixes, plus the tests in this
series?  I expect to apply the fixes before the tests, but I want to make it as
unlikely as possible that I forget and apply tests that fail.

Thanks!
