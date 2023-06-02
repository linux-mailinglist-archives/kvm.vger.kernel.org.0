Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9940671F7BB
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbjFBBW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbjFBBW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:22:26 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EA01A6
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:22:16 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53fa6346e9dso712378a12.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685668936; x=1688260936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VKisusFmkVhk5dJy6vX/QQKbujikMfaLMLUGIhUBWz8=;
        b=zn6QfjEawcC8YoqWhk+WQy3mMaihSJfWD54FYLHWFSbCC4nBEF3lWWaonob6KvX9Yj
         WDhB49b/VW1b9uiRxy6FaEbQmEDyweeOmp8PhljSVjJ4q/xMirF5H5E+Kquzuq9wL+Pt
         QmYOkKLp28p6axTvDIFnHvxYKV576a8ai6vhct710dKOyfLhWcWvo5chT1IUvhLdvLSg
         6CLSqJgd6YdvEmbuPiSxyUZMk/0W+42+tZ+1gDZ/NufM76kKntNJZDaJYIZaRM0/zA2H
         4lh9QHc7FzP7o8GIxTQ2Yauc7cvKCrC6zpve4NPlw0y6mHH/YzYk5MDCVW1HTxEMC6cx
         +uqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685668936; x=1688260936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VKisusFmkVhk5dJy6vX/QQKbujikMfaLMLUGIhUBWz8=;
        b=ZGaQWOPRCtqC03W//z4S8ssybUuRE14DhVoq6O85ZxPksDjkAjkvMo319iqVsYA6H0
         Q4/dWiJt9J5bnHVHGdxRuWl6VOldz7pS/26CZzO8O3etb4l3QEVy0/rBPqvDKBrrOVCi
         pChbydJIFvF7sQfFsUBJVdYQuzgiBknI2PI/9GGsV9AorX9/oXRSaRf1hMH8mOtDValk
         eO0yfw6tYrVS33El6Ch670C8bKMRx3tdw6rUDFO+lsbJQU0r39yumzkq7exYh2twqf86
         iYdZpF37E4R0iZUgjel2LtKrbpT8ianXuNslwaacPNuYczxXXFhMk6E/AXC3nlfI/9qe
         dFkg==
X-Gm-Message-State: AC+VfDzpRAflnfGMloVZNyujp2+lUgZoxUornLULU6nU2LpxkdFHyBK5
        Rxky58yo13nYBZIXFbFK2KB6ADX7yvE=
X-Google-Smtp-Source: ACHHUZ6SaKLwwiJ777JlJJZ+ElaOBzbVunt3pRk3+KPq1j8TJjz/11o+ItwS9JGzATtYJG7N/QMmMlMqChc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:201e:0:b0:51f:869d:d8db with SMTP id
 g30-20020a63201e000000b0051f869dd8dbmr2028287pgg.5.1685668936044; Thu, 01 Jun
 2023 18:22:16 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:21:49 -0700
In-Reply-To: <20230511233351.635053-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168565210307.661485.17815427865526599462.b4-ty@google.com>
Subject: Re: [PATCH v2 0/8] KVM: x86: Clean up MSR PAT handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 May 2023 16:33:43 -0700, Sean Christopherson wrote:
> Clean up KVM's handling of MSR PAT.  The PAT is currently lumped in with
> MTRRs, and while the PAT does affect memtypes, it's not an MTRR and is
> exempted from KVM's kludgy attempts to play nice with UC memory for guests
> with passthrough devices that have non-coherent DMA (KVM does NOT set
> "ignore guest PAT" in this case, and so the guest PAT is virtualized by
> hardware, not emulated by KVM).
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/8] KVM: VMX: Open code writing vCPU's PAT in VMX's MSR handler
      https://github.com/kvm-x86/linux/commit/a33ba1bf0dc6
[2/8] KVM: SVM: Use kvm_pat_valid() directly instead of kvm_mtrr_valid()
      https://github.com/kvm-x86/linux/commit/7aeae027611f
[3/8] KVM: x86: Add helper to query if variable MTRR MSR is base (versus mask)
      https://github.com/kvm-x86/linux/commit/ebda79e50577
[4/8] KVM: x86: Add helper to get variable MTRR range from MSR index
      https://github.com/kvm-x86/linux/commit/9ae38b4fb135
[5/8] KVM: x86: Use MTRR macros to define possible MTRR MSR ranges
      https://github.com/kvm-x86/linux/commit/34a83deac31c
[6/8] KVM: x86: Move PAT MSR handling out of mtrr.c
      https://github.com/kvm-x86/linux/commit/bc7fe2f0b751
[7/8] KVM: x86: Make kvm_mtrr_valid() static now that there are no external users
      https://github.com/kvm-x86/linux/commit/3a5f49078eb5
[8/8] KVM: x86: Move common handling of PAT MSR writes to kvm_set_msr_common()
      https://github.com/kvm-x86/linux/commit/dee321977a23

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
