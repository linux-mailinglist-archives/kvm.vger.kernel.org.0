Return-Path: <kvm+bounces-12028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6781A87F2F2
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:10:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B235281EEF
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1F05A780;
	Mon, 18 Mar 2024 22:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KZpJe42j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8508F5A0E5
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799809; cv=none; b=ZDud771hgIxYopPmtos4DBb7SeN4BNPhNbifDFmWYQ7Uh3NWMsaRfYD2IXhcmWD8lZnM/hS2CqZIXSK15JvoDkOtn85LenDKXR+keJzg48N7oIieG+ePiOc9XocL2Vyf5+IWy39qRJNgh4b+1YDMJGTAkHAjdSpLyNpOsi55Uqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799809; c=relaxed/simple;
	bh=pUDyVdDIhWF+AxxFzQPbcKbrYmlXF2FtVHpKnNJHuHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P7YlewPDcNv53yOToBsPPfCPFs0GsoKMoI32XHdkn/MVjnQn5p+4AUg+o16hPkRFLkJTxlnP9CgJFlio3ypMpvf0s+xodnqPlFG5Li8YaoY/mocbxK74gSbMtzZPecd2Z7Y59FPzM2VrbbGX/Ad+ufyk/BBCAUhxyLbr4uLn/0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KZpJe42j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710799806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jIk57Yw9TtyXvEW7JA55T78f0IPlsLYi8PGmRhytf78=;
	b=KZpJe42j4zsRo5BQEp8jVohvr4cryUB63NZpkqXwck8lIRb4RnBVt9yAXWQQbEqGFXZSrz
	mfd4uqQbO4Mbr0bQWbrxyqY5DaPFtr9e1hTPFin+iwO+6YANS6jsNyb1wTpf/lVdf/Br8c
	/NcdqSJAz6pReDy4mfjNhexnypFGAuc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-3C53FmV2MF685amG0XGf_A-1; Mon, 18 Mar 2024 18:10:04 -0400
X-MC-Unique: 3C53FmV2MF685amG0XGf_A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C500C185A781;
	Mon, 18 Mar 2024 22:10:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A31DD492BD6;
	Mon, 18 Mar 2024 22:10:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 1/7] KVM: SVM: Set sev->asid in sev_asid_new() instead of overloading the return
Date: Mon, 18 Mar 2024 18:09:56 -0400
Message-ID: <20240318221002.2712738-2-pbonzini@redhat.com>
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

From: Sean Christopherson <seanjc@google.com>

Explicitly set sev->asid in sev_asid_new() when a new ASID is successfully
allocated, and return '0' to indicate success instead of overloading the
return value to multiplex the ASID with error codes.  There is exactly one
caller of sev_asid_new(), and sev_asid_free() already consumes sev->asid,
i.e. returning the ASID isn't necessary for flexibility, nor does it
provide symmetry between related APIs.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240131235609.4161407-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f760106c31f8..7c000088bca6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -179,7 +179,8 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 	mutex_unlock(&sev_bitmap_lock);
 
-	return asid;
+	sev->asid = asid;
+	return 0;
 e_uncharge:
 	sev_misc_cg_uncharge(sev);
 	put_misc_cg(sev->misc_cg);
@@ -246,7 +247,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	int asid, ret;
+	int ret;
 
 	if (kvm->created_vcpus)
 		return -EINVAL;
@@ -257,10 +258,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev->active = true;
 	sev->es_active = argp->id == KVM_SEV_ES_INIT;
-	asid = sev_asid_new(sev);
-	if (asid < 0)
+	ret = sev_asid_new(sev);
+	if (ret)
 		goto e_no_asid;
-	sev->asid = asid;
 
 	ret = sev_platform_init(&argp->error);
 	if (ret)
-- 
2.43.0



