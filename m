Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263E0526ABB
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383929AbiEMTuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383906AbiEMTuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:50:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30B92705
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 12:50:03 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x4-20020a1709028ec400b0015e84d42eaaso4821941plo.7
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 12:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=onR+IAdvbrh29QlHrJFJC3XkwYk8RO06sVRPQTeuosI=;
        b=ou/upypMhXJ5+lQwkAxvNENX6+krgADpFac2G5De1yC0Aa4TR7AEfnZ3gF12OrK3gV
         pl9FTsHSRNkhJ7JWuYRPAIVsTGw9CMfCMpbdPRzc79tODYud4oFHHNreUyxhlilIzgiB
         G7EqC81Abimzt07H6ZTGrFwyeJVMAkjP5Llxi7POMqjI4Y7KYlGvRMqIOA96N2lBez7+
         eobZnNql4GYqBhrPSG57U+ql6veGPjHvCNVX2gjrImlLZWAnsWQLOY2CIRGDBChOdCMC
         lEReWm2yl/tSVh5TYUjyxaF0aShDMiKFx6AVxG8wrdpHCQD2lkQeyyRC9N/SfHYWqCJ5
         R8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=onR+IAdvbrh29QlHrJFJC3XkwYk8RO06sVRPQTeuosI=;
        b=4m/TvJahmhbOOYA67rKrkVVyWYhLOgjTKrNvqDcCRgpbsfuWgnCg9I+0fkdn+Qcp4/
         Ad0Avooq8aXaGiwKPQGZZ1JGksGHecz7trX/JfhDvzDGmb8fLklVSBnzOrRWHncTk81w
         JFa//cq7NtZQhnfkvx1hoHB75WL4c7MP0ZqmivRmSz+ME5/RUhOhFvqG2UNPPRJH/daF
         pSoreleu5OLc0Un08RjC2k7RzowDq1pK0m+RsmG0fm7rZSfMOdeWsT+P24MXGts8Bj8P
         VZb2pRzky07GDErtXw6B1dSQmna5eo34O/GLx6dg4D89kFWhMmrSf4A6yfqBtZTmGKuL
         E3NQ==
X-Gm-Message-State: AOAM531FGe8FS3b9GiAmnTgxzz0Fl57Bgu0tLe7M9V+eaSsKpj1Ry18S
        s2ZlFTFUEyzs7nl5RC2bI9zEMVdyhvU=
X-Google-Smtp-Source: ABdhPJyF5uQdJtxHRZaq+0AeanakOcMb8v9LGxfVMwRQxk1lBhpuYUOQvtS/4W2krnVvP39amF9bKuQns9M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:1107:b0:15e:f451:4034 with SMTP id
 n7-20020a170903110700b0015ef4514034mr6282232plh.3.1652471403382; Fri, 13 May
 2022 12:50:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 13 May 2022 19:49:58 +0000
Message-Id: <20220513195000.99371-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 0/2]  KVM: x86/mmu: nEPT X-only unsync bug fix
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a contrived bug where KVM can create a shadow-present SPTE with RWX=0
if L1 modifies an existing RX or RWX 4kb SPTE to be X-only and the combined
permissions for the upper level SPTEs yield !X.

Patch 2 adds a comment explaining why FNAME(sync_page) isn't repsonsible
for flushing synchronized entries that reduce protections, e.g. drop X
(or add NX).  Lack of a flush made me do a double-take and a lot of
staring.

Sean Christopherson (2):
  KVM: x86/mmu: Drop RWX=0 SPTEs during ept_sync_page()
  KVM: x86/mmu: Comment FNAME(sync_page) to document TLB flushing logic

 arch/x86/kvm/mmu/paging_tmpl.h | 18 +++++++++++++++++-
 arch/x86/kvm/mmu/spte.c        |  2 ++
 2 files changed, 19 insertions(+), 1 deletion(-)


base-commit: 2764011106d0436cb44702cfb0981339d68c3509
-- 
2.36.0.550.gb090851708-goog

