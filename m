Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F06866AC89
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 17:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjANQQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Jan 2023 11:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjANQQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Jan 2023 11:16:11 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5D57EFF
        for <kvm@vger.kernel.org>; Sat, 14 Jan 2023 08:16:04 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id g20-20020a17090adb1400b0022941a246aaso999837pjv.0
        for <kvm@vger.kernel.org>; Sat, 14 Jan 2023 08:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ddF4ManzZhqa5SXP5hluB+g3L8XUAVj+gr84Ax3pZFc=;
        b=p+bmH68o/76Ql/dmrbbofvKKxaKG5NUkBJh8IgLrVhzMf96WZsDP2U/DiYrf3+kyOU
         x4sqm/i+HBW9aiM1sGjDoC2MZxp42wKSk0xHCWDc6t4DbPuwUXodrlKp5FycP/Hx7AIB
         zKD5UfMukeFvBaYLOWdS6EIoJUdF8wBh7M92E/g8GvR3pADQyTrGjWcabPjQXrjWkuUN
         aq+R1kzTU0jfsdX14yh+6RYtDFXIYmJr4BRjgnC5dxrjka5937jWGwI1Pgrq5agslTbn
         kARXAeCXj+XuadQhzOLfl5MZBBKEWKFmHRJyuZ8TBNxtm3IDh6SPHv/Xj9WisZQ+IE+G
         1fSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ddF4ManzZhqa5SXP5hluB+g3L8XUAVj+gr84Ax3pZFc=;
        b=br8N5S5dZRO70g7cpAVkcypP8BsjbHcvzpPtrPrjbfN1lyyfawfkkPm6ciSLbpHF0m
         bwEsglnMHX42FL+itQNzjOKiCBRMpJtUTPmzMK27deQcyhOzrxnlJWifke6YM/O/O/b+
         PqlAr6hKPxTIl9ObzlPBhv2QmF0Wpxp9e1SeebkRXDiGEAxkGKJe3yIc6m5mIGL2uhmO
         TgkKcAnTk84qqZtxugQ9E0t67nNPEkIA05jqe9G25SCkUCUaxoiLvUWhzpXW+H0Nza7E
         X3vPsDprmwvwZ9OGhQUmSX9l2pO3Ls8R47jh+rs/cvEpb56ac1AyUNHwWJZMgezDmdEO
         Wfqg==
X-Gm-Message-State: AFqh2kq8eiyVlekkdfxo7iMLF3Vjkl1B3nWXgYcqWh9Nx2qeQsV9QcLR
        0xfLAHoXtBU8EQWf7RLX6aDmjJDjRaNWp62X8A==
X-Google-Smtp-Source: AMrXdXt7KMCGUZ85pcsMjWqjEdVWaMat+Qb9InGkgYa79/eD2LR6U7nua3XHqx6AzqtHWcO3Cqk65U7ml8hrr34W0w==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:a17:902:7444:b0:18c:1bc5:ab84 with
 SMTP id e4-20020a170902744400b0018c1bc5ab84mr262748plt.105.1673712964124;
 Sat, 14 Jan 2023 08:16:04 -0800 (PST)
Date:   Sat, 14 Jan 2023 16:15:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230114161557.499685-1-ackerleytng@google.com>
Subject: [PATCH 0/2] Fix kvm_setup_gdt and reuse in vcpu_init_descriptor_tables
From:   Ackerley Tng <ackerleytng@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Wei Wang <wei.w.wang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove discrepancy between kvm_setup_gdt and vcpu_init_descriptor_tables
by fixing initialization of limit in kvm_setup_gdt and reusing
kvm_setup_gdt in vcpu_init_descriptor_tables.

Ackerley Tng (2):
  KVM: selftests: Fix initialization of GDT limit
  KVM: selftests: Reuse kvm_setup_gdt in vcpu_init_descriptor_tables

 tools/testing/selftests/kvm/lib/x86_64/processor.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--
2.39.0.314.g84b9a713c41-goog
