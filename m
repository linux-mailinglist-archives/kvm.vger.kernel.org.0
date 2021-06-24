Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0053B3569
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhFXSQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:16:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232596AbhFXSQZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:16:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Nog/14DIgnUZ4IUiuS7R5o+tAccEjG5oUAeY24gLNU=;
        b=cfeWZYQeGbZOc9HD6XL336UVT7xuTVQgmZHe6nHVGGtl0vt2qC4MZAAZCIN28mI6cH9OsN
        zJQRUwKmurz3jVWfDOevmsR2n4jWw4Dz8mj8csCmwMXGAu0vWKTYOOIfY9xXwaBLoN8n2G
        fsN8p+4WC0W/KWto5q72vRXILfIYWBk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-8u1DJxtSO7qk-8mLUrANfg-1; Thu, 24 Jun 2021 14:14:04 -0400
X-MC-Unique: 8u1DJxtSO7qk-8mLUrANfg-1
Received: by mail-qk1-f200.google.com with SMTP id c3-20020a37b3030000b02903ad0001a2e8so7924228qkf.3
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Nog/14DIgnUZ4IUiuS7R5o+tAccEjG5oUAeY24gLNU=;
        b=ZdhcOijSStVrQGNH7pGQX5H7yUxc0jr90SXnJMZ2IygVdQX4WXPM0c8YgqVD3NiWC0
         avL34KKYgsQ8cGjW1ax2txAvDoOCohMLQ+GO0V9vzIOHX9lU0u8ovlFpDynY+PaQMY5m
         mFUgwHOjECsQG6Oe7dK3tsmiCelTfLgiDjJonsSgesi935sX6Kl1Z1fVsD7GngjjG4Zv
         PQjj0Faw9b6D11N4qwvEp7GpAx+2MRYwjD1ZDjCBMPIFI6krjH8SN0qP7ag2rGkjL3RK
         gjWuCaLMSIf8CCPJ64ZAeKm4/YU3uFqmlmQsRuvNMn1NifvRoPqdXHsFKZzELICMamA9
         x3Fg==
X-Gm-Message-State: AOAM5323tJX0i/HszSZdkE0pC2c3fIxm8/FGbhzx0QG4c0nd6vaJ+5Ug
        5FPlQ2ZQRosc/Ad3PzGk8cge7y7TppAMzOo42h1ywDQ+ZB5yRl0jAyt72n4tAE7nj6iWgYnP81z
        B7X3X8vrriw5Hw+qSnqXl1LTAd16za4fMn78BRSYT4N6sJMYIH56KCRuOFmyUpQ==
X-Received: by 2002:ac8:5784:: with SMTP id v4mr1635165qta.29.1624558443714;
        Thu, 24 Jun 2021 11:14:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYmWyDHbFW8nYB7xKKg3q0sHZXRjTyTswPy+lanRmvJq7eYT+PD7e4EYtu6p98y3KOK2o0GA==
X-Received: by 2002:ac8:5784:: with SMTP id v4mr1635136qta.29.1624558443350;
        Thu, 24 Jun 2021 11:14:03 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id b7sm2529301qti.21.2021.06.24.11.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:14:02 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 3/9] KVM: Allow to have arch-specific per-vm debugfs files
Date:   Thu, 24 Jun 2021 14:13:50 -0400
Message-Id: <20210624181356.10235-4-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624181356.10235-1-peterx@redhat.com>
References: <20210624181356.10235-1-peterx@redhat.com>
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
 virt/kvm/kvm_main.c      | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 53d7d09eebd7..480baa55d93f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1009,6 +1009,7 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
+int kvm_arch_create_vm_debugfs(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0b4f55370b18..6648743f4dcf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -847,6 +847,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	char dir_name[ITOA_MAX_LEN * 2];
 	struct kvm_stat_data *stat_data;
 	struct kvm_stats_debugfs_item *p;
+	int ret;
 
 	if (!debugfs_initialized())
 		return 0;
@@ -872,6 +873,13 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 				    kvm->debugfs_dentry, stat_data,
 				    &stat_fops_per_vm);
 	}
+
+	ret = kvm_arch_create_vm_debugfs(kvm);
+	if (ret) {
+		kvm_destroy_vm_debugfs(kvm);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -892,6 +900,17 @@ void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
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

