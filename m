Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B1D79AF1E
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjIKUsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243920AbjIKSUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 14:20:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADACE110
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:20:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so4599962276.2
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694456416; x=1695061216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OO6hJ0ABYHN8zgIR4FZOYgzIVAhANS0xV5LilSo/dHk=;
        b=ersXw9r9uoiv5mvyyEKcAe+M6JGdytgwJhzWem6aMdKeCQjxmbXe6qhJj0Q2EBA0CV
         KypGv+76Y5536aPQlosoYMt6c7XH4USLHmWDmFJtW0BOgMpYtFtFFd3O9M4PQ4YPofoN
         Zq0YHn7g/bgTatJGbh+Cchct4sjvEQ63aXleSw8TBGslgvlgtqRsLl2mNvsWoI7xXWNm
         WAkcpNbq7jVf576nR6qBpyGxrgkofBtzRjVfQWqUlP73p0GOX9byq4PXIa+cM0X2L4Yz
         yjg8RowXfLCwcC6LmKWOsvkzov6HvIkMLzekClatli4SRUJ50gpjklsC47VIw/sKV6AN
         Ff5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694456416; x=1695061216;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OO6hJ0ABYHN8zgIR4FZOYgzIVAhANS0xV5LilSo/dHk=;
        b=aQsR50+XQxm7Qo7OQXEK6RcXC+qfOiJjGpHzVpPBVmCPAeSKwWA9NFuz4sBoJYbYBT
         T5KqbBpRNTNK0JjiWQW+tci0xuFIfdRifMiXFYqoyG1bEE/DcHR4sVxG7ludoRCVRdZm
         KHX0PruOLkYX9r9p01/smHZNb7fRcz3lwjiLMGFOmJE5fA1Q+A2sx+2KSmrmIOiZXZpB
         DBm/YX2dTpGfLde7BDuaiIp7sBStEgzsiMiLw9H99RTOpZ/GyvXeMZaYq8eLGzM2Ir1Z
         //LgQTDbv3B5Dy44taZN3OIGkKpM4afydUi2nxK76+uPNRY4pu+FFziZbJpEzALiGt/t
         ealQ==
X-Gm-Message-State: AOJu0Yza2vB7cREzNaQNwZNi51vKIFEvZqMc/UJIbaiTlBShaEZX9IP2
        xoHv059tsI9ZyXLPKUrntYN4ABErnMw=
X-Google-Smtp-Source: AGHT+IFiZFhsjOA5AHhA0tEr+/3w8LcO/rFF+A/QTjr/VDrVtAR0GVfuegGZQphHd/lb0wkGbxbobF8uh58=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1682:b0:d73:bcb7:7282 with SMTP id
 bx2-20020a056902168200b00d73bcb77282mr255582ybb.8.1694456415922; Mon, 11 Sep
 2023 11:20:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Sep 2023 11:20:10 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230911182013.333559-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/3] nVMX: Test for EP4TA pointing at MMIO
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Finally posting the testcase for the fix to back !visible roots with a dummy
root[*].  The testcase is very simple: point EP4TA at MMIO (TPM base), do
VM-Enter, and expect the VM to not die.

[*] https://lore.kernel.org/all/20230729005200.1057358-6-seanjc@google.com

Sean Christopherson (3):
  nVMX: Use helpers to check for WB memtype and 4-level EPT support
  nVMX: Use setup_dummy_ept() to configure EPT for test_ept_eptp() test
  nVMX: Add a testcase for running L2 with EP4TA that points at MMIO

 x86/vmx_tests.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)


base-commit: d4fba74a42d222d2cfdde65351fac3531a1d6f5c
-- 
2.42.0.283.g2d96d420d3-goog

