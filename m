Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42B23B46A7
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhFYPev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:34:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53372 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229955AbhFYPep (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624635144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CyUuFYaAoVveXOt5smrSbQaSHQszxWEWMgmcLEywPtc=;
        b=i4EDn/0QxuAIE6Q93U31zVi7EYCu7p8Sa/yNgW3d+Gb18OreVUuiicEJwt/GWJFj1hP6CB
        psZsnKULnNc8pz3Leds871Xqp3q8uzchd2vr6JG9V8ZoIZ0m0RVl3G9kOMwQ4KftAspAAZ
        uU9JTSNRhpkw52Kq9weaUzH7Oo5puaM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-cmsDhvwAP2-JUqTaQ3r-MQ-1; Fri, 25 Jun 2021 11:32:22 -0400
X-MC-Unique: cmsDhvwAP2-JUqTaQ3r-MQ-1
Received: by mail-il1-f198.google.com with SMTP id x2-20020a056e021bc2b02901ee78f516b4so631234ilv.11
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CyUuFYaAoVveXOt5smrSbQaSHQszxWEWMgmcLEywPtc=;
        b=WYjDmlr1BvQ+211L7VVrTVuW0cVujFhbB37VovRbr96AwVO2CBdodkyciUiwVGWxV2
         VK0CkSCOAJfpi+Xkq41R1m6UATeG9cKhZH3nIsWtVV+Eo3p2o8h5NKD9z6zPwdo6ZMEG
         jTgWQBUxv/I3NPdDglwQiOJFiut/FKHhJ0dJw7GrhfxNTIuqpKsQr2j3NV4wO8XG7q2k
         4nnUHI0IHJA9cakQjvFw3CVUgJG2pv8FkVprclybeda3+WmAwkBP3Rk9eZyIFAfgCzR7
         Q8//VeP1P/i80/SyyI6tj3LpDQeHX1J1pHkyPfEdBHVopoHkI9RNxYpixuCqk/MDC+zZ
         7TCw==
X-Gm-Message-State: AOAM532Ql+8aZUr6dUyTyG83zjEJwIGWppySZAjLLVR1UtA+W/DYo11u
        jAmZkb2CFplybkfyPiJr5KoL6BKehhbhgCYn04w70+trMu9GAvOCdDdkGF5/mKEXY4kKzHu106B
        MOpgymEoB/wRK
X-Received: by 2002:a02:628b:: with SMTP id d133mr9920050jac.27.1624635141966;
        Fri, 25 Jun 2021 08:32:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9YNK4wl19El0hz9j0y8hwec2iaaS6VyEe/RlX8sikVF2hwYG4LnksdMqlMXL8QScakdtIwQ==
X-Received: by 2002:a02:628b:: with SMTP id d133mr9920020jac.27.1624635141672;
        Fri, 25 Jun 2021 08:32:21 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id s8sm3668772ilj.51.2021.06.25.08.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:32:20 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 3/9] KVM: Allow to have arch-specific per-vm debugfs files
Date:   Fri, 25 Jun 2021 11:32:08 -0400
Message-Id: <20210625153214.43106-4-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625153214.43106-1-peterx@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow archs to create arch-specific nodes under kvm->debugfs_dentry directory
besides the stats fields.  The new interface kvm_arch_create_vm_debugfs() is
defined but not yet used.  It's called after kvm->debugfs_dentry is created, so
it can be referenced directly in kvm_arch_create_vm_debugfs().  Arch should
define their own versions when they want to create extra debugfs nodes.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c6fcd75dd8b9..8521d3492eb2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1035,6 +1035,7 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
+int kvm_arch_create_vm_debugfs(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 79b0c1b7b284..516ba8d25bda 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -895,7 +895,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	char dir_name[ITOA_MAX_LEN * 2];
 	struct kvm_stat_data *stat_data;
 	const struct _kvm_stats_desc *pdesc;
-	int i;
+	int i, ret;
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
@@ -940,6 +940,13 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 				    kvm->debugfs_dentry, stat_data,
 				    &stat_fops_per_vm);
 	}
+
+	ret = kvm_arch_create_vm_debugfs(kvm);
+	if (ret) {
+		kvm_destroy_vm_debugfs(kvm);
+		return i;
+	}
+
 	return 0;
 }
 
@@ -960,6 +967,17 @@ void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
 {
 }
 
+/*
+ * Called after per-vm debugfs created.  When called kvm->debugfs_dentry should
+ * be setup already, so we can create arch-specific debugfs entries under it.
+ * Cleanup should be automatic done in kvm_destroy_vm_debugfs() recursively, so
+ * a per-arch destroy interface is not needed.
+ */
+int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	return 0;
+}
+
 static struct kvm *kvm_create_vm(unsigned long type)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
-- 
2.31.1

