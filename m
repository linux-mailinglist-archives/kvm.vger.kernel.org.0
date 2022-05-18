Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2952C1E2
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241267AbiERR7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiERR7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:59:11 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50B08CB0D
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j13-20020a170902da8d00b00161d78a9e3eso76353plx.17
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fMGKhekV0sa/YRSHAxxD4jBJX+Cxj4sGMKO6wGVMLLU=;
        b=rDo4lZZNt9Jya8MiZXgjYNXvz5J37fb6AuEUs8DN3vWndBXOI1tlgJDwCnvUKvBPc6
         TnxRUc2etnh7q3vcNtEJshhc10uQivQXWKv6a8RKBrOUXLNW3i9tz5EGrsvAcVoADMiL
         PvNIKKOQMpui5nbSexy36l2tOwTHjFolG+IARW9zKt9E0WsklNY44NvY7EeSIM1LAImr
         Qdh1TwS91bwJhJQCqcCHxjySJSl0uXy2thSsDiVRnnjlIcxwEEC5/N6c0tEtDCClsxFr
         WAgaQSTqdu1IYn2f/p7uzC4BPyx+3E9A3cU+HE2HUs8/0d37lyEl4oXbbkNUg4GBWFXk
         XEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fMGKhekV0sa/YRSHAxxD4jBJX+Cxj4sGMKO6wGVMLLU=;
        b=tGwUxXZ/t41aX8PS6MIh//sU+N8UImlbdZMljSx/TaoMrjckWsftVpL8E2RKxZV/bS
         1f+lFgVwSUG9T81No+euCLb4LeRZnlKQnNyflyT3yAMw9UkKlPQTAen0GNSzRSQ66YXg
         fRSUmkkiMU4bx3/8BtQ0pFwUulNgkoZbRaf/iI70U6HhNCUx7hqGHFZ7xONARwVwwheo
         Ax2c0+fShGefpSkv5vwE4lRq09rLt1GRG5bV2vBu3lGfpXpW7RL3I9tbL/eb+UXahJ41
         +Njbuwnzb9EChf8ER5jbHhNrVzCG7nRmp986LcQilDP8Tn5Wgu3qg0oxgQ3/k5ffYyZZ
         DTXQ==
X-Gm-Message-State: AOAM5302yeg4421bh54QBqxycW/SaKKup/HG7V8tWj/0w4SxjmchjlEt
        0ogwrTirauCyIqoNZeNHnq6TBhhKwegLMS8L1hUKWuNKbL7E+h7vf+SRhqMWPXsyUTFTuZ5/2K0
        B1cd7LjJxFIiiwOYnqjUB0QrQOp4UyDt57xQTENH5o9zCBoag/oQX6yn0dA==
X-Google-Smtp-Source: ABdhPJyZ+5KTCDASJ2VzQHVK+2cDZhp3NrE9g00eRb9QNAZGfGNos3Q7HEHF07BETonFHNlM4Zm3P3D3UZ0=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:24c1:b0:50d:33cf:811f with SMTP id
 d1-20020a056a0024c100b0050d33cf811fmr827317pfv.78.1652896749987; Wed, 18 May
 2022 10:59:09 -0700 (PDT)
Date:   Wed, 18 May 2022 17:58:07 +0000
In-Reply-To: <20220518175811.2758661-1-oupton@google.com>
Message-Id: <20220518175811.2758661-2-oupton@google.com>
Mime-Version: 1.0
References: <20220518175811.2758661-1-oupton@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 1/5] KVM: Shove vm stats_id init into kvm_create_vm()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
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

Initialize the field alongside the other struct kvm fields. No
functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6d971fb1b08d..36dc9271d039 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1101,6 +1101,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	 */
 	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
 
+	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
+			"kvm-%d", task_pid_nr(current));
+
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
 	if (init_srcu_struct(&kvm->irq_srcu))
@@ -4787,9 +4790,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	if (r < 0)
 		goto put_kvm;
 
-	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
-			"kvm-%d", task_pid_nr(current));
-
 	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (IS_ERR(file)) {
 		put_unused_fd(r);
-- 
2.36.1.124.g0e6072fb45-goog

