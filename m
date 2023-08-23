Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F6B7863E9
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 01:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbjHWXV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 19:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236710AbjHWXV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 19:21:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD97E5F
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 16:21:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-cf4cb742715so7012978276.2
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 16:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692832885; x=1693437685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rpLC9clh3aho8QzOtmAgfvKrN+/XGvak1AmvjxHFfxs=;
        b=up/mMiM6kiXyJexbp8QMQgcI46X7A2KAdkVTn7kM5VtqtIrVtYYa+HfU8mzsXIQicC
         2Bde4VNLwHIKsgef4xKpNsvc0UNevOf9I7Iy/cbbYfPloZ5H762x1cASaEIGG8JKh+8A
         SQfJx0F1wsgkXKpswgPA8Yd5OlUB3qvncgMQQfFRR65gPN/qEBtWPr4LfafCtLlmyUjh
         WD0+1y1cBLGxs0EuAk8qqWRlDVOPAgWEjOb4BSkEeYO1ravW6Jrolg4cHDEZE7u82E4z
         QL1Y7ZWENaJcK3HZvdX3NeC+WA/PBUYReGh9MudDD+zNejsNz1Kw49x1MWJlVeTZEoMV
         MXHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692832885; x=1693437685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rpLC9clh3aho8QzOtmAgfvKrN+/XGvak1AmvjxHFfxs=;
        b=bqGEVqaz77/hCy7lypzA76Jttu17+a/vM8imYQg+odf5sAuyTrhSHy35PEJBmFSdof
         MjotJ3aiX5Vt6zzcpXNa8iOdwVmGtObhQasQmlTiKnphWakwqv841+BOXhBNNiQ+qSpi
         b2/GDfUEwZpwJwWh2wIfqWx6bHE+etzqhkPu41Ezv8xpdS+/9sU1wnPbU5Om8Cp6/Ftj
         jlFo4/6RQvwfoI1khSBeEQLOsWIvvR35bnl38rfa/PJV3W+ZB2So6LrlvT+PbRnLaeWg
         mBI/vT2yCgIyAfPCTjAJ0uwjwcsr1+jHugZqn2gf9ZBg9wTxKuAWkT2eTwXFowiVWDxk
         qM1w==
X-Gm-Message-State: AOJu0YwSfjf2rZha7qDIlUPBIbr0QkKKpKfollROxfXFI0VMqONvXtSP
        6YszTiJ3Kfk23TFTYMb2PUCFa2pt1r4=
X-Google-Smtp-Source: AGHT+IERLyKMXAzftilm99T/yvQp2Pp8XnzsSLFwilBI2KE63z8HtaMZl5rZqHu0Pau6KYZjQtT6bAfbu/c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:209:0:b0:cb6:6c22:d0f8 with SMTP id
 9-20020a250209000000b00cb66c22d0f8mr180135ybc.4.1692832885769; Wed, 23 Aug
 2023 16:21:25 -0700 (PDT)
Date:   Wed, 23 Aug 2023 16:21:24 -0700
In-Reply-To: <347d3526-7f8d-4744-2a9c-8240cc556975@ewheeler.net>
Mime-Version: 1.0
References: <ZN+BRjUxouKiDSbx@google.com> <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net>
 <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net> <ZOP4lwiMU2Uf89eQ@google.com>
 <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net> <ZOTQPUk5kxskDcsi@google.com>
 <58f24fa2-a5f4-c59a-2bcf-c49f7bddc5b@ewheeler.net> <ZOZH3xe0u4NHhvL8@google.com>
 <db7c65b-6530-692-5e50-c74a7757f22@ewheeler.net> <347d3526-7f8d-4744-2a9c-8240cc556975@ewheeler.net>
Message-ID: <ZOaUdP46f8XjQvio@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
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

On Wed, Aug 23, 2023, Eric Wheeler wrote:
> 22:23:31:481644 tid[142943] pid[142917] SPTE @ rip ffffffffa43ce877 (1196 hits), gpa = cf7b000, hva = 7f6d24f7b000, pfn = 1e35fc6
> 22:23:31:481645 tid[142943] pid[142917] MAP_RET @ rip ffffffffa43ce877 (1196 hits), gpa = cf7b000, hva = 7f6d24f7b000, pfn = 1e35fc6, ret = 4
> 22:23:31:481650 tid[142943] pid[142917] FAULTIN @ rip ffffffffa43ce877 (1197 hits), gpa = cf7c000, hva = 7f6d24f7c000, flags = 0 : MMU seq = 4724e, in-prog = 0, start = 7f6d24f7b000, end = 7f6d24f7c000
> 22:23:31:481653 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1197 hits), gpa = cf7c000 (cf7c000), hva = 7f6d24f7c000, pfn = 0, tdp_mmu = 1, role = 3784, count = 2
> 22:23:31:481658 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1197 hits), gpa = cf7c000 (cf7c000), hva = 7f6d24f7c000, pfn = 0, tdp_mmu = 1, role = 3784, count = 1
> 22:23:31:481660 tid[142943] pid[142917] FAULTIN_RET @ rip ffffffffa43ce877 (1197 hits), gpa = cf7c000, hva = 7f6d24f7c000 (7f6d24f7c000), flags = 0, pfn = 1ee7439, ret = 0 : MMU seq = 4724f, in-prog = 0, start = 7f6d24f7c000, end = 7f6d24f7d000
> 22:23:31:481665 tid[142943] pid[142917] FAULTIN @ rip ffffffffa43ce877 (1198 hits), gpa = cf7c000, hva = 7f6d24f7c000, flags = 0 : MMU seq = 4724f, in-prog = 0, start = 7f6d24f7c000, end = 7f6d24f7d000
> 22:23:31:481666 tid[142943] pid[142917] FAULTIN_RET @ rip ffffffffa43ce877 (1198 hits), gpa = cf7c000, hva = 7f6d24f7c000 (7f6d24f7c000), flags = 0, pfn = 1ee7439, ret = 0 : MMU seq = 4724f, in-prog = 0, start = 7f6d24f7c000, end = 7f6d24f7d000
> 22:23:31:481667 tid[142943] pid[142917] MAP @ rip ffffffffa43ce877 (1199 hits), gpa = cf7c000, hva = 7f6d24f7c000, pfn = 1ee7439
> 22:23:31:481668 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1199 hits), gpa = cf7c000 (cf7c000), hva = 7f6d24f7c000, pfn = 1ee7439, tdp_mmu = 1, role = 3784, count = 1
> 22:23:31:481669 tid[142943] pid[142917] SPTE @ rip ffffffffa43ce877 (1199 hits), gpa = cf7c000, hva = 7f6d24f7c000, pfn = 1ee7439
> 22:23:31:481670 tid[142943] pid[142917] MAP_RET @ rip ffffffffa43ce877 (1199 hits), gpa = cf7c000, hva = 7f6d24f7c000, pfn = 1ee7439, ret = 4
> 22:23:31:481673 tid[142943] pid[142917] FAULTIN @ rip ffffffffa43ce877 (1200 hits), gpa = cf7d000, hva = 7f6d24f7d000, flags = 0 : MMU seq = 4724f, in-prog = 0, start = 7f6d24f7c000, end = 7f6d24f7d000
> 22:23:31:481676 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1200 hits), gpa = cf7d000 (cf7d000), hva = 7f6d24f7d000, pfn = 0, tdp_mmu = 1, role = 3784, count = 2
> 22:23:31:481677 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1200 hits), gpa = cf7d000 (cf7d000), hva = 7f6d24f7d000, pfn = 0, tdp_mmu = 1, role = 3784, count = 1
> 22:23:31:481678 tid[142943] pid[142917] FAULTIN_RET @ rip ffffffffa43ce877 (1200 hits), gpa = cf7d000, hva = 7f6d24f7d000 (7f6d24f7d000), flags = 0, pfn = 4087d5, ret = 0 : MMU seq = 47250, in-prog = 0, start = 7f6d24f7d000, end = 7f6d24f7e000
> 22:23:31:481682 tid[142943] pid[142917] FAULTIN @ rip ffffffffa43ce877 (1201 hits), gpa = cf7d000, hva = 7f6d24f7d000, flags = 0 : MMU seq = 47250, in-prog = 0, start = 7f6d24f7d000, end = 7f6d24f7e000
> 22:23:31:481683 tid[142943] pid[142917] FAULTIN_RET @ rip ffffffffa43ce877 (1201 hits), gpa = cf7d000, hva = 7f6d24f7d000 (7f6d24f7d000), flags = 0, pfn = 4087d5, ret = 0 : MMU seq = 47250, in-prog = 0, start = 7f6d24f7d000, end = 7f6d24f7e000
> 22:23:31:481684 tid[142943] pid[142917] MAP @ rip ffffffffa43ce877 (1202 hits), gpa = cf7d000, hva = 7f6d24f7d000, pfn = 4087d5
> 22:23:31:481684 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1202 hits), gpa = cf7d000 (cf7d000), hva = 7f6d24f7d000, pfn = 4087d5, tdp_mmu = 1, role = 3784, count = 1
> 22:23:31:481685 tid[142943] pid[142917] SPTE @ rip ffffffffa43ce877 (1202 hits), gpa = cf7d000, hva = 7f6d24f7d000, pfn = 4087d5
> 22:23:31:481686 tid[142943] pid[142917] MAP_RET @ rip ffffffffa43ce877 (1202 hits), gpa = cf7d000, hva = 7f6d24f7d000, pfn = 4087d5, ret = 4
> 22:23:31:481689 tid[142943] pid[142917] FAULTIN @ rip ffffffffa43ce877 (1203 hits), gpa = cf7e000, hva = 7f6d24f7e000, flags = 0 : MMU seq = 47250, in-prog = 0, start = 7f6d24f7d000, end = 7f6d24f7e000
> 22:23:31:481691 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1203 hits), gpa = cf7e000 (cf7e000), hva = 7f6d24f7e000, pfn = 0, tdp_mmu = 1, role = 3784, count = 2
> 22:23:31:481692 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1203 hits), gpa = cf7e000 (cf7e000), hva = 7f6d24f7e000, pfn = 0, tdp_mmu = 1, role = 3784, count = 1
> 22:23:31:481694 tid[142943] pid[142917] FAULTIN_RET @ rip ffffffffa43ce877 (1203 hits), gpa = cf7e000, hva = 7f6d24f7e000 (7f6d24f7e000), flags = 0, pfn = 51c5ee, ret = 0 : MMU seq = 47251, in-prog = 0, start = 7f6d24f7e000, end = 7f6d24f7f000
> 22:23:31:481697 tid[142943] pid[142917] FAULTIN @ rip ffffffffa43ce877 (1204 hits), gpa = cf7e000, hva = 7f6d24f7e000, flags = 0 : MMU seq = 47251, in-prog = 0, start = 7f6d24f7e000, end = 7f6d24f7f000
> 22:23:31:481698 tid[142943] pid[142917] FAULTIN_RET @ rip ffffffffa43ce877 (1204 hits), gpa = cf7e000, hva = 7f6d24f7e000 (7f6d24f7e000), flags = 0, pfn = 51c5ee, ret = 0 : MMU seq = 47251, in-prog = 0, start = 7f6d24f7e000, end = 7f6d24f7f000
> 22:23:31:481699 tid[142943] pid[142917] MAP @ rip ffffffffa43ce877 (1205 hits), gpa = cf7e000, hva = 7f6d24f7e000, pfn = 51c5ee
> 22:23:31:481699 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1205 hits), gpa = cf7e000 (cf7e000), hva = 7f6d24f7e000, pfn = 51c5ee, tdp_mmu = 1, role = 3784, count = 1
> 22:23:31:481700 tid[142943] pid[142917] SPTE @ rip ffffffffa43ce877 (1205 hits), gpa = cf7e000, hva = 7f6d24f7e000, pfn = 51c5ee
> 22:23:31:481701 tid[142943] pid[142917] MAP_RET @ rip ffffffffa43ce877 (1205 hits), gpa = cf7e000, hva = 7f6d24f7e000, pfn = 51c5ee, ret = 4
> 22:23:31:481703 tid[142943] pid[142917] FAULTIN @ rip ffffffffa43ce877 (1206 hits), gpa = cf7f000, hva = 7f6d24f7f000, flags = 0 : MMU seq = 47251, in-prog = 0, start = 7f6d24f7e000, end = 7f6d24f7f000
> 22:23:31:481706 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1206 hits), gpa = cf7f000 (cf7f000), hva = 7f6d24f7f000, pfn = 0, tdp_mmu = 1, role = 3784, count = 2
> 22:23:31:481707 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1206 hits), gpa = cf7f000 (cf7f000), hva = 7f6d24f7f000, pfn = 0, tdp_mmu = 1, role = 3784, count = 1
> 22:23:31:481708 tid[142943] pid[142917] FAULTIN_RET @ rip ffffffffa43ce877 (1206 hits), gpa = cf7f000, hva = 7f6d24f7f000 (7f6d24f7f000), flags = 0, pfn = 1ee50ee, ret = 0 : MMU seq = 47252, in-prog = 0, start = 7f6d24f7f000, end = 7f6d24f80000
> 22:23:31:481712 tid[142943] pid[142917] FAULTIN @ rip ffffffffa43ce877 (1207 hits), gpa = cf7f000, hva = 7f6d24f7f000, flags = 0 : MMU seq = 47252, in-prog = 0, start = 7f6d24f7f000, end = 7f6d24f80000
> 22:23:31:481712 tid[142943] pid[142917] FAULTIN_RET @ rip ffffffffa43ce877 (1207 hits), gpa = cf7f000, hva = 7f6d24f7f000 (7f6d24f7f000), flags = 0, pfn = 1ee50ee, ret = 0 : MMU seq = 47252, in-prog = 0, start = 7f6d24f7f000, end = 7f6d24f80000
> 22:23:31:481714 tid[142943] pid[142917] MAP @ rip ffffffffa43ce877 (1208 hits), gpa = cf7f000, hva = 7f6d24f7f000, pfn = 1ee50ee
> 22:23:31:481714 tid[142943] pid[142917] ITER @ rip ffffffffa43ce877 (1208 hits), gpa = cf7f000 (cf7f000), hva = 7f6d24f7f000, pfn = 1ee50ee, tdp_mmu = 1, role = 3784, count = 1
> 22:23:31:481715 tid[142943] pid[142917] SPTE @ rip ffffffffa43ce877 (1208 hits), gpa = cf7f000, hva = 7f6d24f7f000, pfn = 1ee50ee
> 22:23:31:481716 tid[142943] pid[142917] MAP_RET @ rip ffffffffa43ce877 (1208 hits), gpa = cf7f000, hva = 7f6d24f7f000, pfn = 1ee50ee, ret = 4

This vCPU is making forward progress, it just happens to be taken lots of fualts
on a single RIP.  MAP_RET's "ret = 4" means KVM did inded "fix" the fault, and
the faulting GPA/HVA is changing on every fault.  Best guess is that the guest
is zeroing a hugepage, but the guest's 2MiB page is mapped with 4KiB EPT entries,
i.e. the vCPU is doing REP STOS on a 2MiB region.

> > 21:25:50:282711 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92234 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282714 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92235 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282720 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92237 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282723 tid[3484173] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (92238 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282726 tid[3484173] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (92239 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000

...

> > 21:25:50:282354 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90073 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282418 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90087 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282475 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90100 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282507 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90107 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282524 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90111 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282528 tid[3484174] pid[3484149] FAULTIN @ rip ffffffff814e6ca5 (90112 hits), gpa = 1343fa0b0, hva = 7feb409fa000, flags = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282557 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90118 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000
> > 21:25:50:282571 tid[3484174] pid[3484149] FAULTIN_RET @ rip ffffffff814e6ca5 (90121 hits), gpa = 1343fa0b0, hva = 7feb409fa000 (7feb409fa000), flags = 0, pfn = 18d1d46, ret = 0 : MMU seq = 8002dc25, in-prog = 0, start = 7feacde61000, end = 7feacde62000

These vCPUs (which belong to the same VM) appear to be well and truly stuck.  The
fact that you got prints from MAP, MAP_RET, ITER, and SPTE for an unrelated (and
not stuck) vCPU is serendipitious, as it all but guarantees that the trace is
"good", i.e. that MAP prints aren't missing because the bpf program is bad.

Since the mmu_notifier info is stable (though the seq is still *insanely* high),
assuming there's no kernel memory corruption, that means that KVM is bailing
because is_page_fault_stale() returns true.  Based on v5.15 being the last known
good kernel for you, that places the blame squarerly on commit
a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update").
Note, that commit had an unrelated but fixed by 18c841e1f411 ("KVM: x86: Retry
page fault if MMU reload is pending and root has no sp"), but all flavors of v6.1
have said fix and the bug caused a crash, not stuck vCPUs.

The "MMU seq = 8002dc25" value still gives me pause.  It's one hell of a coincidence
that all stuck vCPUs have had a sequence counter of 0x800xxxxx.

<time goes by as I keep staring>

Fudge (that's not actually what I said).  *sigh*

Not a coincidence, at all.  The bug is that, in v6.1, is_page_fault_stale() takes
the local @mmu_seq snapshot as an int, whereas as the per-VM count is stored as an
unsigned long.  When the sequence sets bit 31, the local @mmu_seq value becomes
a signed *negative* value, and then when that gets passed to mmu_invalidate_retry_hva(),
which correctly takes an unsigned long, the negative value gets sign-extended and
so the comparison ends up being

	if (0x8002dc25 != 0xffffffff8002dc25)

and KVM thinks the sequence count is stale.  I missed it for so long because I
was stupidly looking mostly at upstream code (see below), and because of the subtle
sign-extension behavior (I was mostly on the lookout for a straight truncation
bug where bits[63:32] got dropped).

I suspect others haven't hit this issues because no one else is generating anywhere
near the same number of mmu_notifier invalidations, and/or live migrates VMs more
regularly (which effectively resets the sequence count).

The real kicker to all this is that the bug was accidentally fixed in v6.3 by
commit ba6e3fe25543 ("KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()"),
as that refactoring correctly stored the "local" mmu_seq as an unsigned long.

I'll post the below as a proper patch for inclusion in stable kernels.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 230108a90cf3..beca03556379 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4212,7 +4212,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
  * root was invalidated by a memslot update or a relevant mmu_notifier fired.
  */
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
-                               struct kvm_page_fault *fault, int mmu_seq)
+                               struct kvm_page_fault *fault,
+                               unsigned long mmu_seq)
 {
        struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
 
P.S. FWIW, it's probably worth taking a peek at your NUMA setup and/or KSM settings.
2 billion invalidations is still quite insane, even for a long-lived VM.  E.g.
we (Google) disable NUMA balancing and instead rely on other parts of the stack
to hit our SLOs for NUMA locality.  That certainly has its own challenges, and
might not be viable for your environment, but NUMA balancing is far from a free
lunch for VMs; NUMA balancing is a _lot_ more costly when KVM is on the receiving
end due to the way mmu_notifier invalidations work.   And for KSM, I personally
think KSM is a terrible tradeoff and should never be enabled.  It saves memory at
the cost of CPU cycles, guest performance, and guest security.

