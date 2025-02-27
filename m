Return-Path: <kvm+bounces-39638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5E2A48B7E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:26:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 812EB7A1EE5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 22:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC97727FE7F;
	Thu, 27 Feb 2025 22:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tUaPzjcW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1BF27291F
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 22:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695057; cv=none; b=mE2MfFiDAHJ8XXyHacQ9ww6igj82gzvNk5YjHpeTp6g3ZVeyvLzO4EQNBpKUIbnCS/E8plh+yXqLoRLlSeuRLnzXcFLiUxypMUZs2b+UVJOTB9vTD4ES9af3pDlgC4mzen3qOdQyRodLVy/MmKjLTJHaP3/qMdHBQn+bB9cw9Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695057; c=relaxed/simple;
	bh=zm2QaR360KIl6iSEbDz2zLo3X3lN7lh4lpL7RxCk81I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CnpLpxBtBiyc0MuVQTgwPmJveL1lCRlreR1ehH9cAyeLTMsMdRNj7+8HN5olJjwDQ9EQiuVfhGSkLfnXrJkD8HXc+YmGMqVpZtegvH637TiLST1BB+xfyM57/oKWb2SDiey7XClThN20DOlOK+jSCFjpz6lAedW1l30VyeIw+nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tUaPzjcW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220ff7d7b67so26920535ad.2
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740695055; x=1741299855; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0b+q4LTl32D7RG/ClIETiGyEI98jipo9UuVZ1dxYatM=;
        b=tUaPzjcWqgl2XhWRsI+XfcNA41k5CIfDP0i5RHMCaHBH8zxT82YAzF5I2C8Liq57ek
         9bZju1xT6lVnFeo7q+4dkRxrcs76b1QFxmY/edJv8OAjjUfhBnGnFtxj2JGJWabQABX/
         6dRmgsCWxtlD9GdEHJ3wvjMXCw9HjXaKDURNCJRIywN8p+Q5VZWUcwvYZfpnhsyovArQ
         RCDdhsvWG9lFMA+8nUEpUGyxxXqt5z3vexQjKFwmWGpk/RCwXLV+EIUJ6l9oztSD/e+b
         YK93z13N1GGYvg+EOuuje783GDKtkTRSStnodsgBdKcHZylEcpgkDI0iyaJlFu5+psue
         Pqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740695055; x=1741299855;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0b+q4LTl32D7RG/ClIETiGyEI98jipo9UuVZ1dxYatM=;
        b=fmxuwdoEprd1/SqWtTYBbb2bBaZ9v8e6O6i4fNieKJa/aXP4aU5ILR5ToXdAezv3Ov
         yGvKUEceOrq69Iyk43QuCFLb3/xbXDgzIUdx1CtAqgjpVBSNAH3F4MpXcfLlnBvgrL3y
         IKFBP6w/6i0vFVlFErxPJMHNpOhGtFDvBDfhkeurks0kpqJOgB0JdvR/iUbmhUdnpHeW
         lt18fNOm0Eu02GXPYuKanN3Ow6puUiACK26yEUv/K8EcHzBL23EdR8qvO+jsAf0VIe/H
         fVbolcKjGO7wLHldwaaadL6qkUGrnYwtaqPaIrxVYwQ1J78CPIDb2hlXOBVTC+/72OzZ
         GPOQ==
X-Gm-Message-State: AOJu0YyVcf4hANRd36YTUKuRJesTvmz95z+nRriGfXX+HA6/w/fyiQ+j
	EvjERw5FhZ5hIhWiIx4BMQGNUNkp/91isGLLFEktP3mTV88CJN6mHJVZgVdcrwuRulVcYZE3uKa
	HNQ==
X-Google-Smtp-Source: AGHT+IEVfhWJbCHzhv945nE23qQtlQGHQDAfLrpb39fV+tlQVN+EJ3Y0HE+Vr2OulijTWrxhfARiJuURpvQ=
X-Received: from pfld22.prod.google.com ([2002:a05:6a00:1996:b0:725:e4b6:901f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b53:b0:730:7970:1f8f
 with SMTP id d2e1a72fcca58-734ac376faamr1574376b3a.12.1740695055322; Thu, 27
 Feb 2025 14:24:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 27 Feb 2025 14:24:06 -0800
In-Reply-To: <20250227222411.3490595-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227222411.3490595-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227222411.3490595-2-seanjc@google.com>
Subject: [PATCH v3 1/6] KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Drop bits 5:2 from the guest's effective DEBUGCTL value, as AMD changed
the architectural behavior of the bits and broke backwards compatibility.
On CPUs without BusLockTrap (or at least, in APMs from before ~2023),
bits 5:2 controlled the behavior of external pins:

  Performance-Monitoring/Breakpoint Pin-Control (PBi)=E2=80=94Bits 5:2, rea=
d/write.
  Software uses thesebits to control the type of information reported by
  the four external performance-monitoring/breakpoint pins on the
  processor. When a PBi bit is cleared to 0, the corresponding external pin
  (BPi) reports performance-monitor information. When a PBi bit is set to
  1, the corresponding external pin (BPi) reports breakpoint information.

With the introduction of BusLockTrap, presumably to be compatible with
Intel CPUs, AMD redefined bit 2 to be BLCKDB:

  Bus Lock #DB Trap (BLCKDB)=E2=80=94Bit 2, read/write. Software sets this =
bit to
  enable generation of a #DB trap following successful execution of a bus
  lock when CPL is > 0.

and redefined bits 5:3 (and bit 6) as "6:3 Reserved MBZ".

Ideally, KVM would treat bits 5:2 as reserved.  Defer that change to a
feature cleanup to avoid breaking existing guest in LTS kernels.  For now,
drop the bits to retain backwards compatibility (of a sort).

Note, dropping bits 5:2 is still a guest-visible change, e.g. if the guest
is enabling LBRs *and* the legacy PBi bits, then the state of the PBi bits
is visible to the guest, whereas now the guest will always see '0'.

Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b8aa0f36850f..2280bd1d0863 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3165,6 +3165,18 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct=
 msr_data *msr)
 			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
 			break;
 		}
+
+		/*
+		 * AMD changed the architectural behavior of bits 5:2.  On CPUs
+		 * without BusLockTrap, bits 5:2 control "external pins", but
+		 * on CPUs that support BusLockDetect, bit 2 enables BusLockTrap
+		 * and bits 5:3 are reserved-to-zero.  Sadly, old KVM allowed
+		 * the guest to set bits 5:2 despite not actually virtualizing
+		 * Performance-Monitoring/Breakpoint external pins.  Drop bits
+		 * 5:2 for backwards compatibility.
+		 */
+		data &=3D ~GENMASK(5, 2);
+
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
=20
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5b159f017055..f573548b7b41 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -582,7 +582,7 @@ static inline bool is_vnmi_enabled(struct vcpu_svm *svm=
)
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
=20
-#define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
+#define DEBUGCTL_RESERVED_BITS (~(DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR))
=20
 extern bool dump_invalid_vmcb;
=20
--=20
2.48.1.711.g2feabab25a-goog


