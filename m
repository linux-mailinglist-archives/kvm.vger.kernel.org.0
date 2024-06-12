Return-Path: <kvm+bounces-19515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2A2905E07
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 012C0B20FDE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943C812A14C;
	Wed, 12 Jun 2024 21:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="DJTf9oMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA5B82488
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718229271; cv=none; b=KbOyJ+V0wBreKGwcqQdfjnG/Wy+Gl74WsyQvoCZlzcJ4+JVWcPSW2VfVONYonLRNNpCkSnSNDCr9YkmDnq1vEWzzHoR2Q72knU0ZcfPhlscuiuTTmcxvBRlFgUWU4y9TlZVykEuqZtt+KNdY/QTj9G0J92EKPeka5dtRC9p3W8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718229271; c=relaxed/simple;
	bh=YYK68WFDRsw2ngRpORU4BvMiRT9JZvHsdKs2lAAvwXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=twgzKqKE3ipd+ss0mA8zojKrvUeUwPWsXzSraSQyptOfMtRyjNrCQ9r5nPRQ1h8usBZ3kNGcZmRM/nl20xuFz1aoLZQOtnf6D5tdI//Icg2bN3ALFnL8vCieQ8KkVVVuKeoxONEXQ2eylAv8Q58nP8k0qqPCI3Tar7EHtKQd/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=DJTf9oMc; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a6265d48ec3so51218566b.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718229268; x=1718834068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GpnIlzasRXPDrLHeFqpUbRMekE5s61RRbf6mIjmfyP4=;
        b=DJTf9oMcqUxWfdBt8xMpcgOHk9lYG/+i1sEK1fpIoH7HZFacGC7qdWNEY5Ujdy/EwB
         cz4lExLNT4zOOdfVwCEz4QxuaogCsUqm3QxnzKRSX+UhUTaAMFBTKL9PVdiQfM786LhO
         SFIwV/sP4EKlxrz9+r/6jv9eJvL7rtvQGeWTCCgoE4GU3DX94AOG96XVYJehXYrBEHID
         nNyuAUCtCL0mvb/tLt9/OnLXZf/ZHm022VyCVpqBJ6emNqZlNczpBzgms6uSBTeMEjjL
         9VrZ9HX9Cpl3GG8PbF3sGlEJYh/N1iq95RvnjNTOR84qaJxSg+kl6M+Ds+6XQGCsLz7o
         RAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718229268; x=1718834068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GpnIlzasRXPDrLHeFqpUbRMekE5s61RRbf6mIjmfyP4=;
        b=ByNn/jRs5ITwCRxPMYoDwP4nVNHOjlP7o6sOEqi5CBo2ak0YvQw7/p2h9aDbgwSndU
         WpwqdP94bg33oVwy4DteIMwPpv/1/uZv4WnrStPSgY6c7kLga+OoM/nX9NQBnixnofiP
         jiFNT/szlyOInRZNvnN/zLYagdRFVboK/VkZQ+HdCVpqhR1xNuqVdkURRn+Bx9yRYyU/
         QPvRfcEL4BWj/1udhR3o5t1fYE/S/yh8ndnvZwdNrGRyrmewRnk2CtdoBcE4RyfUAlSl
         mE4JzfmoWD/boQ2rc4/OQ+IHxbDKqcuGGQTfcH0hLbGkSKlYn7PL35xRY7P05TH44vPY
         bz0g==
X-Gm-Message-State: AOJu0YznqrMtrCqtuMzSyfxLV+UvP1lKUqv2ZoiV1A214rBPgVT5xWkL
	uB/zoWYgId4DFONAAYF5FhOOu8g0Yrf0hMgu65e4M6ci4iRrO4rT722MOp+Eo+Y=
X-Google-Smtp-Source: AGHT+IFAP2dxYnk5y5m6tXMhQr8qkxgEQ7fuY4uqCUeHAYT2sEziLS32qJpOa3tt50BpR+y1tQlqHg==
X-Received: by 2002:a17:907:2d28:b0:a6f:1f4a:dfba with SMTP id a640c23a62f3a-a6f47cc0dcemr205356466b.43.1718229268191;
        Wed, 12 Jun 2024 14:54:28 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af372f000c444b1ebcbc1017.dip0.t-ipconnect.de. [2003:f6:af37:2f00:c44:4b1e:bcbc:1017])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6dff0247a4sm785359966b.147.2024.06.12.14.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 14:54:27 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>,
	Emese Revfy <re.emese@gmail.com>,
	PaX Team <pageexec@freemail.hu>
Subject: [PATCH v2 1/4] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
Date: Wed, 12 Jun 2024 23:54:12 +0200
Message-Id: <20240612215415.3450952-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240612215415.3450952-1-minipli@grsecurity.net>
References: <20240612215415.3450952-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If, on a 64 bit system, a vCPU ID is provided that has the upper 32 bits
set to a non-zero value, it may get accepted if the truncated to 32 bits
integer value is below KVM_MAX_VCPU_IDS and 'max_vcpus'. This feels very
wrong and triggered the reporting logic of PaX's SIZE_OVERFLOW plugin.

Instead of silently truncating and accepting such values, pass the full
value to kvm_vm_ioctl_create_vcpu() and make the existing limit checks
return an error.

Even if this is a userland ABI breaking change, no sane userland could
have ever relied on that behaviour.

Reported-by: PaX's SIZE_OVERFLOW plugin running on grsecurity's syzkaller
Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Cc: Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2:
- add comment and build bug to make truncation check more obvious (Sean)
 virt/kvm/kvm_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..b04e87f6568f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4200,12 +4200,20 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
 	struct page *page;
 
+	/*
+	 * KVM tracks vCPU IDs as 'int', be kind to userspace and reject
+	 * too-large values instead of silently truncating.
+	 *
+	 * Also ensure we're not breaking this assumption by accidentally
+	 * pushing KVM_MAX_VCPU_IDS above INT_MAX.
+	 */
+	BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);
 	if (id >= KVM_MAX_VCPU_IDS)
 		return -EINVAL;
 
-- 
2.30.2


