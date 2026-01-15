Return-Path: <kvm+bounces-68264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4427BD291F5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 43B663083C7B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 22:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE1B3203B6;
	Thu, 15 Jan 2026 22:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LlEwYoMn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A14221DAE
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 22:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768517563; cv=none; b=TwdQTM/4mznPt9nRGj0Afj1tZu2j1eg0/NRot1WH1UyaiijpqsviNkAprKal6LZNWDdqV+7YB9soS25HoJBeP5jcau8HGkvWnj4DhMCuJETjImfoSX+x4rB+soHy4+PxlBJPy34lq1PBgQzfPzY+GLqh+pNyWD/Bliuf0o/YPTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768517563; c=relaxed/simple;
	bh=E+D/xWOr1s8GCE/Wqb9NdzI/sxSTWm/3fxHESTDH6c8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EnLRO1zRPxiTP3uI6i8INPOfMPD7LChwTwZeIuE4RAJWowcV3bfgRAjk2D4rm0J19K/eqlIOjEG/VjorXlq0bhNNWCKHkWbc9iQfKp8iRym6x+o0Im4Zj6Od4nSYkJL7N/pdN6J3FG3p/6w7YQnNrzfP4ot/VL56oRVmZLwgzVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LlEwYoMn; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-45c879592feso3046384b6e.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 14:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768517561; x=1769122361; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TRmKjaBXNK+AvtD0p9RP9J8FQ82ubxpDWL/utJgxLnI=;
        b=LlEwYoMnDMAE9vmARkr9Y5EDlNs0TpqSF3FByyYPMC5UWH0SIw4Krr6ow3PZOXN+S9
         yKaMh8oJjsxkVL3RpiP7QX8vLDZnpuPEWgsoVI+BYuJMHpQRGBrIMHrUk6vlcVD/QUGg
         f3Hw9XKi8rld2u5gQtJrHG3Ld+IqUo1N7jfZmvRbSzfEozA7Exo+eKXm+LjnME+egzb4
         4op7ZPsZ3CWeOo95WI2hDT922CWpkL1mDURZo0Et4QdK1qZLdR6+jfpvADv1B9r/QtDv
         ymQywLIrMIYBPRqy8mn0OUTi3w2T6MKHyAe01jFyQzAguoJxOt1TjN9nic1UMqw1jayJ
         CD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768517561; x=1769122361;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TRmKjaBXNK+AvtD0p9RP9J8FQ82ubxpDWL/utJgxLnI=;
        b=BXfVq2D28sMD5xOQOHgYYmhS0FmYNhca2PPPoLZZY1mWyptwWddGBwi14QzwwQIZKB
         tu5td06y8rzfWKUXaMGBZ0SjlYDCNNmwZh+LgcAqQNDLggv0WmsJ5a9UrKXoMPUteltX
         WEIXJzoU5FzLYNU7G/wcICrSFfVAZ9jtLjbgy9ZCnC7CTeowrvk5tcJ00U+hWFk9Xrxe
         EUamj3GmBiTfphOLE2I/67Q+2s4+0X1gOwVIFzpxAF1yv7deydKv6jDxGIOdmTeWjwyZ
         Eg1XFDzBc7Da4UarwVjCFvGpNavhgiJAQpA9djKSpHyVtZ2wUrc6lJ+Oj2WxSs4BwJRS
         9riA==
X-Forwarded-Encrypted: i=1; AJvYcCXLAZulgavQpX6Oyr4pWqQSWbfd/7vfmFqTABWMlJVyR32qdK3kf0d6eCnS2U3o6NjHo9U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO2bEaqH9VreUd/bFQqQmC2ELNw+h9UJBWEdDVNkFKioMP3JP/
	mRt040ItYyFmCFfLfwGRv5pHMjoHlMuB0OTWZJ0IedaeOQAoG2Dlh8n24keo9G4FZdTmIICtnlC
	Vcw==
X-Received: from oijr5.prod.google.com ([2002:a05:6808:aa5:b0:45c:7cc1:5636])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:1b1f:b0:45a:4189:d2cf
 with SMTP id 5614622812f47-45c9d70a437mr379132b6e.8.1768517560722; Thu, 15
 Jan 2026 14:52:40 -0800 (PST)
Date: Thu, 15 Jan 2026 22:52:37 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115225238.2837449-1-sagis@google.com>
Subject: [PATCH v2] KVM: TDX: Allow userspace to return errors to guest for MAPGPA
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
migration is completed.

Allow userspace to signal to TDX guests that the MAPGPA operation should
be retried the next time the guest is scheduled.

This is potentially a breaking change since if userspace sets
hypercall.ret to a value other than EBUSY or EINVAL an EINVAL error code
will be returned to userspace. As of now QEMU never sets hypercall.ret
to a non-zero value after handling KVM_EXIT_HYPERCALL so this change
should be safe.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb..9bd4ffbdfecf 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1189,7 +1189,13 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
 	if (vcpu->run->hypercall.ret) {
-		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		if (vcpu->run->hypercall.ret == EAGAIN)
+			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
+		else if (vcpu->run->hypercall.ret == EINVAL)
+			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		else
+			return -EINVAL;
+
 		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
 		return 1;
 	}
-- 
2.52.0.457.g6b5491de43-goog


