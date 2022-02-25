Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075B84C4D91
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiBYSX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiBYSXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:23:23 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FFC6E78C
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:22:51 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k13-20020a65434d000000b00342d8eb46b4so3029892pgq.23
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=x4Ku6YsMCKcusqhh1KEW7b8ua9qMmgZkvtpofAGbtVk=;
        b=RCy+rU96VujgIkYwHn+eJ5lO3hg6B5rvgAVjzyr0MvZ1ZAAaC6UXB+cPjHj469kxNY
         Dw/RtxHGBJYxtWSp0N+MA+FQg+U8eFE+C4uFNuV2LgxD+q84FNZsyaJANm2VwbaQlVFy
         gqjB10qjYVDsTOnCB+tre7f3ppLBqcZQMoQOO77NG0G9ZEAKYrAZsvPopKEjUHud6Eji
         j/4KlnmP+APgnEEeVFGEXmR+Jcxr3wj5lkdTlcY5lHXhtB4cvoq6WeNbwbMDKQRf7sFj
         AleA+MFbDA9x+F044WEpWtsjE+yir3y5MtRaHwORbGb+qEIqd3DdTJltzhXYaAsN6Yog
         hQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=x4Ku6YsMCKcusqhh1KEW7b8ua9qMmgZkvtpofAGbtVk=;
        b=GnmFnqFeU1kYyE2ry5dJK3SiEo3EWvbT5sCL5iP2KjoYMCAtycAxkAHugz7rNpBKcL
         TwkQZry1WAzaQ6Py3If6MBQ5sOJCK1bVWQ0rPxYhmBbTCZAu+M4yp01xUhJp19O6Szgr
         gES+Rd+s9/FgsWOtpOIAuOmrdRM11Xwn4anm+AlxNIr+EfnEohlLZHrq7DQv9o3z1XYA
         VBNLAtFJzYHKam8+7SGAMetOa6XNPUc4fqaqRcuopTmgqpElFTtRkXaRUKH45VcA7S+s
         /1njzjj90uT2M/alY4P+NOvVl/2laEaDDrTOpLAqQYjBxYJiu8O3vbCrngWdw1Zkvgha
         HqbA==
X-Gm-Message-State: AOAM531DsMplQP1GJdXzp8D7cHBX7Of3mIyNdYsdiRjx0zbVKaRiXmLd
        4vSsJ0dhIyDS/N/YjYjgSxmxBOh+rEE=
X-Google-Smtp-Source: ABdhPJzTwrVJB5RstZ5uRrPjtjrFdFuxWajJeU/80rhuK+/Xbgr9+0EWknI0rOF0W7DBGk7e5DIi5QEDmPQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4f43:b0:1bc:7e5c:e024 with SMTP id
 pj3-20020a17090b4f4300b001bc7e5ce024mr26588pjb.0.1645813370236; Fri, 25 Feb
 2022 10:22:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 25 Feb 2022 18:22:41 +0000
Message-Id: <20220225182248.3812651-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v2 0/7] KVM: x86/mmu: Zap only obsolete roots on "reload"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For all intents and purposes, this is an x86/mmu series, but it touches
s390 and common KVM code because KVM_REQ_MMU_RELOAD is currently a generic
request despite its use being encapsulated entirely within arch code.

The meat of the series is to zap only obsolete (a.k.a. invalid) roots in
response to KVM marking a root obsolete/invalid due to it being zapped.
KVM currently drops/zaps all roots, which, aside from being a performance
hit if the guest is using multiple roots, complicates x86 KVM paths that
load a new root because it raises the question of what should be done if
there's a pending KVM_REQ_MMU_RELOAD, i.e. if the path _knows_ that any
root it loads will be obliterated.

Paolo, I'm hoping you can squash patch 01 with your patch it "fixes".

I'm also speculating that this will be applied after my patch to remove
KVM_REQ_GPC_INVALIDATE, otherwise the changelog in patch 06 will be
wrong.

v2:
 - Collect reviews. [Claudio, Janosch]
 - Rebase to latest kvm/queue.

v1: https://lore.kernel.org/all/20211209060552.2956723-1-seanjc@google.com

Sean Christopherson (7):
  KVM: x86: Remove spurious whitespaces from kvm_post_set_cr4()
  KVM: x86: Invoke kvm_mmu_unload() directly on CR4.PCIDE change
  KVM: Drop kvm_reload_remote_mmus(), open code request in x86 users
  KVM: x86/mmu: Zap only obsolete roots if a root shadow page is zapped
  KVM: s390: Replace KVM_REQ_MMU_RELOAD usage with arch specific request
  KVM: Drop KVM_REQ_MMU_RELOAD and update vcpu-requests.rst
    documentation
  KVM: WARN if is_unsync_root() is called on a root without a shadow
    page

 Documentation/virt/kvm/vcpu-requests.rst |  7 +-
 arch/s390/include/asm/kvm_host.h         |  2 +
 arch/s390/kvm/kvm-s390.c                 |  8 +--
 arch/s390/kvm/kvm-s390.h                 |  2 +-
 arch/x86/include/asm/kvm_host.h          |  2 +
 arch/x86/kvm/mmu.h                       |  1 +
 arch/x86/kvm/mmu/mmu.c                   | 83 ++++++++++++++++++++----
 arch/x86/kvm/x86.c                       | 10 +--
 include/linux/kvm_host.h                 |  4 +-
 virt/kvm/kvm_main.c                      |  5 --
 10 files changed, 90 insertions(+), 34 deletions(-)


base-commit: f4bc051fc91ab9f1d5225d94e52d369ef58bec58
-- 
2.35.1.574.g5d30c73bfb-goog

