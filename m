Return-Path: <kvm+bounces-51987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 615B9AFF032
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 19:54:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56EA11C825C7
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 17:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A77623C502;
	Wed,  9 Jul 2025 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jv2ElF6l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3666239E9C
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 17:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752083593; cv=none; b=L6oDSgBbRB+MzIKBbAOOT/m2BAKaE6FyHeaut4KAVYHGe1WJ/Jmv6yd31bwA/3aA+vAuv/tjofKCETtrrvxkthl3M/fW4+DUyAwb7GHAoBfoZran3cVZM6S2ni1o3y5+xhutE6Zw9Ni9MRYW6QlIl1fqMscjp/kBLALgDEpTGeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752083593; c=relaxed/simple;
	bh=Mu/vEwykicqa3sW2iz5ZrXrPavYLXSsA3HF6TMndu6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S2p1mp5L6g2jYJoYtSNFtYzMEvN2pEP5SSsPAIRl3XVJEdws1bZLo9NiRTzH3Yqry+PnEFFiukY7o+YhapTyeiN7GASQFQPJBcV9QDOF7uwSC21+xHXOGxsnNWk37MAjknHXx96qwgFjMpojHACrQUViBr8kPAWaDpuMu9M8mis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jv2ElF6l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752083589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6B8QlnDbL7txSd+jiz/U6vGVYrpYeKQzpaMnG5t2poQ=;
	b=Jv2ElF6l500cZK4DgHFhwdjR2arxLkLuWLt8JHRHidvAucuQM2sa1FzG79p9s+TV/XvCmT
	Gyh+WxpNEflmuNs1+iQroavC3AMsnzVud+2Ucn1XbIDEJaio5M9+lGb0PJ1KZr2KnTLtjF
	YY1hQWKBgNPkLSYjSZckFadD8zx9l/Y=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-pSGlg5aUMZil4X0oIUwjlA-1; Wed,
 09 Jul 2025 13:53:06 -0400
X-MC-Unique: pSGlg5aUMZil4X0oIUwjlA-1
X-Mimecast-MFC-AGG-ID: pSGlg5aUMZil4X0oIUwjlA_1752083585
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFEB918011CD;
	Wed,  9 Jul 2025 17:53:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F35AD1955E85;
	Wed,  9 Jul 2025 17:53:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Yuntao Liu <liuyuntao12@huawei.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: x86: avoid underflow when scaling TSC frequency
Date: Wed,  9 Jul 2025 13:53:03 -0400
Message-ID: <20250709175303.228675-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

In function kvm_guest_time_update(), __scale_tsc() is used to calculate
a TSC *frequency* rather than a TSC value.  With low-enough ratios,
a TSC value that is less than 1 would underflow to 0 and to an infinite
while loop in kvm_get_time_scale():

  kvm_guest_time_update(struct kvm_vcpu *v)
    if (kvm_caps.has_tsc_control)
      tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
                                  v->arch.l1_tsc_scaling_ratio);
        __scale_tsc(u64 ratio, u64 tsc)
          ratio=122380531, tsc=2299998, N=48
          ratio*tsc >> N = 0.999... -> 0

Later in the function:

  Call Trace:
   <TASK>
   kvm_get_time_scale arch/x86/kvm/x86.c:2458 [inline]
   kvm_guest_time_update+0x926/0xb00 arch/x86/kvm/x86.c:3268
   vcpu_enter_guest.constprop.0+0x1e70/0x3cf0 arch/x86/kvm/x86.c:10678
   vcpu_run+0x129/0x8d0 arch/x86/kvm/x86.c:11126
   kvm_arch_vcpu_ioctl_run+0x37a/0x13d0 arch/x86/kvm/x86.c:11352
   kvm_vcpu_ioctl+0x56b/0xe60 virt/kvm/kvm_main.c:4188
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:871 [inline]
   __se_sys_ioctl+0x12d/0x190 fs/ioctl.c:857
   do_syscall_x64 arch/x86/entry/common.c:51 [inline]
   do_syscall_64+0x59/0x110 arch/x86/entry/common.c:81
   entry_SYSCALL_64_after_hwframe+0x78/0xe2

This can really happen only when fuzzing, since the TSC frequency
would have to be nonsensically low.

Fixes: 35181e86df97 ("KVM: x86: Add a common TSC scaling function")
Reported-by: Yuntao Liu <liuyuntao12@huawei.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b58a74c1722d..de51dbd85a58 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3258,9 +3258,11 @@ int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	/* With all the info we got, fill in the values */
 
-	if (kvm_caps.has_tsc_control)
+	if (kvm_caps.has_tsc_control) {
 		tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
 					    v->arch.l1_tsc_scaling_ratio);
+		tgt_tsc_khz = tgt_tsc_khz ? : 1;
+	}
 
 	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
 		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
-- 
2.43.5


