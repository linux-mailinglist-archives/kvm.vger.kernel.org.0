Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52FC7B22A9
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjI1Qmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjI1Qmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:42:51 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B784998
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:42:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f8188b718so166937497b3.1
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695919369; x=1696524169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DPGh9unxuL2nJXgyj58qseqaVYwl19QlZd4mAA+cegs=;
        b=gu+PIV/ukMC9Ipe1mQq9G9FQRWELInQviX22EBqut05dyTQIAjB6C6X7uirQ+bUhzn
         oWPjWLzKE0D+uDB73gg/aAgAZNpYvUapKWVGtCJ9Lf/hhERJBlLHekxk3s8sjXl3rF6G
         lXycmG2tI6GZIxYaXrB0YYbILIiIR1MjoJOjvBEudut5FhmnCy5L2r/j8UWN8w92N/8O
         dgABLXOKWi3BFDK5CHdIBSN6tv3DM1DwSXvSjrGAn3TC+GiCj9WaIDppccTtYvXgi5Ip
         7fJOSQ5k8r3AOxH3GQNqfDNRZgwRwROsG5hrF9e3rNCCy1jNa7UQJrzee//qxzWKctGE
         TFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695919369; x=1696524169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPGh9unxuL2nJXgyj58qseqaVYwl19QlZd4mAA+cegs=;
        b=ORU7XiK+8m7BzNRYWgjq0OHM+c16YUtkitEfa9B46/XXsSbLaXA03g/I4sO4QT9Zao
         RsGubJjP/A8YOphxDwL5higNnwSF4ML/4rjM/CpEEv4UntkYoOYIAreAJneOVAvHoJI1
         xpaSBwIYHVqiyXv/kf3hSAHSLZ5eQHR2W44LOn65013JD8fSX1yfwdzDw4vjslgkg6HW
         Rvh7RzUNKF6Wa+j69ALckAJ6kmbAhc0v9OqXckYxNLvYjn2se+/S4FPvaimnWNfb0Xc3
         MVmDDLinfjOkH1OW3LNhq4ce16LEHGjegYSe2oSo/g6sK8uLsPDlLxhwNddHQBzshEsP
         4EAQ==
X-Gm-Message-State: AOJu0YwX/GNACmm70wpLWyuFAHzqEI9c4/jyIAhPnovbVAs3/El3kVYK
        5fKOqweEgbQAhvL/eVWixjTVFFo11JI=
X-Google-Smtp-Source: AGHT+IEL0P2IU2uKrDbVIaPhwCdXzE9Hq13ZgAB42CVQPMaI3EnedEdTWgNHYykexcrr04W6o8Oc96AsFhE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ec10:0:b0:59b:e97e:f7d7 with SMTP id
 q16-20020a0dec10000000b0059be97ef7d7mr27808ywn.1.1695919368962; Thu, 28 Sep
 2023 09:42:48 -0700 (PDT)
Date:   Thu, 28 Sep 2023 09:41:56 -0700
In-Reply-To: <20230504120042.785651-1-rkagan@amazon.de>
Mime-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169567773146.165747.5292830285056018670.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Roman Kagan <rkagan@amazon.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Hankland <ehankland@google.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 04 May 2023 14:00:42 +0200, Roman Kagan wrote:
> Performance counters are defined to have width less than 64 bits.  The
> vPMU code maintains the counters in u64 variables but assumes the value
> to fit within the defined width.  However, for Intel non-full-width
> counters (MSR_IA32_PERFCTRx) the value receieved from the guest is
> truncated to 32 bits and then sign-extended to full 64 bits.  If a
> negative value is set, it's sign-extended to 64 bits, but then in
> kvm_pmu_incr_counter() it's incremented, truncated, and compared to the
> previous value for overflow detection.
> That previous value is not truncated, so it always evaluates bigger than
> the truncated new one, and a PMI is injected.  If the PMI handler writes
> a negative counter value itself, the vCPU never quits the PMI loop.
> 
> [...]

Applied to kvm-x86 pmu, with a slightly massaged changelog.  Thanks!  And sorry
for the horrendous delay...

[1/1] KVM: x86/pmu: Truncate counter value to allowed width on write
      https://github.com/kvm-x86/linux/commit/b29a2acd36dd

--
https://github.com/kvm-x86/linux/tree/next
