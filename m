Return-Path: <kvm+bounces-49483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC4C8AD9519
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EFF017E73C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DBF23D28A;
	Fri, 13 Jun 2025 19:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kez1Vmlu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948BF255F52
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842063; cv=none; b=VtVTAZvYzE+WL2NbpENl7bfJzmqPvJnBE3RSXiYedcoPcTWsgGIUhEuD596jqMyz+CLvyEeMzUC+HgyD6abkXngObrvavLEyyGuxO8Lj/JhLLCZ4vcrSeBacVxFbleD2iriJAgLgfHBpIHZPPlCsGTR1ucI4w5RJpxthKpwAhaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842063; c=relaxed/simple;
	bh=WuNQeIEjxP0MpZ43wQJ8QH7/E4ptzd6ZC4ALnAIRTio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VZooaQ+h/6efCwoSRNnlJuGsng6m756Lvt4K154+gv9dJION+pBLIjcmCf4lKbCj1Eb2OWAvMcDuXFPBqTAZArxTKQ9Vo4BA6BhrMgk+Rc2iMn8tx8zBaPKtyH8mXoqyawIRJgD8AUPrCR53OqpA0heeWpfOLPM3T5BSX0qSayA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kez1Vmlu; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c00e965d0so1582685a12.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749842060; x=1750446860; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lK8PSoEGI5Kbvnp6kPiiz7QOvkRIGce991kbDt0U/HU=;
        b=Kez1VmluuKC4Hhsc58tcbMt3SFtDCOg+rO6quYIdNFPBDKxRK7EZosIZPiS1gDxSsJ
         QibalauIbXzcL5Txt8fcW+4jUO2ow9riW9GGrV6/sUZL21K5Mqio9AHha+KVA17/8YYq
         gDvRcXkEn1hizdrXuH922dysA5e6Wy5U5/gJq6F9rMC+CsCRagNAfcilGCdg2fVaBjXu
         W+1AG4CuQRAs4mLvjhMeuYqqgvIoLtHhFTJdw3QOPujfA5sNa/cgnqtLaUGLUdL4zIAT
         KLFarg9edTW1f6bmMr1VN2dRJHBKdP5gJKBilHYDxvannRyFV1XJNgO1pycjyxKTc6he
         K+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842060; x=1750446860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lK8PSoEGI5Kbvnp6kPiiz7QOvkRIGce991kbDt0U/HU=;
        b=plNdvWxHd7/xAVCxYNlA5Fom3y6B5CnoTKs8scpCmt4KXNZXKgqL9rOBa05YpGBE8/
         /lQN3lqLyswMmy3n9f5HBO4ixySfjf0/WkjwWu4sIBl8T8zx3Kc8NGkeov8IIQZZfAov
         iXDTytMxhg4Q/RZfS3xE9sjQS78Rj6wrZ1hKaiktvu6FfsyHEsiePP+URC/biUdW1nzA
         0jXId69cY3nXr6YJaWwzIXmEDdme/gjHZqeJsqBgpK6g2AUKv2xs3dsAvlZ/VDSQIhGF
         sV7pADKBCoBhO9CCImj0A9ajh5u3dFYVidPEBQaVXptAj6mCU13xDaZiiVaOFuXEiFp0
         1+hg==
X-Forwarded-Encrypted: i=1; AJvYcCUqqa3h3X+OPLsiHiAZdElJpojX6U9mf6ybil875j1iVUF3KgqvTlqSyphOWaNE+QueRPs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc5a4hjBl0qHVev5fZM2iGIVhRA2aYao8yXg0EVThvMm6H+8qc
	eOX4WzGQmU2YAm2N6je/qwZHJXjma4NmiUxK33lmPy90GYghNzOdw6EEZBJ5iq1SlYVu2ROnxtY
	HAQ==
X-Google-Smtp-Source: AGHT+IG2rnq08o1rOOulMjf3/xAjuyKFVtU58bEMOUg+186GSEJdawuT9DZLEd/V6esV4Z1DRz0RGaOAmQ==
X-Received: from pjbsm7.prod.google.com ([2002:a17:90b:2e47:b0:312:f650:c7aa])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dcd:b0:311:a314:c2e0
 with SMTP id 98e67ed59e1d1-313f1cae3b7mr1173552a91.20.1749842059954; Fri, 13
 Jun 2025 12:14:19 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:13:32 -0700
In-Reply-To: <20250613191359.35078-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613191359.35078-1-sagis@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613191359.35078-6-sagis@google.com>
Subject: [PATCH v7 05/30] KVM: selftests: Update kvm_init_vm_address_properties()
 for TDX
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Isaku Yamahata <isaku.yamahata@intel.com>

Let kvm_init_vm_address_properties() initialize vm->arch.{s_bit, tag_mask}
similar to SEV.

Set shared bit position based on guest maximum physical address width
instead of maximum physical address width, because that is what KVM
uses, refer to setup_tdparams_eptp_controls(), and because maximum physical
address width can be different.

In the case of SRF, guest maximum physical address width is 48 because SRF
does not support 5-level EPT, even though the maximum physical address
width is 52.

Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/lib/x86/processor.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index d082d429e127..d9f4ecd6ffbc 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1166,10 +1166,19 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 
 void kvm_init_vm_address_properties(struct kvm_vm *vm)
 {
+	uint32_t gpa_bits = kvm_cpu_property(X86_PROPERTY_GUEST_MAX_PHY_ADDR)
+
 	if (is_sev_vm(vm)) {
 		vm->arch.sev_fd = open_sev_dev_path_or_exit();
 		vm->arch.c_bit = BIT_ULL(this_cpu_property(X86_PROPERTY_SEV_C_BIT));
 		vm->gpa_tag_mask = vm->arch.c_bit;
+	} else if (vm->type == KVM_X86_TDX_VM) {
+		TEST_ASSERT(gpa_bits == 48 || gpa_bits == 52,
+			    "TDX: bad X86_PROPERTY_GUEST_MAX_PHY_ADDR value: %u", gpa_bits);
+		vm->arch.sev_fd = -1;
+		vm->arch.s_bit = 1ULL << (gpa_bits - 1);
+		vm->arch.c_bit = 0;
+		vm->gpa_tag_mask = vm->arch.s_bit;
 	} else {
 		vm->arch.sev_fd = -1;
 	}
-- 
2.50.0.rc2.692.g299adb8693-goog


