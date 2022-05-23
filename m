Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6130A531CF8
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiEWTYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiEWTYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:24:24 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CA716F361
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:03:32 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id b11so4121548qvv.4
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HHNIPUsJDbBFJZh22t/jyDNYIOXLs4DuR2SaQZ0oOdk=;
        b=OHGWjxZ43RVGglH0ZBaek/zekCwJXQ2me+plJ95APbCUPJDRlsu/w2lrn8zTe4mHJv
         TeX2VBxIgthP+O3K/6u3vFvFZL3kFGXQT0PePQ3yBvaoCsECP/6etaACqtkWm9m+yE/N
         1pmilsdldoHfCzImdAfScR2AeKtXiX68NUU4XE0eMvp9L0p+UUdjctazUkl0Ud9FwMZT
         L71eJv3qSP2F1gmdjI+8Lf9SPqVXWScvEgOQd6QA8o5hMM5YMtZaBUeQAismPhJ8BQ2V
         P4IVMVLLUtrSNXp4zJgsaGSk849FwhVe/D+dVKnMG+oDEK+e7BNh5WsgeYn3WcMWHJuU
         tJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HHNIPUsJDbBFJZh22t/jyDNYIOXLs4DuR2SaQZ0oOdk=;
        b=Rxk2GCTsYq+Pm1GFTR6UNSJzOa6+fCaMzEVLhvVQ9cf6dwMx9pXAYzMOm6YCsQ9sX+
         wQCcOis7QnIhn+fza2aLiaZVBlZ97cVmYbCUIKbDiax7ccUCcjkZKwfA0MFbPCoiyJWw
         3YsF6UHcuO7cZemsYgIBl5TlLQpSDh4MVkN5emm+LJXHXKFBWWGz7rcwbp1DDJP53i6W
         dAPQKb3AuGe3D5XbJ5Ta7Ebg2K9kxRRumIoptXJf/pJbwsXictIwTvPZG4nZ4HttrzC1
         284otockV4b64Puw/Mq71d2vt9cOqXawxFP6dmtfTElxsZeht7KTMuiI7lZuGjauZyFN
         JAZw==
X-Gm-Message-State: AOAM531NUF8tCnt2K5gMgDBoC250DxB8mYd2USuDg9vr3ZgPx0CuyEWR
        p62J9Cjjtc20DVPNNK7mhMUhfQ==
X-Google-Smtp-Source: ABdhPJzrbeRCv6+La2EKTHMthFHEHjXyfkxe88T4A2iN93t6pEtPIwoIXBkf7PiAJy58E3o/eNlOXQ==
X-Received: by 2002:a05:6214:ac3:b0:461:c492:d628 with SMTP id g3-20020a0562140ac300b00461c492d628mr18287853qvi.68.1653332611240;
        Mon, 23 May 2022 12:03:31 -0700 (PDT)
Received: from vinmini.lan (c-73-38-52-84.hsd1.vt.comcast.net. [73.38.52.84])
        by smtp.gmail.com with ESMTPSA id q10-20020ac8450a000000b002f3ca56e6edsm4809279qtn.8.2022.05.23.12.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 12:03:30 -0700 (PDT)
From:   "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Vineeth Pillai <vineeth@bitbyteword.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH] KVM: debugfs: expose pid of vcpu threads
Date:   Mon, 23 May 2022 15:03:27 -0400
Message-Id: <20220523190327.2658-1-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vineeth Pillai <vineeth@bitbyteword.org>

Add a new debugfs file to expose the pid of each vcpu threads. This
is very helpful for userland tools to get the vcpu pids without
worrying about thread naming conventions of the VMM.

Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 34eed5f85ed6..c2c86fce761c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1434,6 +1434,8 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state);
 
 #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry);
+#else
+static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 int kvm_arch_hardware_enable(void);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5ab12214e18d..9bb1dbf51c90 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3723,9 +3723,18 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 	return anon_inode_getfd(name, &kvm_vcpu_fops, vcpu, O_RDWR | O_CLOEXEC);
 }
 
+#ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
+static int vcpu_get_pid(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+	*val = pid_nr(rcu_access_pointer(vcpu->pid));
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
+
 static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
-#ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
 	struct dentry *debugfs_dentry;
 	char dir_name[ITOA_MAX_LEN * 2];
 
@@ -3735,10 +3744,12 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	snprintf(dir_name, sizeof(dir_name), "vcpu%d", vcpu->vcpu_id);
 	debugfs_dentry = debugfs_create_dir(dir_name,
 					    vcpu->kvm->debugfs_dentry);
+	debugfs_create_file("pid", 0444, debugfs_dentry, vcpu,
+			    &vcpu_get_pid_fops);
 
 	kvm_arch_create_vcpu_debugfs(vcpu, debugfs_dentry);
-#endif
 }
+#endif
 
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
-- 
2.34.1

