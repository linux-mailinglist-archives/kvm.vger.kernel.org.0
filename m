Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E256123BE9A
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 19:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgHDRIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 13:08:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42711 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728415AbgHDRIX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 13:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596560902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4r8eOHvP6f0oDrekacIxhK5fe0vBr0vL63RZi5tQK4o=;
        b=SWIcJsbliu6QwRUookWqQ9dnCuU3KJ8N2bFdPgLjcpiFrhn2Pi5xzzEYgnvecMy7tY6ygd
        xJXsTvszmOW+CRWG6sRi+/ps1hfa4HB5cBX7F3Ff7gYjtUy7K2AItVQjz0sCkpX3SWdVwO
        r4mcvrL3eVW6Hk3RC5RGX4/cwKtKJgg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-gsF3w5IWPf2mkKvi0ZLVrw-1; Tue, 04 Aug 2020 13:06:14 -0400
X-MC-Unique: gsF3w5IWPf2mkKvi0ZLVrw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE6D157;
        Tue,  4 Aug 2020 17:06:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C85272E48;
        Tue,  4 Aug 2020 17:06:11 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, steven.price@arm.com, pbonzini@redhat.com
Subject: [PATCH v2 3/6] KVM: arm64: Drop type input from kvm_put_guest
Date:   Tue,  4 Aug 2020 19:06:01 +0200
Message-Id: <20200804170604.42662-4-drjones@redhat.com>
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
References: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can use typeof() to avoid the need for the type input.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/pvtime.c  |  2 +-
 include/linux/kvm_host.h | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 95f9580275b1..241ded7ee0ad 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -32,7 +32,7 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 	steal_le = cpu_to_le64(steal);
 	idx = srcu_read_lock(&kvm->srcu);
 	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
-	kvm_put_guest(kvm, base + offset, steal_le, u64);
+	kvm_put_guest(kvm, base + offset, steal_le);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d564855243d8..cf51b06a5edd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -749,25 +749,26 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len);
 
-#define __kvm_put_guest(kvm, gfn, offset, value, type)			\
+#define __kvm_put_guest(kvm, gfn, offset, v)				\
 ({									\
 	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
-	type __user *__uaddr = (type __user *)(__addr + offset);	\
+	typeof(v) __user *__uaddr = (typeof(__uaddr))(__addr + offset);	\
 	int __ret = -EFAULT;						\
 									\
 	if (!kvm_is_error_hva(__addr))					\
-		__ret = put_user(value, __uaddr);			\
+		__ret = put_user(v, __uaddr);				\
 	if (!__ret)							\
 		mark_page_dirty(kvm, gfn);				\
 	__ret;								\
 })
 
-#define kvm_put_guest(kvm, gpa, value, type)				\
+#define kvm_put_guest(kvm, gpa, v)					\
 ({									\
 	gpa_t __gpa = gpa;						\
 	struct kvm *__kvm = kvm;					\
+									\
 	__kvm_put_guest(__kvm, __gpa >> PAGE_SHIFT,			\
-			offset_in_page(__gpa), (value), type);		\
+			offset_in_page(__gpa), v);			\
 })
 
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
-- 
2.25.4

