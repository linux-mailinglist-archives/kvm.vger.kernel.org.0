Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57652788F0D
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 21:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjHYTCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 15:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjHYTCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 15:02:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032BD2127
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:01:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7814efcccbso1577114276.0
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692990118; x=1693594918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yB25VmLsZ05XCxrScAEBUUZ2TzeRvANuVQ5uvbtI2cs=;
        b=JmV2U2qMmNMZxe94Ua1X2AkpJCVskBqzdJe8fc5fkmPKf8h+oTXK7NMe+EaOWZlifM
         S9z2ssAg1mJzovGTe1x4TiConlEGEBw/D3JzthnxvrV6WwWuZCe+oHuDl1jaGA0LVm8z
         yJE4lQWQCNYVMHWqBc5dz4YNExv12tE/+2gtRu9RWc0WrXzqUV1XVyLeY47aqcH9mx4n
         kwFI5qu5uaRvjdXsTSS67CaQtT+Ch7o91SlndOJpYtz1b7tnr6Kk5QE4b9cgP71ondLa
         Y4lo+GpNTKs8BAKb53aWGWozgydoAIJYaTcrhversHA3JhOEW0AzWIHa4JLG2rZvwS9N
         V1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692990118; x=1693594918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yB25VmLsZ05XCxrScAEBUUZ2TzeRvANuVQ5uvbtI2cs=;
        b=iJbHqrVHrvlYgwcvTMI+XLa99+8Nxeq5VEXsGW/KQKaeg8fIcoBYt2Qvojf6aTPHCZ
         n6oUs4YQI+zjXsRvyDm03vK3Y+UVZwpCga7fjWD97C5yZBrM2J/eriQqw/suThCxcDTL
         aAHQ5xfdkU1Wm1EHQ1q0g/khI8UsfAc7ORVzfRuwMUMqdPaoJQhi1b6iZ6DNdnk0myMP
         9yyXEojj58ysPMBv0AmyLckW/h0V1M2QLq898Apy0/1Nfck4DkCEVuSEy9LyEcAv9iDG
         ls1ofYyAifK0BAnktPadPA13cjfPgG38T8j4XojI6ul9Y3G0MmNw5owl2ZSjgUQy44Tl
         snuQ==
X-Gm-Message-State: AOJu0Yxci0cMMvVTPDBCJg7dpnddbboaJ6SQ/4NNARwz0xjfKs4Fzl6G
        /lnK4WCpR9DO30VhdbjMtiOpmOuUiWE=
X-Google-Smtp-Source: AGHT+IHKz4maR/Ue5JgIvKQgfAheQjp7Anr9d18U6qw5jkQVZoJRmhdsuyzq3d++9C63AVpT28uWvnkQKRg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:108f:b0:d7a:bf7d:bc0f with SMTP id
 v15-20020a056902108f00b00d7abf7dbc0fmr18959ybu.3.1692990118310; Fri, 25 Aug
 2023 12:01:58 -0700 (PDT)
Date:   Fri, 25 Aug 2023 12:01:42 -0700
In-Reply-To: <20230817233430.1416463-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230817233430.1416463-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <169297947911.2871633.4127274459666234045.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Fix sync_regs race tests on AMD
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Aug 2023 16:34:28 -0700, Sean Christopherson wrote:
> The recently introduced sync_regs subtests to detect TOCTOU bugs hang on
> AMD because KVM synthesizes INIT on triple fault shutdown (because AMD says
> the VMCB is undefined after shutdown).  Fix it by loading known good state
> if a shutdown occurs.
> 
> Patch two explicitly injects #UD as the "good" vector so that the test
> doesn't rely on KVM inadvertantly setting the vector to #DE (old, buggy
> behavior).
> 
> [...]

Applied to kvm-x86 selftests.

[1/2] KVM: selftests: Reload "good" vCPU state if vCPU hits shutdown
      https://github.com/kvm-x86/linux/commit/5002b112a5ad
[2/2] KVM: selftests: Explicit set #UD when *potentially* injecting exception
      https://github.com/kvm-x86/linux/commit/02dc2543e379

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
