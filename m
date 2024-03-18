Return-Path: <kvm+bounces-12034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2509C87F2FC
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CB55B21FBC
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263845B5CD;
	Mon, 18 Mar 2024 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DgLUcDua"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B845A4C4
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799811; cv=none; b=fTLuIWNsUxAQKTIGfShCFHMWmlDRggvgqaSKqiE4Sd6dXH+KDSOCPSIlMVUm9WIhkSAQ7JAgVCXxHVq3yY1SXfv9+H4jkIIFQJKMcqOyPzLiu0N5699edjm4gCcb1UowEAM7cqf4il3VF5JOzwYyyx9igszqJHFNl8Nvj3FIO9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799811; c=relaxed/simple;
	bh=jBqGxeE+IhKyoXM9zVHSpir3KZfZHpFMsiIw7rgHpZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJ3zdnZJewWYp2IvQIEOrH4Wv4C0Dhj8ukvzxEyrhQZK0AtUgJtANqmwVyDslhE/pnBYVXi4wLHh/OuT7SBEWvfo1uYBzd6RUrrh3h2O8Rb3T/2DXTthxCr6PboD0YRsfRB2YznyDDfO0JksDRJw9O0O0zrNFJbM/efkuwx+56c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DgLUcDua; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710799808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OyCsbi8n3w9nlxB/vU9IG/7BiogA4ynph3bT+cZ/wPg=;
	b=DgLUcDuarakIMmsnqAQWRDgq1XFBHxt56eLU925HNoLmF5M/Muesd5TfdRWEV2QPFZ5tUi
	3OSrvfnvtHsko4AM9z9mXk4IsdnfISbRt2WpLstlQXdiBtlv/XduEXd8zlNwqLngHrXDrG
	SiDFBFx6df7s6SmXZEPj2rAY/DPvfGk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-262-nIs2tlAGOB-euepDbDHAPQ-1; Mon,
 18 Mar 2024 18:10:04 -0400
X-MC-Unique: nIs2tlAGOB-euepDbDHAPQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F78A2800E8B;
	Mon, 18 Mar 2024 22:10:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03EC9492BC8;
	Mon, 18 Mar 2024 22:10:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Ashish Kalra <ashish.kalra@amd.com>,
	stable@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 3/7] KVM: SVM: Add support for allowing zero SEV ASIDs
Date: Mon, 18 Mar 2024 18:09:58 -0400
Message-ID: <20240318221002.2712738-4-pbonzini@redhat.com>
In-Reply-To: <20240318221002.2712738-1-pbonzini@redhat.com>
References: <20240318221002.2712738-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Ashish Kalra <ashish.kalra@amd.com>

Some BIOSes allow the end user to set the minimum SEV ASID value
(CPUID 0x8000001F_EDX) to be greater than the maximum number of
encrypted guests, or maximum SEV ASID value (CPUID 0x8000001F_ECX)
in order to dedicate all the SEV ASIDs to SEV-ES or SEV-SNP.

The SEV support, as coded, does not handle the case where the minimum
SEV ASID value can be greater than the maximum SEV ASID value.
As a result, the following confusing message is issued:

[   30.715724] kvm_amd: SEV enabled (ASIDs 1007 - 1006)

Fix the support to properly handle this case.

Fixes: 916391a2d1dc ("KVM: SVM: Add support for SEV-ES capability in KVM")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240104190520.62510-1-Ashish.Kalra@amd.com
Link: https://lore.kernel.org/r/20240131235609.4161407-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index eeef43c795d8..5f8312edee36 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -144,10 +144,21 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 
 static int sev_asid_new(struct kvm_sev_info *sev)
 {
-	unsigned int asid, min_asid, max_asid;
+	/*
+	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
+	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
+	 * Note: min ASID can end up larger than the max if basic SEV support is
+	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 */
+	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
+	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
+	unsigned int asid;
 	bool retry = true;
 	int ret;
 
+	if (min_asid > max_asid)
+		return -ENOTTY;
+
 	WARN_ON(sev->misc_cg);
 	sev->misc_cg = get_current_misc_cg();
 	ret = sev_misc_cg_try_charge(sev);
@@ -159,12 +170,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 	mutex_lock(&sev_bitmap_lock);
 
-	/*
-	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
-	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
-	 */
-	min_asid = sev->es_active ? 1 : min_sev_asid;
-	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
 again:
 	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
 	if (asid > max_asid) {
@@ -2234,8 +2239,10 @@ void __init sev_hardware_setup(void)
 		goto out;
 	}
 
-	sev_asid_count = max_sev_asid - min_sev_asid + 1;
-	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
+	if (min_sev_asid <= max_sev_asid) {
+		sev_asid_count = max_sev_asid - min_sev_asid + 1;
+		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
+	}
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -2266,7 +2273,9 @@ void __init sev_hardware_setup(void)
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
-			sev_supported ? "enabled" : "disabled",
+			sev_supported ? min_sev_asid <= max_sev_asid ? "enabled" :
+								       "unusable" :
+								       "disabled",
 			min_sev_asid, max_sev_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
-- 
2.43.0



