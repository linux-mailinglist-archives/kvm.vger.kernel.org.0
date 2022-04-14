Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED91F501B7F
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344827AbiDNTBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 15:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344964AbiDNTBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 15:01:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC52DE9940
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:59:05 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h9-20020a631209000000b0039cc31b22aeso3132925pgl.9
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wZ/1jFiq6Usx/60i+DBalln4Dj8ARLD+7QK5ceGGV6U=;
        b=qxIRneZRlqtc0Jy9HRbbY9jJj4X530oD4QZGVGV4n9ChTqvBFqLTauRyh0cdkTKBy4
         sf65KtEwoCAbx/2K6M/dgpozvuwH0wijJ1cPJzMBZxKmhRpM3TGHPTxjbHS3HOutTdMI
         EMU5M4tZv+/D6Etvrr+eGDCL1qUY89mPOg0pwory1BHj/+6b8T7ao53aFKwDPm5x0BWa
         8QlS8yULau+szm5VsqKNhHxEIlrPeErJBK6IP6zL1djEbek8sXywIUYO6SmyzCJWilnn
         ipkdfOs99dG436kZ8antE3q2+xr57WEFQQihTh7fEDQOf4fp+poVJ2GAtk+NrUxS8RmC
         9pag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wZ/1jFiq6Usx/60i+DBalln4Dj8ARLD+7QK5ceGGV6U=;
        b=ho6XLARWBW2U2IvNMAIUkAzB3YNwlsXiMRHq4S3YPUqTyUZ/7mYJl/T1oUwPmCwHyt
         QnxIY9YnhU8obGdndOxNqz6bIFMGseEqAoW+QrOm6nAeTUo0J+f9gv9Db0rDARNKCbiI
         PJCW/Jx3wwK9SR2IGWIHLRG1UzR8BdSVh8/0MWrS6GQbxAQICCLa5p3JBvvwc+CwsRFk
         ylfndBYv2RdUpKqWGnwJP+NPXjHeH6LiU1EjRirXFuVfkR6mFQCEj1YH/tq+2+7ZKcL0
         x2LCGiUtE+R/hlwwzEmUpuhC85D9wDibfi2eA/QQ7H/Q5oltTUjDX3+RQVt+ytCEkXvE
         oZLw==
X-Gm-Message-State: AOAM5323IlUpCOYmkGnmZMU+tu2twLYUQQbrNErFrKgF+lvHkyjyfIMT
        QVSPBEc2vXQ3XBBk30qFzVdm9x3xjJRc1o7iRG0kK9mt93StCX6R2JcbeBRQvtt9s9c35z8+LaM
        w1WvkSDI+0kcBi1a1peIMggmzzSALxgx8KkkYD2nIq6S1Luche3V5xTZRNZM4ZwA=
X-Google-Smtp-Source: ABdhPJxZnVfK6EWLyf8y50n4qg0AUlgUM+iN9O+g59HlIQAPwDGZrlbbPuuHVz5NNY0zlNUes6MOKTZJXcy8Vw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:1397:b0:505:c8d2:d5e5 with SMTP
 id t23-20020a056a00139700b00505c8d2d5e5mr5334011pfg.45.1649962745038; Thu, 14
 Apr 2022 11:59:05 -0700 (PDT)
Date:   Thu, 14 Apr 2022 11:58:53 -0700
Message-Id: <20220414185853.342787-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [kvm-unit-tests PATCH] x86: VMX: Require 16-byte alignment for struct vmx_msr_entry
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, aaronlewis@google.com
Cc:     Jim Mattson <jmattson@google.com>
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

The MSR-store area and the MSR-load areas must be 16-byte aligned, per
the hardware specification.

Fixes: bd1bf2d6af77a ("VMX: Test MSR load/store feature")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/vmx_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index df931985ec46..4d98b7cb08dd 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1959,7 +1959,7 @@ struct vmx_msr_entry {
 	u32 index;
 	u32 reserved;
 	u64 value;
-} __attribute__((packed));
+} __attribute__((packed, aligned(16)));
 
 #define MSR_MAGIC 0x31415926
 struct vmx_msr_entry *exit_msr_store, *entry_msr_load, *exit_msr_load;
-- 
2.36.0.rc0.470.gd361397f0d-goog

