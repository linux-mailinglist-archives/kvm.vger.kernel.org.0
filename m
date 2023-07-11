Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855A874FB9E
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 01:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjGKXBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 19:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjGKXBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 19:01:38 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A44310CF
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:37 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-57704a25be9so2141507b3.1
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689116496; x=1691708496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wQ6W4kIntv9wFXwEtPmIvIpacLwVSVo7NJzU3VtiE1w=;
        b=3ORxn9Vhd4WXF0g7JDL6HBWL9k07DS8mYs9fn0OJUVMYO7awAduaCjkyXa3c4zcUWP
         CiMyMGWKk7gpHnFuYLbMUK9kvuawoMxaIU5xCb4PbrzBwNxGeIU03YPFn53IH9fPrqeX
         4FmTRkGhTHmOdCaZo/KIiAYJHZJ7xAvzMNbMTF2zTxH+n26utIZyh9RcbGfVY0YuOUAY
         y1agF/SkbXq6mvekFU03VqWiBTZiO0EljkyR/3Myi3Flrjtcedmj8KWUU1JHb75p6S/R
         VDL1tRai9UtK+iTVKTCqi+bXRmThYcXrJnJmqF9LyRxNIYLV4jA/f3UBqV+05g/WhPYh
         3mJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689116496; x=1691708496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wQ6W4kIntv9wFXwEtPmIvIpacLwVSVo7NJzU3VtiE1w=;
        b=E+ykS95QDKbCux/UdVXhOZQBsvkaa1GlagVAssDY8Zr8Ua5bz+kw3V+hgxF1jqgtRB
         9QWD2cz/ZNhPuQy9kd7y/KwzZmbe/XxvRcOBFA03mlc8RM1fQNBEwdRiA9s8yep9ZF04
         O0s3hsfF8ZBDL4hkt0A4sJwOl54wows4/8qJxbl5bp4SlG5bJbFZLu84UX4PZsUcRisD
         BLyuj0in6EI+HZaGWhzM21EbxE9+q+2sM5fV/yoK/gQvBZHTaYSdXpesriFulcprRGWf
         J0JuRUPzjux1TV2QKC1zVhXjhvUX28RSjnNF8qZ3h5vfpCu2PGiqRLYPDA/pHSqVNRUU
         DsAQ==
X-Gm-Message-State: ABy/qLaJP0hgD+Fe71VCOmU+0klj55HQtnzEzscXSR9cJME+Un5dhk82
        Ims+2Zlo9vokOY/B/SQREKOWPmXO04k=
X-Google-Smtp-Source: APBJJlHY1zUMZmD84o0W3pNWXRl+ifCASv/QArdWkFNwOfiiRusxKodO28LqgUUoEWUMxCkFV3iHUrKcU5w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af18:0:b0:576:e268:903d with SMTP id
 n24-20020a81af18000000b00576e268903dmr3211ywh.2.1689116496718; Tue, 11 Jul
 2023 16:01:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Jul 2023 16:01:25 -0700
In-Reply-To: <20230711230131.648752-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230711230131.648752-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711230131.648752-2-seanjc@google.com>
Subject: [PATCH 1/7] KVM: Grab a reference to KVM for VM and vCPU stats file descriptors
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Zhang <zheng.zhang@email.ucr.edu>,
        Kees Cook <keescook@chromium.org>,
        Sean Christopherson <seanjc@google.com>
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

Grab a reference to KVM prior to installing VM and vCPU stats file
descriptors to ensure the underlying VM and vCPU objects are not freed
until the last reference to any and all stats fds are dropped.

Note, the stats paths manually invoke fd_install() and so don't need to
grab a reference before creating the file.

Fixes: ce55c049459c ("KVM: stats: Support binary stats retrieval for a VCPU")
Fixes: fcfe1baeddbf ("KVM: stats: Support binary stats retrieval for a VM")
Reported-by: Zheng Zhang <zheng.zhang@email.ucr.edu>
Closes: https://lore.kernel.org/all/CAC_GQSr3xzZaeZt85k_RCBd5kfiOve8qXo7a81Cq53LuVQ5r=Q@mail.gmail.com
Cc: stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b838c8f71349..312a8d9184fe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4032,8 +4032,17 @@ static ssize_t kvm_vcpu_stats_read(struct file *file, char __user *user_buffer,
 			sizeof(vcpu->stat), user_buffer, size, offset);
 }
 
+static int kvm_vcpu_stats_release(struct inode *inode, struct file *file)
+{
+	struct kvm_vcpu *vcpu = file->private_data;
+
+	kvm_put_kvm(vcpu->kvm);
+	return 0;
+}
+
 static const struct file_operations kvm_vcpu_stats_fops = {
 	.read = kvm_vcpu_stats_read,
+	.release = kvm_vcpu_stats_release,
 	.llseek = noop_llseek,
 };
 
@@ -4054,6 +4063,9 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
 		put_unused_fd(fd);
 		return PTR_ERR(file);
 	}
+
+	kvm_get_kvm(vcpu->kvm);
+
 	file->f_mode |= FMODE_PREAD;
 	fd_install(fd, file);
 
@@ -4698,8 +4710,17 @@ static ssize_t kvm_vm_stats_read(struct file *file, char __user *user_buffer,
 				sizeof(kvm->stat), user_buffer, size, offset);
 }
 
+static int kvm_vm_stats_release(struct inode *inode, struct file *file)
+{
+	struct kvm *kvm = file->private_data;
+
+	kvm_put_kvm(kvm);
+	return 0;
+}
+
 static const struct file_operations kvm_vm_stats_fops = {
 	.read = kvm_vm_stats_read,
+	.release = kvm_vm_stats_release,
 	.llseek = noop_llseek,
 };
 
@@ -4718,6 +4739,9 @@ static int kvm_vm_ioctl_get_stats_fd(struct kvm *kvm)
 		put_unused_fd(fd);
 		return PTR_ERR(file);
 	}
+
+	kvm_get_kvm(kvm);
+
 	file->f_mode |= FMODE_PREAD;
 	fd_install(fd, file);
 
-- 
2.41.0.255.g8b1d071c50-goog

