Return-Path: <kvm+bounces-39369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A3C2A46B85
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E00F0188C98C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8AC82641F7;
	Wed, 26 Feb 2025 19:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ecKu+W1x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6882525E466
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599751; cv=none; b=b7JRw8F5m0YHHSPE+spDaQJp1W9pMnbnTiBvfQz2tUfiWmw/Dym117Cc1nWDA97GDU9R+xa2CojHmL92dh5kRf/vy/299MwTmprl1qWcRffc/rddzZWu701UXwNXegpxhJ987zr7LiT/DSh4AlylMFksRx8UsYJEBJZCZThRd0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599751; c=relaxed/simple;
	bh=71c0Xtv1G3sdZShTLwpLDw/Yx2zIkCmErPobYWY6JJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tnkmwtqi0z0K5MaS6YVLxZJlCJgDImG5QGhz+IiyC5NvzoJh5is6m22a5U7LzhJEBuNGkB+HYPXzvvTyg/Dzd1wwyaIY4vYMUsFPOOiZ3ZPkeboRDWpJFjryiJey34VzeMWcmsuXBmG9iKfZBzK851srmhVZg0xQVaSua3Kh4Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ecKu+W1x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tIU7KaERyuJNgcNNJI4KzTDkF/zeQ9fHuKz3CRSp9RE=;
	b=ecKu+W1xtqw5cCcyOV5F0//UCHyDpEjgRxq/s2C41lRdDI2Uk/qtofdf7+j4p9oAIK0M3R
	Rp12LMc0pRwB8JVimAZAunWxTbTC/8O3hKJqb2Lv45tb19PAiWZgjHW9bOzhGGGLrvMEpM
	C8NNy3+ZX+wZVA8khmhvc7IiZqC8eIg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-AL00vHvIPo2IKzW5Vb-kpQ-1; Wed,
 26 Feb 2025 14:55:44 -0500
X-MC-Unique: AL00vHvIPo2IKzW5Vb-kpQ-1
X-Mimecast-MFC-AGG-ID: AL00vHvIPo2IKzW5Vb-kpQ_1740599742
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6BB219560B9;
	Wed, 26 Feb 2025 19:55:42 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7F2001944D02;
	Wed, 26 Feb 2025 19:55:41 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@linux.intel.com>
Subject: [PATCH 08/29] KVM: x86/mmu: Do not enable page track for TD guest
Date: Wed, 26 Feb 2025 14:55:08 -0500
Message-ID: <20250226195529.2314580-9-pbonzini@redhat.com>
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

From: Yan Zhao <yan.y.zhao@intel.com>

Fail kvm_page_track_write_tracking_enabled() if VM type is TDX to make the
external page track user fail in kvm_page_track_register_notifier() since
TDX does not support write protection and hence page track.

No need to fail KVM internal users of page track (i.e. for shadow page),
because TDX is always with EPT enabled and currently TDX module does not
emulate and send VMLAUNCH/VMRESUME VMExits to VMM.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>
Message-ID: <20241112073515.22028-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/page_track.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 561c331fd6ec..1b17b12393a8 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -172,6 +172,9 @@ static int kvm_enable_external_write_tracking(struct kvm *kvm)
 	struct kvm_memory_slot *slot;
 	int r = 0, i, bkt;
 
+	if (kvm->arch.vm_type == KVM_X86_TDX_VM)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&kvm->slots_arch_lock);
 
 	/*
-- 
2.43.5



