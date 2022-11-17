Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F4B62CF5F
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 01:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbiKQARV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 19:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKQARR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 19:17:17 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE89D2F3AE
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:17:16 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id a6-20020a170902ecc600b00186f035ed74so61729plh.12
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m4x7FJ0UuVDG9aKbpg4fk0axLXovply23MnsYgQwgnc=;
        b=Pdlb4ZEqSP7apDZmvoYP6nhT5PGh0PcuB86pZgU5/RNRGXSkLUZEHf9KpYhFKXCzOz
         DgqSzZSf1IgZeh1HKuM8L1gmEitKqV2iPVDWDw8EcIpsfN0kIORNsCqxwSXVJei3Rb2u
         YlKt2XiM5XxeBfhnZq0ovgOwQVyfR6PmFJtMzRNszlP6c1qP4R2cvAxYg/QtkIhop4d8
         fjTJTA9EoJS/Ac2V39phArl4s9bQgc/onuwLQAMiOQNNEJvNYLXw9VF9WVqCCstnESvz
         W/pX8fnVU5O7izquIn7WV6/n1wAwwZmyFpCMi5soMgkr7im7xDNGMkSMRW/ELIbwsxoy
         mPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m4x7FJ0UuVDG9aKbpg4fk0axLXovply23MnsYgQwgnc=;
        b=iZiEy4QIoez0TcQkZcYiicOKnsf6bmpY6sL6rWqwKUSw9SrWvZucUpEoSwnYCVpQCu
         O+9SGKzPhBmLFA698VSgkcH8+eqLJqn986EHsX85QWNb9lbPvSkB96JXut44voCZYpTC
         M+yumpowm0AelAn139UCwXdh/DX2VGL+hM3AR4jxI0My4RH9d/pJhR8dKEOezUQdjhrc
         JAnNAgR0YYKGPTDsyuX2s5Inp5ZyWGxq8zdrnlpBLbcNtDLxJuEfDT4VH6GW47AuaUAl
         57NmIK4C3n69bPwZ7FM27on3CvcFD2z38vuWGwbFvykbEXEreRZB4cshv+0mKRneaRwd
         nupA==
X-Gm-Message-State: ANoB5pljAUUxMz14jMSR6k3XNYUKyARi+srVVi6tz3U+nt41NLxxANJa
        hnIMsziUsy4DdICtFwCKy2g0maDLbb5mnQ==
X-Google-Smtp-Source: AA0mqf79OafXf7+4o5SXmdQvPZvR8/Ks93l/NfPUG4GH5/+aPARoFR70hMGjrm0JvqTiWS8XV6X9iaRe52nB7A==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:15d1:b0:572:4ea6:ddc7 with SMTP
 id o17-20020a056a0015d100b005724ea6ddc7mr517972pfu.26.1668644236188; Wed, 16
 Nov 2022 16:17:16 -0800 (PST)
Date:   Wed, 16 Nov 2022 16:16:54 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117001657.1067231-1-dmatlack@google.com>
Subject: [RFC PATCH 0/3] KVM: Restore original behavior of kvm.halt_poll_ns
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Yanan Wang <wangyanan55@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series restores the original behavior of the module parameter
kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL. This should allow
admins to administer VMs not using KVM_CAP_HALT_POLL just as they were
before this capability was introduced.

VMs that use KVM_CAP_HALT_POLL can be administered through userspace
changes that invoke KVM_CAP_HALT_POLL (i.e. the capability can be
invoked multiple times to change the max halt poll time).

If any admin needs a system-wide override of KVM_CAP_HALT_POLL we can
add that through a new mechanism (e.g. a new bool module parameter).

Compile-tested only. I want to get feedback from Christian and Yunan if
this approach would address their concerns.

Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Yanan Wang <wangyanan55@huawei.com>

David Matlack (3):
  KVM: Cap vcpu->halt_poll_ns before halting rather than after
  KVM: Avoid re-reading kvm->max_halt_poll_ns during halt-polling
  KVM: Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL

 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 52 ++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 10 deletions(-)


base-commit: d663b8a285986072428a6a145e5994bc275df994
-- 
2.38.1.431.g37b22c650d-goog

