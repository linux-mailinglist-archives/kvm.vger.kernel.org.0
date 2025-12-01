Return-Path: <kvm+bounces-65023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75ADCC98B29
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 19:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA6633A45D3
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 18:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF2933890A;
	Mon,  1 Dec 2025 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gEa8KddT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CEC338925
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764613200; cv=none; b=UDsxFJmS5qokeOYzLtSBUBSV3RF6UYbvhPPQdssccSx07LD866mTe8NIdLPT2w/Vy63p1r/rsnaFjiRgXwT24+E8xG1bko9p9+cSy2dOQaKUFNgfOPDX7rXhIaMuDp2IWG5dRgvw24ByuUR6UxBy5t8Q/+pKFA1XMCCOxJSLOAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764613200; c=relaxed/simple;
	bh=R4zb8QVEWFPgzNvZ5CPpwj0EBVH9ubdWaSW2XoDwoY0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OHD5RLh3qhJgaFlYou6+B0iRKvIaQVJJ1yh8Ebp7ve1m7pCgxFSXhrK/h5pk/2kegt47lk1DJT3CORM1D8J4XKib0EnrNUDkhZ/PpraB/VTbFrqRyXPhjeDqQFxl+hZwS9skeYl5d5TR+Cc4QAmkzmOlavx0Ncd0HiFQJqsHP8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gEa8KddT; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b70caafad59so436695966b.0
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 10:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764613197; x=1765217997; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R2ky1g7vqxE0dSxSYlDayHPkG662KZ7f5gS2hZCCGuQ=;
        b=gEa8KddTUkmX/DWdwx+KjhGa+x5kX46ytu6NtGMSD8XPi5gsiLEWscWckua0KU04NO
         MLX/HFSAEUgdssvqwr9I559AfXx/reuWJwdNwNdQEF8PZG/F5W1FcQoCa3ShpOkwM1my
         9i6O9qrqyQcfsuKzG2OrUmp6WviOsi1NTSIpPHjAW1FegYJC0RwcO8GLvq/JS4nC/PPL
         pFLeimN3PXDk/70f95lvaY/Ceqvq7mgopl3bTciYFbr3FRv1zKkgXYMXR5odI76vRUj+
         fDArLz5VhUOx7N4WCCFLFOhaj10mK0tI/gdUoYnytixE6u3Lx2Esm6WSDVat714Zpz9/
         ELUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764613197; x=1765217997;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2ky1g7vqxE0dSxSYlDayHPkG662KZ7f5gS2hZCCGuQ=;
        b=uq8jvJOkVvpAxt5BxL1ht/zzUdoJzRIa1rVVJqz7Kz0ogfYKgGu4PtXjHUUw7+94Yp
         iiQpg+2Mz6Xjf0ayrP+g03zQWcTlVeYrtDWh40U1SLtT9zlkR0R4oV309cMqENMIHVjH
         dl3HXDsVaRcLzILVrJvzSyq7N3vewN3yxbA9ksU1BDM1yKV1CpD5u67aEwr3oXFp2HB2
         20wYD6oe54O+FL18Y6/qyoGplZo5jVDqk0j3+yZZigkqzTuWCSEYrXFja1pR49bKcWkM
         HbTb1rfCEs/VVpViX2FeNWDl/MIomHV5IpRCx75EZJPpfcoHNiIpEPksUyCvuM8n+kO+
         B9Kw==
X-Gm-Message-State: AOJu0YyYdVP+9Ya7XJX8qtuyI5NisTq79UIVBItnun0QW/MBP5pZejWv
	5dblfGYvkbGitxJX/pe3OJDV3HfyZrHaQJjyo/suNyt5Xo5WBxR5+XeIbfy6eT8BUaIBb30Q11F
	xnc4uIkWUuzfurEID3NwYVEKHhGxx6UfdoQRXiv/vIDldN004EYIi40SvHXVJdfTQUgj1DKNWsN
	X8i9jWlDsNFLlEpaCmorzQYUDYMvc=
X-Google-Smtp-Source: AGHT+IG0rnfQOBcsGBc89nGQ7P5SqEhx394iLm0A9p+JH2UauaQ7PKGIBjoXKOQU6ONzPdt2vT+TuR01CA==
X-Received: from ejdcu3.prod.google.com ([2002:a17:906:ba83:b0:b73:2695:dbc5])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6d13:b0:b77:18a0:3c8b
 with SMTP id a640c23a62f3a-b7718a03cd2mr1308264966b.1.1764613196560; Mon, 01
 Dec 2025 10:19:56 -0800 (PST)
Date: Mon, 01 Dec 2025 18:19:52 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEjcLWkC/x3MQQqAIBBA0avIrBN0QpCuEi1KxxooC40IxLsnL
 d/i/wKZElOGQRRI9HDmMzboToDb5riSZN8MqNBoVFrmwzknA+83JWms9T5oXHpjoCVXosDvvxu nWj8ivT43XgAAAA==
X-Change-Id: 20251201-smccc-filter-588ddf12b355
X-Mailer: b4 0.14.2
Message-ID: <20251201-smccc-filter-v1-1-b4831416f8a3@google.com>
Subject: [PATCH] KVM: arm64: Prevent FWD_TO_USER of SMCCC to pKVM
From: "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	"=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

With protected VMs, forwarding guest HVC/SMCs happens at two interfaces:

     pKVM [EL2] <--> KVM [EL1] <--> VMM [EL0]

so it might be possible for EL0 to successfully register with EL1 to
handle guest SMCCC calls but never see the KVM_EXIT_HYPERCALL, even if
the calls are properly issued by the guest, due to EL2 handling them so
that (host) EL1 never gets a chance to exit to EL0.

Instead, avoid that confusing situation and make userspace fail early by
disallowing KVM_ARM_VM_SMCCC_FILTER-ing calls from protected guests in
the KVM FID range (which pKVM re-uses).

DEN0028 defines 65536 "Vendor Specific Hypervisor Service Calls":

- the first ARM_SMCCC_KVM_NUM_FUNCS (128) can be custom-defined
- the following 3 are currently standardized
- the rest is "reserved for future expansion"

so reserve them all, like commit 821d935c87bc ("KVM: arm64: Introduce
support for userspace SMCCC filtering") with the Arm Architecture Calls.

Alternatively, we could have only reserved the ARM_SMCCC_KVM_NUM_FUNCS
(or even a subset of it) and the "Call UID Query" but that would have
risked future conflicts between that uAPI and an extension of the SMCCC
or of the pKVM ABI.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 Documentation/virt/kvm/devices/vm.rst | 11 ++++++++++
 arch/arm64/kvm/hypercalls.c           | 39 +++++++++++++++++++++++++++++++=
++++
 2 files changed, 50 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm=
/devices/vm.rst
index a4d39fa1b0834b090318250db3b670b0b3174259..9ed4b7afe022023346d4835d33a=
901e557fc4765 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -400,3 +400,14 @@ will reject attempts to define a filter for any portio=
n of these ranges:
         0x8000_0000 0x8000_FFFF
         0xC000_0000 0xC000_FFFF
         =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+
+Protected KVM (pKVM) reserves the 'Vendor Specific Hypervisor Service Call=
s'
+range of function IDs and will reject attempts to define a filter for any
+portion of these ranges for a protected VM (``KVM_VM_TYPE_ARM_PROTECTED``)=
:
+
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+        Start       End (inclusive)
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+        0x8600_0000 0x8600_FFFF
+        0xC600_0000 0xC600_FFFF
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 58c5fe7d757274d9079606fcc378485980c6c0f8..5ddcdd70a6b280914048e7683da=
fb778d0f24658 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -135,6 +135,21 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vc=
pu, u32 func_id)
 						   ARM_SMCCC_SMC_64,		\
 						   0, ARM_SMCCC_FUNC_MASK)
=20
+#define SMC32_VHYP_RANGE_BEGIN	ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID
+#define SMC32_VHYP_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_32,		\
+						   ARM_SMCCC_OWNER_VENDOR_HYP,	\
+						   ARM_SMCCC_FUNC_MASK)
+
+#define SMC64_VHYP_RANGE_BEGIN	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_64,		\
+						   ARM_SMCCC_OWNER_VENDOR_HYP,	\
+						   0)
+#define SMC64_VHYP_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_64,		\
+						   ARM_SMCCC_OWNER_VENDOR_HYP,	\
+						   ARM_SMCCC_FUNC_MASK)
+
 static int kvm_smccc_filter_insert_reserved(struct kvm *kvm)
 {
 	int r;
@@ -158,6 +173,30 @@ static int kvm_smccc_filter_insert_reserved(struct kvm=
 *kvm)
 	if (r)
 		goto out_destroy;
=20
+	/*
+	 * Prevent userspace from registering to handle any SMCCC call in the
+	 * vendor hypervisor range for pVMs, avoiding the confusion of guest
+	 * calls seemingly not resulting in KVM_RUN exits because pKVM handles
+	 * them without ever returning to the host. This is NOT for security.
+	 */
+	if (kvm_vm_is_protected(kvm)) {
+		r =3D mtree_insert_range(&kvm->arch.smccc_filter,
+				       SMC32_VHYP_RANGE_BEGIN,
+				       SMC32_VHYP_RANGE_END,
+				       xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
+				       GFP_KERNEL_ACCOUNT);
+		if (r)
+			goto out_destroy;
+
+		r =3D mtree_insert_range(&kvm->arch.smccc_filter,
+				       SMC64_VHYP_RANGE_BEGIN,
+				       SMC64_VHYP_RANGE_END,
+				       xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
+				       GFP_KERNEL_ACCOUNT);
+		if (r)
+			goto out_destroy;
+	}
+
 	return 0;
 out_destroy:
 	mtree_destroy(&kvm->arch.smccc_filter);

---
base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
change-id: 20251201-smccc-filter-588ddf12b355

Best regards,
--=20
Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>


