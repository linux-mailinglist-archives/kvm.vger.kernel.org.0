Return-Path: <kvm+bounces-31735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CAA9C6E99
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D22802839C4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33D6201118;
	Wed, 13 Nov 2024 12:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8A9qENn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B03C200C8B
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 12:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731499311; cv=none; b=R9VJ/uCQWlT27Ll4vYhq0b4hUwpa4SiSSh0RECt3JfTCR/tZ/Pkpjl2w7oxN38Uyh4rniKekd0bjWQDzA3Wm11IFGPt6xWg1Boi/x7CK7sCa3+ogzrUE4QZIXq1B6PvcFMu9Zyj/CFRzN4lF08wZdYWKtuM6bzfGpPbDWo1QWlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731499311; c=relaxed/simple;
	bh=ZRNu98X/Aq7FMdr669P99K9A18RVmmAu4sWC/JQfSa8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t+w7QdB7bu5NZs0ZdQFHZjK/6AtGqLcNBOzX6H5Y1knJCQwWqnlVszy/NgK7pmm0RUwhQ8YilDVuruwZ82rShPddMT8nOqGg4VtJL1pOf9SCEdGBxalnoPoTBXRFAlm+a2R06vb4iJMZBHmF0wZrr+3QJ96c1YAzESlK7tSvH1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8A9qENn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731499308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i64/HfOLCzx+xwWoMfRTr2iqUATuC1Oi6/xkRusoSNU=;
	b=D8A9qENnXa6Rw6XZsYNdaUgy9lBLWEFrz10VmJEmGlVaiaRj7SjGFhwpqs03S3E2tXUO1X
	iosK/rvjzLqW4Da8Z4nxoqtFf6qFFUqR9elvpG7x/+zSh/kTvW/r47VV24DFl3a4G+xwPK
	k4bDyKS5dG1yk7fq5i93xnCxuGgwQTQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-lZrQ2DvcOzGkdpuagMY_CA-1; Wed,
 13 Nov 2024 07:01:47 -0500
X-MC-Unique: lZrQ2DvcOzGkdpuagMY_CA-1
X-Mimecast-MFC-AGG-ID: lZrQ2DvcOzGkdpuagMY_CA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A3151954226;
	Wed, 13 Nov 2024 12:01:46 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C0ED01955F3C;
	Wed, 13 Nov 2024 12:01:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: expose MSR_PLATFORM_INFO as a feature MSR
Date: Wed, 13 Nov 2024 07:01:44 -0500
Message-ID: <20241113120145.388071-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

For userspace that wants to disable KVM_X86_QUIRK_STUFF_FEATURE_MSRS, it
is useful to know what bits can be set to 1 in MSR_PLATFORM_INFO (apart
from the TSC ratio).  The right way to do that is via /dev/kvm's
feature MSR mechanism.

In fact, MSR_PLATFORM_INFO is already a feature MSR for the purpose of
blocking updates after the vCPU is run, but KVM_GET_MSRS did not return
a valid value for it.

Just like in a VM that leaves KVM_X86_QUIRK_STUFF_FEATURE_MSRS enabled,
the TSC ratio field is left to 0.  Only bit 31 is set.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8637bc001096..03b409deb7d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1675,6 +1675,9 @@ static int kvm_get_feature_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	case MSR_IA32_PERF_CAPABILITIES:
 		*data = kvm_caps.supported_perf_cap;
 		break;
+	case MSR_PLATFORM_INFO:
+		msr->data = MSR_PLATFORM_INFO_CPUID_FAULT;
+		break;
 	case MSR_IA32_UCODE_REV:
 		rdmsrl_safe(index, data);
 		break;
-- 
2.43.5


