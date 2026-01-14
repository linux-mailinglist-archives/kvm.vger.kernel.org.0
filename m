Return-Path: <kvm+bounces-67995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27ACBD1BD19
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 01:33:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32CCA308B0AB
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EF921CA13;
	Wed, 14 Jan 2026 00:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hb65YCRc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341001F4CA9
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 00:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768350621; cv=none; b=TCZoAsqLxTd/Y9zEOrAxMko0ht2K2MzP7sS8+lhk1XSrFt72mAmnat8TV9Amc/e7NoOKR8jEdOt2AxLKB1ZYo+yrFy4qCNnqzTZzc//OS1OrJPYlYRdw8Nqq3rqkMrWXLgo5fTUAJXvlLeQeqCgVuDICIpwmmynYwwGKVPZiEgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768350621; c=relaxed/simple;
	bh=Sww1KhC26DhzRX8vj6+jeZjMA0ohksUqS7ewJwBUchw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oqmBlwIQcX4Rpn+vj0rlHENDBDGwjscXMpFcBudpsEwZFUHOzgEtgaZGg3AAv8aUuzZGIKGFKttmdssVdXwHpLWVNQeHN0k2tQzcQ1k202MLm3VH6MudjskkQlqoFy2vVFZ7Wo2v1Ykg/b4aIXjsT4TcrOOkDWvwp7QqJrG3Ll4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hb65YCRc; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-40014408503so4860093fac.3
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768350619; x=1768955419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mDqQzZpBqG5DC4HlLuHkP1lRxnE+ttALMGnQiFNcgcU=;
        b=Hb65YCRcWPftMCNljS8ZQNYlX26ShYHvBZ3D5Ek7ctmkcY4hfPtCWGgHxxA7BTjBvz
         7M5Qmjg39od9eni8zea5bP8L0ceoUKefK24ze07jLh4QKJkWwbl/V4HvugOLAmJ2PGis
         pYwj3XYZYLsG0QJu8YfOjZmgC1jcjawqHf16oEZt4ScYfHt5tDJEfwPU8H5yoWDcjDbq
         I/LDGjcA2bH7ouLkP5MBkx6qBBpAyctCdMQ8KPYQ2T0e0Bivy8Cigz6tToX2qXCkvF75
         40beVaWs8W4sUnk07uMqUrtBkq2JdHFg2lFTcay0MbMHcnSdBazMivpJKYAV5vHCE3th
         PXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768350619; x=1768955419;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mDqQzZpBqG5DC4HlLuHkP1lRxnE+ttALMGnQiFNcgcU=;
        b=E+BMOKLW10nabJp2uNygtX4/TtZnOi6YWJmN1ZbXMGUKmZgizokO8/6JxBh/U+KPeZ
         Kd2Dhir589Y2LUqzkdNsvd8f4vyB+iqLm6K4iyGwynVVOIrN0ySV5enL+w6VF5xytRrq
         zjCPmZdeT6DAVytDfUukwZ/okLWwZ2ZUVTPsVZo78jNRR9MxFjXsO2aw+1SUbq1yFbaw
         UveclTuv5kn2BnDAWW6i3fB8fYKXZjtkZKjjljt1kICEbAYL42PM/jqvh3THFYkKTVbs
         X4T87F3KtSMpqEHcKmmDbqY9li2gvYPxRyNZ4WVr21dAoDQpt6CUjj15TkP8S23SepzE
         6j8g==
X-Forwarded-Encrypted: i=1; AJvYcCVfkrzP/1XIjKu7SHXSX2jut+1YgOmopp83p3U0tVRZI2ssZxyNU03dxEjJlAa+nszmMwg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6YxA4Hu2f62o7KmLUeH3nxalafq0hQjWVfrd01jjm9S7vU3d2
	kJ9gUBUc+srf5ozVTSKitEnIrny7iZhWJXFZB9fCaE9mYIC6tL3cv+6NnMeZSjJtFDnTcbpkzeN
	+2Q==
X-Received: from jajn1.prod.google.com ([2002:a05:6638:2101:b0:5ca:5a1e:2501])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:d858:0:b0:65f:cda0:ed8f
 with SMTP id 006d021491bc7-6610064cecbmr551777eaf.35.1768350619122; Tue, 13
 Jan 2026 16:30:19 -0800 (PST)
Date: Wed, 14 Jan 2026 00:30:15 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114003015.1386066-1-sagis@google.com>
Subject: [PATCH] KVM: TDX: Allow userspace to return errors to guest for MAPGPA
From: Sagi Shahar <sagis@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Vishal Annapurve <vannapurve@google.com>, Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Vishal Annapurve <vannapurve@google.com>

MAPGPA request from TDX VMs gets split into chunks by KVM using a loop
of userspace exits until the complete range is handled.

In some cases userspace VMM might decide to break the MAPGPA operation
and continue it later. For example: in the case of intrahost migration
userspace might decide to continue the MAPGPA operation after the
migrration is completed.

Allow userspace to signal to TDX guests that the MAPGPA operation should
be retried the next time the guest is scheduled.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb..3244064b1a04 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1189,7 +1189,13 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
 	if (vcpu->run->hypercall.ret) {
-		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		if (vcpu->run->hypercall.ret == -EBUSY)
+			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
+		else if (vcpu->run->hypercall.ret == -EINVAL)
+			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		else
+			return -EINVAL;
+
 		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
 		return 1;
 	}
-- 
2.52.0.457.g6b5491de43-goog


