Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED89144E414
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhKLJns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:43:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234799AbhKLJnp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 04:43:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636710055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9tPgpMzRvsL0rk1XyYG/xlU1Es1b/Zx1t8JiA6XaAgI=;
        b=Tb9tB6ryrN0xvQOWHiqxj8SmCwb7P3ooHMV2z7rImBRNnCsiJrEHRIitVJiZs+eKLMZXdQ
        OdESFVJi5qncfgKw1mKqwn+9eTcsqpOqxbO8X30vhW2BUhkoxbDTHaUDkwc7MXDNRLUtIB
        0uMIYxQt57HNOPncT0UeCBC8cJvq2Kw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-UqtkKy2SNiil34fel2AkBQ-1; Fri, 12 Nov 2021 04:40:51 -0500
X-MC-Unique: UqtkKy2SNiil34fel2AkBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 820DD1926DA1;
        Fri, 12 Nov 2021 09:40:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 159EA6FEED;
        Fri, 12 Nov 2021 09:40:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com, marcorr@google.com
Subject: [PATCH 8/7] KVM: SEV: unify cgroup cleanup code for svm_vm_migrate_from
Date:   Fri, 12 Nov 2021 04:40:49 -0500
Message-Id: <20211112094049.3827308-1-pbonzini@redhat.com>
In-Reply-To: <20211111154930.3603189-1-pbonzini@redhat.com>
References: <20211111154930.3603189-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the same cleanup code independent of whether the cgroup to be
uncharged and unref'd is the source or the destination cgroup.  Use a
bool to track whether the destination cgroup has been charged, which also
fixes a bug in the error case: the destination cgroup must be uncharged
only if it does not match the source.

Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 531613f758ba..902c52a8dd0c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1614,12 +1614,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
 	src->handle = 0;
 	src->pages_locked = 0;
 
-	if (dst->misc_cg != src->misc_cg)
-		sev_misc_cg_uncharge(src);
-
-	put_misc_cg(src->misc_cg);
-	src->misc_cg = NULL;
-
 	INIT_LIST_HEAD(&dst->regions_list);
 	list_replace_init(&src->regions_list, &dst->regions_list);
 }
@@ -1667,9 +1661,10 @@ static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
 int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
-	struct kvm_sev_info *src_sev;
+	struct kvm_sev_info *src_sev, *cg_cleanup_sev;
 	struct file *source_kvm_file;
 	struct kvm *source_kvm;
+	bool charged = false;
 	int ret;
 
 	ret = sev_lock_for_migration(kvm);
@@ -1699,10 +1694,12 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 
 	src_sev = &to_kvm_svm(source_kvm)->sev_info;
 	dst_sev->misc_cg = get_current_misc_cg();
+	cg_cleanup_sev = dst_sev;
 	if (dst_sev->misc_cg != src_sev->misc_cg) {
 		ret = sev_misc_cg_try_charge(dst_sev);
 		if (ret)
-			goto out_dst_put_cgroup;
+			goto out_dst_cgroup;
+		charged = true;
 	}
 
 	ret = sev_lock_vcpus_for_migration(kvm);
@@ -1719,6 +1716,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	}
 	sev_migrate_from(dst_sev, src_sev);
 	kvm_vm_dead(source_kvm);
+	cg_cleanup_sev = src_sev;
 	ret = 0;
 
 out_source_vcpu:
@@ -1726,12 +1724,11 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 out_dst_vcpu:
 	sev_unlock_vcpus_for_migration(kvm);
 out_dst_cgroup:
-	if (ret < 0) {
-		sev_misc_cg_uncharge(dst_sev);
-out_dst_put_cgroup:
-		put_misc_cg(dst_sev->misc_cg);
-		dst_sev->misc_cg = NULL;
-	}
+	/* Operates on the source on success, on the destination on failure.  */
+	if (charged)
+		sev_misc_cg_uncharge(cg_cleanup_sev);
+	put_misc_cg(cg_cleanup_sev->misc_cg);
+	cg_cleanup_sev->misc_cg = NULL;
 out_source:
 	sev_unlock_after_migration(source_kvm);
 out_fput:
-- 
2.27.0

