Return-Path: <kvm+bounces-37242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98664A276DE
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:13:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C80E83A3E8C
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 16:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FA4215196;
	Tue,  4 Feb 2025 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QxRO9M8x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874B02153E1
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 16:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738685625; cv=none; b=AaHpLpcoFMhWSykMGkuRHZi8o0HstMp9Av+OsHxto1woW6ctB6y1U2x3MwjfSiekoxavXIVJSB1DsoUqj6BXQFqv/8qkcVeirrX5syLREPkR7GuG49Njh3LgyhX6Vjm+qyYpp52QE4AnPYG3gkNiIMsYn3w0mAgIsApFycQ552Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738685625; c=relaxed/simple;
	bh=cPwqLr8BDELmolESMXNqze7lHcKNuRdbVtpTozCp7h4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=byvrN9zjq85zHKd6THaIiRq3ui7pMshk40ioIyAnRzu/Xql7rOJyEzeCIv1X3Tzfkbywn3cinwn50vQrDBhducj2Jth5I1S4tcQUoi3FLLOFBn/EpdstzgTEK/iKcPrq1RASSyO2ZXMv+jNw+tSWvY8tX+f8gObFIl8dtIHY0BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QxRO9M8x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738685622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UOgMQ3yv3bSOFkEu8fodu03c+EAHT2dI+/P5Nsr68W0=;
	b=QxRO9M8xCY0x2cz8twIxfCG/qDd/7CmiMlescE8Mhw1F3SV698hVnCF0eOq0WCuSYAqwZ0
	ll5I6Bp2KRBjlawcskwEIRY5sqWeD5wzv+YtZQLnrt5GOAKYodx167Ksl6dvF6fzlSDaLC
	0B01kZMyf5gfy6kDk8P3S8Ggn65TXyA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-En1GibzwNXio2bwmYREK2g-1; Tue,
 04 Feb 2025 11:13:39 -0500
X-MC-Unique: En1GibzwNXio2bwmYREK2g-1
X-Mimecast-MFC-AGG-ID: En1GibzwNXio2bwmYREK2g
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F270C18009B8;
	Tue,  4 Feb 2025 16:13:37 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4BFE630001BE;
	Tue,  4 Feb 2025 16:13:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com
Subject: [PATCH] kvm: x86: SRSO_USER_KERNEL_NO is not synthesized
Date: Tue,  4 Feb 2025 11:13:36 -0500
Message-ID: <20250204161336.251962-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

SYNTHESIZED_F() generally is used together with setup_force_cpu_cap(),
i.e. when it makes sense to present the feature even if cpuid does not
have it *and* the VM is not able to see the difference.  For example,
it can be used when mitigations on the host automatically protect
the guest as well.

The "SYNTHESIZED_F(SRSO_USER_KERNEL_NO)" line came in as a conflict
resolution between the CPUID overhaul from the KVM tree and support
for the feature in the x86 tree.  Using it right now does not hurt,
or make a difference for that matter, because there is no
setup_force_cpu_cap(X86_FEATURE_SRSO_USER_KERNEL_NO).  However, it
is a little less future proof in case such a setup_force_cpu_cap()
appears later, for a case where the kernel somehow is not vulnerable
but the guest would have to apply the mitigation.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2cbb3874ad39..8eb3a88707f2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1180,7 +1180,7 @@ void kvm_set_cpu_caps(void)
 		SYNTHESIZED_F(SBPB),
 		SYNTHESIZED_F(IBPB_BRTYPE),
 		SYNTHESIZED_F(SRSO_NO),
-		SYNTHESIZED_F(SRSO_USER_KERNEL_NO),
+		F(SRSO_USER_KERNEL_NO),
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
-- 
2.43.5


