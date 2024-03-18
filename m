Return-Path: <kvm+bounces-12033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0252A87F2FB
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:11:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC3961F22935
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222225B5CA;
	Mon, 18 Mar 2024 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CzXLzgfW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E3C5A4C7
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799811; cv=none; b=ZRrURnfOIfI2fqhhFFzwiA4u9GTwHipQHkKKPG5FYHEtw0zj1bVz6hTHubpMoV7ty+x3dmVStA/XpXJpEPIqMVCxB1+cWZzY7rDm5K4K/nnvE93MLXJwtC1lQ92IWYUG+QjuHIv+HfCyetxOytHWwH5DLpJF4r5BfsAdTfolNAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799811; c=relaxed/simple;
	bh=xM5W/AEDhbWznck8GcEsoD7ke6NnQ8+Pi6POT+TXjgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVT4wVXia78fBhPRa/KZhm5slvLLRG8EeEkQYvSXdeL0TKzmJIv49h9ja4NcxjYTMtO6mrjTRc0VKTHz3Vhx1O/Sa1O5CPtuEAqfhNrXgf/+PiWFdibg9q0V/iD5DporLOUe1xkYvARpqB1LsYsLoRbGUuu+YDe7NY5NlLrl4VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CzXLzgfW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710799808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l14lmjr+n9Dly31dq7L8425halZyBpXBAUC4NGSIZWM=;
	b=CzXLzgfW9IFunAL39GW9Yd+mBJZx5nxTbJuDjucLiq0p+7dbAfS7Tv5Bi8LqYmRXVZZ3JV
	ZLnstcwY1RG87pvl9LgHuaHCGiHz2G3++Q+xTRmZkLVvZiwabTAe4VCjji0DBbyWN3f//+
	bg/Z11N+zQBGqv1OB4AqrkmrxGCc3Lo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-262-b88i4gU6OEacsAnFBlDGXg-1; Mon,
 18 Mar 2024 18:10:04 -0400
X-MC-Unique: b88i4gU6OEacsAnFBlDGXg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 591DD2800EA6;
	Mon, 18 Mar 2024 22:10:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38595492BC8;
	Mon, 18 Mar 2024 22:10:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 4/7] KVM: SVM: Return -EINVAL instead of -EBUSY on attempt to re-init SEV/SEV-ES
Date: Mon, 18 Mar 2024 18:09:59 -0400
Message-ID: <20240318221002.2712738-5-pbonzini@redhat.com>
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

Return -EINVAL instead of -EBUSY if userspace attempts KVM_SEV{,ES}_INIT
on a VM that already has SEV active.  Returning -EBUSY is nonsencial as
it's impossible to deactivate SEV without destroying the VM, i.e. the VM
isn't "busy" in any sane sense of the word, and the odds of any userspace
wanting exactly -EBUSY on a userspace bug are minuscule.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240131235609.4161407-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5f8312edee36..f06f9e51ad9d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -259,9 +259,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (kvm->created_vcpus)
 		return -EINVAL;
 
-	ret = -EBUSY;
 	if (unlikely(sev->active))
-		return ret;
+		return -EINVAL;
 
 	sev->active = true;
 	sev->es_active = argp->id == KVM_SEV_ES_INIT;
-- 
2.43.0



