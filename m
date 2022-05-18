Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0F752C1EA
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbiERR70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241251AbiERR7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:59:16 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900678CB37
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:14 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id b20-20020a62a114000000b0050a6280e374so1486506pff.13
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OZkEtfeO16+WBXKIrEVzWaZgX0pGEVfJdhpX9jyjq9s=;
        b=XJnCL2DYM9o+Jy3j+sEoMXrtNq6JAflArhwOtUHIjrEJ8kcHsgAPojP2qMv6peZSpu
         AVnDrXhMKunZ+7DZv8Ykv0Xkyb4dOPzi3bZnMCqecQ2bk5JiSZNRSl5Ll4UYCVlHOF9l
         vrMxF6Hgc8ELAaEsQW04jMYqjYJulXTOreiHeNdsa5Zv6D+y5WW11Ee6AKmwybmm8JX1
         SBi5k0bDcYSbA9Q4cQNcBwwYLFFiPoU6k2ncYTfq6vQQGTST7+g+Ay8IDn63zRbNrdUq
         VdqpFcYBnP9M/mrXKdjnnCiIAKV+DZB4adpHjcpMLZeJb3vOBQodZed2QVril2oAvOZP
         CQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OZkEtfeO16+WBXKIrEVzWaZgX0pGEVfJdhpX9jyjq9s=;
        b=uf3x9lYCU5vLZiIUWi8umCj61+yQOMFEj5h46hWp/WTKlIG+zgaVkBnkMi31js+ulb
         RoskFVVYF6qpU2fJ4LfDPeZhepHFkjuv+hlPwFWjFORFxfUBYCWUYqpfnDkIQXROczfS
         NLeBZPQ9VeqAXMlNxt6N8o2jU+zUso45FXhS845lhX+kwWQputiv+X14JZxQTARgB5Co
         6cASx2OBxL5C8/QWUs2Xx07O4x69YA0YAgqu2HQI9gCVcmoihZ7rOe6BgwNubYN1dxLm
         GNuP+CNR8fpOgdx5DkKUye0xQLLSRES3+B5gBmT2YJiEL4auOXn7E3Frri0CHITMoI/6
         bvLw==
X-Gm-Message-State: AOAM533iOCmQJCN+28awEU13ZG6bkTK2deeU0qdrHxtVeLnAdFTEgI4P
        qXNzfV0IuIQqwDSRa487pXITB5fbETIBDCsYuUnY5JvV2lN58l7acNHiuv3XG284RYCxslJ5J4Q
        9HKtqctkReno85hptFkAY57Xm0P2YMFXDIGGDi7V7Ti4ItF5xDFZK0DvPug==
X-Google-Smtp-Source: ABdhPJx5Hvz7aJKam/sS0xyXJXyVtOFQQc1blLiFh+vfuuj+mPAMcQ+wZ2ANZdo1mfsv8fBY7dTmpQyN9J0=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:22d4:b0:510:6d75:e3da with SMTP id
 f20-20020a056a0022d400b005106d75e3damr520307pfj.3.1652896753816; Wed, 18 May
 2022 10:59:13 -0700 (PDT)
Date:   Wed, 18 May 2022 17:58:09 +0000
In-Reply-To: <20220518175811.2758661-1-oupton@google.com>
Message-Id: <20220518175811.2758661-4-oupton@google.com>
Mime-Version: 1.0
References: <20220518175811.2758661-1-oupton@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 3/5] KVM: Get an fd before creating the VM
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

Hoist fd init to the very beginning of kvm_create_vm() so we can make
use of it in other init routines.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 778151333ac0..87ccab74dc80 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4774,25 +4774,27 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
 
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
@@ -4804,17 +4806,19 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
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
2.36.1.124.g0e6072fb45-goog

