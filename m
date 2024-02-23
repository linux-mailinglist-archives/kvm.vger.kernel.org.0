Return-Path: <kvm+bounces-9514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73186860FA5
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 11:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A00C01C22ADB
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 10:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D6F7BB17;
	Fri, 23 Feb 2024 10:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EMVrFMJg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A0F78B7B
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708684819; cv=none; b=BlVgRmMeTMChtZGbw0BqEYksj0D6t7GCbjFcgoEk9wK9TzDv2ffMat5cdUzSjZCFM1R7J6O/mPvI/WCeJj8jSEtykz8Ns38ClXfi3I/mw7znrpEj2kegEhKCcTlmc57eNFNCNMHjyltYI+xBPOpiLENTE6IDqVTeSY31V2k4zN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708684819; c=relaxed/simple;
	bh=pU+I1UNsFigwwYduAuVyFUMAum80+uoBu3TqnVl6ud4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dd81kPRGeVJ/FOSCAtMg5rnubNwzVaGAAU6fJQlY3ymQtctL7e0SfuhrgzFz/G8GU5ndMOWBKnc0W9sr0XJOkEfo2cdRB3eVLoAC8zFfJ5SbFmZZW4w8G+ViV7OgV6R44oLcDjU3yhKVTW8JEBwHlbRIrdOnLFQw4l0N1sfISHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EMVrFMJg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708684816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/d+3soBxX8Esy8j47TVH8Z004bmpwg8FksG075eEEEk=;
	b=EMVrFMJg126jYjHF9Jvb20fSXU4cVNlg4bc7Jji6JESGIMpD+svczed1272P/alaS8HXcV
	NzpB8El3f7NDsaBqNz8Qv340g7t4j2WR/1vzuxNZIl/4iPOxgyBbLiZtL6RxbEpeZ/sPUW
	hJa3kZA0eNmqfl4vcbLgE05qRIVwNt4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-2OYUTg_bN8qaFMvQcjEpww-1; Fri,
 23 Feb 2024 05:40:12 -0500
X-MC-Unique: 2OYUTg_bN8qaFMvQcjEpww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FE1729AA2CF;
	Fri, 23 Feb 2024 10:40:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A420112132A;
	Fri, 23 Feb 2024 10:40:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v2 06/11] KVM: SEV: disable DEBUG_SWAP by default
Date: Fri, 23 Feb 2024 05:40:04 -0500
Message-Id: <20240223104009.632194-7-pbonzini@redhat.com>
In-Reply-To: <20240223104009.632194-1-pbonzini@redhat.com>
References: <20240223104009.632194-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Disable all VMSA features in KVM_SEV_INIT and KVM_SEV_ES_INIT.  They are
not actually supported by SEV (a SEV guest does not have a VMSA to which
you can apply features) and they cause unexpected changes in measurement
for SEV-ES.

Going on, the way to enable them will be to use a new initialization ioctl
that takes the VMSA features as a parameter.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b0e97f9617e3..06e03a6fe7e4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -267,7 +267,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev->active = true;
 	sev->es_active = argp->id == KVM_SEV_ES_INIT;
-	sev->vmsa_features = sev_supported_vmsa_features;
+	sev->vmsa_features = 0;
 
 	asid = sev_asid_new(sev);
 	if (asid < 0)
-- 
2.39.1



