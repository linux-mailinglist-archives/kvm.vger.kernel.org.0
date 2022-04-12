Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49E54FE947
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 22:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiDLUII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 16:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiDLUHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 16:07:21 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF4138
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:59:10 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id a12-20020a5d6cac000000b002079e81d09eso1847054wra.4
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:cc;
        bh=MENr6JaFQrvHMeFq6sKLlOwf0hec/wgSr+mPRwQN+l0=;
        b=My+M5BYSA+gXTB91tN4X1vERu3Z09Qivgl3WTvb6ePAQkulgyUSvxYka18IjQJ7/t2
         Cq3sU1nQYaJpHFTSlkXVKJ8UUMQ1ubXpUcCQ9kLG6/jA2FVXaNtjfAEeMO8x+8553/Nf
         Ais3vLlINs5YtZRDph09DA+j5IOvETna5R3sGs0kMF3MZFytYhogncyb8g511D/SZFi+
         1wzdybWE20l1obqfnCfyfvIO7Ci9nqbDcij6KIFyIh8gYwxyBOdw6TqFaBkR9yCygOQZ
         5yuy6vQGqNN2MCH7lruIJHLVfjz7iwgs0kNkdc3VejPACXrgG3SpCjWHclk+HHp5nxOc
         fvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:cc;
        bh=MENr6JaFQrvHMeFq6sKLlOwf0hec/wgSr+mPRwQN+l0=;
        b=rF0i9sYuOUA5VBc/tf7Z/3K4okXScBO4eoe+NfiuTsP96C8Chc44C8iF0X+0mC6p2v
         bmzBYtJz1QXk9Eh69XE9+Y/T7JNUX2ipt9mfRKiHZ/tKp9CtIZzG1ZFRir4COnzj9NFV
         Jc5LV7bxjV1I527Ig1RpWuFA3tPIj1Ho6CaRLPvWXxiASRy1g7D13BgiSZxYoAsR6RuW
         qaNHkQjVyIY+5Bl7JSctl0UnI+AzHQcHJKdAHBcx8UAfOcXejOlZBRvaw7BrmLEi0WA5
         dT4V0CEEKKMFnhVz3jhSZ55XyI5TAVGRyF1Zxpy6ziqJTe09OSLae0YQEsy6XczF/PPj
         iZbA==
X-Gm-Message-State: AOAM533o7TSARPSXZPUx4/DPhQMtiq4XmgLwm9Rc+rju99rYWLPN6YAz
        0ASJAC1MG67MHKW+7F8RhC28rn9yKnG+
X-Google-Smtp-Source: ABdhPJw2Al6hykQfZi1/dlidzpxWGtE3f4gUI8/c4WffSBjE7JfuGSFasTK/dm0mH0/G/0qN1nlYXc81X4cb
X-Received: from zhanwei.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2da8])
 (user=zhanwei job=sendgmr) by 2002:a7b:c5d1:0:b0:37f:a8a3:9e17 with SMTP id
 n17-20020a7bc5d1000000b0037fa8a39e17mr5371013wmk.109.1649793543167; Tue, 12
 Apr 2022 12:59:03 -0700 (PDT)
Reply-To: Wei Zhang <zhanwei@google.com>
Date:   Tue, 12 Apr 2022 19:58:44 +0000
Message-Id: <20220412195846.3692374-1-zhanwei@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH 0/2] KVM: x86: Fix incorrect VM-exit profiling
From:   Wei Zhang <zhanwei@google.com>
Cc:     Wei Zhang <zhanwei@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Sangwhan Moon <sxm@google.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The profile=kvm boot option has been useful because it provides a
convenient approach to profile VM exits. However, it's problematic because
the profiling buffer is indexed by (pc - _stext), and a guest's pc minus a
host's _stext doesn't make sense in most cases.

When running another linux kernel in the guest, we could work around the
problem by disabling KASLR in both the host and the guest so they have the
same _stext. However, this is inconvenient and not always possible.

We're looking for a solution to this problem. A straightforward idea is to
pass the guest's _stext to the host so the profiling buffer can be indexed
correctly. This approach is quite brute, as you can see in the prototype
patches.

We had some initial discussions and here is a short summary:
1. The VM-exit profiling is already hacky. It's collecting stats about all
   KVM guests bunched together into a single global buffer without any
   separation.
2. Even if we pass _stext from the guest, there are still a lot of
   limitations: There can be only one running guest, and the size of its
   text region shouldn't exceed the size of the profiling buffer,
   which is (_etext - _stext) in the host.
3. There are other methods for profiling VM exits, but it would be really
   convenient if readprofile just works out of box for KVM profiling.

It would be awesome to hear more thoughts on this. Should we try to fix the
existing VM-exit profiling functionility? Or should we avoid adding more
hacks there? If it should be fixed, what's the preferred way? Thanks in
advance for any suggestions.

Wei Zhang (2):
  KVM: x86: allow guest to send its _stext for kvm profiling
  KVM: x86: illustrative example for sending guest _stext with a
    hypercall

 arch/x86/kernel/setup.c       |  6 ++++++
 arch/x86/kvm/x86.c            | 15 +++++++++++++++
 include/linux/kvm_host.h      |  4 ++++
 include/uapi/linux/kvm_para.h |  1 +
 virt/kvm/Kconfig              |  5 +++++
 5 files changed, 31 insertions(+)

base-commit: 42dcbe7d8bac997eef4c379e61d9121a15ed4e36
-- 
2.35.1.1178.g4f1659d476-goog

