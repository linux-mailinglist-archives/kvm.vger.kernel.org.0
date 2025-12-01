Return-Path: <kvm+bounces-65040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F24C992BD
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 22:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4205F3A51B4
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 21:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275AE283FDD;
	Mon,  1 Dec 2025 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C57hN5X/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9758D2773D9
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764624420; cv=none; b=W8yicJ50loJ9L5SZ4Z2fTH/6QX2Qy4lFmvg2XVXW+tesyCC9X7Ze9YwAJm76SMd+ZBv9x/cmL2qqQXXa4rEi1e00oxECr9HAbG39MF5BVwlrtcUdv68+Q3Nh9lugp7g0YUVrbBchXzG1RC7vKZ7LSdALziHxTHC/m6Itt21V3m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764624420; c=relaxed/simple;
	bh=8mLxC795XDeXvk7AKRtIomjBDkWhyEQnDZ+CSuHWqxQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kibx9B/FsSIQSTC/lT4vnGkBQMuTtABcFFf6sUNBzoz06JBtjXoosN83ijktbsRBdGnG4gjaauySVWG80aXXUfb5OznMNVFZCwq4Ed3MlxIbKwk+nPtI4ZIxfLFa1BV4BIQV7ETsulfyK81WnMAyRXjdBxLjiStc/OwW1j4B5EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C57hN5X/; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64174630bf9so4313942a12.1
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 13:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764624417; x=1765229217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cfRTWtcIaathUA2mgL41QBVM+XL6VT6UBdp0QiNZHSY=;
        b=C57hN5X/XUshqEZ7BREJUiY9l/NXDdxyE3X49c9134QVuejddYBUYJ2arnyFbGj5cp
         9iqejDjwJ13G16L4Jj5y9pl8431MlTeEzsjc7zjhBtH3nLYe33hwn1a+LBQkbz6GFBJZ
         ha11yZNwM4FhzaKcTMjlT0FuJoVNjhTATKZdfuOIRpCR0lKygUQjKTgJthXOuceGTI5N
         UgwlCIRpM7XsoLC2fmxy1fQOv/RMdpUmAoofrEjJg6yzbhZqH8YWHAT7nbmG1rGqcm7b
         XAzV5hg3KR0bLTpG1kNl30NjoXainVnf7lNIqZkux8EqQf7EmU2jHaNaDTG8ndht072q
         oIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764624417; x=1765229217;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfRTWtcIaathUA2mgL41QBVM+XL6VT6UBdp0QiNZHSY=;
        b=jaSg07klBKXA5r4qNAPll9c7hqaukietJsELWiytgCMNIWVqFDCexPWkjB5OuLa/yO
         j1DenGc+EgdQ2J7HM85JIjp9qbS5SPvCSmAVQrbyYzqNzvz4rQEOzZLVt+HQy7aEO2W0
         YL+Ia36zmLCMSAEVYYBdjxZpC5tbwO7Ly9NnkDWb5gpuy+oMpKUFWmnFkx09Ljqx7xe2
         5Gz5bPS+Mq4XNlDx/VEWb6jnSHwe5e+Eam2mQlqJzUgceAJ2+pcDIg5spoVm9Sp8NmBK
         ZKjuRYCUn8aojVBeVNZH8CH+vs971etjUDxrv92+Bj3DClYzR+u3vn0fCWYrnjQvfSyZ
         SKrA==
X-Gm-Message-State: AOJu0YwKiqPNgg+S6WGyvuQk7N0n0asP+UvuagtSh0F2IbUuexabYWWn
	HAAxlpLtWfr56AluiCKy/aemdlvPXxn1t/Q0N5X19IoCTet3S873lGOobrOiposlBlU+nQ4flRj
	sCPEt3T791ToRC3xC937V1CW+8UEE2tMduX5OaM7xBCh4ikfKVXZb17qZTutuFQRwvlg0gamDAI
	ybzWCAF0pqyfvl7J2kHCWHkDLW3JM=
X-Google-Smtp-Source: AGHT+IG6OTWqFbaWntwqBBvO6mL+v9FKNl0tgC0FGiL0/5Lod1u3ROGkbcUdu5tvSbLlEmMPZt/biMrlsA==
X-Received: from eda15.prod.google.com ([2002:a05:6402:a00f:b0:647:7a4d:7406])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:26c3:b0:643:6af2:2356
 with SMTP id 4fb4d7f45d1cf-645eb2aade8mr24700068a12.26.1764624416786; Mon, 01
 Dec 2025 13:26:56 -0800 (PST)
Date: Mon, 01 Dec 2025 21:26:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABEILmkC/3XMQQ6DIBCF4auYWZfGQWlIV71H40JhwElUGjCkj
 eHupe67/F/yvgMSRaYE9+aASJkTh62GvDRg5nHzJNjWBtlKhbJFkVZjjHC87BSF0tpah3LqlIJ 6eUVy/D6551B75rSH+Dn1jL/1D5RRoJh63WGPN6fH7uFD8AtdTVhhKKV8ATlMx72pAAAA
X-Change-Id: 20251201-smccc-filter-588ddf12b355
X-Mailer: b4 0.14.2
Message-ID: <20251201-smccc-filter-v2-1-03dab737a14d@google.com>
Subject: [PATCH v2] KVM: arm64: Prevent FWD_TO_USER of SMCCC to pKVM
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
the pKVM FID range.

Similarly, reserve the "Call UID Query" to ensure that a malicious host
can't mislead a protected guest into misusing the pKVM ABI, under the
premise that it would be interacting with a different hypervisor ABI, as
hypervisors share the same FID space.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
Changes in v2:
- Restricted the range to pKVM HVCs & the "Call UID Query"
- Updated docs & removed mention of KVM_VM_TYPE_ARM_PROTECTED
- Link to v1: https://lore.kernel.org/r/20251201-smccc-filter-v1-1-b4831416=
f8a3@google.com
---
 Documentation/virt/kvm/devices/vm.rst | 10 ++++++++++
 arch/arm64/kvm/hypercalls.c           | 29 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm=
/devices/vm.rst
index a4d39fa1b0834b090318250db3b670b0b3174259..28ab2629e7e8f166def6f9efd18=
e8408ab4a8e63 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -400,3 +400,13 @@ will reject attempts to define a filter for any portio=
n of these ranges:
         0x8000_0000 0x8000_FFFF
         0xC000_0000 0xC000_FFFF
         =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+
+Protected KVM (pKVM) handles some calls directly and will reject attempts =
to
+define a filter for a protected VM for any portion of these ranges:
+
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+        Start       End (inclusive)
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+        0x8600_FF01 0x8600_FF01
+        0xC600_0002 0xC600_003F
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 58c5fe7d757274d9079606fcc378485980c6c0f8..5329772f228d356322863a7150f=
fa40c25ea1ee2 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -135,6 +135,12 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vc=
pu, u32 func_id)
 						   ARM_SMCCC_SMC_64,		\
 						   0, ARM_SMCCC_FUNC_MASK)
=20
+#define SMC64_PKVM_RANGE_BEGIN	ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_I=
D
+#define SMC64_PKVM_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_64,		\
+						   ARM_SMCCC_OWNER_VENDOR_HYP,	\
+						   ARM_SMCCC_KVM_FUNC_PKVM_RESV_63)
+
 static int kvm_smccc_filter_insert_reserved(struct kvm *kvm)
 {
 	int r;
@@ -158,6 +164,29 @@ static int kvm_smccc_filter_insert_reserved(struct kvm=
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
+		r =3D mtree_insert(&kvm->arch.smccc_filter,
+				ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID,
+				xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
+				GFP_KERNEL_ACCOUNT);
+		if (r)
+			goto out_destroy;
+
+		r =3D mtree_insert_range(&kvm->arch.smccc_filter,
+				       SMC64_PKVM_RANGE_BEGIN,
+				       SMC64_PKVM_RANGE_END,
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


