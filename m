Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4E376F693
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 02:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjHDAld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 20:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbjHDAlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 20:41:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A5444BB
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 17:41:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d087ffcc43cso1621995276.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 17:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691109670; x=1691714470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dTRvsnA+sbELxPyIEK/hSeGyuRvQauNjtE64dh76l8c=;
        b=VSuDJJHNeUoVx6l0JPqzaBceM+hyywBdUbXpILDREbokx0PXni4MowRVRKHm6t5PWT
         hSpTtj3GsZxZjqabXsReth4gMm1EZtOPvhuvD8Wr2I06KocfOgLOhWsRrhoB3KBDYAcr
         H+5fz7AL+xvseCnn5pHXWHBD0t22vtrH+5SA04ln5bpAVfEWmWvpVgWEO/iHz5hX3kFd
         D6GZbvE8opQskeMDdqt59Tme2YJNfsr5AZf7+Jetp5qzNSo+jnzKlbm26LWD/ezzSb57
         kgmbUyGrxiEL2jbfRPuUu3b/6o0AwRsXGr+TWP/STqXd95n2hpFgy4P4QnY5hMVY1Aji
         k7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691109670; x=1691714470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTRvsnA+sbELxPyIEK/hSeGyuRvQauNjtE64dh76l8c=;
        b=bpp8pX1VfPt39Pd5MAj82WfR0B1mmFTyBF10Vt6IMCWPVSZEDLjAeSRhAKQcBzZEKK
         9taqMUDqQUueVk8fWifoU362U03ntIXESfUw7RgEkp1Afs7rdO16VtVAss6+qEaeiEAx
         lVpXIuvvYzAu6jdOyKjolmel8AaH5pt9DG4LgKanNNfYkftO3gcWj5NYMcMAUjsdQias
         gqimly7tvjomoqbs3yUF3btCjjYw32ifDFTYpAnTDAUUeBFjCShVco+m2YsUi3z0auQR
         ybJlnAHTKW6Lu418eFku1gw7lJvAMJof+O+FlbkiKhGlQXr5Y4Ih9qIpL4KCqiFKD+BP
         zTwQ==
X-Gm-Message-State: AOJu0YwyoPfNQ0rjsGWIHZ4Y1pgy18DssOGcHgIr6nWFDUvlIvDY5aMs
        1M/ya2PCTJ/r3xoRR6Qwfs/YeOrLvJ0=
X-Google-Smtp-Source: AGHT+IEqjrZWPwzIg1XIGKUTbpToRYXrPYXW6KBqyej+Tw1G5y4hQN63MGdAwKIEQVCE5Ssqr58kfePnomw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1364:b0:d14:6868:16a3 with SMTP id
 bt4-20020a056902136400b00d14686816a3mr722ybb.5.1691109670401; Thu, 03 Aug
 2023 17:41:10 -0700 (PDT)
Date:   Thu,  3 Aug 2023 17:41:04 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169110163548.1962937.16775471389381796228.b4-ty@google.com>
Subject: Re: [PATCH v3 00/12] KVM: x86/mmu: Clean up MMU_DEBUG and BUG/WARN usage
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jul 2023 17:47:10 -0700, Sean Christopherson wrote:
> This series consist of three loosely related miniseries:
> 
>  1. Remove the noisy prints buried behind MMU_DEBUG, and replace MMU_DEBUG
>     with a KVM_PROVE_MMU Kconfig.
> 
>  2. Use WARN_ON_ONCE() for all runtime WARNs, i.e. avoid spamming the
>     kernel log if something goes awry in the MMU.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[01/12] KVM: x86/mmu: Delete pgprintk() and all its usage
        https://github.com/kvm-x86/linux/commit/5a9481e69942
[02/12] KVM: x86/mmu: Delete rmap_printk() and all its usage
        https://github.com/kvm-x86/linux/commit/ed501863ae54
[03/12] KVM: x86/mmu: Delete the "dbg" module param
        https://github.com/kvm-x86/linux/commit/f01ebf874adb
[04/12] KVM: x86/mmu: Avoid pointer arithmetic when iterating over SPTEs
        https://github.com/kvm-x86/linux/commit/c7784ee6cc06
[05/12] KVM: x86/mmu: Cleanup sanity check of SPTEs at SP free
        https://github.com/kvm-x86/linux/commit/064a5ab685bd
[06/12] KVM: x86/mmu: Rename MMU_WARN_ON() to KVM_MMU_WARN_ON()
        https://github.com/kvm-x86/linux/commit/e1cb291d66ac
[07/12] KVM: x86/mmu: Convert "runtime" WARN_ON() assertions to WARN_ON_ONCE()
        https://github.com/kvm-x86/linux/commit/50719bc3dda9
[08/12] KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode without PAE enabled
        https://github.com/kvm-x86/linux/commit/4f121b5d2228
[09/12] KVM: x86/mmu: Replace MMU_DEBUG with proper KVM_PROVE_MMU Kconfig
        https://github.com/kvm-x86/linux/commit/982758f88bb9
[10/12] KVM: x86/mmu: Use BUILD_BUG_ON_INVALID() for KVM_MMU_WARN_ON() stub
        https://github.com/kvm-x86/linux/commit/bc90c971dcb7
[11/12] KVM: x86/mmu: Plumb "struct kvm" all the way to pte_list_remove()
        https://github.com/kvm-x86/linux/commit/472ba3231883
[12/12] KVM: x86/mmu: BUG() in rmap helpers iff CONFIG_BUG_ON_DATA_CORRUPTION=y
        https://github.com/kvm-x86/linux/commit/21baf78ef845

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
