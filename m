Return-Path: <kvm+bounces-39368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA7DA46B84
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E56A616C60C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C807326157F;
	Wed, 26 Feb 2025 19:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e/wusIXd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF4925E458
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599749; cv=none; b=aCVGwumxcenbpc3IwIk6PFWet6t/mqEsMCDLiLXaDOqsma943A1kZr496DQW+GzV8gAKQfamYkqetFt+wJJAMP/AG//P8DGAJj3cvo5bYXuRO3dvb6FbAGLY9BcE5ZusdOuWy0IDdMv1fRZSxNZV99fudQQ7VoZMXNIUkvGI838=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599749; c=relaxed/simple;
	bh=YApeIwsQId9X/2wsGLl/eGkRiUx1BikJ1Isg+Wz2W+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yd5DKoR36XJS3SMkIU8Q/no3qRUPyzDXZ+zHx8UsADZ5Fxc951SBUD1p5gZTBwPl9m+kz+YmWdSnebFjNo4z8DkGJ73VfD7oX5r6iCOvZqAL+Y0dK7m8E3E63N+LIVNLgVJeLazT8AxAHSRdGH+BAxcQrZRhtnEvoQ6MeOES1i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e/wusIXd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x8HwOqxovlLqANJKv1rHzsM8ETvMMYIO18NESmV+lHw=;
	b=e/wusIXdER65fxke1Wltdn+d98tKw8f3MXDsoQbcgleie1PykEjWAvEOLy8tn0oleoP0jv
	2MeUMPDND/Qp7B/1XrJqhILHQAPFC+LrbdLwi/Ubm7P4Yb2NFjApuEXX5ZGUZThWwHoe/3
	U80UW6hKAqKLUWgEMfiBA85QS2RomM8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-evdx9S5qN-aWNzHcZO3nDA-1; Wed,
 26 Feb 2025 14:55:41 -0500
X-MC-Unique: evdx9S5qN-aWNzHcZO3nDA-1
X-Mimecast-MFC-AGG-ID: evdx9S5qN-aWNzHcZO3nDA_1740599740
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43A391800872;
	Wed, 26 Feb 2025 19:55:40 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 44C551944D02;
	Wed, 26 Feb 2025 19:55:39 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 06/29] KVM: x86/mmu: Implement memslot deletion for TDX
Date: Wed, 26 Feb 2025 14:55:06 -0500
Message-ID: <20250226195529.2314580-7-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Update attr_filter field to zap both private and shared mappings for TDX
when memslot is deleted.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20241112073426.21997-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c1c54a7a7735..9d5d50e2464f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7072,6 +7072,7 @@ static void kvm_mmu_zap_memslot(struct kvm *kvm,
 		.start = slot->base_gfn,
 		.end = slot->base_gfn + slot->npages,
 		.may_block = true,
+		.attr_filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED,
 	};
 	bool flush;
 
-- 
2.43.5



