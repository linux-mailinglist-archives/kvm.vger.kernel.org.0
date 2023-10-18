Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316637CE952
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjJRUqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjJRUqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:46:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97774109
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:46:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9bc6447193so5479868276.3
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697661991; x=1698266791; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YCKlkz4R2Q6RU5vodf+rWJY1o344ijixhxmOi/luL3I=;
        b=K85kBLV8EULs9R1khIPPnbT9jHWvSZj2v4ju/jHnqAt7cRtCuP1qbhAal+B+JLDpsh
         4DJ7Tdx26Mzfvj4R/QOQlP5gStlK+3dK9Pt4XYrDrvYjA2qPxfGW4eEkk2JPPM4wN8iT
         2/ybukWxaU1eVA0pQE1P1F84XbCqd6nQtJxtOpuOuYLQmvDumXybtslxRn0DinSpPyQm
         t5dkqdpUFPGwjxzW2xS2V56+b3IGKDl9swAdvWCB/+ag/m6+YBbg4NUHks8T2QlbVSMQ
         msHtOKW2qW6GePgNDDhrRzS2/Y408gB/us4laXNg9GpkTnDDRZVaJre0ZAZzYJAVXB6M
         94yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697661991; x=1698266791;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YCKlkz4R2Q6RU5vodf+rWJY1o344ijixhxmOi/luL3I=;
        b=PRfUz6MKb4EUSt/loC/QJsy6b2xh1adFDKDep17JiXyaVwV1vuiNY9F3DyXBkpypkJ
         z9Z9eDa7YM7BcyquJEDL1wGOoXH/ze2ul6f9sTyq2TnlcYh9Ir3L1jyVaVnre577/w6h
         StChdEQxrSTqi5IdXWWQeymVk/Rs5YEzGA4yzBUNf9fFIGe93/JB7+uboYDKWziY1Col
         F7YFRHDbjpX8R7ncX8aizAqV92YaMJU18yk6X9gcywgUJLWx59eKMPXSGyJ8OTxfgMSX
         4yxKo8XrCoLBJuXCIhwX++IRSIhOICurdDD04UZbYT7RlHrxJWUruneHSehKoCdh2WRf
         heMw==
X-Gm-Message-State: AOJu0YxY9hiLEGP3pvU0xZKR3BERaQWZWws7odLwsTIzY/ji/KyBFM8M
        X2eSDWaie+q3rIFHHK3a2y0fnyoZSi4=
X-Google-Smtp-Source: AGHT+IEvWcULir+fy3kukn4lCaSrU2SEZY1rlzQWn4K6zYhDP3EK+lSGeXZ2L94lVbOF6m7rXneINQWJqGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:76cc:0:b0:d9a:3f67:672c with SMTP id
 r195-20020a2576cc000000b00d9a3f67672cmr13828ybc.3.1697661991383; Wed, 18 Oct
 2023 13:46:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 13:46:21 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018204624.1905300-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: Fix KVM-owned file refcounting of KVM module(s)
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up a KVM module refcounting mess that Al pointed out in the context
of the guest_memfd series.  The worst behavior was recently introduced by
an ill-fated attempt to fix a bug in x86's async #PF code.  Instead of
fixing the underlying bug of not flushing a workqueue (see patch 2), KVM
fudged around the bug by gifting every VM a reference to the KVM module.

That made the reproducer happy (hopefully there was actually a reproducer
at one point), but it didn't fully fix the use-after-free bug, it just made
the bug harder to hit.  E.g. as pointed out by Al, if kvm_destroy_vm() is
preempted after putting the last KVM module reference, KVM can be unloaded
before kvm_destroy_vm() completes, and scheduling back in the associated
task will explode (preemption isn't strictly required, it's just the most
obvious path to failure).

Then after applying that "fix", we/I made an even bigger goof by relying on
the nonexistent "protection" provided by the VM's reference and removed the
code which guaranteed that the KVM module would be pinned until *after* the
last reference to a KVM-owned file was put.

Undo the mess we created and fix the original async #PF workqueue bug.

Sean Christopherson (3):
  KVM: Set file_operations.owner appropriately for all such structures
  KVM: Always flush async #PF workqueue when vCPU is being destroyed
  Revert "KVM: Prevent module exit until all VMs are freed"

 arch/x86/kvm/debugfs.c |  1 +
 virt/kvm/async_pf.c    | 15 ++++++++++++---
 virt/kvm/kvm_main.c    | 18 ++++++++----------
 3 files changed, 21 insertions(+), 13 deletions(-)


base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
-- 
2.42.0.655.g421f12c284-goog

