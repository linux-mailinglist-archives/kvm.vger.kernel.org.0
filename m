Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBD43B3567
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhFXSQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:16:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230450AbhFXSQX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a/z5ekGyyTIFDc5iC+PDsxm8TweH5l/mhGx4xsPY5QA=;
        b=RLASARGZMdeG+wRfOsZYQGrm+MeqH6JxGPAABoBRcy7oKUVpnns0fbcbmzgyjCYhHJjba7
        3rX96/NqeWHnSh08vuxAJ32+tvuj2632O/B1YbDLb2Qc8l2Hd4MlOb87zuHuVo1BurElsm
        rSnsG1omzzleIVHn6Pj/pw89+8WnNxE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-P20lZ0m3Pw6uX0G6e2R01Q-1; Thu, 24 Jun 2021 14:14:02 -0400
X-MC-Unique: P20lZ0m3Pw6uX0G6e2R01Q-1
Received: by mail-qt1-f197.google.com with SMTP id s20-20020ac85cd40000b029024ebedff900so7132380qta.10
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/z5ekGyyTIFDc5iC+PDsxm8TweH5l/mhGx4xsPY5QA=;
        b=gT77ds2nDmzCzee2cbWiEwl8acSca0lv5ycjCTsU0ig+pTIsJu2yW5BtOWsv8UGKIS
         EUQxedivLog/xndd0R1aEkfUcYDX9QSxmdz0STb2CYuW6aGZGhAli6sN2C/LMtXTMV+x
         LQKImsg5b4vwTJg16vtZO+fl7erHSkrrI7QdJYa0/A/xB7ol364qgrMHg+yT6tgOHA51
         TkxexSahf4fmH291Y2ivRE0qqzEefc5IghOL0FNhdzq2GW9qM1ssffrYKwlGmxkxrpDL
         JuSo7A+vmCN6JLo1HP324grffyxyEh30ffrQwrdksWM9o04GcSv0tfcGPsA6FGD28hQs
         tDdQ==
X-Gm-Message-State: AOAM533Sq5zQHrPBmZEDqXSWyR/m+ixgusvrhMOvLASQslIhO8D1XJ5J
        jMCkyHrOqnLfpJPfBT/ilrowaJVKEFsg+f1fengyNsWAeZ2iFQs7i55R+AS/LYiL4IXX/HJCsCd
        n/8m47rVHnuqSSxAnmqL9/1qQMIuvl2ihsPXqu6E82yUEagoKnM9T2oSxzOpdVw==
X-Received: by 2002:a37:9d90:: with SMTP id g138mr3201335qke.212.1624558441963;
        Thu, 24 Jun 2021 11:14:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw81+DaAwL/DpqMKlW8EsBoQO4jQNMsJoAjiZVBV2+Lx9VL6USjuQp2YkIyZMNrp4T6w5dGMg==
X-Received: by 2002:a37:9d90:: with SMTP id g138mr3201313qke.212.1624558441718;
        Thu, 24 Jun 2021 11:14:01 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id b7sm2529301qti.21.2021.06.24.11.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:14:01 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 2/9] KVM: Introduce kvm_get_kvm_safe()
Date:   Thu, 24 Jun 2021 14:13:49 -0400
Message-Id: <20210624181356.10235-3-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624181356.10235-1-peterx@redhat.com>
References: <20210624181356.10235-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce this safe version of kvm_get_kvm() so that it can be called even
during vm destruction.  Use it in kvm_debugfs_open() and remove the verbose
comment.  Prepare to be used elsewhere.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2f34487e21f2..53d7d09eebd7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -698,6 +698,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 void kvm_exit(void);
 
 void kvm_get_kvm(struct kvm *kvm);
+bool kvm_get_kvm_safe(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
 void kvm_put_kvm_no_destroy(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d170f65e15b0..0b4f55370b18 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1049,6 +1049,16 @@ void kvm_get_kvm(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_get_kvm);
 
+/*
+ * Make sure the vm is not during destruction, which is a safe version of
+ * kvm_get_kvm().  Return true if kvm referenced successfully, false otherwise.
+ */
+bool kvm_get_kvm_safe(struct kvm *kvm)
+{
+	return refcount_inc_not_zero(&kvm->users_count);
+}
+EXPORT_SYMBOL_GPL(kvm_get_kvm_safe);
+
 void kvm_put_kvm(struct kvm *kvm)
 {
 	if (refcount_dec_and_test(&kvm->users_count))
@@ -4713,12 +4723,7 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
 					  inode->i_private;
 
-	/* The debugfs files are a reference to the kvm struct which
-	 * is still valid when kvm_destroy_vm is called.
-	 * To avoid the race between open and the removal of the debugfs
-	 * directory we test against the users count.
-	 */
-	if (!refcount_inc_not_zero(&stat_data->kvm->users_count))
+	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
 
 	if (simple_attr_open(inode, file, get,
-- 
2.31.1

