Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE7780296
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356641AbjHRAM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356752AbjHRAMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:12:54 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3B93C30
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:12:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26b4020fa34so492460a91.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692317536; x=1692922336;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YI+px4fWIrcz8CUG0KC1uIUK7AnSC5+MoX0wNUm9NKo=;
        b=XbxmTmy27uaIcJDYAR3lyOLlKyz2Mi17sg+aHfzQxaHEyrIvAlS9ybcj/4aIqpFJ6k
         tgE7YK/rC7xG9sXGhv+Ucxhyo2GGmBpvMK7ywcryOfZsD+L0fcwLfG9YjyiUfKySVmvt
         Nd4sd7FfiDcupRvBJX5TdrOfv6RzGMq6pYVOnPQcwp0/29u3yiTDAhMrRCkPi0RnmglR
         Yazr99JDIDLw9s1jcxUyoHdLwBYWoMUWiM6qNq199HcaNtCWPHCtgRL743IG0aZRr/ZV
         uioCSY0ryR0N/I5YthRqMN+MerCJ+JEGn++LMGymE5C9fkEaszwtk8C/fnjKGdocRJSe
         tuxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692317536; x=1692922336;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YI+px4fWIrcz8CUG0KC1uIUK7AnSC5+MoX0wNUm9NKo=;
        b=fc61iss0+jkYy1/z3nB4BSZYPvnm32HqUbMfYtkgXjxJh7DlG6DCqn75iMYhWHtmKl
         I45PzUhTwihAg/sD8lmgRB+4atVcF3D20SyRYRzZ7uaIvnPUoq3GQGH0qggEUMuANrX5
         l5+198cylSWWlknD97dk+GvmE3+sCIiT30aCroTskJT9TKA1WjDevxyYWcsmz0hRCFM4
         lj9qQ8SGBgpjjrgti3EXDLECwLBll8vgnsQSnDch1pigTMDgfeyW0SskYZNk3BbGI+cN
         kPY3tJw4Pltnd4NJnP+Pqav69G9BIGAteREIG/EC4sHYZ7mm54piIIcpBOHeg67plZ6D
         7A3g==
X-Gm-Message-State: AOJu0YxekQnjBfBhXzlIu5imzM4hJJchXKdyPsxjq9k5caB4krSAb4hr
        9n0RaaPdm8IBvhjID0whwKC30mvNLcE=
X-Google-Smtp-Source: AGHT+IG1p3dJVwfEGQ1dfJ2h8Y7P+0UyR58+z6UiYediut5nwHBboD9dWVhenb9Uo4cyOTTO2wrkY66kguQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:108d:b0:263:317f:7ca4 with SMTP id
 gj13-20020a17090b108d00b00263317f7ca4mr256618pjb.9.1692317536334; Thu, 17 Aug
 2023 17:12:16 -0700 (PDT)
Date:   Thu, 17 Aug 2023 17:12:00 -0700
In-Reply-To: <20230729005200.1057358-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729005200.1057358-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169230015618.1264622.714933097966873011.b4-ty@google.com>
Subject: Re: [PATCH v2 0/5] KVM: x86/mmu: Don't synthesize triple fault on bad root
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jul 2023 17:51:55 -0700, Sean Christopherson wrote:
> Rework the handling of !visible guest root gfns to wait until the guest
> actually tries to access memory before synthesizing a fault.  KVM currently
> just immediately synthesizes triple fault, which causes problems for nVMX
> and nSVM as immediately injecting a fault causes KVM to try and forward the
> fault to L1 (as a VM-Exit) before completing nested VM-Enter, e.g. if L1
> runs L2 with a "bad" nested TDP root.
> 
> [...]

With some trepidation that I'm overlooking something, applied to kvm-x86 mmu.
Patches 1-4 are worthwhile on their own, so even if the actual fix is wildly
broken somehow and needs to be reverted, it'll just be that one commit that
gets nuked.

[1/5] KVM: x86/mmu: Add helper to convert root hpa to shadow page
      https://github.com/kvm-x86/linux/commit/732f57612d5c
[2/5] KVM: x86/mmu: Harden new PGD against roots without shadow pages
      https://github.com/kvm-x86/linux/commit/9e3f832edfca
[3/5] KVM: x86/mmu: Harden TDP MMU iteration against root w/o shadow page
      https://github.com/kvm-x86/linux/commit/004c297c327f
[4/5] KVM: x86/mmu: Disallow guest from using !visible slots for page tables
      https://github.com/kvm-x86/linux/commit/81d4621b7d9f
[5/5] KVM: x86/mmu: Use dummy root, backed by zero page, for !visible guest roots
      https://github.com/kvm-x86/linux/commit/a328a359d99b

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
