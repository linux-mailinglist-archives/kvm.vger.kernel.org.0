Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F82502FA9
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 22:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbiDOUSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 16:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350744AbiDOUSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 16:18:21 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548F33B285
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:52 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id o17-20020a92c691000000b002c2c04aebe7so5332121ilg.8
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3xc2EKUu7uEnFMNYX7NeITwrWrqypsePgkOpoddgFwU=;
        b=tmcVwYAmxAJM9UgwFDjZQ16XftORi9A9sl5AipqBPgT7NRV1vrOnjEP4zBug6x3tA/
         DN4CsZ9KXfZDT8gu9DbnRwt0D4GZg3DaNX2xejBjQc63+fdl+m20G5n4eRDLJlE7ptoS
         +cgZSE8MECVoWsQy2G86Y0zvgzuEGh4Z1vJK1lUuclinVwoejHm+4dYquAjp6t9uAZLL
         gihMbvvSjbUfX4Kfn17gkfh3TOyIoOad17RuR3n/FbAcahRyPo5Dc0TSTLCS53aFLJaF
         1UOQ7gYhGtWFV31HrYDLgQoH0fNkaMsrR4lggvDWgewho2MM9QCgfxen2mNOZAC+agzw
         Q4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3xc2EKUu7uEnFMNYX7NeITwrWrqypsePgkOpoddgFwU=;
        b=3aPYK7+iM6T1XBWbfZt1S5QmcJVm6V+Oymua1HpfTCN0I7ZuQ/Ii5VcYtM9bSAyPwW
         CI7iPx51FGc8lEGRdE5EMLs5E8lNHoGYk00gtlJtXSKMSNdcCrZsPZc32ZK4ChknTnHz
         2gRoL8GX3Ae20GekMIKAZRMNi6Vihkfb6SOugH8qrcS+AlKah5PtiFR3PWjTGjjf74u0
         kLyYudmoM6deVJUGKHmV37BMGEUCXhVap5+jtq705co+ZgLkkiD89onNnMsRa+wq9fWE
         6ho8ll6aBJEXFVxqRLPEtznrLDThPKYnFBYTa+p7C+5Fyg22SUEOAteNqm7czSMkjoZz
         eBuw==
X-Gm-Message-State: AOAM533HJWpIulPX+eOiya6RLXOHHDlTG+bseBejL+w88A+19yc4GlnY
        gVdRqvRWxA1k+AVPXgwXiHAz5Sat9VBHT9NhDGRfY0yYdeb/TuSjZlTp9ni90VxQdpiFQKnS6eo
        iXqBuIYCM5xVISj7qN4Nojr4NygR6yK20WhEg1iTlRwrTDzkkW4H0SXS+Qw==
X-Google-Smtp-Source: ABdhPJyw2If8M9jrUYo8GVts2nmzPWzbxeagQwSB0CGagwUUffSrDGf7s83sV+p4canIjwMHVePF0iQWEQA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2c46:b0:653:879e:4490 with SMTP id
 x6-20020a0566022c4600b00653879e4490mr194901iov.130.1650053751645; Fri, 15 Apr
 2022 13:15:51 -0700 (PDT)
Date:   Fri, 15 Apr 2022 20:15:40 +0000
In-Reply-To: <20220415201542.1496582-1-oupton@google.com>
Message-Id: <20220415201542.1496582-4-oupton@google.com>
Mime-Version: 1.0
References: <20220415201542.1496582-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 3/5] KVM: Get an fd before creating the VM
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org, Oliver Upton <oupton@google.com>
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

Hoist fd init to the very beginning of kvm_create_vm() so we can make
use of it in other init routines.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aaf8de62b897..1abbc6b07c19 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4752,25 +4752,27 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
 
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
-	int r;
+	int r, fd;
 	struct kvm *kvm;
 	struct file *file;
 
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
 	kvm = kvm_create_vm(type);
-	if (IS_ERR(kvm))
-		return PTR_ERR(kvm);
+	if (IS_ERR(kvm)) {
+		r = PTR_ERR(kvm);
+		goto put_fd;
+	}
+
 #ifdef CONFIG_KVM_MMIO
 	r = kvm_coalesced_mmio_init(kvm);
 	if (r < 0)
 		goto put_kvm;
 #endif
-	r = get_unused_fd_flags(O_CLOEXEC);
-	if (r < 0)
-		goto put_kvm;
-
 	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (IS_ERR(file)) {
-		put_unused_fd(r);
 		r = PTR_ERR(file);
 		goto put_kvm;
 	}
@@ -4782,17 +4784,19 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	 * care of doing kvm_put_kvm(kvm).
 	 */
 	if (kvm_create_vm_debugfs(kvm, r) < 0) {
-		put_unused_fd(r);
 		fput(file);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto put_fd;
 	}
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
 
-	fd_install(r, file);
-	return r;
+	fd_install(fd, file);
+	return fd;
 
 put_kvm:
 	kvm_put_kvm(kvm);
+put_fd:
+	put_unused_fd(fd);
 	return r;
 }
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

