Return-Path: <kvm+bounces-6841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0C983ADF3
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:05:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B55D7B2630C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 16:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E305C7CF19;
	Wed, 24 Jan 2024 16:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OqqLbO+H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBC57C097;
	Wed, 24 Jan 2024 16:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706112252; cv=none; b=DWrdmnGvxDZwbzRdl5o2dZmv4Dq1PxkwDVLCa0/sjtZDSDStZPIJhvQslTl6NasZTeeI+VPQ5o1b7vWiXMza4/hr7wKkW2PycS6DzRcwqdT13UagxDqa4HIdhbSdQci57LiAeWmU+bdCrXclbELKYN19uJl7/tLtu4XSpk8SUVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706112252; c=relaxed/simple;
	bh=8xVTevAapGS1MQ5rJveUXc7iD2ZRnvv/yXE6rpElJw4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Fl6dzRPRtqXNDaVeXr5lxTu0t88F4eXfJubmKSwaBUNF4WwFy+bnbFh45TrCDoxwn8vkg36m4Uy1gSw6pejWD+YrhBHn84Cex6s8ni8tcSEXeJbWsuMWKXsxwmxAgVR7H3Zsj6JUeyrFbTzRQGzM6joa+7afwIHvkJ1QUzHruX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OqqLbO+H; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6ddc162d8d5so263719b3a.1;
        Wed, 24 Jan 2024 08:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706112250; x=1706717050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JX7fJkqmjqtzDmgdDOKfImoORSlASa5dCAfyrxQaPEo=;
        b=OqqLbO+HUNisj1pJ5cVGc1uoQuxCKe8z9//k6+rJJuTP7why/qI8TEhVxveAtHeLGM
         /8kcIr5RG4uUv2o0Sz9uyS3VCbQoydaWGhOJ+W+gpirQX3mlUh5QzSjtqqA5AWkc86xc
         WYenXdTBV7OYExMWvZ1lieYKy6zP9E/TLGoVw5DOeQY12V/HyQ4PIz9Lu1Ct3TuLjxYZ
         3XFgB9FHcD6b6BJu4TQoVB1o3I7JP0KJHDzyymYSEvMon99RE0HxpOYwuX3J4nGc98KH
         qmmh16pOW9T+8IBQp/RVUi+x6WMITDyWQcgFmSlqdfl0ckXNO1cL6pH0iTL/VfAdchEB
         mT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706112250; x=1706717050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JX7fJkqmjqtzDmgdDOKfImoORSlASa5dCAfyrxQaPEo=;
        b=ih32MIUBpF8Wltxwo55ATuUljoihkUpUGjQ/0WboocLJGlBDw4VUEPDLhqimewyome
         SywofOMyH1y4/Ez4doArRfjUeC6SzlsbSkl31BfLLGV5CrqiPUjBnPmWCWSfb+FUCWD+
         3aByl42K8P9c1cZgpzLsHdYdl7imGwwJiZZZ9WG4UHDtJ2WiHeoTVILCTRLXrIx5v5bw
         HFSW3ANiqxVPmd5g8rdfPEKLiCiS9HSzlE8GUSMC3myyD97juEgYFIX+8bj8WLPi4QZF
         9JGqkBze0xVHv6f3qA/66SjN4PhM/wu+3Y/6MsTHEUtIfS6uWgVDFWMk/lb9btka0PgN
         Gp7g==
X-Gm-Message-State: AOJu0Yz8mi4YaegBcIO1fPUj0qltBGLzN6JFh/EZyi7VpqIuoRQbOx6P
	YaAsCkqSJbe2BlcY7+3w6HeOi1iu9cYXFwnn6wWDromcPHWkLht7
X-Google-Smtp-Source: AGHT+IG9X3BonDvOmbjNmyFp7OzLgofEsVIQOu7XOyvWeyqU+PgZpu8DhZFz5DwOkpYuEBB6a+fg/Q==
X-Received: by 2002:a05:6a00:a1e:b0:6da:938c:f77f with SMTP id p30-20020a056a000a1e00b006da938cf77fmr5939769pfh.52.1706112250067;
        Wed, 24 Jan 2024 08:04:10 -0800 (PST)
Received: from localhost.localdomain ([43.129.189.221])
        by smtp.gmail.com with ESMTPSA id n16-20020aa78a50000000b006cecaff9e29sm13973014pfa.128.2024.01.24.08.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 08:04:09 -0800 (PST)
From: Brilliant Hanabi <moehanabichan@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Brilliant Hanabi <moehanabichan@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Check irqchip mode before create PIT
Date: Thu, 25 Jan 2024 00:02:48 +0800
Message-Id: <20240124160248.3077-1-moehanabichan@gmail.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
support via KVM_CREATE_IRQCHIP.

Without this check, I can create PIT first and enable irqchip-split
then, which may cause the PIT invalid because of lacking of in-kernel
PIC to inject the interrupt.

Signed-off-by: Brilliant Hanabi <moehanabichan@gmail.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e23714e960..3edc8478310f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7016,6 +7016,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		r = -EEXIST;
 		if (kvm->arch.vpit)
 			goto create_pit_unlock;
+		if (!pic_in_kernel(kvm))
+			goto create_pit_unlock;
 		r = -ENOMEM;
 		kvm->arch.vpit = kvm_create_pit(kvm, u.pit_config.flags);
 		if (kvm->arch.vpit)
-- 
2.39.3


