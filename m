Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CE244D97A
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhKKPw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:52:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234004AbhKKPw2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 10:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636645779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tchgW1G/woqY+v0B8S2W3vnChWM23Uhw3AARV7UMWNI=;
        b=RAQ12KT9uarcuNyDHyYB7M3trKpaLg/KF8xwvA3e1gg1rk4mfvkLAw0S9KZxM+AiXxNPHg
        VbcwzyAQ+X646Ql+Q2Jt7m42uxbnbbZef6oH+r0I3BPh/znrql2SKagkZin7fXnZ4XgNAq
        VqjvuV0kz6BAzkdq5CoS8Kq+LE3zdcA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-bfgxgoheNfy87bxFCc4S0Q-1; Thu, 11 Nov 2021 10:49:35 -0500
X-MC-Unique: bfgxgoheNfy87bxFCc4S0Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B93C9814248;
        Thu, 11 Nov 2021 15:49:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A3505E26A;
        Thu, 11 Nov 2021 15:49:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com
Subject: [PATCH 3/7] KVM: SEV: provide helpers to charge/uncharge misc_cg
Date:   Thu, 11 Nov 2021 10:49:26 -0500
Message-Id: <20211111154930.3603189-4-pbonzini@redhat.com>
In-Reply-To: <20211111154930.3603189-1-pbonzini@redhat.com>
References: <20211111154930.3603189-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid code duplication across all callers of misc_cg_try_charge and
misc_cg_uncharge.  The resource type for KVM is always derived from
sev->es_active, and the quantity is always 1.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d53f71054475..227becd93cb6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -120,16 +120,26 @@ static bool __sev_recycle_asids(int min_asid, int max_asid)
 	return true;
 }
 
+static int sev_misc_cg_try_charge(struct kvm_sev_info *sev)
+{
+	enum misc_res_type type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+	return misc_cg_try_charge(type, sev->misc_cg, 1);
+}
+
+static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
+{
+	enum misc_res_type type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+	misc_cg_uncharge(type, sev->misc_cg, 1);
+}
+
 static int sev_asid_new(struct kvm_sev_info *sev)
 {
 	int asid, min_asid, max_asid, ret;
 	bool retry = true;
-	enum misc_res_type type;
 
-	type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
 	WARN_ON(sev->misc_cg);
 	sev->misc_cg = get_current_misc_cg();
-	ret = misc_cg_try_charge(type, sev->misc_cg, 1);
+	ret = sev_misc_cg_try_charge(sev);
 	if (ret) {
 		put_misc_cg(sev->misc_cg);
 		sev->misc_cg = NULL;
@@ -162,7 +172,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 	return asid;
 e_uncharge:
-	misc_cg_uncharge(type, sev->misc_cg, 1);
+	sev_misc_cg_uncharge(sev);
 	put_misc_cg(sev->misc_cg);
 	sev->misc_cg = NULL;
 	return ret;
@@ -179,7 +189,6 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 {
 	struct svm_cpu_data *sd;
 	int cpu;
-	enum misc_res_type type;
 
 	mutex_lock(&sev_bitmap_lock);
 
@@ -192,8 +201,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 
 	mutex_unlock(&sev_bitmap_lock);
 
-	type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
-	misc_cg_uncharge(type, sev->misc_cg, 1);
+	sev_misc_cg_uncharge(sev);
 	put_misc_cg(sev->misc_cg);
 	sev->misc_cg = NULL;
 }
-- 
2.27.0


