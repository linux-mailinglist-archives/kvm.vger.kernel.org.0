Return-Path: <kvm+bounces-5510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 949B2822922
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 312F81F23B81
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 07:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F3E182B5;
	Wed,  3 Jan 2024 07:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CeJMq+hm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFAA18044
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 07:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704268435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SWQQWalLqDTi/rVwra4T6IuCV/dWGZrTeD1nxNtIarw=;
	b=CeJMq+hmIXz6E4xz4l14u8thEZcytkclMkP3HRh7UFVcbz/IqgmnoU0d9YYISLbFYYZNCX
	Rd3Z8EW+Jrw8+iJ3JGflIzq15xhMeqxplbd0lF40i37wlFgblppL4Zv7VBhZx6qzSao/n7
	uLaPqzfEVyTmEzUB2XWze9sAuVAzEN4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-qB21hdV7MgeY4gGnoxEWzA-1; Wed, 03 Jan 2024 02:53:51 -0500
X-MC-Unique: qB21hdV7MgeY4gGnoxEWzA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78DA9101A555;
	Wed,  3 Jan 2024 07:53:51 +0000 (UTC)
Received: from kaapi.redhat.com (unknown [10.74.16.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DEA5492BE6;
	Wed,  3 Jan 2024 07:53:49 +0000 (UTC)
From: Prasad Pandit <ppandit@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Prasad Pandit <pjp@fedoraproject.org>
Subject: [PATCH] KVM: x86: make KVM_REQ_NMI request iff NMI pending for vcpu
Date: Wed,  3 Jan 2024 13:23:43 +0530
Message-ID: <20240103075343.549293-1-ppandit@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

From: Prasad Pandit <pjp@fedoraproject.org>

kvm_vcpu_ioctl_x86_set_vcpu_events() routine makes 'KVM_REQ_NMI'
request for a vcpu even when its 'events->nmi.pending' is zero.
Ex:
    qemu_thread_start
     kvm_vcpu_thread_fn
      qemu_wait_io_event
       qemu_wait_io_event_common
        process_queued_cpu_work
         do_kvm_cpu_synchronize_post_init/_reset
          kvm_arch_put_registers
           kvm_put_vcpu_events (cpu, level=[2|3])

This leads vCPU threads in QEMU to constantly acquire & release the
global mutex lock, delaying the guest boot due to lock contention.
Add check to make KVM_REQ_NMI request only if vcpu has NMI pending.

Fixes: bdedff263132 ("KVM: x86: Route pending NMIs from userspace through process_nmi()")
Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a3aaa7dafae..468870450b8b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5405,7 +5405,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
 		vcpu->arch.nmi_pending = 0;
 		atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
-		kvm_make_request(KVM_REQ_NMI, vcpu);
+		if (events->nmi.pending)
+			kvm_make_request(KVM_REQ_NMI, vcpu);
 	}
 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);

--
2.43.0


