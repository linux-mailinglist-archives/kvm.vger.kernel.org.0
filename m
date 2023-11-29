Return-Path: <kvm+bounces-2734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 845F07FCFDF
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 08:28:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B07E282924
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 07:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C792F10959;
	Wed, 29 Nov 2023 07:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b/zzJ3D8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F26DA
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 23:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701242853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/PkR03f+9VfCYETbYP2LE2uGV5Kg0J9vteA61mMgJc=;
	b=b/zzJ3D8Npnz1w8kj5WyEPMWWNPaFzhyZTGm3nLAg13OmyekG7fYNSq5p7N4y4ZoK2hzPZ
	iIKfq/TqjlhNlKYQEnbxKIZ6dmPxmC5GHXcJjOowpW3LAbhn5bkkOyC/+4S3ermvsdP1J6
	scRR059/QIFHnQTc0LLuIRCqGreiW/w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-QeP6sf1_M6WC6fNL7yu2Ig-1; Wed, 29 Nov 2023 02:27:27 -0500
X-MC-Unique: QeP6sf1_M6WC6fNL7yu2Ig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21C19852ACB;
	Wed, 29 Nov 2023 07:27:27 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10FB01C060AE;
	Wed, 29 Nov 2023 07:27:27 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Eric Auger <eauger@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] KVM: selftests: aarch64: Fix the buggy [enable|disable]_counter
Date: Wed, 29 Nov 2023 02:27:05 -0500
Message-Id: <20231129072712.2667337-4-shahuang@redhat.com>
In-Reply-To: <20231129072712.2667337-1-shahuang@redhat.com>
References: <20231129072712.2667337-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

In general, the set/clr registers should always be used in their
write form, never in a RMW form (imagine an interrupt disabling
a counter between the read and the write...).

The current implementation of [enable|disable]_counter both use the RMW
form, fix them by directly write to the set/clr registers.

At the same time, it also fix the buggy disable_counter() which would
end up disabling all the counters.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 tools/testing/selftests/kvm/include/aarch64/vpmu.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/vpmu.h b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
index e0cc1ca1c4b7..644dae3814b5 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vpmu.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
@@ -78,17 +78,13 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
 
 static inline void enable_counter(int idx)
 {
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenset_el0);
+	write_sysreg(BIT(idx), pmcntenset_el0);
 	isb();
 }
 
 static inline void disable_counter(int idx)
 {
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
+	write_sysreg(BIT(idx), pmcntenclr_el0);
 	isb();
 }
 
-- 
2.40.1


